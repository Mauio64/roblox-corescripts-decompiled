local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local SharedFlags = require(parent2.SharedFlags)

local Foundation = require(parent2.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local ButtonGroup = Foundation.ButtonGroup
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local Orientation = Foundation.Enums.Orientation
local Sheet = Foundation.Sheet
local useScaledValue = Foundation.Hooks.useScaledValue
local Enums = Foundation.Enums
local getIconRichText = Foundation.Utility.getIconRichText

local LocalizationService = game:GetService("LocalizationService")
local AppLocales = require(parent2.AppLocales)
local Localization = AppLocales.Localization
local Localization2 = require(parent2.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local useLocalization = Localization2.Hooks.useLocalization

local UnifiedProductDetails = require(parent.Generic.UnifiedProductDetails)
local YellowBadge = require(parent.Generic.YellowBadge)
local GrayBadge = require(parent.Generic.GrayBadge)
local PriceSummary = require(parent.Generic.PriceSummary)
local UnifiedPurchaseModalHeader = require(parent.Generic.UnifiedPurchaseModalHeader)
local ProductDetailsContainer = require(parent.Generic.ProductDetailsContainer)
local CartPricingLoading = require(parent.ProductPurchase.v4.CartPricingLoading)
local buildCartPricingOfferCheckboxes = require(parent.ProductPurchase.v4.buildCartPricingOfferCheckboxes)
local useCartPricing = require(parent.ProductPurchase.v4.useCartPricing)

local useInitialButtonDisableDelay = require(parent.Generic.Hooks.useInitialButtonDisableDelay)
local useFocusNavigationRefs = require(parent.Generic.Hooks.useFocusNavigationRefs)

local UnifiedPurchaseModalTypeEnum = require(parent.Enums.UnifiedPurchaseModalTypeEnum)
require(parent.ProductPurchase.v4.cartPricingResponseLineItem)

local formatNumber = require(parent.Utility.formatNumber)
local getUpsellBadgeInfo = require(parent.Utility.getUpsellBadgeInfo)

local Constants = require(parent.Generic.Constants)

local UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_SINGLE_PACKAGE = Constants.UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_SINGLE_PACKAGE

local UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_DEFAULT = Constants.UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_DEFAULT

local UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES = Constants.UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES

local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird

local FFlagEnableRobuxUpsellPlusButtonExperiment = require(parent.Flags.FFlagEnableRobuxUpsellPlusButtonExperiment)

local SharedFlags2 = require(parent.Parent.SharedFlags)
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = SharedFlags2.FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local defineFastInt = game:DefineFastInt("CompactUpsellModalBreakpoint", 400)

local SharedFlags3 = require(parent.Parent.SharedFlags)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = SharedFlags3.FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagShouldFixDevSubsFlashingTitle = require(parent.Flags.FFlagShouldFixDevSubsFlashingTitle)

local GetFFlagIAPExperienceEnableMultiDisplayUpsell = require(parent.Flags.GetFFlagIAPExperienceEnableMultiDisplayUpsell)

local GetFFlagIAPExperienceUseUpsellBadgeHelper = require(parent.Flags.GetFFlagIAPExperienceUseUpsellBadgeHelper)
local FFlagFixUpsellModalUnevenLayout = require(parent.Flags.FFlagFixUpsellModalUnevenLayout)

local SharedFlags4 = require(parent.Parent.SharedFlags)
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags4.FFlagLuaAppsEnablePromptVIPServerPurchase

require(parent.Api.PaymentsGateway.GetUpsellSuggestionsTypes)
local BadgeType = require(parent.Enums.BadgeType)
require(parent.Enums.VirtualItemBadgeType)
require(parent.ProductPurchase.PricingTypes)

local function UpsellProductDetailsLegacyImpl(props, p)
	local text

	if props.badgeType == BadgeType.Popular then
		text = p.Popular
	elseif props.badgeType == BadgeType.LastPurchased then
		text = p.LastPurchased
	end

	local icon = props.badgeType == BadgeType.Popular and "icons/menu/fire_fill" or nil

	local v = "size-full-1400 radius-medium padding-x-large row"
	local tag

	if props.selected then
		tag = v .. " bg-surface-200 stroke-system-contrast stroke-thick"
	else
		tag = v .. " bg-surface-300 stroke-emphasis stroke-standard"
	end

	local tag2 = props.isCompact and "auto-xy text-title-small content-emphasis text-align-x-left"
		or "auto-xy text-title-large content-emphasis text-align-x-left"

	local tag3 = props.isCompact and "auto-xy text-title-small content-muted text-align-x-left"
		or "auto-xy text-title-large content-muted text-align-x-left"

	local tag4 = props.isCompact and "auto-xy text-title-small content-emphasis text-align-x-right"
		or "auto-xy text-title-large content-emphasis text-align-x-right"

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.layoutOrder,
		onActivated = props.onSelected,
		tag = tag,
		Size = 0
	}
	local size

	if props.isCompact then
		size = UDim2.new(1, 0, 0, 40)
	end

	v2.Size = size
	local v3 = {
		LeftSide = React.createElement(View, {
			LayoutOrder = 1,
			tag = { ["row align-y-center gap-small"] = true, ["align-x-start"] = true },
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			RobuxAmount = React.createElement(Text, {
				LayoutOrder = 1,
				Text = utf8.char(57346) .. " " .. formatNumber(
					LocalizationService.RobloxLocaleId,
					props.product.robuxAmount
				),
				tag = tag2
			}),
			RobuxAmountBonus = props.product.robuxAmountBeforeBonus and React.createElement(Text, {
				LayoutOrder = 2,
				RichText = true,
				Text = "<s>" .. utf8.char(57346) .. formatNumber(
					LocalizationService.RobloxLocaleId,
					props.product.robuxAmountBeforeBonus
				) .. "</s>",
				tag = tag3
			})
		}),
		RightSide = 0
	}

	local createElement2 = React.createElement
	local v4 = {
		LayoutOrder = 2,
		tag = "row align-x-right align-y-center gap-large",
		Size = UDim2.new(0.5, 0, 1, 0)
	}
	local badge

	if text then
		badge = React.createElement(YellowBadge, { LayoutOrder = 1, Text = text, Icon = icon })
	end

	v3.RightSide = createElement2(View, v4, {
		Badge = badge,
		RobuxPrice = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.product.price or "",
			tag = tag4
		})
	})
	return createElement(View, v2, v3)
