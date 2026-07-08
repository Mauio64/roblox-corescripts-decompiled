local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local TouchEnabled = UserInputService.TouchEnabled
local scriptParent = script.Parent
local Components = scriptParent.Components
local context = scriptParent.context
local utils = scriptParent.utils
local Logger = require(scriptParent.Logger)
local toastNotificationHelper = require(utils.toastNotificationHelper)
local toastNotificationSessionizationHelper = require(utils.toastNotificationSessionizationHelper)
local scriptParentParent = scriptParent.Parent
local NotificationsCommon = require(scriptParentParent.NotificationsCommon)
local React = require(scriptParentParent.React)
local UIBlox = require(scriptParentParent.UIBlox)
local Cryo = require(scriptParentParent.Cryo)
local IsVRAppBuild = require(scriptParentParent.AppCommonLib).IsVRAppBuild
local Responsive = require(scriptParentParent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local useIsSpatial = Responsive.useIsSpatial
local ReactOtter = require(scriptParentParent.ReactOtter)
local LifecycleEvents = require(script.Parent.utils.LifecycleEvents)
local ToastNotificationProtocol = require(scriptParentParent.ToastNotificationsProtocol).ToastNotificationProtocol
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local SharedFlags = require(scriptParentParent.SharedFlags)
local analyticsService = require(scriptParent.analytics.analyticsService)
local NotificationCardProvider = require(context.NotificationCardProvider)
local NotificationCard = require(Components.NotificationCard)
local ToastNotificationSnoozeMenu = require(Components.ToastNotificationSnoozeMenu)
local DeeplinkConfirmationModal = NotificationsCommon.DeeplinkConfirmationModal
local SwipeDetectionWrapper = require(Components.SwipeDetectionWrapper)
local ToastVRWrapper = require(Components.ToastVRWrapper)
local ClientNotificationWrapper = require(Components.ClientNotificationWrapper)
local useKeyCodeHold = require(Components.useKeyCodeHold)
local type = require(scriptParent.type)
local constants = require(scriptParent.constants)
local JoinExperience = NotificationsCommon.JoinExperience
local SpringAnimatedItem = UIBlox.Utility.SpringAnimatedItem
local v44 = Images["icons/navigation/close"]
local GetFFlagEnableChatNewMessage = SharedFlags.GetFFlagEnableChatNewMessage
local EngineFeature = game:GetEngineFeature("ClientToastNotificationsEnabled")
local v47 = game:DefineFastFlag("EnableClientToastNotificationsReducedMotion", false)
local v48 = game:DefineFastFlag("EnableNotificationsToastTTLFix", false)
local default = require(scriptParent.ToastNotificationSnoozeManager).default
local GetFStringPCGDKFilteredNotificationTypes = SharedFlags.GetFStringPCGDKFilteredNotificationTypes

local function GetIsFriendCommunicationRestricted() -- line: 61
	-- upvalues: ThirdPartyUserService (copy)
	return ThirdPartyUserService and (ThirdPartyUserService:IsChatRestrictionSupported() and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted)
end

local GetFFlagFilterSecurityAlertsVRToastEnabled = SharedFlags.GetFFlagFilterSecurityAlertsVRToastEnabled
local v53 = game:DefineFastFlag("EnableDisplayLoggingForToastsFix", false)
local IXPServiceWrapper = require(scriptParentParent.IXPServiceWrapper).IXPServiceWrapper
local FFlagFriendshipNotifsUseSendrExperiment = SharedFlags.FFlagFriendshipNotifsUseSendrExperiment
local v56 = game:DefineFastString("FriendshipNotifsUseSendrLayerName", "Notification.Toast")
local v57 = game:DefineFastString("FRRToastPositionVariantKey", "frrToastPositionVariant")
local u58 = false
local u59 = nil
local u60 = nil

local function getFRRToastPositionVariant() -- line: 82
	-- upvalues: FFlagFriendshipNotifsUseSendrExperiment (copy), u58 (ref), u59 (ref), u60 (ref), IXPServiceWrapper (copy), v56 (copy), v57 (copy)
	if FFlagFriendshipNotifsUseSendrExperiment and not u58 then
		local ok, result = pcall(function() -- line: 84
			-- upvalues: u58 (ref), IXPServiceWrapper (copy), v56 (copy)
			u58 = true

			return IXPServiceWrapper:GetLayerData(v56)
		end)

		u59 = ok
		u60 = result
	end

	if u59 and u60 then
		return u60[v57]
	end

	return nil
end

local t1 = {
	frequency = 4,
	damping = 1
}
local getDeviceOrientation = toastNotificationHelper.getDeviceOrientation
local getNotificationSize = toastNotificationHelper.getNotificationSize
local marshalNotificationData = toastNotificationHelper.marshalNotificationData
local calculateToastPosition = toastNotificationHelper.calculateToastPosition
local isToastToRight = toastNotificationHelper.isToastToRight
local calculateTimeRemaining = toastNotificationHelper.calculateTimeRemaining

return function(t2: {[any]: any}) -- line: 115
	-- upvalues: type (copy), toastNotificationHelper (copy), constants (copy), ToastNotificationProtocol (copy), React (copy), UserGameSettings (copy), getNotificationSize (copy), getDeviceOrientation (copy), FFlagFriendshipNotifsUseSendrExperiment (copy), calculateToastPosition (copy), isToastToRight (copy), useIsSpatial (copy), usePreferredInput (copy), Responsive (copy), UserInputService (copy), useKeyCodeHold (copy), useStyle (copy), Players (copy), Logger (copy), analyticsService (copy), toastNotificationSessionizationHelper (copy), Cryo (copy), default (copy), u58 (ref), u59 (ref), u60 (ref), IXPServiceWrapper (copy), v56 (copy), v57 (copy), v48 (copy), EngineFeature (copy), GuiService (copy), JoinExperience (copy), HttpService (copy), calculateTimeRemaining (copy), LifecycleEvents (copy), GetFStringPCGDKFilteredNotificationTypes (copy), ThirdPartyUserService (copy), v53 (copy), GetFFlagFilterSecurityAlertsVRToastEnabled (copy), GetFFlagEnableChatNewMessage (copy), marshalNotificationData (copy), t1 (copy), ReactOtter (copy), IsVRAppBuild (copy), TouchEnabled (copy), ImageSetLabel (copy), v44 (copy), SpringAnimatedItem (copy), SwipeDetectionWrapper (copy), ClientNotificationWrapper (copy), v47 (copy), NotificationCardProvider (copy), NotificationCard (copy), ToastVRWrapper (copy), ToastNotificationSnoozeMenu (copy), DeeplinkConfirmationModal (copy)
	local v72 = t2.renderLocation == type.RenderLocationEnum.CoreScript
	local v73 = toastNotificationHelper.isDesktopDevice()
	local v74 = if not v72 then constants.CardTopMargin.App else constants.CardTopMargin.Experience
	local default2 = ToastNotificationProtocol.default
	local v76, v77 = React.useState(UserGameSettings.ReducedMotion)
	local v78, v79 = React.useState(getNotificationSize(v72, workspace.CurrentCamera.ViewportSize.X))
	local v80, v81 = React.useState(getDeviceOrientation(workspace.CurrentCamera.ViewportSize))
	local v82, v83 = React.useState(if not FFlagFriendshipNotifsUseSendrExperiment then nil else workspace.CurrentCamera.ViewportSize)
	local v84, v85 = React.useState(false)
	local v86, v87 = React.useState(nil)
	local v88, v89 = React.useState(nil)
	local v90, v91 = React.useState(calculateToastPosition(false, isToastToRight(v80), v74, v76))
	local v92, v93 = React.useState(nil)
	local v94, v95 = React.useState(nil)
	local v96, v97 = React.useState(function() -- line: 148
		-- upvalues: v72 (copy), constants (copy)
		return v72 and workspace.CurrentCamera.ViewportSize.X < constants.CompactCardThreashold
	end)
	local v98, v99 = React.useState(false)
	local v100, v101 = React.useState(false)
	local v102, v103 = React.useState(false)
	local v104 = React.useRef(false)
	local v105, v106 = React.useState(false)
	local v107, v108 = React.useState(false)
	local v109, v110 = React.useState(false)
	local v111, v112 = React.useState({})
	local v113 = useIsSpatial()
	local v114 = usePreferredInput() == Responsive.Input.Directional
	local v115, v116 = React.useState(false)
	local u117 = v115
	local u118 = v116
	local v119 = React.useMemo(function() -- line: 167
		-- upvalues: v114 (copy), u117 (ref), v86 (copy)
		return not v114 or (u117 or v86 == nil)
	end, {
		v114,
		u117,
		v86
	})

	React.useEffect(function() -- line: 172
		-- upvalues: u117 (ref), UserInputService (copy), u118 (ref)
		if not u117 then
			return
		end

		local connection = UserInputService.InputBegan:Connect(function(input, gameProcessed) -- line: 177
			-- upvalues: u118 (ref)
			if gameProcessed then
				return
			end

			if input.KeyCode == Enum.KeyCode.ButtonB then
				u118(false)
			end
		end)

		return function() -- line: 187
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { u117 })

	local v120 = React.useCallback(function() -- line: 193
		-- upvalues: u118 (ref)
		u118(true)
	end, {})
	local v121 = useKeyCodeHold(Enum.KeyCode.ButtonSelect, constants.SIGNAL_HOLD_INTENT_SECONDS, constants.SIGNAL_HOLD_COMPLETE_SECONDS, v120, v119)
	local holdProgress = v121.holdProgress
	local holding = v121.holding
	local v124, v125 = React.useState((Instance.new("BindableEvent")))
	local v126 = useStyle()
	local v127 = v105 or v107
	local v128 = Players and (not not Players.LocalPlayer and Players.LocalPlayer.UserId) or nil

	local function v129(s1: string, p1, p2) -- line: 226
		-- upvalues: Logger (copy), analyticsService (copy), toastNotificationSessionizationHelper (copy), toastNotificationHelper (copy), Cryo (copy), constants (copy), v72 (copy), default (copy), FFlagFriendshipNotifsUseSendrExperiment (copy), type (copy), u58 (ref), u59 (ref), u60 (ref), IXPServiceWrapper (copy), v56 (copy), v57 (copy)
		if p2 == nil then
			return
		end

		Logger:info("NotificationType: {} with event: {}", p2.notificationType, s1)

		local EventStream = analyticsService.EventStream

		toastNotificationSessionizationHelper(s1)

		local n1 = 0

		if p2 and p2.displayTimestamp then
			n1 = DateTime.now().UnixTimestampMillis - p2.displayTimestamp
		end

		local fireEvent = toastNotificationHelper.fireEvent
		local join = Cryo.Dictionary.join
		local t3 = {
			action_type = s1,
			delivery_channel = constants.DeliveryChannel,
			notification_type = p2 and p2.notificationType or nil,
			notification_id = p2 and p2.id or nil,
			recipient_userid = p1 or nil,
			recipient_universe_id = if not v72 then nil else game and game.GameId,
			client_destination = if not v72 then constants.Destinations.App else constants.Destinations.Experience,
			deliver_timestamp = p2 and p2.deliverTimestamp or nil,
			snoozed = not not p2 and (not not p2.notificationType and default:isSnoozedNotificationType(p2.notificationType)),
			time_to_action_timestamp = n1
		}
		local v167

		if FFlagFriendshipNotifsUseSendrExperiment and p2.notificationType == type.NotificationTypeEnum.FriendRequestReceived then
			if FFlagFriendshipNotifsUseSendrExperiment and not u58 then
				local ok, result = pcall(function() -- line: 84
					-- upvalues: u58 (ref), IXPServiceWrapper (copy), v56 (copy)
					u58 = true

					return IXPServiceWrapper:GetLayerData(v56)
				end)

				u59 = ok
				u60 = result
			end

			v167 = if not u59 or not u60 then nil else u60[v57]
		else
			v167 = nil
		end

		t3.frr_toast_position_variant = v167
		fireEvent(EventStream, join(t3, p2 and p2.clientEventsPayload or {}))
	end

	React.useEffect(function() -- line: 273
		-- upvalues: UserGameSettings (copy), v77 (copy)
		local connection = UserGameSettings.Changed:Connect(function(property) -- line: 274
			-- upvalues: UserGameSettings (copy), v77 (copy)
			if property == "ReducedMotion" then
				local ok, result = pcall(function() -- line: 276
					-- upvalues: UserGameSettings (copy), property (copy)
					return UserGameSettings[property]
				end)

				if ok then
					v77(result)
				end
			end
		end)

		return function() -- line: 286
			-- upvalues: connection (copy)
			if connection then
				connection:Disconnect()
			end
		end
	end, {
		v77,
		UserGameSettings
	})

	local function v130(b1: boolean) -- line: 293
		-- upvalues: v129 (copy), type (copy), v128 (copy), v86 (copy), v101 (copy), v124 (copy)
		if not b1 then
			v129(type.ToastNotificationActionsEnum.ModalCancel, v128, v86)
			v101(false)
		end

		if v124 then
			v129(type.ToastNotificationActionsEnum.ModalConfirm, v128, v86)
			v124:Fire(b1)
		end
	end

	local v131 = React.useCallback(function() -- line: 304
		-- upvalues: v92 (copy), v93 (copy)
		if v92 then
			task.cancel(v92)
		end

		v93(nil)
	end, { v92 })
	local u132 = if not v48 then React.useCallback(function(s2: string, n2: number, p3) -- line: 357
		-- upvalues: v131 (copy), v102 (copy), v129 (copy), type (copy), v128 (copy), EngineFeature (copy), GuiService (copy), default2 (copy), v89 (copy), v93 (copy)
		v131()

		local thread = task.delay(n2, function() -- line: 359
			-- upvalues: v102 (copy), v129 (copy), type (copy), v128 (copy), p3 (copy), EngineFeature (copy), GuiService (copy), s2 (copy), default2 (copy), v89 (copy), v131 (copy)
			if not v102 then
				v129(type.ToastNotificationActionsEnum.Ignored, v128, p3)

				if EngineFeature and p3 and p3.luaNotifInfo then
					GuiService:DismissNotification(s2)

					return
				end

				local v249 = s2

				default2:dismissNotification(v249)
				v89(nil)
				v131()
			end
		end)

		v93(thread)
	end, { v102 }) else function(s3: string, n3: number, p4) -- line: 331
		-- upvalues: v131 (copy), v104 (copy), v129 (copy), type (copy), v128 (copy), EngineFeature (copy), GuiService (copy), default2 (copy), v89 (copy), v93 (copy)
		v131()

		local thread = task.delay(n3, function() -- line: 337
			-- upvalues: v104 (copy), v131 (copy), v129 (copy), type (copy), v128 (copy), p4 (copy), EngineFeature (copy), GuiService (copy), s3 (copy), default2 (copy), v89 (copy)
			if v104.current then
				v131()

				return
			end

			v129(type.ToastNotificationActionsEnum.Ignored, v128, p4)

			if EngineFeature and p4 and p4.luaNotifInfo then
				GuiService:DismissNotification(s3)

				return
			end

			local v248 = s3

			default2:dismissNotification(v248)
			v89(nil)
			v131()
		end)

		v93(thread)
	end
	local v133 = React.useCallback(function() -- line: 380
		-- upvalues: v86 (copy), v88 (copy), EngineFeature (copy), GuiService (copy), default2 (copy), v89 (copy), v131 (copy)
		if v86 and (v88 and v88.id == v86.id) then
			if EngineFeature and v86.luaNotifInfo then
				GuiService:DismissNotification(v86.id)

				return
			end

			local id = v86.id

			default2:dismissNotification(id)
			v89(nil)
			v131()
		end
	end, {
		v86,
		v88
	})

	local function v134() -- line: 397
		-- upvalues: v129 (copy), type (copy), v128 (copy), v86 (copy), v133 (copy), v108 (copy)
		v129(type.ToastNotificationActionsEnum.Dismissed, v128, v86)
		v133()
		v108(false)
	end

	local v135 = React.useCallback(function() -- line: 404
		-- upvalues: v72 (copy), v124 (copy), v101 (copy)
		if v72 and v124 then
			v101(true)

			return v124.Event:Wait()
		end

		return true
	end, {
		v72,
		v124
	})

	local function v136() -- line: 418
		-- upvalues: v86 (copy), v88 (copy), v92 (copy), u132 (ref), constants (copy)
		if v86 and (v88 and not v92) then
			local v182 = u132
			local id = v86.id
			local v184 = v86
			local v185 = v184.state and v184.state.timeOnScreenMs

			if v185 then
				v185 /= 1000
			end

			v182(id, (v185 or constants.DefaultNotificationDisplayTime) + 1, v86)
		end
	end

	local u137 = not v48 and function(b2: boolean, p5: ((...any) -> ...any), p6: ((...any) -> ...any)) -- line: 441
		if b2 then
			p5()

			return
		end

		p6()
	end or function(b3: boolean, ...) -- line: 432
		-- upvalues: v131 (copy), v86 (copy), v88 (copy), v92 (copy), u132 (ref), constants (copy)
		if b3 then
			v131()

			return
		end

		if v86 and v88 and not v92 then
			local v187 = u132
			local id = v86.id
			local v189 = v86
			local v190 = v189.state and v189.state.timeOnScreenMs

			if v190 then
				v190 /= 1000
			end

			v187(id, (v190 or constants.DefaultNotificationDisplayTime) + 1, v86)
		end
	end
	local v138 = React.useCallback(function() -- line: 451
		-- upvalues: v111 (copy)
		for _, v in ipairs(v111) do
			task.cancel(v)
		end
	end, { v111 })

	React.useEffect(function() -- line: 457
		-- upvalues: v138 (copy)
		return function() -- line: 460
			-- upvalues: v138 (copy)
			v138()
		end
	end, { v138 })

	local v139 = React.useCallback(function(p7, p8) -- line: 466
		-- upvalues: type (copy), v133 (copy), v135 (copy), JoinExperience (copy), v72 (copy), v101 (copy), default2 (copy), v129 (copy), v128 (copy), HttpService (copy), Logger (copy), ToastNotificationProtocol (copy)
		if p7.actionType == type.ActionTypeEnum.Dismiss then
			v133()

			return
		end

		if p7.actionType == type.ActionTypeEnum.Deeplink then
			if v135() then
				if not JoinExperience(p7.path or "", v72) then
					v129(type.ToastNotificationActionsEnum.DeeplinkFailed, v128, p8)
					v133()

					return
				end

				v101(false)

				if p8 then
					local id = p8.id

					default2:dismissNotification(id)

					return
				end
			end
		else
			if p7.actionType == type.ActionTypeEnum.VoltronBroadcast then
				local ok, result = pcall(function() -- line: 493
					-- upvalues: HttpService (copy), p7 (copy)
					return HttpService:JSONDecode(p7.parameters)
				end)

				if ok then
					default2:voltronBroadcast(p7.messageId, result)

					return
				end

				Logger:warning("Invalid decoded payload for voltronBroadcast")

				return
			end

			if p7.actionType == type.ActionTypeEnum.UpdateState and p7.nextState ~= nil and p7.nextState ~= "" and p8 and p8.id then
				ToastNotificationProtocol:updateNotification(p8.id, p7.nextState)
			end
		end
	end, {
		v133,
		v135
	})
	local v140 = React.useCallback(function(p9) -- line: 522
		-- upvalues: v139 (copy), v138 (copy), calculateTimeRemaining (copy), v112 (copy)
		local function executeAllActions(t4: {[any]: any}) -- line: 523
			-- upvalues: v139 (copy), p9 (copy)
			for _, v in ipairs(t4) do
				v139(v, p9)
			end
		end

		v138()

		if p9.timers then
			local t5 = {}

			for _, v in pairs(p9.timers) do
				local v206 = calculateTimeRemaining(v, p9.notificationReceivedTimestampMs, p9.displayTimestamp)

				if v206 > 0 then
					table.insert(t5, (task.delay(v206 / 1000, function() -- line: 539
						-- upvalues: v (copy), v139 (copy), p9 (copy)
						local actions = v.actions

						for _, v2 in ipairs(actions) do
							v139(v2, p9)
						end
					end)))
				else
					local actions = v.actions

					for _, v3 in ipairs(actions) do
						v139(v3, p9)
					end
				end
			end

			if #t5 > 0 then
				v112(t5)
			end
		end
	end, {
		v139,
		v138,
		calculateTimeRemaining
	})
	local v141 = React.useCallback(function(p10) -- line: 555
		-- upvalues: v98 (copy), v99 (copy), v129 (copy), v128 (copy), v86 (copy), LifecycleEvents (copy), v139 (copy), type (copy), v135 (copy)
		if v98 then
			return
		end

		v99(true)

		if p10.eventName then
			v129(p10.eventName, v128, v86)
		end

		if p10.actionEventParams and v86 then
			LifecycleEvents:DispatchEvent(LifecycleEvents.ToastEvents.UserAction, v86.notificationType, {
				userActionType = "click",
				notificationData = v86,
				visualItem = p10,
				parameters = p10.actionEventParams
			})
		end

		if p10.actions and #p10.actions > 0 then
			for _, v in ipairs(p10.actions) do
				v139(v, v86)

				if v.actionType == type.ActionTypeEnum.Deeplink and v135() then
					break
				end
			end
		end

		v99(false)
	end, {
		v86,
		v133,
		v98,
		v135
	})

	local function v142(p11, p12) -- line: 597
		-- upvalues: GetFStringPCGDKFilteredNotificationTypes (copy), ThirdPartyUserService (copy), default2 (copy), type (copy), v53 (copy), default (copy), v129 (copy), v128 (copy), v87 (copy), constants (copy), u132 (ref), v140 (copy), EngineFeature (copy), GuiService (copy), v95 (copy)
		p11.displayTimestamp = DateTime.now().UnixTimestampMillis

		if GetFStringPCGDKFilteredNotificationTypes()[p11.notificationType] and (ThirdPartyUserService and (ThirdPartyUserService:IsChatRestrictionSupported() and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted)) then
			local id = p11.id

			default2:dismissNotification(id)

			return
		end

		local v216 = if p12 ~= "update" then type.ToastNotificationActionsEnum.Display else type.ToastNotificationActionsEnum.Update

		if v53 then
			if default:isSnoozedNotificationType(p11.notificationType) then
				local id = p11.id

				default2:dismissNotification(id)

				return
			end

			v129(v216, v128, p11)
		else
			v129(v216, v128, p11)

			if default:isSnoozedNotificationType(p11.notificationType) then
				local id = p11.id

				default2:dismissNotification(id)

				return
			end
		end

		v87(p11)

		local v219 = p11.state and p11.state.timeOnScreenMs

		if v219 then
			v219 /= 1000
		end

		local v220 = (v219 or constants.DefaultNotificationDisplayTime) + 1

		u132(p11.id, v220, p11)

		if p12 == "display" then
			v140(p11)
		end

		if EngineFeature and p11 and p11.luaNotifInfo then
			GuiService:OnNotificationDisplayed(p11.id)
		end

		v95(nil)
	end

	local v143 = React.useCallback(function(p13) -- line: 655
		-- upvalues: GuiService (copy), type (copy), GetFFlagFilterSecurityAlertsVRToastEnabled (copy), v113 (copy), GetFFlagEnableChatNewMessage (copy), default2 (copy), marshalNotificationData (copy), v89 (copy), LifecycleEvents (copy)
		if GuiService:IsTenFootInterface() and (p13 and p13.notificationType ~= nil and p13.notificationType ~= type.NotificationTypeEnum.ClientNotification) then
			return
		end

		if GetFFlagFilterSecurityAlertsVRToastEnabled() and v113 and p13 and p13.notificationType ~= nil and p13.notificationType == type.NotificationTypeEnum.SecurityAlert then
			return
		end

		if p13 and p13.notificationType == type.NotificationTypeEnum.ChatNewMessage and not GetFFlagEnableChatNewMessage() and p13.content and p13.content.id then
			local id = p13.content.id

			default2:dismissNotification(id)

			return
		end

		if p13 and p13.content and p13.content.id ~= nil then
			local v226 = marshalNotificationData(p13)

			v89(v226)
			LifecycleEvents:DispatchEvent(LifecycleEvents.ToastEvents.AttemptDisplay, v226.notificationType, v226)

			return
		end

		v89(nil)
	end, {})

	React.useEffect(function() -- line: 707
		-- upvalues: v88 (copy), v86 (copy), v142 (copy), LifecycleEvents (copy), constants (copy), t1 (copy), v94 (copy), v95 (copy)
		if v88 then
			if v86 and v86.id == v88.id then
				v142(v88, "update")
				LifecycleEvents:DispatchEvent(LifecycleEvents.ToastEvents.Update, v88.notificationType, v88)

				return
			end

			local DisplayNotificationDelay = constants.DisplayNotificationDelay

			if v88.luaNotifInfo ~= nil then
				DisplayNotificationDelay = not v86 and 0 or 1 / t1.frequency
			end

			local v228 = v88

			if v94 then
				task.cancel(v94)
			end

			local thread = task.delay(DisplayNotificationDelay, function() -- line: 648
				-- upvalues: v142 (copy), v228 (copy), LifecycleEvents (copy)
				v142(v228, "display")
				LifecycleEvents:DispatchEvent(LifecycleEvents.ToastEvents.Display, v228.notificationType, v228)
			end)

			v95(thread)
		end
	end, { v88 })
	React.useEffect(function() -- line: 738
		-- upvalues: v88 (copy), v86 (copy), v85 (copy), u118 (ref)
		local v230 = not not v88 and (not not v86 and (v88.id == v86.id or false))

		v85(v230)

		if v230 == false then
			u118(false)
		end
	end, {
		v88,
		v86
	})
	React.useEffect(function() -- line: 755
		-- upvalues: v84 (copy), v98 (copy), v105 (copy), v107 (copy), v109 (copy), u117 (ref), holding (copy), v103 (copy), v48 (copy), v104 (copy)
		local v231 = v84 and (v98 or (v105 or (v107 or (v109 or (u117 or holding)))))

		v103(v231)

		if v48 then
			v104.current = v231
		end
	end, {
		v84,
		v98,
		v105,
		v107,
		v109,
		u117,
		holding
	})
	React.useEffect(function() -- line: 784
		-- upvalues: v48 (copy), u137 (ref), v102 (copy), v131 (copy), v136 (copy)
		if v48 then
			u137(v102)

			return
		end

		u137(v102, v131, v136)
	end, { v102 })

	local v144, v145 = ReactOtter.useAnimatedBinding(1, function() -- line: 793
		-- upvalues: v84 (copy), v87 (copy), v138 (copy)
		if not v84 then
			v87(nil)
			v138()
		end
	end)

	React.useEffect(function() -- line: 800
		-- upvalues: v145 (copy), ReactOtter (copy), v84 (copy), t1 (copy)
		v145(ReactOtter.spring(not v84 and 1 or 0, t1))
	end, {
		v84,
		v145
	})
	React.useEffect(function() -- line: 806
		-- upvalues: FFlagFriendshipNotifsUseSendrExperiment (copy), v86 (copy), type (copy), u58 (ref), u59 (ref), u60 (ref), IXPServiceWrapper (copy), v56 (copy), v57 (copy), calculateToastPosition (copy), v84 (copy), isToastToRight (copy), v80 (copy), v74 (copy), v76 (copy), v82 (copy), v91 (copy)
		local g233 = nil
		local g234 = nil
		local s4 = nil
		local v232 = nil

		if not FFlagFriendshipNotifsUseSendrExperiment then
			v232 = calculateToastPosition(v84, isToastToRight(v80), v74, v76)
			g233 = true
		end

		repeat
			if g233 or (g234 or v86 and v86.notificationType == type.NotificationTypeEnum.FriendRequestReceived) then
				if not g233 then
					if not g234 then
						if FFlagFriendshipNotifsUseSendrExperiment and not u58 then
							local ok, result = pcall(function() -- line: 84
								-- upvalues: u58 (ref), IXPServiceWrapper (copy), v56 (copy)
								u58 = true

								return IXPServiceWrapper:GetLayerData(v56)
							end)

							u59 = ok
							u60 = result
						end
					end
				end

				if g233 or (g234 or ((if not u59 or not u60 then nil else u60[v57])) == "legacyBottomRight") then
					if not g233 then
						if not g234 then
							s4 = "legacyBottomRight"
						end

						g234 = false
						v232 = calculateToastPosition(v84, isToastToRight(v80), v74, v76, s4, v82)
					end

					g233 = false
					v91(v232)

					return
				end
			end

			s4 = nil
			g234 = true
		until not g234
	end, {
		v80,
		v84,
		v76,
		if not FFlagFriendshipNotifsUseSendrExperiment then nil else v86,
		if not FFlagFriendshipNotifsUseSendrExperiment then nil else v74,
		if not FFlagFriendshipNotifsUseSendrExperiment then nil else v82
	})
	React.useEffect(function() -- line: 843
		-- upvalues: getDeviceOrientation (copy), getNotificationSize (copy), v72 (copy), v79 (copy), v97 (copy), constants (copy), v81 (copy), FFlagFriendshipNotifsUseSendrExperiment (copy), v83 (copy)
		local ViewportSize = workspace.CurrentCamera.ViewportSize
		local v239 = getDeviceOrientation(ViewportSize)
		local v240 = getNotificationSize(v72, ViewportSize.X)

		v79(v240)
		v97(v72 and workspace.CurrentCamera.ViewportSize.X < constants.CompactCardThreashold)
		v81(v239)

		local connection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 847
			-- upvalues: getDeviceOrientation (copy), getNotificationSize (copy), v72 (copy), v79 (copy), v97 (copy), constants (copy), v81 (copy), FFlagFriendshipNotifsUseSendrExperiment (copy), v83 (copy)
			local ViewportSize2 = workspace.CurrentCamera.ViewportSize
			local v257 = getDeviceOrientation(ViewportSize2)
			local v258 = getNotificationSize(v72, ViewportSize2.X)

			v79(v258)
			v97(v72 and workspace.CurrentCamera.ViewportSize.X < constants.CompactCardThreashold)
			v81(v257)

			if FFlagFriendshipNotifsUseSendrExperiment then
				v83(workspace.CurrentCamera.ViewportSize)
			end
		end)

		return function() -- line: 854
			-- upvalues: connection (copy)
			if connection then
				connection:Disconnect()
			end
		end
	end, {})
	React.useEffect(function() -- line: 862
		-- upvalues: v94 (copy), v92 (copy), v124 (copy), v125 (copy)
		return function() -- line: 863
			-- upvalues: v94 (copy), v92 (copy), v124 (copy), v125 (copy)
			if v94 then
				task.cancel(v94)
			end

			if v92 then
				task.cancel(v92)
			end

			if v124 then
				v125(nil)
				v124:Fire(false)
				v124:Destroy()
			end
		end
	end, {})
	React.useEffect(function() -- line: 879
		-- upvalues: v72 (copy), type (copy), v73 (copy), default2 (copy)
		task.delay(0, function() -- line: 880
			-- upvalues: v72 (copy), type (copy), v73 (copy), default2 (copy)
			local v259 = if not v72 then {
				type.ChannelListEnum.App,
				type.ChannelListEnum.Dual
			} else {
				type.ChannelListEnum.Experience,
				type.ChannelListEnum.Dual
			}

			if v73 then
				table.insert(v259, type.ChannelListEnum.Desktop)
			end

			default2:setupNotifications(v259)
		end)
	end, {})
	React.useEffect(function() -- line: 900
		-- upvalues: default2 (copy), v143 (copy)
		local v242 = default2:listenToDisplayNotification(v143)

		return function() -- line: 902
			-- upvalues: v242 (copy)
			if v242 then
				v242:Disconnect()
			end
		end
	end, { v143 })

	local v146 = IsVRAppBuild()
	local v147 = v84 or not v146
	local v148 = v127 and (not TouchEnabled and (not v146 and v84))
	local v149 = React.createElement("TextButton", {
		ZIndex = 2,
		LayoutOrder = 1,
		AnchorPoint = Vector2.new(0, 0),
		Size = UDim2.new(0, constants.CardSizeDefault.closeButton, 0, constants.CardSizeDefault.closeButton),
		Position = UDim2.new(0, -10, 0, -10),
		BackgroundTransparency = v126.Theme.BackgroundUIDefault.Transparency,
		BackgroundColor3 = v126.Theme.BackgroundUIDefault.Color,
		Text = "",
		[React.Event.Activated] = v134,
		[React.Event.MouseEnter] = function() -- line: 927
			-- upvalues: v108 (copy)
			v108(true)
		end,
		[React.Event.MouseLeave] = function() -- line: 930
			-- upvalues: v108 (copy)
			v108(false)
		end
	}, {
		Border = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = v126.Theme.UIDefault.Color
		}),
		UICorner = React.createElement("UICorner", {
			CornerRadius = constants.DefaultCardCloseButtonCornerRadius
		}),
		CloseButtonIcon = React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, constants.CardSizeDefault.closeIcon, 0, constants.CardSizeDefault.closeIcon),
			Image = v44,
			ImageColor3 = v126.Theme.SystemPrimaryDefault.Color
		})
	})
	local v150 = React.useMemo(function() -- line: 953
		-- upvalues: React (copy), SpringAnimatedItem (copy), v78 (copy), v147 (copy), v86 (copy), v129 (copy), type (copy), v128 (copy), v106 (copy), v90 (copy), t1 (copy), v146 (copy), v84 (copy), v87 (copy), v138 (copy), SwipeDetectionWrapper (copy), v133 (copy), v108 (copy), EngineFeature (copy), ClientNotificationWrapper (copy), v110 (copy), v47 (copy), v144 (copy), v148 (copy), v149 (copy), NotificationCardProvider (copy), v96 (copy), v141 (copy), NotificationCard (copy), v127 (copy), u117 (ref), v114 (copy), holdProgress (copy)
		return React.createElement(SpringAnimatedItem.AnimatedFrame, {
			regularProps = {
				ClipsDescendants = false,
				Size = v78,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Active = true,
				Visible = v147 and v86 ~= nil,
				[React.Event.MouseEnter] = function() -- line: 962
					-- upvalues: v129 (copy), type (copy), v128 (copy), v86 (copy), v106 (copy)
					v129(type.ToastNotificationActionsEnum.Hover, v128, v86)
					v106(true)
				end,
				[React.Event.MouseLeave] = function() -- line: 970
					-- upvalues: v106 (copy)
					v106(false)
				end
			},
			animatedValues = v90,
			springOptions = t1,
			mapValuesToProps = function(p14) -- line: 976
				-- upvalues: v146 (copy)
				return {
					Position = if not v146 then UDim2.new(p14.positionX, p14.positionXOffset, p14.positionY, p14.positionYOffset) else UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = if not v146 then Vector2.new(p14.anchorX, p14.anchorY) else Vector2.new(0.5, 0.5)
				}
			end,
			onComplete = function() -- line: 991
				-- upvalues: v84 (copy), v87 (copy), v138 (copy)
				if not v84 then
					v87(nil)
					v138()
				end
			end
		}, {
			SwipeDetector = React.createElement(SwipeDetectionWrapper, {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				swipeEnabled = v84,
				swipeCallback = function(p15) -- line: 1002
					-- upvalues: v129 (copy), type (copy), v128 (copy), v86 (copy), v133 (copy), v108 (copy)
					if p15 == Enum.SwipeDirection.Up or p15 == Enum.SwipeDirection.Right then
						v129(type.ToastNotificationActionsEnum.Dismissed, v128, v86)
						v133()
						v108(false)
					end
				end
			}, {
				NotificationProvider = if not EngineFeature or (not v86 or (not v86.luaNotifInfo or not v86.id)) then React.createElement(NotificationCardProvider, {
					state = v86 and v86.state,
					isCompact = v96,
					handleActions = v141,
					notificationReceivedTimestampMs = v86 and v86.notificationReceivedTimestampMs,
					timers = v86 and v86.timers,
					displayTimestampMs = v86 and v86.displayTimestamp
				}, {
					NotificationCardCanvasGroup = if not v86 then nil else React.createElement("CanvasGroup", {
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = v78,
						GroupTransparency = v144
					}, {
						NotificationCard = React.createElement(NotificationCard, {
							isHover = v127,
							shouldAutoFocus = u117,
							showHoldButton = v114,
							holdProgress = holdProgress
						})
					}),
					ToastCloseButton = if not v148 then nil else v149
				}) else React.createElement(ClientNotificationWrapper, {
					notificationInfo = v86.luaNotifInfo,
					notificationId = v86.id,
					onPause = v110,
					onHover = v106,
					transparency = if not v47 then nil else v144,
					width = v78.X
				}, {
					ToastCloseButton = if not v148 then nil else v149
				})
			})
		})
	end, {
		constants,
		v126,
		v86,
		v147,
		v84,
		v96,
		v148,
		v127,
		v90,
		v134,
		v106,
		v108,
		v141
	})

	if v146 then
		return React.createElement(ToastVRWrapper, {
			isConfirmModalOpen = v100,
			isToastOpen = v84,
			isCoreScript = v72,
			ToastComponent = v150,
			ToastNotificationSnoozeMenu = React.createElement(ToastNotificationSnoozeMenu),
			ConfirmationModalComponent = React.createElement(DeeplinkConfirmationModal, {
				backgroundTransparency = 1,
				closeCallback = v130
			})
		})
	end

	return React.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		DisplayOrder = t2.displayOrder,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		Toast = v150,
		ToastNotificationSnoozeMenu = React.createElement(ToastNotificationSnoozeMenu),
		DeeplinkConfirmationModal = v100 and React.createElement(DeeplinkConfirmationModal, {
			closeCallback = v130
		})
	})
end
