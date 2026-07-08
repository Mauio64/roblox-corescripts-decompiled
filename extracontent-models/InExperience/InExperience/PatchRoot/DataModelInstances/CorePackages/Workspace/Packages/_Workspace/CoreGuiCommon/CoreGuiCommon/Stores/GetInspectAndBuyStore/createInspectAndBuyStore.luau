local Parent = script:FindFirstAncestor("CoreGuiCommon").Parent
local createSignal = require(Parent.Signals).createSignal

return function() -- line: 14
	-- upvalues: createSignal (copy)
	local v3, v4 = createSignal(false)

	return {
		getInspectAndBuyOpen = v3,
		setInspectAndBuyOpen = v4
	}
end
