local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local getFoundationIconName = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/CatalogOffersBanner/getFoundationIconName")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")
local offerExpiryBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon").Components.OfferExpiryBadge

local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local iconVariant = Foundation.Enums.IconVariant
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens

local fFlagAXUpdateOffersEndsUIWithBadge = AvatarExperienceFlags.FFlagAXUpdateOffersEndsUIWithBadge
local fFlagAXRemoveOfferBannerIcon = AvatarExperienceFlags.FFlagAXRemoveOfferBannerIcon

local function CatalogOffersBannerView(props)
	local v5 = if fFlagAXUpdateOffersEndsUIWithBadge then useTokens() else nil

	local createElement = React.createElement
	local view = Foundation.View
	local v6 = {
		tag = props.rootTags,
		backgroundStyle = 0,
		Size = 0,
		Position = 0,
		testId = "CatalogOffersBanner"
	}
	local v7 = if fFlagAXUpdateOffersEndsUIWithBadge then props.backgroundStyle else nil
	v6.backgroundStyle = v7
	v6.Size = props.Size
	v6.Position = props.Position

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v11

	if props.offerModalTapAreaEnabled and props.onOfferBannerActivated then
		local createElement3 = React.createElement
		local view3 = Foundation.View

		local createElement4 = React.createElement
		local onOfferBannerActivatedsByActivated = {
			Text = "",
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Selectable = false,
			[React.Event.Activated] = props.onOfferBannerActivated
		}

		local createElement5 = React.createElement
		local view4 = Foundation.View
		local v18

		if not (fFlagAXRemoveOfferBannerIcon and not getFoundationIconName(props.iconName)) then
			local createElement6 = React.createElement
			local icon = Foundation.Icon
			local v19 = {
				name = getFoundationIconName(props.iconName),
				variant = iconVariant.Filled,
				size = iconSize.Large,
				style = 0,
				AnchorPoint = 0,
				LayoutOrder = 1
			}

			local v20 = if fFlagAXUpdateOffersEndsUIWithBadge then v5.Color.System.Contrast else props.iconEmphasisStyle
			v19.style = v20

			v19.AnchorPoint = Vector2.new(0.5, 0.5)
			v18 = createElement6(icon, v19)
		end

		local v17 = {
			Icon = v18,
			Title = React.createElement(Foundation.Text, {
				Text = props.titleText,
				RichText = true,
				textStyle = props.titleContentEmphasisStyle,
				tag = "align-y-center grow auto-xy text-title-medium text-wrap text-align-x-left",
				LayoutOrder = 2
			}),
			ExpiryBadge = 0
		}

		local v19 = if fFlagAXUpdateOffersEndsUIWithBadge and props.expirationTimeInUTC then React.createElement(offerExpiryBadge, {
			layoutOrder = 3,
			expirationTimeInUTC = props.expirationTimeInUTC
		}) else nil
		v17.ExpiryBadge = v19
		v11 = createElement3(
			view3,
			{
				tag = "grow auto-y",
				LayoutOrder = 1,
				testId = "CatalogOffersBannerDirectApiTapArea"
			},
			{
				HitTarget = createElement4("TextButton", onOfferBannerActivatedsByActivated, {
					TapInner = createElement5(
						view4,
						{ tag = "row items-center gap-medium size-full-0 auto-y" },
						v17
					)
				})
			}
		)
	else
		local createElement3 = React.createElement
		local view3 = Foundation.View
		local v14

		if not (fFlagAXRemoveOfferBannerIcon and not getFoundationIconName(props.iconName)) then
			local createElement4 = React.createElement
			local icon = Foundation.Icon
			local v15 = {
				name = getFoundationIconName(props.iconName),
				variant = iconVariant.Regular,
				size = iconSize.Large,
				style = 0,
				AnchorPoint = 0,
				LayoutOrder = 1
			}

			local v16 = if fFlagAXUpdateOffersEndsUIWithBadge then v5.Color.System.Contrast else props.iconEmphasisStyle
			v15.style = v16

			v15.AnchorPoint = Vector2.new(0.5, 0.5)
			v14 = createElement4(icon, v15)
		end

		v11 = createElement3(view3, {
			tag = "row items-center grow gap-medium auto-y",
			LayoutOrder = 1
		}, {
			Icon = v14,
			Title = React.createElement(Foundation.Text, {
				Text = props.titleText,
				RichText = true,
				textStyle = props.titleContentEmphasisStyle,
				tag = "align-y-center grow auto-xy text-title-medium text-wrap text-align-x-left",
				LayoutOrder = 2
			})
		})
	end

	return createElement(view, v6, {
		BannerRow = createElement2(view2, {
			tag = fFlagAXUpdateOffersEndsUIWithBadge and "row items-center gap-xsmall size-full-0 auto-y padding-x-medium padding-bottom-small padding-top-xsmall" or "row items-center gap-medium size-full-0 auto-y padding-x-medium padding-bottom-small padding-top-xsmall",
			LayoutOrder = 1
		}, {
			Leading = v11,
			Close = React.createElement(
				Foundation.View,
				{ tag = "row items-center auto-xy", LayoutOrder = 2, ZIndex = 2 },
				{
					CloseButton = React.createElement(Foundation.IconButton, {
						icon = iconName.XSmall,
						isCircular = true,
						variant = buttonVariant.Utility,
						size = inputSize.Small,
						onActivated = props.onCloseActivated,
						testId = "CatalogOffersBannerClose"
					})
				}
			)
		})
	})
end

return CatalogOffersBannerView
