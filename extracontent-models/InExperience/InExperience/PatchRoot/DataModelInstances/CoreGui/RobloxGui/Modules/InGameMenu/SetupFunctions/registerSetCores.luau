local StarterGui = game:GetService("StarterGui")

local parent = script.Parent.Parent

local SetRespawnBehavior = require(parent.Actions.SetRespawnBehavior)

local function registerSetCores(object)
	StarterGui:RegisterSetCore("ResetButtonCallback", function(bindableEvent)
		local v = true
		local v2 = nil

		if typeof(bindableEvent) == "boolean" then
			v = bindableEvent
		elseif typeof(bindableEvent) == "Instance" and bindableEvent:IsA("BindableEvent") then
			v2 = bindableEvent
			v = true
		else
			error("ResetButtonCallback must be set to a BindableEvent or a boolean", 0)
		end

		object:dispatch(SetRespawnBehavior(v, v2))
	end)
end

return registerSetCores
