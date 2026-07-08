local ReplicatedStorage = game:GetService("ReplicatedStorage")
local scriptParent = script.Parent

require(scriptParent.Types)

local function dispatchEnhancedVideoConfig(p1) -- line: 9
	-- upvalues: ReplicatedStorage (copy)
	task.spawn(function() -- line: 10
		-- upvalues: ReplicatedStorage (copy), p1 (copy)
		local EnhancedVideoConfig = ReplicatedStorage:WaitForChild("EnhancedVideoConfig", 60)

		if not EnhancedVideoConfig or not EnhancedVideoConfig:IsA("BindableEvent") then
			return
		end

		EnhancedVideoConfig:Fire(p1)
	end)
end

return dispatchEnhancedVideoConfig
