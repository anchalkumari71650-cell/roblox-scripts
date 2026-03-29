local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function highlightCharacter(char)
    if not char or char:FindFirstChild("Highlight") then return end
    
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.Parent = char
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        if player.Character then
            highlightCharacter(player.Character)
        end
        
        player.CharacterAdded:Connect(highlightCharacter)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(highlightCharacter)
    end
end)
