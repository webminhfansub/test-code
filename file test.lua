-- aimbot_pro.lua
-- Phiên bản: Hiện đại (💎) — Không có menu Key, không có nút Discord
-- Giữ ESP, Aimbot, FOV. Loại bỏ Key input & Discord button.

-- -------- Services & basic refs
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Drawing (ESP)
local Drawing = Drawing

-- ---------- Config (có thể chỉnh)
local CONFIG = {
    UI = {
        title = "whoamhoam v2.0 PRO",
        theme = {
            bg = Color3.fromRGB(18, 18, 20),
            panel = Color3.fromRGB(24, 26, 30),
            accent = Color3.fromRGB(21, 255, 217), -- neon teal
            text = Color3.fromRGB(235, 235, 235),
            bad = Color3.fromRGB(238, 77, 77)
        }
    },
    Aimbot = {
        Enabled = false,
        Keybind = Enum.KeyCode.LeftControl,
        FOV = 90,
        MaxDistance = 200,
        TargetPart = "Head",
        ShowFOV = true
    },
    ESP = {
        Enabled = false,
        Snaplines = true,
        SnaplinePos = "Center", -- "Center" | "Top" | "Bottom"
        Rainbow = false,
        BoxColor = Color3.fromRGB(21,255,217),
        DistanceColor = Color3.fromRGB(255,255,255),
        HealthGradient = { Color3.fromRGB(0,255,0), Color3.fromRGB(255,255,0), Color3.fromRGB(255,0,0) }
    },
}

-- ---------- Utilities
local function safe_pcall(fn, ...)
    local ok, res = pcall(fn, ...)
    return ok, res
end

local function isPlayerValid(plr)
    if not plr or not plr.Character then return false end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    local head = plr.Character:FindFirstChild("Head")
    if not hum or not head then return false end
    if hum.Health <= 0 then return false end
    return true
end

-- FPS counter (simple)
local fps = 0
do
    local frames = 0
    local last = tick()
    RunService.RenderStepped:Connect(function(dt)
        frames = frames + 1
        if tick() - last >= 1 then
            fps = frames
            frames = 0
            last = tick()
        end
    end)
end

-- Ping reader (best-effort)
local function getPing()
    local success, stat = pcall(function()
        local s = game:GetService("Stats")
        if s and s:FindFirstChild("Network") then
            local n = s.Network
            if n:FindFirstChild("DataPing") then
                return math.floor(n.DataPing:GetValue())
            end
        end
        return nil
    end)
    if success and stat then return stat end
    return nil
end

-- Notification helper (StarterGui:SetCore safe)
local function notify(title, text, dur)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title or "Notification",
            Text = text or "",
            Duration = dur or 3
        })
    end)
end

-- ---------- GUI (ScreenGui in CoreGui)
local screen = Instance.new("ScreenGui")
screen.Name = "AimbotProGUI"
screen.DisplayOrder = 9999
screen.Parent = CoreGui

-- Main container
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 420, 0, 520)
main.Position = UDim2.new(0, 12, 0, 12)
main.BackgroundColor3 = CONFIG.UI.theme.bg
main.BorderSizePixel = 0
main.Parent = screen

local uicorner = Instance.new("UICorner", main)
uicorner.CornerRadius = UDim.new(0, 12)

-- Title bar
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 48)
titleBar.BackgroundColor3 = CONFIG.UI.theme.panel
titleBar.BorderSizePixel = 0

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, -20, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = CONFIG.UI.title
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.TextColor3 = CONFIG.UI.theme.accent
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Close & minimize
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 34, 0, 28)
closeBtn.Position = UDim2.new(1, -44, 0, 10)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = CONFIG.UI.theme.text
closeBtn.BackgroundTransparency = 1

local minimizeBtn = Instance.new("TextButton", titleBar)
minimizeBtn.Size = UDim2.new(0, 34, 0, 28)
minimizeBtn.Position = UDim2.new(1, -88, 0, 10)
minimizeBtn.Text = "_"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.TextColor3 = CONFIG.UI.theme.text
minimizeBtn.BackgroundTransparency = 1

-- Content area (left: controls, right: info)
local leftPanel = Instance.new("Frame", main)
leftPanel.Size = UDim2.new(0, 270, 1, -60)
leftPanel.Position = UDim2.new(0, 12, 0, 60)
leftPanel.BackgroundTransparency = 1

