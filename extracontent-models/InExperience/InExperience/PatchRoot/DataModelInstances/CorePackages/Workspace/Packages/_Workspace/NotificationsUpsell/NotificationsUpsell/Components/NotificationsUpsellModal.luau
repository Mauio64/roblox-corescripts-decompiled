local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local parent = script.Parent.Parent.Parent
local Players = game:GetService("Players")

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDefaultHttpRetry = SharedFlags.FFlagLuaAppDefaultHttpRetry
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images

local NotificationModalsManager = require(parent.NotificationModalsManager)

local useState = React.useState
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local defineFastFlag = game:DefineFastFlag("EnableConsoleAutoFocusForUEN1", false)

local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local HttpRequest = require(parent.HttpRequest)
local config = HttpRequest.config
local v = { requestFunction = HttpRequest.requestFunctions.HttpRbxApi, maxRetryCount = 0 }
local maxRetryCount

if FFlagLuaAppDefaultHttpRetry then
	maxRetryCount = game:DefineFastInt("NotificationsUpsellModalHttpRetryCount", 4)
end

v.maxRetryCount = maxRetryCount
local v2 = config(v)

local FollowingsPostFollow = require(script.Parent.Parent.Requests.FollowingsPostFollow)

local NotificationsCommon = require(parent.NotificationsCommon)
local sendEventDeferred = NotificationsCommon.sendEventDeferred
local ModalEventConstants = require(script.Parent.Parent.Analytics.ModalEventConstants)

local RichTextEscape = require(script.Parent.Parent.Util.RichTextEscape)

return function(props)
	local v3 = useLocalization({
		Cancel = "CommonUI.Controls.Action.Cancel",
		Yes = "CommonUI.Controls.Action.Yes",
		Heading = "Feature.Notifications.Heading.TurnOnNotifications",
		ReceiveUpdates = "Feature.Notifications.Label.ReceiveActivityUpdates",
		ReceiveUpdatesForExperience = "Feature.Notifications.Label.GetUpdatesFromExperience",
		NotificationsEnabledForExperience = "Feature.Notifications.Response.NotificationsEnabledForExperience",
		NotificationsEnabled = "Feature.Notifications.Response.NotificationsEnabled",
		SomethingWentWrong = "Feature.Call.Error.Description.Generic"
	})

	local onActivated = useCallback(function()
		sendEventDeferred(ModalEventConstants.ModalContext, ModalEventConstants.OptInEventName, {
			[ModalEventConstants.ActionType] = ModalEventConstants.Clicked,
			[ModalEventConstants.Button] = ModalEventConstants.Cancel,
			[ModalEventConstants.UniverseId] = props.ExperienceId
		})

		props.CloseModal()
	end, { props.CloseModal, props.ExperienceId })
	local onActivated2 = useCallback(function()
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

			FollowingsPostFollow(v2, tostring(localPlayer.UserId), (tostring(props.ExperienceId))):andThen(function()
				sendEventDeferred(ModalEventConstants.ModalContext, ModalEventConstants.OptInEventName, {
					[ModalEventConstants.ActionType] = ModalEventConstants.BackendSuccess,
					[ModalEventConstants.UniverseId] = props.ExperienceId
				})

				local setUIBloxToast = NotificationModalsManager.SetUIBloxToast
				local v4 = { iconImage = Images["icons/common/notificationOn"], toastTitle = 0 }
				local toastTitle

				if props.ExperienceName then
					toastTitle = v3.NotificationsEnabledForExperience:gsub("{experienceName}", props.ExperienceName)
				else
					toastTitle = v3.NotificationsEnabled
				end

				v4.toastTitle = toastTitle
				setUIBloxToast(v4)
			end, function()
				sendEventDeferred(ModalEventConstants.ModalContext, ModalEventConstants.OptInEventName, {
					[ModalEventConstants.ActionType] = ModalEventConstants.BackendFailed,
					[ModalEventConstants.UniverseId] = props.ExperienceId
				})

				NotificationModalsManager.SetUIBloxToast({
					iconImage = Images["icons/status/alert"],
					toastTitle = v3.SomethingWentWrong
				})
			end)
		end

		props.CloseModal()
	end, { props.CloseModal, props.ExperienceId, v3 })

	local state, setState = useState(Vector2.new(800, 600))
	local v4 = useCallback(function(p)
		setState(p.AbsoluteSize)
	end, { setState })

	local ref = useRef(nil)

	if defineFastFlag then
		useEffect(function()
			if not UserInputService.GamepadEnabled then
				return
			end

			task.delay(0.3, function()
				local buttons = ref.current and ref.current:FindFirstChild("Buttons", true)
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
					local buttons = ref.current and ref.current:FindFirstChild("Buttons", true)
					local _2 = buttons and buttons:FindFirstChild("2")

					if _2 then
						GuiService.SelectedCoreObject = _2
					end
				end)
			end
		end, {})
	end

	local createElement = React.createElement
	local v5 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ref = ref,
		[ReactRoblox.Change.AbsoluteSize] = v4
	}

	local createElement2 = React.createElement
	local v6 = {
		screenSize = state,
		title = v3.Heading,
		bodyText = 0,
		richText = true,
		buttonStackInfo = 0
	}
	local bodyText

	if props.ExperienceName then
		bodyText = string.gsub(
			v3.ReceiveUpdatesForExperience,
			"{experienceName}",
			"\n<b>" .. RichTextEscape(props.ExperienceName) .. "</b>"
		)
	else
		bodyText = v3.ReceiveUpdates
	end

	v6.bodyText = bodyText

	v6.buttonStackInfo = {
		buttons = {
			{
				props = { onActivated = onActivated, text = v3.Cancel },
				isDefaultChild = true
			},
			{
				buttonType = ButtonType.PrimarySystem,
				props = { onActivated = onActivated2, text = v3.Yes },
				isDefaultChild = false
			}
		}
	}
	return createElement("Frame", v5, {
		ConfirmationPrompt = createElement2(InteractiveAlert, v6)
	})
end
