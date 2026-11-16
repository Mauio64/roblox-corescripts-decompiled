local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Signals = require(parent.Signals)

require(AppChat.Hooks.useExternalChatMessageSender)

return Signals.createComputed(function()
	local signal, v = Signals.createSignal(nil)
	local function setExternalChatMessageSender(p)
		v(p)
	end

	return {
		getSender = signal,
		setSender = setExternalChatMessageSender,
		clearSender = function()
			v(nil)
		end
	}
end)
