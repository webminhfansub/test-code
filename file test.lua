-- aimbot_v2_deluxe.lua
-- Deluxe Aimbot + ESP for Roblox (clean, commented, configurable)
-- Features:
-- 1) Smooth aim + hard lock option
-- 2) Toggleable wall penetration (ignore walls)
-- 3) ESP: Box, Health bar, Name, Distance, Snapline, Rainbow
-- 4) Modern-ish GUI (simple native Gui elements) + draggable
-- 5) FOV Circle (drawing) with show/hide and rainbow option
-- 6) Readable, editable code (no obfuscation)
--
-- Controls (defaults):
-- RightShift: Toggle GUI visibility
-- MouseButton2 (right mouse) while Aimbot Enabled: Aim (hold)
-- InsertKey "Insert": Toggle Aimbot Enabled
-- InsertKey "Home": Toggle ESP Enabled
-- You can change keys in Config section.

-- ====== CONFIG ======
local Config = {
    -- Aimbot
    AimbotEnabled = false,        -- master toggle
    AimKey = Enum.UserInputType.MouseButton2, -- hold to aim (MouseButton2 = right mouse)
    ToggleAimbotKey = Enum.KeyCode.Insert,    -- press to toggle aimbot on/off
    LockOn = true,                -- hard lock (true = strong lock, false = smooth follow)
    Smoothness = 0.12,            -- smaller = snappier, 0.0 = instant
    FOV = 120,                    -- degrees FOV for target acquisition
    MaxDistance = 200,            -- max target distance in studs
    IgnoreWalls = false,          -- if true, aimbot ignores raycast block (bypass walls)
    TargetPart = "Head",          -- which part to aim at ("Head" or "HumanoidRootPart")
    AimWhileMenuClosed = true,    -- only aim when menu hidden? (not used here)
    LockStrength = 1.0,           -- multiplier for lock (1 full, <1 weaker)
    -- ESP
    ESPEnabled = true,
    ESP_DrawBox = true,
    ESP_DrawHealth = true,
    ESP_DrawName = true,
    ESP_DrawDistance = true,
    ESP_Snapline = true,
    ESP_SnaplinePosition = "Bottom", -- "Top" | "Bottom" | "Center"
    ESP_Rainbow = false,
    ESP_Font = Drawing.Fonts.UI,  -- choose font for Drawing's text
    -- FOV Visual
    ShowFOV = true,
    FOV_Rainbow = false,
    -- Visuals
    BoxColor = Color3.fromRGB(255, 150, 0),
    HealthGradient = {
        Color3.fromRGB(0,255,0),
        Color3.fromRGB(255,255,0),
        Color3.fromRGB(255,0,0),
    },
    SnaplineColor = Color3.fromRGB(255,255,255),
    -- Misc / GUI
    ToggleGuiKey = Enum.KeyCode.RightShift,
    GuiOpen = true,
    -- Performance
    MaxESPPlayers = 50, -- don't try to draw for more than this many players
}

-- ====== SERVICES & SHORTCUTS ======
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Drawing safe constructor
local function NewDrawing(kind)
    local ok, obj = pcall(function() return Drawing.new(kind) end)
    if ok then return obj end
    return nil
end

-- ====== DATA STRUCTURES ======
local ESPObjects = {} -- player -> draws
local function MakeESPForPlayer(player)
    local data = {}
    data.Box = NewDrawing("Square")
    data.Health = NewDrawing("Square")
    data.Name = NewDrawing("Text")
    data.Distance = NewDrawing("Text")
    data.Snapline = NewDrawing("Line")
    -- default properties
    if data.Box then
        data.Box.Visible = false
        data.Box.Filled = false
        data.Box.Thickness = 2
    end
    if data.Health then
        data.Health.Visible = false
        data.Health.Filled = true
        data.Health.Thickness = 0
    end
    if data.Name then
        data.Name.Visible = false
        data.Name.Center = true
        data.Name.Size = 16
        data.Name.Font = Config.ESP_Font
    end
    if data.Distance then
        data.Distance.Visible = false
        data.Distance.Center = true
        data.Distance.Size = 14
        data.Distance.Font = Config.ESP_Font
    end
    if data.Snapline then
        data.Snapline.Visible = false
        data.Snapline.Thickness = 1
    end
    return data
