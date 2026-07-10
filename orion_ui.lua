local OrionLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/source.txt"))()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local Window = OrionLibrary:MakeWindow({
    Name = "(＃°Д°)HUB (FTAP)",
    HidePremium = false, 
    SaveConfig = true,
    ConfigFolder = "emojiHUB",
    KeyToOpenWindow = "RightShift",
    FreeMouse = true
})

local TextChatService = game:GetService("TextChatService")
local textChannels = TextChatService:FindFirstChild("TextChannels")
local generalChannel = textChannels and textChannels:FindFirstChild("RBXGeneral")

if generalChannel then
    generalChannel:SendAsync("(＃°Д°)HUB(公開鯖テスト中)起動完了(•ω•)")
end

local SelectedPlayerName = ""      
local SelectedBlobmanTarget = ""   

-- --- タブ作成 ---
local PlayerTab = Window:MakeTab({ Name = "Player", Icon = "rbxassetid://13585613884", PremiumOnly = false })
local TeleportTab = Window:MakeTab({ Name = "Teleport", Icon = "rbxassetid://7733992829", PremiumOnly = false }) 
local DefenseTab = Window:MakeTab({ Name = "Defense", Icon = "rbxassetid://7734056608", PremiumOnly = false })
local BlobmanTab = Window:MakeTab({ Name = "Blobman", Icon = "rbxassetid://13585613884", PremiumOnly = false })

-- --- Player タブ (既存機能) ---
PlayerTab:AddToggle({ Name = "WalkspeedOverride", Default = false, Callback = function(Value) _G.WalkspeedOverride = Value end })
PlayerTab:AddSlider({ Name = "Speed Multiplier", Min = 1, Max = 10, Default = 1, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "Speed", Callback = function(Value) _G.SpeedMultiplier = Value end })
PlayerTab:AddToggle({ Name = "JumpPowerOverride", Default = false, Callback = function(Value) _G.JumpPowerOverride = Value end })
PlayerTab:AddSlider({ Name = "Jump Multiplier", Min = 1, Max = 10, Default = 1, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "Jump", Callback = function(Value) _G.JumpMultiplier = Value end })
PlayerTab:AddToggle({ Name = "Infinite Jump", Default = false, Callback = function(Value) _G.InfiniteJump = Value end })

PlayerTab:AddButton({
    Name = "VFLY",
    Callback = function()
        -- すでに起動している場合は重複防止で削除
        if game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("main") then
            game.Players.LocalPlayer.PlayerGui.main:Destroy()
        end

        -- 元のVfly GUIコードをそのまま生成（独立動作）
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
        main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
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
        TextLabel.Text = "FLY GUI V3"
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

        local speeds = 1
        local speaker = game:GetService("Players").LocalPlayer
        local nowe = false

        game:GetService("StarterGui"):SetCore("SendNotification", { 
            Title = "FLY GUI V3";
            Text = "BY XNEO";
            Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"
        })

        Frame.Active = true
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
                        if speed > maxspeed then speed = maxspeed end
                    elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                        speed = speed-1
                        if speed < 0 then speed = 0 end
                    end
                    if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                        bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                        lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                    elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                        bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                    else
                        bv.velocity = Vector3.new(0,0,0)
                    end
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
                local ctrl = {f = 0, b = 0, l = 0, r = 0}
                local lastctrl = {f = 0, b = 0, l = 0, r = 0}
                local maxspeed = 50
                local speed = 0

                local bg = Instance.new("BodyGyro", UpperTorso)
                bg.P = 9e4
                bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.cframe = UpperTorso.CFrame
                local bv = Instance.new("BodyVelocity", UpperTorso)
                bv.velocity = Vector3.new(0,0.1,0)
                bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                if nowe == true then
                    plr.Character.Humanoid.PlatformStand = true
                end
                while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
                    wait()

                    if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                        speed = speed+.5+(speed/maxspeed)
                        if speed > maxspeed then speed = maxspeed end
                    elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                        speed = speed-1
                        if speed < 0 then speed = 0 end
                    end
                    if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                        bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                        lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                    elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                        bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                    else
                        bv.velocity = Vector3.new(0,0,0)
                    end
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
            end
        end)

        local tis
        up.MouseButton1Down:connect(function()
            tis = up.MouseEnter:connect(function()
                while tis do
                    wait()
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,0)
                end
            end)
        end)
        up.MouseLeave:connect(function()
            if tis then tis:Disconnect() tis = nil end
        end)

        local dis
        down.MouseButton1Down:connect(function()
            dis = down.MouseEnter:connect(function()
                while dis do
                    wait()
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,-1,0)
                end
            end)
        end)
        down.MouseLeave:connect(function()
            if dis then dis:Disconnect() dis = nil end
        end)

        plus.MouseButton1Down:connect(function()
            speeds = speeds + 1
            speed.Text = speeds
            if nowe == true then
                tpwalking = false
                for i = 1, speeds do
                    spawn(function()
                        local hb = game:GetService("RunService").Heartbeat	
                        tpwalking = true
                        local chr = game.Players.LocalPlayer.Character
                        local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                        while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                            if hum.MoveDirection.Magnitude > 0 then chr:TranslateBy(hum.MoveDirection) end
                        end
                    end)
                end
            end
        end)

        mine.MouseButton1Down:connect(function()
            if speeds == 1 then
                speed.Text = 'cannot be less than 1'
                wait(1)
                speed.Text = speeds
            else
                speeds = speeds - 1
                speed.Text = speeds
                if nowe == true then
                    tpwalking = false
                    for i = 1, speeds do
                        spawn(function()
                            local hb = game:GetService("RunService").Heartbeat	
                            tpwalking = true
                            local chr = game.Players.LocalPlayer.Character
                            local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                            while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                                if hum.MoveDirection.Magnitude > 0 then chr:TranslateBy(hum.MoveDirection) end
                            end
                        end)
                    end
                end
            end
        end)

        closebutton.MouseButton1Click:Connect(function() main:Destroy() end)
        mini.MouseButton1Click:Connect(function()
            up.Visible = false down.Visible = false onof.Visible = false plus.Visible = false
            speed.Visible = false mine.Visible = false mini.Visible = false mini2.Visible = true
            main.Frame.BackgroundTransparency = 1 closebutton.Position =  UDim2.new(0, 0, -1, 57)
        end)
        mini2.MouseButton1Click:Connect(function()
            up.Visible = true down.Visible = true onof.Visible = true plus.Visible = true
            speed.Visible = true mine.Visible = true mini.Visible = true mini2.Visible = false
            main.Frame.BackgroundTransparency = 0 closebutton.Position =  UDim2.new(0, 0, -1, 27)
        end)
    end
})

