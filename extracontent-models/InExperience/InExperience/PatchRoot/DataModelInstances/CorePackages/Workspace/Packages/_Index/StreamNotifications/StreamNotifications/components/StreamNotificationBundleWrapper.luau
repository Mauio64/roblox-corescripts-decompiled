local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local components = StreamNotifications.components
local parent = StreamNotifications.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local constants = require(StreamNotifications.constants)
local ReactOtter = require(parent.ReactOtter)

local NotificationsCommon = require(parent.NotificationsCommon)
local StreamNotificationAnimationWrapper = require(components.StreamNotificationAnimationWrapper)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local NotificationHelper = NotificationsCommon.NotificationHelper

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local iconsactionstruncationExpand = Images["icons/actions/truncationExpand"]
local iconsactionstruncationCollapse = Images["icons/actions/truncationCollapse"]

local udim = UDim.new(0, 12)
local udim2 = UDim.new(0, 24)

local v = constants.DefaultPadding * 4
local udim3 = UDim2.fromOffset(24, 24)

local analyticsService = require(StreamNotifications.analytics.analyticsService)
local eventStream = analyticsService.EventStream
local analyticsConstants = require(StreamNotifications.analytics.analyticsConstants)

local v2 = { stiffness = 207, damping = 24, mass = 1 }

