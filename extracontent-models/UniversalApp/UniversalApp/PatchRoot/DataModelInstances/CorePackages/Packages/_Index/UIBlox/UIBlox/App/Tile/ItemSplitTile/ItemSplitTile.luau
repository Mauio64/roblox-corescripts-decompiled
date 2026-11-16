local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local core = parent2.Core
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local t = require(parent3.t)
local Foundation = require(parent3.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local withStyle = require(core.Style.withStyle)
local Interactable = require(core.Control.Interactable)
local ControlState = require(core.Control.Enum.ControlState)
local LoadableImage = require(parent2.App.Loading.LoadableImage)
local Images = require(parent.ImageSet.Images)
local ImageSetComponent = require(core.ImageSet.ImageSetComponent)
local ItemSplitTileFooter = require(parent2.App.Tile.ItemSplitTile.ItemSplitTileFooter)

local udim = UDim.new(0, 8)

local udim2 = UDim.new(0, 8)
local udim3 = UDim.new(0, 12)

local extended = Roact.PureComponent:extend("ItemSplitTile")

extended.validateProps = t.strictInterface({
	itemName = t.optional(t.string),
	priceText = t.optional(t.string),
	isOwned = t.optional(t.boolean),
	hasBackground = t.optional(t.boolean),
	isHovered = t.optional(t.boolean),
	onActivated = t.optional(t.callback),
	thumbnail = t.optional(t.string)
})

extended.defaultProps = {
	itemName = "--",
	priceText = "--",
	hasBackground = true,
	isHovered = false
}

function extended:init()
	self:setState({ controlState = ControlState.Initialize })

	function self.onStateChanged(_, controlState)
		self:setState({ controlState = controlState })
	end
end

function extended:renderImageFrame(image, p, p2, p3)
	local theme = p3.Theme
	local v = p2 or not p
	local v2 = typeof(image) == "table"

	local createElement = Roact.createElement
	local v3 = {
		Position = UDim2.fromScale(0, p and 0.5 or 0),
		Size = UDim2.fromScale(1, p2 and 1 or 0.5),
		ClipsDescendants = true,
		BackgroundTransparency = 1
	}
	local image2

	if v2 then
		local createElement2 = Roact.createElement
		local label = ImageSetComponent.Label
		local v4 = {
			BackgroundColor3 = theme.PlaceHolder.Color,
			BackgroundTransparency = 1,
			Image = image,
			Position = UDim2.fromScale(0, p and -1 or 0),
			Size = UDim2.fromScale(1, p2 and 1 or 2)
		}
		local uiCorner

		if v then
			uiCorner = Roact.createElement("UICorner", { CornerRadius = udim })
		end

		image2 = createElement2(label, v4, { UICorner = uiCorner })
	else
		local createElement2 = Roact.createElement
		local v4 = {
			BackgroundColor3 = theme.PlaceHolder.Color,
			BackgroundTransparency = 1,
			Image = image,
			Position = UDim2.fromScale(0.5, p and 0 or 1),
			Size = UDim2.fromScale(1, p2 and 1 or 2),
			AnchorPoint = Vector2.new(0.5, p2 and 1 or 0.5),
			cornerRadius = 0,
			showFailedStateWhenLoadingFailed = true,
			useShimmerAnimationWhileLoading = true
		}
		local cornerRadius

		if v then
			cornerRadius = udim
		end

		v4.cornerRadius = cornerRadius
		image2 = createElement2(LoadableImage, v4)
	end

	return createElement("Frame", v3, { Image = image2 })
end

function extended:renderTopContent(p)
	local hasBackground = self.props.hasBackground
	local isHovered = self.props.isHovered
	local v = not hasBackground
	local theme = p.Theme
	local image = Images[theme.ItemBackgroundDefault.Image]

	local createElement = Roact.createElement
	local v2 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		SizeConstraint = Enum.SizeConstraint.RelativeXX,
		ZIndex = 2
	}
	local backgroundImage

	if self.props.thumbnail then
		local createElement2 = Roact.createElement
		local v3 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

		local v4 = {
			TopImageFrame = self:renderImageFrame(image, false, v, p),
			BottomImageFrame = 0
		}
		local bottomImageFrame

		if not v then
			bottomImageFrame = self:renderImageFrame(image, true, false, p)
		end

		v4.BottomImageFrame = bottomImageFrame
		backgroundImage = createElement2("Frame", v3, v4)
	end

	local createElement2 = Roact.createElement
	local v3 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

	local v5 = {
		TopImageFrame = self:renderImageFrame(self.props.thumbnail, false, v, p),
		BottomImageFrame = 0
	}
	local bottomImageFrame

	if not v then
		bottomImageFrame = self:renderImageFrame(self.props.thumbnail, true, false, p)
	end

	v5.BottomImageFrame = bottomImageFrame
	local v4 = {
		BackgroundImage = backgroundImage,
		ItemImage = createElement2("Frame", v3, v5),
		HoverShadow = 0
	}
	local hoverShadow

	if isHovered and not hasBackground then
		hoverShadow = Roact.createElement(ImageSetComponent.Label, {
			ZIndex = 0,
			Position = UDim2.new(0.5, 0, 0.5, 2),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 12),
			Image = Images["component_assets/dropshadow_24_6"],
			ImageColor3 = theme.DropShadow.Color,
			ImageTransparency = theme.DropShadow.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(18, 18, 18, 18)
		})
	end

	v4.HoverShadow = hoverShadow
	return createElement("Frame", v2, v4)
