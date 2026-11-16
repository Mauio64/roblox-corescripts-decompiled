local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local parent = StreamNotifications.Parent
local React = require(parent.React)
local StreamNotifications2 = require(StreamNotifications.StreamNotifications)
local StreamNotificationStore = require(StreamNotifications.StreamNotificationStore)
local SharedFlags = require(parent.SharedFlags)
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local HttpService = game:GetService("HttpService")

local UIBlox = require(parent.UIBlox)
local Badge = UIBlox.App.Indicator.Badge
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.Constant.IconSize
local Images = UIBlox.App.ImageSet.Images
local BadgeVariant = UIBlox.App.Indicator.Enum.BadgeVariant
local UtilityActionIcon = UIBlox.App.Button.UtilityActionIcon
local Foundation = require(parent.Foundation)
local Popover = Foundation.Popover
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local useTokens = Foundation.Hooks.useTokens

local analyticsService = require(StreamNotifications.analytics.analyticsService)
local eventStream = analyticsService.EventStream
local NotificationsCommon = require(parent.NotificationsCommon)
local NotificationHelper = NotificationsCommon.NotificationHelper
local NotificationsCommon2 = require(parent.NotificationsCommon)
local ixpHelper = NotificationsCommon2.ixpHelper
local constants = require(StreamNotifications.constants)
local analyticsConstants = require(StreamNotifications.analytics.analyticsConstants)

local SharedFlags2 = require(parent.SharedFlags)
local GetFStringNotificationsStreamNotificationUXLayer = SharedFlags2.GetFStringNotificationsStreamNotificationUXLayer
local SharedFlags3 = require(parent.SharedFlags)
local isAppNavEnabled = SharedFlags3.isAppNavEnabled
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local StreamNotificationDropdownExperimentation = require(StreamNotifications.StreamNotificationDropdownExperimentation)

local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local RoactAppPolicy = UniversalAppPolicy.RoactAppPolicy

local GetFFlagNotificationsComplianceShouldRestrictStream = SharedFlags.GetFFlagNotificationsComplianceShouldRestrictStream
local FFlagEnableNotificationsDeeplink = SharedFlags.FFlagEnableNotificationsDeeplink
local FFlagStreamNotificationBellEntryPoint = SharedFlags.FFlagStreamNotificationBellEntryPoint
local FFlagSignalsNavP3bTopBar = SharedFlags.FFlagSignalsNavP3bTopBar
local FFlagEnableHeaderBarButtonsUpdate = SharedFlags.FFlagEnableHeaderBarButtonsUpdate
local FFlagStreamNotificationDropdownSingleOwner = SharedFlags.FFlagStreamNotificationDropdownSingleOwner
local FFlagStreamNotificationDropdownFocusedOwner = SharedFlags.FFlagStreamNotificationDropdownFocusedOwner
local iconscommonnotificationOff = Images["icons/common/notificationOff"]

local function GetIsFriendCommunicationRestricted()
	return ThirdPartyUserService
		and ThirdPartyUserService:IsChatRestrictionSupported()
		and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted
end

