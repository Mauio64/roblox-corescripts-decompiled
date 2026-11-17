local AppStorageService = game:GetService("AppStorageService")

local parent = script.Parent.Parent.Parent

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local UIBlox = require(parent.UIBlox)
local PermissionsProtocol = require(parent.PermissionsProtocol)
local default = PermissionsProtocol.PermissionsProtocol.default
local LoggingProtocol = require(parent.LoggingProtocol)
local default2 = LoggingProtocol.default

local useState = React.useState
local useCallback = React.useCallback
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local NotificationsCommon = require(parent.NotificationsCommon)
local sendEventDeferred = NotificationsCommon.sendEventDeferred
local ModalEventConstants = require(script.Parent.Parent.Analytics.ModalEventConstants)
local PushUpsellEventName = require(script.Parent.Parent.Analytics.RobloxTelemetryConfigs.PushUpsellEventName)
local PushNotificationsUpsellUtils = require(script.Parent.Parent.Util.PushNotificationsUpsellUtils)
local mergeEventFields = require(script.Parent.Parent.Util.mergeEventFields)

local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local SharedFlags = require(parent.SharedFlags)
local GetFFlagLuaAppPushUpsellDeprecateOldEvents = SharedFlags.GetFFlagLuaAppPushUpsellDeprecateOldEvents

return function(props)
	local v = useLocalization(props.TranslationKeys)
	local onActivated = useCallback(function()
		PushNotificationsUpsellUtils.setPushEduUpsellResponse(AppStorageService, "Deny")
		PushNotificationsUpsellUtils.setPushEduUpsellResponseTimestamp(AppStorageService, os.time())

		if not GetFFlagLuaAppPushUpsellDeprecateOldEvents() then
			sendEventDeferred(ModalEventConstants.ModalContextPushEduUpsell, ModalEventConstants.OptInPushEventName, {
				[ModalEventConstants.ActionType] = ModalEventConstants.Clicked,
				[ModalEventConstants.Button] = ModalEventConstants.Cancel
			})
		end

		default2:logRobloxTelemetryEvent(
			PushUpsellEventName,
			{},
			mergeEventFields(
				{
					[ModalEventConstants.ActionType] = ModalEventConstants.Clicked,
					[ModalEventConstants.Button] = ModalEventConstants.Cancel
				},
				props.ExtraEventFields
			),
			ModalEventConstants.ModalContextPushEduUpsell
		)

		props.CloseModal()
	end, { props.CloseModal, props.ExtraEventFields })

	local onActivated2 = useCallback(function()
		if not GetFFlagLuaAppPushUpsellDeprecateOldEvents() then
			sendEventDeferred(ModalEventConstants.ModalContextPushEduUpsell, ModalEventConstants.OptInPushEventName, {
				[ModalEventConstants.ActionType] = ModalEventConstants.Clicked,
				[ModalEventConstants.Button] = ModalEventConstants.Confirm
			})
		end

		default2:logRobloxTelemetryEvent(
			PushUpsellEventName,
			{},
			mergeEventFields(
				{
					[ModalEventConstants.ActionType] = ModalEventConstants.Clicked,
					[ModalEventConstants.Button] = ModalEventConstants.Confirm
				},
				props.ExtraEventFields
			),
			ModalEventConstants.ModalContextPushEduUpsell
		)

		PushNotificationsUpsellUtils.setPushEduUpsellResponse(AppStorageService, "Allow")
		PushNotificationsUpsellUtils.setPushEduUpsellResponseTimestamp(AppStorageService, os.time())

		default2:logRobloxTelemetryEvent(
			PushUpsellEventName,
			{},
			mergeEventFields(
				{
					[ModalEventConstants.ActionType] = ModalEventConstants.Opened,
					[ModalEventConstants.EntryPoint] = "LuaPushUpsellModal"
				},
				props.ExtraEventFields
			),
			ModalEventConstants.ModalContextSysUpsell
		)

		default:requestPermissions({ default.Permissions.POST_NOTIFICATIONS }):andThen(function(_)
			PushNotificationsUpsellUtils.setPushSysUpsellPromptTimestamp(AppStorageService, os.time())

			if not GetFFlagLuaAppPushUpsellDeprecateOldEvents() then
				sendEventDeferred(ModalEventConstants.ModalContextSysUpsell, ModalEventConstants.OptInPushEventName, {
					[ModalEventConstants.ActionType] = ModalEventConstants.Opened
				})

				sendEventDeferred(ModalEventConstants.ModalContextSysUpsell, ModalEventConstants.OptInPushEventName, {
					[ModalEventConstants.ActionType] = ModalEventConstants.RequestSuccess
				})
			end

			default2:logRobloxTelemetryEvent(
				PushUpsellEventName,
				{},
				mergeEventFields(
					{ [ModalEventConstants.ActionType] = ModalEventConstants.RequestSuccess },
					props.ExtraEventFields
				),
				ModalEventConstants.ModalContextSysUpsell
			)
		end, function(_)
			if not GetFFlagLuaAppPushUpsellDeprecateOldEvents() then
				sendEventDeferred(ModalEventConstants.ModalContextSysUpsell, ModalEventConstants.OptInPushEventName, {
					[ModalEventConstants.ActionType] = ModalEventConstants.RequestFailed
				})
			end

			default2:logRobloxTelemetryEvent(
				PushUpsellEventName,
				{},
				mergeEventFields(
					{ [ModalEventConstants.ActionType] = ModalEventConstants.RequestFailed },
					props.ExtraEventFields
				),
				ModalEventConstants.ModalContextSysUpsell
			)
		end)

		props.CloseModal()
	end, { props.CloseModal, props.ExtraEventFields, v })

	local state, setState = useState(Vector2.new(800, 600))
	local v2 = useCallback(function(p)
		setState(p.AbsoluteSize)
	end, { setState })

	return React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			[ReactRoblox.Change.AbsoluteSize] = v2
		},
		{
			ConfirmationPrompt = React.createElement(InteractiveAlert, {
				screenSize = state,
				title = v.Heading,
				bodyText = v.Body,
				richText = true,
				buttonStackInfo = {
					buttons = {
						{
							props = { onActivated = onActivated, text = v.CancelAction },
							isDefaultChild = true
						},
						{
							buttonType = ButtonType.PrimarySystem,
							props = { onActivated = onActivated2, text = v.ConfirmAction },
							isDefaultChild = false
						}
					}
				}
			})
		}
	)
end
