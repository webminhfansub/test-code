--[=[
Safe "Script Aggregator Launcher" — Enhanced UI

Notes:
- This file remains SAFE: it only shows hub names/URLs and never executes remote code.
- Improvements: dark glass UI, header with icon, search filter, categories, scrolling list, hover effects, thumbnails (placeholders), copy-to-clipboard and in-GUI URL preview.
- Text is bilingual (Vietnamese + English) in labels.

Usage: paste into a LocalScript inside StarterPlayerScripts or run in an environment where PlayerGui and setclipboard are allowed.
]=]

local Hubs = {
    {name = "Blue-X", url = "https://raw.githubusercontent.com/Dev-BlueX/BlueX-Hub/refs/heads/main/Main.lua", tag = "General"},
    {name = "Quantum-Hub", url = "https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua", tag = "General"},
    {name = "Cokka-Hub", url = "https://raw.githubusercontent.com/UserDevEthical/Loadstring/main/CokkaHub.lua", tag = "Utility"},
    {name = "Ldt-Hub", url = "https://raw.githubusercontent.com/thohihi312-coder/ldt-hub/refs/heads/main/main.lua.txt", tag = "General"},
    {name = "Vector-Hub", url = "https://raw.githubusercontent.com/AAwful/Vector_Hub/0/v2", tag = "Combat"},
    {name = "Than-Hub", url = "https://raw.githubusercontent.com/thantzy/thanhub/refs/heads/main/thanv1", tag = "General"},
    {name = "Xero-Hub", url = "https://raw.githubusercontent.com/Xero2409/XeroHub/refs/heads/main/main.lua", tag = "General"},
    {name = "Volcano-Hub-V3", url = "https://raw.githubusercontent.com/indexeduu/BF-NewVer/refs/heads/main/V3New.lua", tag = "Utility"},
    {name = "REDZ Beta", url = "https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau", tag = "General"},
    {name = "W-azure", url = "https://api.luarmor.net/files/v3/loaders/85e904ae1ff30824c1aa007fc7324f8f.lua", tag = "General"},
}

-- Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

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

-- Subtle shadow (frame behind)
local shadow = Instance.new("Frame")
shadow.Size = mainFrame.Size + UDim2.new(0,8,0,8)
shadow.Position = mainFrame.Position - UDim2.new(0,4,0,4)
shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
shadow.BorderSizePixel = 0
shadow.BackgroundTransparency = 0.7
shadow.ZIndex = mainFrame.ZIndex - 1
shadow.Parent = screenGui
local shadowCorner = Instance.new("UICorner", shadow)
shadowCorner.CornerRadius = UDim.new(0, 16)

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 78)
header.BackgroundTransparency = 0
header.BackgroundColor3 = Color3.fromRGB(28,28,30)
header.BorderSizePixel = 0
header.Parent = mainFrame
local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 12)

local logo = Instance.new("ImageLabel")
logo.Name = "Logo"
logo.Size = UDim2.new(0, 56, 0, 56)
logo.Position = UDim2.new(0, 16, 0, 11)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://0" -- placeholder (transparent). Replace with asset id if desired.
logo.Parent = header

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
title.TextSize = 14
subtitle.TextColor3 = Color3.fromRGB(170,170,170)
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Text = "An toàn: chỉ sao chép/hiển thị URL — Không thực thi mã từ xa"
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
closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.12), {Size = UDim2.new(0, 40, 0, 40)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.12), {Size = UDim2.new(0, 36, 0, 36)}):Play()
end)
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