-- --- ドロップダウンデータ生成 ---
local function GetPlayerDropdownData()
    local displayList = {}
    local nameMap = {} 
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local formattedName = p.DisplayName .. " (@" .. p.Name .. ")"
            table.insert(displayList, formattedName)
            nameMap[formattedName] = p.Name
        end
    end
    return displayList, nameMap
end

local currentDisplayList, currentNameMap = GetPlayerDropdownData()

-- --- Teleport タブ ---
local PlayerDropdown = TeleportTab:AddDropdown({
    Name = "Select Player", 
    Default = "None", 
    Options = currentDisplayList,
    Callback = function(Value) 
        SelectedPlayerName = currentNameMap[Value] or "" 
    end
})

local function RefreshDropdown()
    currentDisplayList, currentNameMap = GetPlayerDropdownData()
    PlayerDropdown:Refresh(currentDisplayList, true)
end

Players.PlayerAdded:Connect(RefreshDropdown)
Players.PlayerRemoving:Connect(RefreshDropdown)

-- --- TPSトグル ---
PlayerTab:AddToggle({ 
    Name = "Enable TPS (Max 500 Studs)", 
    Default = false, 
    Callback = function(Value) 
        _G.TPSToggle = Value 
        if not Value and player then 
            player.CameraMode = Enum.CameraMode.Classic 
            player.CameraMaxZoomDistance = 12 
            player.CameraMinZoomDistance = 0.5 
        end 
    end 
})

-- --- テレポートボタン ---
TeleportTab:AddButton({
    Name = "Teleport Behind Player",
    Callback = function()
        if SelectedPlayerName ~= "" then
            local targetPlayer = Players:FindFirstChild(SelectedPlayerName)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                end
            end
        end
    end
})

-- --- Defense タブ ---
local RS = game:GetService("ReplicatedStorage")
local R = game:GetService("RunService")
local CE = RS:WaitForChild("CharacterEvents", 5) 
local StruggleEvent = CE and CE:WaitForChild("Struggle", 5)
local BeingHeld = player:WaitForChild("IsHeld", 5)

local AntiExplosionEnabled = true
local AntiGrabEnabled = true
local AntiSitEnabled = true

workspace.DescendantAdded:Connect(function(v) 
    if AntiExplosionEnabled and v:IsA("Explosion") then 
        v.BlastPressure = 0 
    end 
end)

