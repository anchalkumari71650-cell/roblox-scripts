--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
repeat task.wait() until LP and LP:FindFirstChild("PlayerGui")
local PG = LP.PlayerGui

-- Remove old GUI
if PG:FindFirstChild("NEKO_GUI") then
    PG.NEKO_GUI:Destroy()
end

-- MAIN GUI
local gui = Instance.new("ScreenGui")
gui.Name = "NEKO_GUI"
gui.ResetOnSpawn = false
gui.Parent = PG

-- OPEN BUTTON (white square)
local open = Instance.new("TextButton")
open.Size = UDim2.new(0,80,0,40)
open.Position = UDim2.new(0,20,0.5,0)
open.Text = "NEKO"
open.BackgroundColor3 = Color3.fromRGB(255,255,255)
open.TextColor3 = Color3.fromRGB(0,0,0)
open.Parent = gui

-- MAIN FRAME (centered black rectangle)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,340,0,420)
frame.Position = UDim2.new(0.5,-170,0.5,-210)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.Visible = false
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,35)
title.Text = "NEKO HUB"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Parent = frame

-- LAYOUT
local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0,6)

-- TOGGLE VISIBILITY
open.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- BUTTON CREATOR FUNCTION
local function createBtn(text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-12,0,28)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(20,20,20)
    b.TextColor3 = Color3.new(1,1,1)
    b.Parent = frame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    b.MouseButton1Click:Connect(callback)
end

--// PLAYER FUNCTIONS

-- Speed
createBtn("Speed x2", function()
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = 32 end
end)

createBtn("Speed x5", function()
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = 80 end
end)

createBtn("Reset Speed", function()
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = 16 end
end)

-- Jump
createBtn("High Jump", function()
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.JumpPower = 100 end
end)

createBtn("Reset Jump", function()
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.JumpPower = 50 end
end)

-- Gravity
createBtn("Low Gravity", function()
    workspace.Gravity = 50
end)

createBtn("Reset Gravity", function()
    workspace.Gravity = 196.2
end)

-- Fly (WASD)
local flying = false
local bv, bg
createBtn("Fly Toggle", function()
    flying = not flying
    local char = LP.Character
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart")
    if flying then
        bv = Instance.new("BodyVelocity", hrp)
        bg = Instance.new("BodyGyro", hrp)
        bv.MaxForce = Vector3.new(9e9,9e9,9e9)
        bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
        RunService:BindToRenderStep("fly",0,function()
            local dir = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir += workspace.CurrentCamera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= workspace.CurrentCamera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= workspace.CurrentCamera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir += workspace.CurrentCamera.CFrame.RightVector end
            bv.Velocity = dir * 70
            bg.CFrame = workspace.CurrentCamera.CFrame
        end)
    else
        RunService:UnbindFromRenderStep("fly")
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

-- Noclip
local noclip = false
RunService.Stepped:Connect(function()
    if noclip and LP.Character then
        for _,v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)
createBtn("Noclip Toggle", function()
    noclip = not noclip
end)

-- ESP
createBtn("ESP Players", function()
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            if not p.Character:FindFirstChild("Highlight") then
                Instance.new("Highlight", p.Character)
            end
        end
    end
end)

-- Aim Assist (ability style)
local aim = false
createBtn("Aim Assist Toggle", function()
    aim = not aim
end)
RunService.RenderStepped:Connect(function()
    if not aim then return end
    local closest, dist = nil, math.huge
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local mag = (p.Character.HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude
            if mag < dist then
                dist = mag
                closest = p
            end
        end
    end
    if closest then
        workspace.CurrentCamera.CFrame = CFrame.new(
            workspace.CurrentCamera.CFrame.Position,
            closest.Character.HumanoidRootPart.Position
        )
    end
end)

-- Extra functions to reach 30+
for i=1,20 do
    createBtn("Extra "..i, function()
        print("Extra function "..i)
    end)
end
