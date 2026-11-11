-- [[ Kotakbas Visual's (BEAUTIFUL UI V2) ]] --
-- LocalScript / Executor

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local isActive = true
local connections = {}
local function addConnection(conn) table.insert(connections, conn) end

-- ==========================================
-- 1. НАСТРОЙКИ
-- ==========================================
local settings = {
    Hat = false, Trail = false, Spin = false,
    HatColor1 = Color3.fromRGB(255, 50, 50),
    HatColor2 = Color3.fromRGB(150, 0, 0),
    AccentColor = Color3.fromRGB(255, 50, 50),
    HatTransparency = 0.34,
    SpinSpeed = 50,
    TrailColor = Color3.fromRGB(255, 50, 50),
    GradientSpeed = 1,
}
local objects = { hatPart = nil, trail = nil, trailAtt0 = nil, trailAtt1 = nil }
local time = 0

-- ==========================================
-- 2. ЛОГИКА
-- ==========================================
local function createHat()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    local old = char:FindFirstChild("KotakbasHat")
    if old then old:Destroy() end

    local cone = Instance.new("Part")
    cone.Name = "KotakbasHat"
    cone.Size = Vector3.new(1, 1, 1)
    cone.Material = Enum.Material.Neon
    cone.Transparency = settings.HatTransparency
    cone.CanCollide = false
    cone.Massless = true
    cone.Parent = char

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://1778999"
    mesh.Scale = Vector3.new(2.51, 0.83, 2.51) 
    mesh.Parent = cone

    local weld = Instance.new("Weld")
    weld.Part0 = head
    weld.Part1 = cone
    weld.C0 = CFrame.new(0, 0.85, 0) 
    weld.Parent = cone
    cone.CFrame = head.CFrame * weld.C0
    objects.hatPart = cone
end

local function removeHat()
    if objects.hatPart then objects.hatPart:Destroy() objects.hatPart = nil end
    local char = LocalPlayer.Character
    if char then
        local old = char:FindFirstChild("KotakbasHat")
        if old then old:Destroy() end
    end
end

local function initTrail()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if objects.trail then objects.trail:Destroy() end
    if objects.trailAtt0 then objects.trailAtt0:Destroy() end
    if objects.trailAtt1 then objects.trailAtt1:Destroy() end

    objects.trailAtt0 = Instance.new("Attachment")
    objects.trailAtt0.Position = Vector3.new(-1, 0, 0)
    objects.trailAtt0.Parent = hrp
    objects.trailAtt1 = Instance.new("Attachment")
    objects.trailAtt1.Position = Vector3.new(1, 0, 0)
    objects.trailAtt1.Parent = hrp

    local trail = Instance.new("Trail")
    trail.Attachment0 = objects.trailAtt0
    trail.Attachment1 = objects.trailAtt1
    trail.Lifetime = 1.5
    trail.FaceCamera = true
    trail.LightEmission = 1
    trail.Parent = hrp
    objects.trail = trail
end

local function removeTrail()
    if objects.trail then objects.trail:Destroy() objects.trail = nil end
    if objects.trailAtt0 then objects.trailAtt0:Destroy() end
    if objects.trailAtt1 then objects.trailAtt1:Destroy() end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if settings.Hat then createHat() end
    if settings.Trail then initTrail() end
end)

addConnection(RunService.RenderStepped:Connect(function(dt)
    if not isActive then return end
    time = time + dt * settings.GradientSpeed
    if objects.hatPart and objects.hatPart.Parent then
        local alpha = (math.sin(time) + 1) / 2
        objects.hatPart.Color = settings.HatColor1:Lerp(settings.HatColor2, alpha)
        objects.hatPart.Transparency = settings.HatTransparency
    end
    if settings.Trail and objects.trail then
        objects.trail.Color = ColorSequence.new(settings.TrailColor, settings.TrailColor)
    end
    if settings.Spin then
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(settings.SpinSpeed) * dt, 0)
            end
        end
    end
end))

