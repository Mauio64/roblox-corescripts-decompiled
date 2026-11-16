local LocalizationService = game:GetService("LocalizationService")
local AppStorageService = game:GetService("AppStorageService")

local NotificationModalsManager = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationModalsManager")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/PermissionsProtocol").PermissionsProtocol.default
local default2 = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/LoggingProtocol").default
local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/RobloxAppLocales").Localization
local sendEventDeferred = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsCommon").sendEventDeferred

local PushNotificationsUpsellModal = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Components/PushNotificationsUpsellModal")
local NotificationsUpsellConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/NotificationsUpsellConstants")
local ModalEventConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Analytics/ModalEventConstants")
local PushUpsellEventName = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Analytics/RobloxTelemetryConfigs/PushUpsellEventName")

local PushNotificationsUpsellUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Util/PushNotificationsUpsellUtils")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/Promise")
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/UniversalAppPolicy").getAppFeaturePolicies

local FIntPushUpsellCooldownPeriod = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Flags/FIntPushUpsellCooldownPeriod")
local FIntPushUpsellMaxPromptCount = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Flags/FIntPushUpsellMaxPromptCount")
local FIntPushUpsellChatCooldownPeriod = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Flags/FIntPushUpsellChatCooldownPeriod")
local FIntPushUpsellChatMaxPromptCount = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Flags/FIntPushUpsellChatMaxPromptCount")

local getFFlagEnablePushNotificationsUpsellModal = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/SharedFlags").GetFFlagEnablePushNotificationsUpsellModal

local getFFlagLuaAppPushUpsellDeprecateOldEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/SharedFlags").GetFFlagLuaAppPushUpsellDeprecateOldEvents

local fFlagNotificationsUpsellUseRequestPushPermissionHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/SharedFlags").FFlagNotificationsUpsellUseRequestPushPermissionHelper
local v5

if fFlagNotificationsUpsellUseRequestPushPermissionHelper then
	v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/requestPushNotificationPermission")
else
	v5 = nil
end

local fFlagPushNotificationsUpsellPassClientAttributesToPrompts = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/SharedFlags").FFlagPushNotificationsUpsellPassClientAttributesToPrompts
local defineFastFlag = game:DefineFastFlag("CacheShouldShowPushUpsellHideResponse", false)

local defineFastInt = game:DefineFastInt("ShouldShowPushUpsellHideResponseCacheExpirationTime", 6)

local v6 = false
local lastTime = 0
local v7 = nil

local function getPushNotificationPermissionUpsellStatus()
	if v7 ~= nil then
		return v7
	end

	local v8 = default:shouldShowUpsell({ default.Permissions.POST_NOTIFICATIONS }):andThen(function(p2)
		return p2.upsellStatus or "UNKNOWN"
	end, function(): string
		return "ERROR"
	end)

	v7 = v8
	v8:finally(function()
		if v7 == v8 then
			v7 = nil
		end
	end)

	return v8
end

local function shouldShowUpsellHome(p2)
	if defineFastFlag and (os.time() - lastTime) / 3600 < defineFastInt and v6 then
		return Promise.resolve(false)
	end

	local pushUpsellPromptedCount = PushNotificationsUpsellUtils.getPushUpsellPromptedCount(
		AppStorageService,
		NotificationsUpsellConstants.LocalStorageKeys.PromptShownCount
	)
	local v8

	if p2 then
		v8 = PushNotificationsUpsellUtils.getPushEduUpsellResponseTimestamp(AppStorageService)
	else
		v8 = PushNotificationsUpsellUtils.getPushSysUpsellPromptTimestamp(AppStorageService)
	end

	local v9

	if pushUpsellPromptedCount >= 0 and v8 >= 0 then
		local v10 = (os.time() - v8) / 86400
		v9 = pushUpsellPromptedCount < FIntPushUpsellMaxPromptCount and (FIntPushUpsellCooldownPeriod <= v10 or v8 == 0)
	else
		v9 = false
	end

	if not v9 then
		return Promise.resolve(false)
	end

	if fFlagPushNotificationsUpsellPassClientAttributesToPrompts then
		return getPushNotificationPermissionUpsellStatus():andThen(function(p3)
			return Promise.resolve(p3 == default.UpsellStatus.SHOW)
		end)
	end

	return default:shouldShowUpsell({ default.Permissions.POST_NOTIFICATIONS }):andThen(function(p3)
		if p3.upsellStatus and p3.upsellStatus == default.UpsellStatus.SHOW then
			return Promise.resolve(true)
		end

		if defineFastFlag then
			v6 = true
			lastTime = os.time()
		end

		return Promise.resolve(false)
	end, function(p3)
		return Promise.resolve(false)
	end)
