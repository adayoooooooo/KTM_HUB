local RayfieldLibrary = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()
local Players = game:GetService("Players")
local player = Players.LocalPlayer

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

local SelectedPlayerName = ""

-- --- タブ作成（アイコンIDを変更しました） ---
local PlayerTab = Window:CreateTab("Player", 16630859858)
local TeleportTab = Window:CreateTab("Teleport", 7733992829) 

-- --- Player タブの要素 ---
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

-- --- Teleport タブの要素 ---
local function GetPlayerList()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            table.insert(list, p.Name)
        end
    end
    return list
end

-- プレイヤー選択ドロップダウン
local PlayerDropdown = TeleportTab:CreateDropdown({
    Name = "Select Player",
    Options = GetPlayerList(),
    CurrentOption = {""},
    MultipleOptions = false,
    Flag = "PlayerSelectDropdown",
    Callback = function(Option)
        SelectedPlayerName = Option[1]
    end,
})

-- ドロップダウン自動更新
local function RefreshDropdown()
    if PlayerDropdown then
        PlayerDropdown:Set(GetPlayerList())
    end
end
Players.PlayerAdded:Connect(RefreshDropdown)
Players.PlayerRemoving:Connect(RefreshDropdown)

-- テレポートボタン（背後にテレポート）
TeleportTab:CreateButton({
    Name = "Teleport Behind Player",
    Callback = function()
        if SelectedPlayerName ~= "" then
            local targetPlayer = Players:FindFirstChild(SelectedPlayerName)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local targetHRP = targetPlayer.Character.HumanoidRootPart
                    player.Character.HumanoidRootPart.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
                end
            end
        end
    end,
})