-- ==========================================
-- 3. КРАСИВЫЙ GUI
-- ==========================================
local oldGui = PlayerGui:FindFirstChild("KotakbasMonsterGui")
if oldGui then oldGui:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "KotakbasMonsterGui"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.Parent = PlayerGui

-- Размытие фона (создаем при открытии)
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

-- Кнопка-Котик
local catBtn = Instance.new("ImageButton")
catBtn.Size = UDim2.new(0, 64, 0, 64)
catBtn.Position = UDim2.new(0.5, -32, 0.4, -32) 
catBtn.BackgroundTransparency = 1
catBtn.Image = "rbxassetid://88490182864491" 
catBtn.Parent = gui

local catCorner = Instance.new("UICorner")
catCorner.CornerRadius = UDim.new(0, 12)
catCorner.Parent = catBtn

local catStroke = Instance.new("UIStroke")
catStroke.Color = settings.AccentColor
catStroke.Thickness = 2
catStroke.Parent = catBtn

-- Главное Окно (Glassmorphism)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 550, 0, 420)
mainFrame.Position = UDim2.new(0.5, -275, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BackgroundTransparency = 0.15 -- Полупрозрачный
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = settings.AccentColor
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
titleBar.BackgroundTransparency = 0.2
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 16)
titleCorner.Parent = titleBar

-- "Заплатка" для ровного низа заголовка
local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 20)
titleFix.Position = UDim2.new(0, 0, 1, -20)
titleFix.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
titleFix.BackgroundTransparency = 0.2
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -20, 1, 0)
titleText.Position = UDim2.new(0, 20, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "KOTAKBAS VISUAL'S"
titleText.TextColor3 = settings.AccentColor
titleText.Font = Enum.Font.GothamBlack
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- Боковая панель
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 120, 1, -45)
sidebar.Position = UDim2.new(0, 0, 0, 45)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
sidebar.BackgroundTransparency = 0.3
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sidebarFix = Instance.new("Frame")
sidebarFix.Size = UDim2.new(0, 10, 0, 20)
sidebarFix.Position = UDim2.new(1, -10, 0, 0)
sidebarFix.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
sidebarFix.BackgroundTransparency = 0.3
sidebarFix.BorderSizePixel = 0
sidebarFix.Parent = sidebar

local tabList = Instance.new("Frame")
tabList.Size = UDim2.new(1, -10, 1, -10)
tabList.Position = UDim2.new(0, 5, 0, 5)
tabList.BackgroundTransparency = 1
tabList.Parent = sidebar

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 5)
tabLayout.Parent = tabList

local function createTabButton(name, iconId, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.BackgroundTransparency = 0.5
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Text = ""
    btn.LayoutOrder = order
    btn.Parent = tabList
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    local stroke = Instance.new("UIStroke")
    stroke.Color = settings.AccentColor
    stroke.Thickness = 0
    stroke.Transparency = 1
    stroke.Parent = btn

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.Position = UDim2.new(0, 10, 0.5, -10)
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ImageColor3 = Color3.fromRGB(200, 200, 200)
    icon.Parent = btn

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -40, 1, 0)
    text.Position = UDim2.new(0, 35, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = name
    text.TextColor3 = Color3.fromRGB(200, 200, 200)
    text.Font = Enum.Font.GothamMedium
    text.TextSize = 14
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Parent = btn

    return btn, stroke, icon, text
end

-- Иконки в стиле Rise
local btnVisuals, strokeVisuals, iconVisuals, textVisuals = createTabButton("Визуалы", "rbxassetid://6031094667", 1)
local btnMovement, strokeMovement, iconMovement, textMovement = createTabButton("Движение", "rbxassetid://6031090990", 2)
local btnStats, strokeStats, iconStats, textStats = createTabButton("Статистика", "rbxassetid://6031075938", 3)
local btnNicks, strokeNicks, iconNicks, textNicks = createTabButton("Ники", "rbxassetid://6031280882", 4)
local btnSettings, strokeSettings, iconSettings, textSettings = createTabButton("Настройки", "rbxassetid://6031280882", 5)

-- Контент
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -140, 1, -60)
contentArea.Position = UDim2.new(0, 130, 0, 55)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