end

local function userHasRespondedToPushUpsellChat(): boolean
	local pushUpsellPromptedCount = PushNotificationsUpsellUtils.getPushUpsellPromptedCount(
		AppStorageService,
		NotificationsUpsellConstants.LocalStorageKeys.ChatPromptShownCount
	)

	return pushUpsellPromptedCount < 0 or FIntPushUpsellChatMaxPromptCount <= pushUpsellPromptedCount
end

local function userHasRespondedToUpsellPromptLessThanCooldownPeriod(): boolean
	local pushSysUpsellPromptTimestamp = PushNotificationsUpsellUtils.getPushSysUpsellPromptTimestamp(AppStorageService)

	return pushSysUpsellPromptTimestamp >= 0
		and (os.time() - pushSysUpsellPromptTimestamp) / 86400 < FIntPushUpsellChatCooldownPeriod
end

local function shouldShowRationale()
	return default:shouldShowRationale({ default.Permissions.POST_NOTIFICATIONS }):andThen(function(p2)
		return Promise.resolve(p2.upsellStatus == default.UpsellStatus.SHOW)
	end):catch(function(p2)
		return Promise.resolve(false)
	end)
end

local function shouldShowUpsellChat(p2)
	local pushUpsellPromptedCount = PushNotificationsUpsellUtils.getPushUpsellPromptedCount(
		AppStorageService,
		NotificationsUpsellConstants.LocalStorageKeys.ChatPromptShownCount
	)

	if not (pushUpsellPromptedCount < 0 or FIntPushUpsellChatMaxPromptCount <= pushUpsellPromptedCount) then
		local pushSysUpsellPromptTimestamp = PushNotificationsUpsellUtils.getPushSysUpsellPromptTimestamp(AppStorageService)
		local v8

		if pushSysUpsellPromptTimestamp >= 0 then
			v8 = (os.time() - pushSysUpsellPromptTimestamp) / 86400 < FIntPushUpsellChatCooldownPeriod
		else
			v8 = false
		end

		if not v8 then
			return shouldShowRationale():andThen(function(p3)
				if p3 then
					return (Promise.resolve(true))
				end

				return (Promise.resolve(false))
			end):catch(function(p3)
				return Promise.resolve(false)
			end)
		end
	end

	return Promise.resolve(false)
end

local function shouldShowUpsell(p2, p3)
	if not getFFlagEnablePushNotificationsUpsellModal() then
		return Promise.resolve(false)
	end

	local appFeaturePolicies = getAppFeaturePolicies()

	if not (appFeaturePolicies.getNotificationsCanReceivePush() and appFeaturePolicies.getPushNotificationsUpsell()) then
		return Promise.resolve(false)
	end

	if p2 == NotificationsUpsellConstants.ModalKey.PushUpsellHome then
		return shouldShowUpsellHome(p3)
	end

	if p2 == NotificationsUpsellConstants.ModalKey.PushUpsellChat then
		return shouldShowUpsellChat(p3)
	end
end