-- Tag filter dropdown (simple)
local tagFrame = Instance.new("Frame")
tagFrame.Size = UDim2.new(0.32, -24, 0, 36)
tagFrame.Position = UDim2.new(0.6, 0, 0, 92)
tagFrame.BackgroundColor3 = Color3.fromRGB(24,24,26)
tagFrame.BorderSizePixel = 0
tagFrame.Parent = mainFrame
local tagCorner = Instance.new("UICorner", tagFrame)
tagCorner.CornerRadius = UDim.new(0,8)
local tagLabel = Instance.new("TextLabel")
tagLabel.Size = UDim2.new(1, -36, 1, 0)
tagLabel.Position = UDim2.new(0, 8, 0, 0)
tagLabel.BackgroundTransparency = 1
tagLabel.Font = Enum.Font.Gotham
tagLabel.TextSize = 14
tagLabel.TextColor3 = Color3.fromRGB(200,200,200)
tagLabel.TextXAlignment = Enum.TextXAlignment.Left
tagLabel.Text = "Tất cả / All"
tagLabel.Parent = tagFrame
local tagArrow = Instance.new("TextLabel")
tagArrow.Size = UDim2.new(0, 24, 1, 0)
tagArrow.Position = UDim2.new(1, -28, 0, 0)
tagArrow.BackgroundTransparency = 1
tagArrow.Font = Enum.Font.Gotham
tagArrow.Text = "▾"
tagArrow.TextColor3 = Color3.fromRGB(170,170,170)
tagArrow.TextSize = 16
tagArrow.Parent = tagFrame

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

local function makeHubCard(hub)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -8, 0, 66)
    card.BackgroundColor3 = Color3.fromRGB(30,30,32)
    card.BorderSizePixel = 0
    card.Parent = scroll
    card.LayoutOrder = 0
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
    copyBtn.Size = UDim2.new(0, 56, 0, 32)
    copyBtn.Position = UDim2.new(1, -72, 0, 18)
    copyBtn.BackgroundColor3 = Color3.fromRGB(60,120,240)
    copyBtn.BorderSizePixel = 0
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.TextSize = 14
    copyBtn.TextColor3 = Color3.fromRGB(255,255,255)
    copyBtn.Text = "Copy"
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

    copyBtn.MouseButton1Click:Connect(function()
        local ok, err = pcall(function() setclipboard(hub.url) end)
        if ok then
            -- small confirmation label
            local confirm = Instance.new("TextLabel")
            confirm.Size = UDim2.new(0, 160, 0, 28)
            confirm.Position = UDim2.new(1, -180, 1, -44)
            confirm.BackgroundTransparency = 0.15
            confirm.BackgroundColor3 = Color3.fromRGB(20,20,20)
            confirm.TextColor3 = Color3.fromRGB(220,220,220)
            confirm.Text = "Đã sao chép: " .. hub.name
            confirm.Font = Enum.Font.Gotham
            confirm.TextSize = 14
            confirm.Parent = mainFrame
            local cc = Instance.new("UICorner", confirm)
            cc.CornerRadius = UDim.new(0,8)
            game:GetService("Debris"):AddItem(confirm, 2.8)
        else
            -- show url in a dialog (fallback)
            local dialog = Instance.new("Frame")
            dialog.Size = UDim2.new(0, 420, 0, 120)
            dialog.Position = UDim2.new(0.5, -210, 0.5, -60)
            dialog.BackgroundColor3 = Color3.fromRGB(22,22,24)
            dialog.BorderSizePixel = 0
            dialog.Parent = screenGui
            local dCorner = Instance.new("UICorner", dialog)
            dCorner.CornerRadius = UDim.new(0,10)

            local dTitle = Instance.new("TextLabel")
            dTitle.Size = UDim2.new(1, -24, 0, 28)
            dTitle.Position = UDim2.new(0, 12, 0, 12)
            dTitle.BackgroundTransparency = 1
            dTitle.Font = Enum.Font.GothamBold
            dTitle.TextSize = 16
            dTitle.TextColor3 = Color3.fromRGB(240,240,240)
            dTitle.Text = "URL (copy manually): " .. hub.name
            dTitle.TextXAlignment = Enum.TextXAlignment.Left
            dTitle.Parent = dialog

            local dBox = Instance.new("TextBox")
            dBox.Size = UDim2.new(1, -24, 0, 54)
            dBox.Position = UDim2.new(0, 12, 0, 44)
            dBox.BackgroundColor3 = Color3.fromRGB(18,18,20)
            dBox.TextColor3 = Color3.fromRGB(220,220,220)
            dBox.Font = Enum.Font.Gotham
            dBox.TextSize = 13
            dBox.Text = hub.url
            dBox.ClearTextOnFocus = false
            dBox.TextXAlignment = Enum.TextXAlignment.Left
            dBox.Parent = dialog

            local okBtn = Instance.new("TextButton")
            okBtn.Size = UDim2.new(0, 84, 0, 30)
            okBtn.Position = UDim2.new(1, -100, 1, -42)
            okBtn.BackgroundColor3 = Color3.fromRGB(100,200,120)
            okBtn.Text = "OK"
            okBtn.Font = Enum.Font.GothamBold
            okBtn.TextSize = 14
            okBtn.Parent = dialog
            local okCorner = Instance.new("UICorner", okBtn)
            okCorner.CornerRadius = UDim.new(0,6)
            okBtn.MouseButton1Click:Connect(function()
                dialog:Destroy()
            end)
        end
    end)

    return card
