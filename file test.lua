-- aimbot_pro.lua
-- Phiên bản: Hiện đại (💎) - Aimbot lock (smooth) + LOS check (no wallhack)
-- Giữ ESP, Aimbot, FOV. KHÔNG có chức năng xuyên tường.

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Drawing = Drawing

-- ======= CONFIG =======
local CONFIG = {
    UI = {
        title = "whoamhoam v3.0 PRO",
        theme = {
            bg = Color3.fromRGB(18, 18, 20),
            panel = Color3.fromRGB(26, 28, 32),
            accent = Color3.fromRGB(21, 255, 217),
            text = Color3.fromRGB(235, 235, 235),
            warn = Color3.fromRGB(255, 120, 120)
        }
    },
    Aimbot = {
        Enabled = false,
        Keybind = Enum.KeyCode.LeftControl, -- hold to aim
        FOV = 90,
        MaxDistance = 300,
        TargetPart = "Head",
        ShowFOV = true,
        Smoothness = 0.12, -- smaller = snappier (0 instant)
        RequireLOS = true -- line-of-sight check (no wallhack)
    },
    ESP = {
        Enabled = false,
        Snaplines = true,
        SnaplinePos = "Center", -- "Top"|"Center"|"Bottom"
        Rainbow = false,
        BoxColor = Color3.fromRGB(21,255,217),
        DistanceColor = Color3.fromRGB(255,255,255),
        HealthGradient = { Color3.fromRGB(0,255,0), Color3.fromRGB(255,255,0), Color3.fromRGB(255,0,0) }
    }
}

-- ======= UTIL =======
local function isPlayerValid(plr)
    if not plr or not plr.Character then return false end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    local head = plr.Character:FindFirstChild("Head")
    if not hum or not head then return false end
    if hum.Health <= 0 then return false end
    return true
end

local function lerp(a, b, t) return a + (b - a) * t end
local function lerpCFrame(cf1, cf2, t)
    local p = Vector3.new(lerp(cf1.Position.X, cf2.Position.X, t), lerp(cf1.Position.Y, cf2.Position.Y, t), lerp(cf1.Position.Z, cf2.Position.Z, t))
    local r = cf1:lerp(cf2, t) -- use CFrame:lerp for rotation + position
    return r
end

-- Raycast LOS check: true if unobstructed to target part
local function hasLineOfSight(targetPart)
    if not targetPart then return false end
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.IgnoreWater = true
    local result = Workspace:Raycast(origin, direction, params)
    if not result then
        -- nothing hit within direction (shouldn't happen often)
        return false
    end
    -- if the instance hit is descendant of the target player's character -> LOS true
    return result.Instance and result.Instance:IsDescendantOf(targetPart.Parent)
end

-- find target within FOV & distance; returns player
local function getAimbotTarget()
    local best = nil
    local bestScore = math.huge
    local fov = CONFIG.Aimbot.FOV
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isPlayerValid(plr) then
            local part = plr.Character:FindFirstChild(CONFIG.Aimbot.TargetPart)
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local screenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                    local distScreen = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                    -- approximate angle by screen distance / half viewport
                    local norm = (distScreen / (math.min(Camera.ViewportSize.X, Camera.ViewportSize.Y)/2)) * 180
                    if norm <= fov/2 then
                        local worldDist = (part.Position - Camera.CFrame.Position).Magnitude
                        if worldDist <= CONFIG.Aimbot.MaxDistance then
                            -- optional LOS check
                            if CONFIG.Aimbot.RequireLOS then
                                if not hasLineOfSight(part) then
                                    -- can't see target directly; skip
                                else
                                    if worldDist < bestScore then
                                        bestScore = worldDist
                                        best = plr
                                    end
                                end
                            else
                                if worldDist < bestScore then
                                    bestScore = worldDist
                                    best = plr
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end

-- ======= GUI (simple modern) =======
local screen = Instance.new("ScreenGui")
screen.Name = "AimbotProGUI_v3"
screen.Parent = CoreGui
screen.ResetOnSpawn = false

local main = Instance.new("Frame", screen)
main.Size = UDim2.new(0, 420, 0, 520)
main.Position = UDim2.new(0, 8, 0, 8)
main.BackgroundColor3 = CONFIG.UI.theme.bg
main.BorderSizePixel = 0
main.Name = "Main"

local uiCorner = Instance.new("UICorner", main); uiCorner.CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -24, 0, 48)
title.Position = UDim2.new(0, 12, 0, 6)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = CONFIG.UI.theme.accent
title.Text = CONFIG.UI.title
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 32, 0, 28)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BackgroundTransparency = 1
closeBtn.TextColor3 = CONFIG.UI.theme.text

