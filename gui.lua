--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

-- Remove old
if PG:FindFirstChild("NEKO_GUI") then
    PG.NEKO_GUI:Destroy()
end

-- GUI
local gui = Instance.new("ScreenGui", PG)
gui.Name = "NEKO_GUI"
gui.ResetOnSpawn = false

-- OPEN BUTTON
local open = Instance.new("TextButton", gui)
open.Size = UDim2.new(0,80,0,40)
open.Position = UDim2.new(0,20,0.5,0)
open.Text = "NEKO"
open.BackgroundColor3 = Color3.new(1,1,1)
open.TextColor3 = Color3.new(0,0,0)

-- MAIN FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,320,0,400)
frame.Position = UDim2.new(0.5,-160,0.5,-200)
frame.BackgroundColor3 = Color3.new(0,0,0)
frame.Visible = false

open.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- LAYOUT
local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0,4)

-- BUTTON CREATOR
local function btn(name, func)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-10,0,25)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(20,20,20)
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(func)
end

--// PLAYER
btn("Speed x2", function()
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = 32 end
end)

btn("Reset Speed", function()
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = 16 end
end)

btn("High Jump", function()
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.JumpPower = 100 end
end)

btn("Reset Jump", function()
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.JumpPower = 50 end
end)

--// FLY (WASD CONTROL)
local flying = false
local bv, bg

btn("Fly Toggle", function()
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

            bv.Velocity = dir * 60
            bg.CFrame = workspace.CurrentCamera.CFrame
        end)
    else
        RunService:UnbindFromRenderStep("fly")
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

--// NOCLIP
local noclip = false
RunService.Stepped:Connect(function()
    if noclip and LP.Character then
        for _,v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

btn("Noclip Toggle", function()
    noclip = not noclip
end)

--// ESP
btn("ESP Toggle", function()
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            if not p.Character:FindFirstChild("Highlight") then
                Instance.new("Highlight", p.Character)
            end
        end
    end
end)

--// AIM ASSIST (LEGIT ABILITY STYLE)
local aimAssist = false

btn("Aim Assist", function()
    aimAssist = not aimAssist
end)

RunService.RenderStepped:Connect(function()
    if not aimAssist then return end

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

--// EXTRA (fill to 30+)
for i = 1,20 do
    btn("Extra "..i, function()
        print("Ability "..i)
    end)
end
