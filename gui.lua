local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "BW_GUI"

-- Toggle Button
local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0, 80, 0, 30)
Toggle.Position = UDim2.new(0, 10, 0, 200)
Toggle.Text = "OPEN"
Toggle.BackgroundColor3 = Color3.fromRGB(0,0,0)
Toggle.TextColor3 = Color3.fromRGB(255,255,255)

-- Main Frame
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 250)
Frame.Position = UDim2.new(0, 10, 0, 240)
Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
Frame.Visible = false

-- Title
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,30)
Title.Text = "BLACK HUB"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1

-- Toggle GUI
Toggle.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

-- Fly Button
local FlyBtn = Instance.new("TextButton", Frame)
FlyBtn.Size = UDim2.new(1, -10, 0, 30)
FlyBtn.Position = UDim2.new(0,5,0,40)
FlyBtn.Text = "Fly"
FlyBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
FlyBtn.TextColor3 = Color3.fromRGB(255,255,255)

local flying = false
FlyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    local char = LocalPlayer.Character
    if flying and char then
        local bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
        bv.Velocity = Vector3.new(0,50,0)
        bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    else
        if char and char:FindFirstChild("HumanoidRootPart") then
            for _,v in pairs(char.HumanoidRootPart:GetChildren()) do
                if v:IsA("BodyVelocity") then v:Destroy() end
            end
        end
    end
end)

-- Speed Button
local SpeedBtn = Instance.new("TextButton", Frame)
SpeedBtn.Size = UDim2.new(1, -10, 0, 30)
SpeedBtn.Position = UDim2.new(0,5,0,80)
SpeedBtn.Text = "Speed x2"
SpeedBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
SpeedBtn.TextColor3 = Color3.fromRGB(255,255,255)

SpeedBtn.MouseButton1Click:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = 32
    end
end)

-- ESP Button
local ESPBtn = Instance.new("TextButton", Frame)
ESPBtn.Size = UDim2.new(1, -10, 0, 30)
ESPBtn.Position = UDim2.new(0,5,0,120)
ESPBtn.Text = "ESP"
ESPBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
ESPBtn.TextColor3 = Color3.fromRGB(255,255,255)

ESPBtn.MouseButton1Click:Connect(function()
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if not p.Character:FindFirstChild("Highlight") then
                local h = Instance.new("Highlight", p.Character)
                h.FillColor = Color3.fromRGB(255,255,255)
            end
        end
    end
end)
