local ParentParent = script.Parent.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local ParentParentParent = ParentParent.Parent
local NetworkingUserSettings = dependencies.NetworkingUserSettings
local UpdateContactImporterModalLogic = dependencies.SocialModalsCommon.Actions.UpdateContactImporterModalLogic
local AppPage = require(ParentParentParent.RobloxAppEnums).AppPage
local NavigateDown = require(ParentParentParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(ParentParentParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v9 = if not FFlagSignalsNavP3Dispatch then nil else require(ParentParentParent.RobloxAppNavigation).NavigationCommands
local ToastRodux = require(ParentParentParent.ToastRodux)

return function(p1) -- line: 19
	-- upvalues: UpdateContactImporterModalLogic (copy), NetworkingUserSettings (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), NavigateDown (copy), ToastRodux (copy)
	return {
		hideContactImporterModal = function() -- line: 21
			-- upvalues: p1 (copy), UpdateContactImporterModalLogic (copy)
			return p1(UpdateContactImporterModalLogic({
				hasOSPermissions = true,
				shouldShowContactImporterUpsellModal = false
			}))
		end,
		getUserSettingsMetadata = function() -- line: 27
			-- upvalues: p1 (copy), NetworkingUserSettings (copy)
			return p1(NetworkingUserSettings.GetUserSettingsMetadata.API())
		end,
		openLearnMoreLink = function() -- line: 30
			-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), p1 (copy), NavigateDown (copy)
			local t1 = {
				detail = "https://en.help.roblox.com/hc/articles/7416652004884",
				name = AppPage.GenericWebPage,
				extraProps = {
					title = ""
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v9.down(v9.fromLegacyPage(t1))

				return
			end

			p1(NavigateDown(t1, nil))
		end,
		showToast = function(p2) -- line: 44
			-- upvalues: p1 (copy), ToastRodux (copy)
			p1(ToastRodux.Actions.SetCurrentToastMessage({
				toastMessage = p2
			}))
		end
	}
end
