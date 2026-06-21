local OrionLibrary = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/refs/heads/main/source')))()
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Window = OrionLibrary:MakeWindow({
    Name = "KTM_HUB (FTAP)",
    HidePremium = false, 
    SaveConfig = true,
    ConfigFolder = "KTM_Hub"
})

local SelectedPlayerName = ""

-- --- タブ作成 ---
-- OrionUIの仕様バグ対策: 数字IDではなくLucideアイコン名("user", "locate")を指定して確実に表示させます。
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://16630859858",
    PremiumOnly = false
})

local TeleportTab = Window:MakeTab({
    Name = "Teleport",
    Icon = "rbxassetid://7733992829",
    PremiumOnly = false
}) 

local keybindsTab = flingThingsWindow:MakeTab({
    Name = "Keybinds",
    Icon = "rbxassetid://11710306232",
    PremiumOnly = false
})

-- --- Player タブの要素 ---
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

-- --- Teleport タブの要素 ---
-- 「表示名 (@ユーザー名)」のリストと、そこからユーザー名を逆引きするテーブルを作成
local function GetPlayerDropdownData()
    local displayList = {}
    local nameMap = {} -- 表示名からユーザー名を検索するためのマップ
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            -- 例: "ひろし (@Hiroshi_Roblox)"
            local formattedName = p.DisplayName .. " (@" .. p.Name .. ")"
            table.insert(displayList, formattedName)
            nameMap[formattedName] = p.Name
        end
    end
    return displayList, nameMap
end

local currentDisplayList, currentNameMap = GetPlayerDropdownData()

-- プレイヤー選択ドロップダウン
local PlayerDropdown = TeleportTab:AddDropdown({
    Name = "Select Player",
    Default = "None",
    Options = currentDisplayList,
    Callback = function(Value)
        -- 選択された表記から、内部処理用の正確なユーザー名を取得
        if currentNameMap[Value] then
            SelectedPlayerName = currentNameMap[Value]
        else
            SelectedPlayerName = ""
        end
    end
})

-- ドロップダウン自動更新関数
local function RefreshDropdown()
    if PlayerDropdown then
        currentDisplayList, currentNameMap = GetPlayerDropdownData()
        PlayerDropdown:Refresh(currentDisplayList, true)
    end
end

Players.PlayerAdded:Connect(RefreshDropdown)
Players.PlayerRemoving:Connect(RefreshDropdown)

-- テレポートボタン（背後にテレポート）
TeleportTab:AddButton({
    Name = "Teleport Behind Player",
    Callback = function()
        if SelectedPlayerName ~= "" and SelectedPlayerName ~= "None" then
            local targetPlayer = Players:FindFirstChild(SelectedPlayerName)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local targetHRP = targetPlayer.Character.HumanoidRootPart
                    player.Character.HumanoidRootPart.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
                end
            end
        end
    end
})

OrionLibrary:Init()
