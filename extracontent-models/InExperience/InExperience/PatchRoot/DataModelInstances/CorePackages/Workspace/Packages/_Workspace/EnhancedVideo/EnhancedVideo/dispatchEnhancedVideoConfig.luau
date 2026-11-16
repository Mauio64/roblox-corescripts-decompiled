local ReplicatedStorage = game:GetService("ReplicatedStorage")

local parent = script.Parent
require(parent.Types)

local function dispatchEnhancedVideoConfig(p)
	task.spawn(function()
		local enhancedVideoConfig = ReplicatedStorage:WaitForChild("EnhancedVideoConfig", 60)

		if enhancedVideoConfig and enhancedVideoConfig:IsA("BindableEvent") then
			enhancedVideoConfig:Fire(p)
		end
	end)
end

return dispatchEnhancedVideoConfig
