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

-- --- Vfly 変数とロジック ---
local vflyEnabled = false
local vflySpeed = 1
local tpwalking = false
local kdown, kup

local function getTargetPart()
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.SeatPart then
            return humanoid.SeatPart -- 乗り物の座席を対象にする(Vfly)
        end
        return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    end
    return nil
end

-- --- Player タブ ---
PlayerTab:AddToggle({ Name = "WalkspeedOverride", Default = false, Callback = function(Value) _G.WalkspeedOverride = Value end })
PlayerTab:AddSlider({ Name = "Speed Multiplier", Min = 1, Max = 10, Default = 1, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "Speed", Callback = function(Value) _G.SpeedMultiplier = Value end })
PlayerTab:AddToggle({ Name = "JumpPowerOverride", Default = false, Callback = function(Value) _G.JumpPowerOverride = Value end })
PlayerTab:AddSlider({ Name = "Jump Multiplier", Min = 1, Max = 10, Default = 1, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "Jump", Callback = function(Value) _G.JumpMultiplier = Value end })
PlayerTab:AddToggle({ Name = "Infinite Jump", Default = false, Callback = function(Value) _G.InfiniteJump = Value end })

PlayerTab:AddLabel("--- Vfly Settings ---")
PlayerTab:AddSlider({
    Name = "Vfly Speed",
    Min = 1,
    Max = 10,
    Default = 1,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        vflySpeed = Value
    end
})

PlayerTab:AddToggle({
    Name = "Vehicle Fly (Vfly)",
    Default = false,
    Callback = function(Value)
        vflyEnabled = Value
        
        if not Value then
            -- OFFの時の処理
            if player.Character and player.Character:FindFirstChildWhichIsA("Humanoid") then
                local hum = player.Character:FindFirstChildWhichIsA("Humanoid")
                hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
                hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
                hum.PlatformStand = false
            end
            if player.Character and player.Character:FindFirstChild("Animate") then
                player.Character.Animate.Disabled = false
            end
            if kdown then kdown:Disconnect() end
            if kup then kup:Disconnect() end
            tpwalking = false
        else
            -- ONの時の処理
            for i = 1, vflySpeed do
                task.spawn(function()
                    local hb = game:GetService("RunService").Heartbeat    
                    tpwalking = true
                    while tpwalking and hb:Wait() do
                        local chr = player.Character
                        local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                        if chr and hum and hum.Parent and hum.MoveDirection.Magnitude > 0 then
                            chr:TranslateBy(hum.MoveDirection)
                        end
                    end
                end)
            end
            
            if player.Character and player.Character:FindFirstChild("Animate") then
                player.Character.Animate.Disabled = true
            end
            
            local Char = player.Character
            local Hum = Char and (Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController"))
            if Hum and Hum:IsA("Humanoid") then
                for i,v in next, Hum:GetPlayingAnimationTracks() do
                    v:AdjustSpeed(0)
                end
                Hum:ChangeState(Enum.HumanoidStateType.Swimming)
            end

            task.spawn(function()
                local ctrl = {f = 0, b = 0, l = 0, r = 0}
                local lastctrl = {f = 0, b = 0, l = 0, r = 0}
                local maxspeed = 50 * vflySpeed
                local speed = 0

                kdown = mouse.KeyDown:Connect(function(key)
                    if key:lower() == "w" then ctrl.f = 1
                    elseif key:lower() == "s" then ctrl.b = -1
                    elseif key:lower() == "a" then ctrl.l = -1
                    elseif key:lower() == "d" then ctrl.r = 1
                    end
                end)
                kup = mouse.KeyUp:Connect(function(key)
                    if key:lower() == "w" then ctrl.f = 0
                    elseif key:lower() == "s" then ctrl.b = 0
                    elseif key:lower() == "a" then ctrl.l = 0
                    elseif key:lower() == "d" then ctrl.r = 0
                    end
                end)

                local targetPart = getTargetPart()
                if not targetPart then return end

                local bg = Instance.new("BodyGyro")
                bg.P = 9e4
                bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.cframe = targetPart.CFrame
                bg.Parent = targetPart

                local bv = Instance.new("BodyVelocity")
                bv.velocity = Vector3.new(0, 0.1, 0)
                bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                bv.Parent = targetPart

                if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                    player.Character.Humanoid.PlatformStand = true
                end

                while vflyEnabled and player.Character and player.Character:FindFirstChildOfClass("Humanoid") and player.Character.Humanoid.Health > 0 do
                    game:GetService("RunService").RenderStepped:Wait()

                    local currentTarget = getTargetPart()
                    if currentTarget and currentTarget ~= targetPart then
                        bg.Parent = currentTarget
                        bv.Parent = currentTarget
                        targetPart = currentTarget
                    end

                    if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                        speed = speed + 0.5 + (speed / maxspeed)
                        if speed > maxspeed then speed = maxspeed end
                    else
                        speed = speed - 1
                        if speed < 0 then speed = 0 end
                    end

                    local camera = workspace.CurrentCamera
                    if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                        bv.velocity = ((camera.CFrame.LookVector * (ctrl.f + ctrl.b)) + ((camera.CFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).Position) - camera.CFrame.Position)) * speed
                        lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                    elseif speed ~= 0 then
                        bv.velocity = ((camera.CFrame.LookVector * (lastctrl.f + lastctrl.b)) + ((camera.CFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * 0.2, 0).Position) - camera.CFrame.Position)) * speed
                    else
                        bv.velocity = Vector3.new(0, 0, 0)
                    end

                    bg.cframe = camera.CFrame * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * speed / maxspeed), 0, 0)
                end

                bg:Destroy()
                bv:Destroy()
                if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                    player.Character.Humanoid.PlatformStand = false
                end
                if player.Character and player.Character:FindFirstChild("Animate") then
                    player.Character.Animate.Disabled = false
                end
                tpwalking = false
            end)
        end
    end
})

PlayerTab:AddButton({
    Name = "Vfly UP",
    Callback = function()
        local root = player.Character and (player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso"))
        if root then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            local target = (hum and hum.SeatPart) or root
            target.CFrame = target.CFrame * CFrame.new(0, 5, 0)
        end
    end
})

PlayerTab:AddButton({
    Name = "Vfly DOWN",
    Callback = function()
        local root = player.Character and (player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso"))
        if root then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            local target = (hum and hum.SeatPart) or root
            target.CFrame = target.CFrame * CFrame.new(0, -5, 0)
        end
    end
})

PlayerTab:AddLabel("--- Camera Settings (TPS) ---")

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
                    -- 特定の乗り物は許可
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
