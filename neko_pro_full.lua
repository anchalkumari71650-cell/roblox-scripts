--// NEKO PRO FULL (ALL-IN-ONE)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local LP = Players.LocalPlayer

pcall(function()
    game.CoreGui.NEKO_PRO:Destroy()
end)

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "NEKO_PRO"

local open = Instance.new("TextButton", gui)
open.Size = UDim2.new(0,90,0,45)
open.Position = UDim2.new(0,20,0.5,0)
open.Text = "NEKO"
open.BackgroundColor3 = Color3.fromRGB(20,20,20)
open.TextColor3 = Color3.fromRGB(0,255,180)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,380,0,460)
frame.Position = UDim2.new(0.5,-190,0.5,-230)
frame.BackgroundColor3 = Color3.fromRGB(10,10,10)
frame.Visible = false
Instance.new("UICorner", frame)

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0,8)

open.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

local function btn(text, func)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-12,0,32)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(20,20,20)
    b.TextColor3 = Color3.fromRGB(0,255,180)
    Instance.new("UICorner", b)
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
        if h then h.WalkSpeed = 50 end
    end
end)

-- SUPER FAST M1
local autoM1 = false
btn("Fast M1", function()
    autoM1 = not autoM1
end)

task.spawn(function()
    while true do
        task.wait(0.03)
        if autoM1 and LP.Character then
            local tool = LP.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end
end)

-- AIM + CIRCLE
local circle = Drawing.new("Circle")
circle.Visible = false
circle.Radius = 120
circle.Color = Color3.fromRGB(0,255,180)
circle.Thickness = 2
circle.Filled = false

local aim = false

btn("Circle Aim", function()
    aim = not aim
    circle.Visible = aim
end)

RunService.RenderStepped:Connect(function()
    circle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    if not aim then return end

    local closest, dist = nil, circle.Radius

    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onscreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onscreen then
                local mag = (Vector2.new(pos.X,pos.Y) - circle.Position).Magnitude
                if mag < dist then
                    dist = mag
                    closest = p
                end
            end
        end
    end

    if closest then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position,
            closest.Character.HumanoidRootPart.Position)
    end
end)

-- BOX ESP
local espOn = false
local esp = {}

local function createESP(p)
    if p == LP then return end

    local function apply(c)
        local hrp = c:WaitForChild("HumanoidRootPart",3)
        if not hrp then return end

        local box = Instance.new("BoxHandleAdornment")
        box.Size = Vector3.new(4,6,2)
        box.Color3 = Color3.fromRGB(0,255,180)
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
        txt.TextColor3 = Color3.fromRGB(0,255,180)
        txt.BackgroundTransparency = 1

        bill.Parent = hrp

        esp[p] = {box, bill}
    end

    if p.Character then apply(p.Character) end
    p.CharacterAdded:Connect(apply)
end

btn("ESP", function()
    espOn = not espOn

    if espOn then
        for _,p in pairs(Players:GetPlayers()) do createESP(p) end
    else
        for _,v in pairs(esp) do
            for _,o in pairs(v) do o:Destroy() end
        end
        esp = {}
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
            bv.Velocity = move * 80 + Vector3.new(0,2,0)
        end)
    else
        RunService:UnbindFromRenderStep("FLY")
        if hrp and hrp:FindFirstChild("FLY") then
            hrp.FLY:Destroy()
        end
    end
end)

-- 🔨 BAN HAMMER (SOFT BAN)
local banned = {}

btn("Ban Hammer 🔨", function()

    local tool = Instance.new("Tool")
    tool.Name = "Ban Hammer"
    tool.RequiresHandle = false

    tool.Activated:Connect(function()
        local char = LP.Character
        if not char then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        for _,p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if dist < 10 then
                    banned[p] = true

                    -- kill effect
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum.Health = 0 end
                end
            end
        end
    end)

    tool.Parent = LP.Backpack
end)

-- KEEP KILLING (FAKE BAN)
RunService.Heartbeat:Connect(function()
    for p,_ in pairs(banned) do
        if p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
            p.Character:FindFirstChildOfClass("Humanoid").Health = 0
        end
    end
end)
