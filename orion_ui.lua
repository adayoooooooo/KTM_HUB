local TextChatService = game:GetService("TextChatService")
local textChannels = TextChatService:FindFirstChild("TextChannels")
local generalChannel = textChannels and textChannels:FindFirstChild("RBXGeneral")

if generalChannel then
    generalChannel:SendAsync("(＃°Д°)HUB(公開鯖テスト中)起動中だよ(•ω•)")
end


local OrionLibrary = loadstring(game:HttpGet(('https://raw.githubusercontent.com/BlizTBr/scripts/refs/heads/main/Orion%20X')))()
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Window = OrionLibrary:MakeWindow({
    Name = "(＃°Д°)HUB (FTAP)",
    HidePremium = false, 
    SaveConfig = true,
    ConfigFolder = "emojiHUB",
    KeyToOpenWindow = "RightShift",
    FreeMouse = true
})

local SelectedPlayerName = ""      
local SelectedBlobmanTarget = ""   

-- --- タブ作成 ---
local PlayerTab = Window:MakeTab({ Name = "Player", Icon = "rbxassetid://13585613884", PremiumOnly = false })
local TeleportTab = Window:MakeTab({ Name = "Teleport", Icon = "rbxassetid://7733992829", PremiumOnly = false }) 
local DefenseTab = Window:MakeTab({ Name = "Defense", Icon = "rbxassetid://7734056608", PremiumOnly = false })

-- --- Player タブ ---
PlayerTab:AddToggle({ Name = "WalkspeedOverride", Default = false, Callback = function(Value) _G.WalkspeedOverride = Value end })
PlayerTab:AddSlider({ Name = "Speed Multiplier", Min = 1, Max = 10, Default = 1, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "Speed", Callback = function(Value) _G.SpeedMultiplier = Value end })
PlayerTab:AddToggle({ Name = "JumpPowerOverride", Default = false, Callback = function(Value) _G.JumpPowerOverride = Value end })
PlayerTab:AddSlider({ Name = "Jump Multiplier", Min = 1, Max = 10, Default = 1, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "Jump", Callback = function(Value) _G.JumpMultiplier = Value end })
PlayerTab:AddToggle({ Name = "Infinite Jump", Default = false, Callback = function(Value) _G.InfiniteJump = Value end })
PlayerTab:AddLabel("--- Camera Settings (TPS) ---")
PlayerTab:AddToggle({ Name = "Enable TPS (Max 500 Studs)", Default = false, Callback = function(Value) _G.TPSToggle = Value if not Value and player then player.CameraMode = Enum.CameraMode.Classic player.CameraMaxZoomDistance = 12 player.CameraMinZoomDistance = 0.5 end end })

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
    Name = "Select Player", Default = "None", Options = currentDisplayList,
    Callback = function(Value) SelectedPlayerName = currentNameMap[Value] or "" end
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

-- --- Defense タブ ---
local RS = game:GetService("ReplicatedStorage")
local R = game:GetService("RunService")
local CE = RS:WaitForChild("CharacterEvents", 5) 
local StruggleEvent = CE and CE:WaitForChild("Struggle", 5)
local BeingHeld = player:WaitForChild("IsHeld", 5)

local AntiExplosionEnabled = true
local AntiGrabEnabled = true
local AntiSitEnabled = true

workspace.DescendantAdded:Connect(function(v) if AntiExplosionEnabled and v:IsA("Explosion") then v.BlastPressure = 0 end end)
if BeingHeld and StruggleEvent then
    BeingHeld.Changed:Connect(function(C)
        if AntiGrabEnabled and C == true then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local Event; Event = R.RenderStepped:Connect(function()
                    if AntiGrabEnabled and BeingHeld.Value == true then
                        char["HumanoidRootPart"].AssemblyLinearVelocity = Vector3.new()
                        StruggleEvent:FireServer(player)
                    else Event:Disconnect() end
                end)
            end
        end
    end)
end

local function reconnect(Character)
    if not Character then return end
    local Humanoid = Character:WaitForChild("Humanoid", 10)
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart", 10)
    if HumanoidRootPart then local firePart = HumanoidRootPart:WaitForChild("FirePlayerPart", 3) if firePart then firePart:Destroy() end end
    if Humanoid then
        Humanoid.Changed:Connect(function(C)
            if AntiSitEnabled and C == "Sit" and Humanoid.Sit == true then
                if Humanoid.SeatPart ~= nil and tostring(Humanoid.SeatPart.Parent) == "CreatureBlobman" then
                elseif Humanoid.SeatPart == nil then Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true) Humanoid.Sit = false end
            end
        end)
    end
end
if player.Character then task.spawn(reconnect, player.Character) end
player.CharacterAdded:Connect(function(char) task.spawn(reconnect, char) end)

DefenseTab:AddToggle({ Name = "Anti Explosion (No Knockback)", Default = true, Callback = function(Value) AntiExplosionEnabled = Value end })
DefenseTab:AddToggle({ Name = "Anti Grab (Auto Struggle)", Default = true, Callback = function(Value) AntiGrabEnabled = Value end })
DefenseTab:AddToggle({ Name = "Anti Sit (Auto Unsit)", Default = true, Callback = function(Value) AntiSitEnabled = Value end })

OrionLibrary:Init()