end

-- Create ESP objects for all players (except local)
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        ESPObjects[p] = MakeESPForPlayer(p)
    end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then
        ESPObjects[p] = MakeESPForPlayer(p)
    end
end)
Players.PlayerRemoving:Connect(function(p)
    if ESPObjects[p] then
        for _, d in pairs(ESPObjects[p]) do
            pcall(function() d:Remove() end)
        end
        ESPObjects[p] = nil
    end
end)

-- ====== HELPERS ======
local function isAlive(chara)
    if not chara then return false end
    local hum = chara:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function worldToScreen(pos)
    local p, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(p.X, p.Y), onScreen, p.Z
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function clamp(val, a, b)
    if val < a then return a end
    if val > b then return b end
    return val
end

-- Raycast helper for wall checking
local function canSee(fromPos, toPos, ignoreCharacter)
    if Config.IgnoreWalls then return true end
    local direction = (toPos - fromPos)
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.IgnoreWater = true
    local result = Workspace:Raycast(fromPos, direction, rayParams)
    if not result then
        return true
    else
        -- If hit something part of target character, it's visible
        if result.Instance and result.Instance:IsDescendantOf(ignoreCharacter) then
            return true
        end
        return false
    end
end

-- Angle between camera look vector and vector to target in degrees
local function angleToTarget(targetPos)
    local look = Camera.CFrame.LookVector
    local dir = (targetPos - Camera.CFrame.Position).Unit
    local dot = clamp(look:Dot(dir), -1, 1)
    return math.deg(math.acos(dot))
end

-- Find closest target within FOV and range
local function getClosestTarget()
    local best = nil
    local bestDist = math.huge
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character and isAlive(pl.Character) then
            local part = pl.Character:FindFirstChild(Config.TargetPart) or pl.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local mag = (part.Position - Camera.CFrame.Position).Magnitude
                if mag <= Config.MaxDistance then
                    local ang = angleToTarget(part.Position)
                    if ang <= (Config.FOV/2) then
                        if canSee(Camera.CFrame.Position, part.Position, pl.Character) then
                            if mag < bestDist then
                                bestDist = mag
                                best = pl
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end

-- Aimbot movement: smoothly rotate camera towards target position
local function aimAtPosition(targetPos, dt)
    if not targetPos then return end
    local cam = Camera
    local currentCFrame = cam.CFrame
    local desired = CFrame.new(currentCFrame.Position, targetPos)
    if Config.LockOn then
        if Config.Smoothness <= 0 then
            cam.CFrame = desired
        else
            -- Interpolate between current look vector and desired look vector
            local t = clamp(Config.Smoothness * (Config.LockStrength or 1), 0, 1)
            -- Slerp using CFrame:Lerp (works for rotation)
            local newCF = currentCFrame:Lerp(desired, t)
            cam.CFrame = newCF
        end
    else
        -- softer following: move camera look vector gradually
        local t = clamp(Config.Smoothness, 0, 1)
        cam.CFrame = currentCFrame:Lerp(desired, t * (Config.LockStrength or 1))
    end
end

-- ====== DRAWING: FOV CIRCLE ======
local fovCircle = NewDrawing("Circle")
if fovCircle then
    fovCircle.Visible = Config.ShowFOV
    fovCircle.Radius = 100
    fovCircle.Filled = false
    fovCircle.Thickness = 2
    fovCircle.NumSides = 90
    fovCircle.Transparency = 1
    fovCircle.Color = Color3.new(1,1,1)
end

