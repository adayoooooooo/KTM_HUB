local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/refs/heads/main/source')))()

-- ウィンドウ作成
local Window = OrionLib:MakeWindow({
    Name = "KTM_HUB (FTAP)",
    HidePremium = false, 
    SaveConfig = true,
    ConfigFolder = "KTM_Hub"
})

-- 🛑 共通変数を最上部で宣言
local player = game.Players.LocalPlayer

_G.WalkspeedOverride = false
_G.SpeedMultiplier = 1

_G.JumpPowerOverride = false
_G.JumpMultiplier = 1

_G.InfiniteJump = false

-- 🎥 TPSトグル用のグローバル変数
_G.TPSToggle = false

-- 👥 Playerタブのみ作成
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://16630859927",
    PremiumOnly = false
})

-- ==========================================
-- Player タブ内の機能
-- ==========================================

-- 1. Walkspeed 機能
PlayerTab:AddToggle({
    Name = "WalkspeedOverride",
    Default = false,
    Callback = function(Value)
        _G.WalkspeedOverride = Value
    end
})

PlayerTab:AddSlider({
    Name = "Speed Multiplier",
    Min = 1,
    Max = 10,
    Default = 1,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        _G.SpeedMultiplier = Value
    end    
})

-- 2. JumpPower 機能
PlayerTab:AddToggle({
    Name = "JumpPowerOverride",
    Default = false,
    Callback = function(Value)
        _G.JumpPowerOverride = Value
    end
})

PlayerTab:AddSlider({
    Name = "Jump Multiplier",
    Min = 1,
    Max = 10,
    Default = 1,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Jump",
    Callback = function(Value)
        _G.JumpMultiplier = Value
    end    
})

-- 3. Infinite Jump 機能
PlayerTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        _G.InfiniteJump = Value
    end
})

-- 4. TPS (カメラズーム固定解除) 機能
PlayerTab:AddLabel("--- Camera Settings (TPS) ---")

PlayerTab:AddToggle({
    Name = "Enable TPS (Max 500 Studs)",
    Default = false,
    Callback = function(Value)
        _G.TPSToggle = Value
        
        -- トグルがオフになった瞬間、カメラの設定をデフォルト値へ安全に戻す
        if not Value and player then
            player.CameraMode = Enum.CameraMode.Classic
            player.CameraMaxZoomDistance = 12
            player.CameraMinZoomDistance = 0.5
        end
    end
})

-- ==========================================
-- ループ・イベント処理
-- ==========================================

-- 無限ジャンプ処理
local UserInputService = game:GetService("UserInputService")
UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- 速度・ジャンプ力・カメラの常時適用処理（Heartbeat）
game:GetService("RunService").Heartbeat:Connect(function()
    -- 🎥 【TPSトグルがオンの時の処理】
    if player then
        if _G.TPSToggle then
            player.CameraMode = Enum.CameraMode.Classic -- 🔓 一人称固定（LockFirstPerson）を強制解除
            player.CameraMaxZoomDistance = 500          -- 500スタッドまでズームアウト可能に
            player.CameraMinZoomDistance = 0.5          -- ズームインで一人称（顔のドアップ）になれるように限界値を下げる
        end
    end

    if player and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart then
            -- 1. スピード上書き
            if _G.WalkspeedOverride and humanoid.MoveDirection.Magnitude > 0 then
                local currentVelocity = rootPart.AssemblyLinearVelocity
                local targetMove = humanoid.MoveDirection * (16 * _G.SpeedMultiplier)
                rootPart.AssemblyLinearVelocity = Vector3.new(targetMove.X, currentVelocity.Y, targetMove.Z)
            end
            
            -- 2. ジャンプ力上書き
            if _G.JumpPowerOverride then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = 23 * _G.JumpMultiplier
            else
                humanoid.UseJumpPower = false
            end
        end
    end
end)

OrionLib:Init()
