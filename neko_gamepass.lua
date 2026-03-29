--// NEKO GAMEPASS SYSTEM

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local LP = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "NEKO_PASS"

local open = Instance.new("TextButton", gui)
open.Size = UDim2.new(0,80,0,40)
open.Position = UDim2.new(0,20,0.5,0)
open.Text = "NEKO"
open.BackgroundColor3 = Color3.new(1,1,1)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,320,0,400)
frame.Position = UDim2.new(0.5,-160,0.5,-200)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.Visible = false

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0,6)

open.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

local function btn(name, func)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-10,0,30)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(20,20,20)
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(func)
end

-- SPEED
local speedOn = false
btn("Speed", function()
    speedOn = not speedOn
end)

RunService.Heartbeat:Connect(function()
    if speedOn and LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 40 end
    end
end)

-- ESP
local espOn = false
local esp = {}

local function addESP(p)
    if p == LP then return end
    if p.Character then
        local h = Instance.new("Highlight", p.Character)
        h.FillColor = Color3.new(1,0,0)
        esp[p] = h
    end
end

btn("ESP", function()
    espOn = not espOn
    if espOn then
        for _,p in pairs(Players:GetPlayers()) do addESP(p) end
    else
        for _,v in pairs(esp) do if v then v:Destroy() end end
        esp = {}
    end
end)

-- AIM ASSIST
local aim = false
btn("Aim Assist", function()
    aim = not aim
end)

RunService.RenderStepped:Connect(function()
    if not aim then return end

    local closest, dist = nil, math.huge
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local mag = (p.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude
            if mag < dist then
                dist = mag
                closest = p
            end
        end
    end

    if closest then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Character.HumanoidRootPart.Position)
    end
end)

-- AUTO M1
local autoM1 = false
btn("Auto M1", function()
    autoM1 = not autoM1
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if autoM1 and LP.Character then
            local tool = LP.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end
        end
    end
end)

-- FLY
local flying = false
btn("Fly", function()
    flying = not flying

    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if flying then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "FLY"
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)

        RunService:BindToRenderStep("FLY",0,function()
            local move = char:FindFirstChildOfClass("Humanoid").MoveDirection
            bv.Velocity = move * 70 + Vector3.new(0,2,0)
        end)
    else
        RunService:UnbindFromRenderStep("FLY")
        if hrp and hrp:FindFirstChild("FLY") then
            hrp.FLY:Destroy()
        end
    end
end)
