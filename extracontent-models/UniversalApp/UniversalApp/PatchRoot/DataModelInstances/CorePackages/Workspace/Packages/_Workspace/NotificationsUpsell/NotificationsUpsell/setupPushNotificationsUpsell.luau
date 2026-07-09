local LocalizationService = game:GetService("LocalizationService")
local AppStorageService = game:GetService("AppStorageService")
local ParentParent = script.Parent.Parent
local NotificationModalsManager = require(ParentParent.NotificationModalsManager)
local default = require(ParentParent.PermissionsProtocol).PermissionsProtocol.default
local default2 = require(ParentParent.LoggingProtocol).default
local Localization = require(ParentParent.RobloxAppLocales).Localization
local sendEventDeferred = require(ParentParent.NotificationsCommon).sendEventDeferred
local PushNotificationsUpsellModal = require(script.Parent.Components.PushNotificationsUpsellModal)
local NotificationsUpsellConstants = require(script.Parent.NotificationsUpsellConstants)
local ModalEventConstants = require(script.Parent.Analytics.ModalEventConstants)
local PushUpsellEventName = require(script.Parent.Analytics.RobloxTelemetryConfigs.PushUpsellEventName)
local PushNotificationsUpsellUtils = require(script.Parent.Util.PushNotificationsUpsellUtils)
local Promise = require(ParentParent.Promise)
local getAppFeaturePolicies = require(ParentParent.UniversalAppPolicy).getAppFeaturePolicies
local FIntPushUpsellCooldownPeriod = require(script.Parent.Flags.FIntPushUpsellCooldownPeriod)
local FIntPushUpsellMaxPromptCount = require(script.Parent.Flags.FIntPushUpsellMaxPromptCount)
local FIntPushUpsellChatCooldownPeriod = require(script.Parent.Flags.FIntPushUpsellChatCooldownPeriod)
local FIntPushUpsellChatMaxPromptCount = require(script.Parent.Flags.FIntPushUpsellChatMaxPromptCount)
local GetFFlagEnablePushNotificationsUpsellModal = require(ParentParent.SharedFlags).GetFFlagEnablePushNotificationsUpsellModal
local GetFFlagLuaAppPushUpsellDeprecateOldEvents = require(ParentParent.SharedFlags).GetFFlagLuaAppPushUpsellDeprecateOldEvents
local v22 = game:DefineFastFlag("CacheShouldShowPushUpsellHideResponse", false)
local v23 = game:DefineFastInt("ShouldShowPushUpsellHideResponseCacheExpirationTime", 6)
local u24 = false
local n1 = 0

local function shouldShowUpsellHome(b1: boolean?) -- line: 40
	-- upvalues: v22 (copy), n1 (ref), v23 (copy), u24 (ref), Promise (copy), PushNotificationsUpsellUtils (copy), AppStorageService (copy), NotificationsUpsellConstants (copy), FIntPushUpsellMaxPromptCount (copy), FIntPushUpsellCooldownPeriod (copy), default (copy)
	if v22 and ((os.time() - n1) / 3600 < v23 and u24) then
		return Promise.resolve(false)
	end

	local v35 = PushNotificationsUpsellUtils.getPushUpsellPromptedCount(AppStorageService, NotificationsUpsellConstants.LocalStorageKeys.PromptShownCount)
	local v36 = if not b1 then PushNotificationsUpsellUtils.getPushSysUpsellPromptTimestamp(AppStorageService) else PushNotificationsUpsellUtils.getPushEduUpsellResponseTimestamp(AppStorageService)
	local v37 = false

	if v35 >= 0 and v36 >= 0 then
		local v38 = (os.time() - v36) / 86400

		v37 = v35 < FIntPushUpsellMaxPromptCount and (v38 >= FIntPushUpsellCooldownPeriod or v36 == 0)
	end

	if v37 then
		return default:shouldShowUpsell({ default.Permissions.POST_NOTIFICATIONS }):andThen(function(p1) -- line: 70
			-- upvalues: default (copy), Promise (copy), v22 (copy), u24 (ref), n1 (ref)
			if p1.upsellStatus and p1.upsellStatus == default.UpsellStatus.SHOW then
				return Promise.resolve(true)
			end

			if v22 then
				u24 = true
				n1 = os.time()
			end

			return Promise.resolve(false)
		end, function(_) -- line: 82
			-- upvalues: Promise (copy)
			return Promise.resolve(false)
		end)
	end

	return Promise.resolve(false)
end
local function userHasRespondedToPushUpsellChat() -- line: 95
	-- upvalues: PushNotificationsUpsellUtils (copy), AppStorageService (copy), NotificationsUpsellConstants (copy), FIntPushUpsellChatMaxPromptCount (copy)
	local v39 = PushNotificationsUpsellUtils.getPushUpsellPromptedCount(AppStorageService, NotificationsUpsellConstants.LocalStorageKeys.ChatPromptShownCount)

	return v39 < 0 or v39 >= FIntPushUpsellChatMaxPromptCount