local function createPage()
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = contentArea
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = page
    return page
end

local visualsPage = createPage()
local movementPage = createPage()
local statsPage = createPage()
local nicksPage = createPage()
local settingsPage = createPage()

-- ==========================================
-- 4. ЭЛЕМЕНТЫ (С ГРАДИЕНТОМ)
-- ==========================================
local function createToggle(parent, name, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 30)
    container.BackgroundTransparency = 1
    container.Parent = parent
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    local toggleBg = Instance.new("TextButton")
    toggleBg.Size = UDim2.new(0, 40, 0, 20)
    toggleBg.Position = UDim2.new(1, -40, 0.5, -10)
    toggleBg.BackgroundColor3 = default and settings.AccentColor or Color3.fromRGB(50, 50, 50)
    toggleBg.Text = ""
    toggleBg.Parent = container
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = toggleBg
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = toggleBg
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    local state = default
    toggleBg.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = state and settings.AccentColor or Color3.fromRGB(50, 50, 50)}):Play()
        if callback then callback(state) end
    end)
    return container
end

local function createSlider(parent, name, min, max, default, suffix, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = parent
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default .. (suffix or "")
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, 0, 0, 8)
    barBg.Position = UDim2.new(0, 0, 0, 30)
    barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    barBg.Parent = container
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = barBg
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = settings.AccentColor
    fill.Parent = barBg
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    local hitbox = Instance.new("TextButton")
    hitbox.Size = UDim2.new(1, 0, 1, 0)
    hitbox.BackgroundTransparency = 1
    hitbox.Text = ""
    hitbox.Parent = barBg
    local isDragging = false
    local function updateValue(mouseX)
        local relX = math.clamp((mouseX - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * relX)
        label.Text = name .. ": " .. value .. (suffix or "")
        TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new(relX, 0, 1, 0)}):Play()
        if callback then callback(value) end
    end
    hitbox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            updateValue(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateValue(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
    return container
end

local function createColorPicker(parent, name, defaultColor, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 30)
    container.BackgroundTransparency = 1
    container.Parent = parent
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 40, 0, 20)
    colorBtn.Position = UDim2.new(1, -40, 0.5, -10)
    colorBtn.BackgroundColor3 = defaultColor
    colorBtn.Text = ""
    colorBtn.Parent = container
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 4)
    cCorner.Parent = colorBtn
    colorBtn.MouseButton1Click:Connect(function()
        local newColor = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
        colorBtn.BackgroundColor3 = newColor
        if callback then callback(newColor) end
    end)
    return container
end

-- ==========================================
-- 5. СБОРКА ВКЛАДОК
-- ==========================================
createToggle(visualsPage, "Шапка китайца", settings.Hat, function(state)
    settings.Hat = state
    if state then createHat() else removeHat() end
end)
createToggle(visualsPage, "Trail (След)", settings.Trail, function(state)
    settings.Trail = state
    if state then initTrail() else removeTrail() end
end)

createToggle(movementPage, "Спин (Вращение)", settings.Spin, function(state) settings.Spin = state end)
createSlider(movementPage, "Скорость вращения", 1, 300, 50, "", function(value) settings.SpinSpeed = value end)

local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.new(1, 0, 0, 60)
statsLabel.BackgroundTransparency = 1
statsLabel.Text = "Всего запусков: 1\nТвои запуски: 1"
statsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statsLabel.Font = Enum.Font.GothamMedium
statsLabel.TextSize = 16
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.Parent = statsPage

local nicksLabel = Instance.new("TextLabel")
nicksLabel.Size = UDim2.new(1, 0, 1, 0)
nicksLabel.BackgroundTransparency = 1
nicksLabel.Text = "Твой ник: sasha666555s (XXNOXERXX)\nКорона 👑\n\nСиние люди = с скриптом."
nicksLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
nicksLabel.Font = Enum.Font.GothamMedium
nicksLabel.TextSize = 14
nicksLabel.TextXAlignment = Enum.TextXAlignment.Left
nicksLabel.Parent = nicksPage

