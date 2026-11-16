local module = require("@luauforge/bundled/edO")
local module2 = require("@luauforge/bundled/edP")

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

return function(p2, p3, onClose, p4, p5, p6)
	return function(object)
		object:dispatch(module2(module.GameDetailMore, {
			universeId = p2,
			menuPosition = p3,
			onClose = onClose,
			menuAnchorPoint = p4,
			hideCloseButton = p5,
			shouldHydrateLegacyIxp = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then p6 else nil
		}))
	end
end