closeBtn.MouseButton1Click:Connect(function() screen:Destroy() end)

-- Left controls
local left = Instance.new("Frame", main)
left.Size = UDim2.new(0, 270, 1, -70)
left.Position = UDim2.new(0, 12, 0, 64)
left.BackgroundTransparency = 1

local function newButton(text, y)
    local b = Instance.new("TextButton", left)
    b.Size = UDim2.new(1, 0, 0, 36)
    b.Position = UDim2.new(0, 0, 0, y)
    b.BackgroundColor3 = CONFIG.UI.theme.panel
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.Text = text
    b.TextColor3 = CONFIG.UI.theme.text
    local c = Instance.new("UICorner", b); c.CornerRadius = UDim.new(0,6)
    return b
end

local y = 0
local espBtn = newButton("ESP: OFF", y); y = y + 46
local snapBtn = newButton("Snaplines: OFF", y); y = y + 46
local rainbowBtn = newButton("Rainbow: OFF", y); y = y + 46
local aimBtn = newButton("Aimbot: OFF", y); y = y + 46

-- FOV & distance & smoothness
local function newLabel(text, ypos)
    local l = Instance.new("TextLabel", left)
    l.Size = UDim2.new(0.5, -6, 0, 18)
    l.Position = UDim2.new(0, 0, 0, ypos)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.Gotham
    l.TextSize = 12
    l.TextColor3 = CONFIG.UI.theme.text
    l.Text = text
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

local fovLabel = newLabel("FOV:", y); local fovBox = Instance.new("TextBox", left)
fovBox.Position = UDim2.new(0.5, 6, 0, y); fovBox.Size = UDim2.new(0.5, -6, 0, 22)
fovBox.BackgroundColor3 = CONFIG.UI.theme.panel; fovBox.Text = tostring(CONFIG.Aimbot.FOV); fovBox.ClearTextOnFocus = false; fovBox.Font = Enum.Font.Gotham; fovBox.TextSize = 14; y = y + 32

local distLabel = newLabel("Max Distance:", y); local distBox = Instance.new("TextBox", left)
distBox.Position = UDim2.new(0.5, 6, 0, y); distBox.Size = UDim2.new(0.5, -6, 0, 22)
distBox.BackgroundColor3 = CONFIG.UI.theme.panel; distBox.Text = tostring(CONFIG.Aimbot.MaxDistance); distBox.ClearTextOnFocus = false; distBox.Font = Enum.Font.Gotham; distBox.TextSize = 14; y = y + 32

local smoothLabel = newLabel("Smoothness (0 instant):", y); local smoothBox = Instance.new("TextBox", left)
smoothBox.Position = UDim2.new(0.5, 6, 0, y); smoothBox.Size = UDim2.new(0.5, -6, 0, 22)
smoothBox.BackgroundColor3 = CONFIG.UI.theme.panel; smoothBox.Text = tostring(CONFIG.Aimbot.Smoothness); smoothBox.ClearTextOnFocus = false; smoothBox.Font = Enum.Font.Gotham; smoothBox.TextSize = 14; y = y + 40

-- Right info panel
local right = Instance.new("Frame", main)
right.Size = UDim2.new(1, -300, 1, -70)
right.Position = UDim2.new(0, 294, 0, 64)
right.BackgroundTransparency = 1

local function newInfo(text, ypos)
    local l = Instance.new("TextLabel", right)
    l.Size = UDim2.new(1, 0, 0, 18)
    l.Position = UDim2.new(0, 0, 0, ypos)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.Gotham
    l.TextSize = 13
    l.TextColor3 = CONFIG.UI.theme.text
    l.Text = text
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

local infoY = 0
local playerLabel = newInfo("User: " .. (LocalPlayer and LocalPlayer.Name or "Unknown"), infoY); infoY = infoY + 22
local pingLabel = newInfo("Ping: ...", infoY); infoY = infoY + 22
local fpsLabel = newInfo("FPS: ...", infoY); infoY = infoY + 22
local timeLabel = newInfo("Time (VN): ...", infoY); infoY = infoY + 22
local statusLabel = newInfo("Status: Ready", infoY); infoY = infoY + 22

-- Dragging main
local dragging, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Button interactions
local function setBtnState(btn, state)
    btn.Text = btn.Text:match("^[^:]+") .. ": " .. (state and "ON" or "OFF")
    btn.BackgroundColor3 = state and CONFIG.UI.theme.accent or CONFIG.UI.theme.panel
end