return function(data)
	local v3 = useStyle()
	local v4 = useTokens()
	local fontFace = normalizeFontFace(v4.Typography.TitleMedium.Font)
	local fontSize = v4.Typography.TitleMedium.FontSize

	local state, setState = React.useState(true)
	local state2, setState2 = React.useState(74)
	local state3, setState3 = React.useState(true)

	local v5, v6 = ReactOtter.useAnimatedBinding({ shadowHeight = 0, shadowWidth = 1 })

	local v7 = useLocalization({
		moreText = constants.Text.ShowMoreKey,
		lessText = constants.Text.ShowLessKey
	})

	local onHeightChange = React.useCallback(function(p: number, p2: number)
		if p == 1 and state then
			setState2(p2)
		end
	end)

	local function fn(notifications)
		local ids = {}

		for _, item in notifications do
			if item.id then
				table.insert(ids, item.id)
			end
		end

		return ids
	end

	local function fn2()
		setState(function(p): boolean
			local fireEvent = NotificationHelper.fireEvent

			local click = analyticsConstants.Context.click
			local v8

			if p then
				v8 = analyticsConstants.EventNames.bundleOpened
			else
				v8 = analyticsConstants.EventNames.bundleClosed
			end

			fireEvent(eventStream, click, v8, {
				bundleKey = data.notifications[1].content.bundleKey or nil,
				totalNotifications = #data.notifications or nil,
				notificationIds = fn(data.notifications) or nil
			})

			if p then
				for k, notification in data.notifications do
					NotificationHelper.fireEvent(
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

			return not p
		end)
	end

	React.useEffect(function()
		v6({
			shadowHeight = ReactOtter.spring(state and 0 or 1, v2),
			shadowWidth = ReactOtter.spring(state and 1 or 0, v2)
		})
	end, { state })

	React.useEffect(function()
		setState3(#data.notifications > 1)
	end, { data.notifications })

	return (React.useMemo(function()
		local children = {}

		for i, notification in ipairs(data.notifications) do
			local v8

			if data.impressionMetadataByNotificationId then
				v8 = data.impressionMetadataByNotificationId[notification.id]
			end

			children[notification.id] = React.createElement(StreamNotificationAnimationWrapper, {
				layoutOrder = i,
				notification = notification,
				finishDismissNotification = data.finishDismissNotification,
				handleActions = data.handleActions,
				openMetaActions = data.openMetaActions,
				onHeightChange = onHeightChange,
				collapsed = state and state3 and true or false,
				impressionsTag = data.impressionsTag,
				impressionIndex = v8 and v8.impressionIndex or nil
			})
		end

		local createElement = React.createElement
		local paddingTop

		if state or not state3 then
			paddingTop = UDim.new(0, 0)
		else
			paddingTop = UDim.new(0, 40)
		end

		children.UIPadding = createElement("UIPadding", { PaddingTop = paddingTop })

		children.UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		})
		local shadow

		if state and state3 then
			shadow = React.createElement("Frame", {
				Size = v5:map(function(p)
					return UDim2.new(1, 0, 0, p.shadowHeight * state2 + constants.DefaultPadding)
				end),
				LayoutOrder = #data.notifications + 1,
				ZIndex = -(#data.notifications + 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}, { React.createElement("Frame", {
					Size = v5:map(function(p)
						return UDim2.new(
							1,
							-(constants.DefaultPadding * 4 * p.shadowWidth),
							0,
							state2 - constants.DefaultPadding
						)
					end),
					BackgroundColor3 = v3.Theme.BackgroundDefault.Color,
					BackgroundTransparency = 0,
					BorderSizePixel = 0,
					Position = UDim2.new(0.5, 0, 0, 0),
					AnchorPoint = Vector2.new(0.5, 0)
				}, {
					UICorner = React.createElement("UICorner", { CornerRadius = udim })
				}) })
		end

		children.Shadow1 = shadow
		local shadow2

		if state and state3 then
			shadow2 = React.createElement("Frame", {
				Size = v5:map(function(p)
					return UDim2.new(1, 0, 0, p.shadowHeight * state2 + constants.DefaultPadding * 2)
				end),
				LayoutOrder = #data.notifications + 2,
				BackgroundTransparency = 1,
				ZIndex = -(#data.notifications + 2),
				BorderSizePixel = 0
			}, { React.createElement("Frame", {
					Size = v5:map(function(p)
						return UDim2.new(
							1,
							-(constants.DefaultPadding * 6 * p.shadowWidth),
							0,
							state2 - constants.DefaultPadding
						)
					end),
					BackgroundColor3 = v3.Theme.BackgroundContrast.Color,
					BackgroundTransparency = 0,
					BorderSizePixel = 0,
					Position = UDim2.new(0.5, 0, 0, 0),
					AnchorPoint = Vector2.new(0.5, 0)
				}, {
					UICorner = React.createElement("UICorner", { CornerRadius = udim })
				}) })
		end

		children.Shadow2 = shadow2

		local createElement2 = React.createElement
		local v8 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = data.layoutOrder
		}

		local createElement3 = React.createElement
		local paddingBottom

		if state and state3 then
			paddingBottom = UDim.new(0, constants.DefaultPadding)
		else
			paddingBottom = UDim.new(0, 0)
		end

		local children2 = {
			UIPadding = createElement3("UIPadding", { PaddingBottom = paddingBottom }),
			ShowLessButton = 0,
			InvisibleExpandButton = 0,
			NumberMoreButton = 0,
			ListOfNotifications = 0
		}
		local showLessButton

		if not (state or not state3) then
			showLessButton = React.createElement("TextButton", {
				Size = UDim2.new(0, 160, 0, 40),
				Text = "",
				FontFace = fontFace,
				TextSize = fontSize,
				[React.Event.Activated] = fn2,
				BackgroundTransparency = 1,
				BackgroundColor3 = v3.Theme.BackgroundMuted.Color,
				AutoButtonColor = false,
				LayoutOrder = 1,
				ZIndex = 4,
				Position = UDim2.new(1, 0, 0, 0),
				AnchorPoint = Vector2.new(1, 0),
				BorderSizePixel = 0
			}, { React.createElement("Frame", {
					Size = UDim2.new(1, -constants.DefaultPadding, 1, -constants.DefaultPadding),
					BackgroundTransparency = 0,
					BackgroundColor3 = v3.Theme.BackgroundContrast.Color,
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
							Text = v7 and v7.lessText,
							LayoutOrder = 1,
							FontFace = fontFace,
							TextSize = fontSize,
							BackgroundTransparency = 1,
							TextColor3 = v3.Theme.TextMuted.Color,
							Size = UDim2.new(0, 0, 1, 0),
							AutomaticSize = Enum.AutomaticSize.X
						}, { React.createElement("UIPadding", {
								PaddingRight = UDim.new(0, constants.DefaultPadding)
							}) }),
						CollapseIcon = React.createElement(ImageSetLabel, {
							LayoutOrder = 2,
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.fromScale(0.5, 0.5),
							Size = udim3,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Image = iconsactionstruncationCollapse,
							ImageColor3 = v3.Theme.UIEmphasis.Color
						})
					})
				}) })
		end

		children2.ShowLessButton = showLessButton

		children2.InvisibleExpandButton = React.createElement("TextButton", {
			Size = UDim2.new(1, 0, 0, not (state and state3) and 0 or state2 + constants.DefaultPadding * 2),
			BackgroundTransparency = 1,
			Text = "",
			[React.Event.Activated] = fn2,
			ZIndex = 5,
			BorderSizePixel = 0,
			AutoButtonColor = false
		})
		local numberMoreButton

		if not (state2 == 0 or not (state and #data.notifications > 1)) then
			numberMoreButton = React.createElement("Frame", {
				Size = UDim2.new(0, 125, 0, v),
				AutomaticSize = Enum.AutomaticSize.X,
				Position = UDim2.new(0.5, 0, 1, 0),
				AnchorPoint = Vector2.new(0.5, 1),
				ZIndex = 10,
				BackgroundColor3 = v3.Theme.BackgroundContrast.Color,
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
						Text = v7 and v7.moreText and string.gsub(
							v7.moreText,
							"{notificationCount}",
							(tostring(#data.notifications - 1))
						),
						LayoutOrder = 1,
						FontFace = fontFace,
						TextSize = fontSize,
						BackgroundTransparency = 1,
						TextColor3 = v3.Theme.TextMuted.Color,
						Size = UDim2.new(0, 0, 1, 0),
						AutomaticSize = Enum.AutomaticSize.X
					}, { React.createElement("UIPadding", {
							PaddingRight = UDim.new(0, constants.DefaultPadding)
						}) }),
					ExpandIcon = React.createElement(ImageSetLabel, {
						LayoutOrder = 2,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						Size = udim3,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Image = iconsactionstruncationExpand,
						ImageColor3 = v3.Theme.UIEmphasis.Color
					})
				})
			})
		end

		children2.NumberMoreButton = numberMoreButton

		children2.ListOfNotifications = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			ZIndex = 3,
			BorderSizePixel = 0
		}, children)
		return createElement2("Frame", v8, children2)
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
