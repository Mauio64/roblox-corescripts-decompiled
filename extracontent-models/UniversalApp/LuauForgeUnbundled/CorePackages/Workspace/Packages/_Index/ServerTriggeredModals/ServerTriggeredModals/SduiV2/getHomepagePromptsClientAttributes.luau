local AppStorageService = game:GetService("AppStorageService")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags")

local fFlagEdpGameLeavePromptsHandlerEnabled = SharedFlags.FFlagEdpGameLeavePromptsHandlerEnabled
local fFlagSplitPaneEducationalTour = SharedFlags.FFlagSplitPaneEducationalTour

local FFlagHomepagePromptsHalloween2026Theme = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/Flags/FFlagHomepagePromptsHalloween2026Theme")
local FFlagAppThemeHalloween2026 = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/SharedFlags/FFlagAppThemeHalloween2026")
local FFlagAppThemeHalloween2026ForAll = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/SharedFlags/FFlagAppThemeHalloween2026ForAll")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/Promise")
local NotificationsUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/NotificationsUpsell")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/React")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RobloxAppEnums")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/RobloxAppHooks").useLocalUserId
local PromptsEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsEntryPoint")

local appPage = RobloxAppEnums.AppPage

local defineFastInt = game:DefineFastInt("PushNotificationsUpsellPromptsClientAttributesTimeoutMs", 1000)

local v5 = nil
local count = 0

local function homePageSessionOrdinalFor(p2)
	if p2 ~= nil and p2 ~= v5 then
		v5 = p2
		count += 1
	end

	return count
end

local function readStoredNumber(p2)
	local success, item = pcall(AppStorageService.GetItem, AppStorageService, p2)

	if success then
		return true, tonumber(item) or 0
	end

	return false, -1
end

local function getExistingHomepageClientAttributes()
	local existingHomepageClientAttributes = {}

	if fFlagSplitPaneEducationalTour and require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SplitPane").isSplitPaneTourSupported() then
		existingHomepageClientAttributes.isSplitPaneTourSupported = "true"
	end

	local success, item = pcall(
		AppStorageService.GetItem,
		AppStorageService,
		"KidsAccountHasResetToDefaultTheme"
	)

	if success and typeof(item) == "string" and item ~= "" then
		existingHomepageClientAttributes.KidsAccountHasResetToDefaultTheme = item
	end

	if FFlagHomepagePromptsHalloween2026Theme then
		existingHomepageClientAttributes.applicablePlusThemes = FFlagAppThemeHalloween2026 and "Halloween2026" or ""
		existingHomepageClientAttributes.applicableDeviceThemes = FFlagAppThemeHalloween2026 and FFlagAppThemeHalloween2026ForAll and "Halloween2026"
			or ""
	end

	return existingHomepageClientAttributes
end

local function getHomepagePromptsClientAttributes()
	local existingHomepageClientAttributes = getExistingHomepageClientAttributes()

	if next(existingHomepageClientAttributes) == nil then
		return nil
	end

	return existingHomepageClientAttributes
end

local function useHomepagePromptsClientAttributes(p2, p3)
	local v6 = p2 == PromptsEntryPoint.HomepageLaunch and (not fFlagEdpGameLeavePromptsHandlerEnabled or p3 == nil)

	local v7 = useLocalUserId()
	local v8 = useSelector(function(p4)
		return p4.LaunchContext
	end)

	local v9 = useSelector(function(p4)
		return p4.Personalization and p4.Personalization.PageSessionTimestamp[appPage.Home]
	end)

	local state, setState = React.useState(nil)
	local v10 = tonumber(v7) or 0

	React.useEffect(function()
		if not v6 then
			return
		end

		local flag = true
		local v11 = v8 or "Unknown"
		local existingHomepageClientAttributes = getExistingHomepageClientAttributes()

		if next(existingHomepageClientAttributes) == nil then
			existingHomepageClientAttributes = nil
		end

		local v12 = existingHomepageClientAttributes or {}
		local promptShownCount = NotificationsUpsell.NotificationsUpsellConstants.LocalStorageKeys.PromptShownCount

		local sysPromptShownTimestamp = NotificationsUpsell.NotificationsUpsellConstants.LocalStorageKeys.SysPromptShownTimestamp
		local success, item = pcall(AppStorageService.GetItem, AppStorageService, promptShownCount)
		local v13, v14

		if success then
			v13 = tonumber(item) or 0
			v14 = true
		else
			v14 = false
			v13 = -1
		end

		local success2, item2 = pcall(AppStorageService.GetItem, AppStorageService, sysPromptShownTimestamp)
		local v15, v16

		if success2 then
			v15 = tonumber(item2) or 0
			v16 = true
		else
			v16 = false
			v15 = -1
		end

		local v17 = v9

		if v17 ~= nil and v17 ~= v5 then
			v5 = v17
			count += 1
		end

		local v18 = count

		local flag2 = false

		local function resolveWithNativeStatus(nativePushPermissionUpsellStatus)
			if flag2 then
				return
			end

			flag2 = true

			v12.nativePushPermissionUpsellStatus = nativePushPermissionUpsellStatus
			v12.launchContext = v11

			if v9 ~= nil then
				v12.homePageSessionTimestamp = tostring(v9)
				v12.homePageSessionOrdinal = tostring(v18)
			end

			v12.legacyPushHistoryReadStatus = v14 and v16 and "SUCCESS" or "ERROR"

			v12.legacyPushPromptShownCount = tostring(v13)
			v12.legacyPushSystemPromptShownTimestamp = tostring(v15)

			if flag then
				setState({
					attributes = v12,
					homePageSessionTimestamp = v9,
					launchContext = v11,
					userId = v10
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
	end, { v6, v9, v8, v10 })
	local attributes

	if not (state == nil or state.homePageSessionTimestamp ~= v9 or state.launchContext ~= (v8 or "Unknown") or state.userId ~= v10) then
		attributes = state.attributes
	end

	if v6 then
		return attributes
	end

	return nil
end

return {
	get = getHomepagePromptsClientAttributes,
	use = useHomepagePromptsClientAttributes,
	sessionClientAttribute = "homePageSessionOrdinal"
}
