local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Core = ParentParentParent.Core
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local withStyle = require(Core.Style.withStyle)
local Interactable = require(Core.Control.Interactable)
local ControlState = require(Core.Control.Enum.ControlState)
local LoadableImage = require(ParentParentParent.App.Loading.LoadableImage)
local Images = require(ParentParent.ImageSet.Images)
local ImageSetComponent = require(Core.ImageSet.ImageSetComponent)
local ItemSplitTileFooter = require(ParentParentParent.App.Tile.ItemSplitTile.ItemSplitTileFooter)
local uDim = UDim.new(0, 8)
local uDim2 = UDim.new(0, 8)
local uDim3 = UDim.new(0, 12)
local v17 = Roact.PureComponent:extend("ItemSplitTile")

v17.validateProps = t.strictInterface({
	itemName = t.optional(t.string),
	priceText = t.optional(t.string),
	isOwned = t.optional(t.boolean),
	hasBackground = t.optional(t.boolean),
	isHovered = t.optional(t.boolean),
	onActivated = t.optional(t.callback),
	thumbnail = t.optional(t.string)
})
v17.defaultProps = {
	itemName = "--",
	priceText = "--",
	hasBackground = true,
	isHovered = false
}

function v17.init(p1) -- line: 68
	-- upvalues: ControlState (copy)
	p1:setState({
		controlState = ControlState.Initialize
	})

	function p1.onStateChanged(_, p3) -- line: 73
		-- upvalues: p1 (copy)
		p1:setState({
			controlState = p3
		})
	end
end
function v17.renderImageFrame(_, p5, p6, p7, p8) -- line: 80
	-- upvalues: Roact (copy), ImageSetComponent (copy), uDim (copy), LoadableImage (copy)
	local Theme = p8.Theme
	local v25 = p7 or not p6
	local v26 = typeof(p5) == "table"

	return Roact.createElement("Frame", {
		ClipsDescendants = true,
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0, not p6 and 0 or 0.5),
		Size = UDim2.fromScale(1, not p7 and 0.5 or 1)
	}, {
		Image = if not v26 then Roact.createElement(LoadableImage, {
			BackgroundTransparency = 1,
			showFailedStateWhenLoadingFailed = true,
			useShimmerAnimationWhileLoading = true,
			BackgroundColor3 = Theme.PlaceHolder.Color,
			Image = p5,
			Position = UDim2.fromScale(0.5, not p6 and 1 or 0),
			Size = UDim2.fromScale(1, not p7 and 2 or 1),
			AnchorPoint = Vector2.new(0.5, not p7 and 0.5 or 1),
			cornerRadius = if not v25 then nil else uDim
		}) else Roact.createElement(ImageSetComponent.Label, {
			BackgroundTransparency = 1,
			BackgroundColor3 = Theme.PlaceHolder.Color,
			Image = p5,
			Position = UDim2.fromScale(0, not p6 and 0 or -1),
			Size = UDim2.fromScale(1, not p7 and 2 or 1)
		}, {
			UICorner = if not v25 then nil else Roact.createElement("UICorner", {
				CornerRadius = uDim
			})
		})
	})
end
function v17.renderTopContent(p9, p10) -- line: 119
	-- upvalues: Images (copy), Roact (copy), ImageSetComponent (copy)
	local hasBackground = p9.props.hasBackground
	local isHovered = p9.props.isHovered
	local v31 = not hasBackground
	local Theme = p10.Theme
	local v33 = Images[Theme.ItemBackgroundDefault.Image]

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 2,
		Size = UDim2.new(1, 0, 1, 0),
		SizeConstraint = Enum.SizeConstraint.RelativeXX
	}, {
		BackgroundImage = if not p9.props.thumbnail then nil else Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			TopImageFrame = p9:renderImageFrame(v33, false, v31, p10),
			BottomImageFrame = if v31 then nil else p9:renderImageFrame(v33, true, false, p10)
		}),
		ItemImage = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			TopImageFrame = p9:renderImageFrame(p9.props.thumbnail, false, v31, p10),
			BottomImageFrame = if v31 then nil else p9:renderImageFrame(p9.props.thumbnail, true, false, p10)
		}),
		HoverShadow = if not isHovered or hasBackground then nil else Roact.createElement(ImageSetComponent.Label, {
			ZIndex = 0,
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.5, 2),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, 0, 1, 12),
			Image = Images["component_assets/dropshadow_24_6"],
			ImageColor3 = Theme.DropShadow.Color,
			ImageTransparency = Theme.DropShadow.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(18, 18, 18, 18)
		})
	})
