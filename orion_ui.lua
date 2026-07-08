local OrionLibrary = loadstring(game:HttpGet(('https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/source.txt')))()
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

-- --- Player タブ ---
PlayerTab:AddToggle({ Name = "WalkspeedOverride", Default = false, Callback = function(Value) _G.WalkspeedOverride = Value end })
PlayerTab:AddSlider({ Name = "Speed Multiplier", Min = 1, Max = 10, Default = 1, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "Speed", Callback = function(Value) _G.SpeedMultiplier = Value end })
PlayerTab:AddToggle({ Name = "JumpPowerOverride", Default = false, Callback = function(Value) _G.JumpPowerOverride = Value end })
PlayerTab:AddSlider({ Name = "Jump Multiplier", Min = 1, Max = 10, Default = 1, Color = Color3.fromRGB(255,255,255), Increment = 1, ValueName = "Jump", Callback = function(Value) _G.JumpMultiplier = Value end })
PlayerTab:AddToggle({ Name = "Infinite Jump", Default = false, Callback = function(Value) _G.InfiniteJump = Value end })
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

-- 初期データの取得
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

-- 【追加】プレイヤーリストを自動更新する関数
local function RefreshDropdown()
    currentDisplayList, currentNameMap = GetPlayerDropdownData()
    -- 使用しているUIライブラリのRefreshメソッドを呼び出す（一般的には Refresh(options, clearCurrent)）
    PlayerDropdown:Refresh(currentDisplayList, true)
end

-- 【追加】プレイヤーの参加・退出イベントを監視
Players.PlayerAdded:Connect(RefreshDropdown)
Players.PlayerRemoving:Connect(RefreshDropdown)


-- --- TPSトグル（既存コード） ---
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

-- --- テレポートボタン（既存コード） ---
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
-- --- Defense タブの強化版処理 ---
local RS = game:GetService("ReplicatedStorage")
local R = game:GetService("RunService")
local CE = RS:WaitForChild("CharacterEvents", 5) 
local StruggleEvent = CE and CE:WaitForChild("Struggle", 5)
local BeingHeld = player:WaitForChild("IsHeld", 5)

local AntiExplosionEnabled = true
local AntiGrabEnabled = true
local AntiSitEnabled = true

-- 爆発対策
workspace.DescendantAdded:Connect(function(v) 
    if AntiExplosionEnabled and v:IsA("Explosion") then 
        v.BlastPressure = 0 
    end 
end)

-- 【強化ポイント】RenderStepped よりも物理演算に近い頻度で強力にループ
R.Heartbeat:Connect(function()
    if not AntiGrabEnabled then return end
    
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    
    -- 1. 掴まれているフラグがON、またはキャラクター内に掴み用のWeld（結合パーツ）が存在するかチェック
    local physicalGrab = char:FindFirstChildOfClass("Weld") or char:FindFirstChildOfClass("WeldConstraint")
    
    if (BeingHeld and BeingHeld.Value == true) or physicalGrab then
        -- 速度をゼロにして引っ張られるのを防ぐ
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
        
        -- 2. サーバーへもがく（Struggle）イベントを高速連打
        if StruggleEvent then
            StruggleEvent:FireServer(player)
        end
        
        -- 3. 【強制解除】ローカル側で掴みパーツや結合を即座に破壊（クライアント側で位置を固定化させない）
        if physicalGrab then
            physicalGrab:Destroy()
        end
        
        -- 4. 人型ステートを強制リセットして拘束アニメーションを解く
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        end
    end
end)

-- キャラクターが生成された際の処理（Anti-Sitなど）
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

-- UIへの登録
DefenseTab:AddToggle({ Name = "Anti Explosion (No Knockback)", Default = true, Callback = function(Value) AntiExplosionEnabled = Value end })
DefenseTab:AddToggle({ Name = "Anti Grab (Auto Struggle)", Default = true, Callback = function(Value) AntiGrabEnabled = Value end })
DefenseTab:AddToggle({ Name = "Anti Sit (Auto Unsit)", Default = true, Callback = function(Value) AntiSitEnabled = Value end })