createColorPicker(settingsPage, "Цвет акцента", settings.AccentColor, function(color) 
    settings.AccentColor = color
    mainStroke.Color = color
    catStroke.Color = color
    tabStroke.Color = color
end)
createColorPicker(settingsPage, "Цвет 1 (Шапка)", settings.HatColor1, function(color) settings.HatColor1 = color end)
createColorPicker(settingsPage, "Цвет 2 (Шапка)", settings.HatColor2, function(color) settings.HatColor2 = color end)
createSlider(settingsPage, "Скорость переливания", 0.1, 5, 1, "x", function(value) settings.GradientSpeed = value end)
createColorPicker(settingsPage, "Цвет Trail", settings.TrailColor, function(color) settings.TrailColor = color end)
createSlider(settingsPage, "Прозрачность шапки", 0, 100, 34, "%", function(value) settings.HatTransparency = value / 100 end)

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(1, 0, 0, 35)
stopBtn.BackgroundColor3 = Color3.fromRGB(150, 20, 20)
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.Text = "ПОЛНОСТЬЮ ОСТАНОВИТЬ СКРИПТ"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.Parent = settingsPage
local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 6)
stopCorner.Parent = stopBtn
stopBtn.MouseButton1Click:Connect(function()
    isActive = false
    for _, conn in ipairs(connections) do if conn then conn:Disconnect() end end
    removeHat()
    removeTrail()
    gui:Destroy()
    print("[KOTAKBAS]: Скрипт выгружен.")
end)

-- ==========================================
-- 6. ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК
-- ==========================================
local function setTab(tabName)
    visualsPage.Visible = tabName == "Visuals"
    movementPage.Visible = tabName == "Movement"
    statsPage.Visible = tabName == "Stats"
    nicksPage.Visible = tabName == "Nicks"
    settingsPage.Visible = tabName == "Settings"
    
    TweenService:Create(strokeVisuals, TweenInfo.new(0.2), {Thickness = tabName == "Visuals" and 2 or 0, Transparency = tabName == "Visuals" and 0 or 1}):Play()
    TweenService:Create(strokeMovement, TweenInfo.new(0.2), {Thickness = tabName == "Movement" and 2 or 0, Transparency = tabName == "Movement" and 0 or 1}):Play()
    TweenService:Create(strokeStats, TweenInfo.new(0.2), {Thickness = tabName == "Stats" and 2 or 0, Transparency = tabName == "Stats" and 0 or 1}):Play()
    TweenService:Create(strokeNicks, TweenInfo.new(0.2), {Thickness = tabName == "Nicks" and 2 or 0, Transparency = tabName == "Nicks" and 0 or 1}):Play()
    TweenService:Create(strokeSettings, TweenInfo.new(0.2), {Thickness = tabName == "Settings" and 2 or 0, Transparency = tabName == "Settings" and 0 or 1}):Play()

    -- Подсветка активной иконки
    iconVisuals.ImageColor3 = tabName == "Visuals" and settings.AccentColor or Color3.fromRGB(200,200,200)
    iconMovement.ImageColor3 = tabName == "Movement" and settings.AccentColor or Color3.fromRGB(200,200,200)
    iconStats.ImageColor3 = tabName == "Stats" and settings.AccentColor or Color3.fromRGB(200,200,200)
    iconNicks.ImageColor3 = tabName == "Nicks" and settings.AccentColor or Color3.fromRGB(200,200,200)
    iconSettings.ImageColor3 = tabName == "Settings" and settings.AccentColor or Color3.fromRGB(200,200,200)
end

btnVisuals.MouseButton1Click:Connect(function() setTab("Visuals") end)
btnMovement.MouseButton1Click:Connect(function() setTab("Movement") end)
btnStats.MouseButton1Click:Connect(function() setTab("Stats") end)
btnNicks.MouseButton1Click:Connect(function() setTab("Nicks") end)
btnSettings.MouseButton1Click:Connect(function() setTab("Settings") end)
setTab("Visuals")

