local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation")
local useTokens = Foundation.Hooks.useTokens
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/BackButton")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/BuyActionBar")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")

local function ItemHeader(props)
	local v5 = useTokens()
	local createElement = React.createElement
	local view = Foundation.View
	local v6 = { tag = "auto-xy size-full-0", LayoutOrder = props.LayoutOrder }

	local v8 = if props.padding then React.createElement("UIPadding", {
		PaddingLeft = props.padding.left,
		PaddingRight = props.padding.right,
		PaddingTop = props.padding.top,
		PaddingBottom = props.padding.bottom
	}) else nil

	local v9 = if props.purchaseButtonProps then React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween
	}) else nil

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v10 = { tag = "auto-xy col align-y-center", Size = UDim2.new(1, 0, 0, 0) }

	local v12 = if props.onBackButtonClick then React.createElement(module3, {
		onBackButtonClick = props.onBackButtonClick,
		LayoutOrder = 1
	}) else nil

	local createElement3 = React.createElement
	local view3 = Foundation.View

	local v15 = if props.onBackButtonClick then React.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, v5.Padding.Large)
	}) else nil

	local v16 = if props.header then props.header else nil
	local v17 = if props.subheader then props.subheader else nil
	local v7 = {
		UIPadding = v8,
		UIListLayout = v9,
		InnerFrame = createElement2(view2, v10, {
			BackButton = v12,
			HeaderAndSubheader = createElement3(view3, {
				tag = "auto-xy col",
				LayoutOrder = 2
			}, {
				UIPadding = v15,
				Header = v16,
				Subheader = v17
			})
		}),
		BuyButton = 0
	}

	local v18 = if props.purchaseButtonProps then React.createElement(Foundation.Button, {
		size = Foundation.Enums.InputSize.Medium,
		width = UDim.new(0, v5.Size.Size_3000),
		text = props.purchaseButtonProps.purchaseButtonText,
		variant = props.purchaseButtonProps.variant,
		isDisabled = props.purchaseButtonProps.isDisabled,
		onActivated = props.purchaseButtonProps.onPurchase,
		LayoutOrder = 2
	}) else nil
	v7.BuyButton = v18
	return createElement(view, v6, v7)
end

return ItemHeader
