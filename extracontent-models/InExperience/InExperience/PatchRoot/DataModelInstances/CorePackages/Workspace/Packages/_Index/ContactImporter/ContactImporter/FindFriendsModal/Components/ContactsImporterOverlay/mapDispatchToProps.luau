local parent = script.Parent.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
local parent2 = parent.Parent

local networkingUserSettings = dependencies.NetworkingUserSettings
local updateContactImporterModalLogic = dependencies.SocialModalsCommon.Actions.UpdateContactImporterModalLogic

local RobloxAppEnums = require(parent2.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent2.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent2.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent2.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local ToastRodux = require(parent2.ToastRodux)

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
			local v = {
				name = AppPage.GenericWebPage,
				detail = "https://en.help.roblox.com/hc/articles/7416652004884",
				extraProps = { title = "" }
			}

			if FFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v))
			else
				callback(NavigateDown(v, nil))
			end
		end,
		showToast = function(toastMessage)
			callback(ToastRodux.Actions.SetCurrentToastMessage({ toastMessage = toastMessage }))
		end
	}
end
