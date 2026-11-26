local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local Players = game:GetService("Players")

local fFlagLuaAppDefaultHttpRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/SharedFlags").FFlagLuaAppDefaultHttpRetry
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/ReactRoblox")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/UIBlox")
local images = UIBlox.App.ImageSet.Images

local NotificationModalsManager = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationModalsManager")

local useState = React.useState
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/Localization").Hooks.useLocalization

local defineFastFlag = game:DefineFastFlag("EnableConsoleAutoFocusForUEN1", false)

local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/HttpRequest")
local config = HttpRequest.config
local v5 = { requestFunction = HttpRequest.requestFunctions.HttpRbxApi, maxRetryCount = 0 }

local v6 = if fFlagLuaAppDefaultHttpRetry then game:DefineFastInt(
	"NotificationsUpsellModalHttpRetryCount",
	4
) else nil
v5.maxRetryCount = v6
local v7 = config(v5)

local FollowingsPostFollow = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Requests/FollowingsPostFollow")

local sendEventDeferred = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsCommon").sendEventDeferred
local ModalEventConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Analytics/ModalEventConstants")

local RichTextEscape = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Util/RichTextEscape")

return function(props)
	local v8 = useLocalization({
		Cancel = "CommonUI.Controls.Action.Cancel",
		Yes = "CommonUI.Controls.Action.Yes",
		Heading = "Feature.Notifications.Heading.TurnOnNotifications",
		ReceiveUpdates = "Feature.Notifications.Label.ReceiveActivityUpdates",
		ReceiveUpdatesForExperience = "Feature.Notifications.Label.GetUpdatesFromExperience",
		NotificationsEnabledForExperience = "Feature.Notifications.Response.NotificationsEnabledForExperience",
		NotificationsEnabled = "Feature.Notifications.Response.NotificationsEnabled",
		SomethingWentWrong = "Feature.Call.Error.Description.Generic"
	})

	local v9 = useCallback(function()
		sendEventDeferred(ModalEventConstants.ModalContext, ModalEventConstants.OptInEventName, {
			[ModalEventConstants.ActionType] = ModalEventConstants.Clicked,
			[ModalEventConstants.Button] = ModalEventConstants.Cancel,
			[ModalEventConstants.UniverseId] = props.ExperienceId
		})

		props.CloseModal()
	end, { props.CloseModal, props.ExperienceId })
	local v10 = useCallback(function()
		sendEventDeferred(ModalEventConstants.ModalContext, ModalEventConstants.OptInEventName, {
			[ModalEventConstants.ActionType] = ModalEventConstants.Clicked,
			[ModalEventConstants.Button] = ModalEventConstants.Confirm,
			[ModalEventConstants.UniverseId] = props.ExperienceId
		})

		local localPlayer = Players and Players.LocalPlayer

		if props.ExperienceId ~= "0" and localPlayer then
			sendEventDeferred(ModalEventConstants.ModalContext, ModalEventConstants.OptInEventName, {
				[ModalEventConstants.ActionType] = ModalEventConstants.BackendRequested,
				[ModalEventConstants.UniverseId] = props.ExperienceId
			})

			FollowingsPostFollow(v7, tostring(localPlayer.UserId), (tostring(props.ExperienceId))):andThen(function()
				sendEventDeferred(ModalEventConstants.ModalContext, ModalEventConstants.OptInEventName, {
					[ModalEventConstants.ActionType] = ModalEventConstants.BackendSuccess,
					[ModalEventConstants.UniverseId] = props.ExperienceId
				})

				local setUIBloxToast = NotificationModalsManager.SetUIBloxToast
				local v17 = {
					iconImage = images["icons/common/notificationOn"],
					toastTitle = 0
				}
				local v18 = if props.ExperienceName then v8.NotificationsEnabledForExperience:gsub(
					"{experienceName}",
					props.ExperienceName
				) else v8.NotificationsEnabled
				v17.toastTitle = v18
				setUIBloxToast(v17)
			end, function()
				sendEventDeferred(ModalEventConstants.ModalContext, ModalEventConstants.OptInEventName, {
					[ModalEventConstants.ActionType] = ModalEventConstants.BackendFailed,
					[ModalEventConstants.UniverseId] = props.ExperienceId
				})

				NotificationModalsManager.SetUIBloxToast({
					iconImage = images["icons/status/alert"],
					toastTitle = v8.SomethingWentWrong
				})
			end)
		end

		props.CloseModal()
	end, { props.CloseModal, props.ExperienceId, v8 })

	local state, setState = useState(Vector2.new(800, 600))
	local v11 = useCallback(function(p2)
		setState(p2.AbsoluteSize)
	end, { setState })

	local v12 = useRef(nil)

	if defineFastFlag then
		useEffect(function()
			if not UserInputService.GamepadEnabled then
				return
			end

			task.delay(0.3, function()
				local buttons = v12.current and v12.current:FindFirstChild("Buttons", true)
				local _2 = buttons and buttons:FindFirstChild("2")

				if _2 then
					GuiService.SelectedCoreObject = _2
				end
			end)

			return function()
				GuiService.SelectedCoreObject = nil
			end
		end, {})
	else
		useEffect(function()
			if UserInputService.GamepadEnabled then
				task.delay(0.3, function()
					local buttons = v12.current and v12.current:FindFirstChild("Buttons", true)
					local _2 = buttons and buttons:FindFirstChild("2")

					if _2 then
						GuiService.SelectedCoreObject = _2
					end
				end)
			end
		end, {})
	end

	local createElement = React.createElement
	local v14 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ref = v12,
		[ReactRoblox.Change.AbsoluteSize] = v11
	}

	local createElement2 = React.createElement
	local v17 = {
		screenSize = state,
		title = v8.Heading,
		bodyText = 0,
		richText = true,
		buttonStackInfo = 0
	}
	local v18 = if props.ExperienceName then string.gsub(
		v8.ReceiveUpdatesForExperience,
		"{experienceName}",
		"\n<b>" .. RichTextEscape(props.ExperienceName) .. "</b>"
	) else v8.ReceiveUpdates
	v17.bodyText = v18

	v17.buttonStackInfo = {
		buttons = {
			{
				props = { onActivated = v9, text = v8.Cancel },
				isDefaultChild = true
			},
			{
				buttonType = buttonType.PrimarySystem,
				props = { onActivated = v10, text = v8.Yes },
				isDefaultChild = false
			}
		}
	}
	return createElement("Frame", v14, {
		ConfirmationPrompt = createElement2(interactiveAlert, v17)
	})
end
