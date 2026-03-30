local Tool = Instance.new("Tool")
Tool.Name = "Kill Stick"
Tool.RequiresHandle = true

local Handle = Instance.new("Part")
Handle.Size = Vector3.new(1, 5, 1)
Handle.BrickColor = BrickColor.new("Bright red")
Handle.Anchored = false
Handle.CanCollide = false
Handle.Name = "Handle"
Handle.Parent = Tool

local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

-- Function to kill player on hit
local function onHit(other)
    local character = other.Parent
    local player = Players:GetPlayerFromCharacter(character)
    if player then
        character:BreakJoints() -- Kills the player by breaking their joints
    end
end

-- Function to enable fly capabilities
local function fly(player)
    local char = player.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if hrp then
        local flySpeed = 50
        hrp.Velocity = Vector3.new(0, flySpeed, 0)
    end
end

-- Function to increase walkspeed and jumps
local function enhancePlayer(player)
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 100 -- Increase walk speed
            humanoid.JumpPower = 100 -- Increase jump power
        end
    end
end

-- Tool activated
Tool.Activated:Connect(function()
    local player = Players.LocalPlayer
    if player then
        fly(player)
        enhancePlayer(player)
    end
end)

-- Handle touched event
Handle.Touched:Connect(onHit)

Tool.Parent = Players.LocalPlayer.Backpack