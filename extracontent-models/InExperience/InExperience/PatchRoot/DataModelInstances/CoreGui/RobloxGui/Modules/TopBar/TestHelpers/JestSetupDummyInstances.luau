local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

if not RobloxGui:FindFirstChild("Sounds") then
	local sounds = Instance.new("Folder")
	sounds.Name = "Sounds"
	sounds.Parent = RobloxGui
end
