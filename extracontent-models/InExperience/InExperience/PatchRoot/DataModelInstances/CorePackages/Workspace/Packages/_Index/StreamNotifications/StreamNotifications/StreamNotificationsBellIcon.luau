local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local StreamNotificationsParent = StreamNotifications.Parent
local React = require(StreamNotificationsParent.React)
local StreamNotifications2 = require(StreamNotifications.StreamNotifications)
local StreamNotificationStore = require(StreamNotifications.StreamNotificationStore)
local SharedFlags = require(StreamNotificationsParent.SharedFlags)
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local HttpService = game:GetService("HttpService")
local UIBlox = require(StreamNotificationsParent.UIBlox)
local Badge = UIBlox.App.Indicator.Badge
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.Constant.IconSize
local Images = UIBlox.App.ImageSet.Images
local BadgeVariant = UIBlox.App.Indicator.Enum.BadgeVariant
local UtilityActionIcon = UIBlox.App.Button.UtilityActionIcon
local Foundation = require(StreamNotificationsParent.Foundation)
local Popover = Foundation.Popover
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local useTokens = Foundation.Hooks.useTokens
local EventStream = require(StreamNotifications.analytics.analyticsService).EventStream
local NotificationHelper = require(StreamNotificationsParent.NotificationsCommon).NotificationHelper
local ixpHelper = require(StreamNotificationsParent.NotificationsCommon).ixpHelper
local constants = require(StreamNotifications.constants)
local analyticsConstants = require(StreamNotifications.analytics.analyticsConstants)
local GetFStringNotificationsStreamNotificationUXLayer = require(StreamNotificationsParent.SharedFlags).GetFStringNotificationsStreamNotificationUXLayer
local isAppNavEnabled = require(StreamNotificationsParent.SharedFlags).isAppNavEnabled
local useSignalState = require(StreamNotificationsParent.SignalsReact).useSignalState
local StreamNotificationDropdownExperimentation = require(StreamNotifications.StreamNotificationDropdownExperimentation)
local RoactAppPolicy = require(StreamNotificationsParent.UniversalAppPolicy).RoactAppPolicy
local GetFFlagNotificationsComplianceShouldRestrictStream = SharedFlags.GetFFlagNotificationsComplianceShouldRestrictStream
local FFlagEnableNotificationsDeeplink = SharedFlags.FFlagEnableNotificationsDeeplink
local FFlagStreamNotificationBellEntryPoint = SharedFlags.FFlagStreamNotificationBellEntryPoint
local FFlagEnableHeaderBarButtonsUpdate = SharedFlags.FFlagEnableHeaderBarButtonsUpdate
local FFlagStreamNotificationDropdownSingleOwner = SharedFlags.FFlagStreamNotificationDropdownSingleOwner
local v36 = Images["icons/common/notificationOff"]

local function GetIsFriendCommunicationRestricted() -- line: 45
	-- upvalues: ThirdPartyUserService (copy)
	return ThirdPartyUserService and (ThirdPartyUserService:IsChatRestrictionSupported() and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted)
