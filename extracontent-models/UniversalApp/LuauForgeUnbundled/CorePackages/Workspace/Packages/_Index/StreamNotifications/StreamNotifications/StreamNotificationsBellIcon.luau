local React = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/React")
local StreamNotifications = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/StreamNotifications")
local StreamNotificationStore = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/StreamNotificationStore")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/SharedFlags")
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local HttpService = game:GetService("HttpService")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/UIBlox")
local badge = UIBlox.App.Indicator.Badge
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.Constant.IconSize
local images = UIBlox.App.ImageSet.Images
local badgeVariant = UIBlox.App.Indicator.Enum.BadgeVariant
local utilityActionIcon = UIBlox.App.Button.UtilityActionIcon
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Foundation")
local popover = Foundation.Popover
local popoverSide = Foundation.Enums.PopoverSide
local popoverAlign = Foundation.Enums.PopoverAlign
local useTokens = Foundation.Hooks.useTokens

local eventStream = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/analytics/analyticsService").EventStream
local notificationHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/NotificationsCommon").NotificationHelper
local ixpHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/NotificationsCommon").ixpHelper
local constants = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/constants")
local analyticsConstants = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/analytics/analyticsConstants")

local getFStringNotificationsStreamNotificationUXLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/SharedFlags").GetFStringNotificationsStreamNotificationUXLayer
local isAppNavEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/SharedFlags").isAppNavEnabled
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/SignalsReact").useSignalState

local StreamNotificationDropdownExperimentation = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/StreamNotificationDropdownExperimentation")

local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/UniversalAppPolicy").RoactAppPolicy

local getFFlagNotificationsComplianceShouldRestrictStream = SharedFlags.GetFFlagNotificationsComplianceShouldRestrictStream
local fFlagEnableNotificationsDeeplink = SharedFlags.FFlagEnableNotificationsDeeplink
local fFlagStreamNotificationBellEntryPoint = SharedFlags.FFlagStreamNotificationBellEntryPoint
local fFlagSignalsNavP3bTopBar = SharedFlags.FFlagSignalsNavP3bTopBar
local fFlagEnableHeaderBarButtonsUpdate = SharedFlags.FFlagEnableHeaderBarButtonsUpdate
local fFlagStreamNotificationDropdownSingleOwner = SharedFlags.FFlagStreamNotificationDropdownSingleOwner
local fFlagStreamNotificationDropdownFocusedOwner = SharedFlags.FFlagStreamNotificationDropdownFocusedOwner
local iconscommonnotificationOff = images["icons/common/notificationOff"]

local function GetIsFriendCommunicationRestricted()
	return ThirdPartyUserService
		and ThirdPartyUserService:IsChatRestrictionSupported()
		and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted
end

