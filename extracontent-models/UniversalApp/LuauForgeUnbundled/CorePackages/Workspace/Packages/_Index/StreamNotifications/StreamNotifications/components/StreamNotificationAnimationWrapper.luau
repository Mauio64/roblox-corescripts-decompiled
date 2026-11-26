local React = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/React")
local constants = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/constants")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/ReactOtter")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/SharedFlags")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local darkTheme = UIBlox.App.Style.Themes.DarkTheme

local StreamNotificationDropdownExperimentation = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/StreamNotificationDropdownExperimentation")
local NotificationsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/NotificationsCommon")
local notificationCard = NotificationsCommon.NotificationCard
local notificationHelper = NotificationsCommon.NotificationHelper
local notificationCardProvider = NotificationsCommon.NotificationCardProvider
local marshalStreamNotificationData = notificationHelper.marshalStreamNotificationData

local useImpressionsTagger = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Impressions").useImpressionsTagger

local fFlagStreamNotificationImpressionLogging = SharedFlags.FFlagStreamNotificationImpressionLogging

local v5 = { stiffness = 207, damping = 24, mass = 1 }

return function(props)
	local v6 = useStyle()
	local dropdownEnabled = StreamNotificationDropdownExperimentation.getDropdownEnabled()
	local v7 = marshalStreamNotificationData(props.notification)
	local ref = React.useRef(nil)

	local state, setState = React.useState(0)
	local v8, v9 = ReactOtter.useAnimatedBinding({
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
		v9({
			dismissHeight = ReactOtter.spring(props.notification.dismiss and 0 or 1, v5),
			transparency = ReactOtter.spring(props.notification.dismiss and 0 or 1, v5),
			collapsedHeight = ReactOtter.spring(props.collapsed and 0 or 1, v5),
			collapsedWidth = ReactOtter.spring(props.collapsed and 1 or 0, v5)
		})
	end, { props.notification.dismiss, props.collapsed })

	local function fn(p2)
		if props.onHeightChange then
			props.onHeightChange(props.layoutOrder, p2.AbsoluteSize.Y)
		end
	end

	local function fn2(p2)
		if props.notification.dismiss ~= true then
			setState(p2.AbsoluteSize.Y + (dropdownEnabled and 0 or constants.DefaultPadding))
		end
	end

	local v10 = 0
	local v11

	if dropdownEnabled then
		v11 = 0
	else
		v11 = constants.DefaultPadding * 2

		if props.layoutOrder == 2 then
			v10 = constants.DefaultPadding * 2
		elseif props.layoutOrder == 3 then
			v10 = constants.DefaultPadding * 4
		elseif props.layoutOrder >= 4 then
			v10 = constants.DefaultPadding * 6
		end
	end

	if fFlagStreamNotificationImpressionLogging then
		useImpressionsTagger(ref, props.impressionsTag, props.impressionIndex)
	end

	local createElement = React.createElement
	local v13 = {
		ref = ref,
		Size = v8:map(function(data)
			if props.layoutOrder == 1 and props.collapsed then
				return UDim2.new(
					1,
					-(v11 + v10 * data.collapsedWidth),
					0,
					data.collapsedHeight * data.dismissHeight * state + (dropdownEnabled and 0 or constants.DefaultPadding)
				)
			end

			return UDim2.new(
				1,
				-(v11 + v10 * data.collapsedWidth),
				0,
				data.collapsedHeight * data.dismissHeight * state
			)
		end),
		BackgroundTransparency = 1,
		ClipsDescendants = props.layoutOrder ~= 1 and props.collapsed and true or false,
		LayoutOrder = props.layoutOrder or 1,
		ZIndex = not props.layoutOrder and 1 or -props.layoutOrder
	}

	local createElement2 = React.createElement
	local v16 = {
		Size = v8:map(function(p2)
			return UDim2.new(1, 0, 0, p2.dismissHeight * state)
		end),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		LayoutOrder = props.layoutOrder,
		[React.Change.AbsoluteSize] = fn
	}

	local createElement3 = React.createElement
	local v18 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = 0,
		BackgroundTransparency = 0,
		ZIndex = 2,
		Position = 0,
		AnchorPoint = 0
	}
	local v19 = if v6.theme == darkTheme then v6.Theme.Overlay.Color else v6.Theme.BackgroundMuted.Color
	v18.BackgroundColor3 = v19

	v18.BackgroundTransparency = v8:map(function(p2)
		return p2.transparency
	end)

	v18.Position = UDim2.fromScale(0.5, 0)
	v18.AnchorPoint = Vector2.new(0.5, 0)
	return createElement("Frame", v13, {
		DismissFrame = createElement2("Frame", v16, {
			FadeFrame = createElement3("Frame", v18, {}),
			InnerFrame = React.createElement("Frame", {
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				ZIndex = 1,
				Position = UDim2.fromScale(0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				[React.Change.AbsoluteSize] = fn2
			}, { React.createElement(notificationCardProvider, {
					notificationPayload = props.notification,
					state = v7.state,
					isCompact = false,
					readOnly = props.collapsed and true or false,
					handleActions = props.handleActions,
					openMetaActions = props.openMetaActions
				}, {
					NotificationCard = React.createElement(notificationCard, {
						isHover = false,
						layoutOrder = props.layoutOrder
					})
				}) })
		})
	})
end