end

-- Populate list
for i, hub in ipairs(Hubs) do
    local c = makeHubCard(hub)
    c.LayoutOrder = i
end

-- Update scroll canvas size when content changes
uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y + 12)
end)

-- Simple search/filter
local function matches(hub, query, tag)
    if query == "" then
        return (tag == "All" or tag == hub.tag or tag == "")
    end
    local q = string.lower(query)
    if string.find(string.lower(hub.name), q, 1, true) then return (tag == "All" or tag == hub.tag or tag == "") end
    if string.find(string.lower(hub.tag or ""), q, 1, true) then return (tag == "All" or tag == hub.tag or tag == "") end
    if string.find(string.lower(hub.url), q, 1, true) then return (tag == "All" or tag == hub.tag or tag == "") end
    return false
end

local currentTag = "All"
local function refreshList(filterText)
    filterText = filterText or ""
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    local order = 1
    for i, hub in ipairs(Hubs) do
        if matches(hub, filterText, currentTag) then
            local card = makeHubCard(hub)
            card.LayoutOrder = order
            order = order + 1
        end
    end
    uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Wait() -- ensure size update
    scroll.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y + 12)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    refreshList(searchBox.Text)
end)

-- Simple tag dropdown: toggles between All and first hub tags (very basic)
local tags = {"All"}
for _, h in ipairs(Hubs) do
    if h.tag and not table.find(tags, h.tag) then table.insert(tags, h.tag) end
end

local tagOpen = false
local dropdown
local function openTagDropdown()
    if tagOpen then return end
    tagOpen = true
    dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(0, 160, 0, math.min(30 * #tags, 180))
    dropdown.Position = UDim2.new(0.68, 0, 0, 92)
    dropdown.BackgroundColor3 = Color3.fromRGB(20,20,22)
    dropdown.BorderSizePixel = 0
    dropdown.Parent = mainFrame
    local dcorner = Instance.new("UICorner", dropdown)
    dcorner.CornerRadius = UDim.new(0,8)
    local layout = Instance.new("UIListLayout", dropdown)
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    for i, t in ipairs(tags) do
        local it = Instance.new("TextButton")
        it.Size = UDim2.new(1, -12, 0, 28)
        it.Position = UDim2.new(0, 6, 0, (i-1) * 32 + 6)
        it.BackgroundTransparency = 1
        it.Font = Enum.Font.Gotham
        it.TextSize = 14
        it.TextColor3 = Color3.fromRGB(220,220,220)
        it.Text = t
        it.Parent = dropdown
        it.MouseButton1Click:Connect(function()
            currentTag = t
            tagLabel.Text = t .. ""
            dropdown:Destroy()
            tagOpen = false
            refreshList(searchBox.Text)
        end)
    end
end

tagFrame.MouseButton1Click:Connect(openTagDropdown)
tagFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then openTagDropdown() end
end)

-- initial layout
refreshList("")

print("Enhanced SafeScriptLauncher loaded. UI updated with improved visuals.")
