--[=[
Safe "Script Aggregator Launcher" — Run Approved ModuleScripts (Safe Execution)

Important safety rules (read before use):
- THIS LAUNCHER WILL ONLY EXECUTE ModuleScripts that you (the developer/admin) place inside ReplicatedStorage.ApprovedModules.
- It WILL NOT fetch or execute code from the internet (no loadstring/http requests). This prevents running unreviewed or malicious code.
- Each ModuleScript must return either:
    1) a table with a `start(player)` function, OR
    2) a function `function(player)`
  The launcher will call that with the local player as the argument.

Setup steps (in Roblox Studio):
1) Create folder: ReplicatedStorage -> ApprovedModules
2) Add ModuleScripts with unique names matching `hub.moduleName` in the Hubs table below.
   Example ModuleScript content (ReplicatedStorage.ApprovedModules.HelloModule):

   local M = {}
   function M.start(player)
       game.StarterGui:SetCore("SendNotification", {Title = "Module", Text = "Hello, "..player.Name, Duration = 3})
   end
   return M

3) Place this LocalScript in StarterPlayerScripts (the launcher UI runs client-side).

Behavior:
- The UI shows hubs. If a hub has `moduleName` set, its button runs that ModuleScript immediately (after a small confirmation dialog).
- Non-approved hubs (no `moduleName`) will show an instruction modal explaining how to approve and run safely.

========================
-- Config: edit Hubs table to map names -> moduleName
========================
local Hubs = {
    {name = "Blue-X", url = "https://raw.githubusercontent.com/Dev-BlueX/BlueX-Hub/refs/heads/main/Main.lua", tag = "General", moduleName = "BlueXModule"},
    {name = "Quantum-Hub", url = "https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua", tag = "General", moduleName = "QuantumModule"},
    {name = "Cokka-Hub", url = "https://raw.githubusercontent.com/UserDevEthical/Loadstring/main/CokkaHub.lua", tag = "Utility", moduleName = "CokkaModule"},
}

-- Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Approved modules folder
local ApprovedModules = ReplicatedStorage:FindFirstChild("ApprovedModules") or Instance.new("Folder", ReplicatedStorage)
ApprovedModules.Name = "ApprovedModules"

-- Cleanup old GUI
if PlayerGui:FindFirstChild("SafeScriptLauncher") then
    PlayerGui.SafeScriptLauncher:Destroy()
end

-- Create UI (same structure as before, slightly simplified)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SafeScriptLauncher"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 520, 0, 540)
mainFrame.Position = UDim2.new(0.5, -260, 0.12, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(18,18,20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 14)

local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,78)
header.BackgroundColor3 = Color3.fromRGB(28,28,30)
header.BorderSizePixel = 0
header.Parent = mainFrame
local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-100,0,30)
title.Position = UDim2.new(0,84,0,12)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(240,240,240)
title.Text = "Script Launcher — Run Approved Modules"
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,36,0,36)
closeBtn.Position = UDim2.new(1,-48,0,14)
closeBtn.BackgroundColor3 = Color3.fromRGB(220,70,70)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.Parent = header
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0,8)
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Body
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,-32,0,420)
scroll.Position = UDim2.new(0,16,0,108)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 8
scroll.Parent = mainFrame
local uiList = Instance.new("UIListLayout", scroll)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0,10)

local function notify(text, duration)
    duration = duration or 3
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {Title = "Launcher", Text = text, Duration = duration})
    end)
end

local function safeRequireModule(moduleName)
    if not moduleName or moduleName == "" then return nil, "moduleName empty" end
    local modInst = ApprovedModules:FindFirstChild(moduleName)
    if not modInst or not modInst:IsA("ModuleScript") then
        return nil, "Module không tồn tại trong ApprovedModules: " .. tostring(moduleName)
    end
    local ok, res = pcall(function()
        local result = require(modInst)
        return result
    end)
    if not ok then
        return nil, "Lỗi khi yêu cầu module: " .. tostring(res)
    end
    return res
end

-- Confirmation modal for running approved modules
local function runModuleWithConfirm(hub)
    local moduleName = hub.moduleName
    if not moduleName or moduleName == "" then
        -- show modal explaining how to approve
        local explain = Instance.new("Frame")
        explain.Size = UDim2.new(0,420,0,160)
        explain.Position = UDim2.new(0.5,-210,0.5,-80)
        explain.BackgroundColor3 = Color3.fromRGB(22,22,24)
        explain.Parent = screenGui
        local ec = Instance.new("UICorner", explain)
        ec.CornerRadius = UDim.new(0,10)
        local t = Instance.new("TextLabel", explain)
        t.Size = UDim2.new(1,-24,0,28)
        t.Position = UDim2.new(0,12,0,12)
        t.BackgroundTransparency = 1
        t.Font = Enum.Font.GothamBold
        t.Text = "Module chưa được phê duyệt"
        t.TextColor3 = Color3.fromRGB(240,240,240)
        t.TextXAlignment = Enum.TextXAlignment.Left
        local info = Instance.new("TextLabel", explain)
        info.Size = UDim2.new(1,-24,0,80)
        info.Position = UDim2.new(0,12,0,44)
        info.BackgroundTransparency = 1
        info.Font = Enum.Font.Gotham
        info.TextSize = 14
        info.TextWrapped = true
        info.TextColor3 = Color3.fromRGB(200,200,200)
        info.Text = "Để chạy script này, tạo ModuleScript trong ReplicatedStorage.ApprovedModules với tên moduleName.

