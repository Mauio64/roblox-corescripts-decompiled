local AppStorageService = game:GetService("AppStorageService")
local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local ReactRoblox = require(ParentParent.ReactRoblox)
local UIBlox = require(ParentParent.UIBlox)
local default = require(ParentParent.PermissionsProtocol).PermissionsProtocol.default
local default2 = require(ParentParent.LoggingProtocol).default
local useState = React.useState
local useCallback = React.useCallback
local useLocalization = require(ParentParent.Localization).Hooks.useLocalization
local sendEventDeferred = require(ParentParent.NotificationsCommon).sendEventDeferred
local ModalEventConstants = require(script.Parent.Parent.Analytics.ModalEventConstants)
local PushUpsellEventName = require(script.Parent.Parent.Analytics.RobloxTelemetryConfigs.PushUpsellEventName)
local PushNotificationsUpsellUtils = require(script.Parent.Parent.Util.PushNotificationsUpsellUtils)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local GetFFlagLuaAppPushUpsellDeprecateOldEvents = require(ParentParent.SharedFlags).GetFFlagLuaAppPushUpsellDeprecateOldEvents

return function(p1) -- line: 27
	-- upvalues: useLocalization (copy), useCallback (copy), PushNotificationsUpsellUtils (copy), AppStorageService (copy), GetFFlagLuaAppPushUpsellDeprecateOldEvents (copy), sendEventDeferred (copy), ModalEventConstants (copy), default2 (copy), PushUpsellEventName (copy), default (copy), useState (copy), React (copy), ReactRoblox (copy), InteractiveAlert (copy), ButtonType (copy)
	local v19 = useLocalization(p1.TranslationKeys)
	local v20 = useCallback(function() -- line: 29
		-- upvalues: PushNotificationsUpsellUtils (copy), AppStorageService (copy), GetFFlagLuaAppPushUpsellDeprecateOldEvents (copy), sendEventDeferred (copy), ModalEventConstants (copy), default2 (copy), PushUpsellEventName (copy), p1 (copy)
		PushNotificationsUpsellUtils.setPushEduUpsellResponse(AppStorageService, "Deny")
		PushNotificationsUpsellUtils.setPushEduUpsellResponseTimestamp(AppStorageService, os.time())

		if not GetFFlagLuaAppPushUpsellDeprecateOldEvents() then
			sendEventDeferred(ModalEventConstants.ModalContextPushEduUpsell, ModalEventConstants.OptInPushEventName, {
				[ModalEventConstants.ActionType] = ModalEventConstants.Clicked,
				[ModalEventConstants.Button] = ModalEventConstants.Cancel
			})
		end

		default2:logRobloxTelemetryEvent(PushUpsellEventName, {}, {
			[ModalEventConstants.ActionType] = ModalEventConstants.Clicked,
			[ModalEventConstants.Button] = ModalEventConstants.Cancel
		}, ModalEventConstants.ModalContextPushEduUpsell)
		p1.CloseModal()
	end, { p1.CloseModal })
	local v21 = useCallback(function() -- line: 47
		-- upvalues: GetFFlagLuaAppPushUpsellDeprecateOldEvents (copy), sendEventDeferred (copy), ModalEventConstants (copy), default2 (copy), PushUpsellEventName (copy), PushNotificationsUpsellUtils (copy), AppStorageService (copy), default (copy), p1 (copy)
		if not GetFFlagLuaAppPushUpsellDeprecateOldEvents() then
			sendEventDeferred(ModalEventConstants.ModalContextPushEduUpsell, ModalEventConstants.OptInPushEventName, {
				[ModalEventConstants.ActionType] = ModalEventConstants.Clicked,
				[ModalEventConstants.Button] = ModalEventConstants.Confirm
			})
		end

		default2:logRobloxTelemetryEvent(PushUpsellEventName, {}, {
			[ModalEventConstants.ActionType] = ModalEventConstants.Clicked,
			[ModalEventConstants.Button] = ModalEventConstants.Confirm
		}, ModalEventConstants.ModalContextPushEduUpsell)
		PushNotificationsUpsellUtils.setPushEduUpsellResponse(AppStorageService, "Allow")
		PushNotificationsUpsellUtils.setPushEduUpsellResponseTimestamp(AppStorageService, os.time())
		default2:logRobloxTelemetryEvent(PushUpsellEventName, {}, {
			[ModalEventConstants.ActionType] = ModalEventConstants.Opened,
			[ModalEventConstants.EntryPoint] = "LuaPushUpsellModal"
		}, ModalEventConstants.ModalContextSysUpsell)
		default:requestPermissions({ default.Permissions.POST_NOTIFICATIONS }):andThen(function(_) -- line: 74
			-- upvalues: PushNotificationsUpsellUtils (copy), AppStorageService (copy), GetFFlagLuaAppPushUpsellDeprecateOldEvents (copy), sendEventDeferred (copy), ModalEventConstants (copy), default2 (copy), PushUpsellEventName (copy)
			PushNotificationsUpsellUtils.setPushSysUpsellPromptTimestamp(AppStorageService, os.time())

			if not GetFFlagLuaAppPushUpsellDeprecateOldEvents() then
				sendEventDeferred(ModalEventConstants.ModalContextSysUpsell, ModalEventConstants.OptInPushEventName, {
					[ModalEventConstants.ActionType] = ModalEventConstants.Opened
				})
				sendEventDeferred(ModalEventConstants.ModalContextSysUpsell, ModalEventConstants.OptInPushEventName, {
					[ModalEventConstants.ActionType] = ModalEventConstants.RequestSuccess
				})
			end

			default2:logRobloxTelemetryEvent(PushUpsellEventName, {}, {
				[ModalEventConstants.ActionType] = ModalEventConstants.RequestSuccess
			}, ModalEventConstants.ModalContextSysUpsell)
		end, function(_) -- line: 96
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
		p1.CloseModal()
	end, {
		p1.CloseModal,
		v19
	})
	local v22, v23 = useState(Vector2.new(800, 600))
	local v24 = useCallback(function(p4) -- line: 120
		-- upvalues: v23 (copy)
		v23(p4.AbsoluteSize)
	end, { v23 })

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		[ReactRoblox.Change.AbsoluteSize] = v24
	}, {
		ConfirmationPrompt = React.createElement(InteractiveAlert, {
			richText = true,
			screenSize = v22,
			title = v19.Heading,
			bodyText = v19.Body,
			buttonStackInfo = {
				buttons = {
					{
						isDefaultChild = true,
						props = {
							onActivated = v20,
							text = v19.CancelAction
						}
					},
					{
						isDefaultChild = false,
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = v21,
							text = v19.ConfirmAction
						}
					}
				}
			}
		})
	})
end
