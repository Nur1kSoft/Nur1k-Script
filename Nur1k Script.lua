-- Полный UI-скрипт с Spinner [V] выше Close UI и рабочим таймером (Исправлен Spinner)
local Services = setmetatable({}, {
    __index = function(self, key)
        local Service = game:GetService(key)
        rawset(self, key, Service)
        return Service
    end
})

local TweenService = Services.TweenService
local Players = Services.Players
local RunService = Services.RunService
local UserInputService = Services.UserInputService
local LocalPlayer = Players.LocalPlayer
local Workspace = Services.Workspace

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "IceHubModernUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui() or game:GetService("CoreGui"))

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, 320)
mainFrame.AnchorPoint = Vector2.new(1, 1)
mainFrame.Position = UDim2.new(1, -20, 1, -20)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0, 200, 255)
mainStroke.Thickness = 2
mainStroke.Transparency = 0.2
mainStroke.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -10, 0, 30)
titleLabel.Position = UDim2.new(0, 10, 0, 6)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Nur1k"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local titleLine = Instance.new("Frame")
titleLine.Size = UDim2.new(1, -20, 0, 2)
titleLine.Position = UDim2.new(0, 10, 0, 36)
titleLine.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
titleLine.BorderSizePixel = 0
titleLine.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 120, 0, 14)
statusLabel.Position = UDim2.new(1, -140, 0, 8)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Anti-AFK on"
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextSize = 12
statusLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
statusLabel.TextXAlignment = Enum.TextXAlignment.Right
statusLabel.Parent = mainFrame

local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, -10, 1, -80)
buttonContainer.Position = UDim2.new(0, 5, 0, 45)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = buttonContainer

local function createButton(name, icon)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 36)
    button.Text = icon .. " " .. name
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    button.AutoButtonColor = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 200, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.7
    stroke.Parent = button

    button.Parent = buttonContainer

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(35, 35, 40) }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.1), { Transparency = 0.5 }):Play()
    end)

    button.MouseLeave:Connect(function()
        if button.BackgroundColor3 == Color3.fromRGB(0, 150, 75) then return end
        TweenService:Create(button, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(25, 25, 30) }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.1), { Transparency = 0.7 }):Play()
    end)

    return button, stroke
end

-- Создаём кнопки (Spinner выше Close UI)
local speedButton, speedStroke = createButton("Speed Boost (x1.5) [Q]", "⚡")
local floorButton, floorStroke = createButton("3rd Floor Glitch [C]", "🏢")
local espButton, espStroke = createButton("ESP Players [P]", "👁️")
local spinnerButton, spinnerStroke = createButton("Spinner [V]", "🔄")
local closeButton, closeStroke = createButton("Close UI [B]", "🗑")

-- Цвета
local ACTIVE_COLOR = Color3.fromRGB(0, 150, 75)
local INACTIVE_COLOR = Color3.fromRGB(25, 25, 30)
local STROKE_COLOR = Color3.fromRGB(0, 200, 255)

local function toggleButtonState(button, stroke, isActive)
    if isActive then
        button.BackgroundColor3 = ACTIVE_COLOR
        stroke.Color = ACTIVE_COLOR
        stroke.Transparency = 0.3
    else
        button.BackgroundColor3 = INACTIVE_COLOR
        stroke.Color = STROKE_COLOR
        stroke.Transparency = 0.7
    end
end

local externalKeybinds = {}

local function RegisterKeybind(keyCode, callback)
    if keyCode and callback then externalKeybinds[keyCode] = callback end
end

local function UnregisterKeybind(keyCode)
    externalKeybinds[keyCode] = nil
end

-- ===============================
-- SPEED BOOST
-- ===============================
do
    local speedConn
    local baseSpeed = 24
    local active = false

    local function GetCharacter()
        local Char = LocalPlayer.Character
        local HRP = Char and Char:FindFirstChild("HumanoidRootPart")
        local Hum = Char and Char:FindFirstChildOfClass("Humanoid")
        return Char, HRP, Hum
    end

    local function startSpeedControl()
        if speedConn then return end
        speedConn = RunService.Heartbeat:Connect(function()
            local Char, HRP, Hum = GetCharacter()
            if not Char or not HRP or not Hum then return end
            local moveVector = Hum.MoveDirection
            if moveVector.Magnitude > 0.1 then
                local dir = Vector3.new(moveVector.X, 0, moveVector.Z).Unit
                HRP.AssemblyLinearVelocity = Vector3.new(dir.X * baseSpeed, HRP.AssemblyLinearVelocity.Y, dir.Z * baseSpeed)
            end
        end)
    end

    local function stopSpeedControl()
        if speedConn then speedConn:Disconnect(); speedConn = nil end
    end

    local function toggleSpeed()
        active = not active
        toggleButtonState(speedButton, speedStroke, active)
        if active then startSpeedControl() else stopSpeedControl() end
    end

    speedButton.MouseButton1Click:Connect(toggleSpeed)
    RegisterKeybind(Enum.KeyCode.Q, toggleSpeed)
