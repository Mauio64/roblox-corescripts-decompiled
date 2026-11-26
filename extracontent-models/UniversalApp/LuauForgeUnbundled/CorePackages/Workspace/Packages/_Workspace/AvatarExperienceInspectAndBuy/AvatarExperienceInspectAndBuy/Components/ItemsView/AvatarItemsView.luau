local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation")
local skeleton = Foundation.Skeleton
local useTokens = Foundation.Hooks.useTokens
local ViewType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/ViewType")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
local ItemCardRowContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/ItemsView/ItemCardRowContainer")

local function fn(view, p2)
	if view == ViewType.WideLandscape then
		return {
			left = UDim.new(0, p2.Padding.XLarge),
			right = UDim.new(0, p2.Padding.XLarge),
			bottom = UDim.new(0, p2.Padding.Large)
		}
	end

	if view == ViewType.Compact then
		return {
			left = UDim.new(0, p2.Padding.Large),
			right = UDim.new(0, p2.Padding.Large),
			bottom = UDim.new(0, p2.Padding.Large)
		}
	end

	return {
		top = UDim.new(0, p2.Padding.Medium),
		left = UDim.new(0, p2.Margin.Large * 2),
		right = UDim.new(0, p2.Margin.Large * 2),
		bottom = UDim.new(0, p2.Padding.Large)
	}
end

return (React.forwardRef(function(props, p2)
	local v5 = useTokens()
	local headerHeightOffset = props.headerHeightOffset or 0
	local actionBarHeightOffset = props.actionBarHeightOffset or 0

	local v6 = React.useMemo(function()
		if props.view == ViewType.Wide then
			return v5.Size.Size_2500
		end

		return v5.Size.Size_2000
	end, { props.view, v5 })

	local v7 = React.useCallback(function()
		local v8 = fn(props.view, v5)

		local children = {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v5.Padding.Large)
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = v8.top,
				PaddingLeft = v8.left,
				PaddingRight = v8.right,
				PaddingBottom = v8.bottom
			})
		}

		if props.items and #props.items > 0 then
			for k, item in props.items do
				children["Item" .. k] = React.createElement(ItemCardRowContainer, {
					item = item,
					view = props.view,
					LayoutOrder = k,
					onItemCardActivated = props.onItemCardActivated,
					itemCardWidth = v6
				})
			end
		else
			for i = 1, 5 do
				children["Skeleton" .. i] = React.createElement(
					"Frame",
					{
						Size = UDim2.new(1, 0, 0, v6),
						LayoutOrder = i,
						BackgroundTransparency = 1
					},
					{
						Skeleton = React.createElement(skeleton, {
							Size = UDim2.new(1, 0, 1, 0)
						})
					}
				)
			end
		end

		return children
	end, { props.items, props.view, actionBarHeightOffset, v5 })

	local v8 = React.useMemo(function()
		if props.view == ViewType.Compact then
			return UDim2.new(1, 0, 1, -headerHeightOffset - v5.Padding.Small - actionBarHeightOffset)
		end

		return UDim2.new(1, 0, 1, -headerHeightOffset - v5.Padding.Small)
	end, { props.view, headerHeightOffset, v5, actionBarHeightOffset })

	return React.createElement("ScrollingFrame", {
		Size = v8,
		Position = UDim2.new(0, 0, 0, headerHeightOffset),
		CanvasSize = UDim2.new(1, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 0,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = 2,
		ref = p2
	}, v7())
end))
