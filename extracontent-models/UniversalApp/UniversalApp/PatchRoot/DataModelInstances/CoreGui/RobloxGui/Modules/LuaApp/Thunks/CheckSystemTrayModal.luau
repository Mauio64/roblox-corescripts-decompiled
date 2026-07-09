local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppStorageService = game:GetService("AppStorageService")
local EngineFeature = game:GetEngineFeature("EnableSystemTray")
local FFlagEnableSystemTrayModals = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSystemTrayModals
local FFlagDebugAlwaysShowSystemTrayModal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagDebugAlwaysShowSystemTrayModal
local LocalStorageKey = require(CorePackages.Workspace.Packages.LocalStorage).Enums.LocalStorageKey
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)

return function() -- line: 13
	-- upvalues: FFlagEnableSystemTrayModals (copy), EngineFeature (copy), AppStorageService (copy), LocalStorageKey (copy), FFlagDebugAlwaysShowSystemTrayModal (copy), SetCentralOverlay (copy), OverlayType (copy)
	return function(p1) -- line: 14
		-- upvalues: FFlagEnableSystemTrayModals (copy), EngineFeature (copy), AppStorageService (copy), LocalStorageKey (copy), FFlagDebugAlwaysShowSystemTrayModal (copy), SetCentralOverlay (copy), OverlayType (copy)
		if not FFlagEnableSystemTrayModals then
			return false
		end

		if not EngineFeature then
			return false
		end

		local ok, result = pcall(function() -- line: 30
			-- upvalues: AppStorageService (copy), LocalStorageKey (copy)
			return AppStorageService:GetItem(LocalStorageKey.MinimizeToTray)
		end)

		if not ok or result == "false" then
			return false
		end

		if FFlagDebugAlwaysShowSystemTrayModal then
			AppStorageService:SetItem("SystemTrayModalShown", "false")
			AppStorageService:Flush()
		end

		local ok2, result2 = pcall(function() -- line: 44
			-- upvalues: AppStorageService (copy)
			return AppStorageService:GetItem("SystemTrayModalShown")
		end)

		if not ok2 or result2 ~= "true" then
			pcall(function() -- line: 51
				-- upvalues: AppStorageService (copy)
				AppStorageService:SetItem("SystemTrayModalShown", "true")
				AppStorageService:Flush()
			end)
			p1:dispatch(SetCentralOverlay(OverlayType.SystemTrayModal, {}))

			return true
		end

		return false
	end
end
