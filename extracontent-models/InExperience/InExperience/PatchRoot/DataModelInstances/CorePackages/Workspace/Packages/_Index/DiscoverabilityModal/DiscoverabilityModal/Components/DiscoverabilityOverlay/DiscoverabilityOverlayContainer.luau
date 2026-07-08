local ParentParent = script.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local ParentParentParent = ParentParent.Parent
local EnumScreens = dependencies.SocialModalsCommon.EnumScreens
local TextKeys = require(ParentParent.Common.TextKeys)
local Constants = require(ParentParent.Common.Constants)
local Analytics = ParentParent.Analytics
local useAnalytics = require(Analytics.useAnalytics)
local EventNames = require(Analytics.Enums.EventNames)
local updateOptedInUsers = dependencies.SocialModalsCommon.Utils.updateOptedInUsers
local UpdateContactImporterModalLogic = dependencies.SocialModalsCommon.Actions.UpdateContactImporterModalLogic
local UpdateIsDiscoverabilityUnset = dependencies.SocialModalsCommon.Actions.UpdateIsDiscoverabilityUnset
local NetworkingUserSettings = dependencies.NetworkingUserSettings
local PermissionsProtocol = dependencies.PermissionsProtocol
local Promise = dependencies.Promise
local Dash = dependencies.Dash
local AppStorageService = dependencies.AppStorageService
local SocialLibraries = dependencies.SocialLibraries
local React = dependencies.React
local useSelector = dependencies.Hooks.useSelector
local useDispatch = dependencies.Hooks.useDispatch
local getDeepValue = SocialLibraries.Dictionary.getDeepValue
local DiscoverabilityOverlay = require(script.Parent.DiscoverabilityOverlay)
local AppPage = require(ParentParentParent.RobloxAppEnums).AppPage
local NavigateDown = require(ParentParentParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(ParentParentParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v27 = if not FFlagSignalsNavP3Dispatch then nil else require(ParentParentParent.RobloxAppNavigation).NavigationCommands
local ToastRodux = require(ParentParentParent.ToastRodux)
local t1 = {
	checkOrRequestPermissions = function(p1) -- line: 66
		-- upvalues: PermissionsProtocol (copy)
		return PermissionsProtocol.default:checkOrRequestPermissions(p1)
	end
}

return function(t2: {[any]: any}) -- line: 72
	-- upvalues: Dash (copy), t1 (copy), getDeepValue (copy), Constants (copy), useDispatch (copy), useAnalytics (copy), useSelector (copy), React (copy), EventNames (copy), ToastRodux (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v27 (copy), NavigateDown (copy), TextKeys (copy), UpdateContactImporterModalLogic (copy), UpdateIsDiscoverabilityUnset (copy), NetworkingUserSettings (copy), PermissionsProtocol (copy), updateOptedInUsers (copy), AppStorageService (copy), EnumScreens (copy), Promise (copy), DiscoverabilityOverlay (copy)
	local v32 = Dash.join(t1, t2 or {})
	local IS_STANDALONE_DISCOVERABILITY_MODAL = Constants.IS_STANDALONE_DISCOVERABILITY_MODAL
	local v34 = if not v32.navigation then getDeepValue(v32, IS_STANDALONE_DISCOVERABILITY_MODAL) else v32.navigation.getParam(IS_STANDALONE_DISCOVERABILITY_MODAL)
	local v35 = useDispatch()
	local v36 = useAnalytics()
	local v37 = useSelector(function(t3: {[any]: any}) -- line: 84
		return t3.ScreenSize
	end)
	local v38 = useSelector(function(t4: {[any]: any}) -- line: 87
		return t4.LocalUserId
	end)
	local v39 = React.useCallback(function() -- line: 91
		-- upvalues: v32 (copy)
		if v32.navigation then
			v32.navigation.pop()

			return
		end

		if v32.onClose then
			v32.onClose()
		end
	end, { v32 })
	local v40 = useSelector(function(t5: {[any]: any}) -- line: 99
		-- upvalues: getDeepValue (copy)
		return getDeepValue(t5, "DiscoverabilityModal.UserPermissions.userSettingsMetadata")
	end)

	React.useEffect(function() -- line: 103
		-- upvalues: v40 (copy), Constants (copy), v36 (copy), EventNames (copy)
		local v47 = if not v40.prefillDiscoverabilitySetting then Constants.GDPR_VERSION else Constants.NON_GDPR_VERSION_CHECKBOX

		v36.fireAnalyticsEvent(EventNames.DiscoverabilityModalLoad, {
			version = v47,
			wordingVersion = Constants.WORDING_VERSION_1
		})
	end, {})

	local v41 = React.useCallback(function(p2) -- line: 117
		-- upvalues: v35 (copy), ToastRodux (copy)
		v35(ToastRodux.Actions.SetCurrentToastMessage({
			toastMessage = p2
		}))
	end, { v35 })

	local function v42(_) -- line: 145
		-- upvalues: v41 (copy), TextKeys (copy)
		v41(TextKeys.CI_FAILED)
	end

	return React.createElement(DiscoverabilityOverlay, {
		screenSize = v37,
		onCloseClicked = function(s1: string) -- line: 123
			-- upvalues: v36 (copy), EventNames (copy), v39 (copy)
			v36.fireAnalyticsEvent(EventNames.DiscoverabilityModalClose, {
				selected = s1
			})
			v39()
		end,
		onLearnMoreClick = function() -- line: 130
			-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v27 (copy), v35 (copy), NavigateDown (copy)
			local t6 = {
				detail = "https://en.help.roblox.com/hc/articles/7416652004884",
				name = AppPage.GenericWebPage,
				extraProps = {
					title = ""
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v27.down(v27.fromLegacyPage(t6))

				return
			end

			v35(NavigateDown(t6, nil))
		end,
		onActivated = function(s2: string) -- line: 168
			-- upvalues: v36 (copy), EventNames (copy), v34 (copy), v35 (copy), NetworkingUserSettings (copy), UpdateIsDiscoverabilityUnset (copy), Constants (copy), v32 (copy), getDeepValue (copy), v39 (copy), v41 (copy), TextKeys (copy), PermissionsProtocol (copy), updateOptedInUsers (copy), AppStorageService (copy), v38 (copy), UpdateContactImporterModalLogic (copy), EnumScreens (copy), v37 (copy), Promise (copy), v42 (copy)
			v36.fireAnalyticsEvent(EventNames.DiscoverabilityModalContinue, {
				selected = s2
			})

			if v34 then
				v35(NetworkingUserSettings.UpdateUserSettings.API({
					phoneNumberDiscoverability = s2
				})):andThen(function() -- line: 174
					-- upvalues: v35 (copy), UpdateIsDiscoverabilityUnset (copy), Constants (copy), v32 (copy), getDeepValue (copy), v39 (copy), v41 (copy), TextKeys (copy)
					v35(UpdateIsDiscoverabilityUnset({
						isDiscoverabilityUnset = false
					}))

					local NAVIGATE_ON_ACTIVATED = Constants.NAVIGATE_ON_ACTIVATED
					local v55 = if not v32.navigation then getDeepValue(v32, NAVIGATE_ON_ACTIVATED) else v32.navigation.getParam(NAVIGATE_ON_ACTIVATED)

					v39()
					v55()
					v41(TextKeys.SETTING_SAVED)
				end)

				return
			end

			v32.checkOrRequestPermissions({ PermissionsProtocol.Permissions.CONTACTS_ACCESS }):andThen(function(p4) -- line: 186
				-- upvalues: PermissionsProtocol (copy), updateOptedInUsers (copy), AppStorageService (copy), v38 (copy), v35 (copy), UpdateContactImporterModalLogic (copy), s2 (copy), NetworkingUserSettings (copy), UpdateIsDiscoverabilityUnset (copy), v32 (copy), EnumScreens (copy), Constants (copy), v37 (copy), Promise (copy)
				if p4 == PermissionsProtocol.Status.AUTHORIZED then
					updateOptedInUsers:addUserToLocalStorage(AppStorageService, v38)
					v35(UpdateContactImporterModalLogic({
						hasOSPermissions = true,
						shouldShowContactImporterUpsellModal = false
					}))

					local v57 = s2

					v35(NetworkingUserSettings.UpdateUserSettings.API({
						phoneNumberDiscoverability = v57
					})):andThen(function() -- line: 190
						-- upvalues: v35 (copy), UpdateIsDiscoverabilityUnset (copy), v32 (copy), EnumScreens (copy), Constants (copy)
						v35(UpdateIsDiscoverabilityUnset({
							isDiscoverabilityUnset = false
						}))
						v32.navigation.replace(EnumScreens.ContactsList, {
							[Constants.IS_PHONE_VERIFIED] = true,
							entryPoint = v32.navigation.getParam("entryPoint")
						})
					end)

					return
				end

				if p4 == PermissionsProtocol.Status.DENIED then
					local v58 = s2

					v35(NetworkingUserSettings.UpdateUserSettings.API({
						phoneNumberDiscoverability = v58
					})):andThen(function() -- line: 199
						-- upvalues: v32 (copy), EnumScreens (copy), v37 (copy)
						v32.navigation.replace(EnumScreens.ContactsRevokedAccessDialog, {
							screenSize = v37,
							closeModal = function() -- line: 202
								-- upvalues: v32 (copy)
								v32.navigation.pop()
							end
						})
					end)

					return
				end

				return Promise.reject()
			end):catch(v42)
		end,
		prefillDiscoverabilitySetting = v40.prefillDiscoverabilitySetting,
		analytics = v36
	})
end
