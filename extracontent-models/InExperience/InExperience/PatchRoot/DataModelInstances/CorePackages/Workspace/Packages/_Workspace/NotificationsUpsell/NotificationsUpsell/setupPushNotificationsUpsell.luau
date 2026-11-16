local LocalizationService = game:GetService("LocalizationService")
local AppStorageService = game:GetService("AppStorageService")

local parent = script.Parent.Parent
local NotificationModalsManager = require(parent.NotificationModalsManager)
local PermissionsProtocol = require(parent.PermissionsProtocol)
local default = PermissionsProtocol.PermissionsProtocol.default
local LoggingProtocol = require(parent.LoggingProtocol)
local default2 = LoggingProtocol.default
local RobloxAppLocales = require(parent.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization
local NotificationsCommon = require(parent.NotificationsCommon)
local sendEventDeferred = NotificationsCommon.sendEventDeferred

local PushNotificationsUpsellModal = require(script.Parent.Components.PushNotificationsUpsellModal)
local NotificationsUpsellConstants = require(script.Parent.NotificationsUpsellConstants)
local ModalEventConstants = require(script.Parent.Analytics.ModalEventConstants)
local PushUpsellEventName = require(script.Parent.Analytics.RobloxTelemetryConfigs.PushUpsellEventName)

local PushNotificationsUpsellUtils = require(script.Parent.Util.PushNotificationsUpsellUtils)
local Promise = require(parent.Promise)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies

local FIntPushUpsellCooldownPeriod = require(script.Parent.Flags.FIntPushUpsellCooldownPeriod)
local FIntPushUpsellMaxPromptCount = require(script.Parent.Flags.FIntPushUpsellMaxPromptCount)
local FIntPushUpsellChatCooldownPeriod = require(script.Parent.Flags.FIntPushUpsellChatCooldownPeriod)
local FIntPushUpsellChatMaxPromptCount = require(script.Parent.Flags.FIntPushUpsellChatMaxPromptCount)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnablePushNotificationsUpsellModal = SharedFlags.GetFFlagEnablePushNotificationsUpsellModal

local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagLuaAppPushUpsellDeprecateOldEvents = SharedFlags2.GetFFlagLuaAppPushUpsellDeprecateOldEvents

local SharedFlags3 = require(parent.SharedFlags)
local FFlagNotificationsUpsellUseRequestPushPermissionHelper = SharedFlags3.FFlagNotificationsUpsellUseRequestPushPermissionHelper
local requestPushNotificationPermission

if FFlagNotificationsUpsellUseRequestPushPermissionHelper then
	requestPushNotificationPermission = require(script.Parent.requestPushNotificationPermission)
else
	requestPushNotificationPermission = nil
end

local SharedFlags4 = require(parent.SharedFlags)
local FFlagPushNotificationsUpsellPassClientAttributesToPrompts = SharedFlags4.FFlagPushNotificationsUpsellPassClientAttributesToPrompts
local defineFastFlag = game:DefineFastFlag("CacheShouldShowPushUpsellHideResponse", false)

local defineFastInt = game:DefineFastInt("ShouldShowPushUpsellHideResponseCacheExpirationTime", 6)

local v = false
local lastTime = 0
local v2 = nil

local function getPushNotificationPermissionUpsellStatus()
	if v2 ~= nil then
		return v2
	end

	local v3 = default:shouldShowUpsell({ default.Permissions.POST_NOTIFICATIONS }):andThen(function(p)
		return p.upsellStatus or "UNKNOWN"
	end, function(): string
		return "ERROR"
	end)

	v2 = v3
	v3:finally(function()
		if v2 == v3 then
			v2 = nil
		end
	end)

	return v3
end

local function shouldShowUpsellHome(flag: boolean?)
	if defineFastFlag and (os.time() - lastTime) / 3600 < defineFastInt and v then
		return Promise.resolve(false)
	end

	local pushUpsellPromptedCount = PushNotificationsUpsellUtils.getPushUpsellPromptedCount(
		AppStorageService,
		NotificationsUpsellConstants.LocalStorageKeys.PromptShownCount
	)
	local v3

	if flag then
		v3 = PushNotificationsUpsellUtils.getPushEduUpsellResponseTimestamp(AppStorageService)
	else
		v3 = PushNotificationsUpsellUtils.getPushSysUpsellPromptTimestamp(AppStorageService)
	end

	local v4

	if pushUpsellPromptedCount >= 0 and v3 >= 0 then
		local v5 = (os.time() - v3) / 86400

		if pushUpsellPromptedCount < FIntPushUpsellMaxPromptCount then
			v4 = FIntPushUpsellCooldownPeriod <= v5 or v3 == 0
		else
			v4 = false
		end
	else
		v4 = false
	end

	if not v4 then
		return Promise.resolve(false)
	end

	if FFlagPushNotificationsUpsellPassClientAttributesToPrompts then
		return getPushNotificationPermissionUpsellStatus():andThen(function(p)
			return Promise.resolve(p == default.UpsellStatus.SHOW)
		end)
	end

	return default:shouldShowUpsell({ default.Permissions.POST_NOTIFICATIONS }):andThen(function(p)
		if p.upsellStatus and p.upsellStatus == default.UpsellStatus.SHOW then
			return Promise.resolve(true)
		end

		if defineFastFlag then
			v = true
			lastTime = os.time()
		end

		return Promise.resolve(false)
	end, function(_)
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

local function userHasRespondedToUpsellPromptLessThanCooldownPeriod(): boolean -- 1 equivalent call inferred from this helper
	local pushSysUpsellPromptTimestamp = PushNotificationsUpsellUtils.getPushSysUpsellPromptTimestamp(AppStorageService)

	return pushSysUpsellPromptTimestamp >= 0
		and (os.time() - pushSysUpsellPromptTimestamp) / 86400 < FIntPushUpsellChatCooldownPeriod
end

local function shouldShowRationale()
	return default:shouldShowRationale({ default.Permissions.POST_NOTIFICATIONS }):andThen(function(p)
		return Promise.resolve(p.upsellStatus == default.UpsellStatus.SHOW)
	end):catch(function(_)
		return Promise.resolve(false)
	end)
end

local function shouldShowUpsellChat(_: boolean?)
	local pushUpsellPromptedCount = PushNotificationsUpsellUtils.getPushUpsellPromptedCount(
		AppStorageService,
		NotificationsUpsellConstants.LocalStorageKeys.ChatPromptShownCount
	)

	if
		not (pushUpsellPromptedCount < 0 or FIntPushUpsellChatMaxPromptCount <= pushUpsellPromptedCount)
		and not userHasRespondedToUpsellPromptLessThanCooldownPeriod() -- inferred equivalent call
	then
		return shouldShowRationale():andThen(function(p)
			if p then
				return (Promise.resolve(true))
			end

			return (Promise.resolve(false))
		end):catch(function(_)
			return Promise.resolve(false)
		end)
	end

	return Promise.resolve(false)
end

local function shouldShowUpsell(p: string, flag: boolean?)
	if not GetFFlagEnablePushNotificationsUpsellModal() then
		return Promise.resolve(false)
	end

	local appFeaturePolicies = getAppFeaturePolicies()

	if not (appFeaturePolicies.getNotificationsCanReceivePush() and appFeaturePolicies.getPushNotificationsUpsell()) then
		return Promise.resolve(false)
	end

	if p == NotificationsUpsellConstants.ModalKey.PushUpsellHome then
		return shouldShowUpsellHome(flag)
	end

	if p == NotificationsUpsellConstants.ModalKey.PushUpsellChat then
		return shouldShowUpsellChat(flag)
	end
end

local function openModal(p: string, flag: boolean?, value: string?)
	if not GetFFlagEnablePushNotificationsUpsellModal() then
		return
	end

	if flag then
		local function fn()
			if not GetFFlagLuaAppPushUpsellDeprecateOldEvents() then
				sendEventDeferred(
					ModalEventConstants.ModalContextPushEduUpsell,
					ModalEventConstants.OptInPushEventName,
					{ [ModalEventConstants.ActionType] = ModalEventConstants.Closed }
				)
			end

			default2:logRobloxTelemetryEvent(
				PushUpsellEventName,
				{},
				{ [ModalEventConstants.ActionType] = ModalEventConstants.Closed },
				ModalEventConstants.ModalContextPushEduUpsell
			)
		end
		local function fn2()
			NotificationModalsManager.CloseModal(p)
		end

		if not GetFFlagLuaAppPushUpsellDeprecateOldEvents() then
			sendEventDeferred(ModalEventConstants.ModalContextPushEduUpsell, ModalEventConstants.OptInPushEventName, {
				[ModalEventConstants.ActionType] = ModalEventConstants.Opened
			})
		end

		default2:logRobloxTelemetryEvent(PushUpsellEventName, {}, {
			[ModalEventConstants.ActionType] = ModalEventConstants.Opened,
			[ModalEventConstants.EntryPoint] = value or ""
		}, ModalEventConstants.ModalContextPushEduUpsell)

		if p == NotificationsUpsellConstants.ModalKey.PushUpsellHome then
			PushNotificationsUpsellUtils.incrementPushUpsellPromptedCount(
				AppStorageService,
				NotificationsUpsellConstants.LocalStorageKeys.PromptShownCount
			)
		elseif p == NotificationsUpsellConstants.ModalKey.PushUpsellChat then
			PushNotificationsUpsellUtils.incrementPushUpsellPromptedCount(
				AppStorageService,
				NotificationsUpsellConstants.LocalStorageKeys.ChatPromptShownCount
			)
		end

		NotificationModalsManager.OpenModal(p, PushNotificationsUpsellModal, {
			CloseCallback = fn,
			Props = {
				CloseModal = fn2,
				TranslationKeys = NotificationsUpsellConstants.TranslationKeys[p]
			},
			DisableBackgroundDismiss = true,
			DisplayOrder = 2,
			Localization = Localization.new(LocalizationService.RobloxLocaleId)
		})
	else
		if not GetFFlagLuaAppPushUpsellDeprecateOldEvents() then
			sendEventDeferred(ModalEventConstants.ModalContextSysUpsell, ModalEventConstants.OptInPushEventName, {
				[ModalEventConstants.ActionType] = ModalEventConstants.Opened
			})
		end

		default2:logRobloxTelemetryEvent(PushUpsellEventName, {}, {
			[ModalEventConstants.ActionType] = ModalEventConstants.Opened,
			[ModalEventConstants.EntryPoint] = value or ""
		}, ModalEventConstants.ModalContextSysUpsell)

		if FFlagNotificationsUpsellUseRequestPushPermissionHelper then
			requestPushNotificationPermission():andThen(function()
				if not GetFFlagLuaAppPushUpsellDeprecateOldEvents() then
					sendEventDeferred(
						ModalEventConstants.ModalContextSysUpsell,
						ModalEventConstants.OptInPushEventName,
						{ [ModalEventConstants.ActionType] = ModalEventConstants.RequestSuccess }
					)
				end

				default2:logRobloxTelemetryEvent(
					PushUpsellEventName,
					{},
					{ [ModalEventConstants.ActionType] = ModalEventConstants.RequestSuccess },
					ModalEventConstants.ModalContextSysUpsell
				)
			end, function()
				if not GetFFlagLuaAppPushUpsellDeprecateOldEvents() then
					sendEventDeferred(
						ModalEventConstants.ModalContextSysUpsell,
						ModalEventConstants.OptInPushEventName,
						{ [ModalEventConstants.ActionType] = ModalEventConstants.RequestFailed }
					)
				end

				default2:logRobloxTelemetryEvent(
					PushUpsellEventName,
					{},
					{ [ModalEventConstants.ActionType] = ModalEventConstants.RequestFailed },
					ModalEventConstants.ModalContextSysUpsell
				)
			end)
		else
			default:requestPermissions({ default.Permissions.POST_NOTIFICATIONS }):andThen(function(_)
				PushNotificationsUpsellUtils.setPushSysUpsellPromptTimestamp(AppStorageService, os.time())
				PushNotificationsUpsellUtils.incrementPushUpsellPromptedCount(
					AppStorageService,
					NotificationsUpsellConstants.LocalStorageKeys.PromptShownCount
				)

				if not GetFFlagLuaAppPushUpsellDeprecateOldEvents() then
					sendEventDeferred(
						ModalEventConstants.ModalContextSysUpsell,
						ModalEventConstants.OptInPushEventName,
						{ [ModalEventConstants.ActionType] = ModalEventConstants.RequestSuccess }
					)
				end

				default2:logRobloxTelemetryEvent(
					PushUpsellEventName,
					{},
					{ [ModalEventConstants.ActionType] = ModalEventConstants.RequestSuccess },
					ModalEventConstants.ModalContextSysUpsell
				)
			end, function(_)
				if not GetFFlagLuaAppPushUpsellDeprecateOldEvents() then
					sendEventDeferred(
						ModalEventConstants.ModalContextSysUpsell,
						ModalEventConstants.OptInPushEventName,
						{ [ModalEventConstants.ActionType] = ModalEventConstants.RequestFailed }
					)
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

local function closeModal(p: string)
	NotificationModalsManager.CloseModal(p)
end

local getPushNotificationPermissionUpsellStatus2

if FFlagPushNotificationsUpsellPassClientAttributesToPrompts then
	getPushNotificationPermissionUpsellStatus2 = getPushNotificationPermissionUpsellStatus
end

return {
	OpenModal = openModal,
	CloseModal = closeModal,
	ShouldShowUpsell = shouldShowUpsell,
	GetPushNotificationPermissionUpsellStatus = getPushNotificationPermissionUpsellStatus2
}