end

-- ===============================
-- 3RD FLOOR GLITCH
-- ===============================
do
    local active = false
    local platform, conn
    local RISE_SPEED = 15

    local function destroyPlatform()
        if platform then platform:Destroy(); platform = nil end
        if conn then conn:Disconnect(); conn = nil end
    end

    local function createPlatform()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        destroyPlatform()
        platform = Instance.new("Part")
        platform.Size = Vector3.new(6, 0.5, 6)
        platform.Anchored = true
        platform.Color = Color3.fromRGB(100, 200, 255)
        platform.Material = Enum.Material.Neon
        platform.Position = root.Position - Vector3.new(0, 4, 0)
        platform.Parent = Workspace

        local function canRise()
            local origin = platform.Position + Vector3.new(0, 1, 0)
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {platform, LocalPlayer.Character}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            return not Workspace:Raycast(origin, Vector3.new(0, 3, 0), rayParams)
        end

        conn = RunService.Heartbeat:Connect(function(dt)
            if platform and active and root then
                local pos = platform.Position
                local newPos = Vector3.new(root.Position.X, pos.Y, root.Position.Z)
                if canRise() then
                    platform.Position = newPos + Vector3.new(0, RISE_SPEED * dt, 0)
                else
                    platform.Position = newPos
                end
            end
        end)
    end

    local function toggleFloorGlitch()
        active = not active
        toggleButtonState(floorButton, floorStroke, active)
        if active then createPlatform() else destroyPlatform() end
    end

    floorButton.MouseButton1Click:Connect(toggleFloorGlitch)
    RegisterKeybind(Enum.KeyCode.C, toggleFloorGlitch)
end

-- ===============================
-- ESP
-- ===============================
do
    local ESP_CONTAINER = {}
    local espActive = false
    local MAX_DISTANCE = 200
    local ESP_COLOR = Color3.fromRGB(0, 200, 255)
    local espConnection

    local function clearESP(player)
        if ESP_CONTAINER[player] then
            for _, v in pairs(ESP_CONTAINER[player]) do
                if v and v.Parent then v:Destroy() end
            end
            ESP_CONTAINER[player] = nil
        end
    end

    local function createESP(player)
        if not player.Character then return end
        clearESP(player)
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local highlight = Instance.new("Highlight")
        highlight.Adornee = player.Character
        highlight.FillColor = ESP_COLOR
        highlight.FillTransparency = 0.85
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0.2
        highlight.Parent = player.Character
        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = hrp
        billboard.Size = UDim2.new(0, 120, 0, 20)
        billboard.StudsOffset = Vector3.new(0, 4, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = screenGui
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 0.5
        label.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        label.Text = player.Name
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.Parent = billboard
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = label
        ESP_CONTAINER[player] = {highlight, billboard}
    end

    local function updateESP()
        local myChar = LocalPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local char = p.Character
                local phrp = char and char:FindFirstChild("HumanoidRootPart")
                if phrp then
                    local dist = (myHRP.Position - phrp.Position).Magnitude
                    if dist <= MAX_DISTANCE then
                        if not ESP_CONTAINER[p] then createESP(p) end
                    else
                        clearESP(p)
                    end
                end
            end
        end
    end

    local function enableESP()
        espActive = true
        toggleButtonState(espButton, espStroke, true)
        if not espConnection then
            espConnection = RunService.RenderStepped:Connect(function()
                if espActive then updateESP() end
            end)
        end
    end

    local function disableESP()
        espActive = false
        toggleButtonState(espButton, espStroke, false)
        if espConnection then espConnection:Disconnect(); espConnection = nil end
        for p in pairs(ESP_CONTAINER) do clearESP(p) end
    end

    local function toggleESP()
        if espActive then disableESP() else enableESP() end
    end

    espButton.MouseButton1Click:Connect(toggleESP)
    RegisterKeybind(Enum.KeyCode.P, toggleESP)
end

-- ===============================
-- CLOSE UI
-- ===============================
do
    local uiVisible = true
    local function toggleUI()
        uiVisible = not uiVisible
        mainFrame.Visible = uiVisible
    end
    closeButton.MouseButton1Click:Connect(toggleUI)
    RegisterKeybind(Enum.KeyCode.B, toggleUI)
    RegisterKeybind(Enum.KeyCode.Insert, toggleUI)
end

-- ===============================
-- SPINNER [V] (ИСПРАВЛЕННЫЙ БЛОК)
-- Обеспечивает работу после респавна персонажа
-- ===============================
do
    local player = LocalPlayer
    local spinnerActive = false
    local spinning = false

    local rotationSpeed = 1440
    local spinDuration = 0.25

    local humanoidStateChangedConn -- Переменная для хранения подключения

    local function setupSpinner(character)
        -- Отключаем предыдущее соединение Humanoid.StateChanged, если оно есть
        if humanoidStateChangedConn then
            humanoidStateChangedConn:Disconnect()
            humanoidStateChangedConn = nil
        end
        
        -- Получаем новый Humanoid и RootPart нового персонажа
        local humanoid = character:WaitForChild("Humanoid")
        local root = character:WaitForChild("HumanoidRootPart")

        -- Подключаем логику вращения к новому Humanoid
        humanoidStateChangedConn = humanoid.StateChanged:Connect(function(_, newState)
            if newState == Enum.HumanoidStateType.Jumping and spinnerActive and not spinning then
                spinning = true
                
                -- Логика вращения
                local rotVelocity = Instance.new("BodyAngularVelocity")
                rotVelocity.AngularVelocity = Vector3.new(0, math.rad(rotationSpeed), 0)
                rotVelocity.MaxTorque = Vector3.new(0, math.huge, 0)
                rotVelocity.P = 1000
                rotVelocity.Parent = root
                
                task.delay(spinDuration, function()
                    -- Проверка, что rotVelocity еще существует, прежде чем уничтожить
                    if rotVelocity.Parent then 
                        rotVelocity:Destroy()
                    end
                    spinning = false
                end)
            end
        end)
    end

    local function toggleSpinner()
        spinnerActive = not spinnerActive
        toggleButtonState(spinnerButton, spinnerStroke, spinnerActive)
    end

    -- 1. Подключаем кнопку и клавишу
    spinnerButton.MouseButton1Click:Connect(toggleSpinner)
    RegisterKeybind(Enum.KeyCode.V, toggleSpinner)

    local function onCharacterAdded(character)
        setupSpinner(character)
    end
    
    -- 2. Обрабатываем появление персонажа (первый вход и респавн)
    
    -- Для первого спавна: если персонаж уже есть, настраиваем спиннер
    if player.Character then
        task.defer(onCharacterAdded, player.Character)
    end

    -- Для всех последующих респавнов: подключаемся к событию CharacterAdded
    player.CharacterAdded:Connect(onCharacterAdded)
end

-- ===============================
-- Unified Input Handler
-- ===============================
do
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        local key = input.KeyCode
        local ext = externalKeybinds[key]
        if ext then
            local ok, err = pcall(ext)
            if not ok then warn("External keybind error:", err) end
        end
    end)