end
local function v38(t1: {[any]: any}) -- line: 65
	-- upvalues: React (copy), FFlagStreamNotificationDropdownSingleOwner (copy), StreamNotificationStore (copy), HttpService (copy), FFlagEnableNotificationsDeeplink (copy), useSignalState (copy), StreamNotificationDropdownExperimentation (copy), useTokens (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), constants (copy), FFlagStreamNotificationBellEntryPoint (copy), StreamNotifications2 (copy), GetFFlagNotificationsComplianceShouldRestrictStream (copy), ThirdPartyUserService (copy), ixpHelper (copy), GetFStringNotificationsStreamNotificationUXLayer (copy), FFlagEnableHeaderBarButtonsUpdate (copy), Foundation (copy), isAppNavEnabled (copy), Popover (copy), PopoverSide (copy), PopoverAlign (copy), v36 (copy), UtilityActionIcon (copy), IconButton (copy), IconSize (copy), Badge (copy), BadgeVariant (copy)
	local v40, v41 = React.useState(false)
	local current = nil

	if FFlagStreamNotificationDropdownSingleOwner then
		local v43 = React.useRef(nil)

		if v43.current == nil then
			v43.current = if not t1.isPrimary then HttpService:GenerateGUID(false) else StreamNotificationStore.PrimaryBellId
		end

		current = v43.current
	end

	local u44 = v40

	if FFlagEnableNotificationsDeeplink then
		local v45 = useSignalState(StreamNotificationStore.getStreamPresented)

		if FFlagStreamNotificationDropdownSingleOwner then
			local v46 = useSignalState(StreamNotificationStore.getActiveBellId)

			u44 = StreamNotificationStore.isBellActive(v45, v46, current, t1.isPrimary)
		else
			u44 = v45
		end
	end

	local v47 = StreamNotificationDropdownExperimentation.getDropdownEnabled()
	local v48 = useTokens()
	local v49 = t1.notificationCount and tonumber(t1.notificationCount) or 0
	local layoutOrder = t1.layoutOrder
	local n1 = 44

	if t1.compactWidth then
		n1 = 34
	end

	React.useEffect(function() -- line: 113
		-- upvalues: v49 (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), constants (copy), FFlagStreamNotificationBellEntryPoint (copy), t1 (copy)
		if v49 > 0 then
			NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.seen, analyticsConstants.EventNames.openCTAShown, {
				count = v49,
				sendrVersion = constants.SENDRVersion,
				entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else t1.entryPoint
			})
		end
	end, { v49 })

	local v52 = React.useMemo(function() -- line: 128
		-- upvalues: u44 (ref), React (copy), StreamNotifications2 (copy), FFlagEnableNotificationsDeeplink (copy), StreamNotificationStore (copy), v41 (copy)
		if u44 then
			return React.createElement(StreamNotifications2, {
				displayStream = if not FFlagEnableNotificationsDeeplink then v41 else StreamNotificationStore.setStreamPresented
			})
		end

		return nil
	end, { u44 })

	if GetFFlagNotificationsComplianceShouldRestrictStream() and t1.shouldRestrictStream then
		return nil
	end

	local v53 = if not (ThirdPartyUserService and (ThirdPartyUserService:IsChatRestrictionSupported() and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted)) then if not (v49 > 0) then nil else v49 else nil

	local function onBellActivated() -- line: 156
		-- upvalues: StreamNotificationDropdownExperimentation (copy), ixpHelper (copy), GetFStringNotificationsStreamNotificationUXLayer (copy), v47 (copy), FFlagEnableNotificationsDeeplink (copy), FFlagStreamNotificationDropdownSingleOwner (copy), StreamNotificationStore (copy), u44 (ref), current (ref), v41 (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), v49 (copy), constants (copy), FFlagStreamNotificationBellEntryPoint (copy), t1 (copy)
		StreamNotificationDropdownExperimentation.logExposure()
		ixpHelper.logUserLayerExposure(GetFStringNotificationsStreamNotificationUXLayer())

		if v47 then
			if FFlagEnableNotificationsDeeplink then
				if FFlagStreamNotificationDropdownSingleOwner then
					StreamNotificationStore.setActiveBellId(if not u44 then current else nil)
				end

				StreamNotificationStore.setStreamPresented(not u44)
			else
				v41(not u44)
			end

			if u44 then
				NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.click, analyticsConstants.EventNames.closeContent, {
					closeMethod = analyticsConstants.CloseMethod.bellIcon
				})

				return
			end

			NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.click, analyticsConstants.EventNames.openContent, {
				countOfUnreadNotification = v49,
				sendrVersion = constants.SENDRVersion,
				entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else t1.entryPoint
			})

			return
		end

		if FFlagEnableNotificationsDeeplink then
			if FFlagStreamNotificationDropdownSingleOwner then
				StreamNotificationStore.setActiveBellId(current)
			end

			StreamNotificationStore.setStreamPresented(true)
		else
			v41(true)
		end

		NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.click, analyticsConstants.EventNames.openContent, {
			countOfUnreadNotification = v49,
			sendrVersion = constants.SENDRVersion,
			entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else t1.entryPoint
		})
	end
	local function onPopoverDismiss() -- line: 220
		-- upvalues: FFlagEnableNotificationsDeeplink (copy), FFlagStreamNotificationDropdownSingleOwner (copy), StreamNotificationStore (copy), v41 (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy)
		if FFlagEnableNotificationsDeeplink then
			if FFlagStreamNotificationDropdownSingleOwner then
				StreamNotificationStore.setActiveBellId(nil)
			end

			StreamNotificationStore.setStreamPresented(false)
		else
			v41(false)
		end

		NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.click, analyticsConstants.EventNames.closeContent, {
			closeMethod = analyticsConstants.CloseMethod.backgroundOverlay
		})
	end

	if FFlagEnableHeaderBarButtonsUpdate then
		local v56 = React.createElement(Foundation.View, {
			tag = "auto-xy radius-circle",
			LayoutOrder = layoutOrder or 3,
			ref = t1.buttonRef,
			testId = t1.testId
		}, {
			IconButton = React.createElement(Foundation.IconButton, {
				ZIndex = 1,
				isCircular = true,
				icon = Foundation.Enums.IconName.Bell,
				onActivated = onBellActivated
			}),
			Badge = if not (ThirdPartyUserService and (ThirdPartyUserService:IsChatRestrictionSupported() and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted)) then if not (v49 > 0) then nil else React.createElement(Foundation.StatusIndicator, {
				ZIndex = 2,
				max = 99,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0.5, 0.5),
				variant = Foundation.Enums.StatusIndicatorVariant.Alert,
				value = v49
			}) else nil,
			DisplayStreamNotifications = if v47 then nil else v52
		})

		if isAppNavEnabled() and v47 then
			return (React.createElement(Popover.Root, {
				isOpen = u44
			}, {
				Anchor = React.createElement(Popover.Anchor, nil, {
					BellIcon = v56
				}),
				Content = React.createElement(Popover.Content, {
					hasArrow = true,
					side = PopoverSide.Bottom,
					align = PopoverAlign.End,
					onPressedOutside = onPopoverDismiss,
					backgroundStyle = v48.Color.Surface.Surface_200
				}, {
					DisplayStreamNotifications = v52
				})
			}))
		end

		return v56
	end

	if isAppNavEnabled() then
		local v57 = if not v47 or not u44 then v36 else constants.Dropdown.BellIconOpen

		if v47 then
			return (React.createElement(Popover.Root, {
				isOpen = u44
			}, {
				Anchor = React.createElement(Popover.Anchor, nil, {
					BellIcon = React.createElement(UtilityActionIcon, {
						icon = v57,
						onActivated = onBellActivated,
						badgeValue = v53,
						buttonRef = t1.buttonRef
					})
				}),
				Content = React.createElement(Popover.Content, {
					hasArrow = true,
					side = PopoverSide.Bottom,
					align = PopoverAlign.End,
					onPressedOutside = onPopoverDismiss,
					backgroundStyle = v48.Color.Surface.Surface_200
				}, {
					DisplayStreamNotifications = v52
				})
			}))
		end

		return (React.createElement(UtilityActionIcon, {
			icon = v57,
			onActivated = onBellActivated,
			badgeValue = v53,
			buttonRef = t1.buttonRef
		}, {
			DisplayStreamNotifications = v52
		}))
	end

	return (React.createElement(IconButton, {
		size = UDim2.new(0, n1, 1, 0),
		icon = v36,
		iconSize = IconSize.Medium,
		layoutOrder = layoutOrder or 3,
		onActivated = onBellActivated,
		buttonRef = t1.buttonRef
	}, {
		notificationBadge = if not (ThirdPartyUserService and (ThirdPartyUserService:IsChatRestrictionSupported() and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted)) then if not (v49 > 0) then nil else React.createElement(Badge, {
			position = UDim2.new(0.5, 0, 0.5, 0),
			anchorPoint = Vector2.new(0, 1),
			value = v49,
			badgeVariant = BadgeVariant.Alert
		}) else nil
	}, { v52 }))
end

if GetFFlagNotificationsComplianceShouldRestrictStream() then
	v38 = RoactAppPolicy.connect(function(p1, _) -- line: 353
		return {
			shouldRestrictStream = p1.getNotificationsCanReceiveStream() or false
		}
	end)(v38)
end

return v38
