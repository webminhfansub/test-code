local v0 = game:GetService("Players");
local v1 = game:GetService("RunService");
local v2 = game:GetService("UserInputService");
local v3 = game:GetService("TweenService");
local v4 = game:GetService("CoreGui");
local v5 = workspace.CurrentCamera;
local v6 = v0.LocalPlayer;
local v7 = {ESP = {Enabled = false, BoxColor = Color3.new(1, 1055.3 - (87 + 968) , 0.3 - 0 ), DistanceColor = Color3.new(1, 1, 1), HealthGradient = {Color3.new(0 + 0 , 1, 0 - 0 ), Color3.new(2 - 1 , 1, 0), Color3.new(1, 0, 1817 - (1703 + 114) )}, SnaplineEnabled = true, SnaplinePosition = "Center", RainbowEnabled = false}, Aimbot = {Enabled = false, FOV = 731 - (376 + 325) , MaxDistance = 200, ShowFOV = false, TargetPart = "Head"}};
local v8 = 0.5 - 0 ;
local v9 = {};
local function v10(v371) local v372 = 0;
    local v373;
    while true do
        if (v372 = = (12 - 8)) then
            v373.Snapline.Color = v7.ESP.BoxColor;
            v9[v371] = v373;
            break;
        end
        if ((0 + 0) = = v372) then
            if (v371 = = v6) then
                return;
            end
            v373 = {Box = Drawing.new("Square"), HealthBar = Drawing.new("Square"), Distance = Drawing.new("Text"), Snapline = Drawing.new("Line")};
            v372 = 1;
        end
        if (2 = = v372) then
            v373.HealthBar.Filled = true;
            v373.Distance.Size = 34 - 18 ;
            v372 = 3;
        end
        if ((15 - (9 + 5)) = = v372) then
            for v514, v515 in pairs(v373) do
                local v516 = 376 - (85 + 291) ;
                while true do
                    if (v516 = = (1265 - (243 + 1022))) then
                        v515.Visible = false;
                        if (v515.Type = = "Square") then
                            local v570 = 0;
                            while true do
                                if (v570 = = (0 - 0)) then
                                    v515.Thickness = 2 + 0 ;
                                    v515.Filled = false;
                                    break;
                                end
                            end
                        end
                        break;
                    end
                end
            end
            v373.Box.Color = v7.ESP.BoxColor;
            v372 = 1182 - (1123 + 57) ;
        end
        if ((3 + 0) = = v372) then
            v373.Distance.Center = true;
            v373.Distance.Color = v7.ESP.DistanceColor;
            v372 = 258 - (163 + 91) ;
        end
    end
end
local function v11(v374, v375) if ( not v7.ESP.Enabled or not v374.Character) then
    for v459, v460 in pairs(v375) do
        v460.Visible = false;
    end
    return;
end
local v376 = v374.Character:FindFirstChildOfClass("Humanoid");
local v377 = v374.Character:FindFirstChild("Head");
if ( not v376 or (v376.Health < = (1930 - (1869 + 61))) or not v377) then
    local v435 = 0 + 0 ;
    while true do
        if ((0 - 0) = = v435) then
            for v540, v541 in pairs(v375) do
                v541.Visible = false;
            end
            return;
        end
    end
end
local v378, v379 = v5:WorldToViewportPoint(v377.Position);
if not v379 then
    local v436 = 0;
    while true do
        if (v436 = = 0) then
            for v543, v544 in pairs(v375) do
                v544.Visible = false;
            end
            return;
        end
    end
end
local v380 = (v377.Position - v5.CFrame.Position).Magnitude;
local v381 = 1000 / v380 ;
v375.Box.Size = Vector2.new(v381, v381 * (1.5 - 0) );
v375.Box.Position = Vector2.new(v378.X - (v381 / 2) , v378.Y - (v381 * 0.75) );
v375.Box.Visible = true;
local v385 = v376.Health / v376.MaxHealth ;
local v386 = math.clamp(3 - (v385 * (1 + 1)) , 1 - 0 , 3 + 0 );
local v387 = v7.ESP.HealthGradient[math.floor(v386)]:Lerp(v7.ESP.HealthGradient[math.ceil(v386)], v386 % (1475 - (1329 + 145)) );
v375.HealthBar.Size = Vector2.new(4, v381 * 1.5 * v385 );
v375.HealthBar.Position = Vector2.new(v378.X + (v381 / (973 - (140 + 831))) + (1855 - (1409 + 441)) , (v378.Y - (v381 * 0.75)) + (v381 * (719.5 - (15 + 703)) * ((1 + 0) - v385)) );
v375.HealthBar.Color = v387;
v375.HealthBar.Visible = true;
v375.Distance.Text = math.floor(v380) .. "m" ;
v375.Distance.Position = Vector2.new(v378.X, v378.Y + (v381 * (438.75 - (262 + 176))) + (1731 - (345 + 1376)) );
v375.Distance.Visible = true;
if v7.ESP.RainbowEnabled then
    local v437 = 0;
    local v438;
    while true do
        if (v437 = = 1) then
            v375.Box.Color = Color3.fromHSV(v438, 1, 689 - (198 + 490) );
            break;
        end
        if (v437 = = (0 - 0)) then
            v438 = (tick() * v8) % 1 ;
            v375.Snapline.Color = Color3.fromHSV(v438, 1, 2 - 1 );
            v437 = 1;
        end
    end
    else local v439 = 0;
    while true do
        if (v439 = = 0) then
            v375.Snapline.Color = v7.ESP.BoxColor;
            v375.Box.Color = v7.ESP.BoxColor;
            break;
        end
    end
