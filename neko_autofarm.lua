--// NEKO AUTO FARM SYSTEM (SERVER SAFE)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local HEIGHT = 12
local RANGE = 80
local SPEED = 60
local DAMAGE = 15

--// GET NEAREST NPC
local function getNearestNPC(player)
    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local nearest = nil
    local shortest = RANGE

    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model")
        and npc ~= char
        and npc:FindFirstChild("Humanoid")
        and npc:FindFirstChild("HumanoidRootPart") then

            local hum = npc.Humanoid
            if hum.Health > 0 then
                local dist = (npc.HumanoidRootPart.Position - hrp.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    nearest = npc
                end
            end
        end
    end

    return nearest
end

--// MAIN
Players.PlayerAdded:Connect(function(player)

    player.CharacterAdded:Connect(function(char)
        local hrp = char:WaitForChild("HumanoidRootPart")
        local humanoid = char:WaitForChild("Humanoid")

        -- BODY MOVERS (smooth fly)
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        bv.Velocity = Vector3.zero
        bv.Parent = hrp

        local bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
        bg.P = 1e4
        bg.CFrame = hrp.CFrame
        bg.Parent = hrp

        -- LOOP
        task.spawn(function()
            while char.Parent do
                task.wait(0.08)

                local npc = getNearestNPC(player)

                if npc then
                    local nHRP = npc:FindFirstChild("HumanoidRootPart")
                    local nHum = npc:FindFirstChild("Humanoid")

                    if nHRP and nHum and nHum.Health > 0 then

                        -- ✈️ POSITION ABOVE NPC
                        local targetPos = nHRP.Position + Vector3.new(0, HEIGHT, 0)
                        local direction = (targetPos - hrp.Position)

                        -- smooth movement (NO TELEPORT)
                        bv.Velocity = direction.Unit * SPEED

                        -- face NPC
                        bg.CFrame = CFrame.new(hrp.Position, nHRP.Position)

                        -- ⚔️ ATTACK SYSTEM
                        local tool = char:FindFirstChildOfClass("Tool")

                        if tool then
                            tool:Activate() -- uses your fighting styles
                        else
                            nHum:TakeDamage(DAMAGE) -- fallback
                        end

                    else
                        bv.Velocity = Vector3.zero
                    end
                else
                    bv.Velocity = Vector3.zero
                end
            end
        end)
    end)
end)