-- ====== UPDATE ESP EACH FRAME ======
RunService.RenderStepped:Connect(function(dt)
    -- Update FOV circle visuals
    if fovCircle then
        fovCircle.Visible = Config.ShowFOV
        local scrSize = Camera.ViewportSize
        fovCircle.Position = Vector2.new(scrSize.X/2, scrSize.Y/2)
        -- map FOV degrees to radius proportionally to viewport height
        -- (this is approximate and for visual guidance)
        local radius = (Config.FOV/180) * (scrSize.Y/2)
        fovCircle.Radius = radius
        if Config.FOV_Rainbow then
            fovCircle.Color = Color3.fromHSV((tick()%5)/5,1,1)
        else
            fovCircle.Color = Color3.new(1,1,1)
        end
    end

    -- Count players drawn (avoid too many)
    local drawCount = 0
    for player, draws in pairs(ESPObjects) do
        if drawCount >= Config.MaxESPPlayers then
            -- hide any remaining
            if draws then
                for _, d in pairs(draws) do
                    if d then d.Visible = false end
                end
            end
            continue
        end

        local char = player.Character
        if not Config.ESPEnabled or not char or not isAlive(char) then
            for _, d in pairs(draws) do
                if d then d.Visible = false end
            end
        else
            local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
            if not head then
                for _, d in pairs(draws) do if d then d.Visible = false end end
            else
                local screenPos, onScreen, z = worldToScreen(head.Position)
                if not onScreen then
                    for _, d in pairs(draws) do if d then d.Visible = false end end
                else
                    drawCount = drawCount + 1
                    -- Box size based on distance
                    local dist = (Camera.CFrame.Position - head.Position).Magnitude
                    local scale = clamp(1500 / (dist + 1), 20, 400)
                    -- Box (centered on head)
                    if draws.Box then
                        draws.Box.Size = Vector2.new(scale, scale * 1.6)
                        draws.Box.Position = Vector2.new(screenPos.X - draws.Box.Size.X/2, screenPos.Y - draws.Box.Size.Y/2)
                        draws.Box.Color = Config.BoxColor
                        if Config.ESP_Rainbow then
                            draws.Box.Color = Color3.fromHSV((tick()%5)/5, 1, 1)
                        end
                        draws.Box.Visible = Config.ESP_DrawBox
                    end
                    -- Health bar (vertical on left of box)
                    if draws.Health then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum and Config.ESP_DrawHealth then
                            local hp = clamp(hum.Health / (hum.MaxHealth or 100), 0, 1)
                            local hbHeight = draws.Box.Size.Y * hp
                            draws.Health.Size = Vector2.new(6, hbHeight)
                            draws.Health.Position = Vector2.new(draws.Box.Position.X - 10, draws.Box.Position.Y + (draws.Box.Size.Y - hbHeight))
                            -- gradient by hp
                            local col
                            if hp > 0.66 then
                                col = Config.HealthGradient[1]
                            elseif hp > 0.33 then
                                col = Config.HealthGradient[2]
                            else
                                col = Config.HealthGradient[3]
                            end
                            draws.Health.Color = col
                            draws.Health.Visible = true
                        else
                            draws.Health.Visible = false
                        end
                    end
                    -- Name text
                    if draws.Name then
                        draws.Name.Text = player.Name
                        draws.Name.Position = Vector2.new(screenPos.X, draws.Box.Position.Y - 14)
                        draws.Name.Color = Color3.new(1,1,1)
                        draws.Name.Visible = Config.ESP_DrawName
                    end
                    -- Distance text
                    if draws.Distance then
                        draws.Distance.Text = string.format("%im", math.floor(dist))
                        draws.Distance.Position = Vector2.new(screenPos.X, draws.Box.Position.Y + draws.Box.Size.Y + 6)
                        draws.Distance.Color = Color3.new(1,1,1)
                        draws.Distance.Visible = Config.ESP_DrawDistance
                    end
                    -- Snapline
                    if draws.Snapline then
                        local fromX, fromY
                        if Config.ESP_SnaplinePosition == "Bottom" then
                            fromX = Camera.ViewportSize.X/2
                            fromY = Camera.ViewportSize.Y
                        elseif Config.ESP_SnaplinePosition == "Top" then
                            fromX = Camera.ViewportSize.X/2
                            fromY = 0
                        else
                            fromX = Camera.ViewportSize.X/2
                            fromY = Camera.ViewportSize.Y/2
                        end
                        draws.Snapline.From = Vector2.new(screenPos.X, screenPos.Y + draws.Box.Size.Y/3)
                        draws.Snapline.To = Vector2.new(fromX, fromY)
                        draws.Snapline.Color = Config.SnaplineColor
                        if Config.ESP_Rainbow then
                            draws.Snapline.Color = Color3.fromHSV((tick()%5)/5,1,1)
                        end
                        draws.Snapline.Visible = Config.ESP_Snapline
                    end
                end
            end
        end
    end

    -- Aimbot logic: track target while holding key
    -- We will only aim when AimbotEnabled is true AND the AimKey is held.
    -- We also allow ToggleAimbotKey to toggle the master AimbotEnabled.
    -- Input detection handled elsewhere; here we check InputService state.
    -- We'll use UserInputService:IsMouseButtonPressed for MouseButton2 or InputBegan state via a simple flag.
end)

