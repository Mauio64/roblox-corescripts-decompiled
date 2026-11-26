local module = require("@luauforge/bundled/ggj")

local module2 = require("@luauforge/bundled/ggi")
local module3 = require("@luauforge/bundled/ggp")

local fFlagUseSignalsForAuthenticationStatus = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/ggh").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

return function(p2, p3, p4)
	return function(object)
		local v5

		if fFlagUseSignalsForAuthenticationStatus then
			v5 = getAuthenticationStatusStore(false).getStatus(false)
		else
			v5 = object:getState().AuthenticationStatus.status
		end

		if v5 == module.LOGGED_IN then
			object:dispatch(module2(p2, p3, module3.UnauthorizedResponse, p4))
		end
	end
end