end

function extended:renderBottomContent(p)
	local itemName = self.props.itemName
	local hasBackground = self.props.hasBackground

	local font = p.Font
	local textSize = math.ceil(p.Font.BaseSize * p.Font.Header2.RelativeSize)
	local theme = p.Theme
	local controlState = self.state.controlState
	local paddingBottom

	if (self.props.isHovered or controlState == ControlState.Pressed) and hasBackground then
		paddingBottom = udim3
	else
		paddingBottom = udim2
	end

	local v = textSize * 3 + udim2.Offset + paddingBottom.Offset * 2

	local textEmphasis = theme.TextEmphasis

	local createElement = Roact.createElement
	local v2 = { Size = UDim2.new(1, 0, 0, v), BackgroundTransparency = 1, LayoutOrder = 2 }

	local children = {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = udim2
		}),
		Padding = 0,
		TitleArea = 0,
		Footer = 0
	}

	local createElement2 = Roact.createElement
	local paddingLeft

	if hasBackground then
		paddingLeft = paddingBottom
	end

	local paddingRight

	if hasBackground then
		paddingRight = paddingBottom
	end

	local paddingTop = if hasBackground then paddingBottom else udim2

	if not hasBackground then
		paddingBottom = udim2
	end

	children.Padding = createElement2("UIPadding", {
		PaddingLeft = paddingLeft,
		PaddingRight = paddingRight,
		PaddingTop = paddingTop,
		PaddingBottom = paddingBottom
	})
	local titleArea

	if itemName and string.len(itemName) > 0 then
		titleArea = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Text = itemName,
			FontFace = normalizeFontFace(font.Header2.Font),
			TextSize = textSize,
			TextTransparency = textEmphasis.Transparency,
			TextColor3 = textEmphasis.Color,
			TextWrapped = true,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			LayoutOrder = 1
		}, {
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(1e999, textSize * 2)
			})
		})
	end

	children.TitleArea = titleArea

	children.Footer = Roact.createElement(ItemSplitTileFooter, {
		priceText = self.props.priceText,
		isOwned = self.props.isOwned,
		layoutOrder = 2
	})
	return createElement("Frame", v2, children)
end

function extended:renderTileContent(p)
	local hasBackground = self.props.hasBackground
	local onActivated = self.props.onActivated
	local theme = p.Theme
	local color

	if hasBackground then
		color = theme.BackgroundUIDefault.Color
	end

	local backgroundTransparency = not hasBackground and 1 or theme.BackgroundUIDefault.Transparency

	local createElement = Roact.createElement
	local v = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = color,
		BackgroundTransparency = backgroundTransparency,
		ClipsDescendants = true,
		ZIndex = 1
	}

	local v2 = {
		UICorner = Roact.createElement("UICorner", { CornerRadius = udim }),
		Panel = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			TopContentPlaceholder = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				SizeConstraint = Enum.SizeConstraint.RelativeXX,
				BackgroundTransparency = 1,
				LayoutOrder = 1
			}),
			BottomContent = self:renderBottomContent(p)
		}),
		TopContent = self:renderTopContent(p),
		TileOverlay = 0
	}
	local createElement2 = Roact.createElement
	local onActivatedsByActivated = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		onStateChanged = self.onStateChanged,
		[Roact.Event.Activated] = onActivated,
		ZIndex = 3
	}

	local v3 = {
		UICorner = Roact.createElement("UICorner", { CornerRadius = udim }),
		BorderFrame = 0
	}

	local createElement3 = Roact.createElement
	local v4 = {
		Size = UDim2.new(1, -2, 1, -2),
		Position = UDim2.fromOffset(1, 1),
		BackgroundTransparency = 1,
		SizeConstraint = 0
	}
	local sizeConstraint

	if not hasBackground then
		sizeConstraint = Enum.SizeConstraint.RelativeXX
	end

	v4.SizeConstraint = sizeConstraint
	v3.BorderFrame = createElement3("Frame", v4, {
		UIStroke = Roact.createElement("UIStroke", {
			Color = theme.Divider.Color,
			Transparency = theme.Divider.Transparency,
			Thickness = 1
		}),
		UICorner = Roact.createElement("UICorner", { CornerRadius = udim })
	})
	v2.TileOverlay = createElement2(Interactable, onActivatedsByActivated, v3)
	return createElement("Frame", v, v2)
end

function extended:render()
	local hasBackground = self.props.hasBackground
	local isHovered = self.props.isHovered

	return withStyle(function(p)
		local theme = p.Theme

		local createElement = Roact.createElement
		local v = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

		local v2 = {
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MinSize = Vector2.new(146, 233)
			}),
			TileContent = self:renderTileContent(p),
			HoverShadow = 0
		}
		local hoverShadow

		if isHovered and hasBackground then
			hoverShadow = Roact.createElement(ImageSetComponent.Label, {
				ZIndex = 0,
				Position = UDim2.new(0.5, 0, 0.5, 2),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 10, 1, 12),
				Image = Images["component_assets/dropshadow_24_6"],
				ImageColor3 = theme.DropShadow.Color,
				ImageTransparency = theme.DropShadow.Transparency,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(18, 18, 18, 18)
			})
		end

		v2.HoverShadow = hoverShadow
		return createElement("Frame", v, v2)
	end)
end

return extended
