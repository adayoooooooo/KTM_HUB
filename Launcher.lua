-- [[ 🛑 旧オブジェクトのクリーンアップ ]]
if game:GetService("CoreGui"):FindFirstChild("UI_Launcher") then
    game:GetService("CoreGui").UI_Launcher:Destroy()
end

-- [[ 🔗 GitHubのRaw URLを設定する場所 ]]
local ORION_SCRIPT_URL = "★ここにOrionのRawURL★"
local RAYFIELD_SCRIPT_URL = "★ここにRayfieldのRawURL★"

-- [[ 🛑 共通グローバル変数宣言 ]]
local player = game.Players.LocalPlayer
_G.WalkspeedOverride = false
_G.SpeedMultiplier = 1
_G.JumpPowerOverride = false
_G.JumpMultiplier = 1
_G.InfiniteJump = false
_G.TPSToggle = false

-- ==========================================
-- 🌐 ループ・イベント処理（バックエンド）
-- ==========================================
local UserInputService = game:GetService("UserInputService")
UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJump and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if player then
        if _G.TPSToggle then
            player.CameraMode = Enum.CameraMode.Classic
            player.CameraMaxZoomDistance = 500
            player.CameraMinZoomDistance = 0.5
        else
            player.CameraMode = Enum.CameraMode.LockFirstPerson
            player.CameraMaxZoomDistance = 0.5
            player.CameraMinZoomDistance = 0.5
        end
    end

    if player and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart then
            if _G.WalkspeedOverride and humanoid.MoveDirection.Magnitude > 0 then
                local currentVelocity = rootPart.AssemblyLinearVelocity
                local targetMove = humanoid.MoveDirection * (16 * _G.SpeedMultiplier)
                rootPart.AssemblyLinearVelocity = Vector3.new(targetMove.X, currentVelocity.Y, targetMove.Z)
            end
            
            if _G.JumpPowerOverride then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = 23 * _G.JumpMultiplier
            else
                humanoid.UseJumpPower = false
            end
        end
    end
end)

-- ==========================================
-- 🖥️ 選択用独自UI（ランチャー画面）
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local OrionBtn = Instance.new("TextButton")
local RayfieldBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UICorner2 = Instance.new("UICorner")
local UICorner3 = Instance.new("UICorner")

ScreenGui.Name = "UI_Launcher"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
MainFrame.Size = UDim2.new(0, 300, 0, 150)

UICorner.Parent = MainFrame

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1.000
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "KTM HUB - Select UI Library"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16.000

-- Orion UI ボタン
OrionBtn.Name = "OrionBtn"
OrionBtn.Parent = MainFrame
OrionBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
OrionBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
OrionBtn.Size = UDim2.new(0.42, 0, 0, 45)
OrionBtn.Font = Enum.Font.Gotham
OrionBtn.Text = "Orion UI"
OrionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OrionBtn.TextSize = 14.000
UICorner2.Parent = OrionBtn

-- Rayfield UI ボタン
RayfieldBtn.Name = "RayfieldBtn"
RayfieldBtn.Parent = MainFrame
RayfieldBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
RayfieldBtn.Position = UDim2.new(0.53, 0, 0.45, 0)
RayfieldBtn.Size = UDim2.new(0.42, 0, 0, 45)
RayfieldBtn.Font = Enum.Font.Gotham
RayfieldBtn.Text = "Rayfield UI"
RayfieldBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RayfieldBtn.TextSize = 14.000
UICorner3.Parent = RayfieldBtn

-- ==========================================
-- 🚀 ボタンクリック時の読み込み処理
-- ==========================================

OrionBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    loadstring(game:HttpGet(ORION_SCRIPT_URL))()
end)

RayfieldBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    loadstring(game:HttpGet(RAYFIELD_SCRIPT_URL))()
end)
