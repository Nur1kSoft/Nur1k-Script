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
local ReplicatedStorage = Services.ReplicatedStorage
local LocalPlayer = Players.LocalPlayer
local workspace = game:GetService("Workspace")
 
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "IceHubModernUI"
screenGui.ResetOnSpawn = false
local GUIParent = game:GetService("CoreGui")
if gethui then GUIParent = gethui() end
screenGui.Parent = GUIParent
 
-- 🔹 Основной фрейм (в нижнем правом углу)
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
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Nur1k"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.Parent = mainFrame
 
local titleLine = Instance.new("Frame")
titleLine.Size = UDim2.new(1, 0, 0, 2)
titleLine.Position = UDim2.new(0, 0, 0, 30)
titleLine.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
titleLine.BorderSizePixel = 0
titleLine.Parent = mainFrame
 
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, -10, 1, -40)
buttonContainer.Position = UDim2.new(0, 5, 0, 35)
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
 
-- 🔹 Кнопки
local speedButton, speedStroke = createButton("Speed Boost (x1.5) [Q]", "⚡")
local floorButton, floorStroke = createButton("3rd Floor Glitch [C]", "🏢")
local desyncButton, desyncStroke = createButton("Invisible - Desync [V]", "🔄")
local espButton, espStroke = createButton("ESP Players [P]", "👁️")
local closeButton, closeStroke = createButton("Close UI [B]", "🗑")
 
local telegramBtn = Instance.new("TextButton")
telegramBtn.Size = UDim2.new(1, 0, 0, 28)
telegramBtn.Text = "📱 Telegram: @nur1k_seller"
telegramBtn.Font = Enum.Font.GothamBold
telegramBtn.TextSize = 12
telegramBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
telegramBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
telegramBtn.AutoButtonColor = false
telegramBtn.Parent = buttonContainer
 
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
 
-- ------------------------
-- Внешние бинды (API)
-- ------------------------
-- Другие скрипты могут регистрировать свои бинды:
-- RegisterKeybind(Enum.KeyCode.X, function() ... end)
local externalKeybinds = {}
 
local function RegisterKeybind(keyCode, callback)
    if not keyCode or not callback then return end
    externalKeybinds[keyCode] = callback
end
 
local function UnregisterKeybind(keyCode)
    externalKeybinds[keyCode] = nil
end
 
-- =============================================================
-- ⚡ SPEED BOOST (Добавлен бинд Q)
-- =============================================================
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
 
    -- Expose toggle for external binds if нужно
    RegisterKeybind(Enum.KeyCode.Q, toggleSpeed)
end
 
