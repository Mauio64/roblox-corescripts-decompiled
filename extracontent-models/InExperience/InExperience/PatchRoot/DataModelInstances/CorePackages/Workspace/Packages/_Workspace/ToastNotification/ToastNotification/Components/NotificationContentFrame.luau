local parent = script.Parent
local parent2 = parent.Parent
local context = parent2.context
local dependencies = require(parent2.dependencies)
local NotificationStyledText = require(parent.NotificationStyledText)
local NotificationThumbnail = require(parent.NotificationThumbnail)
local ToastHoldButton = require(parent.ToastHoldButton)
local kind = require(parent2.type)
local uiBlox = dependencies.UIBlox
local useStyle = uiBlox.Core.Style.useStyle
local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel
local interactable = uiBlox.Core.Control.Interactable
local constants = require(parent2.constants)
local useNotificationCardState = require(context.useNotificationCardState)
local useNotificationCardData = require(context.useNotificationCardData)

local parent3 = parent2.Parent
local React = require(parent3.React)
local Foundation = require(parent3.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local defaultContentPadding = constants.DefaultContentPadding
local defaultTextContentPadding = constants.DefaultTextContentPadding
local vector2 = Vector2.new(36, 36)

local utils = parent2.utils
local toastNotificationHelper = require(utils.toastNotificationHelper)
local isUserThumbnail = toastNotificationHelper.isUserThumbnail

return function(props)
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

	local cardSize = useNotificationCardData().cardSize
	local v3

	if isUserThumbnail then
		local v4 = useNotificationCardState("thumbnail")

		v3 = React.useMemo(function()
			local flag = false

			if v4 then
				for _, v5 in v4 do
					if not isUserThumbnail(v5) then
						flag = true
						break
					end
				end
			end

			if flag then
				return cardSize and cardSize.thumbnail or constants.CardSizeDefault.thumbnail
			end

			return v.Tokens.Size.Size_1000
		end, { v4, v.Tokens.Size.Size_1000, cardSize })
	else
		v3 = cardSize and cardSize.thumbnail or constants.CardSizeDefault.thumbnail
	end

	local size_700 = v.Tokens.Size.Size_700
	local v4 = useNotificationCardState("textBody")

	local v5 = v4 and v4[1]

	local v6 = v5 and v5.title

	if v6 then
		v6 = {
			Text = v5.title,
			MaxSize = Vector2.new(1e999, textSize * 2),
			Size = UDim2.new(1, 0, 0, 0),
			TextSize = textSize,
			AutomaticSize = Enum.AutomaticSize.Y,
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
			MaxSize = Vector2.new(1e999, textSize2 * 2),
			Size = UDim2.new(1, 0, 0, 0),
			TextSize = textSize2,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 2,
			Font = 0,
			FontFace = 0
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
	end

	local v8 = useNotificationCardData()
	cardSize = v8.cardSize
	local handleActions = v8.handleActions
	local v9 = useNotificationCardState("singleMetaAction")
	local v10 = v9 and v9[1]

	local createElement = React.createElement
	local v11 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local v12 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, defaultContentPadding)
		}),
		ThumbnailTextContainer = 0,
		SingleMetaAction = 0
	}

	local createElement2 = React.createElement
	local v13 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Size = 0
	}
	local size

	if v10 then
		size = UDim2.new(1, -(defaultContentPadding + vector2.X), 0, 0)
	else
		size = UDim2.new(1, 0, 0, 0)
	end

	v13.Size = size

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, defaultContentPadding)
		}),
		NotificationThumbnailFrame = React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(0, v3, 0, v3)
			},
			{
				NotificationThumbnail = React.createElement(NotificationThumbnail)
			}
		),
		ToastTextFrame = 0,
		ToastHoldButton = 0
	}

	local createElement3 = React.createElement
	local v14 = {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = 0
	}
	local size2

	if props.showHoldButton then
		size2 = UDim2.new(1, -(v3 + defaultContentPadding * 2 + size_700), 0, 0)
	else
		size2 = UDim2.new(1, -(v3 + defaultContentPadding), 0, 0)
	end

	v14.Size = size2
	children.ToastTextFrame = createElement3("Frame", v14, {
		UIPadding = React.createElement("UIPadding", { PaddingTop = UDim.new(0, 2) }),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, defaultTextContentPadding)
		}),
		ToastTitle = v6 and React.createElement(NotificationStyledText, v6),
		ToastSubtitle = v7 and React.createElement(NotificationStyledText, v7)
	})

	children.ToastHoldButton = React.createElement(ToastHoldButton, {
		iconSize = size_700,
		visible = props.showHoldButton,
		layoutOrder = 3,
		iconTransparency = props.shouldAutoFocus and 0.5 or 0,
		progress = props.holdProgress
	})
	v12.ThumbnailTextContainer = createElement2("Frame", v13, children)
	local singleMetaAction

	if v10 then
		singleMetaAction = React.createElement(interactable, {
			AutoButtonColor = false,
			BackgroundColor3 = v.Theme.UIMuted.Color,
			BackgroundTransparency = 0.9,
			LayoutOrder = 2,
			onStateChanged = function() end,
			[React.Event.Activated] = function()
				if handleActions then
					handleActions(v10)
				end
			end,
			Size = UDim2.fromOffset(vector2.X, vector2.Y)
		}, {
			UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
			Icon = React.createElement(imageSetLabel, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = kind.MetaActionIcons[v10.actionIcon],
				ImageColor3 = v.Theme.IconEmphasis.Color,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(28, 28)
			})
		})
	end

	v12.SingleMetaAction = singleMetaAction
	return createElement("Frame", v11, v12)
end