end

local function UpsellProductDetailsMultiDisplayFixedImpl(props, props2)
	local text, iconName

	if GetFFlagIAPExperienceUseUpsellBadgeHelper() then
		local upsellBadgeInfo = getUpsellBadgeInfo(props.badgeType, props2)
		text = upsellBadgeInfo.text
		iconName = upsellBadgeInfo.icon
	else
		if props.badgeType == BadgeType.Popular then
			text = props2.Popular
		elseif props.badgeType == BadgeType.LastPurchased then
			text = props2.LastPurchased
		elseif props.badgeType == BadgeType.ForYou then
			text = props2.ForYouItem
		elseif props.badgeType == BadgeType.BetterValue then
			text = props2.BetterValue
		end

		if props.badgeType == BadgeType.Popular then
			iconName = Enums.IconName.Flame
		elseif props.badgeType == BadgeType.ForYou then
			iconName = Enums.IconName.CircleStar
		elseif props.badgeType == BadgeType.BetterValue then
			iconName = Enums.IconName.Tag
		end
	end

	local v = props.isCompact and "size-full-1000 radius-medium padding-small row"
		or "size-full-1400 radius-medium padding-x-large row"
	local tag

	if props.selected then
		tag = v .. " bg-surface-200 stroke-system-contrast stroke-thick"
	else
		tag = v .. " bg-surface-300 stroke-default stroke-standard"
	end

	local tag2 = props.isCompact and "auto-xy text-title-small content-emphasis text-align-x-left"
		or "auto-xy text-heading-small content-emphasis text-align-x-left"

	local tag3 = props.isCompact and "auto-xy text-title-small content-muted text-align-x-left"
		or "auto-xy text-title-medium content-muted text-align-x-left"

	local tag4 = props.isCompact and "auto-xy text-title-small content-emphasis text-align-x-right"
		or "auto-xy text-title-large content-emphasis text-align-x-right"

	local createElement = React.createElement
	local v2 = { LayoutOrder = props.layoutOrder, onActivated = props.onSelected, tag = tag }

	local createElement2 = React.createElement
	local v3 = {
		LayoutOrder = 1,
		tag = "row align-x-left align-y-center gap-small",
		Size = UDim2.new(0.5, 0, 1, 0)
	}
	local v4 = {
		RobuxAmount = React.createElement(Text, {
			LayoutOrder = 1,
			RichText = true,
			Text = getIconRichText(Enums.IconName.Robux) .. " " .. formatNumber(
				LocalizationService.RobloxLocaleId,
				props.product.robuxAmount
			),
			tag = tag2
		}),
		RobuxAmountBonus = props.product.robuxAmountBeforeBonus and React.createElement(Text, {
			LayoutOrder = 2,
			RichText = true,
			Text = "<s>" .. getIconRichText(Enums.IconName.Robux) .. formatNumber(
				LocalizationService.RobloxLocaleId,
				props.product.robuxAmountBeforeBonus
			) .. "</s>",
			tag = tag3
		}),
		Badge = 0
	}
	local badge

	if text then
		badge = React.createElement(GrayBadge, { LayoutOrder = 3, Text = text, iconName = iconName })
	end

	v4.Badge = badge
	return createElement(View, v2, {
		LeftSide = createElement2(View, v3, v4),
		RightSide = React.createElement(
			View,
			{
				LayoutOrder = 2,
				tag = "row align-x-right align-y-center gap-large",
				Size = UDim2.new(0.5, 0, 1, 0)
			},
			{
				RobuxPrice = React.createElement(Text, {
					LayoutOrder = 1,
					Text = props.product.price or "",
					tag = tag4
				})
			}
		)
	})
