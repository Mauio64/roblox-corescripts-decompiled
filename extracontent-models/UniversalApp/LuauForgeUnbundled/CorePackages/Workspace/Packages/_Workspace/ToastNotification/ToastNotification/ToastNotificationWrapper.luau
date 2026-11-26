local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")

local touchEnabled = UserInputService.TouchEnabled

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Logger")
local toastNotificationHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/utils/toastNotificationHelper")
local toastNotificationSessionizationHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/utils/toastNotificationSessionizationHelper")

local NotificationsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/NotificationsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/UIBlox")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/Cryo")
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/AppCommonLib").IsVRAppBuild
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/AppCommonLib").isTenFootInterface
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/Responsive")
local usePreferredInput = Responsive.usePreferredInput
local useIsSpatial = Responsive.useIsSpatial
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ReactOtter")

local LifecycleEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/utils/LifecycleEvents")
local toastNotificationProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotificationsProtocol").ToastNotificationProtocol
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/SharedFlags")

local analyticsService = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/analytics/analyticsService")

local NotificationCardProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/context/NotificationCardProvider")
local module14 = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Components/NotificationCard")
local module15 = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Components/ToastNotificationSnoozeMenu")
local deeplinkConfirmationModal = NotificationsCommon.DeeplinkConfirmationModal
local SwipeDetectionWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Components/SwipeDetectionWrapper")
local ToastVRWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Components/ToastVRWrapper")
local ClientNotificationWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Components/ClientNotificationWrapper")
local useKeyCodeHold = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Components/useKeyCodeHold")
local module20 = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/type")
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/constants")
local joinExperience = NotificationsCommon.JoinExperience
local fFlagNotificationDeeplinkTapListenersEnabled = NotificationsCommon.FFlagNotificationDeeplinkTapListenersEnabled

local deeplinkTapListeners = if fFlagNotificationDeeplinkTapListenersEnabled then NotificationsCommon.DeeplinkTapListeners else nil

local springAnimatedItem = UIBlox.Utility.SpringAnimatedItem
local iconsnavigationclose = images["icons/navigation/close"]

local getFFlagEnableChatNewMessage = SharedFlags.GetFFlagEnableChatNewMessage
local engineFeature = game:GetEngineFeature("ClientToastNotificationsEnabled")

local defineFastFlag = game:DefineFastFlag("EnableClientToastNotificationsReducedMotion", false)
local defineFastFlag2 = game:DefineFastFlag("EnableNotificationsToastTTLFix", false)

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/ToastNotificationSnoozeManager").default
local getFStringPCGDKFilteredNotificationTypes = SharedFlags.GetFStringPCGDKFilteredNotificationTypes
local function GetIsFriendCommunicationRestricted()
	return ThirdPartyUserService
		and ThirdPartyUserService:IsChatRestrictionSupported()
		and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted
end

local getFFlagFilterSecurityAlertsVRToastEnabled = SharedFlags.GetFFlagFilterSecurityAlertsVRToastEnabled

local defineFastFlag3 = game:DefineFastFlag("EnableDisplayLoggingForToastsFix", false)

local ixpServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/IxpServiceWrapper").IXPServiceWrapper
local fFlagFriendshipNotifsUseSendrExperiment = SharedFlags.FFlagFriendshipNotifsUseSendrExperiment

local defineFastString = game:DefineFastString("FriendshipNotifsUseSendrLayerName", "Notification.Toast")
local defineFastString2 = game:DefineFastString("FRRToastPositionVariantKey", "frrToastPositionVariant")

local v5 = false
local success = nil
local result = nil

local function getFRRToastPositionVariant()
	if fFlagFriendshipNotifsUseSendrExperiment and not v5 then
		success, result = pcall(function()
			v5 = true
			return ixpServiceWrapper:GetLayerData(defineFastString)
		end)
	end

	if success and result then
		return result[defineFastString2]
	end

	return nil
end

local v6 = { frequency = 4, damping = 1 }

