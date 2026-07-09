local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local createSignal = require(Parent.Signals).createSignal

return function() -- line: 13
	-- upvalues: createSignal (copy)
	local v3, v4 = createSignal(false)
	local v5, v6 = createSignal(false)

	return {
		getEnabled = v3,
		setEnabled = v4,
		getStatusIndicatorEnabled = v5,
		setStatusIndicatorEnabled = v6
	}
end