end

local function UpsellProductDetailsMultiDisplayImpl(props, props2)
	local text, iconName

	if GetFFlagIAPExperienceUseUpsellBadgeHelper() then
		local upsellBadgeInfo = getUpsellBadgeInfo(props.badgeType, props2)
		text = upsellBadgeInfo.text
		iconName = upsellBadgeInfo.icon
	else
		if props.badgeType == BadgeType.Popular then
			text = props2.Popular
		elseif props.badgeType == BadgeType.LastPurchased then
			text = props2.LastPurchased
		elseif props.badgeType == BadgeType.ForYou then
			text = props2.ForYouItem
		elseif props.badgeType == BadgeType.BetterValue then
			text = props2.BetterValue
		end

		if props.badgeType == BadgeType.Popular then
			iconName = Enums.IconName.Flame
		elseif props.badgeType == BadgeType.ForYou then
			iconName = Enums.IconName.CircleStar
		elseif props.badgeType == BadgeType.BetterValue then
			iconName = Enums.IconName.Tag
		end
	end

	local v = props.isCompact and "size-full-0 auto-y radius-medium padding-small row"
		or "col align-x-left gap-medium size-full-0 auto-y padding-medium radius-medium"
	local tag

	if props.selected then
		tag = v .. " bg-surface-200 stroke-system-contrast stroke-thick"
	else
		tag = v .. " bg-surface-300 stroke-default stroke-standard"
	end

	local tag2 = props.isCompact and "auto-xy text-title-small content-emphasis text-align-x-left"
		or "auto-xy text-heading-small content-emphasis text-align-x-left"

	local tag3 = props.isCompact and "auto-xy text-title-small content-muted text-align-x-left"
		or "auto-xy text-title-medium content-muted text-align-x-left"

	local tag4 = props.isCompact and "auto-xy text-title-small content-emphasis text-align-x-right"
		or "auto-xy text-title-large content-emphasis text-align-x-right"

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.layoutOrder,
		onActivated = props.onSelected,
		tag = tag,
		Size = 0
	}
	local size

	if props.isCompact then
		size = UDim2.new(1, 0, 0, 40)
	end

	v2.Size = size

	local createElement2 = React.createElement
	local v3 = {
		LayoutOrder = 1,
		tag = {
			["row align-x-left align-y-center gap-small"] = true,
			["size-full-0 auto-y"] = not props.isCompact
		},
		Size = 0
	}
	local size2

	if props.isCompact then
		size2 = UDim2.new(0.65, 0, 1, 0)
	end

	v3.Size = size2
	local v4 = {
		RobuxAmount = React.createElement(Text, {
			LayoutOrder = 1,
			RichText = true,
			Text = getIconRichText(Enums.IconName.Robux) .. " " .. formatNumber(
				LocalizationService.RobloxLocaleId,
				props.product.robuxAmount
			),
			tag = tag2
		}),
		RobuxAmountBonus = props.product.robuxAmountBeforeBonus and React.createElement(Text, {
			LayoutOrder = 2,
			RichText = true,
			Text = "<s>" .. getIconRichText(Enums.IconName.Robux) .. formatNumber(
				LocalizationService.RobloxLocaleId,
				props.product.robuxAmountBeforeBonus
			) .. "</s>",
			tag = tag3
		}),
		Badge = 0
	}
	local badge

	if text then
		badge = React.createElement(GrayBadge, { LayoutOrder = 3, Text = text, iconName = iconName })
	end

	v4.Badge = badge
	local children = { LeftSide = createElement2(View, v3, v4), RightSide = 0 }

	local createElement3 = React.createElement
	local v5 = {
		LayoutOrder = 2,
		tag = {
			["row align-x-right align-y-center gap-large"] = true,
			["size-full-0 auto-y"] = not props.isCompact
		},
		Size = 0
	}
	local size3

	if props.isCompact then
		size3 = UDim2.new(0.35, 0, 1, 0)
	end

	v5.Size = size3
	children.RightSide = createElement3(View, v5, {
		RobuxPrice = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.product.price or "",
			tag = tag4
		})
	})
	return createElement(View, v2, children)
