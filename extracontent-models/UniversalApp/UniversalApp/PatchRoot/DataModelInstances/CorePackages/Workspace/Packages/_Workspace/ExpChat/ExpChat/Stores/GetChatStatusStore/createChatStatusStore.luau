local Parent = script:FindFirstAncestor("ExpChat").Parent
local createSignal = require(Parent.Signals).createSignal

return function() -- line: 28
	-- upvalues: createSignal (copy)
	local v3, v4 = createSignal("Unknown")

	return {
		getChatStatus = v3,
		setChatStatus = v4
	}
end
