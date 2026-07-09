local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp

return function(p1, p2, p3, p4) -- line: 9
	-- upvalues: SetCentralOverlay (copy), OverlayType (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
	return function(p5) -- line: 10
		-- upvalues: SetCentralOverlay (copy), OverlayType (copy), p1 (copy), p2 (copy), p3 (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), p4 (copy)
		p5:dispatch(SetCentralOverlay(OverlayType.GameDetailsPlayWithFriends, {
			universeId = p1,
			menuPosition = p2,
			hideCloseButton = p3,
			shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p4
		}))
	end
end