local rightPanel = Instance.new("Frame", main)
rightPanel.Size = UDim2.new(1, -300, 1, -60)
rightPanel.Position = UDim2.new(0, 294, 0, 60)
rightPanel.BackgroundTransparency = 1

-- Buttons: ESP, Aimbot toggles and FOV, distance inputs
local btnY = 10
local function newBtn(text, parent)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 36)
    b.Position = UDim2.new(0, 0, 0, btnY)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.BackgroundColor3 = CONFIG.UI.theme.panel
    b.TextColor3 = CONFIG.UI.theme.text
    btnY = btnY + 46
    return b
end

local espBtn = newBtn("ESP: OFF", leftPanel)
local snaplineBtn = newBtn("Snaplines: OFF", leftPanel)
local rainbowBtn = newBtn("Rainbow ESP: OFF", leftPanel)
local aimbotBtn = newBtn("Aimbot: OFF", leftPanel)

-- FOV and distance input
local fovLabel = Instance.new("TextLabel", leftPanel)
fovLabel.Position = UDim2.new(0, 0, 0, btnY)
fovLabel.Size = UDim2.new(0.5, -8, 0, 20)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV:"
fovLabel.Font = Enum.Font.Gotham
fovLabel.TextSize = 12
fovLabel.TextColor3 = CONFIG.UI.theme.text
fovLabel.TextXAlignment = Enum.TextXAlignment.Left

local fovBox = Instance.new("TextBox", leftPanel)
fovBox.Position = UDim2.new(0.5, 0, 0, btnY)
fovBox.Size = UDim2.new(0.5, -0, 0, 24)
fovBox.BackgroundColor3 = CONFIG.UI.theme.panel
fovBox.Text = tostring(CONFIG.Aimbot.FOV)
fovBox.Font = Enum.Font.Gotham
fovBox.TextSize = 14
fovBox.TextColor3 = CONFIG.UI.theme.text

btnY = btnY + 36 + 10

local distLabel = Instance.new("TextLabel", leftPanel)
distLabel.Position = UDim2.new(0, 0, 0, btnY)
distLabel.Size = UDim2.new(0.5, -8, 0, 20)
distLabel.BackgroundTransparency = 1
distLabel.Text = "Max Distance:"
distLabel.Font = Enum.Font.Gotham
distLabel.TextSize = 12
distLabel.TextColor3 = CONFIG.UI.theme.text
distLabel.TextXAlignment = Enum.TextXAlignment.Left

local distBox = Instance.new("TextBox", leftPanel)
distBox.Position = UDim2.new(0.5, 0, 0, btnY)
distBox.Size = UDim2.new(0.5, -0, 0, 24)
distBox.BackgroundColor3 = CONFIG.UI.theme.panel
distBox.Text = tostring(CONFIG.Aimbot.MaxDistance)
distBox.Font = Enum.Font.Gotham
distBox.TextSize = 14
distBox.TextColor3 = CONFIG.UI.theme.text

-- Info panel (right panel)
local infoY = 0
local function newInfoLabel(text)
    local l = Instance.new("TextLabel", rightPanel)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.Position = UDim2.new(0, 0, 0, infoY)
    l.BackgroundTransparency = 1
    l.Text = text
    l.Font = Enum.Font.Gotham
    l.TextSize = 12
    l.TextColor3 = CONFIG.UI.theme.text
    l.TextXAlignment = Enum.TextXAlignment.Left
    infoY = infoY + 22
    return l
end

local playerLabel = newInfoLabel("User: " .. (LocalPlayer and LocalPlayer.Name or "Unknown"))
local pingLabel = newInfoLabel("Ping: ...")
local fpsLabel = newInfoLabel("FPS: ...")
local timeLabel = newInfoLabel("Time (VN): ...")
local statusLabel = newInfoLabel("Status: Ready")

-- Move / drag main
local dragging, dragInput, dragStart, startPos
local function updateInput(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Minimize & close behavior
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    main.Size = minimized and UDim2.new(0, 200, 0, 48) or UDim2.new(0, 420, 0, 520)
end)

closeBtn.MouseButton1Click:Connect(function()
    screen:Destroy()
end)

-- ---------- Toggle buttons behavior
local function updateBtnState(btn, state)
    btn.Text = btn.Text:match("^[^:]+") .. ": " .. (state and "ON" or "OFF")
    btn.BackgroundColor3 = state and CONFIG.UI.theme.accent or CONFIG.UI.theme.panel
