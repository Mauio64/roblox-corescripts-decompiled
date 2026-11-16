local parent = script:FindFirstAncestor("AppChat").Parent

local Signals = require(parent.Signals)

local function createReplyingToStore()
	local signal, v = Signals.createSignal(nil)

	return {
		getMessageId = signal,
		setReplyingTo = function(p: string)
			v(p)
		end,
		clear = function()
			v(nil)
		end
	}
end

return createReplyingToStore
