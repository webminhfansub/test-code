-- script with fixed key system (Roblox)
-- Thay key ở dòng dưới nếu cần
local FIXED_KEY = "MINHVIP123"

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

-- Nếu character đã có sẵn thì gọi ngay, đồng thời lắng nghe CharacterAdded
if player.Character then
    onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)

-- KEY GUI (Yêu cầu nhập key, KHÔNG cho chạy script nếu sai)
local keyGui = Instance.new("ScreenGui")
keyGui.Name = "KeyCheckGui"
keyGui.ResetOnSpawn = false
keyGui.Parent = player:WaitForChild("PlayerGui")
keyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 420, 0, 180)
frame.Position = UDim2.new(0.5, -210, 0.4, -90)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.Parent = keyGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 36)
title.Position = UDim2.new(0, 0, 0, 6)
title.BackgroundTransparency = 1
title.Text = "Nhập Key để sử dụng script"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextColor3 = Color3.new(1,1,1)
title.Parent = frame

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0.9, 0, 0, 40)
inputBox.Position = UDim2.new(0.05, 0, 0, 52)
inputBox.PlaceholderText = "Nhập key..."
inputBox.ClearTextOnFocus = false
inputBox.Text = ""
inputBox.TextScaled = false
inputBox.Font = Enum.Font.SourceSans
inputBox.TextSize = 18
inputBox.Parent = frame

local okBtn = Instance.new("TextButton")
okBtn.Size = UDim2.new(0.4, 0, 0, 38)
okBtn.Position = UDim2.new(0.05, 0, 0, 100)
okBtn.Text = "Xác nhận"
okBtn.Font = Enum.Font.SourceSansBold
okBtn.TextSize = 18
okBtn.Parent = frame
okBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
okBtn.TextColor3 = Color3.new(1,1,1)
okBtn.BorderSizePixel = 0

local cancelBtn = Instance.new("TextButton")
cancelBtn.Size = UDim2.new(0.4, 0, 0, 38)
cancelBtn.Position = UDim2.new(0.55, 0, 0, 100)
cancelBtn.Text = "Thoát"
cancelBtn.Font = Enum.Font.SourceSansBold
cancelBtn.TextSize = 18
cancelBtn.Parent = frame
cancelBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
cancelBtn.TextColor3 = Color3.new(1,1,1)
cancelBtn.BorderSizePixel = 0

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 24)
statusLabel.Position = UDim2.new(0, 10, 0, 144)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.Font = Enum.Font.SourceSansItalic
statusLabel.TextSize = 16
statusLabel.TextColor3 = Color3.fromRGB(255,200,100)
statusLabel.Parent = frame

-- Một số giới hạn (tuỳ ý)
local MAX_ATTEMPTS = 3
local attempts = 0

local function startMain()
    -- Khi key hợp lệ, xoá GUI kiểm tra và chạy phần logic chính
    if keyGui then
        keyGui:Destroy()
    end

    -- === BẮT ĐẦU: phần logic gốc (fly GUI + điều khiển) ===

    -- nếu đã có FlyGui trước đó thì destroy để tránh trùng
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
        if infoGui and infoGui.Parent then
            infoGui:Destroy()
        end
    end)

    -- === KẾT THÚC: phần logic gốc ===
end

-- Xử lý nút Key GUI
okBtn.MouseButton1Click:Connect(function()
    local entered = tostring(inputBox.Text or "")
    attempts = attempts + 1
    if entered == FIXED_KEY then
        statusLabel.Text = "✅ Key hợp lệ. Đang khởi tạo..."
        wait(0.6)
        startMain()
    else
        local left = MAX_ATTEMPTS - attempts
        if left > 0 then
            statusLabel.Text = "❌ Key sai. Còn "..left.." lần thử."
        else
            statusLabel.Text = "❌ Bạn đã nhập sai quá số lần. Đã thoát."
            wait(1)
            -- Nếu muốn kick player khỏi game khi nhập sai nhiều lần, bật dòng dưới
            -- player:Kick("Nhập sai key quá số lần.")
            if keyGui then keyGui:Destroy() end
        end
    end
end)

cancelBtn.MouseButton1Click:Connect(function()
    if keyGui then keyGui:Destroy() end
    -- Nếu muốn ngắt script hoàn toàn, bạn có thể kick player hoặc không làm gì
    -- player:Kick("Đã hủy.")
end)

-- Cho phép người dùng nhấn Enter để xác nhận
inputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        okBtn.MouseButton1Click:Fire()
    end
end)