R.Heartbeat:Connect(function()
    if not AntiGrabEnabled then return end
    
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    
    local physicalGrab = char:FindFirstChildOfClass("Weld") or char:FindFirstChildOfClass("WeldConstraint")
    
    if (BeingHeld and BeingHeld.Value == true) or physicalGrab then
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
        
        if StruggleEvent then
            StruggleEvent:FireServer(player)
        end
        
        if physicalGrab then
            physicalGrab:Destroy()
        end
        
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        end
    end
end)

local function reconnect(Character)
    if not Character then return end
    local Humanoid = Character:WaitForChild("Humanoid", 10)
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 10)
    
    if HumanoidRootPart then 
        local firePart = HumanoidRootPart:WaitForChild("FirePlayerPart", 3) 
        if firePart then firePart:Destroy() end 
    end
    
    if Humanoid then
        Humanoid.Changed:Connect(function(C)
            if AntiSitEnabled and C == "Sit" and Humanoid.Sit == true then
                if Humanoid.SeatPart ~= nil and tostring(Humanoid.SeatPart.Parent) == "CreatureBlobman" then
                elseif Humanoid.SeatPart == nil then 
                    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true) 
                    Humanoid.Sit = false 
                end
            end
        end)
    end
end

if player.Character then task.spawn(reconnect, player.Character) end
player.CharacterAdded:Connect(function(char) task.spawn(reconnect, char) end)

DefenseTab:AddToggle({ Name = "Anti Explosion (No Knockback)", Default = true, Callback = function(Value) AntiExplosionEnabled = Value end })
DefenseTab:AddToggle({ Name = "Anti Grab (Auto Struggle)", Default = true, Callback = function(Value) AntiGrabEnabled = Value end })
DefenseTab:AddToggle({ Name = "Anti Sit (Auto Unsit)", Default = true, Callback = function(Value) AntiSitEnabled = Value end })

local BlobmanKickLoop = false    

local SpawnToyRF = game:GetService("ReplicatedStorage"):WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction")
local DeleteToyRE = game:GetService("ReplicatedStorage"):WaitForChild("MenuToys"):WaitForChild("DestroyToy")

local function GetBlobmanDropdownData()
    local displayList = {}
    local nameMap = {} 
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local formattedName = p.DisplayName .. " (@" .. p.Name .. ")"
            table.insert(displayList, formattedName)
            nameMap[formattedName] = p.Name
        end
    end
    return displayList, nameMap
end
local bDisplayList, bNameMap = GetBlobmanDropdownData()

local BlobmanTargetDropdown = BlobmanTab:AddDropdown({
    Name = "Select Target Player", 
    Default = "None", 
    Options = bDisplayList,
    Callback = function(Value) 
        SelectedBlobmanTarget = bNameMap[Value] or "" 
    end
})

BlobmanTab:AddButton({
    Name = "Refresh Player List",
    Callback = function()
        local newList, newMap = GetBlobmanDropdownData()
        bNameMap = newMap
        BlobmanTargetDropdown:Refresh(newList, true)
    end
})

BlobmanTab:AddToggle({
    Name = "Blobman Spam Kick",
    Default = false,
    Callback = function(Value)
        BlobmanKickLoop = Value
        
        if Value then
            if SelectedBlobmanTarget == "" then 
                OrionLibrary:MakeNotification({Name = "Error", Content = "対象プレイヤーを選択してください", Time = 3})
                return 
            end
            
            local targetPlayer = Players:FindFirstChild(SelectedBlobmanTarget)
            if not targetPlayer or not targetPlayer.Character then 
                OrionLibrary:MakeNotification({Name = "Error", Content = "対象プレイヤーが見つかりません", Time = 3})
                return 
            end

            task.spawn(function()
                while BlobmanKickLoop do
                    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local targetHRP = targetPlayer.Character.HumanoidRootPart
                        
                        local spawnArgs = {
                            "CreatureBlobman", 
                            targetHRP.CFrame * CFrame.new(0, 3, 0), 
                            Vector3.new(0, 0, 0)
                        }
                        
                        task.spawn(function()
                            local spawnedToy = SpawnToyRF:InvokeServer(unpack(spawnArgs))
                            if spawnedToy then
                                DeleteToyRE:FireServer(spawnedToy)
                            end
                        end)
                        
                        local myToysFolder = workspace:FindFirstChild(player.Name .. "SpawnedInToys")
                        if myToysFolder then
                            for _, toy in ipairs(myToysFolder:GetChildren()) do
                                if toy.Name == "CreatureBlobman" then
                                    DeleteToyRE:FireServer(toy)
                                end
                            end
                        end
                    else
                        break
                    end
                    task.wait(0.01) 
                end
            end)
        end
    end
})

OrionLibrary:Init()
