local StarterGui = game:GetService("StarterGui")
local ParentParent = script.Parent.Parent
local SetRespawnBehavior = require(ParentParent.Actions.SetRespawnBehavior)

local function registerSetCores(p1) -- line: 8
	-- upvalues: StarterGui (copy), SetRespawnBehavior (copy)
	StarterGui:RegisterSetCore("ResetButtonCallback", function(p2) -- line: 9
		-- upvalues: p1 (copy), SetRespawnBehavior (copy)
		local v7 = true
		local v8 = nil

		if typeof(p2) == "boolean" then
			v7 = p2
			v8 = nil
		elseif typeof(p2) == "Instance" and p2:IsA("BindableEvent") then
			v7 = true
			v8 = p2
		else
			error("ResetButtonCallback must be set to a BindableEvent or a boolean", 0)
		end

		p1:dispatch(SetRespawnBehavior(v7, v8))
	end)
end

return registerSetCores
