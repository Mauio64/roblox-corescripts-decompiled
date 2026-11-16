local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local ViewType = require(AvatarExperienceInspectAndBuy.Enums.ViewType)
local BackButton = require(AvatarExperienceInspectAndBuy.Components.Common.BackButton)
require(AvatarExperienceInspectAndBuy.Components.Common.BuyActionBar)
local SubheaderLabelPrice = require(AvatarExperienceInspectAndBuy.Components.Common.SubheaderLabelPrice)
require(AvatarExperienceInspectAndBuy.Types)

local function ItemsViewHeader(props)
	local v = useTokens()
	local v2 = props.view == ViewType.WideLandscape
	local v3 = props.view == ViewType.Compact

	local createElement = React.createElement
	local view = Foundation.View
	local v4 = {
		Size = UDim2.new(1, 0, 0, props.headerHeight)
	}

	local createElement2 = React.createElement
	local v5 = {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = 0,
		HorizontalFlex = 0
	}
	local v6

	if v2 or v3 then
		v6 = v.Padding.Medium
	else
		v6 = v.Margin.Large * 2
	end

	v5.Padding = UDim.new(0, v6)
	local horizontalFlex

	if not v2 then
		horizontalFlex = Enum.UIFlexAlignment.SpaceBetween
	end

	v5.HorizontalFlex = horizontalFlex
	local children = {
		UIListLayout = createElement2("UIListLayout", v5),
		UIPadding = 0,
		BackButton = 0,
		HeaderTextAndSubheader = 0,
		BuyButton = 0
	}
	local uiPadding

	if props.padding then
		uiPadding = React.createElement("UIPadding", {
			PaddingLeft = props.padding.left,
			PaddingRight = props.padding.right,
			PaddingTop = props.padding.top,
			PaddingBottom = props.padding.bottom
		})
	end

	children.UIPadding = uiPadding
	local backButton

	if v2 then
		backButton = React.createElement(BackButton, {
			onBackButtonClick = props.onBackButtonClick,
			Position = UDim2.new(0, v.Padding.Small, 0, v.Padding.Small)
		})
	end

	children.BackButton = backButton

	local createElement3 = React.createElement
	local view2 = Foundation.View

	local v7 = {
		HeaderText = React.createElement(Foundation.Text, {
			LayoutOrder = 1,
			tag = "auto-xy text-heading-small content-emphasis text-truncate-end",
			Text = props.headerText
		}),
		SubheaderText = 0
	}
	local subheaderText

	if props.subheaderText and not (v2 or v3) then
		subheaderText = React.createElement(SubheaderLabelPrice, {
			subheaderText = props.subheaderText,
			LayoutOrder = 2
		})
	end

	v7.SubheaderText = subheaderText
	children.HeaderTextAndSubheader = createElement3(
		view2,
		{
			BackgroundTransparency = 1,
			tag = "size-0-full auto-x col align-y-center",
			LayoutOrder = 2
		},
		v7
	)
	local buyButton

	if not (v2 or v3) then
		local createElement4 = React.createElement
		local button = Foundation.Button
		local v8 = {
			size = Foundation.Enums.InputSize.Medium,
			width = 0,
			LayoutOrder = 3,
			text = 0,
			variant = 0,
			isDisabled = 0,
			onActivated = 0
		}
		local width

		if v3 then
			width = UDim.new(0, v.Size.Size_2100)
		else
			width = UDim.new(0, v.Size.Size_3000)
		end

		v8.width = width

		v8.text = props.purchaseButtonProps.purchaseButtonText
		v8.variant = Foundation.Enums.ButtonVariant.Emphasis
		v8.isDisabled = props.purchaseButtonProps.isDisabled
		v8.onActivated = props.purchaseButtonProps.onPurchase
		buyButton = createElement4(button, v8)
	end

	children.BuyButton = buyButton
	return createElement(view, v4, children)
end

return ItemsViewHeader
