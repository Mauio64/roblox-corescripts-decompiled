local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local parent = StreamNotifications.Parent
local React = require(parent.React)
local constants = require(StreamNotifications.constants)
local ReactOtter = require(parent.ReactOtter)
local SharedFlags = require(parent.SharedFlags)

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local DarkTheme = UIBlox.App.Style.Themes.DarkTheme

local StreamNotificationDropdownExperimentation = require(StreamNotifications.StreamNotificationDropdownExperimentation)
local NotificationsCommon = require(parent.NotificationsCommon)
local NotificationCard = NotificationsCommon.NotificationCard
local NotificationHelper = NotificationsCommon.NotificationHelper
local NotificationCardProvider = NotificationsCommon.NotificationCardProvider
local marshalStreamNotificationData = NotificationHelper.marshalStreamNotificationData

local Impressions = require(parent.Impressions)
local useImpressionsTagger = Impressions.useImpressionsTagger

local FFlagStreamNotificationImpressionLogging = SharedFlags.FFlagStreamNotificationImpressionLogging

local v = { stiffness = 207, damping = 24, mass = 1 }

return function(props)
	local v2 = useStyle()
	local dropdownEnabled = StreamNotificationDropdownExperimentation.getDropdownEnabled()
	local v3 = marshalStreamNotificationData(props.notification)
	local ref = React.useRef(nil)

	local state, setState = React.useState(0)
	local v4, v5 = ReactOtter.useAnimatedBinding({
		dismissHeight = 1,
		transparency = 1,
		collapsedHeight = props.collapsed and 0 or 1,
		collapsedWidth = props.collapsed and 1 or 0
	}, function()
		if props.notification.dismiss then
			props.finishDismissNotification(props.notification.id)
		end
	end)

	React.useEffect(function()
		v5({
			dismissHeight = ReactOtter.spring(props.notification.dismiss and 0 or 1, v),
			transparency = ReactOtter.spring(props.notification.dismiss and 0 or 1, v),
			collapsedHeight = ReactOtter.spring(props.collapsed and 0 or 1, v),
			collapsedWidth = ReactOtter.spring(props.collapsed and 1 or 0, v)
		})
	end, { props.notification.dismiss, props.collapsed })

	local function fn(p)
		if props.onHeightChange then
			props.onHeightChange(props.layoutOrder, p.AbsoluteSize.Y)
		end
	end

	local function fn2(p)
		if props.notification.dismiss ~= true then
			setState(p.AbsoluteSize.Y + (dropdownEnabled and 0 or constants.DefaultPadding))
		end
	end

	local v6 = 0
	local v7

	if dropdownEnabled then
		v7 = 0
	else
		v7 = constants.DefaultPadding * 2

		if props.layoutOrder == 2 then
			v6 = constants.DefaultPadding * 2
		elseif props.layoutOrder == 3 then
			v6 = constants.DefaultPadding * 4
		elseif props.layoutOrder >= 4 then
			v6 = constants.DefaultPadding * 6
		end
	end

	if FFlagStreamNotificationImpressionLogging then
		useImpressionsTagger(ref, props.impressionsTag, props.impressionIndex)
	end

	local createElement = React.createElement
	local v8 = {
		ref = ref,
		Size = v4:map(function(data)
			if props.layoutOrder == 1 and props.collapsed then
				return UDim2.new(
					1,
					-(v7 + v6 * data.collapsedWidth),
					0,
					data.collapsedHeight * data.dismissHeight * state + (dropdownEnabled and 0 or constants.DefaultPadding)
				)
			end

			return UDim2.new(1, -(v7 + v6 * data.collapsedWidth), 0, data.collapsedHeight * data.dismissHeight * state)
		end),
		BackgroundTransparency = 1,
		ClipsDescendants = props.layoutOrder ~= 1 and props.collapsed and true or false,
		LayoutOrder = props.layoutOrder or 1,
		ZIndex = not props.layoutOrder and 1 or -props.layoutOrder
	}

	local createElement2 = React.createElement
	local v9 = {
		Size = v4:map(function(p)
			return UDim2.new(1, 0, 0, p.dismissHeight * state)
		end),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		LayoutOrder = props.layoutOrder,
		[React.Change.AbsoluteSize] = fn
	}

	local createElement3 = React.createElement
	local v10 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = 0,
		BackgroundTransparency = 0,
		ZIndex = 2,
		Position = 0,
		AnchorPoint = 0
	}
	local backgroundColor

	if v2.theme == DarkTheme then
		backgroundColor = v2.Theme.Overlay.Color
	else
		backgroundColor = v2.Theme.BackgroundMuted.Color
	end

	v10.BackgroundColor3 = backgroundColor

	v10.BackgroundTransparency = v4:map(function(p)
		return p.transparency
	end)

	v10.Position = UDim2.fromScale(0.5, 0)
	v10.AnchorPoint = Vector2.new(0.5, 0)
	return createElement("Frame", v8, {
		DismissFrame = createElement2("Frame", v9, {
			FadeFrame = createElement3("Frame", v10, {}),
			InnerFrame = React.createElement("Frame", {
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				ZIndex = 1,
				Position = UDim2.fromScale(0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				[React.Change.AbsoluteSize] = fn2
			}, { React.createElement(NotificationCardProvider, {
					notificationPayload = props.notification,
					state = v3.state,
					isCompact = false,
					readOnly = props.collapsed and true or false,
					handleActions = props.handleActions,
					openMetaActions = props.openMetaActions
				}, {
					NotificationCard = React.createElement(NotificationCard, {
						isHover = false,
						layoutOrder = props.layoutOrder
					})
				}) })
		})
	})
end
