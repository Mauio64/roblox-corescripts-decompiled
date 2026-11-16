local DeepLink = script:FindFirstAncestor("DeepLink")
local parent = DeepLink.Parent

local Signals = require(parent.Signals)
local DeepLinkLuaPostAuthReceiverStatus = require(DeepLink.Enums.DeepLinkLuaPostAuthReceiverStatus)

local function createDeepLinkConnectionStore()
	local signal, setLastDetectedPostAuthUrl = Signals.createSignal(nil)
	local signal2, v = Signals.createSignal(DeepLinkLuaPostAuthReceiverStatus.Disconnected)

	return {
		setDeepLinkLuaPostAuthReceiverStatus = function(p, p2: string?)
			if p == DeepLinkLuaPostAuthReceiverStatus.Ready then
				if p2 then
					setLastDetectedPostAuthUrl(p2)
				end
			else
				setLastDetectedPostAuthUrl(nil)
			end

			v(p)
		end,
		getDeepLinkLuaPostAuthReceiverStatus = signal2,
		setLastDetectedPostAuthUrl = setLastDetectedPostAuthUrl,
		getLastDetectedPostAuthUrl = signal
	}
end

return Signals.createComputed(createDeepLinkConnectionStore)
