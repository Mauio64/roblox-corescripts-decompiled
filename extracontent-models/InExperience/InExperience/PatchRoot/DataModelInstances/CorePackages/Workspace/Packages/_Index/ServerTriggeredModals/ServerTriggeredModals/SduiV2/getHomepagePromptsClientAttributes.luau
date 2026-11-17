local AppStorageService = game:GetService("AppStorageService")

local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local parent = ServerTriggeredModals.Parent
local SharedFlags = require(parent.SharedFlags)

local FFlagEdpGameLeavePromptsHandlerEnabled = SharedFlags.FFlagEdpGameLeavePromptsHandlerEnabled
local FFlagSplitPaneEducationalTour = SharedFlags.FFlagSplitPaneEducationalTour
local FFlagPlusUpsellSheetHomePrompt = require(ServerTriggeredModals.Flags.FFlagPlusUpsellSheetHomePrompt)
local RobloxSubscriptionPurchaseApp = require(parent.RobloxSubscriptionPurchaseApp)
local FFlagTTOnboardingSheet = RobloxSubscriptionPurchaseApp.Flags.FFlagTTOnboardingSheet

local FFlagHomepagePromptsHalloween2026Theme = require(ServerTriggeredModals.Flags.FFlagHomepagePromptsHalloween2026Theme)
local FFlagAppThemeHalloween2026 = require(parent.SharedFlags.FFlagAppThemeHalloween2026)
local FFlagAppThemeHalloween2026ForAll = require(parent.SharedFlags.FFlagAppThemeHalloween2026ForAll)

local Promise = require(parent.Promise)
local NotificationsUpsell = require(parent.NotificationsUpsell)
local React = require(parent.React)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies
local PromptsEntryPoint = require(script.Parent.PromptsEntryPoint)

local AppPage = RobloxAppEnums.AppPage

local defineFastInt = game:DefineFastInt("PushNotificationsUpsellPromptsClientAttributesTimeoutMs", 1000)

local v = nil
local count = 0

local function homePageSessionOrdinalFor(p: number?) -- 1 equivalent call inferred from this helper
	if p ~= nil and p ~= v then
		v = p
		count += 1
	end

	return count
end

local function readStoredNumber(p: string)
	local success, item = pcall(AppStorageService.GetItem, AppStorageService, p)

	if success then
		return true, tonumber(item) or 0
	end

	return false, -1
end

local function getExistingHomepageClientAttributes()
	local existingHomepageClientAttributes = {}

	if FFlagSplitPaneEducationalTour then
		local SplitPane = require(parent.SplitPane)

		if SplitPane.isSplitPaneTourSupported() then
			existingHomepageClientAttributes.isSplitPaneTourSupported = "true"
		end
	end

	if
		FFlagPlusUpsellSheetHomePrompt
		and FFlagTTOnboardingSheet
		and not getAppFeaturePolicies().getDisableBlackbirdEntrypoints()
	then
		existingHomepageClientAttributes.isPlusUpsellSheetPromptSupported = "true"
	end

	local success, item = pcall(AppStorageService.GetItem, AppStorageService, "KidsAccountHasResetToDefaultTheme")

	if success and typeof(item) == "string" and item ~= "" then
		existingHomepageClientAttributes.KidsAccountHasResetToDefaultTheme = item
	end

	if FFlagHomepagePromptsHalloween2026Theme then
		existingHomepageClientAttributes.applicablePlusThemes = FFlagAppThemeHalloween2026 and "Halloween2026" or ""
		existingHomepageClientAttributes.applicableDeviceThemes = FFlagAppThemeHalloween2026
			and FFlagAppThemeHalloween2026ForAll
			and "Halloween2026"
			or ""
	end

	return existingHomepageClientAttributes
end

local function getHomepagePromptsClientAttributes() -- 1 equivalent call inferred from this helper
	local existingHomepageClientAttributes = getExistingHomepageClientAttributes()

	if next(existingHomepageClientAttributes) == nil then
		return nil
	end

	return existingHomepageClientAttributes
end

local function useHomepagePromptsClientAttributes(p: string, p2)
	local v2

	if p == PromptsEntryPoint.HomepageLaunch then
		v2 = not FFlagEdpGameLeavePromptsHandlerEnabled or p2 == nil
	else
		v2 = false
	end

	local v3 = useLocalUserId()
	local v4 = useSelector(function(p3)
		return p3.LaunchContext
	end)

	local homePageSessionTimestamp = useSelector(function(p3)
		return p3.Personalization and p3.Personalization.PageSessionTimestamp[AppPage.Home]
	end)

	local state, setState = React.useState(nil)
	local userId = tonumber(v3) or 0

	React.useEffect(function()
		if not v2 then
			return
		end

		local flag = true
		local launchContext = v4 or "Unknown"
		local attributes = getHomepagePromptsClientAttributes() or {} -- inferred equivalent call
		local promptShownCount = NotificationsUpsell.NotificationsUpsellConstants.LocalStorageKeys.PromptShownCount

		local sysPromptShownTimestamp = NotificationsUpsell.NotificationsUpsellConstants.LocalStorageKeys.SysPromptShownTimestamp
		local success, item = pcall(AppStorageService.GetItem, AppStorageService, promptShownCount)
		local v5, v6

		if success then
			v5 = tonumber(item) or 0
			v6 = true
		else
			v6 = false
			v5 = -1
		end

		local success2, item2 = pcall(AppStorageService.GetItem, AppStorageService, sysPromptShownTimestamp)
		local v7, v8

		if success2 then
			v7 = tonumber(item2) or 0
			v8 = true
		else
			v8 = false
			v7 = -1
		end

		local count2 = homePageSessionOrdinalFor(homePageSessionTimestamp) -- inferred equivalent call
		local flag2 = false

		local function resolveWithNativeStatus(nativePushPermissionUpsellStatus: string)
			if flag2 then
				return
			end

			flag2 = true

			attributes.nativePushPermissionUpsellStatus = nativePushPermissionUpsellStatus
			attributes.launchContext = launchContext

			if homePageSessionTimestamp ~= nil then
				attributes.homePageSessionTimestamp = tostring(homePageSessionTimestamp)
				attributes.homePageSessionOrdinal = tostring(count2)
			end

			attributes.legacyPushHistoryReadStatus = v6 and v8 and "SUCCESS" or "ERROR"

			attributes.legacyPushPromptShownCount = tostring(v5)
			attributes.legacyPushSystemPromptShownTimestamp = tostring(v7)

			if flag then
				setState({
					attributes = attributes,
					homePageSessionTimestamp = homePageSessionTimestamp,
					launchContext = launchContext,
					userId = userId
				})
			end
		end

		NotificationsUpsell.setupPushNotificationsUpsell.GetPushNotificationPermissionUpsellStatus():andThen(resolveWithNativeStatus)
		Promise.delay(defineFastInt / 1000):andThen(function()
			resolveWithNativeStatus("TIMEOUT")
		end)

		return function()
			flag = false
		end
	end, { v2, homePageSessionTimestamp, v4, userId })
	local attributes

	if not (state == nil or state.homePageSessionTimestamp ~= homePageSessionTimestamp or state.launchContext ~= (v4 or "Unknown") or state.userId ~= userId) then
		attributes = state.attributes
	end

	return if v2 then attributes else nil
end

return {
	get = getHomepagePromptsClientAttributes,
	use = useHomepagePromptsClientAttributes,
	sessionClientAttribute = "homePageSessionOrdinal"
}
