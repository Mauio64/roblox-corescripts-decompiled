local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local core = parent3.Core
local parent4 = parent3.Parent

local Cryo = require(parent4.Cryo)
local React = require(parent4.React)

local ReactUtils = require(parent4.ReactUtils)
local useDebouncedState = ReactUtils.useDebouncedState

local useStyle = require(core.Style.useStyle)
local ImageSetComponent = require(core.ImageSet.ImageSetComponent)
local Images = require(parent2.ImageSet.Images)
local TileOverlay = require(parent.SplitTile.TileOverlay)
require(parent2.Style.StyleTypes)

local udim = UDim.new(0, 8)

local function useIsHoveredState(hoverDelay: number?, onHoverChanged)
	local v, v2 = useDebouncedState(false, hoverDelay)

	React.useLayoutEffect(function()
		if onHoverChanged ~= nil then
			onHoverChanged(v)
		end
	end, { onHoverChanged, v })

	return v, v2
end

local function VerticalTile(p)
	local theme = useStyle().Theme
	local joined = Cryo.Dictionary.join({
		hasBackground = true,
		hasOutline = true,
		isHoverEnabled = true,
		isOverlayVisible = true,
		isActive = true,
		backgroundColor = {
			Color = theme.BackgroundUIDefault.Color,
			Transparency = theme.BackgroundUIDefault.Transparency
		},
		border = {
			BorderColor = { Color = theme.Divider.Color, Transparency = theme.Divider.Transparency },
			CornerRadius = udim,
			Width = 1
		},
		dropShadow = {
			Position = UDim2.new(0.5, 0, 0.5, 2),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, 10, 1, 12),
			ImageColor = {
				Color = theme.DropShadow.Color,
				Transparency = theme.DropShadow.Transparency
			},
			ImageAssetName = "component_assets/dropshadow_24_6",
			SliceCenter = Rect.new(18, 18, 18, 18)
		}
	}, p)

	local hasBackground = joined.hasBackground
	local isHoverEnabled = joined.isHoverEnabled
	local v, v2 = useIsHoveredState(joined.hoverDelay, joined.onHoverChanged)
	local v3 = React.useCallback(function(flag: boolean)
		return function()
			v2(flag)
		end
	end, {})
	local v4 = v and isHoverEnabled
	local color

	if hasBackground then
		color = joined.backgroundColor.Color
	end

	local backgroundTransparency = not hasBackground and 1 or joined.backgroundColor.Transparency
	local createElement = React.createElement
	local v5 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }
	local uiSizeConstraint

	if joined.minTileSize then
		uiSizeConstraint = React.createElement("UISizeConstraint", { MinSize = joined.minTileSize })
	end

	local createElement2 = React.createElement
	local v6 = {}
	v6.Size = UDim2.new(1, 0, 1, 0)
	v6.BackgroundColor3 = color
	v6.BackgroundTransparency = backgroundTransparency
	local mouseEnter = React.Event.MouseEnter
	local v7

	if isHoverEnabled then
		v7 = v3(true)
	end

	v6[mouseEnter] = v7
	local mouseLeave = React.Event.MouseLeave
	local v9

	if isHoverEnabled then
		v9 = v3(false)
	end

	v6[mouseLeave] = v9
	v6.ClipsDescendants = false
	v6.ZIndex = 1
	local children = {
		UICorner = React.createElement("UICorner", { CornerRadius = joined.border.CornerRadius }),
		Panel = 0,
		FooterRow = 0,
		Overlay = 0
	}

	local createElement3 = React.createElement
	local v10 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 2 }

	local v11 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.Name
		}),
		Content1 = 0,
		Content2 = 0
	}
	local content

	if joined.renderTopContent then
		content = joined.renderTopContent(v4)
	end

	v11.Content1 = content
	local content2

	if joined.renderBottomContent then
		content2 = joined.renderBottomContent(v4)
	end

	v11.Content2 = content2
	children.Panel = createElement3("Frame", v10, v11)
	local footerRow

	if joined.renderFooterRow then
		footerRow = joined.renderFooterRow(v4)
	end

	children.FooterRow = footerRow
	children.Overlay = React.createElement(TileOverlay, {
		reservedBottomHeight = joined.reservedBottomHeight,
		isVisible = joined.isOverlayVisible,
		isActive = joined.isActive,
		onActivated = joined.onActivated,
		zIndex = 3
	})
	local v8 = {
		UISizeConstraint = uiSizeConstraint,
		TileContent = createElement2("Frame", v6, children),
		BorderFrame = 0,
		HoverShadow = 0
	}
	local borderFrame

	if joined.hasOutline then
		local createElement4 = React.createElement
		local v12 = {
			Size = UDim2.new(1, -2 * joined.border.Width, 1, -2 * joined.border.Width),
			AnchorPoint = 0,
			Position = 0,
			BackgroundTransparency = 1,
			SizeConstraint = 0,
			ZIndex = 4
		}
		local anchorPoint

		if hasBackground then
			anchorPoint = Vector2.new(0.5, 0.5)
		end

		v12.AnchorPoint = anchorPoint
		local position

		if hasBackground then
			position = UDim2.fromScale(0.5, 0.5)
		else
			position = UDim2.fromOffset(joined.border.Width, joined.border.Width)
		end

		v12.Position = position
		local sizeConstraint

		if not hasBackground then
			sizeConstraint = Enum.SizeConstraint.RelativeXX
		end

		v12.SizeConstraint = sizeConstraint
		borderFrame = createElement4("Frame", v12, {
			UIStroke = React.createElement("UIStroke", {
				Color = joined.border.BorderColor.Color,
				Transparency = joined.border.BorderColor.Transparency,
				Thickness = joined.border.Width
			}),
			UICorner = React.createElement("UICorner", { CornerRadius = joined.border.CornerRadius })
		})
	end

	v8.BorderFrame = borderFrame
	local hoverShadow

	if v4 and hasBackground then
		hoverShadow = React.createElement(ImageSetComponent.Label, {
			ZIndex = 0,
			Position = joined.dropShadow.Position,
			AnchorPoint = joined.dropShadow.AnchorPoint,
			BackgroundTransparency = 1,
			Size = joined.dropShadow.Size,
			Image = Images[joined.dropShadow.ImageAssetName],
			ImageColor3 = joined.dropShadow.ImageColor.Color,
			ImageTransparency = joined.dropShadow.ImageColor.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = joined.dropShadow.SliceCenter
		})
	end

	v8.HoverShadow = hoverShadow
	return createElement("Frame", v5, v8)
end

return VerticalTile
