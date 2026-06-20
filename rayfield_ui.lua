local RayfieldLibrary = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()
local player = game.Players.LocalPlayer

local Window = RayfieldLibrary:CreateWindow({
    Name = "KTM_HUB (FTAP)",
    LoadingTitle = "KTM_HUB Loading...",
    LoadingSubtitle = "by KTM",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "KTM_Hub_Rayfield",
        FileName = "Config"
    }
})

local PlayerTab = Window:CreateTab("Player", 13585613929)

PlayerTab:CreateToggle({
    Name = "WalkspeedOverride",
    CurrentValue = false,
    Flag = "WalkspeedToggle",
    Callback = function(Value) _G.WalkspeedOverride = Value end
})

PlayerTab:CreateSlider({
    Name = "Speed Multiplier",
    Info = "Walkspeed multiplier factor",
    Interact = "Drag",
    Pointer = "SpeedSlider",
    Suffix = "x",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(Value) _G.SpeedMultiplier = Value end
})

PlayerTab:CreateToggle({
    Name = "JumpPowerOverride",
    CurrentValue = false,
    Flag = "JumpToggle",
    Callback = function(Value) _G.JumpPowerOverride = Value end
})

PlayerTab:CreateSlider({
    Name = "Jump Multiplier",
    Info = "Jump power multiplier factor",
    Interact = "Drag",
    Pointer = "JumpSlider",
    Suffix = "x",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(Value) _G.JumpMultiplier = Value end
})

PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJumpToggle",
    Callback = function(Value) _G.InfiniteJump = Value end
})

PlayerTab:CreateSection("--- Camera Settings (TPS) ---")

PlayerTab:CreateToggle({
    Name = "Enable TPS (Max 500 Studs)", 
    CurrentValue = false, 
    Flag = "TPSToggleFlag",
    Callback = function(Value) 
        _G.TPSToggle = Value 
        if not Value and player then
            player.CameraMode = Enum.CameraMode.Classic
            player.CameraMaxZoomDistance = 12
            player.CameraMinZoomDistance = 0.5
        end
    end
})