end
local function userHasRespondedToUpsellPromptLessThanCooldownPeriod() -- line: 103
	-- upvalues: PushNotificationsUpsellUtils (copy), AppStorageService (copy), FIntPushUpsellChatCooldownPeriod (copy)
	local v40 = PushNotificationsUpsellUtils.getPushSysUpsellPromptTimestamp(AppStorageService)

	return v40 >= 0 and (os.time() - v40) / 86400 < FIntPushUpsellChatCooldownPeriod
end
local function shouldShowRationale() -- line: 109
	-- upvalues: default (copy), Promise (copy)
	return default:shouldShowRationale({ default.Permissions.POST_NOTIFICATIONS }):andThen(function(p3) -- line: 113
		-- upvalues: Promise (copy), default (copy)
		return Promise.resolve(p3.upsellStatus == default.UpsellStatus.SHOW)
	end):catch(function(_) -- line: 116
		-- upvalues: Promise (copy)
		return Promise.resolve(false)
	end)
end
local function shouldShowUpsellChat(_: boolean?) -- line: 121
	-- upvalues: PushNotificationsUpsellUtils (copy), AppStorageService (copy), NotificationsUpsellConstants (copy), FIntPushUpsellChatMaxPromptCount (copy), FIntPushUpsellChatCooldownPeriod (copy), Promise (copy), shouldShowRationale (copy)
	local v42 = PushNotificationsUpsellUtils.getPushUpsellPromptedCount(AppStorageService, NotificationsUpsellConstants.LocalStorageKeys.ChatPromptShownCount)

	if not (v42 < 0) and not (v42 >= FIntPushUpsellChatMaxPromptCount) then
		local v43 = PushNotificationsUpsellUtils.getPushSysUpsellPromptTimestamp(AppStorageService)

		if not (v43 >= 0 and (os.time() - v43) / 86400 < FIntPushUpsellChatCooldownPeriod) then
			return shouldShowRationale():andThen(function(p5) -- line: 127
				-- upvalues: Promise (copy)
				if p5 then
					return (Promise.resolve(true))
				end

				return (Promise.resolve(false))
			end):catch(function(_) -- line: 130
				-- upvalues: Promise (copy)
				return Promise.resolve(false)
			end)
		end
	end

	return Promise.resolve(false)
end
local function shouldShowUpsell(s1: string, b3: boolean?) -- line: 135
	-- upvalues: GetFFlagEnablePushNotificationsUpsellModal (copy), Promise (copy), getAppFeaturePolicies (copy), NotificationsUpsellConstants (copy), shouldShowUpsellHome (copy), shouldShowUpsellChat (copy)
	if not GetFFlagEnablePushNotificationsUpsellModal() then
		return Promise.resolve(false)
	end

	local v46 = getAppFeaturePolicies()

	if not v46.getNotificationsCanReceivePush() or not v46.getPushNotificationsUpsell() then
		return Promise.resolve(false)
	end

	if s1 == NotificationsUpsellConstants.ModalKey.PushUpsellHome then
		return shouldShowUpsellHome(b3)
	end

	if s1 == NotificationsUpsellConstants.ModalKey.PushUpsellChat then
		return shouldShowUpsellChat(b3)
	end