local getDeviceOrientation = toastNotificationHelper.getDeviceOrientation
local getNotificationSize = toastNotificationHelper.getNotificationSize
local marshalNotificationData = toastNotificationHelper.marshalNotificationData
local calculateToastPosition = toastNotificationHelper.calculateToastPosition
local isToastToRight = toastNotificationHelper.isToastToRight
local calculateTimeRemaining = toastNotificationHelper.calculateTimeRemaining

return function(p2)
	local v7 = p2.renderLocation == module20.RenderLocationEnum.CoreScript
	local desktopDevice = toastNotificationHelper.isDesktopDevice()

	local v8 = if v7 then constants.CardTopMargin.Experience else constants.CardTopMargin.App
	local default2 = toastNotificationProtocol.default

	local state, setState = React.useState(UserGameSettings.ReducedMotion)
	local state2, setState2 = React.useState(getNotificationSize(
		v7,
		workspace.CurrentCamera.ViewportSize.X
	))
	local state3, setState3 = React.useState(getDeviceOrientation(workspace.CurrentCamera.ViewportSize))

	local useState = React.useState
	local v9

	if fFlagFriendshipNotifsUseSendrExperiment then
		v9 = workspace.CurrentCamera.ViewportSize
	end

	local state4, setState4 = useState(v9)
	local state5, setState5 = React.useState(false)

	local state6, setState6 = React.useState(nil)

	local state7, setState7 = React.useState(nil)

	local state8, setState8 = React.useState(calculateToastPosition(
		false,
		isToastToRight(state3),
		v8,
		state
	))

	local state9, setState9 = React.useState(nil)
	local state10, setState10 = React.useState(nil)
	local state11, setState11 = React.useState(function()
		return v7 and workspace.CurrentCamera.ViewportSize.X < constants.CompactCardThreashold
	end)

	local state12, setState12 = React.useState(false)
	local state13, setState13 = React.useState(false)
	local state14, setState14 = React.useState(false)
	local ref = React.useRef(false)
	local state15, setState15 = React.useState(false)
	local state16, setState16 = React.useState(false)
	local state17, setState17 = React.useState(false)
	local state18, setState18 = React.useState({})
	local v10 = useIsSpatial()

	local v11 = usePreferredInput() == Responsive.Input.Directional

	local state19, setState19 = React.useState(false)

	local v14 = React.useMemo(function()
		return not v11 or state19 or state6 == nil
	end, { v11, state19, state6 })

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

	local v15 = React.useCallback(function()
		setState19(true)
	end, {})
	local v16 = useKeyCodeHold(
		Enum.KeyCode.ButtonSelect,
		constants.SIGNAL_HOLD_INTENT_SECONDS,
		constants.SIGNAL_HOLD_COMPLETE_SECONDS,
		v15,
		v14
	)

	local holdProgress = v16.holdProgress
	local holding = v16.holding

	local state20, setState20 = React.useState(Instance.new("BindableEvent"))
	local v17 = useStyle()

	local v18 = state15 or state16
	local userId = Players and Players.LocalPlayer and Players.LocalPlayer.UserId or nil

	local function fn(p3, userId2, data)
		if data == nil then
			return
		end

		Logger:info("NotificationType: {} with event: {}", data.notificationType, p3)

		local eventStream = analyticsService.EventStream

		toastNotificationSessionizationHelper(p3)

		local v19 = not (data and data.displayTimestamp) and 0
			or DateTime.now().UnixTimestampMillis - data.displayTimestamp

		local fireEvent = toastNotificationHelper.fireEvent

		local join = Cryo.Dictionary.join
		local v20 = {
			action_type = p3,
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
		local v21 = if data then data.notificationType or nil else nil
		v20.notification_type = v21
		local v22 = if data then data.id or nil else nil
		v20.notification_id = v22
		v20.recipient_userid = userId2 or nil
		local v23 = if v7 then game and game.GameId else nil
		v20.recipient_universe_id = v23

		local v24 = if v7 then constants.Destinations.Experience else constants.Destinations.App
		v20.client_destination = v24

		local v25 = if data then data.deliverTimestamp or nil else nil
		v20.deliver_timestamp = v25
		local v26 = if data and data.notificationType then default:isSnoozedNotificationType(data.notificationType) else false
		v20.snoozed = v26

		v20.time_to_action_timestamp = v19
		local v27

		if
			fFlagFriendshipNotifsUseSendrExperiment
			and data.notificationType == module20.NotificationTypeEnum.FriendRequestReceived
		then
			if fFlagFriendshipNotifsUseSendrExperiment and not v5 then
				success, result = pcall(function()
					v5 = true
					return ixpServiceWrapper:GetLayerData(defineFastString)
				end)
			end

			if success and result then
				v27 = result[defineFastString2]
			end
		end

		v20.frr_toast_position_variant = v27
		fireEvent(eventStream, join(v20, data and data.clientEventsPayload or {}))
	end

	React.useEffect(function()
		local changedConnection = UserGameSettings.Changed:Connect(function(p3)
			if p3 == "ReducedMotion" then
				local success2, result2 = pcall(function()
					return UserGameSettings[p3]
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

	local function fn2(p3)
		if not p3 then
			fn(module20.ToastNotificationActionsEnum.ModalCancel, userId, state6)
			setState13(false)
		end

		if state20 then
			fn(module20.ToastNotificationActionsEnum.ModalConfirm, userId, state6)
			state20:Fire(p3)
		end
	end

	local v19 = React.useCallback(function()
		if state9 then
			task.cancel(state9)
		end

		setState9(nil)
	end, { state9 })
	local v20

	if defineFastFlag2 then
		v20 = function(p3, duration, p4)
			v19()
			setState9((task.delay(duration, function()
				if ref.current then
					v19()
					return
				end

				fn(module20.ToastNotificationActionsEnum.Ignored, userId, p4)

				if engineFeature and p4 and p4.luaNotifInfo then
					GuiService:DismissNotification(p3)
					return
				end

				default2:dismissNotification(p3)

				setState7(nil)
				v19()
			end)))
		end
	else
		v20 = React.useCallback(function(p3, duration, p4)
			v19()
			setState9((task.delay(duration, function()
				if not state14 then
					fn(module20.ToastNotificationActionsEnum.Ignored, userId, p4)

					if engineFeature and p4 and p4.luaNotifInfo then
						GuiService:DismissNotification(p3)
						return
					end

					default2:dismissNotification(p3)

					setState7(nil)
					v19()
				end
			end)))
		end, { state14 })
	end

	local v21 = React.useCallback(function()
		if state6 and state7 and state7.id == state6.id then
			if engineFeature and state6.luaNotifInfo then
				GuiService:DismissNotification(state6.id)
				return
			end

			default2:dismissNotification(state6.id)
			setState7(nil)
			v19()
		end
	end, { state6, state7 })

	local function fn3()
		fn(module20.ToastNotificationActionsEnum.Dismissed, userId, state6)
		v21()
		setState16(false)
	end

	local v22 = React.useCallback(function()
		if v7 and state20 then
			setState13(true)
			return state20.Event:Wait()
		end

		return true
	end, { v7, state20 })

	local function fn4()
		if state6 and state7 and not state9 then
			local id = state6.id
			local v24 = state6
			local timeOnScreenMs = v24.state and v24.state.timeOnScreenMs

			v20(
				id,
				(timeOnScreenMs and timeOnScreenMs / 1000 or constants.DefaultNotificationDisplayTime) + 1,
				state6
			)
		end
	end

	local fn5 = defineFastFlag2 and function(p3, ...)
		if p3 then
			v19()
		elseif state6 and state7 and not state9 then
			local id = state6.id
			local v24 = state6
			local timeOnScreenMs = v24.state and v24.state.timeOnScreenMs

			v20(
				id,
				(timeOnScreenMs and timeOnScreenMs / 1000 or constants.DefaultNotificationDisplayTime) + 1,
				state6
			)
		end
	end or function(p3, callback, callback2)
		if p3 then
			callback()
		else
			callback2()
		end
	end

	local v23 = React.useCallback(function()
		for i, v24 in ipairs(state18) do
			task.cancel(v24)
		end
	end, { state18 })

	React.useEffect(function()
		return function()
			v23()
		end
	end, { v23 })

	local v24 = React.useCallback(function(data, p3, p4)
		if data.actionType == module20.ActionTypeEnum.Dismiss then
			v21()
		elseif data.actionType == module20.ActionTypeEnum.Deeplink then
			if v22() then
				if fFlagNotificationDeeplinkTapListenersEnabled and p4 then
					deeplinkTapListeners.notify({
						notificationType = p3 and p3.notificationType,
						notificationId = p3 and p3.id,
						url = data.path or "",
						source = "toast",
						isInExperience = v7
					})
				end

				if joinExperience(data.path or "", v7) then
					setState13(false)

					if p3 then
						default2:dismissNotification(p3.id)
					end
				else
					fn(module20.ToastNotificationActionsEnum.DeeplinkFailed, userId, p3)

					v21()
				end
			end
		elseif data.actionType == module20.ActionTypeEnum.VoltronBroadcast then
			local success2, result2 = pcall(function()
				return HttpService:JSONDecode(data.parameters)
			end)

			if success2 then
				default2:voltronBroadcast(data.messageId, result2)
			else
				Logger:warning("Invalid decoded payload for voltronBroadcast")
			end
		elseif
			data.actionType == module20.ActionTypeEnum.UpdateState
			and data.nextState ~= nil
			and data.nextState ~= ""
			and p3
			and p3.id
		then
			toastNotificationProtocol:updateNotification(p3.id, data.nextState)
		end
	end, { v21, v22 })

	local v25 = React.useCallback(function(data)
		local function executeAllActions(list)
			for i, item in ipairs(list) do
				v24(item, data)
			end
		end

		v23()

		if data.timers then
			local threads = {}

			for k, timer in pairs(data.timers) do
				local v26 = calculateTimeRemaining(
					timer,
					data.notificationReceivedTimestampMs,
					data.displayTimestamp
				)

				if v26 > 0 then
					table.insert(threads, (task.delay(v26 / 1000, function()
						local actions = timer.actions

						for i, action in ipairs(actions) do
							v24(action, data)
						end
					end)))
				else
					local actions = timer.actions

					for i, action in ipairs(actions) do
						v24(action, data)
					end
				end
			end

			if #threads > 0 then
				setState18(threads)
			end
		end
	end, { v24, v23, calculateTimeRemaining })

	local v26 = React.useCallback(function(data)
		if state12 then
			return
		end

		setState12(true)

		if data.eventName then
			fn(data.eventName, userId, state6)
		end

		if data.actionEventParams and state6 then
			LifecycleEvents:DispatchEvent(LifecycleEvents.ToastEvents.UserAction, state6.notificationType, {
				notificationData = state6,
				visualItem = data,
				userActionType = "click",
				parameters = data.actionEventParams
			})
		end

		if data.actions and #data.actions > 0 then
			for i, action in ipairs(data.actions) do
				v24(action, state6, fFlagNotificationDeeplinkTapListenersEnabled and true or nil)

				if action.actionType == module20.ActionTypeEnum.Deeplink and v22() then
					break
				end
			end
		end

		setState12(false)
	end, { state6, v21, state12, v22 })

	local function fn6(state21, p3)
		state21.displayTimestamp = DateTime.now().UnixTimestampMillis

		if
			getFStringPCGDKFilteredNotificationTypes()[state21.notificationType]
			and ThirdPartyUserService
			and ThirdPartyUserService:IsChatRestrictionSupported()
			and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted
		then
			default2:dismissNotification(state21.id)
		else
			local v27

			if p3 == "update" then
				v27 = module20.ToastNotificationActionsEnum.Update
			else
				v27 = module20.ToastNotificationActionsEnum.Display
			end

			if defineFastFlag3 then
				if default:isSnoozedNotificationType(state21.notificationType) then
					default2:dismissNotification(state21.id)
					return
				end

				fn(v27, userId, state21)
			else
				fn(v27, userId, state21)

				if default:isSnoozedNotificationType(state21.notificationType) then
					default2:dismissNotification(state21.id)
					return
				end
			end

			setState6(state21)
			local timeOnScreenMs = state21.state and state21.state.timeOnScreenMs

			local v28 = (timeOnScreenMs and timeOnScreenMs / 1000 or constants.DefaultNotificationDisplayTime) + 1

			v20(state21.id, v28, state21)

			if p3 == "display" then
				v25(state21)
			end

			if engineFeature and state21 and state21.luaNotifInfo then
				GuiService:OnNotificationDisplayed(state21.id)
			end

			setState10(nil)
		end
	end

	local v27 = React.useCallback(function(p3)
		if
			isTenFootInterface()
			and p3
			and p3.notificationType ~= nil
			and p3.notificationType ~= module20.NotificationTypeEnum.ClientNotification
		then
			return
		end

		if
			getFFlagFilterSecurityAlertsVRToastEnabled()
			and v10
			and p3
			and p3.notificationType ~= nil
			and p3.notificationType == module20.NotificationTypeEnum.SecurityAlert
		then
			return
		end

		if
			p3
			and p3.notificationType == module20.NotificationTypeEnum.ChatNewMessage
			and not getFFlagEnableChatNewMessage()
			and p3.content
			and p3.content.id
		then
			default2:dismissNotification(p3.content.id)
		else
			if not p3 or not p3.content or p3.content.id == nil then
				setState7(nil)

				return
			end

			local v28 = marshalNotificationData(p3)
			setState7(v28)
			LifecycleEvents:DispatchEvent(LifecycleEvents.ToastEvents.AttemptDisplay, v28.notificationType, v28)
		end
	end, {})

	React.useEffect(function()
		if state7 then
			if state6 and state6.id == state7.id then
				fn6(state7, "update")
				LifecycleEvents:DispatchEvent(LifecycleEvents.ToastEvents.Update, state7.notificationType, state7)
			else
				local v28 = constants.DisplayNotificationDelay

				if state7.luaNotifInfo ~= nil then
					v28 = not state6 and 0 or 1 / v6.frequency
				end

				local v29 = state7

				if state10 then
					task.cancel(state10)
				end

				setState10((task.delay(v28, function()
					fn6(v29, "display")
					LifecycleEvents:DispatchEvent(LifecycleEvents.ToastEvents.Display, v29.notificationType, v29)
				end)))
			end
		end
	end, { state7 })

	React.useEffect(function()
		local v28 = state7 and state6 and state7.id == state6.id and true or false

		setState5(v28)

		if v28 == false then
			setState19(false)
		end
	end, { state7, state6 })

	React.useEffect(function()
		local v28 = state5 and (state12 or state15 or state16 or state17 or state19 or holding)
		setState14(v28)

		if defineFastFlag2 then
			ref.current = v28
		end
	end, { state5, state12, state15, state16, state17, state19, holding })

	React.useEffect(function()
		if defineFastFlag2 then
			fn5(state14)
		else
			fn5(state14, v19, fn4)
		end
	end, { state14 })

	local v28, v29 = ReactOtter.useAnimatedBinding(1, function()
		if not state5 then
			setState6(nil)
			v23()
		end
	end)

	React.useEffect(function()
		v29(ReactOtter.spring(state5 and 0 or 1, v6))
	end, { state5, v29 })

	local useEffect = React.useEffect
	local function fn7()
		local v30

		if fFlagFriendshipNotifsUseSendrExperiment then
			local v31

			if
				state6
				and state6.notificationType == module20.NotificationTypeEnum.FriendRequestReceived
			then
				if fFlagFriendshipNotifsUseSendrExperiment and not v5 then
					success, result = pcall(function()
						v5 = true
						return ixpServiceWrapper:GetLayerData(defineFastString)
					end)
				end

				v31 = (if success and result then result[defineFastString2] else nil) == "legacyBottomRight"
					and "legacyBottomRight"
					or nil
			end

			v30 = calculateToastPosition(state5, isToastToRight(state3), v8, state, v31, state4)
		else
			v30 = calculateToastPosition(state5, isToastToRight(state3), v8, state)
		end

		setState8(v30)
	end

	local v31 = if fFlagFriendshipNotifsUseSendrExperiment then state6 else nil
	local v32 = if fFlagFriendshipNotifsUseSendrExperiment then v8 else nil
	useEffect(fn7, {
		state3,
		state5,
		state,
		v31,
		v32,
		if fFlagFriendshipNotifsUseSendrExperiment then state4 else nil
	})

	React.useEffect(function()
		local viewportSize = workspace.CurrentCamera.ViewportSize
		local deviceOrientation = getDeviceOrientation(viewportSize)
		setState2((getNotificationSize(v7, viewportSize.X)))
		setState11(v7 and workspace.CurrentCamera.ViewportSize.X < constants.CompactCardThreashold)
		setState3(deviceOrientation)

		local viewportSizeChangedConnection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			local viewportSize2 = workspace.CurrentCamera.ViewportSize
			local deviceOrientation2 = getDeviceOrientation(viewportSize2)
			setState2((getNotificationSize(v7, viewportSize2.X)))
			setState11(v7 and workspace.CurrentCamera.ViewportSize.X < constants.CompactCardThreashold)
			setState3(deviceOrientation2)

			if fFlagFriendshipNotifsUseSendrExperiment then
				setState4(workspace.CurrentCamera.ViewportSize)
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

			if v7 then
				desktops = { module20.ChannelListEnum.Experience, module20.ChannelListEnum.Dual }
			else
				desktops = { module20.ChannelListEnum.App, module20.ChannelListEnum.Dual }
			end

			if desktopDevice then
				table.insert(desktops, module20.ChannelListEnum.Desktop)
			end

			default2:setupNotifications(desktops)
		end)
	end, {})

	React.useEffect(function()
		local connection = default2:listenToDisplayNotification(v27)
		return function()
			if connection then
				connection:Disconnect()
			end
		end
	end, { v27 })

	local vrAppBuild = isVRAppBuild()
	local v34 = state5 or not vrAppBuild
	local v35 = v18 and not touchEnabled and not vrAppBuild and state5
	local element = React.createElement("TextButton", {
		ZIndex = 2,
		LayoutOrder = 1,
		AnchorPoint = Vector2.new(0, 0),
		Size = UDim2.new(0, constants.CardSizeDefault.closeButton, 0, constants.CardSizeDefault.closeButton),
		Position = UDim2.new(0, -10, 0, -10),
		BackgroundTransparency = v17.Theme.BackgroundUIDefault.Transparency,
		BackgroundColor3 = v17.Theme.BackgroundUIDefault.Color,
		Text = "",
		[React.Event.Activated] = fn3,
		[React.Event.MouseEnter] = function()
			setState16(true)
		end,
		[React.Event.MouseLeave] = function()
			setState16(false)
		end
	}, {
		Border = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = v17.Theme.UIDefault.Color
		}),
		UICorner = React.createElement("UICorner", {
			CornerRadius = constants.DefaultCardCloseButtonCornerRadius
		}),
		CloseButtonIcon = React.createElement(imageSetLabel, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, constants.CardSizeDefault.closeIcon, 0, constants.CardSizeDefault.closeIcon),
			Image = iconsnavigationclose,
			ImageColor3 = v17.Theme.SystemPrimaryDefault.Color
		})
	})

	local v37 = React.useMemo(function()
		local createElement2 = React.createElement
		local animatedFrame = springAnimatedItem.AnimatedFrame
		local v38 = {
			regularProps = {
				ClipsDescendants = false,
				Size = state2,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Active = true,
				Visible = v34 and state6 ~= nil,
				[React.Event.MouseEnter] = function()
					fn(module20.ToastNotificationActionsEnum.Hover, userId, state6)

					setState15(true)
				end,
				[React.Event.MouseLeave] = function()
					setState15(false)
				end
			},
			animatedValues = state8,
			springOptions = v6,
			mapValuesToProps = function(data)
				local v41 = if vrAppBuild then UDim2.new(0.5, 0, 0.5, 0) else UDim2.new(
					data.positionX,
					data.positionXOffset,
					data.positionY,
					data.positionYOffset
				)

				local v42 = if vrAppBuild then Vector2.new(0.5, 0.5) else Vector2.new(data.anchorX, data.anchorY)
				return { Position = v41, AnchorPoint = v42 }
			end,
			onComplete = function()
				if not state5 then
					setState6(nil)
					v23()
				end
			end
		}

		local createElement3 = React.createElement
		local v42 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			swipeEnabled = state5,
			swipeCallback = function(p3)
				if p3 == Enum.SwipeDirection.Up or p3 == Enum.SwipeDirection.Right then
					fn(module20.ToastNotificationActionsEnum.Dismissed, userId, state6)
					v21()
					setState16(false)
				end
			end
		}
		local v44

		if engineFeature and state6 and state6.luaNotifInfo and state6.id then
			v44 = React.createElement(ClientNotificationWrapper, {
				notificationInfo = state6.luaNotifInfo,
				notificationId = state6.id,
				onPause = setState17,
				onHover = setState15,
				transparency = if defineFastFlag then v28 else nil,
				width = state2.X
			}, {
				ToastCloseButton = if v35 then element else nil
			})
		else
			local createElement4 = React.createElement
			local v46 = {
				state = state6 and state6.state,
				isCompact = state11,
				handleActions = v26,
				notificationReceivedTimestampMs = state6 and state6.notificationReceivedTimestampMs,
				timers = state6 and state6.timers,
				displayTimestampMs = state6 and state6.displayTimestamp
			}

			local v48 = if state6 then React.createElement("CanvasGroup", {
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = state2,
				BackgroundTransparency = 1,
				GroupTransparency = v28,
				LayoutOrder = 2
			}, {
				NotificationCard = React.createElement(module14, {
					isHover = v18,
					shouldAutoFocus = state19,
					showHoldButton = v11,
					holdProgress = holdProgress
				})
			}) else nil
			v44 = createElement4(NotificationCardProvider, v46, {
				NotificationCardCanvasGroup = v48,
				ToastCloseButton = if v35 then element else nil
			})
		end

		return createElement2(animatedFrame, v38, {
			SwipeDetector = createElement3(SwipeDetectionWrapper, v42, { NotificationProvider = v44 })
		})
	end, {
		constants,
		v17,
		state6,
		v34,
		state5,
		state11,
		v35,
		v18,
		state8,
		fn3,
		setState15,
		setState16,
		v26
	})

	if vrAppBuild then
		return React.createElement(ToastVRWrapper, {
			isConfirmModalOpen = state13,
			isToastOpen = state5,
			isCoreScript = v7,
			ToastComponent = v37,
			ToastNotificationSnoozeMenu = React.createElement(module15),
			ConfirmationModalComponent = React.createElement(deeplinkConfirmationModal, {
				closeCallback = fn2,
				backgroundTransparency = 1
			})
		})
	end

	return React.createElement(
		"ScreenGui",
		{
			DisplayOrder = p2.displayOrder,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			IgnoreGuiInset = true
		},
		{
			Toast = v37,
			ToastNotificationSnoozeMenu = React.createElement(module15),
			DeeplinkConfirmationModal = state13 and React.createElement(deeplinkConfirmationModal, {
				closeCallback = fn2
			})
		}
	)
end