end

espBtn.MouseButton1Click:Connect(function()
    CONFIG.ESP.Enabled = not CONFIG.ESP.Enabled
    updateBtnState(espBtn, CONFIG.ESP.Enabled)
end)
snaplineBtn.MouseButton1Click:Connect(function()
    CONFIG.ESP.Snaplines = not CONFIG.ESP.Snaplines
    updateBtnState(snaplineBtn, CONFIG.ESP.Snaplines)
end)
rainbowBtn.MouseButton1Click:Connect(function()
    CONFIG.ESP.Rainbow = not CONFIG.ESP.Rainbow
    updateBtnState(rainbowBtn, CONFIG.ESP.Rainbow)
end)
aimbotBtn.MouseButton1Click:Connect(function()
    CONFIG.Aimbot.Enabled = not CONFIG.Aimbot.Enabled
    updateBtnState(aimbotBtn, CONFIG.Aimbot.Enabled)
end)

fovBox.FocusLost:Connect(function(enter)
    if enter then
        local v = tonumber(fovBox.Text)
        if v and v >= 10 and v <= 1000 then
            CONFIG.Aimbot.FOV = v
            fovBox.Text = tostring(v)
        else
            fovBox.Text = tostring(CONFIG.Aimbot.FOV)
        end
    end
end)

distBox.FocusLost:Connect(function(enter)
    if enter then
        local v = tonumber(distBox.Text)
        if v and v > 0 and v <= 5000 then
            CONFIG.Aimbot.MaxDistance = v
            distBox.Text = tostring(v)
        else
            distBox.Text = tostring(CONFIG.Aimbot.MaxDistance)
        end
    end
end)

-- initial states
updateBtnState(espBtn, CONFIG.ESP.Enabled)
updateBtnState(snaplineBtn, CONFIG.ESP.Snaplines)
updateBtnState(rainbowBtn, CONFIG.ESP.Rainbow)
updateBtnState(aimbotBtn, CONFIG.Aimbot.Enabled)

-- ---------- ESP drawing system
local playersDrawing = {} -- [player] = {Box, HealthBar, Distance, Snapline}

local function createDrawForPlayer(plr)
    local t = {}
    t.Box = Drawing.new("Square")
    t.Box.Visible = false
    t.Box.Filled = false
    t.Box.Thickness = 2

    t.HealthBar = Drawing.new("Square")
    t.HealthBar.Visible = false
    t.HealthBar.Filled = true

    t.Distance = Drawing.new("Text")
    t.Distance.Visible = false
    t.Distance.Center = true
    t.Distance.Size = 14

    t.Snapline = Drawing.new("Line")
    t.Snapline.Visible = false
    t.Snapline.Thickness = 1

    return t
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        playersDrawing[plr] = createDrawForPlayer(plr)
    end
end

Players.PlayerAdded:Connect(function(plr)
    if plr ~= LocalPlayer then
        playersDrawing[plr] = createDrawForPlayer(plr)
    end
end)
Players.PlayerRemoving:Connect(function(plr)
    if playersDrawing[plr] then
        for _, d in pairs(playersDrawing[plr]) do
            pcall(function() d:Remove() end)
        end
        playersDrawing[plr] = nil
    end
end)

-- health gradient helper
local function lerpColor(a, b, t)
    return Color3.new(a.r + (b.r - a.r) * t, a.g + (b.g - a.g) * t, a.b + (b.b - a.b) * t)
end

