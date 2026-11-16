local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")

local networkingUserSettings = dependencies.NetworkingUserSettings
local updateContactImporterModalLogic = dependencies.SocialModalsCommon.Actions.UpdateContactImporterModalLogic

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/RobloxAppNavigation").NavigationCommands else nil

local ToastRodux = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ToastRodux")

return function(callback)
	return {
		hideContactImporterModal = function()
			return callback(updateContactImporterModalLogic({
				hasOSPermissions = true,
				shouldShowContactImporterUpsellModal = false
			}))
		end,
		getUserSettingsMetadata = function()
			return callback(networkingUserSettings.GetUserSettingsMetadata.API())
		end,
		openLearnMoreLink = function()
			local v5 = {
				name = appPage.GenericWebPage,
				detail = "https://en.help.roblox.com/hc/articles/7416652004884",
				extraProps = { title = "" }
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v5))
			else
				callback(navigateDown(v5, nil))
			end
		end,
		showToast = function(p2)
			callback(ToastRodux.Actions.SetCurrentToastMessage({ toastMessage = p2 }))
		end
	}
end
