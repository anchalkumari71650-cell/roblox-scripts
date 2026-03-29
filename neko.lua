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

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "NEKO_GUI"
gui.ResetOnSpawn = false
gui.Parent = PG

-- OPEN BUTTON
local open = Instance.new("TextButton")
open.Size = UDim2.new(0,80,0,40)
open.Position = UDim2.new(0,20,0.5,0)
open.Text = "NEKO"
open.BackgroundColor3 = Color3.fromRGB(255,255,255)
open.TextColor3 = Color3.fromRGB(0,0,0)
open.Parent = gui

-- MAIN FRAME
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

-- TOGGLE
open.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- BUTTON CREATOR
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

--// SPEED
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

--// JUMP
createBtn("High Jump", function()
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then
        h.UseJumpPower = true
        h.JumpPower = 120
    end
end)

createBtn("Super Jump", function()
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then
        h.UseJumpPower = true
        h.JumpPower = 200
    end
end)

createBtn("Reset Jump", function()
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.JumpPower = 50 end
end)

--// STRONG LOW GRAVITY
local lowGrav = false
createBtn("Low Gravity Toggle", function()
    lowGrav = not lowGrav
end)

RunService.Heartbeat:Connect(function()
    if lowGrav and LP.Character then
        local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(
                hrp.Velocity.X,
                math.max(hrp.Velocity.Y, 30),
                hrp.Velocity.Z
            )
        end
    end
end)

--// FLY (MOBILE + PC)
local flying = false
local flySpeed = 90

createBtn("Fly Toggle", function()
    flying = not flying

    local char = LP.Character
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart")

    if flying then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "NEKO_FLY"
        bv.MaxForce = Vector3.new(9e9,9e9,9e9)
        bv.Parent = hrp

        RunService:BindToRenderStep("NEKO_FLY",0,function()
            if not flying or not bv.Parent then return end

            local cam = workspace.CurrentCamera
            local moveDir = LP.Character:FindFirstChildOfClass("Humanoid").MoveDirection

            local dir = Vector3.zero

            -- MOBILE joystick
            dir += moveDir

            -- PC keys
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end

            -- upward support
            dir += Vector3.new(0,0.2,0)

            bv.Velocity = dir * flySpeed
        end)

    else
        RunService:UnbindFromRenderStep("NEKO_FLY")
        if hrp:FindFirstChild("NEKO_FLY") then
            hrp.NEKO_FLY:Destroy()
        end
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

createBtn("Noclip Toggle", function()
    noclip = not noclip
end)

--// ESP
createBtn("ESP Players", function()
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            if not p.Character:FindFirstChild("Highlight") then
                Instance.new("Highlight", p.Character)
            end
        end
    end
end)

--// AIM ASSIST (ABILITY STYLE)
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

-- EXTRA CLEAN FUNCTIONS (no fake spam)
createBtn("Sit", function()
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.Sit = true end
end)

createBtn("Reset Character", function()
    LP.Character:BreakJoints()
end)
