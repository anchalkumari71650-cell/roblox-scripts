--// NEKO ULTRA FULL

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local InsertService = game:GetService("InsertService")

local LP = Players.LocalPlayer

pcall(function()
    game.CoreGui.NEKO_ULTRA:Destroy()
end)

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "NEKO_ULTRA"

local open = Instance.new("TextButton", gui)
open.Size = UDim2.new(0,100,0,50)
open.Position = UDim2.new(0,20,0.5,0)
open.Text = "NEKO"
open.BackgroundColor3 = Color3.fromRGB(15,15,15)
open.TextColor3 = Color3.fromRGB(0,255,180)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,400,0,500)
frame.Position = UDim2.new(0.5,-200,0.5,-250)
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
    b.Size = UDim2.new(1,-12,0,34)
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

-- FAST M1
local autoM1 = false
btn("Fast M1", function()
    autoM1 = not autoM1
end)

task.spawn(function()
    while true do
        task.wait(0.02)
        if autoM1 and LP.Character then
            local tool = LP.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end
end)

-- AIM
local circle = Drawing.new("Circle")
circle.Visible = false
circle.Radius = 120
circle.Color = Color3.fromRGB(0,255,180)
circle.Thickness = 2

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

-- ESP
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
            bv.Velocity = move * 60 + Vector3.new(0,1,0)
        end)
    else
        RunService:UnbindFromRenderStep("FLY")
        if hrp and hrp:FindFirstChild("FLY") then
            hrp.FLY:Destroy()
        end
    end
end)

-- FLING FUNCTION
local function fling(p)
    if not p.Character or not LP.Character then return end

    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
    local myhrp = LP.Character:FindFirstChild("HumanoidRootPart")

    if hrp and myhrp then
        myhrp.CFrame = hrp.CFrame
        myhrp.Velocity = Vector3.new(600,600,600)
    end
end

-- KILL AURA
local aura = false
btn("Kill Aura", function()
    aura = not aura
end)

RunService.Heartbeat:Connect(function()
    if aura and LP.Character then
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (p.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude
                if dist < 15 then
                    fling(p)
                end
            end
        end
    end
end)

-- 🔨 BAN HAMMER (ASSET)
btn("Ban Hammer 🔨", function()

    local success, model = pcall(function()
        return InsertService:LoadAsset(7250913946)
    end)

    if success and model then
        local tool = model:FindFirstChildOfClass("Tool")

        if tool then
            tool.Parent = LP.Backpack

            tool.Activated:Connect(function()
                for _,p in pairs(Players:GetPlayers()) do
                    if p ~= LP then
                        fling(p)
                    end
                end
            end)
        end
    else
        warn("Asset failed to load")
    end
end)
