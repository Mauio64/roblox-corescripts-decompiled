local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Signals = require(AppChatParent.Signals)

require(AppChat.Hooks.useExternalChatMessageSender)

return Signals.createComputed(function() -- line: 16
	-- upvalues: Signals (copy)
	local v4, v5 = Signals.createSignal(nil)

	local function setExternalChatMessageSender(p1) -- line: 19
		-- upvalues: v5 (copy)
		v5(p1)
	end

	return {
		getSender = v4,
		setSender = setExternalChatMessageSender,
		clearSender = function() -- line: 26
			-- upvalues: v5 (copy)
			v5(nil)
		end
	}
end)
