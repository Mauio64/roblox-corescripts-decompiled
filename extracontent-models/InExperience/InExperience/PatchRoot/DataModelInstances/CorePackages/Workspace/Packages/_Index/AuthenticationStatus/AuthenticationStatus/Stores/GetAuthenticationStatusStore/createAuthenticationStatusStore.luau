local Parent = script:FindFirstAncestor("AuthenticationStatus").Parent
local Signals = require(Parent.Signals)
local UNKNOWN = require(Parent.RobloxAppEnums).LoginStatus.UNKNOWN

local function createAuthenticationStatusStore() -- line: 9
	-- upvalues: Signals (copy), UNKNOWN (copy)
	local v5, v6 = Signals.createSignal(UNKNOWN)

	return {
		getStatus = v5,
		setAuthenticationStatus = function(p1) -- line: 12
			-- upvalues: v6 (copy)
			v6(p1)
		end,
		reset = function() -- line: 16
			-- upvalues: v6 (copy), UNKNOWN (copy)
			v6(UNKNOWN)
		end
	}
end

return createAuthenticationStatusStore