local SelectedBlobmanTarget = "" -- キック対象のプレイヤー名
local BlobmanKickLoop = false    -- ループフラグ

-- おもちゃの出現・削除用リモート（添付ファイル内の定義を流用）
local SpawnToyRF = game:GetService("ReplicatedStorage"):WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction")
local DeleteToyRE = game:GetService("ReplicatedStorage"):WaitForChild("MenuToys"):WaitForChild("DestroyToy")

-- --- ドロップダウンデータ生成（Blobman用） ---
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

-- 対象プレイヤー選択ドロップダウン
local BlobmanTargetDropdown = BlobmanTab:AddDropdown({
    Name = "Select Target Player", 
    Default = "None", 
    Options = bDisplayList,
    Callback = function(Value) 
        SelectedBlobmanTarget = bNameMap[Value] or "" 
    end
})

-- 【リフレッシュボタン】プレイヤーリストを手動で更新する
BlobmanTab:AddButton({
    Name = "Refresh Player List",
    Callback = function()
        local newList, newMap = GetBlobmanDropdownData()
        bNameMap = newMap
        BlobmanTargetDropdown:Refresh(newList, true)
    end
})

-- スパムキックのトグルスイッチ
BlobmanTab:AddToggle({
    Name = "Blobman Spam Kick",
    Default = false,
    Callback = function(Value)
        BlobmanKickLoop = Value
        
        if Value then
            -- 選択されたプレイヤーが有効かチェック
            if SelectedBlobmanTarget == "" then 
                OrionLibrary:MakeNotification({Name = "Error", Content = "対象プレイヤーを選択してください", Time = 3})
                return 
            end
            
            local targetPlayer = Players:FindFirstChild(SelectedBlobmanTarget)
            if not targetPlayer or not targetPlayer.Character then 
                OrionLibrary:MakeNotification({Name = "Error", Content = "対象プレイヤーが見つかりません", Time = 3})
                return 
            end

            -- 高速ループ処理を開始
            task.spawn(function()
                while BlobmanKickLoop do
                    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local targetHRP = targetPlayer.Character.HumanoidRootPart
                        
                        -- 対象プレイヤーの座標の少し上にBlobmanを出現させる引数
                        -- 添付ファイルの構造: {"おもちゃ名", CFrame位置, Vector3角度}
                        local spawnArgs = {
                            "CreatureBlobman", 
                            targetHRP.CFrame * CFrame.new(0, 3, 0), 
                            Vector3.new(0, 0, 0)
                        }
                        
                        -- クライアント側からサーバーへ出現命令（別スレッドでラグを軽減）
                        task.spawn(function()
                            local spawnedToy = SpawnToyRF:InvokeServer(unpack(spawnArgs))
                            
                            -- 出現に成功した場合、あるいは自分のおもちゃフォルダに生成されたら即座に消去する
                            if spawnedToy then
                                DeleteToyRE:FireServer(spawnedToy)
                            end
                        end)
                        
                        -- 自分の生成したおもちゃフォルダ内を走査して、残骸が残っていれば強制全削除（スパム効率アップ）
                        local myToysFolder = workspace:FindFirstChild(player.Name .. "SpawnedInToys")
                        if myToysFolder then
                            for _, toy in ipairs(myToysFolder:GetChildren()) do
                                if toy.Name == "CreatureBlobman" then
                                    DeleteToyRE:FireServer(toy)
                                end
                            end
                        end
                    else
                        -- 対象がサーバーにいない、または死んでいる場合はループを一時待機
                        break
                    end
                    
                    -- 連打のウェイト（極限まで短く設定、環境に応じて調整してください）
                    task.wait(0.01) 
                end
            end)
        end
    end
})

OrionLibrary:Init()
