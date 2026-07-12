local OrionLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/source.txt"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

_G.WalkspeedOverride = false
_G.SpeedMultiplier = 1
_G.JumpPowerOverride = false
_G.JumpMultiplier = 1
_G.InfiniteJump = false
_G.TPSToggle = false

local FlyEnabled = false
local FlySpeed = 16
local FlyConnection = nil
local BodyGyro = nil
local BodyVelocity = nil

local AntiExplosionEnabled = false
local AntiGrabEnabled = false
local AntiSitEnabled = false
local BlobmanKickLoop = false    

local IsLoadingConfig = true 

local Window = OrionLibrary:MakeWindow({
    Name = "(＃°Д°)HUB (FTAP)",
    HidePremium = false, 
    SaveConfig = false,
    ConfigFolder = "TestHUB",
    KeyToOpenWindow = "RightShift",
    FreeMouse = true
})

-- 💡 他言語から起動された（_G.SkipChatLog が true）場合はチャットを送らない
if not _G.SkipChatLog then
    local TextChatService = game:GetService("TextChatService")
    local textChannels = TextChatService:FindFirstChild("TextChannels")
    local generalChannel = textChannels and textChannels:FindFirstChild("RBXGeneral")

    if generalChannel then
        generalChannel:SendAsync("(＃°Д°)HUB by 自作テスター,初心者チーター(公開鯖テスト)起動完了(•ω•)")
    end
end
_G.SkipChatLog = nil -- 次回のためにリセット

local SelectedPlayerName = ""      
local SelectedBlobmanTarget = ""   

local otherlanguage = Window:MakeTab({ Name = "Otherlanguages", Icon = "rbxassetid://93278098923938", PremiumOnly = false})
local PlayerTab = Window:MakeTab({ Name = "Player", Icon = "rbxassetid://13585613884", PremiumOnly = false })
local TeleportTab = Window:MakeTab({ Name = "Teleport", Icon = "rbxassetid://7733992829", PremiumOnly = false }) 
local DefenseTab = Window:MakeTab({ Name = "Defense", Icon = "rbxassetid://7734056608", PremiumOnly = false })
local BlobmanTab = Window:MakeTab({ Name = "Blobman", Icon = "rbxassetid://13585613884", PremiumOnly = false })

-- 💡 ボタンを押した時は目印を true にしてから読み込む
otherlanguage:AddButton({Name = "JP版起動", Callback = function() _G.SkipChatLog = true loadstring(game:HttpGet("https://raw.githubusercontent.com/adayoooooooo/Test-HUB/refs/heads/main/orion_ui_jp.lua"))() end})
_G.O_WalkspeedOverride = PlayerTab:AddToggle({ Name = "Walkspeed Override", Default = false, Flag = "Flag_WalkspeedOverride", Callback = function(Value) if not IsLoadingConfig then _G.WalkspeedOverride = Value end end })[cite: 1]
_G.O_SpeedMultiplier = PlayerTab:AddSlider({ Name = "Speed Multiplier", Min = 1, Max = 10, Default = 1, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "Speed", Flag = "Flag_SpeedMultiplier", Callback = function(Value) if not IsLoadingConfig then _G.SpeedMultiplier = Value end end })[cite: 1]
_G.O_JumpPowerOverride = PlayerTab:AddToggle({ Name = "Jump Power Override", Default = false, Flag = "Flag_JumpPowerOverride", Callback = function(Value) if not IsLoadingConfig then _G.JumpPowerOverride = Value end end })[cite: 1]
_G.O_JumpMultiplier = PlayerTab:AddSlider({ Name = "Jump Multiplier", Min = 1, Max = 10, Default = 1, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "Jump", Flag = "Flag_JumpMultiplier", Callback = function(Value) if not IsLoadingConfig then _G.JumpMultiplier = Value end end })[cite: 1]
_G.O_InfiniteJump = PlayerTab:AddToggle({ Name = "Infinite Jump", Default = false, Flag = "Flag_InfiniteJump", Callback = function(Value) if not IsLoadingConfig then _G.InfiniteJump = Value end end })[cite: 1]