Module phải trả về 1 bảng có hàm start(player) hoặc 1 function(player)."
        local okBtn = Instance.new("TextButton", explain)
        okBtn.Size = UDim2.new(0,84,0,30)
        okBtn.Position = UDim2.new(1,-100,1,-42)
        okBtn.BackgroundColor3 = Color3.fromRGB(100,200,120)
        okBtn.Text = "OK"
        okBtn.Font = Enum.Font.GothamBold
        okBtn.MouseButton1Click:Connect(function() explain:Destroy() end)
        return
    end

    -- Show confirm modal
    local modal = Instance.new("Frame")
    modal.Size = UDim2.new(0,420,0,160)
    modal.Position = UDim2.new(0.5,-210,0.5,-80)
    modal.BackgroundColor3 = Color3.fromRGB(22,22,24)
    modal.Parent = screenGui
    local mc = Instance.new("UICorner", modal)
    mc.CornerRadius = UDim.new(0,10)

    local title = Instance.new("TextLabel", modal)
    title.Size = UDim2.new(1,-24,0,28)
    title.Position = UDim2.new(0,12,0,12)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "Xác nhận chạy module"
    title.TextColor3 = Color3.fromRGB(240,240,240)
    title.TextXAlignment = Enum.TextXAlignment.Left

    local body = Instance.new("TextLabel", modal)
    body.Size = UDim2.new(1,-24,0,72)
    body.Position = UDim2.new(0,12,0,44)
    body.BackgroundTransparency = 1
    body.Font = Enum.Font.Gotham
    body.TextSize = 14
    body.TextWrapped = true
    body.TextColor3 = Color3.fromRGB(200,200,200)
    body.Text = "Bạn sắp chạy module: "..tostring(moduleName).."
Hệ thống sẽ yêu cầu module trong ReplicatedStorage.ApprovedModules. Hãy đảm bảo bạn đã kiểm tra mã trước khi phê duyệt."

    local runBtn = Instance.new("TextButton", modal)
    runBtn.Size = UDim2.new(0,120,0,34)
    runBtn.Position = UDim2.new(1,-140,1,-46)
    runBtn.BackgroundColor3 = Color3.fromRGB(60,160,90)
    runBtn.Text = "Run"
    runBtn.Font = Enum.Font.GothamBold

    local cancelBtn = Instance.new("TextButton", modal)
    cancelBtn.Size = UDim2.new(0,84,0,34)
    cancelBtn.Position = UDim2.new(1,-260,1,-46)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(200,80,80)
    cancelBtn.Text = "Cancel"
    cancelBtn.Font = Enum.Font.GothamBold

    cancelBtn.MouseButton1Click:Connect(function() modal:Destroy() end)

    runBtn.MouseButton1Click:Connect(function()
        -- attempt to require and run
        local ok, modOrErr = pcall(function() return safeRequireModule(moduleName) end)
        if not ok or not modOrErr then
            local msg = tostring(modOrErr or "Không thể require module")
            notify(msg, 5)
            modal:Destroy()
            return
        end

        -- call module
        local mod = modOrErr
        local ran, err = pcall(function()
            if type(mod) == "table" and type(mod.start) == "function" then
                mod.start(Player)
            elseif type(mod) == "function" then
                mod(Player)
            else
                error("Module trả về kiểu không hợp lệ. Cần bảng với start(player) hoặc function(player)")
            end
        end)

        if not ran then
            notify("Lỗi khi chạy module: "..tostring(err), 6)
        else
            notify("Module đã chạy: "..tostring(moduleName), 3)
        end
        modal:Destroy()
    end)
end

local function makeHubCard(hub, index)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1,-8,0,66)
    card.BackgroundColor3 = Color3.fromRGB(30,30,32)
    card.BorderSizePixel = 0
    card.Parent = scroll
    card.LayoutOrder = index
    local cc = Instance.new("UICorner", card)
    cc.CornerRadius = UDim.new(0,10)

    local nameLbl = Instance.new("TextLabel", card)
    nameLbl.Size = UDim2.new(0.6,-20,0,22)
    nameLbl.Position = UDim2.new(0,72,0,12)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 16
    nameLbl.Text = hub.name
    nameLbl.TextColor3 = Color3.fromRGB(245,245,245)
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left

    local urlPreview = Instance.new("TextLabel", card)
    urlPreview.Size = UDim2.new(1,-92,0,18)
    urlPreview.Position = UDim2.new(0,72,0,36)
    urlPreview.BackgroundTransparency = 1
    urlPreview.Font = Enum.Font.Gotham
    urlPreview.TextSize = 12
    urlPreview.Text = hub.url
    urlPreview.TextColor3 = Color3.fromRGB(170,170,170)
    urlPreview.TextXAlignment = Enum.TextXAlignment.Left

    local runBtn = Instance.new("TextButton", card)
    runBtn.Size = UDim2.new(0,72,0,32)
    runBtn.Position = UDim2.new(1,-84,0,18)
    runBtn.BackgroundColor3 = Color3.fromRGB(70,130,230)
    runBtn.Text = "Run"
    runBtn.Font = Enum.Font.GothamBold

    runBtn.MouseButton1Click:Connect(function()
        runModuleWithConfirm(hub)
    end)

    return card
end

for i, hub in ipairs(Hubs) do
    makeHubCard(hub, i)
end

uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0,0,0,uiList.AbsoluteContentSize.Y + 12)
end)

print("SafeScriptLauncher (Run Approved Modules) loaded. Only executes modules found in ReplicatedStorage.ApprovedModules.")
]=]
