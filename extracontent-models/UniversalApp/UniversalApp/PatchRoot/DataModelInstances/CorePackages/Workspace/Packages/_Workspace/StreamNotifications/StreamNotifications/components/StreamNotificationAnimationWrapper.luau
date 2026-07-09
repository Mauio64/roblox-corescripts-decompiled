local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local StreamNotificationsParent = StreamNotifications.Parent
local React = require(StreamNotificationsParent.React)
local constants = require(StreamNotifications.constants)
local ReactOtter = require(StreamNotificationsParent.ReactOtter)
local SharedFlags = require(StreamNotificationsParent.SharedFlags)
local UIBlox = require(StreamNotificationsParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local DarkTheme = UIBlox.App.Style.Themes.DarkTheme
local StreamNotificationDropdownExperimentation = require(StreamNotifications.StreamNotificationDropdownExperimentation)
local NotificationsCommon = require(StreamNotificationsParent.NotificationsCommon)
local NotificationCard = NotificationsCommon.NotificationCard
local NotificationHelper = NotificationsCommon.NotificationHelper
local NotificationCardProvider = NotificationsCommon.NotificationCardProvider
local marshalStreamNotificationData = NotificationHelper.marshalStreamNotificationData
local useImpressionsTagger = require(StreamNotificationsParent.Impressions).useImpressionsTagger
local FFlagStreamNotificationImpressionLogging = SharedFlags.FFlagStreamNotificationImpressionLogging
local t1 = {
	stiffness = 207,
	damping = 24,
	mass = 1
}

return function(t2: {[any]: any}) -- line: 51
	-- upvalues: useStyle (copy), StreamNotificationDropdownExperimentation (copy), marshalStreamNotificationData (copy), React (copy), ReactOtter (copy), t1 (copy), constants (copy), FFlagStreamNotificationImpressionLogging (copy), useImpressionsTagger (copy), DarkTheme (copy), NotificationCardProvider (copy), NotificationCard (copy)
	local v20 = useStyle()
	local v21 = StreamNotificationDropdownExperimentation.getDropdownEnabled()
	local v22 = marshalStreamNotificationData(t2.notification)
	local v23 = React.useRef(nil)
	local v24, v25 = React.useState(0)
	local v26, v27 = ReactOtter.useAnimatedBinding({
		dismissHeight = 1,
		transparency = 1,
		collapsedHeight = not t2.collapsed and 1 or 0,
		collapsedWidth = not t2.collapsed and 0 or 1
	}, function() -- line: 63
		-- upvalues: t2 (copy)
		if t2.notification.dismiss then
			t2.finishDismissNotification(t2.notification.id)
		end
	end)

	React.useEffect(function() -- line: 70
		-- upvalues: v27 (copy), ReactOtter (copy), t2 (copy), t1 (copy)
		v27({
			dismissHeight = ReactOtter.spring(not t2.notification.dismiss and 1 or 0, t1),
			transparency = ReactOtter.spring(not t2.notification.dismiss and 1 or 0, t1),
			collapsedHeight = ReactOtter.spring(not t2.collapsed and 1 or 0, t1),
			collapsedWidth = ReactOtter.spring(not t2.collapsed and 0 or 1, t1)
		})
	end, {
		t2.notification.dismiss,
		t2.collapsed
	})

	local n1 = 0
	local n2 = 0

	if not v21 then
		n1 = constants.DefaultPadding * 2

		if t2.layoutOrder == 2 then
			n2 = constants.DefaultPadding * 2
		elseif t2.layoutOrder == 3 then
			n2 = constants.DefaultPadding * 4
		elseif t2.layoutOrder >= 4 then
			n2 = constants.DefaultPadding * 6
		end
	end

	if FFlagStreamNotificationImpressionLogging then
		useImpressionsTagger(v23, t2.impressionsTag, t2.impressionIndex)
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ref = v23,
		Size = v26:map(function(t3: {[any]: any}) -- line: 114
			-- upvalues: t2 (copy), n1 (ref), n2 (ref), v24 (copy), v21 (copy), constants (copy)
			if t2.layoutOrder == 1 and t2.collapsed then
				return UDim2.new(1, -(n1 + n2 * t3.collapsedWidth), 0, t3.collapsedHeight * t3.dismissHeight * v24 + if not v21 then constants.DefaultPadding else 0)
			end

			return UDim2.new(1, -(n1 + n2 * t3.collapsedWidth), 0, t3.collapsedHeight * t3.dismissHeight * v24)
		end),
		ClipsDescendants = t2.layoutOrder ~= 1 and not not t2.collapsed,
		LayoutOrder = t2.layoutOrder or 1,
		ZIndex = not t2.layoutOrder and 1 or -t2.layoutOrder
	}, {
		DismissFrame = React.createElement("Frame", {
			Size = v26:map(function(t4: {[any]: any}) -- line: 138
				-- upvalues: v24 (copy)
				return UDim2.new(1, 0, 0, t4.dismissHeight * v24)
			end),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			LayoutOrder = t2.layoutOrder,
			[React.Change.AbsoluteSize] = function(p1) -- line: 79
				-- upvalues: t2 (copy)
				if t2.onHeightChange then
					t2.onHeightChange(t2.layoutOrder, p1.AbsoluteSize.Y)
				end
			end
		}, {
			FadeFrame = React.createElement("Frame", {
				ZIndex = 2,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = if v20.theme ~= DarkTheme then v20.Theme.BackgroundMuted.Color else v20.Theme.Overlay.Color,
				BackgroundTransparency = v26:map(function(p2) -- line: 152
					return p2.transparency
				end),
				Position = UDim2.fromScale(0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0)
			}, {}),
			InnerFrame = React.createElement("Frame", {
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				ZIndex = 1,
				Position = UDim2.fromScale(0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				[React.Change.AbsoluteSize] = function(p3) -- line: 85
					-- upvalues: t2 (copy), v21 (copy), constants (copy), v25 (copy)
					if t2.notification.dismiss ~= true then
						local v32 = p3.AbsoluteSize.Y + if not v21 then constants.DefaultPadding else 0

						v25(v32)
					end
				end
			}, { React.createElement(NotificationCardProvider, {
				isCompact = false,
				notificationPayload = t2.notification,
				state = v22.state,
				readOnly = not not t2.collapsed,
				handleActions = t2.handleActions,
				openMetaActions = t2.openMetaActions
			}, {
				NotificationCard = React.createElement(NotificationCard, {
					isHover = false,
					layoutOrder = t2.layoutOrder
				})
			}) })
		})
	})
end
