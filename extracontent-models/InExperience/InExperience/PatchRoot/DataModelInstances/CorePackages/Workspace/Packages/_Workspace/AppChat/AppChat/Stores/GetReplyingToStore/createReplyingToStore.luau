local Parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(Parent.Signals)

local function createReplyingToStore() -- line: 24
	-- upvalues: Signals (copy)
	local v4, v5 = Signals.createSignal(nil)

	return {
		getMessageId = v4,
		setReplyingTo = function(s1: string) -- line: 27
			-- upvalues: v5 (copy)
			v5(s1)
		end,
		clear = function() -- line: 31
			-- upvalues: v5 (copy)
			v5(nil)
		end
	}
end

return createReplyingToStore