local function fn(props)
	local state, setState = React.useState(false)
	local current

	if FFlagStreamNotificationDropdownSingleOwner then
		local ref = React.useRef(nil)

		if ref.current == nil then
			local current2

			if FFlagStreamNotificationDropdownFocusedOwner then
				current2 = HttpService:GenerateGUID(false)
			elseif props.isPrimary then
				current2 = StreamNotificationStore.PrimaryBellId
			else
				current2 = HttpService:GenerateGUID(false)
			end

			ref.current = current2
		end

		current = ref.current
	else
		current = nil
	end

	local v = nil
	local isFocused = props.isFocused ~= false
	local v2, isOpen

	if FFlagEnableNotificationsDeeplink then
		v2 = useSignalState(StreamNotificationStore.getStreamPresented)

		if FFlagStreamNotificationDropdownSingleOwner then
			v = useSignalState(StreamNotificationStore.getActiveBellId)

			if FFlagStreamNotificationDropdownFocusedOwner then
				isOpen = StreamNotificationStore.isBellActive(v2, v, current, props.isPrimary, isFocused)
			else
				isOpen = StreamNotificationStore.isBellActive(v2, v, current, props.isPrimary)
			end
		else
			isOpen = v2
		end
	else
		isOpen = state
		v2 = isOpen
	end

	if FFlagStreamNotificationDropdownFocusedOwner and not isFocused then
		isOpen = false
	end

	local dropdownEnabled = StreamNotificationDropdownExperimentation.getDropdownEnabled()
	local v3 = useTokens()

	local notificationCount = props.notificationCount and tonumber(props.notificationCount) or 0
	local layoutOrder = props.layoutOrder

	local v4 = props.compactWidth and 34 or 44

	if FFlagStreamNotificationDropdownFocusedOwner then
		React.useEffect(function()
			if isFocused then
				return
			end

			if FFlagEnableNotificationsDeeplink and v == current then
				if not v2 then
					StreamNotificationStore.setActiveBellId(StreamNotificationStore.PrimaryBellId)
					return
				end

				StreamNotificationStore.setActiveBellId(nil)
				StreamNotificationStore.setStreamPresented(false)
			elseif not FFlagEnableNotificationsDeeplink and state then
				setState(false)
			end
		end, { v, current, isFocused, v2, state })
	end

	local function readEntryPoint() -- 3 equivalent calls inferred from this helper
		if not FFlagStreamNotificationBellEntryPoint then
			return nil
		end

		if FFlagSignalsNavP3bTopBar and props.getEntryPoint then
			return (props.getEntryPoint())
		end

		return props.entryPoint
	end

	React.useEffect(function()
		if notificationCount > 0 then
			NotificationHelper.fireEvent(
				eventStream,
				analyticsConstants.Context.seen,
				analyticsConstants.EventNames.openCTAShown,
				{
					count = notificationCount,
					sendrVersion = constants.SENDRVersion,
					entryPoint = readEntryPoint() -- inferred equivalent call
				}
			)
		end
	end, { notificationCount })

	local displayStreamNotifications = React.useMemo(function()
		if not isOpen then
			return nil
		end

		local createElement = React.createElement
		local displayStream

		if FFlagEnableNotificationsDeeplink then
			displayStream = StreamNotificationStore.setStreamPresented
		else
			displayStream = setState
		end

		return createElement(StreamNotifications2, { displayStream = displayStream })
	end, { isOpen })

	if GetFFlagNotificationsComplianceShouldRestrictStream() and props.shouldRestrictStream then
		return nil
	end

	local badgeValue

	if not (ThirdPartyUserService and ThirdPartyUserService:IsChatRestrictionSupported() and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted) then
		if notificationCount > 0 then
			badgeValue = notificationCount
		end
	end

	local function onBellActivated()
		StreamNotificationDropdownExperimentation.logExposure()
		ixpHelper.logUserLayerExposure(GetFStringNotificationsStreamNotificationUXLayer())

		if dropdownEnabled then
			if FFlagEnableNotificationsDeeplink then
				if FFlagStreamNotificationDropdownSingleOwner then
					local setActiveBellId = StreamNotificationStore.setActiveBellId
					local v5

					if not isOpen then
						v5 = current
					end

					setActiveBellId(v5)
				end

				StreamNotificationStore.setStreamPresented(not isOpen)
			else
				setState(not isOpen)
			end

			if isOpen then
				NotificationHelper.fireEvent(
					eventStream,
					analyticsConstants.Context.click,
					analyticsConstants.EventNames.closeContent,
					{ closeMethod = analyticsConstants.CloseMethod.bellIcon }
				)
			else
				NotificationHelper.fireEvent(
					eventStream,
					analyticsConstants.Context.click,
					analyticsConstants.EventNames.openContent,
					{
						countOfUnreadNotification = notificationCount,
						sendrVersion = constants.SENDRVersion,
						entryPoint = readEntryPoint() -- inferred equivalent call
					}
				)
			end
		else
			if FFlagEnableNotificationsDeeplink then
				if FFlagStreamNotificationDropdownSingleOwner then
					StreamNotificationStore.setActiveBellId(current)
				end

				StreamNotificationStore.setStreamPresented(true)
			else
				setState(true)
			end

			NotificationHelper.fireEvent(
				eventStream,
				analyticsConstants.Context.click,
				analyticsConstants.EventNames.openContent,
				{
					countOfUnreadNotification = notificationCount,
					sendrVersion = constants.SENDRVersion,
					entryPoint = readEntryPoint() -- inferred equivalent call
				}
			)
		end

		if props.onActivated then
			props.onActivated()
		end
	end

	local function onPopoverDismiss()
		if FFlagEnableNotificationsDeeplink then
			if FFlagStreamNotificationDropdownSingleOwner then
				StreamNotificationStore.setActiveBellId(nil)
			end

			StreamNotificationStore.setStreamPresented(false)
		else
			setState(false)
		end

		NotificationHelper.fireEvent(
			eventStream,
			analyticsConstants.Context.click,
			analyticsConstants.EventNames.closeContent,
			{ closeMethod = analyticsConstants.CloseMethod.backgroundOverlay }
		)
	end

	if FFlagEnableHeaderBarButtonsUpdate then
		local createElement = React.createElement
		local view = Foundation.View
		local v5 = {
			tag = "auto-xy radius-circle",
			LayoutOrder = layoutOrder or 3,
			ref = props.buttonRef,
			testId = props.testId
		}
		local v6 = {
			IconButton = React.createElement(Foundation.IconButton, {
				ZIndex = 1,
				isCircular = true,
				icon = Foundation.Enums.IconName.Bell,
				onActivated = onBellActivated
			}),
			Badge = 0,
			DisplayStreamNotifications = 0
		}
		local badge

		if not (ThirdPartyUserService and ThirdPartyUserService:IsChatRestrictionSupported() and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted or not (notificationCount > 0)) then
			badge = React.createElement(Foundation.StatusIndicator, {
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0.5, 0.5),
				ZIndex = 2,
				variant = Foundation.Enums.StatusIndicatorVariant.Emphasis,
				value = notificationCount,
				max = 99
			})
		end

		v6.Badge = badge
		local displayStreamNotifications2

		if not dropdownEnabled then
			displayStreamNotifications2 = displayStreamNotifications
		end

		v6.DisplayStreamNotifications = displayStreamNotifications2
		local element = createElement(view, v5, v6)

		if isAppNavEnabled() and dropdownEnabled then
			return (React.createElement(Popover.Root, { isOpen = isOpen }, {
				Anchor = React.createElement(Popover.Anchor, nil, { BellIcon = element }),
				Content = React.createElement(Popover.Content, {
					side = PopoverSide.Bottom,
					align = PopoverAlign.End,
					hasArrow = true,
					onPressedOutside = onPopoverDismiss,
					backgroundStyle = v3.Color.Surface.Surface_200
				}, { DisplayStreamNotifications = displayStreamNotifications })
			}))
		end

		return element
	elseif isAppNavEnabled() then
		local icon

		if dropdownEnabled and isOpen then
			icon = constants.Dropdown.BellIconOpen
		else
			icon = iconscommonnotificationOff
		end

		if dropdownEnabled then
			return (React.createElement(Popover.Root, { isOpen = isOpen }, {
				Anchor = React.createElement(Popover.Anchor, nil, {
					BellIcon = React.createElement(UtilityActionIcon, {
						icon = icon,
						onActivated = onBellActivated,
						badgeValue = badgeValue,
						buttonRef = props.buttonRef
					})
				}),
				Content = React.createElement(Popover.Content, {
					side = PopoverSide.Bottom,
					align = PopoverAlign.End,
					hasArrow = true,
					onPressedOutside = onPopoverDismiss,
					backgroundStyle = v3.Color.Surface.Surface_200
				}, { DisplayStreamNotifications = displayStreamNotifications })
			}))
		end

		return (React.createElement(
			UtilityActionIcon,
			{
				icon = icon,
				onActivated = onBellActivated,
				badgeValue = badgeValue,
				buttonRef = props.buttonRef
			},
			{ DisplayStreamNotifications = displayStreamNotifications }
		))
	else
		local createElement = React.createElement
		local v5 = {
			size = UDim2.new(0, v4, 1, 0),
			icon = iconscommonnotificationOff,
			iconSize = IconSize.Medium,
			layoutOrder = layoutOrder or 3,
			onActivated = onBellActivated,
			buttonRef = props.buttonRef
		}
		local notificationBadge

		if not (ThirdPartyUserService and ThirdPartyUserService:IsChatRestrictionSupported() and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted or not (notificationCount > 0)) then
			notificationBadge = React.createElement(Badge, {
				position = UDim2.new(0.5, 0, 0.5, 0),
				anchorPoint = Vector2.new(0, 1),
				value = notificationCount,
				badgeVariant = BadgeVariant.Alert
			})
		end

		return (createElement(IconButton, v5, { notificationBadge = notificationBadge }, { displayStreamNotifications }))
	end
end

if GetFFlagNotificationsComplianceShouldRestrictStream() then
	fn = RoactAppPolicy.connect(function(p, _)
		return {
			shouldRestrictStream = p.getNotificationsCanReceiveStream() or false
		}
	end)(fn)
end

return fn
