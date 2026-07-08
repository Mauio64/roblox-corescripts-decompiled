local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local ParentParent = script.Parent.Parent.Parent
local Players = game:GetService("Players")
local FFlagLuaAppDefaultHttpRetry = require(ParentParent.SharedFlags).FFlagLuaAppDefaultHttpRetry
local React = require(ParentParent.React)
local ReactRoblox = require(ParentParent.ReactRoblox)
local UIBlox = require(ParentParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local NotificationModalsManager = require(ParentParent.NotificationModalsManager)
local useState = React.useState
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local useLocalization = require(ParentParent.Localization).Hooks.useLocalization
local v16 = game:DefineFastFlag("EnableConsoleAutoFocusForUEN1", false)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local HttpRequest = require(ParentParent.HttpRequest)
local v20 = HttpRequest.config({
	requestFunction = HttpRequest.requestFunctions.HttpRbxApi,
	maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("NotificationsUpsellModalHttpRetryCount", 4)
})
local FollowingsPostFollow = require(script.Parent.Parent.Requests.FollowingsPostFollow)
local sendEventDeferred = require(ParentParent.NotificationsCommon).sendEventDeferred
local ModalEventConstants = require(script.Parent.Parent.Analytics.ModalEventConstants)
local RichTextEscape = require(script.Parent.Parent.Util.RichTextEscape)

return function(p1) -- line: 39
	-- upvalues: useLocalization (copy), useCallback (copy), sendEventDeferred (copy), ModalEventConstants (copy), Players (copy), FollowingsPostFollow (copy), v20 (copy), NotificationModalsManager (copy), Images (copy), useState (copy), useRef (copy), v16 (copy), useEffect (copy), UserInputService (copy), GuiService (copy), React (copy), ReactRoblox (copy), InteractiveAlert (copy), RichTextEscape (copy), ButtonType (copy)
	local v26 = useLocalization({
		Cancel = "CommonUI.Controls.Action.Cancel",
		Yes = "CommonUI.Controls.Action.Yes",
		Heading = "Feature.Notifications.Heading.TurnOnNotifications",
		ReceiveUpdates = "Feature.Notifications.Label.ReceiveActivityUpdates",
		ReceiveUpdatesForExperience = "Feature.Notifications.Label.GetUpdatesFromExperience",
		NotificationsEnabledForExperience = "Feature.Notifications.Response.NotificationsEnabledForExperience",
		NotificationsEnabled = "Feature.Notifications.Response.NotificationsEnabled",
		SomethingWentWrong = "Feature.Call.Error.Description.Generic"
	})
	local v27 = useCallback(function() -- line: 52
		-- upvalues: sendEventDeferred (copy), ModalEventConstants (copy), p1 (copy)
		sendEventDeferred(ModalEventConstants.ModalContext, ModalEventConstants.OptInEventName, {
			[ModalEventConstants.ActionType] = ModalEventConstants.Clicked,
			[ModalEventConstants.Button] = ModalEventConstants.Cancel,
			[ModalEventConstants.UniverseId] = p1.ExperienceId
		})
		p1.CloseModal()
	end, {
		p1.CloseModal,
		p1.ExperienceId
	})
	local v28 = useCallback(function() -- line: 61
		-- upvalues: sendEventDeferred (copy), ModalEventConstants (copy), p1 (copy), Players (copy), FollowingsPostFollow (copy), v20 (copy), NotificationModalsManager (copy), Images (copy), v26 (copy)
		sendEventDeferred(ModalEventConstants.ModalContext, ModalEventConstants.OptInEventName, {
			[ModalEventConstants.ActionType] = ModalEventConstants.Clicked,
			[ModalEventConstants.Button] = ModalEventConstants.Confirm,
			[ModalEventConstants.UniverseId] = p1.ExperienceId
		})

		local v33 = Players and Players.LocalPlayer

		if p1.ExperienceId ~= "0" and v33 then
			sendEventDeferred(ModalEventConstants.ModalContext, ModalEventConstants.OptInEventName, {
				[ModalEventConstants.ActionType] = ModalEventConstants.BackendRequested,
				[ModalEventConstants.UniverseId] = p1.ExperienceId
			})
			FollowingsPostFollow(v20, tostring(v33.UserId), (tostring(p1.ExperienceId))):andThen(function() -- line: 74
				-- upvalues: sendEventDeferred (copy), ModalEventConstants (copy), p1 (copy), NotificationModalsManager (copy), Images (copy), v26 (copy)
				sendEventDeferred(ModalEventConstants.ModalContext, ModalEventConstants.OptInEventName, {
					[ModalEventConstants.ActionType] = ModalEventConstants.BackendSuccess,
					[ModalEventConstants.UniverseId] = p1.ExperienceId
				})
				NotificationModalsManager.SetUIBloxToast({
					iconImage = Images["icons/common/notificationOn"],
					toastTitle = if not p1.ExperienceName then v26.NotificationsEnabled else v26.NotificationsEnabledForExperience:gsub("{experienceName}", p1.ExperienceName)
				})
			end, function() -- line: 89
				-- upvalues: sendEventDeferred (copy), ModalEventConstants (copy), p1 (copy), NotificationModalsManager (copy), Images (copy), v26 (copy)
				sendEventDeferred(ModalEventConstants.ModalContext, ModalEventConstants.OptInEventName, {
					[ModalEventConstants.ActionType] = ModalEventConstants.BackendFailed,
					[ModalEventConstants.UniverseId] = p1.ExperienceId
				})
				NotificationModalsManager.SetUIBloxToast({
					iconImage = Images["icons/status/alert"],
					toastTitle = v26.SomethingWentWrong
				})
			end)
		end

		p1.CloseModal()
	end, {
		p1.CloseModal,
		p1.ExperienceId,
		v26
	})
	local v29, v30 = useState(Vector2.new(800, 600))
	local v31 = useCallback(function(p2) -- line: 111
		-- upvalues: v30 (copy)
		v30(p2.AbsoluteSize)
	end, { v30 })
	local v32 = useRef(nil)

	if v16 then
		useEffect(function() -- line: 117
			-- upvalues: UserInputService (copy), v32 (copy), GuiService (copy)
			if not UserInputService.GamepadEnabled then
				return
			end

			task.delay(0.3, function() -- line: 124
				-- upvalues: v32 (copy), GuiService (copy)
				local v35 = v32.current and v32.current:FindFirstChild("Buttons", true)
				local v36 = v35 and v35:FindFirstChild("2")

				if v36 then
					GuiService.SelectedCoreObject = v36
				end
			end)

			return function() -- line: 132
				-- upvalues: GuiService (copy)
				GuiService.SelectedCoreObject = nil
			end
		end, {})
	else
		useEffect(function() -- line: 137
			-- upvalues: UserInputService (copy), v32 (copy), GuiService (copy)
			if UserInputService.GamepadEnabled then
				task.delay(0.3, function() -- line: 141
					-- upvalues: v32 (copy), GuiService (copy)
					local v37 = v32.current and v32.current:FindFirstChild("Buttons", true)
					local v38 = v37 and v37:FindFirstChild("2")

					if v38 then
						GuiService.SelectedCoreObject = v38
					end
				end)
			end
		end, {})
	end

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ref = v32,
		[ReactRoblox.Change.AbsoluteSize] = v31
	}, {
		ConfirmationPrompt = React.createElement(InteractiveAlert, {
			richText = true,
			screenSize = v29,
			title = v26.Heading,
			bodyText = if not p1.ExperienceName then v26.ReceiveUpdates else string.gsub(v26.ReceiveUpdatesForExperience, "{experienceName}", "\n<b>" .. RichTextEscape(p1.ExperienceName) .. "</b>"),
			buttonStackInfo = {
				buttons = {
					{
						isDefaultChild = true,
						props = {
							onActivated = v27,
							text = v26.Cancel
						}
					},
					{
						isDefaultChild = false,
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = v28,
							text = v26.Yes
						}
					}
				}
			}
		})
	})
end
