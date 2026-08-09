local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local speedValue = 16
local jumpValue = 50
local flySpeedValue = 50
local isFlying = false
local isNoclip = false
local isFling = false
local isEsp = false
local flyConnection = nil
local noclipConnection = nil
local flingConnection = nil

player.CharacterAdded:Connect(function(char)
    character = char
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheatHubMenu"

local success, err = pcall(function()
    screenGui.Parent = CoreGui
end)

if not success then
    screenGui.Parent = player:WaitForChild("PlayerGui")
end

local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 80, 0, 30)
openButton.Position = UDim2.new(0, 10, 0, 10)
openButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.Text = "Открыть"
openButton.TextSize = 14
openButton.Font = Enum.Font.SourceSansBold
openButton.Visible = false
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 6)
openCorner.Parent = openButton

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 350)
mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.6, 0, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Text = "QrptyHub"
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.TextSize = 16
titleText.Font = Enum.Font.SourceSansBold
titleText.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 2)
closeButton.BackgroundTransparency = 1
closeButton.TextColor3 = Color3.fromRGB(255, 85, 85)
closeButton.Text = "X"
closeButton.TextSize = 18
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = titleBar

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 120, 1, -35)
sidebar.Position = UDim2.new(0, 0, 0, 35)
sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 8)
sideCorner.Parent = sidebar

local tabBtn = Instance.new("TextButton")
tabBtn.Size = UDim2.new(1, -10, 0, 35)
tabBtn.Position = UDim2.new(0, 5, 0, 10)
tabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tabBtn.Text = "Основные"
tabBtn.TextSize = 14
tabBtn.Font = Enum.Font.SourceSansBold
tabBtn.Parent = sidebar

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 6)
tabCorner.Parent = tabBtn

local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -135, 1, -50)
container.Position = UDim2.new(0, 130, 0, 45)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.ScrollBarThickness = 4
container.CanvasSize = UDim2.new(0, 0, 0, 500)
container.Parent = mainFrame

local function createSlider(name, min, max, default, pos, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = pos
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Text = name .. ": " .. default
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 14
    label.Font = Enum.Font.SourceSans
    label.Parent = container

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, -10, 0, 6)
    bg.Position = pos + UDim2.new(0, 0, 0, 22)
    bg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    bg.BorderSizePixel = 0
    bg.Parent = container

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 80, 200)
    fill.BorderSizePixel = 0
    fill.Parent = bg

    local function update(input)
        local posPercent = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(posPercent, 0, 1, 0)
        local value = math.floor(min + (max - min) * posPercent)
        label.Text = name .. ": " .. value
        callback(value)
    end

    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            update(input)
            local moveCon
            moveCon = UserInputService.InputChanged:Connect(function(changed)
                if changed.UserInputType == Enum.UserInputType.MouseMovement then
                    update(changed)
                end
            end)
            UserInputService.InputEnded:Connect(function(ended)
                if ended.UserInputType == Enum.UserInputType.MouseButton1 then
                    if moveCon then moveCon:Disconnect() end
                end
            end)
        end
    end)
end

local function createToggle(name, default, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = pos
    btn.BackgroundColor3 = default and Color3.fromRGB(40, 120, 60) or Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.TextSize = 14
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(40, 120, 60) or Color3.fromRGB(30, 30, 30)
        callback(state)
    end)
end

createSlider("Скорость бега", 16, 250, 16, UDim2.new(0, 0, 0, 10), function(val)
    speedValue = val
end)

createSlider("Высота прыжка", 50, 500, 50, UDim2.new(0, 0, 0, 50), function(val)
    jumpValue = val
end)

createSlider("Скорость полета", 10, 300, 50, UDim2.new(0, 0, 0, 90), function(val)
    flySpeedValue = val
end)