local function fn(props)
	local state, setState = React.useState(false)
	local current

	if fFlagStreamNotificationDropdownSingleOwner then
		local ref = React.useRef(nil)

		if ref.current == nil then
			local v5

			if fFlagStreamNotificationDropdownFocusedOwner then
				v5 = HttpService:GenerateGUID(false)
			else
				v5 = if props.isPrimary then StreamNotificationStore.PrimaryBellId else HttpService:GenerateGUID(false)
			end

			ref.current = v5
		end

		current = ref.current
	else
		current = nil
	end

	local v5 = nil
	local isFocused = props.isFocused ~= false
	local v6, v7

	if fFlagEnableNotificationsDeeplink then
		v6 = useSignalState(StreamNotificationStore.getStreamPresented)

		if fFlagStreamNotificationDropdownSingleOwner then
			v5 = useSignalState(StreamNotificationStore.getActiveBellId)

			if fFlagStreamNotificationDropdownFocusedOwner then
				v7 = StreamNotificationStore.isBellActive(v6, v5, current, props.isPrimary, isFocused)
			else
				v7 = StreamNotificationStore.isBellActive(v6, v5, current, props.isPrimary)
			end
		else
			v7 = v6
		end
	else
		v7 = state
		v6 = v7
	end

	if fFlagStreamNotificationDropdownFocusedOwner and not isFocused then
		v7 = false
	end

	local dropdownEnabled = StreamNotificationDropdownExperimentation.getDropdownEnabled()
	local v8 = useTokens()

	local notificationCount = props.notificationCount and tonumber(props.notificationCount) or 0
	local layoutOrder = props.layoutOrder

	local v9 = props.compactWidth and 34 or 44

	if fFlagStreamNotificationDropdownFocusedOwner then
		React.useEffect(function()
			if isFocused then
				return
			end

			if fFlagEnableNotificationsDeeplink and v5 == current then
				if not v6 then
					StreamNotificationStore.setActiveBellId(StreamNotificationStore.PrimaryBellId)
					return
				end

				StreamNotificationStore.setActiveBellId(nil)
				StreamNotificationStore.setStreamPresented(false)
			elseif not fFlagEnableNotificationsDeeplink and state then
				setState(false)
			end
		end, { v5, current, isFocused, v6, state })
	end

	local function readEntryPoint()
		if not fFlagStreamNotificationBellEntryPoint then
			return nil
		end

		if fFlagSignalsNavP3bTopBar and props.getEntryPoint then
			return (props.getEntryPoint())
		end

		return props.entryPoint
	end

	React.useEffect(function()
		if notificationCount > 0 then
			local fireEvent = notificationHelper.fireEvent

			local seen = analyticsConstants.Context.seen
			local openCTAShown = analyticsConstants.EventNames.openCTAShown
			local v11 = {
				count = notificationCount,
				sendrVersion = constants.SENDRVersion,
				entryPoint = 0
			}
			local v12

			if fFlagStreamNotificationBellEntryPoint then
				if fFlagSignalsNavP3bTopBar and props.getEntryPoint then
					v12 = props.getEntryPoint()
				else
					v12 = props.entryPoint
				end
			end

			v11.entryPoint = v12
			fireEvent(eventStream, seen, openCTAShown, v11)
		end
	end, { notificationCount })

	local v10 = React.useMemo(function()
		if not v7 then
			return nil
		end

		local createElement = React.createElement

		local v13 = if fFlagEnableNotificationsDeeplink then StreamNotificationStore.setStreamPresented else setState
		return createElement(StreamNotifications, { displayStream = v13 })
	end, { v7 })

	if getFFlagNotificationsComplianceShouldRestrictStream() and props.shouldRestrictStream then
		return nil
	end

	local v11

	if not (ThirdPartyUserService and ThirdPartyUserService:IsChatRestrictionSupported() and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted) then
		if notificationCount > 0 then
			v11 = notificationCount
		end
	end

	local function onBellActivated()
		StreamNotificationDropdownExperimentation.logExposure()
		ixpHelper.logUserLayerExposure(getFStringNotificationsStreamNotificationUXLayer())

		if dropdownEnabled then
			if fFlagEnableNotificationsDeeplink then
				if fFlagStreamNotificationDropdownSingleOwner then
					StreamNotificationStore.setActiveBellId(if not v7 then current else nil)
				end

				StreamNotificationStore.setStreamPresented(not v7)
			else
				setState(not v7)
			end

			if v7 then
				notificationHelper.fireEvent(
					eventStream,
					analyticsConstants.Context.click,
					analyticsConstants.EventNames.closeContent,
					{ closeMethod = analyticsConstants.CloseMethod.bellIcon }
				)
			else
				local fireEvent = notificationHelper.fireEvent

				local click = analyticsConstants.Context.click
				local openContent = analyticsConstants.EventNames.openContent
				local v13 = {
					countOfUnreadNotification = notificationCount,
					sendrVersion = constants.SENDRVersion,
					entryPoint = 0
				}
				local v14

				if fFlagStreamNotificationBellEntryPoint then
					if fFlagSignalsNavP3bTopBar and props.getEntryPoint then
						v14 = props.getEntryPoint()
					else
						v14 = props.entryPoint
					end
				end

				v13.entryPoint = v14
				fireEvent(eventStream, click, openContent, v13)
			end
		else
			if fFlagEnableNotificationsDeeplink then
				if fFlagStreamNotificationDropdownSingleOwner then
					StreamNotificationStore.setActiveBellId(current)
				end

				StreamNotificationStore.setStreamPresented(true)
			else
				setState(true)
			end

			local fireEvent = notificationHelper.fireEvent

			local click = analyticsConstants.Context.click
			local openContent = analyticsConstants.EventNames.openContent
			local v13 = {
				countOfUnreadNotification = notificationCount,
				sendrVersion = constants.SENDRVersion,
				entryPoint = 0
			}
			local v14

			if fFlagStreamNotificationBellEntryPoint then
				if fFlagSignalsNavP3bTopBar and props.getEntryPoint then
					v14 = props.getEntryPoint()
				else
					v14 = props.entryPoint
				end
			end

			v13.entryPoint = v14
			fireEvent(eventStream, click, openContent, v13)
		end

		if props.onActivated then
			props.onActivated()
		end
	end

	local function onPopoverDismiss()
		if fFlagEnableNotificationsDeeplink then
			if fFlagStreamNotificationDropdownSingleOwner then
				StreamNotificationStore.setActiveBellId(nil)
			end

			StreamNotificationStore.setStreamPresented(false)
		else
			setState(false)
		end

		notificationHelper.fireEvent(eventStream, analyticsConstants.Context.click, analyticsConstants.EventNames.closeContent, {
			closeMethod = analyticsConstants.CloseMethod.backgroundOverlay
		})
	end

	if fFlagEnableHeaderBarButtonsUpdate then
		local createElement = React.createElement
		local view = Foundation.View
		local v12 = {
			tag = "auto-xy radius-circle",
			LayoutOrder = layoutOrder or 3,
			ref = props.buttonRef,
			testId = props.testId
		}
		local v13 = {
			IconButton = React.createElement(Foundation.IconButton, {
				ZIndex = 1,
				isCircular = true,
				icon = Foundation.Enums.IconName.Bell,
				onActivated = onBellActivated
			}),
			Badge = 0,
			DisplayStreamNotifications = 0
		}
		local v14 = if (not (ThirdPartyUserService and ThirdPartyUserService:IsChatRestrictionSupported()) or ThirdPartyUserService.FriendCommunicationRestrictionStatus == Enum.ChatRestrictionStatus.NotRestricted) and notificationCount > 0 then React.createElement(Foundation.StatusIndicator, {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			ZIndex = 2,
			variant = Foundation.Enums.StatusIndicatorVariant.Emphasis,
			value = notificationCount,
			max = 99
		}) else nil
		v13.Badge = v14

		v13.DisplayStreamNotifications = if not dropdownEnabled then v10 else nil
		local element = createElement(view, v12, v13)

		if isAppNavEnabled() and dropdownEnabled then
			return React.createElement(popover.Root, { isOpen = v7 }, {
				Anchor = React.createElement(popover.Anchor, nil, {
					BellIcon = element
				}),
				Content = React.createElement(popover.Content, {
					side = popoverSide.Bottom,
					align = popoverAlign.End,
					hasArrow = true,
					onPressedOutside = onPopoverDismiss,
					backgroundStyle = v8.Color.Surface.Surface_200
				}, { DisplayStreamNotifications = v10 })
			})
		end

		return element
	elseif isAppNavEnabled() then
		local v12

		if dropdownEnabled and v7 then
			v12 = constants.Dropdown.BellIconOpen
		else
			v12 = iconscommonnotificationOff
		end

		if dropdownEnabled then
			return React.createElement(popover.Root, { isOpen = v7 }, {
				Anchor = React.createElement(popover.Anchor, nil, {
					BellIcon = React.createElement(utilityActionIcon, {
						icon = v12,
						onActivated = onBellActivated,
						badgeValue = v11,
						buttonRef = props.buttonRef
					})
				}),
				Content = React.createElement(popover.Content, {
					side = popoverSide.Bottom,
					align = popoverAlign.End,
					hasArrow = true,
					onPressedOutside = onPopoverDismiss,
					backgroundStyle = v8.Color.Surface.Surface_200
				}, { DisplayStreamNotifications = v10 })
			})
		end

		return React.createElement(
			utilityActionIcon,
			{
				icon = v12,
				onActivated = onBellActivated,
				badgeValue = v11,
				buttonRef = props.buttonRef
			},
			{ DisplayStreamNotifications = v10 }
		)
	else
		local createElement = React.createElement
		local v13 = {
			size = UDim2.new(0, v9, 1, 0),
			icon = iconscommonnotificationOff,
			iconSize = iconSize.Medium,
			layoutOrder = layoutOrder or 3,
			onActivated = onBellActivated,
			buttonRef = props.buttonRef
		}
		local v15 = if (not (ThirdPartyUserService and ThirdPartyUserService:IsChatRestrictionSupported()) or ThirdPartyUserService.FriendCommunicationRestrictionStatus == Enum.ChatRestrictionStatus.NotRestricted) and notificationCount > 0 then React.createElement(badge, {
			position = UDim2.new(0.5, 0, 0.5, 0),
			anchorPoint = Vector2.new(0, 1),
			value = notificationCount,
			badgeVariant = badgeVariant.Alert
		}) else nil
		return createElement(iconButton, v13, { notificationBadge = v15 }, { v10 })
	end
end

if getFFlagNotificationsComplianceShouldRestrictStream() then
	fn = roactAppPolicy.connect(function(p2, p3)
		return {
			shouldRestrictStream = p2.getNotificationsCanReceiveStream() or false
		}
	end)(fn)
end

return fn
