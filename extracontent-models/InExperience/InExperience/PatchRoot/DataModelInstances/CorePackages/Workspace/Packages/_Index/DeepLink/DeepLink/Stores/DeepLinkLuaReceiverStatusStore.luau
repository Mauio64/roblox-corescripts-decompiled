local DeepLink = script:FindFirstAncestor("DeepLink")
local DeepLinkParent = DeepLink.Parent
local Signals = require(DeepLinkParent.Signals)
local DeepLinkLuaPostAuthReceiverStatus = require(DeepLink.Enums.DeepLinkLuaPostAuthReceiverStatus)

local function createDeepLinkConnectionStore() -- line: 7
	-- upvalues: Signals (copy), DeepLinkLuaPostAuthReceiverStatus (copy)
	local v6, v7 = Signals.createSignal(nil)
	local v8, v9 = Signals.createSignal(DeepLinkLuaPostAuthReceiverStatus.Disconnected)

	return {
		setDeepLinkLuaPostAuthReceiverStatus = function(p1, s1: string?) -- line: 15
			-- upvalues: DeepLinkLuaPostAuthReceiverStatus (copy), v7 (copy), v9 (copy)
			if p1 == DeepLinkLuaPostAuthReceiverStatus.Ready then
				if s1 then
					v7(s1)
				end
			else
				v7(nil)
			end

			v9(p1)
		end,
		getDeepLinkLuaPostAuthReceiverStatus = v8,
		setLastDetectedPostAuthUrl = v7,
		getLastDetectedPostAuthUrl = v6
	}
end

return Signals.createComputed(createDeepLinkConnectionStore)
