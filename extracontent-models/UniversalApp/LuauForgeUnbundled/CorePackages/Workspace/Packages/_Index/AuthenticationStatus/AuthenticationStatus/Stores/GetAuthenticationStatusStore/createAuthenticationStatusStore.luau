local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthenticationStatus/Signals")
local unknown = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthenticationStatus/RobloxAppEnums").LoginStatus.UNKNOWN

local function createAuthenticationStatusStore()
	local signal, v5 = Signals.createSignal(unknown)

	return {
		getStatus = signal,
		setAuthenticationStatus = function(p2)
			v5(p2)
		end,
		reset = function()
			v5(unknown)
		end
	}
end

return createAuthenticationStatusStore
