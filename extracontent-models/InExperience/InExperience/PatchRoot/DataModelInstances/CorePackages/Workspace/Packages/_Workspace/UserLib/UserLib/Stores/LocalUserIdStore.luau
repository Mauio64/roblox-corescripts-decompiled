local Parent = script:FindFirstAncestor("UserLib").Parent
local v2, v3 = require(Parent.Signals).createSignal("")

return {
	getCurrentUserId = v2,
	setCurrentUserId = v3,
	reset = function() -- line: 26
		-- upvalues: v3 (copy)
		v3("")
	end
}