end
if v7.ESP.SnaplineEnabled then
    local v440 = 0;
    local v441;
    while true do
        if (v440 = = (1207 - (696 + 510))) then
            if (v7.ESP.SnaplinePosition = = "Bottom") then
                v441 = v5.ViewportSize.Y;
                elseif (v7.ESP.SnaplinePosition = = "Top") then
                    v441 = 0 - 0 ;
                    else v441 = v5.ViewportSize.Y / (1264 - (1091 + 171)) ;
                end
                v375.Snapline.To = Vector2.new(v5.ViewportSize.X / (1 + 1) , v441);
                v440 = 6 - 4 ;
            end
            if (v440 = = (0 - 0)) then
                v375.Snapline.From = Vector2.new(v378.X, v378.Y + (v381 * (374.75 - (123 + 251))) );
                v441 = nil;
                v440 = 1;
            end
            if (v440 = = (9 - 7)) then
                v375.Snapline.Visible = true;
                break;
            end
        end
        else v375.Snapline.Visible = false;
    end
end
local function v12() local v395 = nil;
    local v396 = math.huge;
    local v397 = v7.Aimbot.FOV or (768 - (208 + 490)) ;
    for v428, v429 in pairs(v0:GetPlayers()) do
        if ((v429 ~ = v0.LocalPlayer) and v429.Character and v429.Character:FindFirstChild("Head")) then
            local v462 = 0 + 0 ;
            local v463;
            local v464;
            local v465;
            local v466;
            while true do
                if (v462 = = 1) then
                    v465 = v5.CFrame.LookVector;
                    v466 = math.deg(math.acos(v464:Dot(v465)));
                    v462 = 2;
                end
                if (v462 = = 2) then
                    if (v466 < = (v397 / (1 + 1))) then
                        local v562 = 0;
                        local v563;
                        while true do
                            if (v562 = = 0) then
                                v563 = (v5.CFrame.Position - v463.Position).Magnitude;
                                if (v563 < = v7.Aimbot.MaxDistance) then
                                    local v579 = 0;
                                    local v580;
                                    local v581;
                                    local v582;
                                    while true do
                                        if (v579 = = (837 - (660 + 176))) then
                                            if (v581 and v581:IsDescendantOf(v429.Character)) then
                                                if (v563 < v396) then
                                                    local v583 = 0 + 0 ;
                                                    while true do
                                                        if (v583 = = (202 - (14 + 188))) then
                                                            v396 = v563;
                                                            v395 = v429;
                                                            break;
                                                        end
                                                    end
                                                end
                                            end
                                            break;
                                        end
                                        if (v579 = = 0) then
                                            v580 = Ray.new(v5.CFrame.Position, v464 * 500 );
                                            v581, v582 = workspace:FindPartOnRay(v580, v0.LocalPlayer.Character);
                                            v579 = 1;
                                        end
                                    end
                                end
                                break;
                            end
                        end
                    end
                    break;
                end
                if (v462 = = (675 - (534 + 141))) then
                    v463 = v429.Character.Head;
                    v464 = (v463.Position - v5.CFrame.Position).Unit;
                    v462 = 1 + 0 ;
                end
            end
        end
    end
    return v395;
end
local v13 = Drawing.new("Circle");
v13.Thickness = 2 + 0 ;
v13.NumSides = 100;
v13.Filled = false;
v13.Visible = v7.Aimbot.ShowFOV;
v13.Color = Color3.new(1, 1, 1 + 0 );
local v20 = Instance.new("ScreenGui");
v20.Name = "ScriptGUI";
v20.Parent = v4;
v20.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
v20.DisplayOrder = 1000;
local v26 = Instance.new("Frame");
v26.Name = "MainFrame";
v26.Size = UDim2.new(0, 370, 0 - 0 , 476 - 176 );
v26.Position = UDim2.new(0 - 0 , 10, 0 + 0 , 7 + 3 );
v26.BackgroundColor3 = Color3.new(396.05 - (115 + 281) , 0.05 - 0 , 0.05 + 0 );
v26.BorderSizePixel = 0 - 0 ;
v26.Active = true;
v26.Draggable = true;
v26.ZIndex = 366 - 266 ;
v26.Parent = v20;
local v36 = Instance.new("UICorner");
v36.CornerRadius = UDim.new(0, 10);
v36.Parent = v26;
local v39 = Instance.new("UIGradient");
v39.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(0.1 - 0 , 0.1 - 0 , 0.1 - 0 )), ColorSequenceKeypoint.new(1666 - (970 + 695) , Color3.new(0.3, 0.3, 0.3 - 0 ))});
v39.Rotation = 2080 - (582 + 1408) ;
v39.Parent = v26;
local v43 = Instance.new("ImageLabel");
v43.Size = UDim2.new(3 - 2 , 12 - 2 , 3 - 2 , 10);
v43.Position = UDim2.new(1824 - (1195 + 629) , - 5, 0 - 0 , - 5);
v43.BackgroundTransparency = 242 - (187 + 54) ;
v43.Image = "rbxassetid: / / 131604521";
v43.ImageColor3 = Color3.new(780 - (162 + 618) , 0 + 0 , 0 + 0 );
v43.ImageTransparency = 0.5;
v43.ZIndex = 210 - 111 ;
v43.Parent = v26;
local v52 = Instance.new("Frame");
v52.Name = "TitleBar";
v52.Size = UDim2.new(1 - 0 , 0, 0, 3 + 27 );
v52.BackgroundColor3 = Color3.new(1636.2 - (1373 + 263) , 1000.2 - (451 + 549) , 0.2 + 0 );
v52.BorderSizePixel = 0 - 0 ;
v52.ZIndex = 169 - 68 ;
v52.Parent = v26;
local v59 = Instance.new("TextLabel");
v59.Name = "TitleLabel";
v59.Size = UDim2.new(1384 - (746 + 638) , 68 + 112 , 0 - 0 , 371 - (218 + 123) );
v59.Position = UDim2.new(1581 - (1535 + 46) , 10, 0, 0 + 0 );
v59.BackgroundTransparency = 1;
v59.TextColor3 = Color3.new(1, 1 + 0 , 561 - (306 + 254) );
v59.Text = "whoamhoam v1.1.0";
v59.Font = Enum.Font.GothamBold;
v59.TextSize = 1 + 15 ;
v59.TextXAlignment = Enum.TextXAlignment.Left;
v59.ZIndex = 199 - 97 ;
v59.Parent = v52;
local v73 = Instance.new("TextButton");
v73.Name = "MinimizeButton";
v73.Size = UDim2.new(1467 - (899 + 568) , 20, 0 + 0 , 48 - 28 );
v73.Position = UDim2.new(1, - 25, 0, 608 - (268 + 335) );
v73.BackgroundColor3 = Color3.new(1, 0, 290 - (60 + 230) );
v73.TextColor3 = Color3.new(573 - (426 + 146) , 1 + 0 , 1);
v73.Text = " - ";
v73.Font = Enum.Font.GothamBold;
v73.TextSize = 1470 - (282 + 1174) ;
v73.ZIndex = 102;
v73.Parent = v52;
local v84 = Instance.new("UICorner");
v84.CornerRadius = UDim.new(811 - (569 + 242) , 5);
v84.Parent = v73;
local function v87() for v430, v431 in ipairs(v26:GetDescendants()) do
    if v431:IsA("GuiObject") then
        v431.Visible = true;
    end
