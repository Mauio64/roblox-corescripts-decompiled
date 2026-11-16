local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local getFoundationIconName = require(script.Parent.getFoundationIconName)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local OfferExpiryBadge = AvatarExperienceCommon.Components.OfferExpiryBadge

local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens

local FFlagAXUpdateOffersEndsUIWithBadge = AvatarExperienceFlags.FFlagAXUpdateOffersEndsUIWithBadge
local FFlagAXRemoveOfferBannerIcon = AvatarExperienceFlags.FFlagAXRemoveOfferBannerIcon

local function CatalogOffersBannerView(props)
	local v

	if FFlagAXUpdateOffersEndsUIWithBadge then
		v = useTokens()
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v2 = {
		tag = props.rootTags,
		backgroundStyle = 0,
		Size = 0,
		Position = 0,
		testId = "CatalogOffersBanner"
	}
	local backgroundStyle

	if FFlagAXUpdateOffersEndsUIWithBadge then
		backgroundStyle = props.backgroundStyle
	end

	v2.backgroundStyle = backgroundStyle
	v2.Size = props.Size
	v2.Position = props.Position

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local leading

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
		local icon2

		if not (FFlagAXRemoveOfferBannerIcon and not getFoundationIconName(props.iconName)) then
			local createElement6 = React.createElement
			local icon = Foundation.Icon
			local v3 = {
				name = getFoundationIconName(props.iconName),
				variant = IconVariant.Filled,
				size = IconSize.Large,
				style = 0,
				AnchorPoint = 0,
				LayoutOrder = 1
			}
			local style

			if FFlagAXUpdateOffersEndsUIWithBadge then
				style = v.Color.System.Contrast
			else
				style = props.iconEmphasisStyle
			end

			v3.style = style

			v3.AnchorPoint = Vector2.new(0.5, 0.5)
			icon2 = createElement6(icon, v3)
		end

		local v3 = {
			Icon = icon2,
			Title = React.createElement(Foundation.Text, {
				Text = props.titleText,
				RichText = true,
				textStyle = props.titleContentEmphasisStyle,
				tag = "align-y-center grow auto-xy text-title-medium text-wrap text-align-x-left",
				LayoutOrder = 2
			}),
			ExpiryBadge = 0
		}
		local expiryBadge

		if FFlagAXUpdateOffersEndsUIWithBadge and props.expirationTimeInUTC then
			expiryBadge = React.createElement(OfferExpiryBadge, {
				layoutOrder = 3,
				expirationTimeInUTC = props.expirationTimeInUTC
			})
		end

		v3.ExpiryBadge = expiryBadge
		leading = createElement3(
			view3,
			{ tag = "grow auto-y", LayoutOrder = 1, testId = "CatalogOffersBannerDirectApiTapArea" },
			{
				HitTarget = createElement4("TextButton", onOfferBannerActivatedsByActivated, {
					TapInner = createElement5(view4, {
						tag = "row items-center gap-medium size-full-0 auto-y"
					}, v3)
				})
			}
		)
	else
		local createElement3 = React.createElement
		local view3 = Foundation.View
		local icon2

		if not (FFlagAXRemoveOfferBannerIcon and not getFoundationIconName(props.iconName)) then
			local createElement4 = React.createElement
			local icon = Foundation.Icon
			local v3 = {
				name = getFoundationIconName(props.iconName),
				variant = IconVariant.Regular,
				size = IconSize.Large,
				style = 0,
				AnchorPoint = 0,
				LayoutOrder = 1
			}
			local style

			if FFlagAXUpdateOffersEndsUIWithBadge then
				style = v.Color.System.Contrast
			else
				style = props.iconEmphasisStyle
			end

			v3.style = style

			v3.AnchorPoint = Vector2.new(0.5, 0.5)
			icon2 = createElement4(icon, v3)
		end

		leading = createElement3(view3, {
			tag = "row items-center grow gap-medium auto-y",
			LayoutOrder = 1
		}, {
			Icon = icon2,
			Title = React.createElement(Foundation.Text, {
				Text = props.titleText,
				RichText = true,
				textStyle = props.titleContentEmphasisStyle,
				tag = "align-y-center grow auto-xy text-title-medium text-wrap text-align-x-left",
				LayoutOrder = 2
			})
		})
	end

	return createElement(view, v2, {
		BannerRow = createElement2(view2, {
			tag = FFlagAXUpdateOffersEndsUIWithBadge and "row items-center gap-xsmall size-full-0 auto-y padding-x-medium padding-bottom-small padding-top-xsmall" or "row items-center gap-medium size-full-0 auto-y padding-x-medium padding-bottom-small padding-top-xsmall",
			LayoutOrder = 1
		}, {
			Leading = leading,
			Close = React.createElement(
				Foundation.View,
				{ tag = "row items-center auto-xy", LayoutOrder = 2, ZIndex = 2 },
				{
					CloseButton = React.createElement(Foundation.IconButton, {
						icon = IconName.XSmall,
						isCircular = true,
						variant = ButtonVariant.Utility,
						size = InputSize.Small,
						onActivated = props.onCloseActivated,
						testId = "CatalogOffersBannerClose"
					})
				}
			)
		})
	})
end

return CatalogOffersBannerView
