local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character, hrp
local flying = false
local speed = 80
local moveDir = Vector3.new(0,0,0)

-- Hàm lấy HumanoidRootPart an toàn (R6 / R15)
local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
end

local function onCharacterAdded(char)
    character = char
    hrp = getRoot(char)
end

onCharacterAdded(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(onCharacterAdded)

if player.PlayerGui:FindFirstChild("FlyGui") then
    player.PlayerGui.FlyGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Nút bật/tắt bay
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 120, 0, 50)
toggleBtn.Position = UDim2.new(0.05, 0, 0.8, 0)
toggleBtn.Text = "🚀 Bay"
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Parent = screenGui
toggleBtn.BorderSizePixel = 3
toggleBtn.BorderColor3 = Color3.fromRGB(255,255,255)
toggleBtn.BackgroundTransparency = 0.2

-- Nút bay lên
local upBtn = Instance.new("TextButton")
upBtn.Size = UDim2.new(0, 80, 0, 50)
upBtn.Position = UDim2.new(0.8, 0, 0.65, 0)
upBtn.Text = "⬆️ Up"
upBtn.TextScaled = true
upBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
upBtn.TextColor3 = Color3.new(1,1,1)
upBtn.Parent = screenGui
upBtn.Visible = false

-- Nút bay xuống
local downBtn = Instance.new("TextButton")
downBtn.Size = UDim2.new(0, 80, 0, 50)
downBtn.Position = UDim2.new(0.8, 0, 0.75, 0)
downBtn.Text = "⬇️ Down"
downBtn.TextScaled = true
downBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
downBtn.TextColor3 = Color3.new(1,1,1)
downBtn.Parent = screenGui
downBtn.Visible = false

-- Hiển thị tốc độ
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0,120,0,30)
speedLabel.Position = UDim2.new(0.05,0,0.7,0)
speedLabel.BackgroundTransparency = 0.3
speedLabel.BackgroundColor3 = Color3.fromRGB(50,50,50)
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.TextScaled = true
speedLabel.Text = "Speed: "..speed
speedLabel.Parent = screenGui
speedLabel.Visible = false

-- Nút tăng tốc độ
local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0,50,0,30)
plusBtn.Position = UDim2.new(0.05,0,0.65,0)
plusBtn.Text = "+"
plusBtn.TextScaled = true
plusBtn.BackgroundColor3 = Color3.fromRGB(0,200,200)
plusBtn.TextColor3 = Color3.new(1,1,1)
plusBtn.Parent = screenGui
plusBtn.Visible = false

-- Nút giảm tốc độ
local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0,50,0,30)
minusBtn.Position = UDim2.new(0.15,0,0.65,0)
minusBtn.Text = "-"
minusBtn.TextScaled = true
minusBtn.BackgroundColor3 = Color3.fromRGB(200,100,0)
minusBtn.TextColor3 = Color3.new(1,1,1)
minusBtn.Parent = screenGui
minusBtn.Visible = false

-- Toggle fly
toggleBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        toggleBtn.Text = "🛑 Stop"
        upBtn.Visible = true
        downBtn.Visible = true
        plusBtn.Visible = true
        minusBtn.Visible = true
        speedLabel.Visible = true
    else
        toggleBtn.Text = "🚀 Bay"
        upBtn.Visible = false
        downBtn.Visible = false
        plusBtn.Visible = false
        minusBtn.Visible = false
        speedLabel.Visible = false
        moveDir = Vector3.new(0,0,0)
        if hrp then
            hrp.Velocity = Vector3.new(0,0,0)
        end
    end
end)

-- Giữ nút để bay lên/xuống
local upHeld, downHeld = false, false

upBtn.MouseButton1Down:Connect(function() upHeld = true end)
upBtn.MouseButton1Up:Connect(function() upHeld = false end)
downBtn.MouseButton1Down:Connect(function() downHeld = true end)
downBtn.MouseButton1Up:Connect(function() downHeld = false end)

-- Nút chỉnh tốc độ
plusBtn.MouseButton1Click:Connect(function()
    speed = speed + 20
    speedLabel.Text = "Speed: "..speed
end)
minusBtn.MouseButton1Click:Connect(function()
    if speed > 20 then
        speed = speed - 20
        speedLabel.Text = "Speed: "..speed
    end
end)

-- Điều khiển bay
RS.RenderStepped:Connect(function()
    if flying and hrp then
        local cam = workspace.CurrentCamera
        local dir = Vector3.new()

        -- Di chuyển bằng WASD
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            dir = dir + cam.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            dir = dir - cam.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            dir = dir - cam.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            dir = dir + cam.CFrame.RightVector
        end
        if upHeld then
            dir = dir + Vector3.new(0,1,0)
        end
        if downHeld then
            dir = dir + Vector3.new(0,-1,0)
        end

        if dir.Magnitude > 0 then
            hrp.Velocity = dir.Unit * speed
        else
            hrp.Velocity = Vector3.new(0,0,0)
        end
    end

end)

-- Bảng thông tin cá nhân hiển thị trong 10 giây rồi tự ẩn
local infoGui = Instance.new("ScreenGui")
local infoFrame = Instance.new("Frame")
local infoText = Instance.new("TextLabel")

infoGui.Name = "ThongTinAdmin"
infoGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
infoGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
infoGui.ResetOnSpawn = false

infoFrame.Parent = infoGui
infoFrame.BackgroundColor3 = Color3.fromRGB(50, 200, 255)
infoFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
infoFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
infoFrame.Size = UDim2.new(0, 300, 0, 150)
infoFrame.BackgroundTransparency = 0.1
infoFrame.Active = true
infoFrame.Draggable = true

infoText.Parent = infoFrame
infoText.Size = UDim2.new(1, 0, 1, 0)
infoText.BackgroundTransparency = 1
infoText.Font = Enum.Font.SourceSansBold
infoText.TextColor3 = Color3.fromRGB(0, 0, 0)
infoText.TextScaled = true
infoText.Text = "THÔNG TIN ADMIN \n\nADMIN: MinhFansub\nPhiên bản: 1.0\nLiên hệ https://www.facebook.com/minh.fansub"
infoText.TextWrapped = true

-- Tự động ẩn bảng sau 10 giây
delay(10, function()
	infoGui:Destroy()
end)

