local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation")
local ItemsViewHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/ItemsView/ItemsViewHeader")
local AvatarItemsView = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/ItemsView/AvatarItemsView")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/ItemsView/BuyActionBarLayout")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/SubheaderLabelPrice")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/BuyActionBar")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
local ViewType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/ViewType")
local useTokens = Foundation.Hooks.useTokens

local function fn(view, p2)
	if view == ViewType.Compact then
		return {
			left = UDim.new(0, p2.Padding.Medium),
			right = UDim.new(0, p2.Padding.Medium)
		}
	end

	if view == ViewType.Wide then
		return {
			top = UDim.new(0, p2.Padding.XLarge),
			left = UDim.new(0, p2.Margin.Large * 2),
			right = UDim.new(0, p2.Margin.Large * 2),
			bottom = UDim.new(0, p2.Padding.XLarge)
		}
	end

	if view == ViewType.WideLandscape then
		return {
			left = UDim.new(0, p2.Padding.Small),
			right = UDim.new(0, p2.Padding.Medium),
			top = UDim.new(0, p2.Padding.XSmall)
		}
	end

	return nil
end

return (React.forwardRef(function(props, p2)
	local view = props.view
	local v5 = useTokens()
	local items = props.items
	local onInspectMenuClosed = props.onInspectMenuClosed

	local v6 = props.view == ViewType.Compact

	local createElement = React.createElement
	local v8 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

	local v9 = {
		Header = React.createElement(ItemsViewHeader, {
			view = view,
			headerHeight = v5.Size.Size_1300,
			padding = fn(view, v5),
			headerText = props.headerText,
			subheaderText = props.subheaderText,
			onBackButtonClick = function()
				onInspectMenuClosed()
			end,
			purchaseButtonProps = props.buyActionBarProps.purchaseButtonProps
		}),
		List = React.createElement(AvatarItemsView, {
			items = items,
			view = view,
			headerHeightOffset = v5.Size.Size_1300,
			actionBarHeightOffset = v5.Size.Size_2700,
			onItemCardActivated = props.onItemCardActivated,
			ref = p2
		}),
		BuyActionBarLayout = 0
	}

	local v10 = if v6 then React.createElement(module5, {
		buyActionBarProps = props.buyActionBarProps,
		enableTopBorder = true,
		ZIndex = 2,
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		padding = UDim.new(0, v5.Padding.Medium),
		Size = UDim2.new(1, 0, 0, v5.Size.Size_2700)
	}) else nil
	v9.BuyActionBarLayout = v10
	return createElement("Frame", v8, v9)
end))
