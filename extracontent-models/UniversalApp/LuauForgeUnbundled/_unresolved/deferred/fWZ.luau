local module = require("@luauforge/bundled/edO")
local module2 = require("@luauforge/bundled/edP")

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

return function(p2, p3, p4, p5)
	return function(object)
		object:dispatch(module2(module.GameDetailsPlayWithFriends, {
			universeId = p2,
			menuPosition = p3,
			hideCloseButton = p4,
			shouldHydrateLegacyIxp = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then p5 else nil
		}))
	end
end
