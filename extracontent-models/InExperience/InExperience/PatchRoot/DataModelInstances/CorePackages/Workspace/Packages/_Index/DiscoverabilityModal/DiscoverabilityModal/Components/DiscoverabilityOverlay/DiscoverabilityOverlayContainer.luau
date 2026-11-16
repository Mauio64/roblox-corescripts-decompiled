local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
local parent2 = parent.Parent

local enumScreens = dependencies.SocialModalsCommon.EnumScreens
local TextKeys = require(parent.Common.TextKeys)
local Constants = require(parent.Common.Constants)
local analytics = parent.Analytics
local useAnalytics = require(analytics.useAnalytics)
local EventNames = require(analytics.Enums.EventNames)

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

local DiscoverabilityOverlay = require(script.Parent.DiscoverabilityOverlay)

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

local v = {
	checkOrRequestPermissions = function(p)
		return permissionsProtocol.default:checkOrRequestPermissions(p)
	end
}

return function(options)
	local joined = dash.join(v, options or {})
	local function fn(p) -- 2 equivalent calls inferred from this helper
		if joined.navigation then
			return joined.navigation.getParam(p)
		end

		return getDeepValue(joined, p)
	end

	local v2 = fn(Constants.IS_STANDALONE_DISCOVERABILITY_MODAL) -- inferred equivalent call
	local v3 = useDispatch()
	local analytics2 = useAnalytics()
	local screenSize = useSelector(function(p)
		return p.ScreenSize
	end)

	local v4 = useSelector(function(p)
		return p.LocalUserId
	end)

	local v5 = react.useCallback(function()
		if joined.navigation then
			joined.navigation.pop()
		elseif joined.onClose then
			joined.onClose()
		end
	end, { joined })

	local v6 = useSelector(function(p)
		return getDeepValue(p, "DiscoverabilityModal.UserPermissions.userSettingsMetadata")
	end)

	react.useEffect(function()
		local version

		if v6.prefillDiscoverabilitySetting then
			version = Constants.NON_GDPR_VERSION_CHECKBOX
		else
			version = Constants.GDPR_VERSION
		end

		analytics2.fireAnalyticsEvent(EventNames.DiscoverabilityModalLoad, {
			version = version,
			wordingVersion = Constants.WORDING_VERSION_1
		})
	end, {})

	local v7 = react.useCallback(function(toastMessage)
		v3(ToastRodux.Actions.SetCurrentToastMessage({ toastMessage = toastMessage }))
	end, { v3 })

	local function onCloseClicked(selected: string)
		analytics2.fireAnalyticsEvent(EventNames.DiscoverabilityModalClose, { selected = selected })

		v5()
	end

	local function onLearnMoreClick()
		local v8 = {
			name = AppPage.GenericWebPage,
			detail = "https://en.help.roblox.com/hc/articles/7416652004884",
			extraProps = { title = "" }
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v8))
		else
			v3(NavigateDown(v8, nil))
		end
	end

	local function fn2(_)
		v7(TextKeys.CI_FAILED)
	end

	local function fn3() -- 1 equivalent call inferred from this helper
		return v3(updateContactImporterModalLogic({
			hasOSPermissions = true,
			shouldShowContactImporterUpsellModal = false
		}))
	end

	local function fn4() -- 2 equivalent calls inferred from this helper
		return v3(updateIsDiscoverabilityUnset({ isDiscoverabilityUnset = false }))
	end

	local function fn5(phoneNumberDiscoverability: string) -- 3 equivalent calls inferred from this helper
		return v3(networkingUserSettings.UpdateUserSettings.API({
			phoneNumberDiscoverability = phoneNumberDiscoverability
		}))
	end

	local function onActivated(selected: string)
		analytics2.fireAnalyticsEvent(EventNames.DiscoverabilityModalContinue, {
			selected = selected
		})

		if v2 then
			fn5(selected):andThen(function() -- inferred equivalent call
				fn4() -- inferred equivalent call
				local v8 = fn(Constants.NAVIGATE_ON_ACTIVATED) -- inferred equivalent call
				v5()
				v8()
				v7(TextKeys.SETTING_SAVED)
			end)
		else
			joined.checkOrRequestPermissions({ permissionsProtocol.Permissions.CONTACTS_ACCESS }):andThen(function(p)
				if p == permissionsProtocol.Status.AUTHORIZED then
					updateOptedInUsers:addUserToLocalStorage(appStorageService, v4)
					fn3() -- inferred equivalent call
					fn5(selected):andThen(function() -- inferred equivalent call
						fn4() -- inferred equivalent call
						joined.navigation.replace(enumScreens.ContactsList, {
							[Constants.IS_PHONE_VERIFIED] = true,
							entryPoint = joined.navigation.getParam("entryPoint")
						})
					end)
				else
					if p ~= permissionsProtocol.Status.DENIED then
						return promise.reject()
					end

					fn5(selected):andThen(function() -- inferred equivalent call
						joined.navigation.replace(enumScreens.ContactsRevokedAccessDialog, {
							screenSize = screenSize,
							closeModal = function()
								joined.navigation.pop()
							end
						})
					end)
				end
			end):catch(fn2)
		end
	end

	return react.createElement(DiscoverabilityOverlay, {
		screenSize = screenSize,
		onCloseClicked = onCloseClicked,
		onLearnMoreClick = onLearnMoreClick,
		onActivated = onActivated,
		prefillDiscoverabilitySetting = v6.prefillDiscoverabilitySetting,
		analytics = analytics2
	})
end