end

local function UpsellProductDetails(p)
	local v = useLocalization({
		Popular = "IAPExperience.RobuxUpsell.Text.PopularItem",
		LastPurchased = "IAPExperience.RobuxUpsell.Text.LastPurchased",
		ForYouItem = "IAPExperience.RobuxUpsell.Text.ForYou",
		BetterValue = "IAPExperience.RobuxUpsell.Text.BetterValue",
		BestValue = "IAPExperience.RobuxUpsell.Text.BestValue"
	})

	if not GetFFlagIAPExperienceEnableMultiDisplayUpsell() then
		return UpsellProductDetailsLegacyImpl(p, v)
	end

	if FFlagFixUpsellModalUnevenLayout then
		return UpsellProductDetailsMultiDisplayFixedImpl(p, v)
	end

	return UpsellProductDetailsMultiDisplayImpl(p, v)
end

local function resolveRobloxPlusCta(p)
	local robloxPlusDiscountPercentage = p.robloxPlusDiscountPercentage

	if type(robloxPlusDiscountPercentage) == "number" then
		return robloxPlusDiscountPercentage, p.onRobloxPlusButtonActivated
	end

	return nil, nil
end

local function UnifiedRobuxUpsellModal(props)
	local robloxPlusDiscountPercentage, onRobloxPlusButtonActivated

	if FFlagEnableRobuxUpsellPlusButtonExperiment then
		robloxPlusDiscountPercentage = props.robloxPlusDiscountPercentage

		if type(robloxPlusDiscountPercentage) == "number" then
			onRobloxPlusButtonActivated = props.onRobloxPlusButtonActivated
		else
			robloxPlusDiscountPercentage = nil
		end
	end

	local cartPricing = useCartPricing({
		product = props.product,
		purchaseModalType = props.purchaseModalType,
		cartPricingResponse = props.cartPricingResponse,
		onCartOfferAppliedChanged = props.onCartOfferAppliedChanged
	})

	local product = React.useMemo(function()
		if cartPricing.showCartOfferUi then
			return cartPricing.mergedProductForDetails
		end

		return props.product
	end, { props.product, cartPricing.showCartOfferUi, cartPricing.mergedProductForDetails })

	local v = useLocalization({
		Buy = "IAPExperience.PurchasePrompt.Action.Buy",
		GetTenPercentOff = robloxPlusDiscountPercentage ~= nil and {
			"IAPExperience.RobuxUpsell.Action.GetPercentOff",
			discountPercentage = robloxPlusDiscountPercentage
		} or nil,
		Subscribe = FFlagEnableUnifiedPurchaseFlowForDevSubs and "Feature.Subscription.Action.Subscribe" or nil,
		DisclosurePayment = "IAPExperience.RobuxUpsell.Text.DisclosurePayment",
		DisclosureTermsURL = "IAPExperience.RobuxUpsell.Text.DisclosureTermsURL",
		TermsOfUse = "IAPExperience.RobuxUpsell.Text.TermsOfUse",
		BuyRobuxAndExperience = "IAPExperience.PurchasePrompt.BuyRobuxAndExperience",
		BuyRobuxAndItem = "IAPExperience.PurchasePrompt.Title.BuyRobuxAndItem",
		BuyRobuxAndItems = "IAPExperience.PurchasePrompt.Title.BuyRobuxAndItems",
		BuyRobuxOnly = FFlagAXMISWithBlackbird and "IAPExperience.PurchasePrompt.Title.BuyRobuxOnly" or nil,
		BuyRobuxAndAvatar = FFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "IAPExperience.PurchasePrompt.Header.BuyRobuxAndAvatar" or nil,
		BuyRobuxAndSubscription = FFlagEnableUnifiedPurchaseFlowForDevSubs and "IAPExperience.PurchasePrompt.BuyRobuxAndSubscription" or nil,
		PerMonth = (FFlagEnableUnifiedPurchaseFlowForDevSubs or FFlagLuaAppsEnablePromptVIPServerPurchase) and "Feature.Subscription.Text.PerMonth" or nil
	})
	local isCompact

	if
		FFlagEnableUnifiedPurchaseFlowForDevSubs
		and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	then
		if props.screenSize.Y > 0 then
			isCompact = props.screenSize.Y < defineFastInt
		else
			isCompact = false
		end
	else
		isCompact = props.screenSize.Y < defineFastInt
	end

	local isDisabled = useInitialButtonDisableDelay(false)

	local state, setState = React.useState(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_DEFAULT)

	React.useEffect(function()
		if GetFFlagIAPExperienceEnableMultiDisplayUpsell() and not FFlagFixUpsellModalUnevenLayout then
			if
				FFlagEnableUnifiedPurchaseFlowForDevSubs
				and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
			then
				setState(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES)
				return
			end

			local count = #props.upsellSuggestions

			if count == 1 then
				setState(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_SINGLE_PACKAGE)
			elseif count == 2 then
				setState(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_DEFAULT)
			else
				setState(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES)
			end
		else
			if #props.upsellSuggestions > 1 then
				setState(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES)
			end

			if
				FFlagEnableUnifiedPurchaseFlowForDevSubs
				and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
			then
				setState(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES)
			end
		end
	end, { props.upsellSuggestions, props.purchaseModalType })

	local centerSheetHeight = useScaledValue(state or 0)

	local state2, setState2 = React.useState(v.BuyRobuxAndItem)
	local useEffect = React.useEffect
	local function fn()
		local purchaseModalType = props.purchaseModalType

		if
			FFlagEnableUnifiedPurchaseFlowForDevSubs
			and purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
		then
			local v2 = v.BuyRobuxAndItem

			if FFlagShouldFixDevSubsFlashingTitle and v.BuyRobuxAndSubscription and v.BuyRobuxAndSubscription ~= "" then
				v2 = v.BuyRobuxAndSubscription
			end

			setState2(v2)
		elseif purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
			if FFlagAXMISWithBlackbird then
				if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements and props.product.itemName ~= "RobuxUpsell" then
					setState2(v.BuyRobuxAndAvatar)
				else
					setState2(v.BuyRobuxOnly)
				end
			elseif FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
				setState2(v.BuyRobuxAndAvatar)
			else
				setState2(v.BuyRobuxAndItems)
			end
		elseif purchaseModalType == UnifiedPurchaseModalTypeEnum.Experience then
			setState2(v.BuyRobuxAndExperience)
		else
			setState2(v.BuyRobuxAndItem)
		end
	end

	local purchaseModalType = props.purchaseModalType
	local buyRobuxAndAvatar = v.BuyRobuxAndAvatar
	local buyRobuxAndExperience = v.BuyRobuxAndExperience
	local buyRobuxAndItem = v.BuyRobuxAndItem
	local buyRobuxAndItems = v.BuyRobuxAndItems
	local buyRobuxAndSubscription = v.BuyRobuxAndSubscription
	local itemName

	if FFlagAXMISWithBlackbird then
		itemName = props.product.itemName
	end

	local v2

	if FFlagAXMISWithBlackbird then
		v2 = v.BuyRobuxOnly
	end

	useEffect(fn, {
		purchaseModalType,
		buyRobuxAndAvatar,
		buyRobuxAndExperience,
		buyRobuxAndItem,
		buyRobuxAndItems,
		buyRobuxAndSubscription,
		itemName,
		v2
	})

	local ref, ref2 = useFocusNavigationRefs(props.buttons.cancelPurchaseActivated, props.onBuyItemButtonMounted)

	React.useEffect(function() end, { props.upsellSuggestions })

	local v3 = string.split(v.DisclosureTermsURL, " {termsofuse} ")
	local text = v.TermsOfUse

	if props.termsOfUseActivated then
		text = "<u>" .. text .. "</u>"
	end

	local v4 = FFlagEnableUnifiedPurchaseFlowForDevSubs
		and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	local perMonth

	if v4 then
		perMonth = v.PerMonth
	elseif FFlagLuaAppsEnablePromptVIPServerPurchase and props.isMonthlyPrice then
		perMonth = v.PerMonth
	end

	local text2 = if v4 then v.Subscribe else v.Buy

	local cartPricingOfferCheckboxes = buildCartPricingOfferCheckboxes({
		cartPricing = cartPricing,
		isDisabled = props.isCartPricingLoading == true or isDisabled
	})
	local postPurchaseActions

	if next(cartPricingOfferCheckboxes) then
		postPurchaseActions = React.createElement(
			View,
			{ tag = "col gap-medium size-full-0 auto-y", LayoutOrder = 3 },
			cartPricingOfferCheckboxes
		)
	end

	local createElement = React.createElement
	local v5 = {
		purchaseModalType = props.purchaseModalType,
		product = product,
		isCompact = isCompact,
		model = product.model,
		priceSuffix = perMonth,
		includePriceSuffixOnOriginal = 0,
		hideDiscountSummary = 0,
		savingsSummary = 0
	}
	local includePriceSuffixOnOriginal

	if FFlagLuaAppsEnablePromptVIPServerPurchase then
		includePriceSuffixOnOriginal = props.isMonthlyPrice
	end

	v5.includePriceSuffixOnOriginal = includePriceSuffixOnOriginal
	v5.hideDiscountSummary = props.isCartPricingLoading
	v5.savingsSummary = cartPricing.cartPricingSavingsSummary
	local productDetailsContainer = createElement(ProductDetailsContainer, v5)

	local fFlagIAPExperienceEnableMultiDisplayUpsell = GetFFlagIAPExperienceEnableMultiDisplayUpsell()
	local size = isCompact and "Small" or fFlagIAPExperienceEnableMultiDisplayUpsell and "Medium" or nil
	local v6 = {
		LayoutOrder = 1,
		text = text2,
		onActivated = props.buttons.buyItemActivated,
		inputDelay = props.buttons.buyItemEnableInputDelayed and not isDisabled and 2.5 or 0,
		isDisabled = isDisabled,
		ref = ref2,
		fillBehavior = FillBehavior.Fill,
		variant = ButtonVariant.Emphasis,
		size = size
	}
	local tag = fFlagIAPExperienceEnableMultiDisplayUpsell
		and "col align-x-center align-y-center gap-medium size-full-0 auto-y"
		or "col gap-medium auto-y size-full-0 align-x-center align-y-center"
	local createElement2 = React.createElement
	local root = Sheet.Root
	local v7 = {
		onClose = props.buttons.cancelPurchaseActivated,
		snapPoints = { centerSheetHeight, 0.8 },
		centerSheetHeight = 0,
		preferCenterSheet = true,
		ref = 0
	}

	if FFlagFixUpsellModalUnevenLayout then
		centerSheetHeight = nil
	elseif not fFlagIAPExperienceEnableMultiDisplayUpsell then
		centerSheetHeight = nil
	end

	v7.centerSheetHeight = centerSheetHeight

	if isDisabled then
		ref = nil
	end

	v7.ref = ref

	local createElement3 = React.createElement
	local header = Sheet.Header
	local hasCloseAffordance

	if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
		hasCloseAffordance = props.hideUserRobuxBalance and true or nil
	end

	local createElement4 = React.createElement
	local v8 = {
		titleText = state2,
		robuxBalanceAmount = props.userBalance,
		hideUserRobuxBalance = 0
	}
	local hideUserRobuxBalance

	if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
		hideUserRobuxBalance = props.hideUserRobuxBalance
	end

	v8.hideUserRobuxBalance = hideUserRobuxBalance
	local children = {
		Header = createElement3(header, { hasCloseAffordance = hasCloseAffordance }, {
			ModalHeader = createElement4(UnifiedPurchaseModalHeader, v8)
		}),
		Content = 0,
		Actions = 0
	}

	local createElement5 = React.createElement
	local content = Sheet.Content

	local v9 = { SheetContentContainer = 0 }
	local createElement6 = React.createElement

	if not productDetailsContainer then
		local createElement7 = React.createElement
		local productDetails

		if props.purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
			productDetails = React.createElement(PriceSummary, {
				amount = props.product.itemRobuxCost
			})
		else
			local createElement8 = React.createElement
			local v10 = {
				isPortrait = false,
				isCompact = isCompact,
				itemIcon = product.itemIcon,
				itemName = product.itemName,
				itemRobuxCost = product.itemRobuxCost,
				model = product.model,
				priceSuffix = perMonth,
				includePriceSuffixOnOriginal = 0
			}
			local includePriceSuffixOnOriginal2

			if FFlagLuaAppsEnablePromptVIPServerPurchase then
				includePriceSuffixOnOriginal2 = props.isMonthlyPrice
			end

			v10.includePriceSuffixOnOriginal = includePriceSuffixOnOriginal2
			productDetails = createElement8(UnifiedProductDetails, v10)
		end

		productDetailsContainer = createElement7(View, { tag = tag, LayoutOrder = 1 }, {
			ProductDetails = productDetails
		})
	end

	local children2 = {
		ProductDetailsContainer = productDetailsContainer,
		CartPricingLoading = React.createElement(CartPricingLoading, {
			isLoading = props.isCartPricingLoading,
			LayoutOrder = 1
		}),
		PostPurchaseActions = postPurchaseActions,
		UpsellSuggestions = 0
	}

	local createElement7 = React.createElement
	local children3

	local function fn2(i: number) -- 3 equivalent calls inferred from this helper
		props.onUpsellSuggestionsSelected(i)
	end

	if fFlagIAPExperienceEnableMultiDisplayUpsell then
		children3 = {}

		for i, upsellSuggestion in ipairs(props.upsellSuggestions) do
			children3["UpsellPackage" .. tostring(i)] = React.createElement(UpsellProductDetails, {
				layoutOrder = i,
				product = upsellSuggestion,
				selected = props.selectedUpsellIndex == i,
				isCompact = isCompact,
				onSelected = function()
					fn2(i) -- inferred equivalent call
				end,
				badgeType = upsellSuggestion.badgeType
			})
		end
	else
		children3 = {
			UpsellPackage1 = React.createElement(UpsellProductDetails, {
				layoutOrder = 1,
				product = props.upsellSuggestions[1],
				selected = props.selectedUpsellIndex == 1,
				isCompact = isCompact,
				onSelected = function()
					fn2(1) -- inferred equivalent call
				end
			}),
			UpsellPackage2 = 0
		}
		local upsellPackage

		if #props.upsellSuggestions > 1 then
			upsellPackage = React.createElement(UpsellProductDetails, {
				layoutOrder = 2,
				product = props.upsellSuggestions[2],
				selected = props.selectedUpsellIndex == 2,
				isCompact = isCompact,
				onSelected = function()
					fn2(2) -- inferred equivalent call
				end,
				badgeType = props.upsellSuggestions[2].badgeType
			})
		end

		children3.UpsellPackage2 = upsellPackage
	end

	children2.UpsellSuggestions = createElement7(View, {
		LayoutOrder = 2,
		tag = fFlagIAPExperienceEnableMultiDisplayUpsell and "col align-x-center align-y-start gap-medium size-full-0 auto-y padding-x-xsmall" or "col gap-medium auto-y size-full-0 align-x-center align-y-center padding-x-xsmall padding-y-small padding-bottom-xxlarge"
	}, children3)
	v9.SheetContentContainer = createElement6(View, {
		tag = fFlagIAPExperienceEnableMultiDisplayUpsell and "col align-x-center align-y-start gap-medium size-full-0 auto-y" or "col gap-medium auto-y size-full-0 align-x-center align-y-start"
	}, children2)
	children.Content = createElement5(content, { LayoutOrder = 2 }, v9)

	local createElement8 = React.createElement
	local actions = Sheet.Actions

	local createElement9 = React.createElement
	local buyAndPlusRow

	if onRobloxPlusButtonActivated then
		buyAndPlusRow = React.createElement(ButtonGroup, {
			LayoutOrder = 1,
			orientation = Orientation.Vertical,
			size = size,
			buttons = {
				{
					text = v6.text,
					onActivated = v6.onActivated,
					inputDelay = v6.inputDelay,
					isDisabled = v6.isDisabled,
					ref = v6.ref,
					variant = v6.variant
				},
				{
					text = v.GetTenPercentOff,
					onActivated = onRobloxPlusButtonActivated,
					isDisabled = isDisabled,
					variant = ButtonVariant.Standard,
					icon = Enums.IconName.RobloxPlus
				}
			}
		})
	else
		buyAndPlusRow = React.createElement(Foundation.Button, v6)
	end

	children.Actions = createElement8(actions, { LayoutOrder = 3 }, { createElement9(View, {
			LayoutOrder = 1,
			tag = onRobloxPlusButtonActivated and "col gap-small size-full-0 auto-y" or fFlagIAPExperienceEnableMultiDisplayUpsell and "row wrap align-x-center align-y-center gap-medium size-full-0 auto-y" or "row wrap auto-xy align-y-center align-x-center size-full-0 gap-medium"
		}, {
			BuyAndPlusRow = buyAndPlusRow,
			DisclosureTerms = React.createElement(View, {
				LayoutOrder = 2,
				tag = fFlagIAPExperienceEnableMultiDisplayUpsell and "row wrap align-x-left align-y-center gap-xxsmall size-full-0 auto-y" or "row wrap auto-y align-y-center align-x-center size-full-0 gap-xxsmall"
			}, {
				DisclosurePayment = React.createElement(Text, {
					LayoutOrder = 1,
					Text = v.DisclosurePayment,
					tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small"
				}),
				BeforeText = React.createElement(Text, {
					LayoutOrder = 2,
					Text = v3[1],
					tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small"
				}),
				TextLink = React.createElement(Text, {
					LayoutOrder = 3,
					RichText = true,
					Text = text,
					tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small",
					onActivated = props.termsOfUseActivated
				}),
				AfterText = React.createElement(Text, {
					LayoutOrder = 4,
					Text = v3[2],
					tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small"
				})
			})
		}) })
	return createElement2(root, v7, children)
end

local function UnifiedRobuxUpsellModalContainer(p)
	return React.createElement(
		LocalizationProvider,
		{
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			UnifiedRobuxUpsellModal = React.createElement(UnifiedRobuxUpsellModal, p)
		}
	)
end

return UnifiedRobuxUpsellModalContainer
