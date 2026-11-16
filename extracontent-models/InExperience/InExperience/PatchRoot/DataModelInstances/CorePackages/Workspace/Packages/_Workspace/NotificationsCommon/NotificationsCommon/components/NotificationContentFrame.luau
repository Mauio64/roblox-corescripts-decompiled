local NotificationsCommon = script:FindFirstAncestor("NotificationsCommon")
local parent = NotificationsCommon.Parent
local components = NotificationsCommon.components
local context = NotificationsCommon.context
local dependencies = require(NotificationsCommon.dependencies)
local NotificationStyledText = require(components.NotificationStyledText)
local NotificationThumbnail = require(components.NotificationThumbnail)
require(NotificationsCommon.type)
local react = dependencies.React
local uiBlox = dependencies.UIBlox
local Foundation = require(parent.Foundation)
local useStyle = uiBlox.Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local constants = require(NotificationsCommon.constants)
local useNotificationCardState = require(context.useNotificationCardState)
local useNotificationCardData = require(context.useNotificationCardData)
local NotificationActionsFrame = require(components.NotificationActionsFrame)

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
	local v = useStyle()
	local v2

	if FoundationFontFaceMigration then
		v2 = useTokens()
	end

	local textSize

	if FoundationFontFaceMigration then
		textSize = v2.Typography.CaptionLarge.FontSize
	else
		textSize = v.Font.BaseSize * v.Font.CaptionHeader.RelativeSize
	end

	local textSize2

	if FoundationFontFaceMigration then
		textSize2 = v2.Typography.BodySmall.FontSize
	else
		textSize2 = v.Font.BaseSize * v.Font.CaptionBody.RelativeSize
	end

	local v3 = useNotificationCardData()
	local cardSize = v3.cardSize
	local readOnly = v3.readOnly
	local thumbnail = cardSize and cardSize.thumbnail or constants.CardSizeDefault.thumbnail
	local openMetaActions = v3.openMetaActions
	local notificationPayload = v3.notificationPayload
	local handleActions = v3.handleActions

	local v4 = useNotificationCardState("textBody")
	local v5 = v4 and v4[1]

	local v6 = v5 and v5.title

	if v6 then
		v6 = {
			Text = v5.title,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextSize = textSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 1,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0
		}
		local font

		if not FoundationFontFaceMigration then
			font = v.Font.CaptionHeader.Font
		end

		v6.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v2.Typography.CaptionLarge.Font)
		end

		v6.FontFace = fontFace

		v6.TextColor3 = v.Theme.TextEmphasis.Color
	end

	local v7 = v5 and v5.label

	if v7 then
		v7 = {
			Text = v5.label,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextSize = textSize2,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 2,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0
		}
		local font

		if not FoundationFontFaceMigration then
			font = v.Font.CaptionBody.Font
		end

		v7.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v2.Typography.BodySmall.Font)
		end

		v7.FontFace = fontFace

		v7.TextColor3 = v.Theme.TextEmphasis.Color
	end

	local v8

	if readOnly then
		v8 = -defaultTextContentPadding
	else
		v8 = -(metaActionsWidth + defaultTextContentPadding)
	end

	local v9 = notificationPayload and notificationPayload.timestamp

	if v9 then
		v9 = {
			Text = { text = notificationPayload.timestamp },
			Size = UDim2.new(0, timestampWidth + defaultTextContentPadding, 0, timestampHeight),
			TextSize = textSize,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Right,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, v8, 0, 0),
			LayoutOrder = 2,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0,
			TextTransparency = 0
		}
		local font

		if not FoundationFontFaceMigration then
			font = v.Font.CaptionHeader.Font
		end

		v9.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v2.Typography.CaptionLarge.Font)
		end

		v9.FontFace = fontFace

		v9.TextColor3 = v.Theme.TextEmphasis.Color
	end

	local createElement = react.createElement
	local v10 = {
		Selectable = false,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		Text = "",
		AutoButtonColor = false,
		BorderSizePixel = 0,
		[react.Event.Activated] = function()
			if handleActions and v5 and notificationPayload then
				handleActions(v5, notificationPayload)
			end
		end
	}
	local v11 = {
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
			{
				NotificationThumbnail = react.createElement(NotificationThumbnail)
			}
		),
		ContentFrame = 0
	}

	local createElement2 = react.createElement
	local v12 = {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, -(thumbnail + defaultContentPadding), 0, 0)
	}
	local v13 = {
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
	local v14 = {
		Size = UDim2.new(1, 0, 0, constants.MetaActionsHeight),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1,
		BackgroundTransparency = 1
	}

	local createElement4 = react.createElement
	local v15

	if readOnly then
		v15 = -(timestampWidth + defaultTextContentPadding)
	else
		v15 = -(metaActionsWidth + timestampWidth + defaultTextContentPadding * 2)
	end

	local v16 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, v15, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local v17 = {
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
	local title

	if v6 then
		title = react.createElement(NotificationStyledText, v6)
	end

	v17.Title = title
	local subtitle

	if v7 then
		subtitle = react.createElement(NotificationStyledText, v7)
	end

	v17.Subtitle = subtitle
	local v18 = {
		NotificationsText = createElement4("Frame", v16, v17),
		Timestamp = 0,
		MetaActionsButton = 0
	}
	local timestamp

	if v9 then
		timestamp = react.createElement(NotificationStyledText, v9)
	end

	v18.Timestamp = timestamp
	local metaActionsButton

	if openMetaActions and not readOnly then
		metaActionsButton = react.createElement(iconButton, {
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

	v18.MetaActionsButton = metaActionsButton
	v13.NotificationsBody = createElement3("Frame", v14, v18)
	local notificationActionsFrame

	if not readOnly then
		notificationActionsFrame = react.createElement(NotificationActionsFrame)
	end

	v13.NotificationActionsFrame = notificationActionsFrame
	v11.ContentFrame = createElement2("Frame", v12, v13)
	return createElement("TextButton", v10, v11)
end