end
local function openModal(s2: string, b4: boolean?, s3: string?) -- line: 152
	-- upvalues: GetFFlagEnablePushNotificationsUpsellModal (copy), GetFFlagLuaAppPushUpsellDeprecateOldEvents (copy), sendEventDeferred (copy), ModalEventConstants (copy), default2 (copy), PushUpsellEventName (copy), NotificationModalsManager (copy), NotificationsUpsellConstants (copy), PushNotificationsUpsellUtils (copy), AppStorageService (copy), PushNotificationsUpsellModal (copy), Localization (copy), LocalizationService (copy), default (copy)
	if not GetFFlagEnablePushNotificationsUpsellModal() then
		return
	end

	if b4 then
		if not GetFFlagLuaAppPushUpsellDeprecateOldEvents() then
			sendEventDeferred(ModalEventConstants.ModalContextPushEduUpsell, ModalEventConstants.OptInPushEventName, {
				[ModalEventConstants.ActionType] = ModalEventConstants.Opened
			})
		end

		default2:logRobloxTelemetryEvent(PushUpsellEventName, {}, {
			[ModalEventConstants.ActionType] = ModalEventConstants.Opened,
			[ModalEventConstants.EntryPoint] = s3 or ""
		}, ModalEventConstants.ModalContextPushEduUpsell)

		if s2 == NotificationsUpsellConstants.ModalKey.PushUpsellHome then
			PushNotificationsUpsellUtils.incrementPushUpsellPromptedCount(AppStorageService, NotificationsUpsellConstants.LocalStorageKeys.PromptShownCount)
		elseif s2 == NotificationsUpsellConstants.ModalKey.PushUpsellChat then
			PushNotificationsUpsellUtils.incrementPushUpsellPromptedCount(AppStorageService, NotificationsUpsellConstants.LocalStorageKeys.ChatPromptShownCount)
		end

		NotificationModalsManager.OpenModal(s2, PushNotificationsUpsellModal, {
			DisableBackgroundDismiss = true,
			DisplayOrder = 2,
			CloseCallback = function() -- line: 158
				-- upvalues: GetFFlagLuaAppPushUpsellDeprecateOldEvents (copy), sendEventDeferred (copy), ModalEventConstants (copy), default2 (copy), PushUpsellEventName (copy)
				if not GetFFlagLuaAppPushUpsellDeprecateOldEvents() then
					sendEventDeferred(ModalEventConstants.ModalContextPushEduUpsell, ModalEventConstants.OptInPushEventName, {
						[ModalEventConstants.ActionType] = ModalEventConstants.Closed
					})
				end

				default2:logRobloxTelemetryEvent(PushUpsellEventName, {}, {
					[ModalEventConstants.ActionType] = ModalEventConstants.Closed
				}, ModalEventConstants.ModalContextPushEduUpsell)
			end,
			Props = {
				CloseModal = function() -- line: 175
					-- upvalues: NotificationModalsManager (copy), s2 (copy)
					NotificationModalsManager.CloseModal(s2)
				end,
				TranslationKeys = NotificationsUpsellConstants.TranslationKeys[s2]
			},
			Localization = Localization.new(LocalizationService.RobloxLocaleId)
		})

		return
	end

	if not GetFFlagLuaAppPushUpsellDeprecateOldEvents() then
		sendEventDeferred(ModalEventConstants.ModalContextSysUpsell, ModalEventConstants.OptInPushEventName, {
			[ModalEventConstants.ActionType] = ModalEventConstants.Opened
		})
	end

	default2:logRobloxTelemetryEvent(PushUpsellEventName, {}, {
		[ModalEventConstants.ActionType] = ModalEventConstants.Opened,
		[ModalEventConstants.EntryPoint] = s3 or ""
	}, ModalEventConstants.ModalContextSysUpsell)
	default:requestPermissions({ default.Permissions.POST_NOTIFICATIONS }):andThen(function(_) -- line: 227
		-- upvalues: PushNotificationsUpsellUtils (copy), AppStorageService (copy), NotificationsUpsellConstants (copy), GetFFlagLuaAppPushUpsellDeprecateOldEvents (copy), sendEventDeferred (copy), ModalEventConstants (copy), default2 (copy), PushUpsellEventName (copy)
		PushNotificationsUpsellUtils.setPushSysUpsellPromptTimestamp(AppStorageService, os.time())
		PushNotificationsUpsellUtils.incrementPushUpsellPromptedCount(AppStorageService, NotificationsUpsellConstants.LocalStorageKeys.PromptShownCount)

		if not GetFFlagLuaAppPushUpsellDeprecateOldEvents() then
			sendEventDeferred(ModalEventConstants.ModalContextSysUpsell, ModalEventConstants.OptInPushEventName, {
				[ModalEventConstants.ActionType] = ModalEventConstants.RequestSuccess
			})
		end

		default2:logRobloxTelemetryEvent(PushUpsellEventName, {}, {
			[ModalEventConstants.ActionType] = ModalEventConstants.RequestSuccess
		}, ModalEventConstants.ModalContextSysUpsell)
	end, function(_) -- line: 244
		-- upvalues: GetFFlagLuaAppPushUpsellDeprecateOldEvents (copy), sendEventDeferred (copy), ModalEventConstants (copy), default2 (copy), PushUpsellEventName (copy)
		if not GetFFlagLuaAppPushUpsellDeprecateOldEvents() then
			sendEventDeferred(ModalEventConstants.ModalContextSysUpsell, ModalEventConstants.OptInPushEventName, {
				[ModalEventConstants.ActionType] = ModalEventConstants.RequestFailed
			})
		end

		default2:logRobloxTelemetryEvent(PushUpsellEventName, {}, {
			[ModalEventConstants.ActionType] = ModalEventConstants.RequestFailed
		}, ModalEventConstants.ModalContextSysUpsell)
	end)
end
local function closeModal(s4: string) -- line: 260
	-- upvalues: NotificationModalsManager (copy)
	NotificationModalsManager.CloseModal(s4)
end

return {
	OpenModal = openModal,
	CloseModal = closeModal,
	ShouldShowUpsell = shouldShowUpsell
}
