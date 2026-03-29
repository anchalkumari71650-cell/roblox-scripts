--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local LP = Players.LocalPlayer
repeat task.wait() until LP and LP:FindFirstChild("PlayerGui")
local PG = LP.PlayerGui

-- REMOVE OLD
if PG:FindFirstChild("NEKO_GUI") then
    PG.NEKO_GUI:Destroy()
end

-- GUI
local gui = Instance.new("ScreenGui", PG)
gui.Name = "NEKO_GUI"
gui.ResetOnSpawn = false

-- BUTTON
local open = Instance.new("TextButton", gui)
open.Size = UDim2.new(0,80,0,40)
open.Position = UDim2.new(0,20,0.5,0)
open.Text = "NEKO"
open.BackgroundColor3 = Color3.new(1,1,1)
open.TextColor3 = Color3.new(0,0,0)

-- FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,340,0,420)
frame.Position = UDim2.new(0.5,-170,0.5,-210)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.Visible = false
Instance.new("UICorner", frame)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.Text = "NEKO PRO FIXED"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

-- LAYOUT
local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0,6)

open.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- BUTTON FUNCTION
local function btn(txt, func)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-12,0,28)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(20,20,20)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func)
end

--// SPEED (ANTI RESET)
local speedOn = false
local speedValue = 32

btn("Speed Toggle", function()
    speedOn = not speedOn
end)

RunService.Heartbeat:Connect(function()
    if speedOn and LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then
            h.WalkSpeed = speedValue
        end
    end
end)

--// LONG JUMP + SLOW FALL
local lowGrav = false

btn("Long Jump Toggle", function()
    lowGrav = not lowGrav
end)

RunService.Heartbeat:Connect(function()
    if lowGrav and LP.Character then
        local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
        local h = LP.Character:FindFirstChildOfClass("Humanoid")

        if hrp and h then
            if h:GetState() == Enum.HumanoidStateType.Freefall then
                hrp.Velocity = Vector3.new(
                    hrp.Velocity.X,
                    hrp.Velocity.Y * 0.6, -- slow fall
                    hrp.Velocity.Z
                )
            end
        end
    end
end)

-- Jump boost
btn("Boost Jump", function()
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then
        h.UseJumpPower = true
        h.JumpPower = 120
    end
end)

--// SMOOTH FLY (NO TELEPORT)
local flying = false

btn("Fly Toggle", function()
    flying = not flying

    local char = LP.Character
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart")

    if flying then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "NEKO_FLY"
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)

        RunService:BindToRenderStep("NEKO_FLY",0,function()
            if not flying or not bv.Parent then return end

            local move = char:FindFirstChildOfClass("Humanoid").MoveDirection
            local dir = move

            -- slight upward so no fall
            dir += Vector3.new(0,0.1,0)

            bv.Velocity = dir * 70
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
btn("Noclip", function()
    noclip = not noclip
end)

RunService.Stepped:Connect(function()
    if noclip and LP.Character then
        for _,v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

--// ESP PRO
local espOn = false
local esp = {}

local function addESP(p)
    if p == LP then return end

    local function apply(c)
        if not c then return end
        local hrp = c:WaitForChild("HumanoidRootPart",3)
        if not hrp then return end

        local box = Instance.new("BoxHandleAdornment")
        box.Size = Vector3.new(4,6,2)
        box.Color3 = Color3.new(1,0,0)
        box.AlwaysOnTop = true
        box.Adornee = hrp
        box.Parent = hrp

        local bill = Instance.new("BillboardGui")
        bill.Size = UDim2.new(0,100,0,20)
        bill.AlwaysOnTop = true
        bill.Adornee = hrp

        local txt = Instance.new("TextLabel", bill)
        txt.Size = UDim2.new(1,0,1,0)
        txt.Text = p.Name
        txt.TextColor3 = Color3.new(1,1,1)
        txt.BackgroundTransparency = 1

        bill.Parent = hrp

        esp[p] = {box, bill}
    end

    if p.Character then apply(p.Character) end
    p.CharacterAdded:Connect(apply)
end

btn("ESP Toggle", function()
    espOn = not espOn

    if espOn then
        for _,p in pairs(Players:GetPlayers()) do
            addESP(p)
        end
    else
        for _,v in pairs(esp) do
            for _,o in pairs(v) do o:Destroy() end
        end
        esp = {}
    end
end)

--// AIM ASSIST
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
