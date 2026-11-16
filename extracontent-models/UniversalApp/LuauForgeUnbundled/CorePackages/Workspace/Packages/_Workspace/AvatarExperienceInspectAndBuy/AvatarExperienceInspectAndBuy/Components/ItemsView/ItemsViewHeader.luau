local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation")
local useTokens = Foundation.Hooks.useTokens
local ViewType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/ViewType")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/BackButton")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/BuyActionBar")
local SubheaderLabelPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/SubheaderLabelPrice")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")

local function ItemsViewHeader(props)
	local v5 = useTokens()
	local v6 = props.view == ViewType.WideLandscape
	local v7 = props.view == ViewType.Compact

	local createElement = React.createElement
	local view = Foundation.View
	local v8 = {
		Size = UDim2.new(1, 0, 0, props.headerHeight)
	}

	local createElement2 = React.createElement
	local v10 = {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = 0,
		HorizontalFlex = 0
	}
	local newUDim = UDim.new

	local v12 = if v6 or v7 then v5.Padding.Medium else v5.Margin.Large * 2
	v10.Padding = newUDim(0, v12)

	local v13 = if not v6 then Enum.UIFlexAlignment.SpaceBetween else nil
	v10.HorizontalFlex = v13
	local children = {
		UIListLayout = createElement2("UIListLayout", v10),
		UIPadding = 0,
		BackButton = 0,
		HeaderTextAndSubheader = 0,
		BuyButton = 0
	}

	local v14 = if props.padding then React.createElement("UIPadding", {
		PaddingLeft = props.padding.left,
		PaddingRight = props.padding.right,
		PaddingTop = props.padding.top,
		PaddingBottom = props.padding.bottom
	}) else nil
	children.UIPadding = v14

	local v15 = if v6 then React.createElement(module4, {
		onBackButtonClick = props.onBackButtonClick,
		Position = UDim2.new(0, v5.Padding.Small, 0, v5.Padding.Small)
	}) else nil
	children.BackButton = v15

	local createElement3 = React.createElement
	local view2 = Foundation.View

	local v17 = {
		HeaderText = React.createElement(Foundation.Text, {
			LayoutOrder = 1,
			tag = "auto-xy text-heading-small content-emphasis text-truncate-end",
			Text = props.headerText
		}),
		SubheaderText = 0
	}

	local v18 = if props.subheaderText and not (v6 or v7) then React.createElement(SubheaderLabelPrice, {
		subheaderText = props.subheaderText,
		LayoutOrder = 2
	}) else nil
	v17.SubheaderText = v18
	children.HeaderTextAndSubheader = createElement3(
		view2,
		{
			BackgroundTransparency = 1,
			tag = "size-0-full auto-x col align-y-center",
			LayoutOrder = 2
		},
		v17
	)
	local v19

	if not (v6 or v7) then
		local createElement4 = React.createElement
		local button = Foundation.Button
		local v20 = {
			size = Foundation.Enums.InputSize.Medium,
			width = 0,
			LayoutOrder = 3,
			text = 0,
			variant = 0,
			isDisabled = 0,
			onActivated = 0
		}
		local v21 = if v7 then UDim.new(0, v5.Size.Size_2100) else UDim.new(0, v5.Size.Size_3000)
		v20.width = v21

		v20.text = props.purchaseButtonProps.purchaseButtonText
		v20.variant = Foundation.Enums.ButtonVariant.Emphasis
		v20.isDisabled = props.purchaseButtonProps.isDisabled
		v20.onActivated = props.purchaseButtonProps.onPurchase
		v19 = createElement4(button, v20)
	end

	children.BuyButton = v19
	return createElement(view, v8, children)
end

return ItemsViewHeader