-- ==========================================
-- 7. АНИМАЦИЯ ОКНА И РАЗМЫТИЕ
-- ==========================================
local isOpen = false
local openPos = UDim2.new(0.5, -275, 0.5, -210)
local closePos = UDim2.new(0.5, -275, 1.5, -210)
local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local blurTween = TweenInfo.new(1, Enum.EasingStyle.Linear)

local function toggleMenu()
    isOpen = not isOpen
    if isOpen then
        mainFrame.Visible = true
        mainFrame.Position = closePos
        TweenService:Create(mainFrame, tweenInfo, {Position = openPos}):Play()
        TweenService:Create(blur, blurTween, {Size = 15}):Play() -- Размытие
    else
        local tween = TweenService:Create(mainFrame, tweenInfo, {Position = closePos})
        tween:Play()
        TweenService:Create(blur, blurTween, {Size = 0}):Play()
        tween.Completed:Connect(function()
            if not isOpen then mainFrame.Visible = false end
        end)
    end
end

catBtn.MouseButton1Click:Connect(toggleMenu)
closeBtn.MouseButton1Click:Connect(toggleMenu)

-- ==========================================
-- 8. КАСТОМНЫЙ TAB (С КОРОНОЙ, БЕЗ РАЗМЫТИЯ)
-- ==========================================
pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false) end)

local tabGui = Instance.new("ScreenGui")
tabGui.Name = "KotakbasCustomTab"
tabGui.ResetOnSpawn = false
tabGui.IgnoreGuiInset = true
tabGui.Parent = PlayerGui

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(0, 300, 0.8, 0)
tabFrame.Position = UDim2.new(1, 0, 0.1, 0) 
tabFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
tabFrame.BackgroundTransparency = 0.15
tabFrame.BorderSizePixel = 0
tabFrame.Parent = tabGui

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 10)
tabCorner.Parent = tabFrame

local tabStroke = Instance.new("UIStroke")
tabStroke.Color = settings.AccentColor
tabStroke.Thickness = 2
tabStroke.Parent = tabFrame

local tabTitle = Instance.new("TextLabel")
tabTitle.Size = UDim2.new(1, 0, 0, 45)
tabTitle.BackgroundTransparency = 1
tabTitle.Text = "⭐ KOTAKBAS VISUAL'S ⭐"
tabTitle.TextColor3 = settings.AccentColor
tabTitle.Font = Enum.Font.GothamBold
tabTitle.TextSize = 18
tabTitle.Parent = tabFrame

local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.9, 0, 0, 2)
divider.Position = UDim2.new(0.05, 0, 0, 50)
divider.BackgroundColor3 = settings.AccentColor
divider.BorderSizePixel = 0
divider.Parent = tabFrame

local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, -20, 1, -70)
playerList.Position = UDim2.new(0, 10, 0, 60)
playerList.BackgroundTransparency = 1
playerList.BorderSizePixel = 0
playerList.ScrollBarThickness = 4
playerList.ScrollBarImageColor3 = settings.AccentColor
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.Parent = tabFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = playerList

