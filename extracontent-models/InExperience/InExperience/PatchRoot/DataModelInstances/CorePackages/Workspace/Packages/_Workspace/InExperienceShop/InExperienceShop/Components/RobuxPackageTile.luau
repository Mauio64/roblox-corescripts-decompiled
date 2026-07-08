local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local Foundation = require(InExperienceShopParent.Foundation)
local useLocalization = require(InExperienceShopParent.Localization).Hooks.useLocalization
local View = Foundation.View
local FoundationText = Foundation.Text
local FoundationImage = Foundation.Image
local Icon = Foundation.Icon
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local IconSize = Foundation.Enums.IconSize
local formatPrice = require(InExperienceShop.Utils.formatPrice)
local MEDIA_HEIGHT_SCALE_FALLBACK = require(InExperienceShop.Components.computeShopRowTileWidths).MEDIA_HEIGHT_SCALE_FALLBACK
local uDim2 = UDim2.fromOffset(50, 50)
local t1 = {
	buy = "Feature.Catalog.Action.Buy",
	bonusItem = "Feature.InExperienceShop.Label.BonusItem",
	robux = "Feature.Home.Robux"
}

local function getTitleText(b1: boolean?, s1: string, s2: string) -- line: 44
	if b1 then
		return `{ s1 } + { s2 }`
	end

	return s1
end
local function renderMediaContent(t2: {[any]: any}) -- line: 52
	-- upvalues: formatPrice (copy), React (copy), View (copy), Icon (copy), IconSize (copy), FoundationText (copy), FoundationImage (copy), uDim2 (copy)
	local v25 = formatPrice(t2.robuxAmount)
	local v26 = t2.hasBonusItem == true

	return {
		RobuxGroup = React.createElement(View, {
			tag = "row align-y-center gap-xsmall auto-xy",
			testId = "RobuxPackageTile-RobuxGroup",
			LayoutOrder = 1
		}, {
			RobuxIcon = React.createElement(Icon, {
				testId = "RobuxPackageTile-RobuxIcon",
				LayoutOrder = 1,
				name = t2.robuxImage,
				size = IconSize.Medium
			}),
			RobuxAmount = React.createElement(FoundationText, {
				tag = "auto-xy text-heading-medium content-emphasis",
				testId = "RobuxPackageTile-MediaRobuxAmount",
				LayoutOrder = 2,
				Text = v25
			})
		}),
		PlusSign = if not v26 or not t2.bonusItemThumbnail then nil else React.createElement(FoundationText, {
			tag = "auto-xy text-heading-medium content-emphasis",
			Text = "+",
			testId = "RobuxPackageTile-PlusSign",
			LayoutOrder = 2
		}),
		BonusItemImage = if not v26 or not t2.bonusItemThumbnail then nil else React.createElement(FoundationImage, {
			tag = "radius-medium bg-shift-200",
			testId = "RobuxPackageTile-BonusItemImage",
			LayoutOrder = 3,
			Size = uDim2,
			Image = t2.bonusItemThumbnail,
			ScaleType = Enum.ScaleType.Fit
		})
	}
end
local function RobuxPackageTile(t3: {[any]: any}) -- line: 97
	-- upvalues: useLocalization (copy), t1 (copy), MEDIA_HEIGHT_SCALE_FALLBACK (copy), React (copy), View (copy), renderMediaContent (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), InputSize (copy)
	local v28 = useLocalization(t1)
	local hasBonusItem = t3.hasBonusItem
	local robux = v28.robux
	local bonusItem = v28.bonusItem
	local v32 = if not hasBonusItem then robux else `{ robux } + { bonusItem }`
	local v33 = t3.mediaHeightScale or MEDIA_HEIGHT_SCALE_FALLBACK

	return React.createElement(View, {
		tag = "col fill size-full-0 auto-y radius-medium clip bg-shift-200",
		testId = "RobuxPackageTile",
		LayoutOrder = t3.LayoutOrder,
		onActivated = t3.onTileActivated
	}, {
		MediaWrapper = React.createElement(View, {
			tag = "row align-x-center align-y-center gap-small size-full-0 bg-shift-200",
			testId = "RobuxPackageTile-MediaWrapper",
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, v33),
			SizeConstraint = Enum.SizeConstraint.RelativeXX
		}, (renderMediaContent(t3))),
		TileContent = React.createElement(View, {
			tag = "col gap-medium size-full-0 auto-y padding-medium",
			LayoutOrder = 2
		}, {
			ContentHeader = React.createElement(View, {
				tag = "col size-full-0 auto-y",
				LayoutOrder = 1
			}, {
				Title = React.createElement(FoundationText, {
					tag = "size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end content-emphasis",
					testId = "RobuxPackageTile-Title",
					LayoutOrder = 1,
					Text = v32
				}),
				RobuxAmount = React.createElement(View, {
					tag = "row align-y-center auto-xy",
					testId = "RobuxPackageTile-RobuxAmount",
					LayoutOrder = 2
				}, {
					PriceLabel = React.createElement(FoundationText, {
						tag = "auto-xy text-body-medium text-truncate-end content-default",
						testId = "RobuxPackageTile-PriceLabel",
						LayoutOrder = 1,
						Text = t3.currencyAmountStr
					})
				})
			}),
			Footer = React.createElement(Button, {
				testId = "RobuxPackageTile-BuyButton",
				LayoutOrder = 2,
				text = v28.buy,
				variant = if t3.isPrimaryRobuxPackage ~= true then ButtonVariant.Standard else ButtonVariant.SoftEmphasis,
				size = InputSize.Small,
				width = UDim.new(1, 0),
				onActivated = t3.onBuyActivated or function() -- line: 150
				end
			})
		})
	})
end

return React.memo(RobuxPackageTile)
