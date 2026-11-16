local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Skeleton = Foundation.Skeleton
local useTokens = Foundation.Hooks.useTokens
local ViewType = require(AvatarExperienceInspectAndBuy.Enums.ViewType)
require(AvatarExperienceInspectAndBuy.Types)
local ItemCardRowContainer = require(AvatarExperienceInspectAndBuy.Components.ItemsView.ItemCardRowContainer)

local function fn(view, p)
	if view == ViewType.WideLandscape then
		return {
			left = UDim.new(0, p.Padding.XLarge),
			right = UDim.new(0, p.Padding.XLarge),
			bottom = UDim.new(0, p.Padding.Large)
		}
	end

	if view == ViewType.Compact then
		return {
			left = UDim.new(0, p.Padding.Large),
			right = UDim.new(0, p.Padding.Large),
			bottom = UDim.new(0, p.Padding.Large)
		}
	end

	return {
		top = UDim.new(0, p.Padding.Medium),
		left = UDim.new(0, p.Margin.Large * 2),
		right = UDim.new(0, p.Margin.Large * 2),
		bottom = UDim.new(0, p.Padding.Large)
	}
end

return (React.forwardRef(function(props, ref)
	local v = useTokens()
	local headerHeightOffset = props.headerHeightOffset or 0
	local actionBarHeightOffset = props.actionBarHeightOffset or 0

	local itemCardWidth = React.useMemo(function()
		if props.view == ViewType.Wide then
			return v.Size.Size_2500
		end

		return v.Size.Size_2000
	end, { props.view, v })

	local v2 = React.useCallback(function()
		local v2 = fn(props.view, v)

		local children = {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v.Padding.Large)
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = v2.top,
				PaddingLeft = v2.left,
				PaddingRight = v2.right,
				PaddingBottom = v2.bottom
			})
		}

		if props.items and #props.items > 0 then
			for k, item in props.items do
				children["Item" .. k] = React.createElement(ItemCardRowContainer, {
					item = item,
					view = props.view,
					LayoutOrder = k,
					onItemCardActivated = props.onItemCardActivated,
					itemCardWidth = itemCardWidth
				})
			end
		else
			for i = 1, 5 do
				children["Skeleton" .. i] = React.createElement(
					"Frame",
					{
						Size = UDim2.new(1, 0, 0, itemCardWidth),
						LayoutOrder = i,
						BackgroundTransparency = 1
					},
					{
						Skeleton = React.createElement(Skeleton, { Size = UDim2.new(1, 0, 1, 0) })
					}
				)
			end
		end

		return children
	end, { props.items, props.view, actionBarHeightOffset, v })

	local size = React.useMemo(function()
		if props.view == ViewType.Compact then
			return UDim2.new(1, 0, 1, -headerHeightOffset - v.Padding.Small - actionBarHeightOffset)
		end

		return UDim2.new(1, 0, 1, -headerHeightOffset - v.Padding.Small)
	end, { props.view, headerHeightOffset, v, actionBarHeightOffset })

	return React.createElement("ScrollingFrame", {
		Size = size,
		Position = UDim2.new(0, 0, 0, headerHeightOffset),
		CanvasSize = UDim2.new(1, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 0,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 2,
		ref = ref
	}, v2())
end))
