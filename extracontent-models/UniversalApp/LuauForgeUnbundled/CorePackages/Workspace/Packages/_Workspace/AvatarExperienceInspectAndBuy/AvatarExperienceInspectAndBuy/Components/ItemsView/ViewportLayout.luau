local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation")
local useTokens = Foundation.Hooks.useTokens
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/BackButton")
local ViewType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/ViewType")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/ItemsView/BuyActionBarLayout")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/BuyActionBar")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
local getTryOnBackgroundImage = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getTryOnBackgroundImage")

local fFlagAXInspectAndBuyAvatarBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceFlags").FFlagAXInspectAndBuyAvatarBackground

local function ViewportLayout(props)
	local v5 = props.view == ViewType.WideLandscape
	local onBackButtonClick = props.backButtonProps and props.backButtonProps.onBackButtonClick
	local v6 = useTokens()
	local backgroundImageUrl = if fFlagAXInspectAndBuyAvatarBackground then props.backgroundImageUrl else nil

	local createElement = React.createElement
	local v8 = {
		Size = props.Size,
		AutomaticSize = props.AutomaticSize,
		BackgroundTransparency = 1
	}

	local v10 = if not (v5 or not props.backButtonProps) then React.createElement(module3, {
		onBackButtonClick = onBackButtonClick,
		Position = props.backButtonProps and props.backButtonProps.Position or UDim2.new(0, v6.Padding.Small, 0, v6.Padding.Small)
	}) else nil

	local createElement2 = React.createElement
	local view = Foundation.View
	local v11 = { Size = UDim2.new(1, 0, 1, 0) }

	local createElement3 = React.createElement
	local v13 = {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalFlex = 0
	}
	local v14 = if v5 then Enum.UIFlexAlignment.SpaceBetween else nil
	v13.VerticalFlex = v14
	local children = {
		UIListLayout = createElement3("UIListLayout", v13),
		Thumbnail = 0,
		ViewportContainer = 0,
		BuyActionBarLayout = 0
	}
	local v15

	if not props.tryOnState.isTryOnEnabled then
		local createElement4 = React.createElement
		local view2 = Foundation.View
		local v16 = {
			Size = props.viewportProps and props.viewportProps.Size or UDim2.new(0, 200, 0, 200),
			LayoutOrder = 1
		}

		local v17 = if backgroundImageUrl then React.createElement(Foundation.Image, {
			Image = backgroundImageUrl,
			ScaleType = Enum.ScaleType.Crop,
			tag = "size-full radius-medium",
			ZIndex = 1,
			testId = "inspect-and-buy-viewport-background"
		}) else nil
		local children2 = {
			Background = v17,
			ImageLabel = React.createElement("ImageLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Image = props.thumbnailUrl,
				ScaleType = props.viewportProps and props.viewportProps.ScaleType or Enum.ScaleType.Fit,
				ZIndex = backgroundImageUrl and 2 or nil
			}),
			UIFlexItem = 0,
			UIAspectRatioConstraint = 0,
			UIPadding = 0
		}

		local v18 = if v5 then React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Fill
		}) else nil
		children2.UIFlexItem = v18

		children2.UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
			AspectRatio = props.viewportProps and props.viewportProps.AspectRatio or 1
		})

		local v19 = if props.thumbnailPadding then React.createElement("UIPadding", {
			PaddingLeft = props.thumbnailPadding.left,
			PaddingRight = props.thumbnailPadding.right,
			PaddingTop = props.thumbnailPadding.top,
			PaddingBottom = props.thumbnailPadding.bottom
		}) else nil
		children2.UIPadding = v19
		v15 = createElement4(view2, v16, children2)
	end

	children.Thumbnail = v15

	local createElement4 = React.createElement
	local view2 = Foundation.View
	local v16 = {
		tag = "padding-top-medium",
		Size = props.viewportProps and props.viewportProps.Size or UDim2.new(0, 200, 0, 200),
		LayoutOrder = 1,
		Visible = props.tryOnState.isTryOnEnabled
	}

	local v18 = if v5 then React.createElement("UIFlexItem", {
		FlexMode = Enum.UIFlexMode.Fill
	}) else nil
	local v17 = {
		UIFlexItem = v18,
		UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
			AspectRatio = props.viewportProps and props.viewportProps.AspectRatio or 1
		}),
		TryOnBackground = 0,
		Viewport = 0
	}

	local v19 = if fFlagAXInspectAndBuyAvatarBackground and props.tryOnState.isTryOnEnabled then React.createElement(Foundation.Image, {
		Image = getTryOnBackgroundImage(props.tryOnState.tryOnItem),
		ScaleType = Enum.ScaleType.Crop,
		tag = "size-full radius-medium",
		ZIndex = 0,
		testId = "inspect-and-buy-try-on-background"
	}) else nil
	v17.TryOnBackground = v19

	v17.Viewport = props.renderTryOnViewport(props.tryOnState.tryOnItem)
	children.ViewportContainer = createElement4(view2, v16, v17)

	local v20 = if v5 and props.buyActionBarProps then React.createElement(module5, {
		enableTopBorder = true,
		Size = UDim2.new(1, 0, 0, v6.Size.Size_1900),
		buyActionBarProps = props.buyActionBarProps,
		purchaseButtonProps = props.buyActionBarProps.purchaseButtonProps
	}) else nil
	children.BuyActionBarLayout = v20
	return createElement("Frame", v8, {
		BackButton = v10,
		InnerView = createElement2(view, v11, children)
	})
end

return ViewportLayout
