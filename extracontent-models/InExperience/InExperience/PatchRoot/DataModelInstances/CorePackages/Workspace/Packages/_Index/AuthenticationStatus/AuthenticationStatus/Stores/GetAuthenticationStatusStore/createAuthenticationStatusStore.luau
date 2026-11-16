local parent = script:FindFirstAncestor("AuthenticationStatus").Parent

local Signals = require(parent.Signals)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local unknown = RobloxAppEnums.LoginStatus.UNKNOWN

local function createAuthenticationStatusStore()
	local signal, v = Signals.createSignal(unknown)

	return {
		getStatus = signal,
		setAuthenticationStatus = function(p)
			v(p)
		end,
		reset = function()
			v(unknown)
		end
	}
end

return createAuthenticationStatusStore