_G.O_VflyToggle = PlayerTab:AddToggle({
    Name = "Vfly (Vehicle Fly)",
    Default = false,
    Flag = "Flag_VflyToggle",
    Callback = function(Value)
        if IsLoadingConfig then return end
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

                    if currentSeat and currentSeat.Parent then
                        if humanoid and humanoid.SeatPart == nil then
                            BodyVelocity.velocity = Vector3.new(0, 0, 0)
                            targetPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            if currentSeat:IsDescendantOf(workspace) then
                                currentSeat:Sit(humanoid) 
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

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + cameraCFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - cameraCFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - cameraCFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + cameraCFrame.RightVector end

                    if direction.Magnitude > 0 then
                        BodyVelocity.velocity = direction.Unit * (16 * FlySpeed)
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

_G.O_FlySpeed = PlayerTab:AddSlider({
    Name = "Fly Speed",
    Min = 1, Max = 10, Default = 1,
    Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "speed",
    Flag = "Flag_FlySpeed",
    Callback = function(Value) if not IsLoadingConfig then FlySpeed = Value end end
})

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

_G.O_TPSToggle = PlayerTab:AddToggle({ 
    Name = "Enable TPS (Max 500 Studs)", 
    Default = false, 
    Flag = "Flag_TPSToggle",
    Callback = function(Value) 
        if IsLoadingConfig then return end
        _G.TPSToggle = Value 
        if not Value and player then 
            player.CameraMode = Enum.CameraMode.Classic 
            player.CameraMaxZoomDistance = 12 
            player.CameraMinZoomDistance = 0.5 
        end 
    end 
})

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

local RS = game:GetService("ReplicatedStorage")
local R = game:GetService("RunService")
local CE = RS:WaitForChild("CharacterEvents", 5) 
local StruggleEvent = CE and CE:WaitForChild("Struggle", 5)
local BeingHeld = player:WaitForChild("IsHeld", 5)

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

_G.O_AntiExplosionEnabled = DefenseTab:AddToggle({ Name = "Anti Explosion (No Knockback)", Default = false, Flag = "Flag_AntiExplosionEnabled", Callback = function(Value) if not IsLoadingConfig then AntiExplosionEnabled = Value end end })
_G.O_AntiGrabEnabled = DefenseTab:AddToggle({ Name = "Anti Grab (Auto Struggle)", Default = false, Flag = "Flag_AntiGrabEnabled", Callback = function(Value) if not IsLoadingConfig then AntiGrabEnabled = Value end end })
_G.O_AntiSitEnabled = DefenseTab:AddToggle({ Name = "Anti Sit (Auto Unsit)", Default = false, Flag = "Flag_AntiSitEnabled", Callback = function(Value) if not IsLoadingConfig then AntiSitEnabled = Value end end })

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

_G.O_BlobmanKickLoop = BlobmanTab:AddToggle({
    Name = "Blobman Spam Kick",
    Default = false,
    Flag = "Flag_BlobmanKickLoop",
    Callback = function(Value)
        if IsLoadingConfig then return end
        BlobmanKickLoop = Value
        
        if Value then
            if SelectedBlobmanTarget == "" then 
                OrionLibrary:MakeNotification({Name = "Error", Content = "Please select a target player.", Time = 3})
                return 
            end
            
            local targetPlayer = Players:FindFirstChild(SelectedBlobmanTarget)
            if not targetPlayer or not targetPlayer.Character then 
                OrionLibrary:MakeNotification({Name = "Error", Content = "Target player not found.", Time = 3})
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

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local char = player.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if _G.WalkspeedOverride then
                    humanoid.WalkSpeed = (_G.SpeedMultiplier or 1) * 16
                end
                if _G.JumpPowerOverride then
                    humanoid.UseJumpPower = true
                    humanoid.JumpPower = (_G.JumpMultiplier or 1) * 50
                end
            end
        end)
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfiniteJump then
        pcall(function()
            local char = player.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
    end
end)

local SaveTab = Window:MakeTab({ Name = "Save", Icon = "rbxassetid://7734053495", PremiumOnly = false })

local HttpService = game:GetService("HttpService")
local CONFIG_DIR = "TestHUB_Configs/" 

if makefolder then pcall(function() makefolder(CONFIG_DIR) end) end

local function GetSavedFiles()
    local files = {"default"}
    if listfiles then
        pcall(function()
            for _, path in ipairs(listfiles(CONFIG_DIR)) do
                local name = path:match("([^/]+)%.json$") or path:match("([^\\]+)%.json$")
                if name and name ~= "default" then
                    table.insert(files, name)
                end
            end
        end)
    end
    return files
end

local SavedFilesList = GetSavedFiles()
local SelectedFileName = "default"
local InputFileNameText = ""

local FileDropdown = SaveTab:AddDropdown({
    Name = "Select File",
    Default = "default",
    Options = SavedFilesList,
    Callback = function(Value)
        SelectedFileName = Value
    end
})

SaveTab:AddTextbox({
    Name = "File Name Input (New File Only)",
    Default = "",
    TextDisappear = false,
    Callback = function(Value)
        InputFileNameText = Value
    end
})

SaveTab:AddButton({
    Name = "New File",
    Callback = function()
        if InputFileNameText ~= "" then
            local exists = false
            for _, name in ipairs(SavedFilesList) do
                if name == InputFileNameText then exists = true break end
            end
            
            if not exists then
                table.insert(SavedFilesList, InputFileNameText)
                SelectedFileName = InputFileNameText 
                FileDropdown:Refresh(SavedFilesList, true)
                OrionLibrary:MakeNotification({Name = "Success", Content = "Registered new file name. You can save from Select File: " .. InputFileNameText, Time = 4})
            else
                OrionLibrary:MakeNotification({Name = "Warning", Content = "That name already exists.", Time = 3})
            end
        else
            OrionLibrary:MakeNotification({Name = "Error", Content = "Please enter a name in the File Name Input.", Time = 3})
        end
    end
})

SaveTab:AddButton({
    Name = "Save File",
    Callback = function()
        if not SelectedFileName or SelectedFileName == "" then 
            OrionLibrary:MakeNotification({Name = "Error", Content = "Please select a file to save from Select File.", Time = 3})
            return 
        end

        if writefile then
            local configData = {}
            local flagsToSave = {
                "WalkspeedOverride", "SpeedMultiplier", "JumpPowerOverride", "JumpMultiplier", 
                "InfiniteJump", "VflyToggle", "FlySpeed", "TPSToggle", 
                "AntiExplosionEnabled", "AntiGrabEnabled", "AntiSitEnabled", "BlobmanKickLoop"
            }
            
            for _, flag in ipairs(flagsToSave) do
                local internalFlag = "Flag_" .. flag
                if OrionLibrary.Flags[internalFlag] ~= nil then
                    configData[flag] = OrionLibrary.Flags[internalFlag]
                end
            end

            local success, jsonStr = pcall(function() return HttpService:JSONEncode(configData) end)
            if success then
                writefile(CONFIG_DIR .. SelectedFileName .. ".json", jsonStr)
                OrionLibrary:MakeNotification({Name = "Config Saved", Content = "Configuration saved: " .. SelectedFileName, Time = 3})
            else
                OrionLibrary:MakeNotification({Name = "Error", Content = "Failed to convert data.", Time = 3})
            end
        else
            OrionLibrary:MakeNotification({Name = "Error", Content = "Executor does not support writing files.", Time = 3})
        end
    end
})

SaveTab:AddButton({
    Name = "Load File",
    Callback = function()
        if not SelectedFileName or SelectedFileName == "" then return end

        if readfile then
            local filePath = CONFIG_DIR .. SelectedFileName .. ".json"
            local fileExists = pcall(function() return readfile(filePath) end)
            
            if fileExists then
                local jsonStr = readfile(filePath)
                local success, configData = pcall(function() return HttpService:JSONDecode(jsonStr) end)
                
                if success and type(configData) == "table" then
                    IsLoadingConfig = true
                    
                    if configData["WalkspeedOverride"] ~= nil then _G.WalkspeedOverride = configData["WalkspeedOverride"] end
                    if configData["SpeedMultiplier"] ~= nil then _G.SpeedMultiplier = configData["SpeedMultiplier"] end
                    if configData["JumpPowerOverride"] ~= nil then _G.JumpPowerOverride = configData["JumpPowerOverride"] end
                    if configData["JumpMultiplier"] ~= nil then _G.JumpMultiplier = configData["JumpMultiplier"] end
                    if configData["InfiniteJump"] ~= nil then _G.InfiniteJump = configData["InfiniteJump"] end
                    if configData["TPSToggle"] ~= nil then _G.TPSToggle = configData["TPSToggle"] end
                    if configData["FlySpeed"] ~= nil then FlySpeed = configData["FlySpeed"] end
                    if configData["AntiExplosionEnabled"] ~= nil then AntiExplosionEnabled = configData["AntiExplosionEnabled"] end
                    if configData["AntiGrabEnabled"] ~= nil then AntiGrabEnabled = configData["AntiGrabEnabled"] end
                    if configData["AntiSitEnabled"] ~= nil then AntiSitEnabled = configData["AntiSitEnabled"] end

                    pcall(function() if _G.O_WalkspeedOverride and configData["WalkspeedOverride"] ~= nil then _G.O_WalkspeedOverride:Set(configData["WalkspeedOverride"]) end end)
                    pcall(function() if _G.O_SpeedMultiplier and configData["SpeedMultiplier"] ~= nil then _G.O_SpeedMultiplier:Set(configData["SpeedMultiplier"]) end end)
                    pcall(function() if _G.O_JumpPowerOverride and configData["JumpPowerOverride"] ~= nil then _G.O_JumpPowerOverride:Set(configData["JumpPowerOverride"]) end end)
                    pcall(function() if _G.O_JumpMultiplier and configData["JumpMultiplier"] ~= nil then _G.O_JumpMultiplier:Set(configData["JumpMultiplier"]) end end)
                    pcall(function() if _G.O_InfiniteJump and configData["InfiniteJump"] ~= nil then _G.O_InfiniteJump:Set(configData["InfiniteJump"]) end end)
                    pcall(function() if _G.O_VflyToggle and configData["VflyToggle"] ~= nil then _G.O_VflyToggle:Set(configData["VflyToggle"]) end end)
                    pcall(function() if _G.O_FlySpeed and configData["FlySpeed"] ~= nil then _G.O_FlySpeed:Set(configData["FlySpeed"]) end end)
                    pcall(function() if _G.O_TPSToggle and configData["TPSToggle"] ~= nil then _G.O_TPSToggle:Set(configData["TPSToggle"]) end end)
                    
                    pcall(function() if _G.O_AntiExplosionEnabled and configData["AntiExplosionEnabled"] ~= nil then _G.O_AntiExplosionEnabled:Set(configData["AntiExplosionEnabled"]) end end)
                    pcall(function() if _G.O_AntiGrabEnabled and configData["AntiGrabEnabled"] ~= nil then _G.O_AntiGrabEnabled:Set(configData["AntiGrabEnabled"]) end end)
                    pcall(function() if _G.O_AntiSitEnabled and configData["AntiSitEnabled"] ~= nil then _G.O_AntiSitEnabled:Set(configData["AntiSitEnabled"]) end end)
                    pcall(function() if _G.O_BlobmanKickLoop and configData["BlobmanKickLoop"] ~= nil then _G.O_BlobmanKickLoop:Set(configData["BlobmanKickLoop"]) end end)
                    
                    task.wait(0.05)
                    IsLoadingConfig = false
                    
                    OrionLibrary:MakeNotification({ Name = "Config Loaded", Content = "Configuration loaded: " .. SelectedFileName, Time = 3 })
                else
                    OrionLibrary:MakeNotification({Name = "Error", Content = "Failed to parse file.", Time = 3})
                end
            else
                OrionLibrary:MakeNotification({Name = "Error", Content = "File does not exist.", Time = 3})
            end
        else
            OrionLibrary:MakeNotification({Name = "Error", Content = "Executor does not support reading files.", Time = 3})
        end
    end
})

SaveTab:AddButton({
    Name = "Delete File",
    Callback = function()
        if not SelectedFileName or SelectedFileName == "" or SelectedFileName == "default" then
            OrionLibrary:MakeNotification({Name = "Error", Content = "Please select a custom file to delete ('default' cannot be deleted).", Time = 3})
            return
        end

        if delfile then
            local filePath = CONFIG_DIR .. SelectedFileName .. ".json"
            local success, err = pcall(function() delfile(filePath) end)
            
            if success then
                SavedFilesList = GetSavedFiles()
                SelectedFileName = "default"
                FileDropdown:Refresh(SavedFilesList, true)
                OrionLibrary:MakeNotification({Name = "Success", Content = "File deleted successfully.", Time = 3})
            else
                OrionLibrary:MakeNotification({Name = "Error", Content = "Failed to delete file.", Time = 3})
            end
        else
            OrionLibrary:MakeNotification({Name = "Error", Content = "Executor does not support deleting files.", Time = 3})
        end
    end
})

OrionLibrary:Init()

task.wait(0.1)
IsLoadingConfig = false