end
end
local v88 = Instance.new("Frame");
v88.Name = "TabsFrame";
v88.Size = UDim2.new(0, 432 - 282 , 0 + 0 , v26.Size.Y.Offset - v52.Size.Y.Offset );
v88.Position = UDim2.new(1024 - (706 + 318) , 1251 - (721 + 530) , 0, v52.Size.Y.Offset);
v88.BackgroundColor3 = Color3.new(0.1, 1271.1 - (945 + 326) , 0.1);
v88.BorderSizePixel = 0 - 0 ;
v88.ZIndex = 101;
v88.Parent = v26;
local v96 = Instance.new("UICorner");
v96.CornerRadius = UDim.new(0, 10);
v96.Parent = v88;
local v99 = Instance.new("TextButton");
v99.Name = "ESPTabButton";
v99.Size = UDim2.new(1 + 0 , - 10, 0, 740 - (271 + 429) );
v99.Position = UDim2.new(0, 5 + 0 , 1500 - (1408 + 92) , 1096 - (461 + 625) );
v99.BackgroundColor3 = Color3.new(1288.15 - (993 + 295) , 0.15 + 0 , 1171.15 - (418 + 753) );
v99.TextColor3 = Color3.new(1, 1 + 0 , 1 + 0 );
v99.Text = "ESP";
v99.Font = Enum.Font.GothamBold;
v99.TextSize = 5 + 9 ;
v99.ZIndex = 102;
v99.Parent = v88;
local v110 = Instance.new("UICorner");
v110.CornerRadius = UDim.new(0 + 0 , 534 - (406 + 123) );
v110.Parent = v99;
local v113 = Instance.new("TextButton");
v113.Name = "AimbotTabButton";
v113.Size = UDim2.new(1, - (1779 - (1749 + 20)), 0, 10 + 30 );
v113.Position = UDim2.new(0, 5, 1322 - (1249 + 73) , 22 + 38 );
v113.BackgroundColor3 = Color3.new(1145.15 - (466 + 679) , 0.15 - 0 , 0.15);
v113.TextColor3 = Color3.new(1, 2 - 1 , 1);
v113.Text = "Aimbot";
v113.Font = Enum.Font.GothamBold;
v113.TextSize = 1914 - (106 + 1794) ;
v113.ZIndex = 33 + 69 ;
v113.Parent = v88;
local v124 = Instance.new("UICorner");
v124.CornerRadius = UDim.new(0 + 0 , 5);
v124.Parent = v113;
local v127 = Instance.new("Frame");
v127.Name = "ESPTabContent";
v127.Size = UDim2.new(0 - 0 , (v26.Size.X.Offset - v88.Size.X.Offset) - (54 - 34) , 114 - (4 + 110) , (v26.Size.Y.Offset - v52.Size.Y.Offset) - (604 - (57 + 527)) );
v127.Position = UDim2.new(1427 - (41 + 1386) , v88.Size.X.Offset + (113 - (17 + 86)) , 0, v52.Size.Y.Offset + 10 );
v127.BackgroundColor3 = Color3.new(0.1 + 0 , 0.1 - 0 , 0.1 - 0 );
v127.BorderSizePixel = 166 - (122 + 44) ;
v127.ZIndex = 174 - 73 ;
v127.Parent = v26;
local v135 = Instance.new("Frame");
v135.Name = "AimbotTabContent";
v135.Size = v127.Size;
v135.Position = v127.Position;
v135.BackgroundColor3 = Color3.new(0.1, 0.1 - 0 , 0.1 + 0 );
v135.BorderSizePixel = 0;
v135.ZIndex = 15 + 86 ;
v135.Parent = v26;
v135.Visible = false;
local v144 = Instance.new("UICorner");
v144.CornerRadius = UDim.new(0 - 0 , 75 - (30 + 35) );
v144.Parent = v127;
local v147 = v144:Clone();
v147.Parent = v135;
local v149 = 7 + 3 ;
local v150 = 1287 - (1043 + 214) ;
local v151 = 37 - 27 ;
local v152 = 1222 - (323 + 889) ;
local v153 = Instance.new("TextButton");
v153.Name = "ESPButton";
v153.Size = UDim2.new(0, 484 - 304 , 580 - (361 + 219) , v150);
v153.Position = UDim2.new(0, v149, 320 - (53 + 267) , v152);
v153.BackgroundColor3 = Color3.new(0.15 + 0 , 413.15 - (15 + 398) , 0.15);
v153.TextColor3 = Color3.new(1, 983 - (18 + 964) , 1);
v153.Text = "ESP";
v153.Font = Enum.Font.GothamBold;
v153.TextSize = 52 - 38 ;
v153.ZIndex = 101;
v153.Parent = v127;
local v164 = Instance.new("UICorner");
v164.CornerRadius = UDim.new(0 + 0 , 4 + 1 );
v164.Parent = v153;
local v167 = Instance.new("Frame");
v167.Name = "ESPIndicator";
v167.Size = UDim2.new(850 - (20 + 830) , 16 + 4 , 126 - (116 + 10) , 20);
v167.Position = UDim2.new(1 + 0 , - (763 - (542 + 196)), 0 - 0 , 2 + 3 );
v167.BackgroundColor3 = (v7.ESP.Enabled and Color3.new(0, 1 + 0 , 0)) or Color3.new(1, 0, 0) ;
v167.BorderSizePixel = 0 + 0 ;
v167.ZIndex = 268 - 166 ;
v167.Parent = v153;
local v175 = Instance.new("UICorner");
v175.CornerRadius = UDim.new(0 - 0 , 1556 - (1126 + 425) );
v175.Parent = v167;
v152 = v152 + v150 + v151 ;
local v178 = Instance.new("TextButton");
v178.Name = "SnaplineToggleButton";
v178.Size = UDim2.new(405 - (118 + 287) , 705 - 525 , 0, v150);
v178.Position = UDim2.new(1121 - (118 + 1003) , v149, 0 - 0 , v152);
v178.BackgroundColor3 = Color3.new(377.15 - (142 + 235) , 0.15, 0.15 - 0 );
v178.TextColor3 = Color3.new(1 + 0 , 978 - (553 + 424) , 1 - 0 );
v178.Text = "Snapline";
v178.Font = Enum.Font.GothamBold;
v178.TextSize = 13 + 1 ;
v178.ZIndex = 101 + 0 ;
v178.Parent = v127;
local v189 = Instance.new("UICorner");
v189.CornerRadius = UDim.new(0 + 0 , 3 + 2 );
v189.Parent = v178;
local v192 = Instance.new("Frame");
v192.Name = "SnaplineToggleIndicator";
v192.Size = UDim2.new(0, 12 + 8 , 0, 43 - 23 );
v192.Position = UDim2.new(1, - (69 - 44), 0 - 0 , 5);
v192.BackgroundColor3 = (v7.ESP.SnaplineEnabled and Color3.new(0 + 0 , 4 - 3 , 753 - (239 + 514) )) or Color3.new(1, 0, 0 + 0 ) ;
v192.BorderSizePixel = 1329 - (797 + 532) ;
v192.ZIndex = 75 + 27 ;
v192.Parent = v178;
local v200 = Instance.new("UICorner");
v200.CornerRadius = UDim.new(0, 2 + 3 );
v200.Parent = v192;
v152 = v152 + v150 + v151 ;
local v203 = Instance.new("TextLabel");
v203.Name = "SnaplinePositionLabel";
v203.Size = UDim2.new(0 - 0 , 1382 - (373 + 829) , 0, 751 - (476 + 255) );
v203.Position = UDim2.new(0, v149, 0, v152);
v203.BackgroundTransparency = 1131 - (369 + 761) ;
v203.TextColor3 = Color3.new(1 + 0 , 1, 1 - 0 );
v203.Text = "Position:";
v203.Font = Enum.Font.GothamBold;
v203.TextSize = 26 - 12 ;
v203.TextXAlignment = Enum.TextXAlignment.Left;
v203.ZIndex = 101;
v203.Parent = v127;
v152 = v152 + (258 - (64 + 174)) ;
local v215 = Instance.new("TextButton");
v215.Name = "SnaplinePositionDropdown";
v215.Size = UDim2.new(0 + 0 , 266 - 86 , 336 - (144 + 192) , v150);
v215.Position = UDim2.new(216 - (42 + 174) , v149, 0, v152);
v215.BackgroundColor3 = Color3.new(0.15 + 0 , 0.15 + 0 , 0.15 + 0 );
v215.TextColor3 = Color3.new(1505 - (363 + 1141) , 1, 1581 - (1183 + 397) );
v215.Text = v7.ESP.SnaplinePosition;
v215.Font = Enum.Font.GothamBold;
v215.TextSize = 42 - 28 ;
v215.TextXAlignment = Enum.TextXAlignment.Center;
v215.ZIndex = 101;
v215.Parent = v127;
local v229 = Instance.new("UICorner");
v229.CornerRadius = UDim.new(0, 5);
v229.Parent = v215;
v152 = v152 + v150 + v151 ;
local v232 = Instance.new("TextButton");
v232.Name = "RainbowButton";
v232.Size = UDim2.new(0 + 0 , 135 + 45 , 1975 - (1913 + 62) , v150);
v232.Position = UDim2.new(0 + 0 , v149, 0 - 0 , v152);
v232.BackgroundColor3 = Color3.new(1933.15 - (565 + 1368) , 0.15 - 0 , 1661.15 - (1477 + 184) );
v232.TextColor3 = Color3.new(1, 1 - 0 , 1 + 0 );
v232.Text = "Rainbow";
v232.Font = Enum.Font.GothamBold;
v232.TextSize = 870 - (564 + 292) ;
v232.ZIndex = 174 - 73 ;
v232.Parent = v127;
local v243 = Instance.new("UICorner");
v243.CornerRadius = UDim.new(0 - 0 , 309 - (244 + 60) );
v243.Parent = v232;
local v246 = Instance.new("Frame");
v246.Name = "RainbowIndicator";
v246.Size = UDim2.new(0 + 0 , 496 - (41 + 435) , 1001 - (938 + 63) , 16 + 4 );
v246.Position = UDim2.new(1126 - (936 + 189) , - 25, 0 + 0 , 1618 - (1565 + 48) );
v246.BackgroundColor3 = (v7.ESP.RainbowEnabled and Color3.new(0, 1 + 0 , 0)) or Color3.new(1139 - (782 + 356) , 0, 0) ;
v246.BorderSizePixel = 267 - (176 + 91) ;
v246.ZIndex = 265 - 163 ;
v246.Parent = v232;
local v254 = Instance.new("UICorner");
v254.CornerRadius = UDim.new(0 - 0 , 5);
v254.Parent = v246;
local v257 = 1102 - (975 + 117) ;
local v258 = 1905 - (157 + 1718) ;
local v259 = 9 + 1 ;
local v260 = 10;
local v261 = Instance.new("TextButton");
v261.Name = "AimbotButton";
v261.Size = UDim2.new(0 - 0 , 615 - 435 , 1018 - (697 + 321) , v258);
v261.Position = UDim2.new(0 - 0 , v257, 0 - 0 , v260);
v261.BackgroundColor3 = Color3.new(0.15 - 0 , 0.15, 0.15);
v261.TextColor3 = Color3.new(1, 1 + 0 , 1 - 0 );
v261.Text = "Aimbot";
v261.Font = Enum.Font.GothamBold;
v261.TextSize = 37 - 23 ;
v261.ZIndex = 1328 - (322 + 905) ;
v261.Parent = v135;
local v272 = Instance.new("UICorner");
v272.CornerRadius = UDim.new(611 - (602 + 9) , 1194 - (449 + 740) );
v272.Parent = v261;
local v275 = Instance.new("Frame");
v275.Name = "AimbotIndicator";
v275.Size = UDim2.new(872 - (826 + 46) , 967 - (245 + 702) , 0 - 0 , 7 + 13 );
v275.Position = UDim2.new(1, - (1923 - (260 + 1638)), 0, 445 - (382 + 58) );
v275.BackgroundColor3 = (v7.Aimbot.Enabled and Color3.new(0 - 0 , 1 + 0 , 0 - 0 )) or Color3.new(2 - 1 , 1205 - (902 + 303) , 0 - 0 ) ;
v275.BorderSizePixel = 0;
v275.ZIndex = 102;
v275.Parent = v261;
local v283 = Instance.new("UICorner");
v283.CornerRadius = UDim.new(0 - 0 , 1 + 4 );
v283.Parent = v275;
v260 = v260 + v258 + v259 ;
local v286 = Instance.new("TextButton");
v286.Name = "FOVToggleButton";
v286.Size = UDim2.new(1690 - (1121 + 569) , 180, 0, v258);
v286.Position = UDim2.new(214 - (22 + 192) , v257, 0, v260);
v286.BackgroundColor3 = Color3.new(683.15 - (483 + 200) , 1463.15 - (1404 + 59) , 0.15);
v286.TextColor3 = Color3.new(2 - 1 , 1 - 0 , 766 - (468 + 297) );
v286.Text = "FOV Circle";
v286.Font = Enum.Font.GothamBold;
v286.TextSize = 14;
v286.ZIndex = 101;
v286.Parent = v135;
local v297 = Instance.new("UICorner");
v297.CornerRadius = UDim.new(0, 5);
v297.Parent = v286;
local v300 = Instance.new("Frame");
v300.Name = "FOVToggleIndicator";
v300.Size = UDim2.new(0, 582 - (334 + 228) , 0 - 0 , 46 - 26 );
v300.Position = UDim2.new(1, - (45 - 20), 0 + 0 , 241 - (141 + 95) );
v300.BackgroundColor3 = (v7.Aimbot.ShowFOV and Color3.new(0, 1, 0 + 0 )) or Color3.new(1, 0 - 0 , 0 - 0 ) ;
v300.BorderSizePixel = 0 + 0 ;
v300.ZIndex = 279 - 177 ;
v300.Parent = v286;
local v308 = Instance.new("UICorner");
v308.CornerRadius = UDim.new(0 + 0 , 3 + 2 );
v308.Parent = v300;
v260 = v260 + v258 + v259 ;
local v311 = Instance.new("TextLabel");
v311.Name = "FOVLabel";
v311.Size = UDim2.new(0 - 0 , 180, 0 + 0 , 20);
v311.Position = UDim2.new(0, v257, 163 - (92 + 71) , v260);
v311.BackgroundTransparency = 1;
v311.TextColor3 = Color3.new(1, 1, 1);
v311.Text = "FOV:";
v311.Font = Enum.Font.GothamBold;
v311.TextSize = 7 + 7 ;
v311.ZIndex = 169 - 68 ;
v311.Parent = v135;
v260 = v260 + 20 ;
local v322 = Instance.new("TextBox");
v322.Name = "FOVTextBox";
v322.Size = UDim2.new(0, 180, 0, v258);
v322.Position = UDim2.new(0, v257, 0, v260);
v322.BackgroundColor3 = Color3.new(765.15 - (574 + 191) , 0.15 + 0 , 0.15 - 0 );
v322.TextColor3 = Color3.new(1, 1, 1 + 0 );
v322.Text = tostring(v7.Aimbot.FOV);
v322.Font = Enum.Font.GothamBold;
v322.TextSize = 863 - (254 + 595) ;
v322.ZIndex = 227 - (55 + 71) ;
v322.Parent = v135;
local v333 = Instance.new("UICorner");
v333.CornerRadius = UDim.new(0 - 0 , 5);
v333.Parent = v322;
v260 = v260 + v258 + v259 ;
local v336 = Instance.new("TextLabel");
v336.Name = "DistanceLabel";
v336.Size = UDim2.new(0, 1970 - (573 + 1217) , 0 - 0 , 2 + 18 );
v336.Position = UDim2.new(0 - 0 , v257, 0, v260);
v336.BackgroundTransparency = 940 - (714 + 225) ;
v336.TextColor3 = Color3.new(2 - 1 , 1, 1 - 0 );
v336.Text = "Max Distance:";
v336.Font = Enum.Font.GothamBold;
v336.TextSize = 2 + 12 ;
v336.ZIndex = 145 - 44 ;
v336.Parent = v135;
v260 = v260 + 20 ;
local v347 = Instance.new("TextBox");
v347.Name = "DistanceTextBox";
v347.Size = UDim2.new(806 - (118 + 688) , 180, 48 - (25 + 23) , v258);
v347.Position = UDim2.new(0 + 0 , v257, 1886 - (927 + 959) , v260);
v347.BackgroundColor3 = Color3.new(0.15 - 0 , 732.15 - (16 + 716) , 0.15 - 0 );
v347.TextColor3 = Color3.new(98 - (11 + 86) , 2 - 1 , 286 - (175 + 110) );
v347.Text = tostring(v7.Aimbot.MaxDistance);
v347.Font = Enum.Font.GothamBold;
v347.TextSize = 14;
v347.ZIndex = 101;
v347.Parent = v135;
local v358 = Instance.new("UICorner");
v358.CornerRadius = UDim.new(0 - 0 , 24 - 19 );
v358.Parent = v347;
local function v361(v398) local v399 = v398.Size;
    v398.MouseEnter:Connect(function () local v432 = 1796 - (503 + 1293) ;
        while true do
            if (v432 = = (0 - 0)) then
                v3:Create(v398, TweenInfo.new(0.2 + 0 ), {Size = v399 + UDim2.new(0, 5, 1061 - (810 + 251) , 4 + 1 ) }):Play();
                v398.BackgroundColor3 = Color3.new(0.25 + 0 , 0.25, 0.25);
                break;
            end
        end
    end
    );
    v398.MouseLeave:Connect(function () local v433 = 0;
        while true do
            if (v433 = = (0 + 0)) then
                v3:Create(v398, TweenInfo.new(533.2 - (43 + 490) ), {Size = v399}):Play();
                v398.BackgroundColor3 = Color3.new(733.15 - (711 + 22) , 0.15, 0.15 - 0 );
                break;
            end
        end
    end
    );