createToggle("Полет", false, UDim2.new(0, 0, 0, 140), function(state)
    isFlying = state
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if not root or not humanoid then return end

    if isFlying then
        humanoid.PlatformStand = true
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyBV"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = root

        local bg = Instance.new("BodyGyro")
        bg.Name = "FlyBG"
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = root.CFrame
        bg.Parent = root

        flyConnection = RunService.RenderStepped:Connect(function()
            local camera = workspace.CurrentCamera
            local moveDirection = Vector3.new(0, 0, 0)

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end

            bg.CFrame = camera.CFrame
            if moveDirection.Magnitude > 0 then
                bv.Velocity = moveDirection.Unit * flySpeedValue
            else
                bv.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        if flyConnection then flyConnection:Disconnect() flyConnection = nil end
        if root:FindFirstChild("FlyBV") then root.FlyBV:Destroy() end
        if root:FindFirstChild("FlyBG") then root.FlyBG:Destroy() end
        humanoid.PlatformStand = false
    end
end)

createToggle("Noclip (Сквозь стены)", false, UDim2.new(0, 0, 0, 180), function(state)
    isNoclip = state
    if isNoclip then
        noclipConnection = RunService.Stepped:Connect(function()
            if not isNoclip or not character then return end
            for _, part in ipairs(character:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    end
end)

createToggle("Fling (Толкать всех)", false, UDim2.new(0, 0, 0, 220), function(state)
    isFling = state
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if isFling and root then
        flingConnection = RunService.Heartbeat:Connect(function()
            if not isFling or not root then return end
root.Velocity = Vector3.new(9999, 9999, 9999)
            RunService.RenderStepped:Wait()
        end)
    elseif flingConnection then 
        flingConnection:Disconnect() 
        flingConnection = nil 
    end
end)

local function applyESP(otherPlayer)
    if otherPlayer == player then return end
    local function addHighlight(char)
        if char:FindFirstChild("HubESP") then return end
        local hl = Instance.new("Highlight")
        hl.Name = "HubESP"
        hl.FillColor = Color3.fromRGB(100, 80, 200)
        hl.FillTransparency = 0.5
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.Enabled = isEsp
        hl.Parent = char
    end
    if otherPlayer.Character then addHighlight(otherPlayer.Character) end
    otherPlayer.CharacterAdded:Connect(addHighlight)
end

for _, p in ipairs(Players:GetPlayers()) do applyESP(p) end
Players.PlayerAdded:Connect(applyESP)

createToggle("ESP (Подсветка игроков)", false, UDim2.new(0, 0, 0, 260), function(state)
    isEsp = state
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HubESP") then
            p.Character.HubESP.Enabled = isEsp
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and not isFlying then
        humanoid.WalkSpeed = speedValue
        humanoid.JumpPower = jumpValue
    end
end)

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openButton.Visible = true
end)

openButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openButton.Visible = false
end)
local isSpin = false
local isSpinNoclip = false
local spinSpeedValue = 100
local spinConnection = nil
local spinNoclipConnection = nil

local extraLabel = Instance.new("TextLabel")
extraLabel.Size = UDim2.new(1, -10, 0, 25)
extraLabel.Position = UDim2.new(0, 0, 0, 305)
extraLabel.BackgroundTransparency = 1
extraLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
extraLabel.Text = "Дополнительное"
extraLabel.TextXAlignment = Enum.TextXAlignment.Left
extraLabel.TextSize = 14
extraLabel.Font = Enum.Font.SourceSansBold
extraLabel.Parent = container

createSlider("Скорость вращения", 0, 9999, 100, UDim2.new(0, 0, 0, 340), function(val)
    spinSpeedValue = val
end)

createToggle("Включить Spin", false, UDim2.new(0, 0, 0, 380), function(state)
    isSpin = state
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if isSpin and root then
        spinConnection = RunService.Heartbeat:Connect(function()
            if not isSpin or not root then return end
            root.RotVelocity = Vector3.new(0, spinSpeedValue, 0)
        end)
    else
        if spinConnection then spinConnection:Disconnect() spinConnection = nil end
        if root then root.RotVelocity = Vector3.new(0, 0, 0) end
    end
end)

createToggle("Spin + Noclip", false, UDim2.new(0, 0, 0, 420), function(state)
    isSpinNoclip = state
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if isSpinNoclip and root then
        spinNoclipConnection = RunService.Heartbeat:Connect(function()
            if not isSpinNoclip or not root then return end
            root.RotVelocity = Vector3.new(0, spinSpeedValue, 0)
            if character then
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        if spinNoclipConnection then spinNoclipConnection:Disconnect() spinNoclipConnection = nil end
        if root then root.RotVelocity = Vector3.new(0, 0, 0) end
    end
end)
