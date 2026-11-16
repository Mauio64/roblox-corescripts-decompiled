local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/dependencies")

local enumScreens = dependencies.SocialModalsCommon.EnumScreens
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Common/TextKeys")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Common/Constants")

local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Analytics/useAnalytics")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Analytics/Enums/EventNames")

local updateOptedInUsers = dependencies.SocialModalsCommon.Utils.updateOptedInUsers
local updateContactImporterModalLogic = dependencies.SocialModalsCommon.Actions.UpdateContactImporterModalLogic
local updateIsDiscoverabilityUnset = dependencies.SocialModalsCommon.Actions.UpdateIsDiscoverabilityUnset

local networkingUserSettings = dependencies.NetworkingUserSettings
local permissionsProtocol = dependencies.PermissionsProtocol
local promise = dependencies.Promise
local dash = dependencies.Dash
local appStorageService = dependencies.AppStorageService
local socialLibraries = dependencies.SocialLibraries
local react = dependencies.React
local useSelector = dependencies.Hooks.useSelector
local useDispatch = dependencies.Hooks.useDispatch

local getDeepValue = socialLibraries.Dictionary.getDeepValue

local DiscoverabilityOverlay = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Components/DiscoverabilityOverlay/DiscoverabilityOverlay")

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/RobloxAppNavigation").NavigationCommands else nil

local ToastRodux = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/ToastRodux")

local v5 = {
	checkOrRequestPermissions = function(p2)
		return permissionsProtocol.default:checkOrRequestPermissions(p2)
	end
}

return function(options)
	local joined = dash.join(v5, options or {})

	local IS_STANDALONE_DISCOVERABILITY_MODAL = Constants.IS_STANDALONE_DISCOVERABILITY_MODAL
	local v6

	if joined.navigation then
		v6 = joined.navigation.getParam(IS_STANDALONE_DISCOVERABILITY_MODAL)
	else
		v6 = getDeepValue(joined, IS_STANDALONE_DISCOVERABILITY_MODAL)
	end

	local v7 = useDispatch()
	local v8 = useAnalytics()
	local v9 = useSelector(function(p2)
		return p2.ScreenSize
	end)

	local v10 = useSelector(function(p2)
		return p2.LocalUserId
	end)

	local v11 = react.useCallback(function()
		if joined.navigation then
			joined.navigation.pop()
		elseif joined.onClose then
			joined.onClose()
		end
	end, { joined })

	local v12 = useSelector(function(p2)
		return getDeepValue(p2, "DiscoverabilityModal.UserPermissions.userSettingsMetadata")
	end)

	react.useEffect(function()
		local v13 = if v12.prefillDiscoverabilitySetting then Constants.NON_GDPR_VERSION_CHECKBOX else Constants.GDPR_VERSION

		v8.fireAnalyticsEvent(EventNames.DiscoverabilityModalLoad, {
			version = v13,
			wordingVersion = Constants.WORDING_VERSION_1
		})
	end, {})

	local v13 = react.useCallback(function(p2)
		v7(ToastRodux.Actions.SetCurrentToastMessage({ toastMessage = p2 }))
	end, { v7 })

	local function onCloseClicked(p2)
		v8.fireAnalyticsEvent(EventNames.DiscoverabilityModalClose, { selected = p2 })

		v11()
	end

	local function onLearnMoreClick()
		local v14 = {
			name = appPage.GenericWebPage,
			detail = "https://en.help.roblox.com/hc/articles/7416652004884",
			extraProps = { title = "" }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v14))
		else
			v7(navigateDown(v14, nil))
		end
	end

	local function fn(p2)
		v13(TextKeys.CI_FAILED)
	end

	local function onActivated(p2)
		v8.fireAnalyticsEvent(EventNames.DiscoverabilityModalContinue, { selected = p2 })

		if v6 then
			v7(networkingUserSettings.UpdateUserSettings.API({
				phoneNumberDiscoverability = p2
			})):andThen(function()
				v7(updateIsDiscoverabilityUnset({ isDiscoverabilityUnset = false }))

				local NAVIGATE_ON_ACTIVATED = Constants.NAVIGATE_ON_ACTIVATED
				local v14

				if joined.navigation then
					v14 = joined.navigation.getParam(NAVIGATE_ON_ACTIVATED)
				else
					v14 = getDeepValue(joined, NAVIGATE_ON_ACTIVATED)
				end

				v11()
				v14()
				v13(TextKeys.SETTING_SAVED)
			end)
		else
			joined.checkOrRequestPermissions({ permissionsProtocol.Permissions.CONTACTS_ACCESS }):andThen(function(p3)
				if p3 == permissionsProtocol.Status.AUTHORIZED then
					updateOptedInUsers:addUserToLocalStorage(appStorageService, v10)
					v7(updateContactImporterModalLogic({
						hasOSPermissions = true,
						shouldShowContactImporterUpsellModal = false
					}))

					v7(networkingUserSettings.UpdateUserSettings.API({
						phoneNumberDiscoverability = p2
					})):andThen(function()
						v7(updateIsDiscoverabilityUnset({
							isDiscoverabilityUnset = false
						}))

						joined.navigation.replace(enumScreens.ContactsList, {
							[Constants.IS_PHONE_VERIFIED] = true,
							entryPoint = joined.navigation.getParam("entryPoint")
						})
					end)
				else
					if p3 ~= permissionsProtocol.Status.DENIED then
						return promise.reject()
					end

					v7(networkingUserSettings.UpdateUserSettings.API({
						phoneNumberDiscoverability = p2
					})):andThen(function()
						joined.navigation.replace(enumScreens.ContactsRevokedAccessDialog, {
							screenSize = v9,
							closeModal = function()
								joined.navigation.pop()
							end
						})
					end)
				end
			end):catch(fn)
		end
	end

	return react.createElement(DiscoverabilityOverlay, {
		screenSize = v9,
		onCloseClicked = onCloseClicked,
		onLearnMoreClick = onLearnMoreClick,
		onActivated = onActivated,
		prefillDiscoverabilitySetting = v12.prefillDiscoverabilitySetting,
		analytics = v8
	})
end
