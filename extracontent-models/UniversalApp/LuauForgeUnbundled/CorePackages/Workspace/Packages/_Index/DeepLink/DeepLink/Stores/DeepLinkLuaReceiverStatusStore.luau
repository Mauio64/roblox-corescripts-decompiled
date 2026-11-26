local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DeepLink/Signals")
local DeepLinkLuaPostAuthReceiverStatus = require("@game/CorePackages/Workspace/Packages/_Index/DeepLink/DeepLink/Enums/DeepLinkLuaPostAuthReceiverStatus")

local function createDeepLinkConnectionStore()
	local signal, v5 = Signals.createSignal(nil)
	local signal2, v6 = Signals.createSignal(DeepLinkLuaPostAuthReceiverStatus.Disconnected)

	return {
		setDeepLinkLuaPostAuthReceiverStatus = function(p2, p3)
			if p2 == DeepLinkLuaPostAuthReceiverStatus.Ready then
				if p3 then
					v5(p3)
				end
			else
				v5(nil)
			end

			v6(p2)
		end,
		getDeepLinkLuaPostAuthReceiverStatus = signal2,
		setLastDetectedPostAuthUrl = v5,
		getLastDetectedPostAuthUrl = signal
	}
end

return Signals.createComputed(createDeepLinkConnectionStore)