espBtn.MouseButton1Click:Connect(function()
    CONFIG.ESP.Enabled = not CONFIG.ESP.Enabled; setBtnState(espBtn, CONFIG.ESP.Enabled)
end)
snapBtn.MouseButton1Click:Connect(function()
    CONFIG.ESP.Snaplines = not CONFIG.ESP.Snaplines; setBtnState(snapBtn, CONFIG.ESP.Snaplines)
end)
rainbowBtn.MouseButton1Click:Connect(function()
    CONFIG.ESP.Rainbow = not CONFIG.ESP.Rainbow; setBtnState(rainbowBtn, CONFIG.ESP.Rainbow)
end)
aimBtn.MouseButton1Click:Connect(function()
    CONFIG.Aimbot.Enabled = not CONFIG.Aimbot.Enabled; setBtnState(aimBtn, CONFIG.Aimbot.Enabled)
end)

fovBox.FocusLost:Connect(function(enter)
    if enter then local v = tonumber(fovBox.Text); if v and v>0 then CONFIG.Aimbot.FOV = v else fovBox.Text = tostring(CONFIG.Aimbot.FOV) end end
end)
distBox.FocusLost:Connect(function(enter)
    if enter then local v = tonumber(distBox.Text); if v and v>0 then CONFIG.Aimbot.MaxDistance = v else distBox.Text = tostring(CONFIG.Aimbot.MaxDistance) end end
end)
smoothBox.FocusLost:Connect(function(enter)
    if enter then local v = tonumber(smoothBox.Text); if v and v>=0 then CONFIG.Aimbot.Smoothness = v else smoothBox.Text = tostring(CONFIG.Aimbot.Smoothness) end end
end)

-- initial states
setBtnState(espBtn, CONFIG.ESP.Enabled)
setBtnState(snapBtn, CONFIG.ESP.Snaplines)
setBtnState(rainbowBtn, CONFIG.ESP.Rainbow)
setBtnState(aimBtn, CONFIG.Aimbot.Enabled)

-- ======= ESP (Drawing) =======
local playersDrawing = {}

local function createDrawing()
    local t = {}
    t.Box = Drawing.new("Square"); t.Box.Visible=false; t.Box.Filled=false; t.Box.Thickness=2
    t.Health = Drawing.new("Square"); t.Health.Visible=false; t.Health.Filled=true
    t.Distance = Drawing.new("Text"); t.Distance.Visible=false; t.Distance.Center=true; t.Distance.Size=14
    t.Snap = Drawing.new("Line"); t.Snap.Visible=false; t.Snap.Thickness=1
    return t
end

for _,plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then playersDrawing[plr] = createDrawing() end
end
Players.PlayerAdded:Connect(function(plr) if plr~=LocalPlayer then playersDrawing[plr] = createDrawing() end end)
Players.PlayerRemoving:Connect(function(plr)
    if playersDrawing[plr] then
        for _,d in pairs(playersDrawing[plr]) do pcall(function() d:Remove() end) end
        playersDrawing[plr] = nil
    end
end)

local function colorLerp(a,b,t) return Color3.new(a.r+(b.r-a.r)*t, a.g+(b.g-a.g)*t, a.b+(b.b-a.b)*t) end

-- ======= Aimbot loop & Render =======
local fpsCounter = 0
do
    local frames = 0; local last = tick()
    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        if tick()-last >= 1 then fpsCounter = frames; frames = 0; last = tick() end
    end)
end

-- FOV circle (Drawing)
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = CONFIG.Aimbot.ShowFOV
fovCircle.Thickness = 2
fovCircle.NumSides = 100
fovCircle.Filled = false
fovCircle.Color = CONFIG.UI.theme.accent

