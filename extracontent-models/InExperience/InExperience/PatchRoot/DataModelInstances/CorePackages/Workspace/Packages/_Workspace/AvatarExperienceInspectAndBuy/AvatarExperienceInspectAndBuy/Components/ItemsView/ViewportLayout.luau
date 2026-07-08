local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local React = require(AvatarExperienceInspectAndBuyParent.React)
local Foundation = require(AvatarExperienceInspectAndBuyParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local BackButton = require(AvatarExperienceInspectAndBuy.Components.Common.BackButton)
local ViewType = require(AvatarExperienceInspectAndBuy.Enums.ViewType)
local BuyActionBarLayout = require(AvatarExperienceInspectAndBuy.Components.ItemsView.BuyActionBarLayout)

require(AvatarExperienceInspectAndBuy.Components.Common.BuyActionBar)
require(AvatarExperienceInspectAndBuy.Types)

local function ViewportLayout(t1: {[any]: any}) -- line: 64
	-- upvalues: ViewType (copy), useTokens (copy), React (copy), BackButton (copy), Foundation (copy), BuyActionBarLayout (copy)
	local v11 = t1.view == ViewType.WideLandscape
	local v12 = t1.backButtonProps and t1.backButtonProps.onBackButtonClick
	local v13 = useTokens()

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = t1.Size,
		AutomaticSize = t1.AutomaticSize
	}, {
		BackButton = if v11 or not t1.backButtonProps then nil else React.createElement(BackButton, {
			onBackButtonClick = v12,
			Position = t1.backButtonProps and t1.backButtonProps.Position or UDim2.new(0, v13.Padding.Small, 0, v13.Padding.Small)
		}),
		InnerView = React.createElement(Foundation.View, {
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalFlex = if not v11 then nil else Enum.UIFlexAlignment.SpaceBetween
			}),
			Thumbnail = if t1.tryOnState.isTryOnEnabled then nil else React.createElement(Foundation.View, {
				LayoutOrder = 1,
				Size = t1.viewportProps and t1.viewportProps.Size or UDim2.new(0, 200, 0, 200)
			}, {
				ImageLabel = React.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					Image = t1.thumbnailUrl,
					ScaleType = t1.viewportProps and t1.viewportProps.ScaleType or Enum.ScaleType.Fit
				}),
				UIFlexItem = if not v11 then nil else React.createElement("UIFlexItem", {
					FlexMode = Enum.UIFlexMode.Fill
				}),
				UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
					AspectRatio = t1.viewportProps and t1.viewportProps.AspectRatio or 1
				}),
				UIPadding = if not t1.thumbnailPadding then nil else React.createElement("UIPadding", {
					PaddingLeft = t1.thumbnailPadding.left,
					PaddingRight = t1.thumbnailPadding.right,
					PaddingTop = t1.thumbnailPadding.top,
					PaddingBottom = t1.thumbnailPadding.bottom
				})
			}),
			ViewportContainer = React.createElement(Foundation.View, {
				tag = "padding-top-medium",
				LayoutOrder = 1,
				Size = t1.viewportProps and t1.viewportProps.Size or UDim2.new(0, 200, 0, 200),
				Visible = t1.tryOnState.isTryOnEnabled
			}, {
				UIFlexItem = if not v11 then nil else React.createElement("UIFlexItem", {
					FlexMode = Enum.UIFlexMode.Fill
				}),
				UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
					AspectRatio = t1.viewportProps and t1.viewportProps.AspectRatio or 1
				}),
				Viewport = t1.renderTryOnViewport(t1.tryOnState.tryOnItem)
			}),
			BuyActionBarLayout = if not v11 or not t1.buyActionBarProps then nil else React.createElement(BuyActionBarLayout, {
				enableTopBorder = true,
				Size = UDim2.new(1, 0, 0, v13.Size.Size_1900),
				buyActionBarProps = t1.buyActionBarProps,
				purchaseButtonProps = t1.buyActionBarProps.purchaseButtonProps
			})
		})
	})
end

return ViewportLayout
