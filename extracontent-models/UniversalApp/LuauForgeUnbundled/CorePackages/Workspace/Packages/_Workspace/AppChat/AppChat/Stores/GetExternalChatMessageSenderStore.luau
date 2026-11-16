local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useExternalChatMessageSender")

return Signals.createComputed(function()
	local signal, v5 = Signals.createSignal(nil)
	local function setExternalChatMessageSender(p2)
		v5(p2)
	end

	return {
		getSender = signal,
		setSender = setExternalChatMessageSender,
		clearSender = function()
			v5(nil)
		end
	}
end)