local function openModal(p2, p3, value)
	if not getFFlagEnablePushNotificationsUpsellModal() then
		return
	end

	if p3 then
		local function fn()
			if not getFFlagLuaAppPushUpsellDeprecateOldEvents() then
				sendEventDeferred(ModalEventConstants.ModalContextPushEduUpsell, ModalEventConstants.OptInPushEventName, {
					[ModalEventConstants.ActionType] = ModalEventConstants.Closed
				})
			end

			default2:logRobloxTelemetryEvent(
				PushUpsellEventName,
				{},
				{ [ModalEventConstants.ActionType] = ModalEventConstants.Closed },
				ModalEventConstants.ModalContextPushEduUpsell
			)
		end
		local function fn2()
			NotificationModalsManager.CloseModal(p2)
		end

		if not getFFlagLuaAppPushUpsellDeprecateOldEvents() then
			sendEventDeferred(ModalEventConstants.ModalContextPushEduUpsell, ModalEventConstants.OptInPushEventName, {
				[ModalEventConstants.ActionType] = ModalEventConstants.Opened
			})
		end

		default2:logRobloxTelemetryEvent(PushUpsellEventName, {}, {
			[ModalEventConstants.ActionType] = ModalEventConstants.Opened,
			[ModalEventConstants.EntryPoint] = value or ""
		}, ModalEventConstants.ModalContextPushEduUpsell)

		if p2 == NotificationsUpsellConstants.ModalKey.PushUpsellHome then
			PushNotificationsUpsellUtils.incrementPushUpsellPromptedCount(
				AppStorageService,
				NotificationsUpsellConstants.LocalStorageKeys.PromptShownCount
			)
		elseif p2 == NotificationsUpsellConstants.ModalKey.PushUpsellChat then
			PushNotificationsUpsellUtils.incrementPushUpsellPromptedCount(
				AppStorageService,
				NotificationsUpsellConstants.LocalStorageKeys.ChatPromptShownCount
			)
		end

		NotificationModalsManager.OpenModal(p2, PushNotificationsUpsellModal, {
			CloseCallback = fn,
			Props = { CloseModal = fn2, TranslationKeys = NotificationsUpsellConstants.TranslationKeys[p2] },
			DisableBackgroundDismiss = true,
			DisplayOrder = 2,
			Localization = localization.new(LocalizationService.RobloxLocaleId)
		})
	else
		if not getFFlagLuaAppPushUpsellDeprecateOldEvents() then
			sendEventDeferred(ModalEventConstants.ModalContextSysUpsell, ModalEventConstants.OptInPushEventName, {
				[ModalEventConstants.ActionType] = ModalEventConstants.Opened
			})
		end

		default2:logRobloxTelemetryEvent(PushUpsellEventName, {}, {
			[ModalEventConstants.ActionType] = ModalEventConstants.Opened,
			[ModalEventConstants.EntryPoint] = value or ""
		}, ModalEventConstants.ModalContextSysUpsell)

		if fFlagNotificationsUpsellUseRequestPushPermissionHelper then
			v5():andThen(function()
				if not getFFlagLuaAppPushUpsellDeprecateOldEvents() then
					sendEventDeferred(ModalEventConstants.ModalContextSysUpsell, ModalEventConstants.OptInPushEventName, {
						[ModalEventConstants.ActionType] = ModalEventConstants.RequestSuccess
					})
				end

				default2:logRobloxTelemetryEvent(
					PushUpsellEventName,
					{},
					{ [ModalEventConstants.ActionType] = ModalEventConstants.RequestSuccess },
					ModalEventConstants.ModalContextSysUpsell
				)
			end, function()
				if not getFFlagLuaAppPushUpsellDeprecateOldEvents() then
					sendEventDeferred(ModalEventConstants.ModalContextSysUpsell, ModalEventConstants.OptInPushEventName, {
						[ModalEventConstants.ActionType] = ModalEventConstants.RequestFailed
					})
				end

				default2:logRobloxTelemetryEvent(
					PushUpsellEventName,
					{},
					{ [ModalEventConstants.ActionType] = ModalEventConstants.RequestFailed },
					ModalEventConstants.ModalContextSysUpsell
				)
			end)
		else
			default:requestPermissions({ default.Permissions.POST_NOTIFICATIONS }):andThen(function(p4)
				PushNotificationsUpsellUtils.setPushSysUpsellPromptTimestamp(AppStorageService, os.time())
				PushNotificationsUpsellUtils.incrementPushUpsellPromptedCount(
					AppStorageService,
					NotificationsUpsellConstants.LocalStorageKeys.PromptShownCount
				)

				if not getFFlagLuaAppPushUpsellDeprecateOldEvents() then
					sendEventDeferred(ModalEventConstants.ModalContextSysUpsell, ModalEventConstants.OptInPushEventName, {
						[ModalEventConstants.ActionType] = ModalEventConstants.RequestSuccess
					})
				end

				default2:logRobloxTelemetryEvent(
					PushUpsellEventName,
					{},
					{ [ModalEventConstants.ActionType] = ModalEventConstants.RequestSuccess },
					ModalEventConstants.ModalContextSysUpsell
				)
			end, function(p4)
				if not getFFlagLuaAppPushUpsellDeprecateOldEvents() then
					sendEventDeferred(ModalEventConstants.ModalContextSysUpsell, ModalEventConstants.OptInPushEventName, {
						[ModalEventConstants.ActionType] = ModalEventConstants.RequestFailed
					})
				end

				default2:logRobloxTelemetryEvent(
					PushUpsellEventName,
					{},
					{ [ModalEventConstants.ActionType] = ModalEventConstants.RequestFailed },
					ModalEventConstants.ModalContextSysUpsell
				)
			end)
		end
	end
end

local function closeModal(p2)
	NotificationModalsManager.CloseModal(p2)
end

return {
	OpenModal = openModal,
	CloseModal = closeModal,
	ShouldShowUpsell = shouldShowUpsell,
	GetPushNotificationPermissionUpsellStatus = if fFlagPushNotificationsUpsellPassClientAttributesToPrompts then getPushNotificationPermissionUpsellStatus else nil
}
