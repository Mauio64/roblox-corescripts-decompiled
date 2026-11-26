local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/dependencies")
local NotificationStyledText = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/components/NotificationStyledText")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/components/NotificationThumbnail")
require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/type")
local react = dependencies.React
local uiBlox = dependencies.UIBlox
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/Foundation")
local useStyle = uiBlox.Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/constants")
local useNotificationCardState = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/context/useNotificationCardState")
local useNotificationCardData = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/context/useNotificationCardData")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/components/NotificationActionsFrame")

local iconButton = uiBlox.App.Button.IconButton
local images = uiBlox.App.ImageSet.Images
local iconSize = uiBlox.App.ImageSet.Enum.IconSize
local iconscommonoverflow = images["icons/common/overflow"]

local defaultContentPadding = constants.DefaultContentPadding
local defaultTextContentPadding = constants.DefaultTextContentPadding
local metaActionsWidth = constants.MetaActionsWidth
local timestampWidth = constants.TimestampWidth
local timestampHeight = constants.TimestampHeight

return function()
	local v5 = useStyle()
	local v6 = useTokens()
	local fontSize = v6.Typography.CaptionLarge.FontSize
	local fontSize2 = v6.Typography.BodySmall.FontSize
	local v7 = useNotificationCardData()
	local cardSize = v7.cardSize
	local readOnly = v7.readOnly
	local thumbnail = cardSize and cardSize.thumbnail or constants.CardSizeDefault.thumbnail
	local openMetaActions = v7.openMetaActions
	local notificationPayload = v7.notificationPayload
	local handleActions = v7.handleActions

	local v8 = useNotificationCardState("textBody")
	local v9 = v8 and v8[1]

	local v10 = v9 and v9.title and {
		Text = v9.title,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextSize = fontSize,
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = 1,
		FontFace = normalizeFontFace(v6.Typography.CaptionLarge.Font),
		TextColor3 = v5.Theme.TextEmphasis.Color
	}

	local v11 = v9 and v9.label and {
		Text = v9.label,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextSize = fontSize2,
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = 2,
		FontFace = normalizeFontFace(v6.Typography.BodySmall.Font),
		TextColor3 = v5.Theme.TextEmphasis.Color
	}
	local v12

	if readOnly then
		v12 = -defaultTextContentPadding
	else
		v12 = -(metaActionsWidth + defaultTextContentPadding)
	end

	local v13 = notificationPayload and notificationPayload.timestamp and {
		Text = { text = notificationPayload.timestamp },
		Size = UDim2.new(0, timestampWidth + defaultTextContentPadding, 0, timestampHeight),
		TextSize = fontSize,
		AutomaticSize = Enum.AutomaticSize.Y,
		TextXAlignment = Enum.TextXAlignment.Right,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, v12, 0, 0),
		LayoutOrder = 2,
		FontFace = normalizeFontFace(v6.Typography.CaptionLarge.Font),
		TextColor3 = v5.Theme.TextEmphasis.Color,
		TextTransparency = 0
	}

	local createElement = react.createElement
	local v15 = {
		Selectable = false,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		Text = "",
		AutoButtonColor = false,
		BorderSizePixel = 0,
		[react.Event.Activated] = function()
			if handleActions and v9 and notificationPayload then
				handleActions(v9, notificationPayload)
			end
		end
	}
	local v16 = {
		UIListLayout = react.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, defaultContentPadding)
		}),
		NotificationThumbnailFrame = react.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(0, thumbnail, 0, thumbnail)
			},
			{ NotificationThumbnail = react.createElement(module3) }
		),
		ContentFrame = 0
	}

	local createElement2 = react.createElement
	local v18 = {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, -(thumbnail + defaultContentPadding), 0, 0)
	}
	local v19 = {
		UIListLayout = react.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, defaultTextContentPadding)
		}),
		NotificationsBody = 0,
		NotificationActionsFrame = 0
	}

	local createElement3 = react.createElement
	local v21 = {
		Size = UDim2.new(1, 0, 0, constants.MetaActionsHeight),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1,
		BackgroundTransparency = 1
	}

	local createElement4 = react.createElement

	local newUDim2 = UDim2.new
	local v26

	if readOnly then
		v26 = -(timestampWidth + defaultTextContentPadding)
	else
		v26 = -(metaActionsWidth + timestampWidth + defaultTextContentPadding * 2)
	end

	local v24 = {
		BackgroundTransparency = 1,
		Size = newUDim2(1, v26, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local v27 = {
		UIPadding = react.createElement("UIPadding", {
			PaddingTop = UDim.new(0, defaultTextContentPadding)
		}),
		UIListLayout = react.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, defaultTextContentPadding)
		}),
		Title = 0,
		Subtitle = 0
	}

	local v28 = if v10 then react.createElement(NotificationStyledText, v10) else nil
	v27.Title = v28

	local v29 = if v11 then react.createElement(NotificationStyledText, v11) else nil
	v27.Subtitle = v29
	local v22 = {
		NotificationsText = createElement4("Frame", v24, v27),
		Timestamp = 0,
		MetaActionsButton = 0
	}

	local v30 = if v13 then react.createElement(NotificationStyledText, v13) else nil
	v22.Timestamp = v30
	local v31

	if openMetaActions and not readOnly then
		v31 = react.createElement(iconButton, {
			anchorPoint = Vector2.new(1, 0),
			position = UDim2.new(1, 0, 0, 0),
			size = UDim2.fromOffset(0, 0),
			iconSize = iconSize.Medium,
			icon = iconscommonoverflow,
			layoutOrder = 3,
			onActivated = function()
				openMetaActions(notificationPayload)
			end
		})
	end

	v22.MetaActionsButton = v31
	v19.NotificationsBody = createElement3("Frame", v21, v22)

	local v32 = if not readOnly then react.createElement(module8) else nil
	v19.NotificationActionsFrame = v32
	v16.ContentFrame = createElement2("Frame", v18, v19)
	return createElement("TextButton", v15, v16)
end
