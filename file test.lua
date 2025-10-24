--[[ 
📦 MINHFANSUB VIP – AFK + FPS BOOST UI (NEW DESIGN)

✨ TÍNH NĂNG:
+ Auto AFK tránh kick
+ Hiển thị FPS + thời gian AFK
+ FPS Boost (giảm lag)
+ Ẩn/hiện UI bằng [V] (PC) hoặc nút 👁️ (Mobile)
+ Prime Vip Header màu xanh lá
+ UI đẹp, bo góc, kéo thả
]]

--== Dịch vụ ==--
local plr = game:GetService("Players").LocalPlayer
local cam = workspace.CurrentCamera
local vu = game:GetService("VirtualUser")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

--== GUI Gốc ==--
local gui = Instance.new("ScreenGui")
gui.Name = "PrimeVipUI"
gui.Parent = plr:WaitForChild("PlayerGui")

-- Nút 👁️ (Mobile)
local toggleButton = Instance.new("ImageButton", gui)
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(1, -50, 1, -50)
toggleButton.Image = "rbxassetid://6034287594"
toggleButton.BackgroundTransparency = 1

-- Chống kick AFK
plr.Idled:Connect(function()
    vu:Button2Down(Vector2.new(), cam.CFrame)
    wait(0.5)
    vu:Button2Up(Vector2.new(), cam.CFrame)
end)

--== Khung chính ==--
local f = Instance.new("Frame", gui)
f.Size = UDim2.new(0, 250, 0, 230)
f.Position = UDim2.new(0, 30, 0, 30)
f.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
f.Active = true f.Draggable = true
Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", f).Color = Color3.fromRGB(60, 200, 100)

--== Header AFK Vip ==--
local header = Instance.new("TextLabel", f)
header.Size = UDim2.new(1, -10, 0, 30)
header.Position = UDim2.new(0, 5, 0, 5)
header.Text = "AFK VIP"
header.Font = Enum.Font.GothamBlack
header.TextScaled = true
header.BackgroundTransparency = 1
header.TextColor3 = Color3.fromRGB(60, 255, 100)
header.TextStrokeTransparency = 0.3

local close = Instance.new("TextButton", f)
close.Size = UDim2.new(0, 28, 0, 28)
close.Position = UDim2.new(1, -35, 0, 5)
close.Text = "X"
close.TextScaled = true
close.BackgroundColor3 = Color3.fromRGB(200,60,60)
close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", close)
close.MouseButton1Click:Connect(function() f:Destroy() end)

--== Thông tin ==--
local timer = Instance.new("TextLabel", f)
timer.Position = UDim2.new(0, 10, 0, 45)
timer.Size = UDim2.new(1, -20, 0, 28)
timer.Text = "AFK: 300s"
timer.BackgroundColor3 = Color3.fromRGB(40,40,50)
timer.TextColor3 = Color3.new(1,1,1)
timer.Font = Enum.Font.GothamBold
timer.TextScaled = true
Instance.new("UICorner", timer)

local totalTime = Instance.new("TextLabel", f)
totalTime.Position = UDim2.new(0, 10, 0, 80)
totalTime.Size = UDim2.new(1, -20, 0, 25)
totalTime.Text = "🕒 Tổng thời gian AFK: 0 phút"
totalTime.BackgroundTransparency = 1
totalTime.TextColor3 = Color3.fromRGB(200, 200, 200)
totalTime.Font = Enum.Font.GothamSemibold
totalTime.TextScaled = true

local fps = Instance.new("TextLabel", f)
fps.Position = UDim2.new(0, 10, 0, 110)
fps.Size = UDim2.new(1, -20, 0, 28)
fps.Text = "FPS: 0"
fps.BackgroundColor3 = Color3.fromRGB(40,40,45)
fps.TextColor3 = Color3.fromRGB(100,255,100)
fps.Font = Enum.Font.GothamBold
fps.TextScaled = true
Instance.new("UICorner", fps)

--== Nút FPS Boost ==--
local toggle = Instance.new("TextButton", f)
toggle.Position = UDim2.new(0, 10, 0, 145)
toggle.Size = UDim2.new(1, -20, 0, 30)
toggle.Text = "🟢 Bật FPS Boost"
toggle.BackgroundColor3 = Color3.fromRGB(50,120,50)
toggle.Font = Enum.Font.GothamBold
toggle.TextScaled = true
toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", toggle)

-- Ghi chú
local note = Instance.new("TextLabel", f)
note.Position = UDim2.new(0, 10, 0, 185)
note.Size = UDim2.new(1, -20, 0, 40)
note.Text = " MINHFANSUB"
note.TextColor3 = Color3.fromRGB(180, 180, 180)
note.BackgroundTransparency = 1
note.Font = Enum.Font.GothamSemibold
note.TextScaled = true
note.TextWrapped = true

--== FPS Counter ==--
local count, last = 0, tick()
rs.RenderStepped:Connect(function()
    count += 1
    if tick() - last >= 1 then
        fps.Text = "FPS: " .. count
        count = 0
        last = tick()
    end
end)

--== FPS Boost Functions ==--
local function boost()
    local Lighting = game:GetService("Lighting")
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    Lighting.GlobalShadows = false
    Lighting.Brightness = 0
    Lighting.FogEnd = 1e9
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") or v:IsA("Sound") then pcall(function() v:Destroy() end) end
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled = false end
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
            v.CastShadow = false
        end
    end
end

local function unboost()
    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = true
    Lighting.Brightness = 2
    Lighting.FogEnd = 1000
end

local boosted = false
toggle.MouseButton1Click:Connect(function()
    if not boosted then
        boost()
        toggle.Text = "🔴 Tắt FPS Boost"
        toggle.BackgroundColor3 = Color3.fromRGB(150,60,60)
    else
        unboost()
        toggle.Text = "🟢 Bật FPS Boost"
        toggle.BackgroundColor3 = Color3.fromRGB(50,120,50)
    end
    boosted = not boosted
end)

--== Toggle UI ==--
local function toggleUI() f.Visible = not f.Visible end
toggleButton.MouseButton1Click:Connect(toggleUI)
uis.InputBegan:Connect(function(input, g)
    if not g and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.V then
        toggleUI()
    end
end)

--== AFK Timer ==--
local totalMinutes = 0
spawn(function()
    while true do
        local t = 60  -- Thay đổi thời gian đếm ngược thành 60 giây
        for i = t, 0, -1 do
            if f.Visible then
                timer.Text = "AFK: "..i.."s"
                totalTime.Text = "🕒 Tổng thời gian AFK: " .. tostring(totalMinutes) .. " phút"
            end
            wait(1)
        end
        totalMinutes += math.floor(t / 60)  -- Cộng thêm phút
        cam.CFrame *= CFrame.Angles(0, math.rad(math.random(3, 6)), 0)
        vu:Button2Down(Vector2.new(), cam.CFrame)
        wait(math.random(0.4, 0.8))
        vu:Button2Up(Vector2.new(), cam.CFrame)
    end
end)
