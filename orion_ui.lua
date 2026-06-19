local OrionLibrary = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/refs/heads/main/source')))()
local player = game.Players.LocalPlayer

local Window = OrionLibrary:MakeWindow({
    Name = "KTM_HUB (FTAP)",
    HidePremium = false, 
    SaveConfig = true,
    ConfigFolder = "KTM_Hub"
})

local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://13585614827",
    PremiumOnly = false
})

PlayerTab:AddToggle({
    Name = "WalkspeedOverride",
    Default = false,
    Callback = function(Value) _G.WalkspeedOverride = Value end
})

PlayerTab:AddSlider({
    Name = "Speed Multiplier",
    Min = 1, Max = 10, Default = 1,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1, ValueName = "Speed",
    Callback = function(Value) _G.SpeedMultiplier = Value end    
})

PlayerTab:AddToggle({
    Name = "JumpPowerOverride",
    Default = false,
    Callback = function(Value) _G.JumpPowerOverride = Value end
})

PlayerTab:AddSlider({
    Name = "Jump Multiplier",
    Min = 1, Max = 10, Default = 1,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1, ValueName = "Jump",
    Callback = function(Value) _G.JumpMultiplier = Value end    
})

PlayerTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value) _G.InfiniteJump = Value end
})

PlayerTab:AddLabel("--- Camera Settings (TPS) ---")

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

OrionLibrary:Init()