RunService.RenderStepped:Connect(function(dt)
    -- update info
    pingLabel.Text = "Ping: " .. tostring(math.floor((pcall(function() local s=game:GetService("Stats"); if s and s.Network and s.Network:FindFirstChild("DataPing") then return s.Network.DataPing:GetValue() end end) or 0) or 0)) .. " ms"
    fpsLabel.Text = "FPS: " .. tostring(fpsCounter)
    timeLabel.Text = "Time (VN): " .. os.date("%d/%m/%Y %H:%M:%S", os.time() + 7*3600)
    playerLabel.Text = "User: " .. (LocalPlayer and LocalPlayer.Name or "Unknown")
    statusLabel.Text = "Status: " .. (CONFIG.Aimbot.Enabled and "Aimbot ON" or "Idle")

    -- update FOV circle
    fovCircle.Visible = CONFIG.Aimbot.ShowFOV
    if fovCircle.Visible then
        local radius = (CONFIG.Aimbot.FOV/2) * (Camera.ViewportSize.Y / 614)
        fovCircle.Radius = radius
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        if CONFIG.ESP.Rainbow then
            fovCircle.Color = Color3.fromHSV((tick()*0.2)%1, 1, 1)
        else
            fovCircle.Color = CONFIG.UI.theme.accent
        end
    end

    -- ESP drawing per player
    for plr, draws in pairs(playersDrawing) do
        if not isPlayerValid(plr) or not CONFIG.ESP.Enabled then
            for _,d in pairs(draws) do pcall(function() d.Visible = false end) end
        else
            local char = plr.Character
            local head = char and char:FindFirstChild("Head")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if head and hum then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if not onScreen then
                    for _,d in pairs(draws) do pcall(function() d.Visible=false end) end
                else
                    local worldDist = (head.Position - Camera.CFrame.Position).Magnitude
                    local scale = math.clamp(1000/worldDist, 30, 220)
                    draws.Box.Size = Vector2.new(scale, scale*1.4)
                    draws.Box.Position = Vector2.new(pos.X - draws.Box.Size.X/2, pos.Y - draws.Box.Size.Y/2)
                    if CONFIG.ESP.Rainbow then
                        draws.Box.Color = Color3.fromHSV((tick()*0.2)%1,1,1)
                    else
                        draws.Box.Color = CONFIG.ESP.BoxColor
                    end
                    draws.Box.Visible = true

                    -- health bar
                    local ratio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    draws.Health.Size = Vector2.new(4, draws.Box.Size.Y * ratio)
                    draws.Health.Position = Vector2.new(draws.Box.Position.X + draws.Box.Size.X + 6, draws.Box.Position.Y + draws.Box.Size.Y - draws.Health.Size.Y)
                    -- gradient
                    local idx = ratio * 2
                    local floor = math.floor(idx)
                    local frac = idx - floor
                    local c1 = CONFIG.ESP.HealthGradient[math.max(1, math.min(3, floor+1))]
                    local c2 = CONFIG.ESP.HealthGradient[math.max(1, math.min(3, floor+2))]
                    draws.Health.Color = colorLerp(c1, c2, frac)
                    draws.Health.Visible = true

                    draws.Distance.Text = tostring(math.floor(worldDist)) .. "m"
                    draws.Distance.Position = Vector2.new(pos.X, pos.Y + draws.Box.Size.Y/2 + 10)
                    draws.Distance.Color = CONFIG.ESP.DistanceColor
                    draws.Distance.Visible = true

                    -- snapline
                    if CONFIG.ESP.Snaplines then
                        local fromY = (CONFIG.ESP.SnaplinePos == "Top" and 0) or (CONFIG.ESP.SnaplinePos == "Bottom" and Camera.ViewportSize.Y) or (Camera.ViewportSize.Y/2)
                        draws.Snap.From = Vector2.new(pos.X, pos.Y + draws.Box.Size.Y/2)
                        draws.Snap.To = Vector2.new(Camera.ViewportSize.X/2, fromY)
                        if CONFIG.ESP.Rainbow then draws.Snap.Color = Color3.fromHSV((tick()*0.2)%1,1,1) else draws.Snap.Color = CONFIG.ESP.BoxColor end
                        draws.Snap.Visible = true
                    else
                        draws.Snap.Visible = false
                    end
                end
            else
                for _,d in pairs(draws) do pcall(function() d.Visible=false end) end
            end
        end
    end

    -- Aimbot: if enabled and key held, do smooth lock to best target (with LOS check)
    if CONFIG.Aimbot.Enabled and UserInputService:IsKeyDown(CONFIG.Aimbot.Keybind) then
        local target = getAimbotTarget()
        if target and target.Character then
            local part = target.Character:FindFirstChild(CONFIG.Aimbot.TargetPart)
            if part then
                -- compute desired CFrame (look at target part)
                local desired = CFrame.new(Camera.CFrame.Position, part.Position)
                local smooth = math.clamp(CONFIG.Aimbot.Smoothness, 0, 1)
                if smooth <= 0 then
                    Camera.CFrame = desired -- instant lock
                else
                    -- lerp using CFrame:lerp for rotation; but lerp factor must be small to be "ghim chặt"
                    Camera.CFrame = Camera.CFrame:lerp(desired, math.clamp(1 - math.exp(-smooth*60*dt), 0, 1))
                    -- the above approximates frame-rate independent smoothing
                end
            end
        end
    end
end)

-- Hotkey to toggle UI
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        screen.Enabled = not screen.Enabled
    end
end)

-- initial notification (best-effort)
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Aimbot PRO v3",
        Text = "Loaded. RightShift = toggle UI. Hold " .. tostring(CONFIG.Aimbot.Keybind) .. " to aim.",
        Duration = 4
    })
end)

print("✅ aimbot_pro.lua v3 loaded — smooth lock with LOS check (no wallhack).")
