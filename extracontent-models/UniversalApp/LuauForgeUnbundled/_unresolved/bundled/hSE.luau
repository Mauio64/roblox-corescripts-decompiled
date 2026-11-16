local AppStorageService = game:GetService("AppStorageService")
local engineFeature = game:GetEngineFeature("EnableSystemTray")
local fFlagEnableSystemTrayModals = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSystemTrayModals

local fFlagDebugAlwaysShowSystemTrayModal = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagDebugAlwaysShowSystemTrayModal
local localStorageKey = require("@luauforge/bundled/dCq").Enums.LocalStorageKey
local module = require("@luauforge/bundled/edO")
local module2 = require("@luauforge/bundled/edP")

return function()
	return function(object): boolean
		if not (fFlagEnableSystemTrayModals and engineFeature) then
			return false
		end

		local success, result = pcall(function()
			return AppStorageService:GetItem(localStorageKey.MinimizeToTray)
		end)

		if not success or result == "false" then
			return false
		end

		if fFlagDebugAlwaysShowSystemTrayModal then
			AppStorageService:SetItem("SystemTrayModalShown", "false")
			AppStorageService:Flush()
		end

		local success2, result2 = pcall(function()
			return AppStorageService:GetItem("SystemTrayModalShown")
		end)

		if success2 and result2 == "true" then
			return false
		end

		pcall(function()
			AppStorageService:SetItem("SystemTrayModalShown", "true")
			AppStorageService:Flush()
		end)

		object:dispatch(module2(module.SystemTrayModal, {}))
		return true
	end
end