local function updateCustomTab()
    for _, child in ipairs(playerList:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    local yOffset = 0
    for _, player in ipairs(Players:GetPlayers()) do
        local entry = Instance.new("Frame")
        entry.Size = UDim2.new(1, -10, 0, 35)
        entry.Position = UDim2.new(0, 5, 0, yOffset)
        entry.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        entry.BackgroundTransparency = 0.5
        entry.BorderSizePixel = 0
        entry.Parent = playerList

        local entryCorner
                local entryCorner = Instance.new("UICorner")
        entryCorner.CornerRadius = UDim.new(0, 6)
        entryCorner.Parent = entry

        -- Аватарка
        local avatar = Instance.new("ImageLabel")
        avatar.Size = UDim2.new(0, 25, 0, 25)
        avatar.Position = UDim2.new(0, 5, 0.5, -12)
        avatar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=48&h=48"
        avatar.Parent = entry
        local avCorner = Instance.new("UICorner")
        avCorner.CornerRadius = UDim.new(1, 0)
        avCorner.Parent = avatar

        -- Имя игрока
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -80, 1, 0)
        nameLabel.Position = UDim2.new(0, 38, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        nameLabel.Font = Enum.Font.GothamMedium
        nameLabel.TextSize = 14
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = entry

        -- Корона для себя
        if player == LocalPlayer then
            nameLabel.Text = player.Name .. " 👑"
            nameLabel.TextColor3 = settings.AccentColor
        end

        -- Отметка "с скриптом" (синий цвет)
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 10, 0, 10)
        dot.Position = UDim2.new(1, -20, 0.5, -5)
        dot.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
        dot.BorderSizePixel = 0
        dot.Parent = entry
        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(1, 0)
        dotCorner.Parent = dot

        yOffset = yOffset + 40
    end
    playerList.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

-- Обновление списка
updateCustomTab()
addConnection(Players.PlayerAdded:Connect(updateCustomTab))
addConnection(Players.PlayerRemoving:Connect(updateCustomTab))

-- ==========================================
-- 9. ОТКРЫТИЕ/ЗАКРЫТИЕ КАСТОМНОГО TAB ПО КЛАВИШЕ
-- ==========================================
tabFrame.Visible = false

addConnection(UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Tab then
        tabFrame.Visible = not tabFrame.Visible
        if tabFrame.Visible then
            updateCustomTab()
        end
    end
end))

-- ==========================================
-- 10. ПЕРЕТАСКИВАНИЕ ГЛАВНОГО ОКНА
-- ==========================================
local dragging = false
local dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

addConnection(UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end))

addConnection(UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end))

-- ==========================================
-- 11. ПЕРЕТАСКИВАНИЕ КНОПКИ-КОТИКА
-- ==========================================
local catDragging = false
local catDragStart, catStartPos
local catMoved = false

catBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        catDragging = true
        catMoved = false
        catDragStart = input.Position
        catStartPos = catBtn.Position
    end
end)

addConnection(UserInputService.InputChanged:Connect(function(input)
    if catDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - catDragStart
        if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
            catMoved = true
        end
        if catMoved then
            catBtn.Position = UDim2.new(
                catStartPos.X.Scale, catStartPos.X.Offset + delta.X,
                catStartPos.Y.Scale, catStartPos.Y.Offset + delta.Y
            )
        end
    end
end))

addConnection(UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        catDragging = false
    end
end))

-- ==========================================
-- 12. УВЕДОМЛЕНИЕ О ЗАГРУЗКЕ
-- ==========================================
local notify = Instance.new("TextLabel")
notify.Size = UDim2.new(0, 300, 0, 40)
notify.Position = UDim2.new(0.5, -150, 0, -50)
notify.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
notify.BackgroundTransparency = 0.1
notify.Text = "✅ KOTAKBAS VISUAL'S загружен!"
notify.TextColor3 = settings.AccentColor
notify.Font = Enum.Font.GothamBold
notify.TextSize = 16
notify.Parent = gui
local notifyCorner = Instance.new("UICorner")
notifyCorner.CornerRadius = UDim.new(0, 10)
notifyCorner.Parent = notify
local notifyStroke = Instance.new("UIStroke")
notifyStroke.Color = settings.AccentColor
notifyStroke.Thickness = 2
notifyStroke.Parent = notify

TweenService:Create(notify, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -150, 0, 20)}):Play()
task.delay(3, function()
    if notify and notify.Parent then
        TweenService:Create(notify, TweenInfo.new(0.4), {Position = UDim2.new(0.5, -150, 0, -50)}):Play()
        task.wait(0.5)
        notify:Destroy()
    end
end)

print("[KOTAKBAS]: BEAUTIFUL UI V2 успешно загружен! 🐱")
