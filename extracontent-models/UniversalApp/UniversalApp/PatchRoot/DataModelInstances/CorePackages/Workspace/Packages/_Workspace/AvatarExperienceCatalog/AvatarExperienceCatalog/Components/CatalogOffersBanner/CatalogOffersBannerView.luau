local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local getFoundationIconName = require(script.Parent.getFoundationIconName)
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function CatalogOffersBannerView(t1: {[any]: any}) -- line: 36
	-- upvalues: React (copy), Foundation (copy), getFoundationIconName (copy), IconVariant (copy), IconSize (copy), IconName (copy), ButtonVariant (copy), InputSize (copy)
	return React.createElement(Foundation.View, {
		testId = "CatalogOffersBanner",
		tag = t1.rootTags,
		Size = t1.Size,
		Position = t1.Position
	}, {
		BannerRow = React.createElement(Foundation.View, {
			tag = "row items-center gap-medium size-full-0 auto-y padding-x-medium padding-bottom-small padding-top-xsmall",
			LayoutOrder = 1
		}, {
			Leading = if not t1.offerModalTapAreaEnabled or not t1.onOfferBannerActivated then React.createElement(Foundation.View, {
				tag = "row items-center grow gap-medium auto-y",
				LayoutOrder = 1
			}, {
				Icon = React.createElement(Foundation.Icon, {
					LayoutOrder = 1,
					name = getFoundationIconName(t1.iconName),
					variant = IconVariant.Regular,
					size = IconSize.Large,
					style = t1.iconEmphasisStyle,
					AnchorPoint = Vector2.new(0.5, 0.5)
				}),
				Title = React.createElement(Foundation.Text, {
					RichText = true,
					tag = "align-y-center grow auto-xy text-title-medium text-wrap text-align-x-left",
					LayoutOrder = 2,
					Text = t1.titleText,
					textStyle = t1.titleContentEmphasisStyle
				})
			}) else React.createElement(Foundation.View, {
				tag = "grow auto-y",
				LayoutOrder = 1,
				testId = "CatalogOffersBannerDirectApiTapArea"
			}, {
				HitTarget = React.createElement("TextButton", {
					Text = "",
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					Selectable = false,
					[React.Event.Activated] = t1.onOfferBannerActivated
				}, {
					TapInner = React.createElement(Foundation.View, {
						tag = "row items-center gap-medium size-full-0 auto-y"
					}, {
						Icon = React.createElement(Foundation.Icon, {
							LayoutOrder = 1,
							name = getFoundationIconName(t1.iconName),
							variant = IconVariant.Filled,
							size = IconSize.Large,
							style = t1.iconEmphasisStyle,
							AnchorPoint = Vector2.new(0.5, 0.5)
						}),
						Title = React.createElement(Foundation.Text, {
							RichText = true,
							tag = "align-y-center grow auto-xy text-title-medium text-wrap text-align-x-left",
							LayoutOrder = 2,
							Text = t1.titleText,
							textStyle = t1.titleContentEmphasisStyle
						})
					})
				})
			}),
			Close = React.createElement(Foundation.View, {
				tag = "row items-center auto-xy",
				LayoutOrder = 2,
				ZIndex = 2
			}, {
				CloseButton = React.createElement(Foundation.IconButton, {
					isCircular = true,
					testId = "CatalogOffersBannerClose",
					icon = IconName.XSmall,
					variant = ButtonVariant.Utility,
					size = InputSize.Small,
					onActivated = t1.onCloseActivated
				})
			})
		})
	})
end

return CatalogOffersBannerView
