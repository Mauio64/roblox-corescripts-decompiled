local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp

return function(p1, p2, p3, p4, p5, p6) -- line: 9
	-- upvalues: SetCentralOverlay (copy), OverlayType (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy)
	return function(p7) -- line: 10
		-- upvalues: SetCentralOverlay (copy), OverlayType (copy), p1 (copy), p2 (copy), p3 (copy), p4 (copy), p5 (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), p6 (copy)
		p7:dispatch(SetCentralOverlay(OverlayType.GameDetailMore, {
			universeId = p1,
			menuPosition = p2,
			onClose = p3,
			menuAnchorPoint = p4,
			hideCloseButton = p5,
			shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p6
		}))
	end
end
