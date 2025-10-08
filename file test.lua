--[=[
Safe "Script Aggregator Launcher" — Confirmation & Preview (Option 2)

Behavior summary:
- This launcher still NEVER executes remote code.
- When a user clicks the "Copy/Run" button for a hub, a confirmation dialog appears showing the hub URL and short instructions.
- If the user confirms "Run Anyway", the launcher will copy the URL to the clipboard and optionally display safe manual steps for running the code (inspect first, paste into an Approved ModuleScript, then require it).
- This gives the UX of "click -> run" while forcing a manual inspection step and avoiding any automatic loadstring/fetch/execute.

Instructions:
- Place this LocalScript in StarterPlayerScripts or where your UI runs.
- Optionally create ReplicatedStorage/ApprovedModules to run internal modules (the launcher will not do that automatically).
]=]

local Hubs = {
    {name = "Blue-X", url = "https://raw.githubusercontent.com/Dev-BlueX/BlueX-Hub/refs/heads/main/Main.lua", tag = "General", moduleName = nil},
    {name = "Quantum-Hub", url = "https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua", tag = "General", moduleName = nil},
    {name = "Cokka-Hub", url = "https://raw.githubusercontent.com/UserDevEthical/Loadstring/main/CokkaHub.lua", tag = "Utility", moduleName = nil},
    {name = "Ldt-Hub", url = "https://raw.githubusercontent.com/thohihi312-coder/ldt-hub/refs/heads/main/main.lua.txt", tag = "General", moduleName = nil},
    {name = "Vector-Hub", url = "https://raw.githubusercontent.com/AAwful/Vector_Hub/0/v2", tag = "Combat", moduleName = nil},
}

-- Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

-- Cleanup old GUI
if PlayerGui:FindFirstChild("SafeScriptLauncher") then
    PlayerGui.SafeScriptLauncher:Destroy()
end

-- Root ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SafeScriptLauncher"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Main container (centered)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, 520, 0, 540)
mainFrame.Position = UDim2.new(0.5, -260, 0.12, 0)
mainFrame.BackgroundTransparency = 0
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 14)

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 78)
header.BackgroundTransparency = 0
header.BackgroundColor3 = Color3.fromRGB(28,28,30)
header.BorderSizePixel = 0
header.Parent = mainFrame
local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 0, 30)
title.Position = UDim2.new(0, 84, 0, 12)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(240,240,240)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "Script Launcher — Trình quản lý links"
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -100, 0, 20)
subtitle.Position = UDim2.new(0, 84, 0, 36)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 14
subtitle.TextColor3 = Color3.fromRGB(170,170,170)
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Text = "An toàn: luôn xem trước URL và mã — Không tự động thực thi"
subtitle.Parent = header

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -48, 0, 14)
closeBtn.BackgroundColor3 = Color3.fromRGB(220,70,70)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Parent = header
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0,8)
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Search box
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0.6, -20, 0, 36)
searchBox.Position = UDim2.new(0, 16, 0, 92)
searchBox.BackgroundColor3 = Color3.fromRGB(24,24,26)
searchBox.TextColor3 = Color3.fromRGB(220,220,220)
searchBox.PlaceholderText = "Tìm kiếm tên hub hoặc tag... / Search hubs or tags"
searchBox.ClearTextOnFocus = false
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 14
searchBox.BorderSizePixel = 0
searchBox.Parent = mainFrame
local sbCorner = Instance.new("UICorner", searchBox)
sbCorner.CornerRadius = UDim.new(0,8)

-- Body: scrolling list
local bodyFrame = Instance.new("Frame")
bodyFrame.Size = UDim2.new(1, -32, 0, 360)
bodyFrame.Position = UDim2.new(0, 16, 0, 140)
bodyFrame.BackgroundTransparency = 1
bodyFrame.Parent = mainFrame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 8
scroll.BackgroundTransparency = 1
scroll.Parent = bodyFrame
local uiList = Instance.new("UIListLayout", scroll)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 10)

-- Helper to create a modal dialog
local function createModal(titleText)
    local modal = Instance.new("Frame")
    modal.Size = UDim2.new(0, 560, 0, 220)
    modal.Position = UDim2.new(0.5, -280, 0.5, -110)
    modal.BackgroundColor3 = Color3.fromRGB(22,22,24)
    modal.BorderSizePixel = 0
    modal.Parent = screenGui
    modal.ZIndex = 50
    local mcorner = Instance.new("UICorner", modal)
    mcorner.CornerRadius = UDim.new(0, 10)

    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -28, 0, 28)
    t.Position = UDim2.new(0, 14, 0, 12)
    t.BackgroundTransparency = 1
    t.Font = Enum.Font.GothamBold
    t.TextSize = 16
    t.TextColor3 = Color3.fromRGB(240,240,240)
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Text = titleText
    t.Parent = modal

    return modal
end

