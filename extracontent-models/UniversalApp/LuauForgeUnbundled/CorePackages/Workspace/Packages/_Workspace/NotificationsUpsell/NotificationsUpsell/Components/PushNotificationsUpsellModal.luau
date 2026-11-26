local AppStorageService = game:GetService("AppStorageService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/ReactRoblox")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/UIBlox")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/PermissionsProtocol").PermissionsProtocol.default
local default2 = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/LoggingProtocol").default

local useState = React.useState
local useCallback = React.useCallback
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/Localization").Hooks.useLocalization
local sendEventDeferred = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsCommon").sendEventDeferred
local ModalEventConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Analytics/ModalEventConstants")
local PushUpsellEventName = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Analytics/RobloxTelemetryConfigs/PushUpsellEventName")
local PushNotificationsUpsellUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Util/PushNotificationsUpsellUtils")
local mergeEventFields = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Util/mergeEventFields")

local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local getFFlagLuaAppPushUpsellDeprecateOldEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/SharedFlags").GetFFlagLuaAppPushUpsellDeprecateOldEvents

return function(props)
	local v5 = useLocalization(props.TranslationKeys)
	local v6 = useCallback(function()
		PushNotificationsUpsellUtils.setPushEduUpsellResponse(AppStorageService, "Deny")
		PushNotificationsUpsellUtils.setPushEduUpsellResponseTimestamp(AppStorageService, os.time())

		if not getFFlagLuaAppPushUpsellDeprecateOldEvents() then
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

	local v7 = useCallback(function()
		if not getFFlagLuaAppPushUpsellDeprecateOldEvents() then
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

		default:requestPermissions({ default.Permissions.POST_NOTIFICATIONS }):andThen(function(p2)
			PushNotificationsUpsellUtils.setPushSysUpsellPromptTimestamp(AppStorageService, os.time())

			if not getFFlagLuaAppPushUpsellDeprecateOldEvents() then
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
				mergeEventFields({ [ModalEventConstants.ActionType] = ModalEventConstants.RequestSuccess }, props.ExtraEventFields),
				ModalEventConstants.ModalContextSysUpsell
			)
		end, function(p2)
			if not getFFlagLuaAppPushUpsellDeprecateOldEvents() then
				sendEventDeferred(ModalEventConstants.ModalContextSysUpsell, ModalEventConstants.OptInPushEventName, {
					[ModalEventConstants.ActionType] = ModalEventConstants.RequestFailed
				})
			end

			default2:logRobloxTelemetryEvent(
				PushUpsellEventName,
				{},
				mergeEventFields({ [ModalEventConstants.ActionType] = ModalEventConstants.RequestFailed }, props.ExtraEventFields),
				ModalEventConstants.ModalContextSysUpsell
			)
		end)

		props.CloseModal()
	end, { props.CloseModal, props.ExtraEventFields, v5 })

	local state, setState = useState(Vector2.new(800, 600))
	local v8 = useCallback(function(p2)
		setState(p2.AbsoluteSize)
	end, { setState })

	return React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			[ReactRoblox.Change.AbsoluteSize] = v8
		},
		{
			ConfirmationPrompt = React.createElement(interactiveAlert, {
				screenSize = state,
				title = v5.Heading,
				bodyText = v5.Body,
				richText = true,
				buttonStackInfo = {
					buttons = {
						{
							props = { onActivated = v6, text = v5.CancelAction },
							isDefaultChild = true
						},
						{
							buttonType = buttonType.PrimarySystem,
							props = { onActivated = v7, text = v5.ConfirmAction },
							isDefaultChild = false
						}
					}
				}
			})
		}
	)
end