end
v361(v99);
v361(v113);
v361(v73);
local v362 = "ESP";
local function v363(v400) local v401 = 859 - (240 + 619) ;
    local v402;
    while true do
        if (v401 = = (0 + 0)) then
            v362 = v400;
            v127.Visible = v400 = = "ESP" ;
            v401 = 1 - 0 ;
        end
        if (v401 = = (1 + 0)) then
            v135.Visible = v400 = = "Aimbot" ;
            v402 = {v99, v113};
            v401 = 407 - (255 + 150) ;
        end
        if (v401 = = (2 + 0)) then
            for v519, v520 in ipairs(v402) do
                if (v520.Name = = (v400 .. "TabButton")) then
                    v520.BackgroundColor3 = Color3.new(0.2 + 0 , 0.2 - 0 , 0.2);
                    else v520.BackgroundColor3 = Color3.new(0.15 - 0 , 1739.15 - (404 + 1335) , 0.15);
                end
            end
            break;
        end
    end
end
v99.MouseButton1Click:Connect(function () v363("ESP");
end
);
v113.MouseButton1Click:Connect(function () v363("Aimbot");
end
);
v153.MouseButton1Click:Connect(function () v7.ESP.Enabled = not v7.ESP.Enabled;
    v3:Create(v167, TweenInfo.new(0.2), {BackgroundColor3 = (v7.ESP.Enabled and Color3.new(406 - (183 + 223) , 1, 0 - 0 )) or Color3.new(1 + 0 , 0 + 0 , 337 - (10 + 327) ) }):Play();
end
);
v261.MouseButton1Click:Connect(function () local v404 = 0 + 0 ;
    while true do
        if (v404 = = (338 - (118 + 220))) then
            v7.Aimbot.Enabled = not v7.Aimbot.Enabled;
            v3:Create(v275, TweenInfo.new(0.2 + 0 ), {BackgroundColor3 = (v7.Aimbot.Enabled and Color3.new(0, 1, 0)) or Color3.new(450 - (108 + 341) , 0 + 0 , 0 - 0 ) }):Play();
            break;
        end
    end
end
);
v286.MouseButton1Click:Connect(function () v7.Aimbot.ShowFOV = not v7.Aimbot.ShowFOV;
    v13.Visible = v7.Aimbot.ShowFOV;
    v3:Create(v300, TweenInfo.new(1493.2 - (711 + 782) ), {BackgroundColor3 = (v7.Aimbot.ShowFOV and Color3.new(0 - 0 , 470 - (270 + 199) , 0 + 0 )) or Color3.new(1820 - (580 + 1239) , 0 - 0 , 0 + 0 ) }):Play();
end
);
v178.MouseButton1Click:Connect(function () local v407 = 0 + 0 ;
    while true do
        if (v407 = = 0) then
            v7.ESP.SnaplineEnabled = not v7.ESP.SnaplineEnabled;
            v3:Create(v192, TweenInfo.new(0.2 + 0 ), {BackgroundColor3 = (v7.ESP.SnaplineEnabled and Color3.new(0 - 0 , 1, 0)) or Color3.new(1, 0, 0 + 0 ) }):Play();
            break;
        end
    end
end
);
v322.FocusLost:Connect(function (v408) if v408 then
    local v443 = 1167 - (645 + 522) ;
    local v444;
    while true do
        if (v443 = = 0) then
            v444 = tonumber(v322.Text);
            if (v444 and (v444 > = (1820 - (1010 + 780))) and (v444 < = 100)) then
                v7.Aimbot.FOV = v444;
                else v322.Text = tostring(v7.Aimbot.FOV);
            end
            break;
        end
    end
end
end
);
v347.FocusLost:Connect(function (v409) if v409 then
    local v445 = 0 + 0 ;
    local v446;
    while true do
        if (v445 = = (0 - 0)) then
            v446 = tonumber(v347.Text);
            if (v446 and (v446 > 0) and (v446 < = (2930 - 1930))) then
                v7.Aimbot.MaxDistance = v446;
                else v347.Text = tostring(v7.Aimbot.MaxDistance);
            end
            break;
        end
    end
end
end
);
local v364 = {"Center", "Bottom", "Top"};
local v365 = 1;
v215.MouseButton1Click:Connect(function () local v410 = 0 - 0 ;
    while true do
        if (v410 = = (505 - (351 + 154))) then
            v365 = v365 + (1575 - (1281 + 293)) ;
            if (v365 > #v364) then
                v365 = 1;
            end
            v410 = 267 - (28 + 238) ;
        end
        if (v410 = = (2 - 1)) then
            v7.ESP.SnaplinePosition = v364[v365];
            v215.Text = v7.ESP.SnaplinePosition;
            break;
        end
    end
end
);
v232.MouseButton1Click:Connect(function () local v411 = 1559 - (1381 + 178) ;
    while true do
        if (0 = = v411) then
            v7.ESP.RainbowEnabled = not v7.ESP.RainbowEnabled;
            v3:Create(v246, TweenInfo.new(0.2 + 0 ), {BackgroundColor3 = (v7.ESP.RainbowEnabled and Color3.new(0 + 0 , 1 + 0 , 0 - 0 )) or Color3.new(1 + 0 , 470 - (381 + 89) , 0) }):Play();
            break;
        end
    end
end
);
local v366 = true;
v2.InputBegan:Connect(function (v412) if (v412.KeyCode = = Enum.KeyCode.RightShift) then
    local v447 = 0 + 0 ;
    while true do
        if (v447 = = (1 + 0)) then
            if v366 then
                v87();
            end
            break;
        end
        if (v447 = = (0 - 0)) then
            v366 = not v366;
            v26.Visible = v366;
            v447 = 1157 - (1074 + 82) ;
        end
    end
end
end
);
local v367 = false;
local v368 = v26.Size;
local v369 = UDim2.new(0 - 0 , 2154 - (214 + 1570) , 1455 - (990 + 465) , 30);
v73.MouseButton1Click:Connect(function () local v413 = 0 + 0 ;
    while true do
        if (v413 = = (0 + 0)) then
            v367 = not v367;
            if v367 then
                local v532 = 0;
                local v533;
                while true do
                    if (v532 = = 1) then
                        v135.Visible = false;
                        v533 = v3:Create(v26, TweenInfo.new(0.3 + 0 ), {Size = v369});
                        v532 = 7 - 5 ;
                    end
                    if (0 = = v532) then
                        v88.Visible = false;
                        v127.Visible = false;
                        v532 = 1;
                    end
                    if ((1728 - (1668 + 58)) = = v532) then
                        v533:Play();
                        v73.Text = " + ";
                        break;
                    end
                end
                else local v534 = 626 - (512 + 114) ;
                local v535;
                while true do
                    if ((2 - 1) = = v534) then
                        v535.Completed:Connect(function () local v571 = 0 - 0 ;
                            while true do
                                if (v571 = = (0 - 0)) then
                                    v87();
                                    v363(v362);
                                    break;
                                end
                            end
                        end
                        );
                        v73.Text = " - ";
                        break;
                    end
                    if (v534 = = (0 + 0)) then
                        v535 = v3:Create(v26, TweenInfo.new(0.3 + 0 ), {Size = v368});
                        v535:Play();
                        v534 = 1 + 0 ;
                    end
                end
            end
            break;
        end
    end
end
);
local function v370() local v414 = 0;
    local v415;
    local v416;
    local v417;
    local v418;
    local v419;
    local v420;
    local v421;
    local v422;
    while true do
        if (v414 = = (6 - 4)) then
            v417 = Instance.new("UICorner");
            v417.CornerRadius = UDim.new(0, 15);
            v417.Parent = v416;
            v418 = Instance.new("UIGradient");
            v418.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(0.1, 1469.5 - (1269 + 200) , 1 - 0 )), ColorSequenceKeypoint.new(827 - (802 + 24) , Color3.new(0.8 - 0 , 0.2 - 0 , 1 + 0 ))});
            v414 = 3 + 0 ;
        end
        if (v414 = = (0 + 0)) then
            v415 = Instance.new("ScreenGui");
            v415.Name = "WelcomeNotification";
            v415.Parent = v4;
            v416 = Instance.new("Frame");
            v416.Size = UDim2.new(0 + 0 , 834 - 534 , 0 - 0 , 22 + 38 );
            v414 = 1 + 0 ;
        end
        if (v414 = = 6) then
            v420.Text = "Welcome!";
            v420.TextSize = 24;
            v420.Font = Enum.Font.GothamBold;
            v420.TextStrokeTransparency = 0.7 + 0 ;
            v420.TextStrokeColor3 = Color3.new(0 + 0 , 0, 0);
            v414 = 4 + 3 ;
        end
        if (v414 = = (1440 - (797 + 636))) then
            v420.Parent = v416;
            v421 = v3:Create(v416, TweenInfo.new(0.5 - 0 , Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, - (1769 - (1427 + 192)), 1 + 0 , - (162 - 92))});
            v421:Play();
            v421.Completed:Wait();
            wait(2 + 0 );
            v414 = 8;
        end
        if (v414 = = 8) then
            v422 = v3:Create(v416, TweenInfo.new(0.5 + 0 , Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(326.5 - (192 + 134) , - 150, 1277 - (316 + 960) , 56 + 44 )});
            v422:Play();
            v422.Completed:Wait();
            v415:Destroy();
            break;
        end
        if (v414 = = (4 + 1)) then
            v419.Parent = v416;
            v420 = Instance.new("TextLabel");
            v420.Size = UDim2.new(1 + 0 , 0 - 0 , 1, 551 - (83 + 468) );
            v420.BackgroundTransparency = 1807 - (1202 + 604) ;
            v420.TextColor3 = Color3.new(4 - 3 , 1, 1);
            v414 = 9 - 3 ;
        end
        if (v414 = = (2 - 1)) then
            v416.Position = UDim2.new(0.5, - (475 - (45 + 280)), 1 + 0 , 88 + 12 );
            v416.BackgroundColor3 = Color3.new(0 + 0 , 0, 0);
            v416.BackgroundTransparency = 0.2 + 0 ;
            v416.BorderSizePixel = 0 + 0 ;
            v416.Parent = v415;
            v414 = 3 - 1 ;
        end
        if (v414 = = 4) then
            v419.BackgroundTransparency = 1912 - (340 + 1571) ;
            v419.Image = "rbxassetid: / / 131604521";
            v419.ImageColor3 = Color3.new(0 + 0 , 1772 - (1733 + 39) , 0);
            v419.ImageTransparency = 0.5;
            v419.ZIndex = 271 - 172 ;
            v414 = 1039 - (125 + 909) ;
        end
        if (v414 = = (1951 - (1096 + 852))) then
            v418.Rotation = 21 + 24 ;
            v418.Parent = v416;
            v419 = Instance.new("ImageLabel");
            v419.Size = UDim2.new(1 - 0 , 10 + 0 , 513 - (409 + 103) , 246 - (46 + 190) );
            v419.Position = UDim2.new(0, - 5, 95 - (51 + 44) , - (2 + 3));
            v414 = 4;
        end
    end
