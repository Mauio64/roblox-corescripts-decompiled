local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")

local TouchEnabled = UserInputService.TouchEnabled

local parent = script.Parent
local components = parent.Components
local context = parent.context
local utils = parent.utils
local Logger = require(parent.Logger)
local toastNotificationHelper = require(utils.toastNotificationHelper)
local toastNotificationSessionizationHelper = require(utils.toastNotificationSessionizationHelper)
local parent2 = parent.Parent
local NotificationsCommon = require(parent2.NotificationsCommon)
local React = require(parent2.React)
local UIBlox = require(parent2.UIBlox)
local Cryo = require(parent2.Cryo)
local AppCommonLib = require(parent2.AppCommonLib)
local IsVRAppBuild = AppCommonLib.IsVRAppBuild
local AppCommonLib2 = require(parent2.AppCommonLib)
local isTenFootInterface = AppCommonLib2.isTenFootInterface
local Responsive = require(parent2.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local useIsSpatial = Responsive.useIsSpatial
local ReactOtter = require(parent2.ReactOtter)

local LifecycleEvents = require(script.Parent.utils.LifecycleEvents)
local ToastNotificationsProtocol = require(parent2.ToastNotificationsProtocol)
local ToastNotificationProtocol = ToastNotificationsProtocol.ToastNotificationProtocol
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local SharedFlags = require(parent2.SharedFlags)

local analyticsService = require(parent.analytics.analyticsService)

local NotificationCardProvider = require(context.NotificationCardProvider)
local NotificationCard = require(components.NotificationCard)
local ToastNotificationSnoozeMenu = require(components.ToastNotificationSnoozeMenu)
local DeeplinkConfirmationModal = NotificationsCommon.DeeplinkConfirmationModal
local SwipeDetectionWrapper = require(components.SwipeDetectionWrapper)
local ToastVRWrapper = require(components.ToastVRWrapper)
local ClientNotificationWrapper = require(components.ClientNotificationWrapper)
local useKeyCodeHold = require(components.useKeyCodeHold)
local kind = require(parent.type)
local constants = require(parent.constants)
local JoinExperience = NotificationsCommon.JoinExperience
local FFlagNotificationDeeplinkTapListenersEnabled = NotificationsCommon.FFlagNotificationDeeplinkTapListenersEnabled
local deeplinkTapListeners

if FFlagNotificationDeeplinkTapListenersEnabled then
	deeplinkTapListeners = NotificationsCommon.DeeplinkTapListeners
else
	deeplinkTapListeners = nil
end

local SpringAnimatedItem = UIBlox.Utility.SpringAnimatedItem
local iconsnavigationclose = Images["icons/navigation/close"]

local GetFFlagEnableChatNewMessage = SharedFlags.GetFFlagEnableChatNewMessage
local engineFeature = game:GetEngineFeature("ClientToastNotificationsEnabled")

local defineFastFlag = game:DefineFastFlag("EnableClientToastNotificationsReducedMotion", false)
local defineFastFlag2 = game:DefineFastFlag("EnableNotificationsToastTTLFix", false)

local ToastNotificationSnoozeManager = require(parent.ToastNotificationSnoozeManager)
local default = ToastNotificationSnoozeManager.default
local GetFStringPCGDKFilteredNotificationTypes = SharedFlags.GetFStringPCGDKFilteredNotificationTypes
local function GetIsFriendCommunicationRestricted()
	return ThirdPartyUserService
		and ThirdPartyUserService:IsChatRestrictionSupported()
		and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted
end

local GetFFlagFilterSecurityAlertsVRToastEnabled = SharedFlags.GetFFlagFilterSecurityAlertsVRToastEnabled

local defineFastFlag3 = game:DefineFastFlag("EnableDisplayLoggingForToastsFix", false)

local IXPServiceWrapper = require(parent2.IXPServiceWrapper)
local ixpServiceWrapper = IXPServiceWrapper.IXPServiceWrapper
local FFlagFriendshipNotifsUseSendrExperiment = SharedFlags.FFlagFriendshipNotifsUseSendrExperiment

local defineFastString = game:DefineFastString("FriendshipNotifsUseSendrLayerName", "Notification.Toast")
local defineFastString2 = game:DefineFastString("FRRToastPositionVariantKey", "frrToastPositionVariant")

local v = false
local success = nil
local result = nil

local function getFRRToastPositionVariant() -- 2 equivalent calls inferred from this helper
	if FFlagFriendshipNotifsUseSendrExperiment and not v then
		success, result = pcall(function()
			v = true
			return ixpServiceWrapper:GetLayerData(defineFastString)
		end)
	end

	if success and result then
		return result[defineFastString2]
	end

	return nil
end

local springOptions = { frequency = 4, damping = 1 }

local getDeviceOrientation = toastNotificationHelper.getDeviceOrientation
local getNotificationSize = toastNotificationHelper.getNotificationSize
local marshalNotificationData = toastNotificationHelper.marshalNotificationData
local calculateToastPosition = toastNotificationHelper.calculateToastPosition
local isToastToRight = toastNotificationHelper.isToastToRight
local calculateTimeRemaining = toastNotificationHelper.calculateTimeRemaining

return function(p)
	local v2 = p.renderLocation == kind.RenderLocationEnum.CoreScript
	local desktopDevice = toastNotificationHelper.isDesktopDevice()
	local v3

	if v2 then
		v3 = constants.CardTopMargin.Experience
	else
		v3 = constants.CardTopMargin.App
	end

	local default2 = ToastNotificationProtocol.default

	local state, setState = React.useState(UserGameSettings.ReducedMotion)

	local function fn() -- 6 equivalent calls inferred from this helper
		return workspace.CurrentCamera.ViewportSize
	end

	local state2, setState2 = React.useState(getNotificationSize(v2, fn().X)) -- inferred equivalent call
	local state3, setState3 = React.useState(getDeviceOrientation(fn())) -- inferred equivalent call

	local useState = React.useState
	local v4

	if FFlagFriendshipNotifsUseSendrExperiment then
		v4 = fn() -- inferred equivalent call
	end

	local state4, setState4 = useState(v4)
	local state5, setState5 = React.useState(false)

	local state6, setState6 = React.useState(nil)

	local state7, setState7 = React.useState(nil)

	local state8, setState8 = React.useState(calculateToastPosition(false, isToastToRight(state3), v3, state))

	local state9, setState9 = React.useState(nil)
	local state10, setState10 = React.useState(nil)

	local function fn2(flag: boolean) -- 2 equivalent calls inferred from this helper
		return flag and fn().X < constants.CompactCardThreashold -- inferred equivalent call
	end

	local state11, setState11 = React.useState(function()
		return fn2(v2) -- inferred equivalent call
	end)

	local state12, setState12 = React.useState(false)
	local state13, setState13 = React.useState(false)
	local state14, setState14 = React.useState(false)
	local ref = React.useRef(false)
	local state15, setState15 = React.useState(false)
	local state16, setState16 = React.useState(false)
	local state17, setState17 = React.useState(false)
	local state18, setState18 = React.useState({})
	local v5 = useIsSpatial()

	local showHoldButton = usePreferredInput() == Responsive.Input.Directional

	local state19, setState19 = React.useState(false)

	local v6 = React.useMemo(function()
		return not showHoldButton or state19 or state6 == nil
	end, { showHoldButton, state19, state6 })

	React.useEffect(function()
		if not state19 then
			return
		end

		local inputBeganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then
				return
			end

			if input.KeyCode == Enum.KeyCode.ButtonB then
				setState19(false)
			end
		end)

		return function()
			inputBeganConnection:Disconnect()
		end
	end, { state19 })

	local v7 = React.useCallback(function()
		setState19(true)
	end, {})
	local v8 = useKeyCodeHold(
		Enum.KeyCode.ButtonSelect,
		constants.SIGNAL_HOLD_INTENT_SECONDS,
		constants.SIGNAL_HOLD_COMPLETE_SECONDS,
		v7,
		v6
	)

	local holdProgress = v8.holdProgress
	local holding = v8.holding

	local state20, setState20 = React.useState((Instance.new("BindableEvent")))
	local v9 = useStyle()

	local isHover = state15 or state16
	local userId = Players and Players.LocalPlayer and Players.LocalPlayer.UserId or nil

	local function fn3(action_type: string, userId2, data)
		if data == nil then
			return
		end

		Logger:info("NotificationType: {} with event: {}", data.notificationType, action_type)

		local eventStream = analyticsService.EventStream

		toastNotificationSessionizationHelper(action_type)

		local time_to_action_timestamp = not (data and data.displayTimestamp) and 0
			or DateTime.now().UnixTimestampMillis - data.displayTimestamp

		local fireEvent = toastNotificationHelper.fireEvent

		local join = Cryo.Dictionary.join
		local v10 = {
			action_type = action_type,
			delivery_channel = constants.DeliveryChannel,
			notification_type = 0,
			notification_id = 0,
			recipient_userid = 0,
			recipient_universe_id = 0,
			client_destination = 0,
			deliver_timestamp = 0,
			snoozed = 0,
			time_to_action_timestamp = 0,
			frr_toast_position_variant = 0
		}
		local notification_type

		if data then
			notification_type = data.notificationType or nil
		end

		v10.notification_type = notification_type
		local notification_id

		if data then
			notification_id = data.id or nil
		end

		v10.notification_id = notification_id
		v10.recipient_userid = userId2 or nil
		local recipient_universe_id

		if v2 then
			recipient_universe_id = game and game.GameId
		end

		v10.recipient_universe_id = recipient_universe_id
		local client_destination

		if v2 then
			client_destination = constants.Destinations.Experience
		else
			client_destination = constants.Destinations.App
		end

		v10.client_destination = client_destination
		local deliver_timestamp

		if data then
			deliver_timestamp = data.deliverTimestamp or nil
		end

		v10.deliver_timestamp = deliver_timestamp
		local snoozed

		if data and data.notificationType then
			snoozed = default:isSnoozedNotificationType(data.notificationType)
		else
			snoozed = false
		end

		v10.snoozed = snoozed

		v10.time_to_action_timestamp = time_to_action_timestamp
		local frr_toast_position_variant

		if
			FFlagFriendshipNotifsUseSendrExperiment
			and data.notificationType == kind.NotificationTypeEnum.FriendRequestReceived
		then
			frr_toast_position_variant = getFRRToastPositionVariant() -- inferred equivalent call
		end

		v10.frr_toast_position_variant = frr_toast_position_variant
		fireEvent(eventStream, join(v10, data and data.clientEventsPayload or {}))
	end

	React.useEffect(function()
		local changedConnection = UserGameSettings.Changed:Connect(function(p2)
			if p2 == "ReducedMotion" then
				local success2, result2 = pcall(function()
					return UserGameSettings[p2]
				end)

				if success2 then
					setState(result2)
				end
			end
		end)

		return function()
			if changedConnection then
				changedConnection:Disconnect()
			end
		end
	end, { setState, UserGameSettings })

	local function fn4(flag: boolean)
		if not flag then
			fn3(kind.ToastNotificationActionsEnum.ModalCancel, userId, state6)
			setState13(false)
		end

		if state20 then
			fn3(kind.ToastNotificationActionsEnum.ModalConfirm, userId, state6)
			state20:Fire(flag)
		end
	end

	local v10 = React.useCallback(function()
		if state9 then
			task.cancel(state9)
		end

		setState9(nil)
	end, { state9 })
	local v11

	local function fn5(p2: string) -- 3 equivalent calls inferred from this helper
		fn10(p2) -- inferred equivalent call
		setState7(nil)
		v10()
	end

	if defineFastFlag2 then
		v11 = function(p2: string, duration: number, p3)
			v10()
			setState9((task.delay(duration, function()
				if ref.current then
					v10()
					return
				end

				fn3(kind.ToastNotificationActionsEnum.Ignored, userId, p3)

				if engineFeature and p3 and p3.luaNotifInfo then
					GuiService:DismissNotification(p2)
					return
				end

				fn5(p2) -- inferred equivalent call
			end)))
		end
	else
		v11 = React.useCallback(function(p2: string, duration: number, p3)
			v10()
			setState9((task.delay(duration, function()
				if not state14 then
					fn3(kind.ToastNotificationActionsEnum.Ignored, userId, p3)

					if engineFeature and p3 and p3.luaNotifInfo then
						GuiService:DismissNotification(p2)
						return
					end

					fn5(p2) -- inferred equivalent call
				end
			end)))
		end, { state14 })
	end

	local v12 = React.useCallback(function()
		if state6 and state7 and state7.id == state6.id then
			if engineFeature and state6.luaNotifInfo then
				GuiService:DismissNotification(state6.id)
				return
			end

			fn5(state6.id) -- inferred equivalent call
		end
	end, { state6, state7 })

	local function fn6() -- 1 equivalent call inferred from this helper
		fn3(kind.ToastNotificationActionsEnum.Dismissed, userId, state6)
		v12()
		setState16(false)
	end

	local v13 = React.useCallback(function()
		if v2 and state20 then
			setState13(true)
			return state20.Event:Wait()
		end

		return true
	end, { v2, state20 })

	local function fn7(state21) -- 2 equivalent calls inferred from this helper
		local timeOnScreenMs = state21.state and state21.state.timeOnScreenMs

		return (timeOnScreenMs and timeOnScreenMs / 1000 or constants.DefaultNotificationDisplayTime) + 1
	end

	local function fn8() -- 1 equivalent call inferred from this helper
		if state6 and state7 and not state9 then
			v11(state6.id, fn7(state6), state6) -- inferred equivalent call
		end
	end

	local fn9 = defineFastFlag2 and function(flag: boolean, ...)
		if flag then
			v10()
			return
		end

		fn8() -- inferred equivalent call
	end or function(flag: boolean, callback, callback2)
		if flag then
			callback()
		else
			callback2()
		end
	end

	local v14 = React.useCallback(function()
		for _, v14 in ipairs(state18) do
			task.cancel(v14)
		end
	end, { state18 })

	React.useEffect(function()
		return function()
			v14()
		end
	end, { v14 })

	local function fn10(p2: string) -- 6 equivalent calls inferred from this helper
		default2:dismissNotification(p2)
	end

	local v15 = React.useCallback(function(data, p2, flag: boolean?)
		if data.actionType == kind.ActionTypeEnum.Dismiss then
			v12()
		elseif data.actionType == kind.ActionTypeEnum.Deeplink then
			if v13() then
				if FFlagNotificationDeeplinkTapListenersEnabled and flag then
					deeplinkTapListeners.notify({
						notificationType = p2 and p2.notificationType,
						notificationId = p2 and p2.id,
						url = data.path or "",
						source = "toast",
						isInExperience = v2
					})
				end

				if JoinExperience(data.path or "", v2) then
					setState13(false)

					if p2 then
						fn10(p2.id) -- inferred equivalent call
					end
				else
					fn3(kind.ToastNotificationActionsEnum.DeeplinkFailed, userId, p2)

					v12()
				end
			end
		elseif data.actionType == kind.ActionTypeEnum.VoltronBroadcast then
			local success2, result2 = pcall(function()
				return HttpService:JSONDecode(data.parameters)
			end)

			if success2 then
				default2:voltronBroadcast(data.messageId, result2)
			else
				Logger:warning("Invalid decoded payload for voltronBroadcast")
			end
		elseif
			data.actionType == kind.ActionTypeEnum.UpdateState
			and data.nextState ~= nil
			and data.nextState ~= ""
			and p2
			and p2.id
		then
			ToastNotificationProtocol:updateNotification(p2.id, data.nextState)
		end
	end, { v12, v13 })

	local v16 = React.useCallback(function(data)
		local function executeAllActions(actions) -- 2 equivalent calls inferred from this helper
			for _, item in ipairs(actions) do
				v15(item, data)
			end
		end

		v14()

		if data.timers then
			local threads = {}

			for _, timer in pairs(data.timers) do
				local v16 = calculateTimeRemaining(timer, data.notificationReceivedTimestampMs, data.displayTimestamp)

				if v16 > 0 then
					table.insert(threads, (task.delay(v16 / 1000, function()
						executeAllActions(timer.actions) -- inferred equivalent call
					end)))
				else
					executeAllActions(timer.actions) -- inferred equivalent call
				end
			end

			if #threads > 0 then
				setState18(threads)
			end
		end
	end, { v15, v14, calculateTimeRemaining })

	local handleActions = React.useCallback(function(visualItem)
		if state12 then
			return
		end

		setState12(true)

		if visualItem.eventName then
			fn3(visualItem.eventName, userId, state6)
		end

		if visualItem.actionEventParams and state6 then
			LifecycleEvents:DispatchEvent(LifecycleEvents.ToastEvents.UserAction, state6.notificationType, {
				notificationData = state6,
				visualItem = visualItem,
				userActionType = "click",
				parameters = visualItem.actionEventParams
			})
		end

		if visualItem.actions and #visualItem.actions > 0 then
			for _, action in ipairs(visualItem.actions) do
				v15(action, state6, FFlagNotificationDeeplinkTapListenersEnabled and true or nil)

				if action.actionType == kind.ActionTypeEnum.Deeplink and v13() then
					break
				end
			end
		end

		setState12(false)
	end, { state6, v12, state12, v13 })

	local function fn11(state21, p2)
		state21.displayTimestamp = DateTime.now().UnixTimestampMillis

		if
			GetFStringPCGDKFilteredNotificationTypes()[state21.notificationType]
			and ThirdPartyUserService
			and ThirdPartyUserService:IsChatRestrictionSupported()
			and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted
		then
			fn10(state21.id) -- inferred equivalent call
		else
			local v17

			if p2 == "update" then
				v17 = kind.ToastNotificationActionsEnum.Update
			else
				v17 = kind.ToastNotificationActionsEnum.Display
			end

			if defineFastFlag3 then
				if default:isSnoozedNotificationType(state21.notificationType) then
					fn10(state21.id) -- inferred equivalent call
					return
				end

				fn3(v17, userId, state21)
			else
				fn3(v17, userId, state21)

				if default:isSnoozedNotificationType(state21.notificationType) then
					fn10(state21.id) -- inferred equivalent call
					return
				end
			end

			setState6(state21)
			local v18 = fn7(state21) -- inferred equivalent call
			v11(state21.id, v18, state21)

			if p2 == "display" then
				v16(state21)
			end

			if engineFeature and state21 and state21.luaNotifInfo then
				GuiService:OnNotificationDisplayed(state21.id)
			end

			setState10(nil)
		end
	end

	local v17 = React.useCallback(function(p2)
		if
			isTenFootInterface()
			and p2
			and p2.notificationType ~= nil
			and p2.notificationType ~= kind.NotificationTypeEnum.ClientNotification
		then
			return
		end

		if
			GetFFlagFilterSecurityAlertsVRToastEnabled()
			and v5
			and p2
			and p2.notificationType ~= nil
			and p2.notificationType == kind.NotificationTypeEnum.SecurityAlert
		then
			return
		end

		if
			p2
			and p2.notificationType == kind.NotificationTypeEnum.ChatNewMessage
			and not GetFFlagEnableChatNewMessage()
			and p2.content
			and p2.content.id
		then
			fn10(p2.content.id) -- inferred equivalent call
		else
			if not p2 or not p2.content or p2.content.id == nil then
				setState7(nil)

				return
			end

			local v17 = marshalNotificationData(p2)
			setState7(v17)
			LifecycleEvents:DispatchEvent(LifecycleEvents.ToastEvents.AttemptDisplay, v17.notificationType, v17)
		end
	end, {})

	local function fn12(state21, duration: number) -- 1 equivalent call inferred from this helper
		if state10 then
			task.cancel(state10)
		end

		setState10((task.delay(duration, function()
			fn11(state21, "display")
			LifecycleEvents:DispatchEvent(LifecycleEvents.ToastEvents.Display, state21.notificationType, state21)
		end)))
	end

	React.useEffect(function()
		if state7 then
			if state6 and state6.id == state7.id then
				fn11(state7, "update")
				LifecycleEvents:DispatchEvent(LifecycleEvents.ToastEvents.Update, state7.notificationType, state7)
			else
				local v18 = constants.DisplayNotificationDelay

				if state7.luaNotifInfo ~= nil then
					v18 = not state6 and 0 or 1 / springOptions.frequency
				end

				fn12(state7, v18) -- inferred equivalent call
			end
		end
	end, { state7 })

	React.useEffect(function()
		local v18 = state7 and state6 and state7.id == state6.id and true or false

		setState5(v18)

		if v18 == false then
			setState19(false)
		end
	end, { state7, state6 })

	React.useEffect(function()
		local current = state5 and (state12 or state15 or state16 or state17 or state19 or holding)
		setState14(current)

		if defineFastFlag2 then
			ref.current = current
		end
	end, { state5, state12, state15, state16, state17, state19, holding })

	React.useEffect(function()
		if defineFastFlag2 then
			fn9(state14)
		else
			fn9(state14, v10, fn8)
		end
	end, { state14 })

	local groupTransparency, v18 = ReactOtter.useAnimatedBinding(1, function()
		if not state5 then
			setState6(nil)
			v14()
		end
	end)

	React.useEffect(function()
		v18(ReactOtter.spring(state5 and 0 or 1, springOptions))
	end, { state5, v18 })

	local useEffect = React.useEffect
	local function fn13()
		local v19

		if FFlagFriendshipNotifsUseSendrExperiment then
			local v20

			if state6 and state6.notificationType == kind.NotificationTypeEnum.FriendRequestReceived then
				v20 = getFRRToastPositionVariant() == "legacyBottomRight" and "legacyBottomRight" or nil -- inferred equivalent call
			end

			v19 = calculateToastPosition(state5, isToastToRight(state3), v3, state, v20, state4)
		else
			v19 = calculateToastPosition(state5, isToastToRight(state3), v3, state)
		end

		setState8(v19)
	end

	local v19

	if FFlagFriendshipNotifsUseSendrExperiment then
		v19 = state6
	end

	local v20

	if FFlagFriendshipNotifsUseSendrExperiment then
		v20 = v3
	end

	local v21

	if FFlagFriendshipNotifsUseSendrExperiment then
		v21 = state4
	end

	useEffect(fn13, { state3, state5, state, v19, v20, v21 })

	local function fn14() -- 2 equivalent calls inferred from this helper
		local viewportSize = fn() -- inferred equivalent call
		local deviceOrientation = getDeviceOrientation(viewportSize)
		setState2((getNotificationSize(v2, viewportSize.X)))
		setState11(fn2(v2)) -- inferred equivalent call
		setState3(deviceOrientation)
	end

	React.useEffect(function()
		fn14() -- inferred equivalent call
		local viewportSizeChangedConnection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			fn14() -- inferred equivalent call

			if FFlagFriendshipNotifsUseSendrExperiment then
				setState4(fn()) -- inferred equivalent call
			end
		end)

		return function()
			if viewportSizeChangedConnection then
				viewportSizeChangedConnection:Disconnect()
			end
		end
	end, {})

	React.useEffect(function()
		return function()
			if state10 then
				task.cancel(state10)
			end

			if state9 then
				task.cancel(state9)
			end

			if state20 then
				setState20(nil)
				state20:Fire(false)
				state20:Destroy()
			end
		end
	end, {})

	React.useEffect(function()
		task.delay(0, function()
			local desktops

			if v2 then
				desktops = { kind.ChannelListEnum.Experience, kind.ChannelListEnum.Dual }
			else
				desktops = { kind.ChannelListEnum.App, kind.ChannelListEnum.Dual }
			end

			if desktopDevice then
				table.insert(desktops, kind.ChannelListEnum.Desktop)
			end

			default2:setupNotifications(desktops)
		end)
	end, {})

	React.useEffect(function()
		local connection = default2:listenToDisplayNotification(v17)
		return function()
			if connection then
				connection:Disconnect()
			end
		end
	end, { v17 })

	local vrAppBuild = IsVRAppBuild()
	local v22 = state5 or not vrAppBuild
	local v23 = isHover and not TouchEnabled and not vrAppBuild and state5
	local element = React.createElement("TextButton", {
		ZIndex = 2,
		LayoutOrder = 1,
		AnchorPoint = Vector2.new(0, 0),
		Size = UDim2.new(0, constants.CardSizeDefault.closeButton, 0, constants.CardSizeDefault.closeButton),
		Position = UDim2.new(0, -10, 0, -10),
		BackgroundTransparency = v9.Theme.BackgroundUIDefault.Transparency,
		BackgroundColor3 = v9.Theme.BackgroundUIDefault.Color,
		Text = "",
		[React.Event.Activated] = fn6,
		[React.Event.MouseEnter] = function()
			setState16(true)
		end,
		[React.Event.MouseLeave] = function()
			setState16(false)
		end
	}, {
		Border = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = v9.Theme.UIDefault.Color
		}),
		UICorner = React.createElement("UICorner", {
			CornerRadius = constants.DefaultCardCloseButtonCornerRadius
		}),
		CloseButtonIcon = React.createElement(ImageSetLabel, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, constants.CardSizeDefault.closeIcon, 0, constants.CardSizeDefault.closeIcon),
			Image = iconsnavigationclose,
			ImageColor3 = v9.Theme.SystemPrimaryDefault.Color
		})
	})

	local v24 = React.useMemo(function()
		local createElement = React.createElement
		local animatedFrame = SpringAnimatedItem.AnimatedFrame
		local v24 = {
			regularProps = {
				ClipsDescendants = false,
				Size = state2,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Active = true,
				Visible = v22 and state6 ~= nil,
				[React.Event.MouseEnter] = function()
					fn3(kind.ToastNotificationActionsEnum.Hover, userId, state6)

					setState15(true)
				end,
				[React.Event.MouseLeave] = function()
					setState15(false)
				end
			},
			animatedValues = state8,
			springOptions = springOptions,
			mapValuesToProps = function(data)
				local position

				if vrAppBuild then
					position = UDim2.new(0.5, 0, 0.5, 0)
				else
					position = UDim2.new(data.positionX, data.positionXOffset, data.positionY, data.positionYOffset)
				end

				local anchorPoint

				if vrAppBuild then
					anchorPoint = Vector2.new(0.5, 0.5)
				else
					anchorPoint = Vector2.new(data.anchorX, data.anchorY)
				end

				return { Position = position, AnchorPoint = anchorPoint }
			end,
			onComplete = function()
				if not state5 then
					setState6(nil)
					v14()
				end
			end
		}

		local createElement2 = React.createElement
		local v25 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			swipeEnabled = state5,
			swipeCallback = function(p2)
				if p2 == Enum.SwipeDirection.Up or p2 == Enum.SwipeDirection.Right then
					fn6() -- inferred equivalent call
				end
			end
		}
		local notificationProvider

		if engineFeature and state6 and state6.luaNotifInfo and state6.id then
			local createElement3 = React.createElement
			local v26 = {
				notificationInfo = state6.luaNotifInfo,
				notificationId = state6.id,
				onPause = setState17,
				onHover = setState15,
				transparency = 0,
				width = 0
			}
			local transparency

			if defineFastFlag then
				transparency = groupTransparency
			end

			v26.transparency = transparency

			v26.width = state2.X
			local toastCloseButton

			if v23 then
				toastCloseButton = element
			end

			notificationProvider = createElement3(ClientNotificationWrapper, v26, {
				ToastCloseButton = toastCloseButton
			})
		else
			local createElement3 = React.createElement
			local v26 = {
				state = state6 and state6.state,
				isCompact = state11,
				handleActions = handleActions,
				notificationReceivedTimestampMs = state6 and state6.notificationReceivedTimestampMs,
				timers = state6 and state6.timers,
				displayTimestampMs = state6 and state6.displayTimestamp
			}
			local notificationCardCanvasGroup

			if state6 then
				notificationCardCanvasGroup = React.createElement("CanvasGroup", {
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = state2,
					BackgroundTransparency = 1,
					GroupTransparency = groupTransparency,
					LayoutOrder = 2
				}, {
					NotificationCard = React.createElement(NotificationCard, {
						isHover = isHover,
						shouldAutoFocus = state19,
						showHoldButton = showHoldButton,
						holdProgress = holdProgress
					})
				})
			end

			local toastCloseButton

			if v23 then
				toastCloseButton = element
			end

			notificationProvider = createElement3(NotificationCardProvider, v26, {
				NotificationCardCanvasGroup = notificationCardCanvasGroup,
				ToastCloseButton = toastCloseButton
			})
		end

		return createElement(animatedFrame, v24, {
			SwipeDetector = createElement2(SwipeDetectionWrapper, v25, {
				NotificationProvider = notificationProvider
			})
		})
	end, {
		constants,
		v9,
		state6,
		v22,
		state5,
		state11,
		v23,
		isHover,
		state8,
		fn6,
		setState15,
		setState16,
		handleActions
	})

	if vrAppBuild then
		return React.createElement(ToastVRWrapper, {
			isConfirmModalOpen = state13,
			isToastOpen = state5,
			isCoreScript = v2,
			ToastComponent = v24,
			ToastNotificationSnoozeMenu = React.createElement(ToastNotificationSnoozeMenu),
			ConfirmationModalComponent = React.createElement(DeeplinkConfirmationModal, {
				closeCallback = fn4,
				backgroundTransparency = 1
			})
		})
	end

	return React.createElement(
		"ScreenGui",
		{
			DisplayOrder = p.displayOrder,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			IgnoreGuiInset = true
		},
		{
			Toast = v24,
			ToastNotificationSnoozeMenu = React.createElement(ToastNotificationSnoozeMenu),
			DeeplinkConfirmationModal = state13 and React.createElement(DeeplinkConfirmationModal, {
				closeCallback = fn4
			})
		}
	)
end
