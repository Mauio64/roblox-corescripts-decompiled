local Parent = script:FindFirstAncestor("CoreGuiCommon").Parent
local Signals = require(Parent.Signals)

return function() -- line: 12
	-- upvalues: Signals (copy)
	local v3, v4 = Signals.createSignal(false)

	return {
		getVisibility = v3,
		setVisibility = v4
	}
end
