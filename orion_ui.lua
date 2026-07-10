local OrionLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/source.txt"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
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

-- --- 自作Vfly用の変数 ---
local FlyEnabled = false
local FlySpeed = 16
local FlyConnection = nil
local BodyGyro = nil
local BodyVelocity = nil

-- --- タブ作成 ---
local PlayerTab = Window:MakeTab({ Name = "Player", Icon = "rbxassetid://13585613884", PremiumOnly = false })
local TeleportTab = Window:MakeTab({ Name = "Teleport", Icon = "rbxassetid://7733992829", PremiumOnly = false }) 
local DefenseTab = Window:MakeTab({ Name = "Defense", Icon = "rbxassetid://7734056608", PremiumOnly = false })
local BlobmanTab = Window:MakeTab({ Name = "Blobman", Icon = "rbxassetid://13585613884", PremiumOnly = false })

-- --- Player タブ (既存機能 + 自作Vfly) ---
PlayerTab:AddToggle({ Name = "WalkspeedOverride", Default = false, Callback = function(Value) _G.WalkspeedOverride = Value end })
PlayerTab:AddSlider({ Name = "Speed Multiplier", Min = 1, Max = 10, Default = 1, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "Speed", Callback = function(Value) _G.SpeedMultiplier = Value end })
PlayerTab:AddToggle({ Name = "JumpPowerOverride", Default = false, Callback = function(Value) _G.JumpPowerOverride = Value end })
PlayerTab:AddSlider({ Name = "Jump Multiplier", Min = 1, Max = 10, Default = 1, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "Jump", Callback = function(Value) _G.JumpMultiplier = Value end })
PlayerTab:AddToggle({ Name = "Infinite Jump", Default = false, Callback = function(Value) _G.InfiniteJump = Value end })

-- --- Vfly用コントロール (自動再搭乗・オブジェクト存在確認付き) ---
PlayerTab:AddToggle({
    Name = "Vfly (Vehicle Fly)",
    Default = false,
    Callback = function(Value)
        FlyEnabled = Value
        
        if FlyConnection then 
            FlyConnection:Disconnect() 
            FlyConnection = nil 
        end
        if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
        if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end

        if FlyEnabled then
            task.spawn(function()
                local char = player.Character
                if not char then return end
                
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                -- 最初に座っているシートを記憶
                local currentSeat = humanoid and humanoid.SeatPart
                local targetPart = currentSeat or char:FindFirstChild("HumanoidRootPart")
                
                if not targetPart then return end

                BodyGyro = Instance.new("BodyGyro")
                BodyGyro.P = 500000
                BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                BodyGyro.cframe = targetPart.CFrame
                BodyGyro.Parent = targetPart

                BodyVelocity = Instance.new("BodyVelocity")
                BodyVelocity.velocity = Vector3.new(0, 0, 0)
                BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
                BodyVelocity.Parent = targetPart

                FlyConnection = RunService.RenderStepped:Connect(function()
                    if not FlyEnabled or not targetPart or not targetPart.Parent then
                        if FlyConnection then FlyConnection:Disconnect() FlyConnection = nil end
                        return
                    end

                    -- 【新規追加】もしシートから降りてしまった場合の検知と自動再搭乗
                    if currentSeat and currentSeat.Parent then
                        if humanoid and humanoid.SeatPart == nil then
                            -- 降りてしまった場合、一度乗り物の動きを安全に止める
                            BodyVelocity.velocity = Vector3.new(0, 0, 0)
                            targetPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            
                            -- オブジェクトがまだ存在するか、親が workspace 内にあるかを確認
                            if currentSeat:IsDescendantOf(workspace) then
                                currentSeat:Sit(humanoid) -- 強制的に再搭乗
                            end
                        end
                    end

                    if humanoid and humanoid.SeatPart then
                        targetPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        targetPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end

                    local cameraCFrame = workspace.CurrentCamera.CFrame
                    BodyGyro.cframe = cameraCFrame

                    local UserInputService = game:GetService("UserInputService")
                    local direction = Vector3.new(0, 0, 0)

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        direction = direction + cameraCFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        direction = direction - cameraCFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        direction = direction - cameraCFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        direction = direction + cameraCFrame.RightVector
                    end

                    if direction.Magnitude > 0 then
                        BodyVelocity.velocity = direction.Unit * FlySpeed * 16
                    else
                        BodyVelocity.velocity = Vector3.new(0, 0, 0)
                    end
                end)
            end)
        else
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and not hum.Sit then 
                    hum:ChangeState(Enum.HumanoidStateType.Freefall) 
                end
            end
        end
    end
})

PlayerTab:AddSlider({
    Name = "Fly Speed",
    Min = 1,
    Max = 10,
    Default = 1,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "speed",
    Callback = function(Value)
        FlySpeed = Value
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
