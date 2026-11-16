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
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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
	local v8 = if foundationFontFaceMigration then useTokens() else nil
	local font = v7.Font
	local font2 = if not foundationFontFaceMigration then font.Header1.Font else nil
	local v9

	if foundationFontFaceMigration then
		v9 = normalizeFontFace(v8.Typography.TitleMedium.Font)
	else
		v9 = nil
	end

	local v10

	if foundationFontFaceMigration then
		v10 = v8.Typography.TitleMedium.FontSize
	else
		v10 = font.BaseSize * font.CaptionHeader.RelativeSize
	end

	local state, setState = React.useState(true)
	local state2, setState2 = React.useState(74)
	local state3, setState3 = React.useState(true)

	local v11, v12 = ReactOtter.useAnimatedBinding({ shadowHeight = 0, shadowWidth = 1 })

	local v13 = useLocalization({
		moreText = constants.Text.ShowMoreKey,
		lessText = constants.Text.ShowLessKey
	})

	local v14 = React.useCallback(function(p2, p3)
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

			local v16 = if p2 then analyticsConstants.EventNames.bundleOpened else analyticsConstants.EventNames.bundleClosed
			fireEvent(eventStream, click, v16, {
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
		v12({
			shadowHeight = ReactOtter.spring(state and 0 or 1, v6),
			shadowWidth = ReactOtter.spring(state and 1 or 0, v6)
		})
	end, { state })

	React.useEffect(function()
		setState3(#data.notifications > 1)
	end, { data.notifications })

	local useMemo = React.useMemo
	local function fn3()
		local children = {}

		for i, notification in ipairs(data.notifications) do
			local v16

			if data.impressionMetadataByNotificationId then
				v16 = data.impressionMetadataByNotificationId[notification.id]
			end

			children[notification.id] = React.createElement(StreamNotificationAnimationWrapper, {
				layoutOrder = i,
				notification = notification,
				finishDismissNotification = data.finishDismissNotification,
				handleActions = data.handleActions,
				openMetaActions = data.openMetaActions,
				onHeightChange = v14,
				collapsed = state and state3 and true or false,
				impressionsTag = data.impressionsTag,
				impressionIndex = v16 and v16.impressionIndex or nil
			})
		end

		local createElement = React.createElement

		local v17 = if state or not state3 then UDim.new(0, 0) else UDim.new(0, 40)
		children.UIPadding = createElement("UIPadding", { PaddingTop = v17 })

		children.UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		})
		local v18

		if state and state3 then
			v18 = React.createElement("Frame", {
				Size = v11:map(function(p2)
					return UDim2.new(1, 0, 0, p2.shadowHeight * state2 + constants.DefaultPadding)
				end),
				LayoutOrder = #data.notifications + 1,
				ZIndex = -(#data.notifications + 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}, { React.createElement("Frame", {
					Size = v11:map(function(p2)
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

		children.Shadow1 = v18
		local v19

		if state and state3 then
			v19 = React.createElement("Frame", {
				Size = v11:map(function(p2)
					return UDim2.new(1, 0, 0, p2.shadowHeight * state2 + constants.DefaultPadding * 2)
				end),
				LayoutOrder = #data.notifications + 2,
				BackgroundTransparency = 1,
				ZIndex = -(#data.notifications + 2),
				BorderSizePixel = 0
			}, { React.createElement("Frame", {
					Size = v11:map(function(p2)
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

		children.Shadow2 = v19

		local createElement2 = React.createElement
		local v21 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = data.layoutOrder
		}

		local createElement3 = React.createElement

		local v24 = if state and state3 then UDim.new(0, constants.DefaultPadding) else UDim.new(0, 0)
		local children2 = {
			UIPadding = createElement3("UIPadding", { PaddingBottom = v24 }),
			ShowLessButton = 0,
			InvisibleExpandButton = 0,
			NumberMoreButton = 0,
			ListOfNotifications = 0
		}
		local v25

		if not (state or not state3) then
			v25 = React.createElement("TextButton", {
				Size = UDim2.new(0, 160, 0, 40),
				Text = "",
				Font = font2,
				FontFace = v9,
				TextSize = v10,
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
							Text = v13 and v13.lessText,
							LayoutOrder = 1,
							Font = font2,
							FontFace = v9,
							TextSize = v10,
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

		children2.ShowLessButton = v25

		children2.InvisibleExpandButton = React.createElement("TextButton", {
			Size = UDim2.new(1, 0, 0, not (state and state3) and 0 or state2 + constants.DefaultPadding * 2),
			BackgroundTransparency = 1,
			Text = "",
			[React.Event.Activated] = fn2,
			ZIndex = 5,
			BorderSizePixel = 0,
			AutoButtonColor = false
		})

		local v27 = if state2 ~= 0 and not not (state and #data.notifications > 1) then React.createElement("Frame", {
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
					Text = v13 and v13.moreText and string.gsub(
						v13.moreText,
						"{notificationCount}",
						(tostring(#data.notifications - 1))
					),
					LayoutOrder = 1,
					Font = font2,
					FontFace = v9,
					TextSize = v10,
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
		children2.NumberMoreButton = v27

		children2.ListOfNotifications = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			ZIndex = 3,
			BorderSizePixel = 0
		}, children)
		return createElement2("Frame", v21, children2)
	end

	local notifications = data.notifications

	local impressionsTag = data.impressionsTag
	local impressionMetadataByNotificationId = data.impressionMetadataByNotificationId
	local v16 = if foundationFontFaceMigration then v9 else nil
	return (useMemo(fn3, {
		notifications,
		state,
		state2,
		state3,
		impressionsTag,
		impressionMetadataByNotificationId,
		v16,
		if foundationFontFaceMigration then v10 else nil
	}))
end
