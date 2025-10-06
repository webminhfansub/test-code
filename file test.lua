-- Script bay with fixed key system + Nút dẫn đến trang web
local FIXED_KEY = "MINHVIP123"  -- <-- thay key cố định ở đây
local WEB_URL = "https://webminhfansub.github.io/caclienketxin/"  -- <-- thay link bạn muốn
local MAX_ATTEMPTS = 3

-- KEY GUI (hiển thị trước, chặn mọi thứ cho đến khi nhập đúng key)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local keyGui = Instance.new("ScreenGui")
keyGui.Name = "KeyCheckGui"
keyGui.ResetOnSpawn = false
keyGui.Parent = playerGui
keyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 420, 0, 200)
frame.Position = UDim2.new(0.5, -210, 0.4, -100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.Parent = keyGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 36)
title.Position = UDim2.new(0, 0, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Nhập Key để sử dụng script"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextColor3 = Color3.new(1,1,1)
title.Parent = frame

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0.9, 0, 0, 40)
inputBox.Position = UDim2.new(0.05, 0, 0, 56)
inputBox.PlaceholderText = "Nhập key..."
inputBox.ClearTextOnFocus = false
inputBox.Text = ""
inputBox.Font = Enum.Font.SourceSans
inputBox.TextSize = 18
inputBox.Parent = frame

local okBtn = Instance.new("TextButton")
okBtn.Size = UDim2.new(0.4, 0, 0, 36)
okBtn.Position = UDim2.new(0.05, 0, 0, 104)
okBtn.Text = "Xác nhận"
okBtn.Font = Enum.Font.SourceSansBold
okBtn.TextSize = 18
okBtn.Parent = frame
okBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
okBtn.TextColor3 = Color3.new(1,1,1)
okBtn.BorderSizePixel = 0

local cancelBtn = Instance.new("TextButton")
cancelBtn.Size = UDim2.new(0.4, 0, 0, 36)
cancelBtn.Position = UDim2.new(0.55, 0, 0, 104)
cancelBtn.Text = "Thoát"
cancelBtn.Font = Enum.Font.SourceSansBold
cancelBtn.TextSize = 18
cancelBtn.Parent = frame
cancelBtn.BackgroundColor3 = Color3.fromRGB(180,40,40)
cancelBtn.TextColor3 = Color3.new(1,1,1)
cancelBtn.BorderSizePixel = 0

-- 🌐 Nút dẫn đến trang web
local webBtn = Instance.new("TextButton")
webBtn.Size = UDim2.new(0.9, 0, 0, 36)
webBtn.Position = UDim2.new(0.05, 0, 0, 150)
webBtn.Text = "🌐 Truy cập trang web"
webBtn.Font = Enum.Font.SourceSansBold
webBtn.TextSize = 18
webBtn.Parent = frame
webBtn.BackgroundColor3 = Color3.fromRGB(70, 200, 70)
webBtn.TextColor3 = Color3.new(1,1,1)
webBtn.BorderSizePixel = 0

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 24)
statusLabel.Position = UDim2.new(0, 10, 0, 186)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.Font = Enum.Font.SourceSansItalic
statusLabel.TextSize = 16
statusLabel.TextColor3 = Color3.fromRGB(255,200,100)
statusLabel.Parent = frame

-- Xử lý nút truy cập trang web
webBtn.MouseButton1Click:Connect(function()
    setclipboard(WEB_URL)
    statusLabel.Text = "🔗 Link đã được sao chép! Dán vào trình duyệt để mở."
end)

local attempts = 0

-- === Phần chạy script chính ===
local function startMain()
    if keyGui then keyGui:Destroy() end
    -- ⚙️ Gọi script bay chính ở đây (bạn giữ nguyên phần cũ)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/webminhfansub/scriptbay/refs/heads/main/.lua"))() -- <-- hoặc dán code bay ở đây
end

-- Kiểm tra key
local function tryKey()
    local entered = tostring(inputBox.Text or "")
    attempts += 1
    if entered == FIXED_KEY then
        statusLabel.Text = "✅ Key hợp lệ. Đang khởi tạo..."
        wait(0.6)
        startMain()
    else
        local left = MAX_ATTEMPTS - attempts
        if left > 0 then
            statusLabel.Text = "❌ Key sai. Còn "..left.." lần thử."
        else
            statusLabel.Text = "❌ Sai quá nhiều. Đã đóng GUI."
            wait(1)
            if keyGui then keyGui:Destroy() end
        end
    end
end

okBtn.MouseButton1Click:Connect(tryKey)
inputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then tryKey() end
end)
cancelBtn.MouseButton1Click:Connect(function()
    if keyGui then keyGui:Destroy() end
end)