-- choose best target (closest to center of view & within FOV)
local function getAimbotTarget()
    local best = nil
    local bestDist = math.huge
    local fov = CONFIG.Aimbot.FOV
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isPlayerValid(plr) then
            local head = plr.Character:FindFirstChild("Head")
            local vec, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local dir = (Vector2.new(vec.X, vec.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                local normalizedDir = (dir / (math.min(Camera.ViewportSize.X, Camera.ViewportSize.Y) / 2)) * 180 -- approx degrees
                if normalizedDir <= fov/2 then
                    local dist = (head.Position - Camera.CFrame.Position).Magnitude
                    if dist <= CONFIG.Aimbot.MaxDistance and dist < bestDist then
                        bestDist = dist
                        best = plr
                    end
                end
            end
        end
    end
    return best
end

-- main render loop
RunService.RenderStepped:Connect(function()
    -- update info panel
    pingLabel.Text = "Ping: " .. (tostring(getPing() or "N/A") .. " ms")
    fpsLabel.Text = "FPS: " .. tostring(fps)
    timeLabel.Text = "Time (VN): " .. os.date("%d/%m/%Y %H:%M:%S", os.time() + 7*3600) -- VN timezone offset +7
    playerLabel.Text = "User: " .. (LocalPlayer and LocalPlayer.Name or "Unknown")
    -- ESP
    for plr, draws in pairs(playersDrawing) do
        if not isPlayerValid(plr) or not CONFIG.ESP.Enabled or not plr.Character then
            for _, d in pairs(draws) do
                pcall(function() d.Visible = false end)
            end
        else
            local head = plr.Character:FindFirstChild("Head")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if not onScreen then
                for _, d in pairs(draws) do pcall(function() d.Visible = false end) end
            else
                local dist = (head.Position - Camera.CFrame.Position).Magnitude
                local scale = math.clamp(1000/dist, 25, 200)
                -- box
                draws.Box.Size = Vector2.new(scale, scale*1.4)
                draws.Box.Position = Vector2.new(pos.X - draws.Box.Size.X/2, pos.Y - draws.Box.Size.Y/2)
                draws.Box.Color = CONFIG.ESP.BoxColor
                draws.Box.Visible = true
                -- health
                local healthRatio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                draws.HealthBar.Size = Vector2.new(4, draws.Box.Size.Y * healthRatio)
                draws.HealthBar.Position = Vector2.new(draws.Box.Position.X + draws.Box.Size.X + 6, draws.Box.Position.Y + draws.Box.Size.Y - draws.HealthBar.Size.Y)
                -- gradient
                local gidx = healthRatio * 2
                local gfloor = math.floor(gidx)
                local gfract = gidx - gfloor
                local c1 = CONFIG.ESP.HealthGradient[math.max(1, math.min(3, gfloor+1))]
                local c2 = CONFIG.ESP.HealthGradient[math.max(1, math.min(3, gfloor+2))]
                draws.HealthBar.Color = lerpColor(c1, c2, gfract)
                draws.HealthBar.Visible = true
                -- distance text
                draws.Distance.Text = tostring(math.floor(dist)) .. "m"
                draws.Distance.Position = Vector2.new(pos.X, pos.Y + draws.Box.Size.Y/2 + 10)
                draws.Distance.Visible = true
                draws.Distance.Color = CONFIG.ESP.DistanceColor
                -- snapline
                if CONFIG.ESP.Snaplines then
                    local fromY = (CONFIG.ESP.SnaplinePos == "Top") and 0 or ((CONFIG.ESP.SnaplinePos == "Bottom") and Camera.ViewportSize.Y or Camera.ViewportSize.Y/2)
                    draws.Snapline.From = Vector2.new(pos.X, pos.Y + draws.Box.Size.Y/2)
                    draws.Snapline.To = Vector2.new(Camera.ViewportSize.X/2, fromY)
                    if CONFIG.ESP.Rainbow then
                        local h = (tick() * 0.2) % 1
                        draws.Snapline.Color = Color3.fromHSV(h, 1, 1)
                    else
                        draws.Snapline.Color = CONFIG.ESP.BoxColor
                    end
                    draws.Snapline.Visible = true
                else
                    draws.Snapline.Visible = false
                end
            end
        end
    end

    -- Aimbot (simple: snap camera to target if enabled & key held)
    if CONFIG.Aimbot.Enabled then
        -- require key hold
        if UserInputService:IsKeyDown(CONFIG.Aimbot.Keybind) then
            local target = getAimbotTarget()
            if target and target.Character and target.Character:FindFirstChild(CONFIG.Aimbot.TargetPart) then
                local head = target.Character:FindFirstChild(CONFIG.Aimbot.TargetPart)
                if head then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
                end
            end
        end
    end
end)

-- hotkey to toggle menu (RightShift)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        screen.Enabled = not screen.Enabled
    end
end)

-- initial notification & welcome
pcall(function() notify("Aimbot PRO", "Script activated. Press RightShift to toggle UI.", 4) end)
statusLabel.Text = "Status: Ready"

print("✅ aimbot_pro.lua loaded (PRO modern) - Key & Discord removed.")
