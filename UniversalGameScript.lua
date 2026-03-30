local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- Create the main GUI
local ScreenGui = Instance.new('ScreenGui')
local MainFrame = Instance.new('Frame')
MainFrame.Size = UDim2.new(0, 200, 0, 300)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
MainFrame.Parent = ScreenGui

local function createButton(name, position, func)
    local button = Instance.new('TextButton')
    button.Size = UDim2.new(1, 0, 0, 50)
    button.Position = position
    button.Text = name
    button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    button.Parent = MainFrame
    button.MouseButton1Click:Connect(func)
end

createButton('Fly', UDim2.new(0, 0, 0, 0), function()
    local bodyVelocity = Instance.new('BodyVelocity', player.Character.HumanoidRootPart)
    bodyVelocity.Velocity = Vector3.new(0, 50, 0)
end)

createButton('Jump', UDim2.new(0, 0, 0, 50), function()
    player.Character:Move(Vector3.new(0, 50, 0))
end)

createButton('Kill Tool', UDim2.new(0, 0, 0, 100), function()
    local tool = Instance.new('Tool', player.Backpack)
    tool.Name = 'KillTool'
    tool.Activated:Connect(function()
        local hit = mouse.Target
        if hit and hit.Parent:FindFirstChild('Humanoid') then
            hit.Parent.Humanoid.Health = 0
        end
    end)
end)

createButton('Jumpscare', UDim2.new(0, 0, 0, 150), function()
    local jumpscare = Instance.new('ScreenGui')
    local jumpscareFrame = Instance.new('Frame')
    jumpscareFrame.Size = UDim2.new(1, 0, 1, 0)
    jumpscareFrame.BackgroundColor3 = Color3.new(1, 0, 0)
    jumpscareFrame.Parent = jumpscare
    jumpscare.Parent = game.Players.LocalPlayer:WaitForChild('PlayerGui')
    wait(2)
    jumpscare:Destroy()
end)

createButton('Speed Boost', UDim2.new(0, 0, 0, 200), function()
    player.Character.Humanoid.WalkSpeed = 100
end)

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild('PlayerGui')
