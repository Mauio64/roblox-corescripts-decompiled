local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Core = ParentParentParentParent.Core
local ParentParentParentParentParent = ParentParentParentParent.Parent
local Cryo = require(ParentParentParentParentParent.Cryo)
local React = require(ParentParentParentParentParent.React)
local useDebouncedState = require(ParentParentParentParentParent.ReactUtils).useDebouncedState
local useStyle = require(Core.Style.useStyle)
local ImageSetComponent = require(Core.ImageSet.ImageSetComponent)
local Images = require(ParentParentParent.ImageSet.Images)
local TileOverlay = require(ParentParent.SplitTile.TileOverlay)

require(ParentParentParent.Style.StyleTypes)

local uDim = UDim.new(0, 8)

local function useIsHoveredState(n1: number?, p1: ((...any) -> ...any)?) -- line: 65
	-- upvalues: useDebouncedState (copy), React (copy)
	local v18, v19 = useDebouncedState(false, n1)

	React.useLayoutEffect(function() -- line: 68
		-- upvalues: p1 (copy), v18 (copy)
		if p1 ~= nil then
			p1(v18)
		end
	end, {
		p1,
		v18
	})

	return v18, v19
end
local function VerticalTile(t1: {[any]: any}) -- line: 77
	-- upvalues: useStyle (copy), Cryo (copy), uDim (copy), useIsHoveredState (copy), React (copy), TileOverlay (copy), ImageSetComponent (copy), Images (copy)
	local Theme = useStyle().Theme
	local v22 = Cryo.Dictionary.join({
		hasBackground = true,
		hasOutline = true,
		isHoverEnabled = true,
		isOverlayVisible = true,
		isActive = true,
		backgroundColor = {
			Color = Theme.BackgroundUIDefault.Color,
			Transparency = Theme.BackgroundUIDefault.Transparency
		},
		border = {
			Width = 1,
			BorderColor = {
				Color = Theme.Divider.Color,
				Transparency = Theme.Divider.Transparency
			},
			CornerRadius = uDim
		},
		dropShadow = {
			ImageAssetName = "component_assets/dropshadow_24_6",
			Position = UDim2.new(0.5, 0, 0.5, 2),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, 10, 1, 12),
			ImageColor = {
				Color = Theme.DropShadow.Color,
				Transparency = Theme.DropShadow.Transparency
			},
			SliceCenter = Rect.new(18, 18, 18, 18)
		}
	}, t1)
	local hasBackground = v22.hasBackground
	local isHoverEnabled = v22.isHoverEnabled
	local v25, v26 = useIsHoveredState(v22.hoverDelay, v22.onHoverChanged)
	local v27 = React.useCallback(function(b1: boolean) -- line: 113
		-- upvalues: v26 (copy)
		return function() -- line: 114
			-- upvalues: v26 (copy), b1 (copy)
			v26(b1)
		end
	end, {})
	local v28 = v25 and isHoverEnabled
	local v29 = if not hasBackground then nil else v22.backgroundColor.Color
	local v30 = not hasBackground and 1 or v22.backgroundColor.Transparency

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		UISizeConstraint = if not v22.minTileSize then nil else React.createElement("UISizeConstraint", {
			MinSize = v22.minTileSize
		}),
		TileContent = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = v29,
			BackgroundTransparency = v30,
			[React.Event.MouseEnter] = if not isHoverEnabled then nil else v27(true),
			[React.Event.MouseLeave] = if not isHoverEnabled then nil else v27(false),
			ClipsDescendants = false,
			ZIndex = 1
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = v22.border.CornerRadius
			}),
			Panel = React.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.Name
				}),
				Content1 = if not v22.renderTopContent then nil else v22.renderTopContent(v28),
				Content2 = if not v22.renderBottomContent then nil else v22.renderBottomContent(v28)
			}),
			FooterRow = if not v22.renderFooterRow then nil else v22.renderFooterRow(v28),
			Overlay = React.createElement(TileOverlay, {
				zIndex = 3,
				reservedBottomHeight = v22.reservedBottomHeight,
				isVisible = v22.isOverlayVisible,
				isActive = v22.isActive,
				onActivated = v22.onActivated
			})
		}),
		BorderFrame = if not v22.hasOutline then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 4,
			Size = UDim2.new(1, -2 * v22.border.Width, 1, -2 * v22.border.Width),
			AnchorPoint = if not hasBackground then nil else Vector2.new(0.5, 0.5),
			Position = if not hasBackground then UDim2.fromOffset(v22.border.Width, v22.border.Width) else UDim2.fromScale(0.5, 0.5),
			SizeConstraint = if hasBackground then nil else Enum.SizeConstraint.RelativeXX
		}, {
			UIStroke = React.createElement("UIStroke", {
				Color = v22.border.BorderColor.Color,
				Transparency = v22.border.BorderColor.Transparency,
				Thickness = v22.border.Width
			}),
			UICorner = React.createElement("UICorner", {
				CornerRadius = v22.border.CornerRadius
			})
		}),
		HoverShadow = if not v28 or not hasBackground then nil else React.createElement(ImageSetComponent.Label, {
			ZIndex = 0,
			BackgroundTransparency = 1,
			Position = v22.dropShadow.Position,
			AnchorPoint = v22.dropShadow.AnchorPoint,
			Size = v22.dropShadow.Size,
			Image = Images[v22.dropShadow.ImageAssetName],
			ImageColor3 = v22.dropShadow.ImageColor.Color,
			ImageTransparency = v22.dropShadow.ImageColor.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = v22.dropShadow.SliceCenter
		})
	})
end

return VerticalTile
