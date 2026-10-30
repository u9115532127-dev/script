-- [[ Nursultan Visual's ]] --
-- LocalScript / Executor

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- 1. ЗАГРУЗКА Nursultan Visual's
-- ==========================================
local Rayfield = nil
local Window = nil
local SettingsTab = nil
local FunTab = nil

local success, err = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    Window = Rayfield:CreateWindow({
       Name = "Nursultan Visual's",
       LoadingTitle = "Загрузка...",
       LoadingSubtitle = "Только для тебя",
       ConfigurationSaving = { Enabled = false },
       KeySystem = false
    })
end)

if not success then
    warn("[NURSULTAN VISUAL'S]: Не удалось загрузить Rayfield UI. Ошибка: " .. tostring(err))
end

-- ==========================================
-- 2. НАСТРОЙКИ
-- ==========================================
local color1 = Color3.fromHex("#80FFD4") 
local color2 = Color3.fromHex("#40D4A0")
local gradientSpeed = 1
local hatTransparency = 0.34
local hatParts = nil
local time = 0
local isActive = true

-- Настройки Spin
local isSpinning = false
local spinSpeed = 15

-- Настройки Следа
local isTrailEnabled = false
local trailColorMode = "Rainbow"
local customTrailColor = Color3.fromRGB(255, 0, 0)
local trailLifetime = 0.5
local trailFolder = nil
local trailPool = {}
local trailIndex = 1
local lastTrailPos = nil

local connections = {}
local function addConnection(conn)
    table.insert(connections, conn)
end

-- ==========================================
-- 3. ШЛЯПА
-- ==========================================
local function setTransparencySmooth(part, targetTransparency)
    if not part or not part.Parent then return end
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(part, tweenInfo, { Transparency = targetTransparency })
    tween:Play()
end

local function updateAllTransparency(targetTransparency)
    if hatParts and hatParts.hat then
        setTransparencySmooth(hatParts.hat, targetTransparency)
    end
end

local function createHat()
    if not isActive then return end
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    
    for _, name in ipairs({"ChineseHat", "ChineseHatBrim"}) do
        local old = char:FindFirstChild(name)
        if old then old:Destroy() end
    end

    local cone = Instance.new("Part")
    cone.Name = "ChineseHat"
    cone.Size = Vector3.new(1, 1, 1)
    cone.Material = Enum.Material.Neon
    cone.Transparency = hatTransparency
    cone.CanCollide = false
    cone.CanTouch = false
    cone.CanQuery = false
    cone.Massless = true
    cone.Parent = char

    local mesh1 = Instance.new("SpecialMesh")
    mesh1.MeshType = Enum.MeshType.FileMesh
    mesh1.MeshId = "rbxassetid://1778999"
    mesh1.Scale = Vector3.new(2.51, 0.83, 2.51) 
    mesh1.Parent = cone

    local weld1 = Instance.new("Weld")
    weld1.Part0 = head
    weld1.Part1 = cone
    weld1.C0 = CFrame.new(0, 0.85, 0) 
    weld1.Parent = cone
    cone.CFrame = head.CFrame * weld1.C0

    return {hat = cone}
end

local function safeUpdateHat()
    if not isActive then return end
    local ok, result = pcall(createHat)
    if ok then
        hatParts = result
    end
end

addConnection(LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    safeUpdateHat()
end))

if LocalPlayer.Character then safeUpdateHat() end

-- ==========================================
-- 4. SPIN
-- ==========================================
local function updateSpinState()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = not isSpinning
    end
end

-- ==========================================
-- 5. СЛЕД
-- ==========================================
local function initTrailPool()
    if trailFolder and trailFolder.Parent then return end
    
    trailFolder = workspace:FindFirstChild("LocalTrailFolder")
    if not trailFolder then
        trailFolder = Instance.new("Folder")
        trailFolder.Name = "LocalTrailFolder"
        trailFolder.Parent = workspace
    end

    for _, child in ipairs(trailFolder:GetChildren()) do
        child:Destroy()
    end
    trailPool = {}

    for i = 1, 50 do
        local part = Instance.new("Part")
        part.Name = "TrailPart"
        part.Size = Vector3.new(0.8, 0.8, 0.8)
        part.Material = Enum.Material.Neon
        part.CanCollide = false
        part.CanTouch = false
        part.CanQuery = false
        part.Anchored = true
        part.Transparency = 1
        part.Parent = trailFolder
        table.insert(trailPool, part)
    end
