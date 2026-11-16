local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local View = Foundation.View
local Text = Foundation.Text
local Image = Foundation.Image
local Icon = Foundation.Icon
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local IconSize = Foundation.Enums.IconSize

local formatPrice = require(InExperienceShop.Utils.formatPrice)
local computeShopRowTileWidths = require(InExperienceShop.Components.computeShopRowTileWidths)
local MEDIA_HEIGHT_SCALE_FALLBACK = computeShopRowTileWidths.MEDIA_HEIGHT_SCALE_FALLBACK

local udim = UDim2.fromOffset(50, 50)

local v = {
	buy = "Feature.Catalog.Action.Buy",
	bonusItem = "Feature.InExperienceShop.Label.BonusItem",
	robux = "Feature.Home.Robux"
}

local function getTitleText(hasBonusItem: boolean?, robux: string, bonusItem: string) -- 1 equivalent call inferred from this helper
	if hasBonusItem then
		return `{robux} + {bonusItem}`
	end

	return robux
end

local function renderMediaContent(props)
	local text = formatPrice(props.robuxAmount)
	local hasBonusItem = props.hasBonusItem == true

	local mediaContent = {
		RobuxGroup = React.createElement(
			View,
			{
				tag = "row align-y-center gap-xsmall auto-xy",
				testId = "RobuxPackageTile-RobuxGroup",
				LayoutOrder = 1
			},
			{
				RobuxIcon = React.createElement(Icon, {
					name = props.robuxImage,
					size = IconSize.Medium,
					testId = "RobuxPackageTile-RobuxIcon",
					LayoutOrder = 1
				}),
				RobuxAmount = React.createElement(Text, {
					tag = "auto-xy text-heading-medium content-emphasis",
					Text = text,
					testId = "RobuxPackageTile-MediaRobuxAmount",
					LayoutOrder = 2
				})
			}
		),
		PlusSign = 0,
		BonusItemImage = 0
	}
	local plusSign

	if hasBonusItem and props.bonusItemThumbnail then
		plusSign = React.createElement(Text, {
			tag = "auto-xy text-heading-medium content-emphasis",
			Text = "+",
			testId = "RobuxPackageTile-PlusSign",
			LayoutOrder = 2
		})
	end

	mediaContent.PlusSign = plusSign
	local bonusItemImage

	if hasBonusItem and props.bonusItemThumbnail then
		bonusItemImage = React.createElement(Image, {
			tag = "radius-medium bg-shift-200",
			Size = udim,
			Image = props.bonusItemThumbnail,
			ScaleType = Enum.ScaleType.Fit,
			testId = "RobuxPackageTile-BonusItemImage",
			LayoutOrder = 3
		})
	end

	mediaContent.BonusItemImage = bonusItemImage
	return mediaContent
end

local function RobuxPackageTile(props)
	local v2 = useLocalization(v)
	local titleText = getTitleText(props.hasBonusItem, v2.robux, v2.bonusItem) -- inferred equivalent call
	local mediaHeightScale = props.mediaHeightScale or MEDIA_HEIGHT_SCALE_FALLBACK

	local createElement = React.createElement
	local v3 = {
		tag = "col fill size-full-0 auto-y radius-medium clip bg-shift-200",
		testId = "RobuxPackageTile",
		LayoutOrder = props.LayoutOrder,
		onActivated = props.onTileActivated
	}
	local v4 = {
		MediaWrapper = React.createElement(View, {
			tag = "row align-x-center align-y-center gap-small size-full-0 bg-shift-200",
			Size = UDim2.fromScale(1, mediaHeightScale),
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			testId = "RobuxPackageTile-MediaWrapper",
			LayoutOrder = 1
		}, renderMediaContent(props)),
		TileContent = 0
	}

	local createElement2 = React.createElement

	local v5 = {
		ContentHeader = React.createElement(View, {
			tag = "col size-full-0 auto-y",
			LayoutOrder = 1
		}, {
			Title = React.createElement(Text, {
				tag = "size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end content-emphasis",
				Text = titleText,
				testId = "RobuxPackageTile-Title",
				LayoutOrder = 1
			}),
			RobuxAmount = React.createElement(
				View,
				{
					tag = "row align-y-center auto-xy",
					testId = "RobuxPackageTile-RobuxAmount",
					LayoutOrder = 2
				},
				{
					PriceLabel = React.createElement(Text, {
						tag = "auto-xy text-body-medium text-truncate-end content-default",
						Text = props.currencyAmountStr,
						testId = "RobuxPackageTile-PriceLabel",
						LayoutOrder = 1
					})
				}
			)
		}),
		Footer = 0
	}

	local createElement3 = React.createElement
	local v6 = {
		text = v2.buy,
		variant = 0,
		size = 0,
		width = 0,
		onActivated = 0,
		isLoading = 0,
		testId = "RobuxPackageTile-BuyButton",
		LayoutOrder = 2
	}
	local variant

	if props.isPrimaryRobuxPackage == true then
		variant = ButtonVariant.SoftEmphasis
	else
		variant = ButtonVariant.Standard
	end

	v6.variant = variant

	v6.size = InputSize.Small
	v6.width = UDim.new(1, 0)
	v6.onActivated = props.onBuyActivated or function() end
	v6.isLoading = props.isBuyLoading
	v5.Footer = createElement3(Button, v6)
	v4.TileContent = createElement2(
		View,
		{ tag = "col gap-medium size-full-0 auto-y padding-medium", LayoutOrder = 2 },
		v5
	)
	return createElement(View, v3, v4)
end

return React.memo(RobuxPackageTile)
