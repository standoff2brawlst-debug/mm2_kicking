-- MM2 Kick + Fling
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local ANIM_ID = "rbxassetid://2515090838"
local enabled = false
local flingPower = 500
local flingUp = 300

-- Меню
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "KickFlingMenu"

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 200, 0, 120)
Frame.Position = UDim2.new(0, 20, 0, 20)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0

Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Kick + Fling"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

ToggleBtn.Parent = Frame
ToggleBtn.Size = UDim2.new(0, 160, 0, 40)
ToggleBtn.Position = UDim2.new(0, 20, 0, 50)
ToggleBtn.Text = "ВЫКЛ"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 16

-- Анимация
local anim = Instance.new("Animation")
anim.AnimationId = ANIM_ID
local track

local function playKick()
    if not track then
        track = humanoid:LoadAnimation(anim)
    end
    track:Play()
end

-- Флинг
local function fling(targetChar)
    local tHrp = targetChar:FindFirstChild("HumanoidRootPart")
    local tHum = targetChar:FindFirstChild("Humanoid")
    if not tHrp or not tHum then return end

    local dir = (tHrp.Position - hrp.Position).Unit
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = dir * flingPower + Vector3.new(0, flingUp, 0)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = tHrp

    tHum.PlatformStand = true

    game:GetService("Debris"):AddItem(bv, 0.3)
    task.delay(1, function()
        if tHum then tHum.PlatformStand = false end
    end)
end

-- Касание
local touchConn
local function connectTouch()
    if touchConn then touchConn:Disconnect() end
    touchConn = hrp.Touched:Connect(function(hit)
        if not enabled then return end
        local model = hit:FindFirstAncestorOfClass("Model")
        if not model then return end
        local targetPlr = Players:GetPlayerFromCharacter(model)
        if targetPlr and targetPlr ~= plr then
            playKick()
            fling(model)
        end
    end)
end

-- Кнопка
ToggleBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        ToggleBtn.Text = "ВКЛ"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 30)
        connectTouch()
    else
        ToggleBtn.Text = "ВЫКЛ"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
        if touchConn then touchConn:Disconnect() end
    end
end)

-- Обновление при респавне
plr.CharacterAdded:Connect(function(newChar)
    char = newChar
    hrp = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
    track = nil
    if enabled then connectTouch() end
end)