end

-- expose API
_G.Nur1kUI = _G.Nur1kUI or {}
_G.Nur1kUI.RegisterKeybind = RegisterKeybind
_G.Nur1kUI.UnregisterKeybind = UnregisterKeybind

-- ===============================
-- Таймер
-- ===============================
local timerLabel = Instance.new("TextLabel")
timerLabel.Size = UDim2.new(1, -20, 0, 18)
timerLabel.Position = UDim2.new(0, 10, 1, -24)
timerLabel.BackgroundTransparency = 1
timerLabel.Text = "Время в сессии: 00:00"
timerLabel.Font = Enum.Font.GothamSemibold
timerLabel.TextSize = 12
timerLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
timerLabel.TextXAlignment = Enum.TextXAlignment.Left
timerLabel.Parent = mainFrame

local startTick = tick()
local function formatTime(totalSeconds)
    totalSeconds = math.max(0, math.floor(totalSeconds))
    local minutes = math.floor(totalSeconds / 60)
    local seconds = totalSeconds % 60
    return string.format("%02d:%02d", minutes, seconds)
end

task.spawn(function()
    while task.wait(1) do
        local elapsed = tick() - startTick
        timerLabel.Text = "Время в сессии: " .. formatTime(elapsed)
    end
end)

-- Telegram button
local telegramBtn = Instance.new("TextButton")
telegramBtn.Size = UDim2.new(1, 0, 0, 28)
telegramBtn.Position = UDim2.new(0, 0, 1, -50) -- чуть выше нижнего края
telegramBtn.Text = "📱 Telegram: @nur1k_seller"
telegramBtn.Font = Enum.Font.GothamBold
telegramBtn.TextSize = 12
telegramBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
telegramBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
telegramBtn.AutoButtonColor = false
telegramBtn.Parent = mainFrame

local telegramCorner = Instance.new("UICorner")
telegramCorner.CornerRadius = UDim.new(0, 6)
telegramCorner.Parent = telegramBtn

telegramBtn.MouseButton1Click:Connect(function()
    local telegramLink = "https://t.me/nur1k_seller"
    if setclipboard then
        setclipboard(telegramLink)
    elseif toclipboard then
        toclipboard(telegramLink)
    end
    local originalText = telegramBtn.Text
    telegramBtn.Text = "✅ Ссылка скопирована!"
    task.wait(2)
    telegramBtn.Text = originalText
end)
