local parent = script:FindFirstAncestor("ItemDetails").Parent

local React = require(parent.React)
local RoactGamepad = require(parent.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local VerifiedBadges = require(parent.VerifiedBadges)

local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local Skeleton = Foundation.Skeleton
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local useStyle = UIBlox.Core.Style.useStyle
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local iconsnavigationpushRight_small = Images["icons/navigation/pushRight_small"]
	or "LuaApp/icons/GameDetails/navigation/pushRight_small"

local vector2 = Vector2.new(14, 14)

local udim = UDim2.new(0.3, 0, 0.8, 0)

return (React.forwardRef(function(props, ref)
	local layoutOrder = props.LayoutOrder
	local infoName = props.infoName
	local infoData = props.infoData
	local onActivate = props.onActivate
	local hasVerifiedBadge = props.hasVerifiedBadge
	local isLoading = props.isLoading

	local v = useStyle()
	local theme = v.Theme
	local font = v.Font

	local v2 = useSelectionCursor(CursorKind.RoundedRect)

	local color = theme.TextEmphasis.Color
	local v3 = font.BaseSize * font.Body.RelativeSize
	local v4 = -11 - vector2.X
	local v5 = ref ~= nil
	local v6 = not v5 and "ImageButton" or Focusable.ImageButton
	local infoDataTextLabel = not (isLoading or hasVerifiedBadge)
	local infoDataWithEmoji = not isLoading and hasVerifiedBadge

	local createElement = React.createElement
	local onActivatesByActivated = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		Size = UDim2.new(1, 0, 0, props.hideDivider and 52 or 53),
		[React.Event.Activated] = onActivate,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown,
		NextSelectionLeft = props.NextSelectionLeft,
		NextSelectionRight = props.NextSelectionRight,
		ref = ref,
		SelectionImageObject = v5 and v2 or nil,
		Selectable = props.Selectable
	}

	local createElement2 = React.createElement
	local v7 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, props.hideDivider and 0 or -1)
	}
	local v8 = {
		InfoNameTextLabel = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			FontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font),
			Size = UDim2.new(0.5, 0, 1, 0),
			Text = infoName,
			TextColor3 = theme.TextDefault.Color,
			TextSize = v3,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		}),
		InfoDataWithEmoji = 0,
		InfoDataTextLabel = 0,
		LoadingShimmer = 0,
		LinkIcon = 0
	}

	if infoDataWithEmoji then
		local createElement3 = React.createElement
		local emojiWrapper = VerifiedBadges.EmojiWrapper
		local v9 = {
			emoji = VerifiedBadges.emoji.verified,
			font = 0,
			anchorPoint = 0,
			position = 0,
			size = 0,
			automaticSize = 0,
			horizontalAlignment = 0,
			verticalAlignment = 0
		}
		local font2

		if onActivate then
			font2 = font.Header2.Font
		else
			font2 = font.Body.Font
		end

		v9.font = font2
		v9.anchorPoint = Vector2.new(1, 0)
		v9.position = UDim2.new(1, not onActivate and 0 or v4, 0, 0)
		v9.size = UDim2.new(0.5, 0, 1, 0)
		v9.automaticSize = Enum.AutomaticSize.None
		v9.horizontalAlignment = Enum.HorizontalAlignment.Right
		v9.verticalAlignment = Enum.VerticalAlignment.Center

		local createElement4 = React.createElement
		local v10

		if onActivate then
			v10 = v.Tokens.Typography.TitleLarge.Font
		else
			v10 = v.Tokens.Typography.BodyLarge.Font
		end

		local v11 = {
			BackgroundTransparency = 1,
			FontFace = normalizeFontFace(v10),
			Size = UDim2.new(0, 0, 1, 0),
			Text = infoData,
			TextColor3 = 0,
			TextSize = 0,
			TextTruncate = 0,
			TextScaled = 0,
			AutomaticSize = 0,
			TextXAlignment = 0
		}
		local textColor

		if onActivate then
			textColor = theme.TextEmphasis.Color
		else
			textColor = theme.TextDefault.Color
		end

		v11.TextColor3 = textColor
		v11.TextSize = v3
		v11.TextTruncate = Enum.TextTruncate.AtEnd
		v11.TextScaled = props.TextScaled
		v11.AutomaticSize = Enum.AutomaticSize.X
		v11.TextXAlignment = Enum.TextXAlignment.Left
		infoDataWithEmoji = createElement3(emojiWrapper, v9, {
			InfoDataTextLabel = createElement4("TextLabel", v11)
		})
	end

	v8.InfoDataWithEmoji = infoDataWithEmoji

	if infoDataTextLabel then
		local createElement3 = React.createElement
		local v9 = {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, not onActivate and 0 or v4, 0, 0),
			BackgroundTransparency = 1,
			FontFace = 0,
			Size = 0,
			Text = 0,
			TextColor3 = 0,
			TextSize = 0,
			TextTruncate = 0,
			TextScaled = 0,
			TextXAlignment = 0,
			TextYAlignment = 0
		}
		local v10

		if onActivate then
			v10 = v.Tokens.Typography.TitleLarge.Font
		else
			v10 = v.Tokens.Typography.BodyLarge.Font
		end

		v9.FontFace = normalizeFontFace(v10)

		v9.Size = UDim2.new(0.5, 0, 1, 0)
		v9.Text = infoData
		local textColor

		if onActivate then
			textColor = theme.TextEmphasis.Color
		else
			textColor = theme.TextDefault.Color
		end

		v9.TextColor3 = textColor
		v9.TextSize = v3
		v9.TextTruncate = Enum.TextTruncate.AtEnd
		v9.TextScaled = props.TextScaled
		v9.TextXAlignment = Enum.TextXAlignment.Right
		v9.TextYAlignment = Enum.TextYAlignment.Center
		infoDataTextLabel = createElement3("TextLabel", v9, {
			TextSizeConstraint = props.TextScaled and React.createElement("UITextSizeConstraint", {
				MaxTextSize = v3
			})
		})
	end

	v8.InfoDataTextLabel = infoDataTextLabel

	v8.LoadingShimmer = isLoading
		and React.createElement(Skeleton, {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = udim
		})

	v8.LinkIcon = onActivate and React.createElement(ImageSetLabel, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(vector2.X, vector2.Y),
		Image = iconsnavigationpushRight_small,
		ImageColor3 = color,
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	})
	return createElement(v6, onActivatesByActivated, {
		Container = createElement2("Frame", v7, v8),
		Divider = not props.hideDivider and React.createElement("Frame", {
			BackgroundColor3 = theme.Divider.Color,
			BackgroundTransparency = theme.Divider.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, -1)
		})
	})
end))