-- ====== AIM LOOP (separate, to avoid blocking) ======
-- We'll use RenderStepped to perform aiming when active and target exists
local aiming = false -- whether hold key pressed
local aimToggleActive = false -- for toggled on/off mode (we keep Config.AimbotEnabled as master)
-- Track mouse buttons pressed for aim
local mouseDown = false
UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.UserInputType == Config.AimKey then
        mouseDown = true
    elseif inp.KeyCode == Config.ToggleAimbotKey then
        Config.AimbotEnabled = not Config.AimbotEnabled
        -- feedback
        print("[Aimbot] Toggled: ", Config.AimbotEnabled)
    elseif inp.KeyCode == Config.ToggleGuiKey then
        Config.GuiOpen = not Config.GuiOpen
        pcall(function() mainGui.Enabled = Config.GuiOpen end)
    elseif inp.KeyCode == Enum.KeyCode.Home then
        Config.ESPEnabled = not Config.ESPEnabled
        print("[ESP] Toggled:", Config.ESPEnabled)
    end
end)
UserInputService.InputEnded:Connect(function(inp, gpe)
    if inp.UserInputType == Config.AimKey then
        mouseDown = false
    end
end)

RunService.RenderStepped:Connect(function(dt)
    -- Only aim when appropriate:
    local shouldAim = Config.AimbotEnabled and (mouseDown or false)
    if shouldAim then
        local targetPlayer = getClosestTarget()
        if targetPlayer and targetPlayer.Character and isAlive(targetPlayer.Character) then
            local part = targetPlayer.Character:FindFirstChild(Config.TargetPart) or targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if part then
                if Config.IgnoreWalls or canSee(Camera.CFrame.Position, part.Position, targetPlayer.Character) then
                    aimAtPosition(part.Position, dt)
                end
            end
        end
    end
end)

-- ====== SIMPLE GUI: Basic toggles and sliders ======
-- We'll build a small ScreenGui with some toggles. This is basic but functional and draggable.
local StarterGui = game:GetService("StarterGui")

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "DeluxeAimGui"
mainGui.ResetOnSpawn = false
mainGui.Enabled = Config.GuiOpen
mainGui.Parent = CoreGui -- use CoreGui so it's always on top (be careful in some environments)

local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.new(0, 420, 0, 380)
frame.Position = UDim2.new(0, 20, 0, 80)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Parent = mainGui
frame.Active = true
frame.Draggable = true

local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 36)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Deluxe Aimbot v2"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(240,240,240)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Padding = Instance.new("UIPadding", title)
title.Padding.PaddingLeft = UDim.new(0, 12)

local function makeToggle(parent, labelText, getFunc, setFunc, y)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(0, 220, 0, 28)
    lbl.Position = UDim2.new(0, 12, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 16
    lbl.TextColor3 = Color3.fromRGB(220,220,220)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 60, 0, 24)
    btn.Position = UDim2.new(1, -72, 0, y+2)
    btn.BackgroundColor3 = getFunc() and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
    btn.Text = getFunc() and "ON" or "OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(20,20,20)
    btn.MouseButton1Click:Connect(function()
        setFunc(not getFunc())
        btn.BackgroundColor3 = getFunc() and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
        btn.Text = getFunc() and "ON" or "OFF"
    end)
    return {Label = lbl, Button = btn}
