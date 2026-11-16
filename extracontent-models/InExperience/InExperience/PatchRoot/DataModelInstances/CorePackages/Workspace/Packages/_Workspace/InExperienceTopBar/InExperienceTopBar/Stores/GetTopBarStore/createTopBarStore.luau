local StarterGui = game:GetService("StarterGui")
local parent = script:FindFirstAncestor("InExperienceTopBar").Parent
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

return function()
	local signal, v = createSignal(true)

	StarterGui:RegisterSetCore("TopbarEnabled", function(p)
		if type(p) == "boolean" then
			v(p)
		else
			error("SetCore TopbarEnabled argument must be a boolean", 2)
		end
	end)

	StarterGui:RegisterGetCore("TopbarEnabled", function()
		return signal(false)
	end)

	return { getTopBarCoreGuiEnabled = signal }
end