end
function v17.renderBottomContent(p11, p12) -- line: 169
	-- upvalues: ControlState (copy), uDim3 (copy), uDim2 (copy), Roact (copy), ItemSplitTileFooter (copy)
	local itemName = p11.props.itemName
	local hasBackground = p11.props.hasBackground
	local p12Font = p12.Font
	local v39 = math.ceil(p12.Font.BaseSize * p12.Font.Header2.RelativeSize)
	local Theme = p12.Theme
	local controlState = p11.state.controlState
	local v42 = if not p11.props.isHovered and controlState ~= ControlState.Pressed or not hasBackground then uDim2 else uDim3
	local v43 = v39 * 3 + uDim2.Offset + v42.Offset * 2
	local TextEmphasis = Theme.TextEmphasis

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, v43)
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = uDim2
		}),
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = if not hasBackground then nil else v42,
			PaddingRight = if not hasBackground then nil else v42,
			PaddingTop = if not hasBackground then uDim2 else v42,
			PaddingBottom = if not hasBackground then uDim2 else v42
		}),
		TitleArea = if not itemName or not (string.len(itemName) > 0) then nil else Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = true,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = itemName,
			Font = p12Font.Header2.Font,
			TextSize = v39,
			TextTransparency = TextEmphasis.Transparency,
			TextColor3 = TextEmphasis.Color,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		}, {
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(1e999, v39 * 2)
			})
		}),
		Footer = Roact.createElement(ItemSplitTileFooter, {
			layoutOrder = 2,
			priceText = p11.props.priceText,
			isOwned = p11.props.isOwned
		})
	})
end
function v17.renderTileContent(p13, p14) -- line: 237
	-- upvalues: Roact (copy), uDim (copy), Interactable (copy)
	local hasBackground = p13.props.hasBackground
	local onActivated = p13.props.onActivated
	local Theme = p14.Theme
	local v50 = if not hasBackground then nil else Theme.BackgroundUIDefault.Color
	local v51 = not hasBackground and 1 or Theme.BackgroundUIDefault.Transparency

	return Roact.createElement("Frame", {
		ClipsDescendants = true,
		ZIndex = 1,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = v50,
		BackgroundTransparency = v51
	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = uDim
		}),
		Panel = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			TopContentPlaceholder = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 1, 0),
				SizeConstraint = Enum.SizeConstraint.RelativeXX
			}),
			BottomContent = p13:renderBottomContent(p14)
		}),
		TopContent = p13:renderTopContent(p14),
		TileOverlay = Roact.createElement(Interactable, {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			onStateChanged = p13.onStateChanged,
			[Roact.Event.Activated] = onActivated,
			ZIndex = 3
		}, {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = uDim
			}),
			BorderFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.fromOffset(1, 1),
				SizeConstraint = if hasBackground then nil else Enum.SizeConstraint.RelativeXX
			}, {
				UIStroke = Roact.createElement("UIStroke", {
					Thickness = 1,
					Color = Theme.Divider.Color,
					Transparency = Theme.Divider.Transparency
				}),
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = uDim
				})
			})
		})
	})
end
function v17.render(p15) -- line: 300
	-- upvalues: withStyle (copy), Roact (copy), ImageSetComponent (copy), Images (copy)
	local hasBackground = p15.props.hasBackground
	local isHovered = p15.props.isHovered

	return withStyle(function(p16) -- line: 304
		-- upvalues: Roact (copy), p15 (copy), isHovered (copy), hasBackground (copy), ImageSetComponent (copy), Images (copy)
		local Theme = p16.Theme

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MinSize = Vector2.new(146, 233)
			}),
			TileContent = p15:renderTileContent(p16),
			HoverShadow = if not isHovered or not hasBackground then nil else Roact.createElement(ImageSetComponent.Label, {
				ZIndex = 0,
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0.5, 2),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(1, 10, 1, 12),
				Image = Images["component_assets/dropshadow_24_6"],
				ImageColor3 = Theme.DropShadow.Color,
				ImageTransparency = Theme.DropShadow.Transparency,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(18, 18, 18, 18)
			})
		})
	end)
end

return v17