end

local function spawnTrailPart(pos, color)
    if #trailPool == 0 then return end
    local part = trailPool[trailIndex]
    trailIndex = (trailIndex % #trailPool) + 1

    part.CFrame = CFrame.new(pos)
    part.Color = color
    part.Transparency = 0.2
    part.Size = Vector3.new(0.8, 0.8, 0.8)

    local tweenInfo = TweenInfo.new(trailLifetime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(part, tweenInfo, { Transparency = 1, Size = Vector3.new(0, 0, 0) })
    tween:Play()
end

-- ==========================================
-- 6. ГЛАВНЫЙ ЦИКЛ
-- ==========================================
addConnection(RunService.RenderStepped:Connect(function(dt)
    if not isActive then return end
    
    -- 1. Переливание шляпы
    time = time + dt * gradientSpeed
    if hatParts and hatParts.hat and hatParts.hat.Parent then
        local alpha = (math.sin(time) + 1) / 2 
        hatParts.hat.Color = color1:Lerp(color2, alpha)
    end

    -- 2. Вращение Spin
    if isSpinning then
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local rotationAmount = math.rad(spinSpeed * 10) * dt
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, rotationAmount, 0)
            end
        end
    end

    -- 3. След
    if isTrailEnabled then
        if not trailFolder or not trailFolder.Parent then initTrailPool() end
        
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local currentPos = hrp.Position
                if not lastTrailPos or (currentPos - lastTrailPos).Magnitude > 1.5 then
                    lastTrailPos = currentPos
                    
                    local finalColor = customTrailColor
                    if trailColorMode == "Rainbow" then
                        local hue = (time * 0.5) % 1
                        finalColor = Color3.fromHSV(hue, 1, 1)
                    end
                    spawnTrailPart(currentPos - Vector3.new(0, 2.5, 0), finalColor)
                end
            end
        end
    end
end))

-- ==========================================
-- 7. МЕНЮ НАСТРОЕК
-- ==========================================
if Window then
    SettingsTab = Window:CreateTab("Настройки", 4483362458)

    SettingsTab:CreateColorPicker({ Name = "Цвет 1", Color = color1, Callback = function(value) color1 = value end })
    SettingsTab:CreateColorPicker({ Name = "Цвет 2", Color = color2, Callback = function(value) color2 = value end })
    SettingsTab:CreateSlider({ Name = "Скорость переливания", Range = {0.1, 5}, Increment = 0.1, Suffix = "x", CurrentValue = 1, Callback = function(value) gradientSpeed = value end })
    SettingsTab:CreateSlider({ Name = "Прозрачность шляпы (%)", Range = {0, 100}, Increment = 1, Suffix = "%", CurrentValue = 34, Callback = function(value) hatTransparency = value / 100; updateAllTransparency(hatTransparency) end })
    SettingsTab:CreateButton({ Name = "Пересоздать шляпу", Callback = function() safeUpdateHat() end })

    FunTab = Window:CreateTab("Безделушки", 4483362458)

    FunTab:CreateToggle({ Name = "Spin (Вращение)", CurrentValue = false, Flag = "SpinToggle", Callback = function(state) isSpinning = state; updateSpinState() end })
    FunTab:CreateSlider({ Name = "Скорость вращения", Range = {1, 100}, Increment = 1, Suffix = "x", CurrentValue = 15, Flag = "SpinSpeed", Callback = function(value) spinSpeed = value end })
    FunTab:CreateDivider()

    FunTab:CreateToggle({ Name = "Радужный след", CurrentValue = false, Flag = "TrailToggle", Callback = function(state) 
        isTrailEnabled = state 
        if state then initTrailPool() end
    end })
    FunTab:CreateDropdown({ Name = "Режим цвета следа", Options = {"Радужный", "Свой цвет"}, CurrentOption = {"Радужный"}, Flag = "TrailMode", Callback = function(option) if option == "Радужный" then trailColorMode = "Rainbow" else trailColorMode = "Custom" end end })
    FunTab:CreateColorPicker({ Name = "Цвет следа", Color = customTrailColor, Flag = "TrailColor", Callback = function(value) customTrailColor = value end })
    
    -- ИЗМЕНЕНИЕ: Длительность следа до 10
    FunTab:CreateSlider({ Name = "Длительность следа", Range = {0.1, 10}, Increment = 0.1, Suffix = "сек", CurrentValue = 0.5, Flag = "TrailLife", Callback = function(value) trailLifetime = value end })

    SettingsTab:CreateButton({
        Name = "⛔ ПОЛНОСТЬЮ ОСТАНОВИТЬ СКРИПТ",
        Callback = function()
            isActive = false
            isSpinning = false
            isTrailEnabled = false

            for _, conn in ipairs(connections) do
                if conn and conn.Disconnect then pcall(conn.Disconnect, conn) end
            end
            connections = {}
            
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then 
                    hum.AutoRotate = true 
                end
            end
            
            if hatParts and hatParts.hat and hatParts.hat.Parent then hatParts.hat:Destroy() end
            hatParts = nil
            
            if trailFolder then trailFolder:Destroy() end
            trailPool = {}
            
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                local toggleGui = playerGui:FindFirstChild("HatToggleGui")
                if toggleGui then toggleGui:Destroy() end
                local gearGui = playerGui:FindFirstChild("GearGui")
                if gearGui then gearGui:Destroy() end
            end

            if Rayfield and Rayfield.Destroy then pcall(function() Rayfield:Destroy() end) end
            if playerGui then
                local rayfieldGui = playerGui:FindFirstChild("Rayfield")
                if rayfieldGui then rayfieldGui:Destroy() end
            end
            print("[NURSULTAN VISUAL'S]: Скрипт ПОЛНОСТЬЮ остановлен.")
        end
    })
end

-- ==========================================
-- 8. ШЕСТЕРЕНКА И КНОПКА
-- ==========================================
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local oldGear = playerGui:FindFirstChild("GearGui")
if oldGear then oldGear:Destroy() end

local gearGui = Instance.new("ScreenGui")
gearGui.Name = "GearGui"
gearGui.ResetOnSpawn = false
gearGui.Parent = playerGui

local gearBtn = Instance.new("ImageButton")
gearBtn.Name = "GearButton"
gearBtn.Size = UDim2.new(0, 24, 0, 24)
gearBtn.BackgroundTransparency = 1
gearBtn.Image = "rbxassetid://6031280882"
gearBtn.ImageColor3 = Color3.fromRGB(200, 200, 200)
gearBtn.Parent = gearGui

task.spawn(function()
    local rayfieldGui = playerGui:WaitForChild("Rayfield", 5)
    if not rayfieldGui then return end
    local main = rayfieldGui:WaitForChild("Main", 5)
    if not main then return end

    local function updateGearPos()
        if not main.Visible then
            gearBtn.Visible = false
            return
        end
        gearBtn.Visible = true
        gearBtn.Position = UDim2.new(main.Position.X.Scale, main.Position.X.Offset + main.AbsoluteSize.X - 55, 
                                     main.Position.Y.Scale, main.Position.Y.Offset + 10)
    end

    RunService.RenderStepped:Connect(updateGearPos)
end)

gearBtn.MouseButton1Click:Connect(function()
    if not isActive or not Window then return end
    if Rayfield.Toggle then Rayfield:Toggle(true) end
    if SettingsTab then
        if SettingsTab.SelectTab then SettingsTab:SelectTab() end
    end
end)

local oldGui = playerGui:FindFirstChild("HatToggleGui")
if oldGui then oldGui:Destroy() end

local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "HatToggleGui"
toggleGui.ResetOnSpawn = false
toggleGui.Parent = playerGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Size = UDim2.new(0, 120, 0, 40)
toggleBtn.Position = UDim2.new(0.5, -60, 0, 20)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Text = "Закрыть меню"
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 14
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = toggleGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = toggleBtn

local dragging = false
local dragStart, startPos

addConnection(toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = toggleBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end))

addConnection(UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        toggleBtn.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end))

local menuOpen = true
local function toggleMenu()
    if not isActive then return end
    menuOpen = not menuOpen
    if menuOpen then
        if Rayfield.Toggle then Rayfield:Toggle(true) end
        toggleBtn.Text = "Закрыть меню"
    else
        if Rayfield.Toggle then Rayfield:Toggle(false) end
        toggleBtn.Text = "Открыть меню"
    end
end

addConnection(toggleBtn.MouseButton1Click:Connect(toggleMenu))

Rayfield:Notify({
   Title = "Nursultan Visual's",
   Content = "Скрипт успешно загружен!",
   Duration = 5,
   Image = 4483362458
})

print("[NURSULTAN VISUAL'S]: Загружено!")
