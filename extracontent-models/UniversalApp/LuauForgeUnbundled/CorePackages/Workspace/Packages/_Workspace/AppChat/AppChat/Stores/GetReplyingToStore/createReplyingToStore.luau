local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local function createReplyingToStore()
	local signal, v5 = Signals.createSignal(nil)

	return {
		getMessageId = signal,
		setReplyingTo = function(p2)
			v5(p2)
		end,
		clear = function()
			v5(nil)
		end
	}
end

return createReplyingToStore
