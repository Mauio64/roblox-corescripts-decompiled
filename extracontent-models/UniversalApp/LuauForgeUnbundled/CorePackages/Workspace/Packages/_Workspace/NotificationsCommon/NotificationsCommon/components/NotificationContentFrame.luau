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
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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
	local v6 = if foundationFontFaceMigration then useTokens() else nil
	local v7

	if foundationFontFaceMigration then
		v7 = v6.Typography.CaptionLarge.FontSize
	else
		v7 = v5.Font.BaseSize * v5.Font.CaptionHeader.RelativeSize
	end

	local v8

	if foundationFontFaceMigration then
		v8 = v6.Typography.BodySmall.FontSize
	else
		v8 = v5.Font.BaseSize * v5.Font.CaptionBody.RelativeSize
	end

	local v9 = useNotificationCardData()
	local cardSize = v9.cardSize
	local readOnly = v9.readOnly
	local thumbnail = cardSize and cardSize.thumbnail or constants.CardSizeDefault.thumbnail
	local openMetaActions = v9.openMetaActions
	local notificationPayload = v9.notificationPayload
	local handleActions = v9.handleActions

	local v10 = useNotificationCardState("textBody")
	local v11 = v10 and v10[1]

	local v12 = v11 and v11.title

	if v12 then
		v12 = {
			Text = v11.title,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextSize = v7,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 1,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0
		}

		local v13 = if not foundationFontFaceMigration then v5.Font.CaptionHeader.Font else nil
		v12.Font = v13

		local v14 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.CaptionLarge.Font) else nil
		v12.FontFace = v14

		v12.TextColor3 = v5.Theme.TextEmphasis.Color
	end

	local v13 = v11 and v11.label

	if v13 then
		v13 = {
			Text = v11.label,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextSize = v8,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 2,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0
		}

		local v14 = if not foundationFontFaceMigration then v5.Font.CaptionBody.Font else nil
		v13.Font = v14

		local v15 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.BodySmall.Font) else nil
		v13.FontFace = v15

		v13.TextColor3 = v5.Theme.TextEmphasis.Color
	end

	local v14

	if readOnly then
		v14 = -defaultTextContentPadding
	else
		v14 = -(metaActionsWidth + defaultTextContentPadding)
	end

	local v15 = notificationPayload and notificationPayload.timestamp

	if v15 then
		v15 = {
			Text = { text = notificationPayload.timestamp },
			Size = UDim2.new(0, timestampWidth + defaultTextContentPadding, 0, timestampHeight),
			TextSize = v7,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Right,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, v14, 0, 0),
			LayoutOrder = 2,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0,
			TextTransparency = 0
		}

		local v16 = if not foundationFontFaceMigration then v5.Font.CaptionHeader.Font else nil
		v15.Font = v16

		local v17 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.CaptionLarge.Font) else nil
		v15.FontFace = v17

		v15.TextColor3 = v5.Theme.TextEmphasis.Color
	end

	local createElement = react.createElement
	local v17 = {
		Selectable = false,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		Text = "",
		AutoButtonColor = false,
		BorderSizePixel = 0,
		[react.Event.Activated] = function()
			if handleActions and v11 and notificationPayload then
				handleActions(v11, notificationPayload)
			end
		end
	}
	local v18 = {
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
	local v20 = {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, -(thumbnail + defaultContentPadding), 0, 0)
	}
	local v21 = {
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
	local v23 = {
		Size = UDim2.new(1, 0, 0, constants.MetaActionsHeight),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1,
		BackgroundTransparency = 1
	}

	local createElement4 = react.createElement

	local newUDim2 = UDim2.new
	local v28

	if readOnly then
		v28 = -(timestampWidth + defaultTextContentPadding)
	else
		v28 = -(metaActionsWidth + timestampWidth + defaultTextContentPadding * 2)
	end

	local v26 = {
		BackgroundTransparency = 1,
		Size = newUDim2(1, v28, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local v29 = {
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

	local v30 = if v12 then react.createElement(NotificationStyledText, v12) else nil
	v29.Title = v30

	local v31 = if v13 then react.createElement(NotificationStyledText, v13) else nil
	v29.Subtitle = v31
	local v24 = {
		NotificationsText = createElement4("Frame", v26, v29),
		Timestamp = 0,
		MetaActionsButton = 0
	}

	local v32 = if v15 then react.createElement(NotificationStyledText, v15) else nil
	v24.Timestamp = v32
	local v33

	if openMetaActions and not readOnly then
		v33 = react.createElement(iconButton, {
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

	v24.MetaActionsButton = v33
	v21.NotificationsBody = createElement3("Frame", v23, v24)

	local v34 = if not readOnly then react.createElement(module8) else nil
	v21.NotificationActionsFrame = v34
	v18.ContentFrame = createElement2("Frame", v20, v21)
	return createElement("TextButton", v17, v18)
end