end
v1.RenderStepped:Connect(function () local v423 = 1317 - (1114 + 203) ;
    while true do
        if (v423 = = (727 - (228 + 498))) then
            v13.Visible = v7.Aimbot.ShowFOV;
            if (v7.ESP.RainbowEnabled and v7.Aimbot.ShowFOV) then
                local v536 = 0;
                local v537;
                while true do
                    if (v536 = = 0) then
                        v537 = (tick() * v8) % 1 ;
                        v13.Color = Color3.fromHSV(v537, 1, 1 + 0 );
                        break;
                    end
                end
                elseif v7.Aimbot.ShowFOV then
                    v13.Color = Color3.new(1 + 0 , 1, 664 - (174 + 489) );
                end
                v423 = 5 - 3 ;
            end
            if ((1905 - (830 + 1075)) = = v423) then
                v13.Radius = (v7.Aimbot.FOV / 2) * (v5.ViewportSize.Y / (614 - (303 + 221))) ;
                v13.Position = Vector2.new(v5.ViewportSize.X / (1271 - (231 + 1038)) , v5.ViewportSize.Y / 2 );
                v423 = 1 + 0 ;
            end
            if ((1164 - (171 + 991)) = = v423) then
                for v521, v522 in pairs(v9) do
                    v11(v521, v522);
                end
                if v7.Aimbot.Enabled then
                    local v538 = 0 - 0 ;
                    local v539;
                    while true do
                        if (v538 = = (0 - 0)) then
                            v539 = v12();
                            if (v539 and v539.Character and v539.Character:FindFirstChild("Head")) then
                                v5.CFrame = CFrame.new(v5.CFrame.Position, v539.Character.Head.Position);
                            end
                            break;
                        end
                    end
                end
                break;
            end
        end
    end
    );
    for v424, v425 in ipairs(v0:GetPlayers()) do
        if (v425 ~ = v6) then
            v10(v425);
        end
    end
    v0.PlayerAdded:Connect(function (v426) v10(v426);
        v426.CharacterAdded:Connect(function () local v434 = 0 - 0 ;
            while true do
                if (v434 = = (0 + 0)) then
                    if v9[v426] then
                        local v551 = 0 - 0 ;
                        while true do
                            if (v551 = = 0) then
                                for v574, v575 in pairs(v9[v426]) do
                                    pcall(function () v575:Remove();
                                    end
                                    );
                                end
                                v9[v426] = nil;
                                break;
                            end
                        end
                    end
                    v10(v426);
                    break;
                end
            end
        end
        );
        v426.CharacterRemoving:Connect(function () if v9[v426] then
            local v511 = 0 - 0 ;
            while true do
                if (v511 = = 0) then
                    for v560, v561 in pairs(v9[v426]) do
                        pcall(function () v561:Remove();
                        end
                        );
                    end
                    v9[v426] = nil;
                    break;
                end
            end
        end
    end
    );
end
);
v0.PlayerRemoving:Connect(function (v427) if v9[v427] then
    for v512, v513 in pairs(v9[v427]) do
        pcall(function () v513:Remove();
        end
        );
    end
    v9[v427] = nil;
end
end
);
v370();
warn("✅ Script successfully activated!");