end

-- Rows
local y = 46
local toggles = {}
table.insert(toggles, makeToggle(frame, "Aimbot", function() return Config.AimbotEnabled end, function(v) Config.AimbotEnabled = v end, y)); y = y + 36
table.insert(toggles, makeToggle(frame, "ESP", function() return Config.ESPEnabled end, function(v) Config.ESPEnabled = v end, y)); y = y + 36
table.insert(toggles, makeToggle(frame, "Ignore Walls (Penetration)", function() return Config.IgnoreWalls end, function(v) Config.IgnoreWalls = v end, y)); y = y + 36
table.insert(toggles, makeToggle(frame, "Lock-On (Hard)", function() return Config.LockOn end, function(v) Config.LockOn = v end, y)); y = y + 36
table.insert(toggles, makeToggle(frame, "ESP Rainbow", function() return Config.ESP_Rainbow end, function(v) Config.ESP_Rainbow = v end, y)); y = y + 36
table.insert(toggles, makeToggle(frame, "Show FOV", function() return Config.ShowFOV end, function(v) Config.ShowFOV = v end, y)); y = y + 36

-- Slider helper (simple)
local function makeNumberEntry(parent, labelText, getFunc, setFunc, y)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(0, 150, 0, 24)
    lbl.Position = UDim2.new(0, 12, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.fromRGB(220,220,220)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local box = Instance.new("TextBox", parent)
    box.Size = UDim2.new(0, 100, 0, 22)
    box.Position = UDim2.new(1, -120, 0, y)
    box.BackgroundColor3 = Color3.fromRGB(40,40,40)
    box.Text = tostring(getFunc())
    box.ClearTextOnFocus = false
    box.TextColor3 = Color3.fromRGB(220,220,220)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.FocusLost:Connect(function(enter)
        if enter then
            local n = tonumber(box.Text)
            if n then
                setFunc(n)
                box.Text = tostring(getFunc())
            else
                box.Text = tostring(getFunc())
            end
        end
    end)
end

makeNumberEntry(frame, "FOV (deg)", function() return Config.FOV end, function(v) Config.FOV = clamp(v, 10, 360) end, y); y = y + 30
makeNumberEntry(frame, "Max Distance", function() return Config.MaxDistance end, function(v) Config.MaxDistance = clamp(v, 10, 2000) end, y); y = y + 30
makeNumberEntry(frame, "Smoothness (0-1)", function() return Config.Smoothness end, function(v) Config.Smoothness = clamp(v, 0, 1) end, y); y = y + 30

-- Close / quick hints
local hint = Instance.new("TextLabel", frame)
hint.Size = UDim2.new(1, -20, 0, 48)
hint.Position = UDim2.new(0, 10, 1, -58)
hint.BackgroundTransparency = 1
hint.Text = "Right-click to aim (hold). Insert toggles Aimbot. RightShift toggles GUI. Use Home to toggle ESP."
hint.Font = Enum.Font.Gotham
hint.TextSize = 12
hint.TextColor3 = Color3.fromRGB(170,170,170)
hint.TextWrapped = true

-- ====== CLEANUP on disable (optional) ======
local function cleanup()
    -- remove drawing
    if fovCircle then pcall(function() fovCircle:Remove() end) end
    for p, draws in pairs(ESPObjects) do
        for _, d in pairs(draws) do
            if d then
                pcall(function() d:Remove() end)
            end
        end
    end
    ESPObjects = {}
    if mainGui then
        pcall(function() mainGui:Destroy() end)
    end
end

-- Optional: a command to disable and cleanup (type in output console)
_G.DisableDeluxeAimbot = function()
    print("[DeluxeAimbot] Disabling & cleaning up...")
    cleanup()
end

print("[DeluxeAimbot] Loaded. Use Insert to toggle Aimbot, Home to toggle ESP, RightShift to toggle GUI. Use Right Mouse Button to aim while Aimbot is enabled.")
