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
-- Script bay with fixed key system
local FIXED_KEY = "MINHVIP123"  -- <-- thay key ở đây
local MAX_ATTEMPTS = 3

-- KEY GUI: hiển thị trước, chặn mọi thứ cho đến khi nhập đúng key
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local keyGui = Instance.new("ScreenGui")
keyGui.Name = "KeyCheckGui"
keyGui.ResetOnSpawn = false
keyGui.Parent = playerGui
keyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 420, 0, 160)
frame.Position = UDim2.new(0.5, -210, 0.4, -80)
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

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 24)
statusLabel.Position = UDim2.new(0, 10, 0, 136)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.Font = Enum.Font.SourceSansItalic
statusLabel.TextSize = 16
statusLabel.TextColor3 = Color3.fromRGB(255,200,100)
statusLabel.Parent = frame

local attempts = 0

-- START: original script logic moved into a function startMain()
local function startMain()
    -- Tạo GUI chính (main) và logic bay từ file gốc
    local main = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local up = Instance.new("TextButton")
    local down = Instance.new("TextButton")
    local onof = Instance.new("TextButton")
    local TextLabel = Instance.new("TextLabel")
    local plus = Instance.new("TextButton")
    local speed = Instance.new("TextLabel")
    local mine = Instance.new("TextButton")
    local closebutton = Instance.new("TextButton")
    local mini = Instance.new("TextButton")
    local mini2 = Instance.new("TextButton")

    main.Name = "main"
    main.Parent = playerGui
    main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    main.ResetOnSpawn = false

    Frame.Parent = main
    Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
    Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
    Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
    Frame.Size = UDim2.new(0, 190, 0, 57)

    up.Name = "up"
    up.Parent = Frame
    up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
    up.Size = UDim2.new(0, 44, 0, 28)
    up.Font = Enum.Font.SourceSans
    up.Text = "UP"
    up.TextColor3 = Color3.fromRGB(0, 0, 0)
    up.TextSize = 14.000

    down.Name = "down"
    down.Parent = Frame
    down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
    down.Position = UDim2.new(0, 0, 0.491228074, 0)
    down.Size = UDim2.new(0, 44, 0, 28)
    down.Font = Enum.Font.SourceSans
    down.Text = "DOWN"
    down.TextColor3 = Color3.fromRGB(0, 0, 0)
    down.TextSize = 14.000

    onof.Name = "onof"
    onof.Parent = Frame
    onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
    onof.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
    onof.Size = UDim2.new(0, 56, 0, 28)
    onof.Font = Enum.Font.SourceSans
    onof.Text = "fly"
    onof.TextColor3 = Color3.fromRGB(0, 0, 0)
    onof.TextSize = 14.000

    TextLabel.Parent = Frame
    TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
    TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
    TextLabel.Size = UDim2.new(0, 100, 0, 28)
    TextLabel.Font = Enum.Font.SourceSans
    TextLabel.Text = "Script hack bay"
    TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.TextScaled = true
    TextLabel.TextSize = 14.000
    TextLabel.TextWrapped = true

    plus.Name = "plus"
    plus.Parent = Frame
    plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
    plus.Position = UDim2.new(0.231578946, 0, 0, 0)
    plus.Size = UDim2.new(0, 45, 0, 28)
    plus.Font = Enum.Font.SourceSans
    plus.Text = "+"
    plus.TextColor3 = Color3.fromRGB(0, 0, 0)
    plus.TextScaled = true
    plus.TextSize = 14.000
    plus.TextWrapped = true

    speed.Name = "speed"
    speed.Parent = Frame
    speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
    speed.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
    speed.Size = UDim2.new(0, 44, 0, 28)
    speed.Font = Enum.Font.SourceSans
    speed.Text = "1"
    speed.TextColor3 = Color3.fromRGB(0, 0, 0)
    speed.TextScaled = true
    speed.TextSize = 14.000
    speed.TextWrapped = true

    mine.Name = "mine"
    mine.Parent = Frame
    mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
    mine.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
    mine.Size = UDim2.new(0, 45, 0, 29)
    mine.Font = Enum.Font.SourceSans
    mine.Text = "-"
    mine.TextColor3 = Color3.fromRGB(0, 0, 0)
    mine.TextScaled = true
    mine.TextSize = 14.000
    mine.TextWrapped = true

    closebutton.Name = "Close"
    closebutton.Parent = main.Frame
    closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
    closebutton.Font = "SourceSans"
    closebutton.Size = UDim2.new(0, 45, 0, 28)
    closebutton.Text = "X"
    closebutton.TextSize = 30
    closebutton.Position =  UDim2.new(0, 0, -1, 27)

    mini.Name = "minimize"
    mini.Parent = main.Frame
    mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
    mini.Font = "SourceSans"
    mini.Size = UDim2.new(0, 45, 0, 28)
    mini.Text = "-"
    mini.TextSize = 40
    mini.Position = UDim2.new(0, 44, -1, 27)

    mini2.Name = "minimize2"
    mini2.Parent = main.Frame
    mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
    mini2.Font = "SourceSans"
    mini2.Size = UDim2.new(0, 45, 0, 28)
    mini2.Text = "+"
    mini2.TextSize = 40
    mini2.Position = UDim2.new(0, 44, -1, 57)
    mini2.Visible = false

    speeds = 1

    local speaker = game:GetService("Players").LocalPlayer

    local chr = game.Players.LocalPlayer.Character
    local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

    nowe = false

    game:GetService("StarterGui"):SetCore("SendNotification", { 
        Title = "script hack bay";
        Text = "BY Minhfansub";
        Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
    Duration = 5;

    Frame.Active = true -- main = gui
    Frame.Draggable = true

    onof.MouseButton1Down:connect(function()

        if nowe == true then
            nowe = false

            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
            speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        else 
            nowe = true

            for i = 1, speeds do
                spawn(function()

                    local hb = game:GetService("RunService").Heartbeat    

                    tpwalking = true
                    local chr = game.Players.LocalPlayer.Character
                    local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                    while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                        if hum.MoveDirection.Magnitude > 0 then
                            chr:TranslateBy(hum.MoveDirection)
                        end
                    end

                end)
            end
            game.Players.LocalPlayer.Character.Animate.Disabled = true
            local Char = game.Players.LocalPlayer.Character
            local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

            for i,v in next, Hum:GetPlayingAnimationTracks() do
                v:AdjustSpeed(0)
            end
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
            speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
        end

        if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then

            local plr = game.Players.LocalPlayer
            local torso = plr.Character.Torso
            local flying = true
            local deb = true
            local ctrl = {f = 0, b = 0, l = 0, r = 0}
            local lastctrl = {f = 0, b = 0, l = 0, r = 0}
            local maxspeed = 50
            local speed = 0

            local bg = Instance.new("BodyGyro", torso)
            bg.P = 9e4
            bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.cframe = torso.CFrame
            local bv = Instance.new("BodyVelocity", torso)
            bv.velocity = Vector3.new(0,0.1,0)
            bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
            if nowe == true then
                plr.Character.Humanoid.PlatformStand = true
            end
            while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
                game:GetService("RunService").RenderStepped:Wait()

                if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                    speed = speed+.5+(speed/maxspeed)
                    if speed > maxspeed then
                        speed = maxspeed
                    end
                elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                    speed = speed-1
                    if speed < 0 then
                        speed = 0
                    end
                end
                if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                    bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                    lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                    bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                else
                    bv.velocity = Vector3.new(0,0,0)
                end
                --  game.Players.LocalPlayer.Character.Animate.Disabled = true
                bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
            end
            ctrl = {f = 0, b = 0, l = 0, r = 0}
            lastctrl = {f = 0, b = 0, l = 0, r = 0}
            speed = 0
            bg:Destroy()
            bv:Destroy()
            plr.Character.Humanoid.PlatformStand = false
            game.Players.LocalPlayer.Character.Animate.Disabled = false
            tpwalking = false

        else
            local plr = game.Players.LocalPlayer
            local UpperTorso = plr.Character.UpperTorso
            local flying = true
            local deb = true
            local ctrl = {f = 0, b = 0, l = 0, r = 0}
            local lastctrl = {f = 0, b = 0, l = 0, r = 0}
            local maxspeed = 50
            local speed = 0

            local bg = Instance.new("BodyGyro", UpperTorso)
            bg.P = 9e4
            bg.maxTorque = Vector3.ne

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

