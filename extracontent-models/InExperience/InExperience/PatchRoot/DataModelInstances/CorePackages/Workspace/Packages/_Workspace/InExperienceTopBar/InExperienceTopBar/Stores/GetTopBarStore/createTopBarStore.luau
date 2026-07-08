local StarterGui = game:GetService("StarterGui")
local Parent = script:FindFirstAncestor("InExperienceTopBar").Parent
local createSignal = require(Parent.Signals).createSignal

return function() -- line: 12
	-- upvalues: createSignal (copy), StarterGui (copy)
	local v4, v5 = createSignal(true)

	StarterGui:RegisterSetCore("TopbarEnabled", function(p1) -- line: 15
		-- upvalues: v5 (copy)
		if type(p1) == "boolean" then
			v5(p1)

			return
		end

		error("SetCore TopbarEnabled argument must be a boolean", 2)
	end)
	StarterGui:RegisterGetCore("TopbarEnabled", function() -- line: 23
		-- upvalues: v4 (copy)
		return v4(false)
	end)

	return {
		getTopBarCoreGuiEnabled = v4
	}
end
