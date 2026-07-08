local Parent = script:FindFirstAncestor("ExpChat").Parent
local createSignal = require(Parent.Signals).createSignal

return function() -- line: 15
	-- upvalues: createSignal (copy)
	local v3, v4 = createSignal(false)

	return {
		getChatInputBarFocused = v3,
		focusChatInputBar = function() -- line: 18
			-- upvalues: v4 (copy)
			v4(true)
		end,
		unfocusChatInputBar = function() -- line: 21
			-- upvalues: v4 (copy)
			v4(false)
		end
	}
end
