local React = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Foundation")
local constants = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/constants")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/ReactOtter")

local NotificationsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/NotificationsCommon")
local StreamNotificationAnimationWrapper = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/components/StreamNotificationAnimationWrapper")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Localization").Hooks.useLocalization
local notificationHelper = NotificationsCommon.NotificationHelper

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local iconsactionstruncationExpand = images["icons/actions/truncationExpand"]
local iconsactionstruncationCollapse = images["icons/actions/truncationCollapse"]

local udim = UDim.new(0, 12)
local udim2 = UDim.new(0, 24)

local v5 = constants.DefaultPadding * 4
local udim3 = UDim2.fromOffset(24, 24)

local eventStream = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/analytics/analyticsService").EventStream
local analyticsConstants = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/analytics/analyticsConstants")

local v6 = { stiffness = 207, damping = 24, mass = 1 }

return function(data)
	local v7 = useStyle()
	local v8 = useTokens()
	local fontFace = normalizeFontFace(v8.Typography.TitleMedium.Font)
	local fontSize = v8.Typography.TitleMedium.FontSize

	local state, setState = React.useState(true)
	local state2, setState2 = React.useState(74)
	local state3, setState3 = React.useState(true)

	local v9, v10 = ReactOtter.useAnimatedBinding({ shadowHeight = 0, shadowWidth = 1 })

	local v11 = useLocalization({
		moreText = constants.Text.ShowMoreKey,
		lessText = constants.Text.ShowLessKey
	})

	local v12 = React.useCallback(function(p2, p3)
		if p2 == 1 and state then
			setState2(p3)
		end
	end)

	local function fn(notifications)
		local ids = {}

		for k, item in notifications do
			if item.id then
				table.insert(ids, item.id)
			end
		end

		return ids
	end

	local function fn2()
		setState(function(p2): boolean
			local fireEvent = notificationHelper.fireEvent

			local click = analyticsConstants.Context.click

			local v14 = if p2 then analyticsConstants.EventNames.bundleOpened else analyticsConstants.EventNames.bundleClosed
			fireEvent(eventStream, click, v14, {
				bundleKey = data.notifications[1].content.bundleKey or nil,
				totalNotifications = #data.notifications or nil,
				notificationIds = fn(data.notifications) or nil
			})

			if p2 then
				for k, notification in data.notifications do
					notificationHelper.fireEvent(
						eventStream,
						analyticsConstants.Context.seen,
						analyticsConstants.EventNames.notificationViewed,
						{
							notificationId = notification.id or nil,
							notificationType = notification.content.notificationType or nil,
							bundlePosition = k,
							bundleKey = notification.content.bundleKey or nil,
							clientEventsPayload = notification.content.clientEventsPayload or nil
						}
					)
				end
			end

			return not p2
		end)
	end

	React.useEffect(function()
		v10({
			shadowHeight = ReactOtter.spring(state and 0 or 1, v6),
			shadowWidth = ReactOtter.spring(state and 1 or 0, v6)
		})
	end, { state })

	React.useEffect(function()
		setState3(#data.notifications > 1)
	end, { data.notifications })

	return (React.useMemo(function()
		local children = {}

		for i, notification in ipairs(data.notifications) do
			local v14

			if data.impressionMetadataByNotificationId then
				v14 = data.impressionMetadataByNotificationId[notification.id]
			end

			children[notification.id] = React.createElement(StreamNotificationAnimationWrapper, {
				layoutOrder = i,
				notification = notification,
				finishDismissNotification = data.finishDismissNotification,
				handleActions = data.handleActions,
				openMetaActions = data.openMetaActions,
				onHeightChange = v12,
				collapsed = state and state3 and true or false,
				impressionsTag = data.impressionsTag,
				impressionIndex = v14 and v14.impressionIndex or nil
			})
		end

		local createElement = React.createElement

		local v15 = if state or not state3 then UDim.new(0, 0) else UDim.new(0, 40)
		children.UIPadding = createElement("UIPadding", { PaddingTop = v15 })

		children.UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		})
		local v16

		if state and state3 then
			v16 = React.createElement("Frame", {
				Size = v9:map(function(p2)
					return UDim2.new(1, 0, 0, p2.shadowHeight * state2 + constants.DefaultPadding)
				end),
				LayoutOrder = #data.notifications + 1,
				ZIndex = -(#data.notifications + 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}, { React.createElement("Frame", {
					Size = v9:map(function(p2)
						return UDim2.new(
							1,
							-(constants.DefaultPadding * 4 * p2.shadowWidth),
							0,
							state2 - constants.DefaultPadding
						)
					end),
					BackgroundColor3 = v7.Theme.BackgroundDefault.Color,
					BackgroundTransparency = 0,
					BorderSizePixel = 0,
					Position = UDim2.new(0.5, 0, 0, 0),
					AnchorPoint = Vector2.new(0.5, 0)
				}, {
					UICorner = React.createElement("UICorner", { CornerRadius = udim })
				}) })
		end

		children.Shadow1 = v16
		local v17

		if state and state3 then
			v17 = React.createElement("Frame", {
				Size = v9:map(function(p2)
					return UDim2.new(1, 0, 0, p2.shadowHeight * state2 + constants.DefaultPadding * 2)
				end),
				LayoutOrder = #data.notifications + 2,
				BackgroundTransparency = 1,
				ZIndex = -(#data.notifications + 2),
				BorderSizePixel = 0
			}, { React.createElement("Frame", {
					Size = v9:map(function(p2)
						return UDim2.new(
							1,
							-(constants.DefaultPadding * 6 * p2.shadowWidth),
							0,
							state2 - constants.DefaultPadding
						)
					end),
					BackgroundColor3 = v7.Theme.BackgroundContrast.Color,
					BackgroundTransparency = 0,
					BorderSizePixel = 0,
					Position = UDim2.new(0.5, 0, 0, 0),
					AnchorPoint = Vector2.new(0.5, 0)
				}, {
					UICorner = React.createElement("UICorner", { CornerRadius = udim })
				}) })
		end

		children.Shadow2 = v17

		local createElement2 = React.createElement
		local v19 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = data.layoutOrder
		}

		local createElement3 = React.createElement

		local v22 = if state and state3 then UDim.new(0, constants.DefaultPadding) else UDim.new(0, 0)
		local children2 = {
			UIPadding = createElement3("UIPadding", { PaddingBottom = v22 }),
			ShowLessButton = 0,
			InvisibleExpandButton = 0,
			NumberMoreButton = 0,
			ListOfNotifications = 0
		}
		local v23

		if not (state or not state3) then
			v23 = React.createElement("TextButton", {
				Size = UDim2.new(0, 160, 0, 40),
				Text = "",
				FontFace = fontFace,
				TextSize = fontSize,
				[React.Event.Activated] = fn2,
				BackgroundTransparency = 1,
				BackgroundColor3 = v7.Theme.BackgroundMuted.Color,
				AutoButtonColor = false,
				LayoutOrder = 1,
				ZIndex = 4,
				Position = UDim2.new(1, 0, 0, 0),
				AnchorPoint = Vector2.new(1, 0),
				BorderSizePixel = 0
			}, { React.createElement("Frame", {
					Size = UDim2.new(1, -constants.DefaultPadding, 1, -constants.DefaultPadding),
					BackgroundTransparency = 0,
					BackgroundColor3 = v7.Theme.BackgroundContrast.Color,
					Position = UDim2.new(1, -constants.DefaultPadding, 0, 0),
					AnchorPoint = Vector2.new(1, 0),
					ZIndex = 10,
					BorderSizePixel = 0
				}, {
					UICorner = React.createElement("UICorner", { CornerRadius = udim2 }),
					ShowLessTextAndIconFrame = React.createElement("Frame", {
						AutomaticSize = Enum.AutomaticSize.XY,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BorderSizePixel = 0,
						BackgroundTransparency = 1
					}, {
						UIListLayout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
							HorizontalAlignment = Enum.HorizontalAlignment.Center
						}),
						ShowLessText = React.createElement("TextLabel", {
							Text = v11 and v11.lessText,
							LayoutOrder = 1,
							FontFace = fontFace,
							TextSize = fontSize,
							BackgroundTransparency = 1,
							TextColor3 = v7.Theme.TextMuted.Color,
							Size = UDim2.new(0, 0, 1, 0),
							AutomaticSize = Enum.AutomaticSize.X
						}, { React.createElement("UIPadding", {
								PaddingRight = UDim.new(0, constants.DefaultPadding)
							}) }),
						CollapseIcon = React.createElement(imageSetLabel, {
							LayoutOrder = 2,
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.fromScale(0.5, 0.5),
							Size = udim3,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Image = iconsactionstruncationCollapse,
							ImageColor3 = v7.Theme.UIEmphasis.Color
						})
					})
				}) })
		end

		children2.ShowLessButton = v23

		children2.InvisibleExpandButton = React.createElement("TextButton", {
			Size = UDim2.new(1, 0, 0, not (state and state3) and 0 or state2 + constants.DefaultPadding * 2),
			BackgroundTransparency = 1,
			Text = "",
			[React.Event.Activated] = fn2,
			ZIndex = 5,
			BorderSizePixel = 0,
			AutoButtonColor = false
		})

		local v25 = if state2 ~= 0 and not not (state and #data.notifications > 1) then React.createElement("Frame", {
			Size = UDim2.new(0, 125, 0, v5),
			AutomaticSize = Enum.AutomaticSize.X,
			Position = UDim2.new(0.5, 0, 1, 0),
			AnchorPoint = Vector2.new(0.5, 1),
			ZIndex = 10,
			BackgroundColor3 = v7.Theme.BackgroundContrast.Color,
			BackgroundTransparency = 0
		}, {
			UICorner = React.createElement("UICorner", { CornerRadius = udim2 }),
			NumberedMoreTextAndIconFrame = React.createElement("Frame", {
				AutomaticSize = Enum.AutomaticSize.XY,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				NumberMoreText = React.createElement("TextLabel", {
					Text = v11 and v11.moreText and string.gsub(
						v11.moreText,
						"{notificationCount}",
						(tostring(#data.notifications - 1))
					),
					LayoutOrder = 1,
					FontFace = fontFace,
					TextSize = fontSize,
					BackgroundTransparency = 1,
					TextColor3 = v7.Theme.TextMuted.Color,
					Size = UDim2.new(0, 0, 1, 0),
					AutomaticSize = Enum.AutomaticSize.X
				}, { React.createElement("UIPadding", {
						PaddingRight = UDim.new(0, constants.DefaultPadding)
					}) }),
				ExpandIcon = React.createElement(imageSetLabel, {
					LayoutOrder = 2,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = udim3,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Image = iconsactionstruncationExpand,
					ImageColor3 = v7.Theme.UIEmphasis.Color
				})
			})
		}) else nil
		children2.NumberMoreButton = v25

		children2.ListOfNotifications = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			ZIndex = 3,
			BorderSizePixel = 0
		}, children)
		return createElement2("Frame", v19, children2)
	end, {
		data.notifications,
		state,
		state2,
		state3,
		data.impressionsTag,
		data.impressionMetadataByNotificationId,
		fontFace,
		fontSize
	}))
end
