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
local FFlagStreamNotificationDropdownFocusedOwner = SharedFlags.FFlagStreamNotificationDropdownFocusedOwner
local v37 = Images["icons/common/notificationOff"]

local function GetIsFriendCommunicationRestricted() -- line: 46
	-- upvalues: ThirdPartyUserService (copy)
	return ThirdPartyUserService and (ThirdPartyUserService:IsChatRestrictionSupported() and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted)
end
local function v39(t1: {[any]: any}) -- line: 66
	-- upvalues: React (copy), FFlagStreamNotificationDropdownSingleOwner (copy), FFlagStreamNotificationDropdownFocusedOwner (copy), HttpService (copy), StreamNotificationStore (copy), FFlagEnableNotificationsDeeplink (copy), useSignalState (copy), StreamNotificationDropdownExperimentation (copy), useTokens (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), constants (copy), FFlagStreamNotificationBellEntryPoint (copy), StreamNotifications2 (copy), GetFFlagNotificationsComplianceShouldRestrictStream (copy), ThirdPartyUserService (copy), ixpHelper (copy), GetFStringNotificationsStreamNotificationUXLayer (copy), FFlagEnableHeaderBarButtonsUpdate (copy), Foundation (copy), isAppNavEnabled (copy), Popover (copy), PopoverSide (copy), PopoverAlign (copy), v37 (copy), UtilityActionIcon (copy), IconButton (copy), IconSize (copy), Badge (copy), BadgeVariant (copy)
	local v41, v42 = React.useState(false)
	local current = nil

	if FFlagStreamNotificationDropdownSingleOwner then
		local v44 = React.useRef(nil)

		if v44.current == nil then
			v44.current = if not FFlagStreamNotificationDropdownFocusedOwner then if not t1.isPrimary then HttpService:GenerateGUID(false) else StreamNotificationStore.PrimaryBellId else HttpService:GenerateGUID(false)
		end

		current = v44.current
	end

	local u45 = v41
	local u46 = nil
	local v47 = t1.isFocused ~= false
	local u48 = v41

	if FFlagEnableNotificationsDeeplink then
		u45 = useSignalState(StreamNotificationStore.getStreamPresented)

		if FFlagStreamNotificationDropdownSingleOwner then
			u46 = useSignalState(StreamNotificationStore.getActiveBellId)
			u48 = if not FFlagStreamNotificationDropdownFocusedOwner then StreamNotificationStore.isBellActive(u45, u46, current, t1.isPrimary) else StreamNotificationStore.isBellActive(u45, u46, current, t1.isPrimary, v47)
		else
			u48 = u45
		end
	end

	if FFlagStreamNotificationDropdownFocusedOwner and not v47 then
		u48 = false
	end

	local v49 = StreamNotificationDropdownExperimentation.getDropdownEnabled()
	local v50 = useTokens()
	local v51 = t1.notificationCount and tonumber(t1.notificationCount) or 0
	local layoutOrder = t1.layoutOrder
	local n1 = 44

	if t1.compactWidth then
		n1 = 34
	end

	if FFlagStreamNotificationDropdownFocusedOwner then
		React.useEffect(function() -- line: 121
			-- upvalues: v47 (copy), FFlagEnableNotificationsDeeplink (copy), u46 (ref), current (ref), u45 (ref), StreamNotificationStore (copy), v41 (copy), v42 (copy)
			if v47 then
				return
			end

			if FFlagEnableNotificationsDeeplink and u46 == current then
				if u45 then
					StreamNotificationStore.setActiveBellId(nil)
					StreamNotificationStore.setStreamPresented(false)

					return
				end

				StreamNotificationStore.setActiveBellId(StreamNotificationStore.PrimaryBellId)

				return
			end

			if not FFlagEnableNotificationsDeeplink and v41 then
				v42(false)
			end
		end, {
			u46,
			current,
			v47,
			u45,
			v41
		})
	end

	React.useEffect(function() -- line: 143
		-- upvalues: v51 (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), constants (copy), FFlagStreamNotificationBellEntryPoint (copy), t1 (copy)
		if v51 > 0 then
			NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.seen, analyticsConstants.EventNames.openCTAShown, {
				count = v51,
				sendrVersion = constants.SENDRVersion,
				entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else t1.entryPoint
			})
		end
	end, { v51 })

	local v54 = React.useMemo(function() -- line: 158
		-- upvalues: u48 (ref), React (copy), StreamNotifications2 (copy), FFlagEnableNotificationsDeeplink (copy), StreamNotificationStore (copy), v42 (copy)
		if u48 then
			return React.createElement(StreamNotifications2, {
				displayStream = if not FFlagEnableNotificationsDeeplink then v42 else StreamNotificationStore.setStreamPresented
			})
		end

		return nil
	end, { u48 })

	if GetFFlagNotificationsComplianceShouldRestrictStream() and t1.shouldRestrictStream then
		return nil
	end

	local v55 = if not (ThirdPartyUserService and (ThirdPartyUserService:IsChatRestrictionSupported() and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted)) then if not (v51 > 0) then nil else v51 else nil

	local function onBellActivated() -- line: 186
		-- upvalues: StreamNotificationDropdownExperimentation (copy), ixpHelper (copy), GetFStringNotificationsStreamNotificationUXLayer (copy), v49 (copy), FFlagEnableNotificationsDeeplink (copy), FFlagStreamNotificationDropdownSingleOwner (copy), StreamNotificationStore (copy), u48 (ref), current (ref), v42 (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), v51 (copy), constants (copy), FFlagStreamNotificationBellEntryPoint (copy), t1 (copy)
		StreamNotificationDropdownExperimentation.logExposure()
		ixpHelper.logUserLayerExposure(GetFStringNotificationsStreamNotificationUXLayer())

		if v49 then
			if FFlagEnableNotificationsDeeplink then
				if FFlagStreamNotificationDropdownSingleOwner then
					StreamNotificationStore.setActiveBellId(if not u48 then current else nil)
				end

				StreamNotificationStore.setStreamPresented(not u48)
			else
				v42(not u48)
			end

			if u48 then
				NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.click, analyticsConstants.EventNames.closeContent, {
					closeMethod = analyticsConstants.CloseMethod.bellIcon
				})

				return
			end

			NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.click, analyticsConstants.EventNames.openContent, {
				countOfUnreadNotification = v51,
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
			v42(true)
		end

		NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.click, analyticsConstants.EventNames.openContent, {
			countOfUnreadNotification = v51,
			sendrVersion = constants.SENDRVersion,
			entryPoint = if not FFlagStreamNotificationBellEntryPoint then nil else t1.entryPoint
		})
	end
	local function onPopoverDismiss() -- line: 250
		-- upvalues: FFlagEnableNotificationsDeeplink (copy), FFlagStreamNotificationDropdownSingleOwner (copy), StreamNotificationStore (copy), v42 (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy)
		if FFlagEnableNotificationsDeeplink then
			if FFlagStreamNotificationDropdownSingleOwner then
				StreamNotificationStore.setActiveBellId(nil)
			end

			StreamNotificationStore.setStreamPresented(false)
		else
			v42(false)
		end

		NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.click, analyticsConstants.EventNames.closeContent, {
			closeMethod = analyticsConstants.CloseMethod.backgroundOverlay
		})
	end

	if FFlagEnableHeaderBarButtonsUpdate then
		local v58 = React.createElement(Foundation.View, {
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
			Badge = if not (ThirdPartyUserService and (ThirdPartyUserService:IsChatRestrictionSupported() and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted)) then if not (v51 > 0) then nil else React.createElement(Foundation.StatusIndicator, {
				ZIndex = 2,
				max = 99,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0.5, 0.5),
				variant = Foundation.Enums.StatusIndicatorVariant.Alert,
				value = v51
			}) else nil,
			DisplayStreamNotifications = if v49 then nil else v54
		})

		if isAppNavEnabled() and v49 then
			return (React.createElement(Popover.Root, {
				isOpen = u48
			}, {
				Anchor = React.createElement(Popover.Anchor, nil, {
					BellIcon = v58
				}),
				Content = React.createElement(Popover.Content, {
					hasArrow = true,
					side = PopoverSide.Bottom,
					align = PopoverAlign.End,
					onPressedOutside = onPopoverDismiss,
					backgroundStyle = v50.Color.Surface.Surface_200
				}, {
					DisplayStreamNotifications = v54
				})
			}))
		end

		return v58
	end

	if isAppNavEnabled() then
		local v59 = if not v49 or not u48 then v37 else constants.Dropdown.BellIconOpen

		if v49 then
			return (React.createElement(Popover.Root, {
				isOpen = u48
			}, {
				Anchor = React.createElement(Popover.Anchor, nil, {
					BellIcon = React.createElement(UtilityActionIcon, {
						icon = v59,
						onActivated = onBellActivated,
						badgeValue = v55,
						buttonRef = t1.buttonRef
					})
				}),
				Content = React.createElement(Popover.Content, {
					hasArrow = true,
					side = PopoverSide.Bottom,
					align = PopoverAlign.End,
					onPressedOutside = onPopoverDismiss,
					backgroundStyle = v50.Color.Surface.Surface_200
				}, {
					DisplayStreamNotifications = v54
				})
			}))
		end

		return (React.createElement(UtilityActionIcon, {
			icon = v59,
			onActivated = onBellActivated,
			badgeValue = v55,
			buttonRef = t1.buttonRef
		}, {
			DisplayStreamNotifications = v54
		}))
	end

	return (React.createElement(IconButton, {
		size = UDim2.new(0, n1, 1, 0),
		icon = v37,
		iconSize = IconSize.Medium,
		layoutOrder = layoutOrder or 3,
		onActivated = onBellActivated,
		buttonRef = t1.buttonRef
	}, {
		notificationBadge = if not (ThirdPartyUserService and (ThirdPartyUserService:IsChatRestrictionSupported() and ThirdPartyUserService.FriendCommunicationRestrictionStatus ~= Enum.ChatRestrictionStatus.NotRestricted)) then if not (v51 > 0) then nil else React.createElement(Badge, {
			position = UDim2.new(0.5, 0, 0.5, 0),
			anchorPoint = Vector2.new(0, 1),
			value = v51,
			badgeVariant = BadgeVariant.Alert
		}) else nil
	}, { v54 }))
end

if GetFFlagNotificationsComplianceShouldRestrictStream() then
	v39 = RoactAppPolicy.connect(function(p1, _) -- line: 383
		return {
			shouldRestrictStream = p1.getNotificationsCanReceiveStream() or false
		}
	end)(v39)
end

return v39