-- =============================================================
-- 🏢 3RD FLOOR GLITCH (Добавлен бинд C)
-- =============================================================
do
    local active = false
    local platform, conn
    local RISE_SPEED = 15
    local isRising = false
 
    local function destroyPlatform()
        if platform then platform:Destroy(); platform = nil end
        if conn then conn:Disconnect(); conn = nil end
        isRising = false
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
        platform.Parent = workspace
 
        local function canRise()
            local origin = platform.Position + Vector3.new(0, 1, 0)
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {platform, LocalPlayer.Character}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            return not workspace:Raycast(origin, Vector3.new(0, 3, 0), rayParams)
        end
 
        isRising = true
        conn = RunService.Heartbeat:Connect(function(dt)
            if platform and active and root then
                local pos = platform.Position
                local newPos = Vector3.new(root.Position.X, pos.Y, root.Position.Z)
                if isRising and canRise() then
                    platform.Position = newPos + Vector3.new(0, RISE_SPEED * dt, 0)
                else
                    isRising = false
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
 
-- =============================================================
-- 🔄 DESYNC / INVISIBLE (Рабочий с биндом V)
-- =============================================================
do
    local desyncActive = false
 
    local function enableMobileDesync()
        local success = pcall(function()
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")
            local backpack = LocalPlayer:WaitForChild("Backpack")
 
            local netFolder = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Net")
            if not netFolder then return end
 
            local useItemRemote = netFolder:FindFirstChild("RE/UseItem", true)
            local teleportRemote = netFolder:FindFirstChild("RE/QuantumCloner/OnTeleport", true)
 
            if not useItemRemote or not teleportRemote then return end
 
            local tool
            local toolNames = {"Quantum Cloner", "Brainrot", "brainrot"}
            for _, toolName in ipairs(toolNames) do
                tool = backpack:FindFirstChild(toolName) or character:FindFirstChild(toolName)
                if tool then break end
            end
 
            if tool and tool.Parent == backpack then humanoid:EquipTool(tool); task.wait(0.3) end
 
            if setfflag then setfflag("WorldStepMax", "-9999999999") end
 
            task.spawn(function() useItemRemote:FireServer() end)
            task.wait(0.1)
            task.spawn(function() teleportRemote:FireServer() end)
            task.wait(1)
 
            if setfflag then setfflag("WorldStepMax", "-1") end
        end)
        return success
    end
 
    local function disableMobileDesync()
        pcall(function()
            if setfflag then setfflag("WorldStepMax", "-1") end
        end)
    end
 
    local function toggleDesync()
        desyncActive = not desyncActive
        if desyncActive then
            local success = enableMobileDesync()
            if success then
                toggleButtonState(desyncButton, desyncStroke, true)
            else
                desyncActive = false
                toggleButtonState(desyncButton, desyncStroke, false)
            end
        else
            disableMobileDesync()
            toggleButtonState(desyncButton, desyncStroke, false)
        end
    end
 
    desyncButton.MouseButton1Click:Connect(toggleDesync)
 
    RegisterKeybind(Enum.KeyCode.V, toggleDesync)
end
 
-- =============================================================
-- 🔹 ESP (Добавлен бинд P)
-- =============================================================
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
        billboard.Parent = GUIParent
 
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
 
        ESP_CONTAINER[player] = { highlight, billboard }
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
                        if not ESP_CONTAINER[p] then
                            createESP(p)
                        end
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
        for p in pairs(ESP_CONTAINER) do
            clearESP(p)
        end
    end
 
    local function toggleESP()
        if espActive then disableESP() else enableESP() end
    end
 
    espButton.MouseButton1Click:Connect(toggleESP)
 
    RegisterKeybind(Enum.KeyCode.P, toggleESP)
end
 
-- =============================================================
-- 🗑 CLOSE UI (Добавлен бинд B + Insert)
-- =============================================================
do
    local uiVisible = true
 
    local function toggleUI()
        uiVisible = not uiVisible
        mainFrame.Visible = uiVisible
    end
 
    closeButton.MouseButton1Click:Connect(function()
        toggleUI()
    end)
 
    RegisterKeybind(Enum.KeyCode.B, toggleUI)
    RegisterKeybind(Enum.KeyCode.Insert, toggleUI)
end
 
-- =============================================================
-- Unified Input Handler (все бинды через одну функцию + внешние)
-- =============================================================
do
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        local key = input.KeyCode
        -- сначала внешние бинды (если есть) — внешние имеют приоритет
        local ext = externalKeybinds[key]
        if ext then
            -- pcall для безопасности
            local ok, err = pcall(ext)
            if not ok then
                warn("External keybind error:", err)
            end
            return
        end
 
        -- внутренние бинды (если внешние не зарегистрированы)
        if key == Enum.KeyCode.Q then
            local cb = externalKeybinds[Enum.KeyCode.Q]
            if not cb then
                -- toggleSpeed (если зарегистрирован внутренне через RegisterKeybind — он уже в externalKeybinds)
                -- В любом случае, вызываем зарегистрированную или ничего не делаем
                -- (скорость уже зарегистрирована выше)
            end
        elseif key == Enum.KeyCode.C then
            -- floor glitch handled via registration
        elseif key == Enum.KeyCode.V then
            -- desync handled via registration
        elseif key == Enum.KeyCode.P then
            -- esp handled via registration
        elseif key == Enum.KeyCode.B or key == Enum.KeyCode.Insert then
            -- toggle UI handled via registration
        end
        -- (внутренние функции уже добавлены в registry через RegisterKeybind, поэтому ничего вручную не дергаем)
    end)
end
 
-- expose API (возможно понадобится в других скриптах)
_G.Nur1kUI = _G.Nur1kUI or {}
_G.Nur1kUI.RegisterKeybind = RegisterKeybind
_G.Nur1kUI.UnregisterKeybind = UnregisterKeybind
 
-- Готово! Другие скрипты могут теперь делать:
-- if _G.Nur1kUI and _G.Nur1kUI.RegisterKeybind then
--     _G.Nur1kUI.RegisterKeybind(Enum.KeyCode.X, function() print("X pressed") end)
-- end
 