local function makeHubCard(hub, index)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -8, 0, 66)
    card.BackgroundColor3 = Color3.fromRGB(30,30,32)
    card.BorderSizePixel = 0
    card.Parent = scroll
    card.LayoutOrder = index
    local cardCorner = Instance.new("UICorner", card)
    cardCorner.CornerRadius = UDim.new(0,10)

    local thumb = Instance.new("TextLabel")
    thumb.Size = UDim2.new(0, 46, 0, 46)
    thumb.Position = UDim2.new(0, 10, 0, 10)
    thumb.BackgroundColor3 = Color3.fromRGB(48,48,50)
    thumb.Text = string.sub(hub.name,1,2):upper()
    thumb.TextColor3 = Color3.fromRGB(230,230,230)
    thumb.Font = Enum.Font.GothamBold
    thumb.TextSize = 18
    thumb.BorderSizePixel = 0
    thumb.Parent = card
    local thumbCorner = Instance.new("UICorner", thumb)
    thumbCorner.CornerRadius = UDim.new(0,8)

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0.6, -20, 0, 22)
    nameLbl.Position = UDim2.new(0, 72, 0, 12)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 16
    nameLbl.TextColor3 = Color3.fromRGB(245,245,245)
    nameLbl.Text = hub.name
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = card

    local tagLbl = Instance.new("TextLabel")
    tagLbl.Size = UDim2.new(0.24, -20, 0, 18)
    tagLbl.Position = UDim2.new(0.72, 0, 0, 12)
    tagLbl.BackgroundColor3 = Color3.fromRGB(40,40,42)
    tagLbl.Font = Enum.Font.Gotham
    tagLbl.TextSize = 12
    tagLbl.TextColor3 = Color3.fromRGB(200,200,200)
    tagLbl.Text = hub.tag or "Unknown"
    tagLbl.Parent = card
    local tagCorner = Instance.new("UICorner", tagLbl)
    tagCorner.CornerRadius = UDim.new(0,6)

    local urlPreview = Instance.new("TextLabel")
    urlPreview.Size = UDim2.new(1, -92, 0, 18)
    urlPreview.Position = UDim2.new(0, 72, 0, 36)
    urlPreview.BackgroundTransparency = 1
    urlPreview.Font = Enum.Font.Gotham
    urlPreview.TextSize = 12
    urlPreview.TextColor3 = Color3.fromRGB(170,170,170)
    urlPreview.TextXAlignment = Enum.TextXAlignment.Left
    urlPreview.TextTruncate = Enum.TextTruncate.AtEnd
    urlPreview.Text = hub.url
    urlPreview.Parent = card

    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0, 72, 0, 32)
    copyBtn.Position = UDim2.new(1, -84, 0, 18)
    copyBtn.BackgroundColor3 = Color3.fromRGB(60,120,240)
    copyBtn.BorderSizePixel = 0
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.TextSize = 14
    copyBtn.TextColor3 = Color3.fromRGB(255,255,255)
    copyBtn.Text = "Copy / Run"
    copyBtn.Parent = card
    local copyCorner = Instance.new("UICorner", copyBtn)
    copyCorner.CornerRadius = UDim.new(0,6)

    -- Hover effect
    card.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(36,36,38)}):Play()
    end)
    card.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(30,30,32)}):Play()
    end)

    -- On click: open confirmation modal with URL preview and instructions
    copyBtn.MouseButton1Click:Connect(function()
        local modal = createModal("Xác nhận: Sao chép / Chạy (Preview)")

        -- URL label
        local urlLabel = Instance.new("TextLabel")
        urlLabel.Size = UDim2.new(1, -28, 0, 18)
        urlLabel.Position = UDim2.new(0, 14, 0, 48)
        urlLabel.BackgroundTransparency = 1
        urlLabel.Font = Enum.Font.Gotham
        urlLabel.TextSize = 13
        urlLabel.TextColor3 = Color3.fromRGB(200,200,200)
        urlLabel.TextXAlignment = Enum.TextXAlignment.Left
        urlLabel.Text = "URL:"
        urlLabel.Parent = modal

        local urlBox = Instance.new("TextBox")
        urlBox.Size = UDim2.new(1, -28, 0, 60)
        urlBox.Position = UDim2.new(0, 14, 0, 68)
        urlBox.BackgroundColor3 = Color3.fromRGB(18,18,20)
        urlBox.TextColor3 = Color3.fromRGB(220,220,220)
        urlBox.Font = Enum.Font.Gotham
        urlBox.TextSize = 13
        urlBox.Text = hub.url
        urlBox.ClearTextOnFocus = false
        urlBox.TextXAlignment = Enum.TextXAlignment.Left
        urlBox.TextWrapped = true
        urlBox.Parent = modal

        -- Instruction text
        local instr = Instance.new("TextLabel")
        instr.Size = UDim2.new(1, -28, 0, 28)
        instr.Position = UDim2.new(0, 14, 0, 136)
        instr.BackgroundTransparency = 1
        instr.Font = Enum.Font.Gotham
        instr.TextSize = 12
        instr.TextColor3 = Color3.fromRGB(170,170,170)
        instr.Text = "HỆ THỐNG KHÔNG TỰ CHẠY: Hãy kiểm tra mã trước khi chạy. Copy URL hoặc nội dung và dán vào ModuleScript Approved để chạy an toàn."
        instr.TextXAlignment = Enum.TextXAlignment.Left
        instr.TextWrapped = true
        instr.Parent = modal

        -- Buttons: Run Anyway (copy) & Cancel
        local runBtn = Instance.new("TextButton")
        runBtn.Size = UDim2.new(0, 120, 0, 32)
        runBtn.Position = UDim2.new(1, -140, 1, -44)
        runBtn.BackgroundColor3 = Color3.fromRGB(60,160,90)
        runBtn.Text = "Run Anyway (Copy)"
        runBtn.Font = Enum.Font.GothamBold
        runBtn.TextSize = 14
        runBtn.TextColor3 = Color3.fromRGB(255,255,255)
        runBtn.Parent = modal
        local runCorner = Instance.new("UICorner", runBtn)
        runCorner.CornerRadius = UDim.new(0,6)

        local cancelBtn = Instance.new("TextButton")
        cancelBtn.Size = UDim2.new(0, 84, 0, 32)
        cancelBtn.Position = UDim2.new(1, -260, 1, -44)
        cancelBtn.BackgroundColor3 = Color3.fromRGB(200,80,80)
        cancelBtn.Text = "Cancel"
        cancelBtn.Font = Enum.Font.GothamBold
        cancelBtn.TextSize = 14
        cancelBtn.TextColor3 = Color3.fromRGB(255,255,255)
        cancelBtn.Parent = modal
        local cCorner = Instance.new("UICorner", cancelBtn)
        cCorner.CornerRadius = UDim.new(0,6)

        cancelBtn.MouseButton1Click:Connect(function()
            modal:Destroy()
        end)

        runBtn.MouseButton1Click:Connect(function()
            -- SAFE ACTION: copy URL to clipboard and show step-by-step instructions
            local ok = pcall(function() setclipboard(hub.url) end)
            if ok then
                local notif = Instance.new("TextLabel")
                notif.Size = UDim2.new(0, 220, 0, 36)
                notif.Position = UDim2.new(0.5, -110, 0.5, 120)
                notif.BackgroundColor3 = Color3.fromRGB(20,20,20)
                notif.TextColor3 = Color3.fromRGB(220,220,220)
                notif.Font = Enum.Font.Gotham
                notif.TextSize = 14
                notif.Text = "URL đã được copy vào clipboard. Kiểm tra trước khi chạy."
                notif.Parent = screenGui
                local nc = Instance.new("UICorner", notif)
                nc.CornerRadius = UDim.new(0,8)
                Debris:AddItem(notif, 3)
            else
                -- fallback: show dialog with URL textbox (already visible) and instruction
                local fallbackNote = Instance.new("TextLabel")
                fallbackNote.Size = UDim2.new(0, 320, 0, 36)
                fallbackNote.Position = UDim2.new(0.5, -160, 0.5, 120)
                fallbackNote.BackgroundColor3 = Color3.fromRGB(20,20,20)
                fallbackNote.TextColor3 = Color3.fromRGB(220,220,220)
                fallbackNote.Font = Enum.Font.Gotham
                fallbackNote.TextSize = 14
                fallbackNote.Text = "Không thể copy tự động. Vui lòng sao chép thủ công từ ô URL."
                fallbackNote.Parent = screenGui
                local fc = Instance.new("UICorner", fallbackNote)
                fc.CornerRadius = UDim.new(0,8)
                Debris:AddItem(fallbackNote, 4)
            end

            -- Provide explicit next-step instructions inside the modal (replace or append)
            instr.Text = "Bước an toàn: 1) Mở URL và kiểm tra code. 2) Tạo ModuleScript trong ReplicatedStorage/ApprovedModules. 3) Dán mã đã kiểm tra vào ModuleScript và lưu. 4) Dùng launcher hoặc require() nội bộ để chạy module."

            -- Optionally keep modal open so user can copy/paste code manually; we won't auto-execute.
        end)
    end)

    return card
end

-- Populate list
for i, hub in ipairs(Hubs) do
    local c = makeHubCard(hub, i)
    c.LayoutOrder = i
end

-- Update scroll canvas size when content changes
uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y + 12)
end)

-- Simple search/filter
local function matches(hub, query)
    if query == "" then return true end
    local q = string.lower(query)
    if string.find(string.lower(hub.name), q, 1, true) then return true end
    if string.find(string.lower(hub.tag or ""), q, 1, true) then return true end
    if string.find(string.lower(hub.url), q, 1, true) then return true end
    return false
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    local order = 1
    for i, hub in ipairs(Hubs) do
        if matches(hub, searchBox.Text) then
            local card = makeHubCard(hub, order)
            card.LayoutOrder = order
            order = order + 1
        end
    end
    uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Wait()
    scroll.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y + 12)
end)

print("SafeScriptLauncher (Preview modal) loaded. Clicking 'Copy / Run' opens a confirmation dialog instead of auto-executing.")
