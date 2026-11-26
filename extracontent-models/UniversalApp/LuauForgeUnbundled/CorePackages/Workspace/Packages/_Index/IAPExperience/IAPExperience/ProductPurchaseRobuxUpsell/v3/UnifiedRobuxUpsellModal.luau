local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local view = Foundation.View
local text = Foundation.Text
local buttonGroup = Foundation.ButtonGroup
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local orientation = Foundation.Enums.Orientation
local sheet = Foundation.Sheet
local useScaledValue = Foundation.Hooks.useScaledValue
local enums = Foundation.Enums
local getIconRichText = Foundation.Utility.getIconRichText

local LocalizationService = game:GetService("LocalizationService")
local localization = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/AppLocales").Localization
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization")
local localizationProvider = Localization.LocalizationProvider
local useLocalization = Localization.Hooks.useLocalization

local UnifiedProductDetails = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/UnifiedProductDetails")
local YellowBadge = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/YellowBadge")
local GrayBadge = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/GrayBadge")
local PriceSummary = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/PriceSummary")
local UnifiedPurchaseModalHeader = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/UnifiedPurchaseModalHeader")
local module10 = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/ProductDetailsContainer")
local module11 = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/CartPricingLoading")
local buildCartPricingOfferCheckboxes = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/buildCartPricingOfferCheckboxes")
local useCartPricing = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/useCartPricing")

local useInitialButtonDisableDelay = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Hooks/useInitialButtonDisableDelay")
local useFocusNavigationRefs = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Hooks/useFocusNavigationRefs")

local UnifiedPurchaseModalTypeEnum = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/UnifiedPurchaseModalTypeEnum")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/cartPricingResponseLineItem")

local formatNumber = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/formatNumber")
local getUpsellBadgeInfo = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/getUpsellBadgeInfo")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Constants")

local UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_SINGLE_PACKAGE = Constants.UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_SINGLE_PACKAGE

local UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_DEFAULT = Constants.UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_DEFAULT

local UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES = Constants.UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES

local fFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird

local FFlagEnableRobuxUpsellPlusButtonExperiment = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagEnableRobuxUpsellPlusButtonExperiment")

local fFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local defineFastInt = game:DefineFastInt("CompactUpsellModalBreakpoint", 400)

local fFlagEnableUnifiedPurchaseFlowForDevSubs = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagShouldFixDevSubsFlashingTitle = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagShouldFixDevSubsFlashingTitle")

local GetFFlagIAPExperienceEnableMultiDisplayUpsell = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/GetFFlagIAPExperienceEnableMultiDisplayUpsell")

local GetFFlagIAPExperienceUseUpsellBadgeHelper = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/GetFFlagIAPExperienceUseUpsellBadgeHelper")
local FFlagFixUpsellModalUnevenLayout = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagFixUpsellModalUnevenLayout")

local fFlagLuaAppsEnablePromptVIPServerPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagLuaAppsEnablePromptVIPServerPurchase

require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Api/PaymentsGateway/GetUpsellSuggestionsTypes")
local BadgeType = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/BadgeType")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/VirtualItemBadgeType")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/PricingTypes")

local function UpsellProductDetailsLegacyImpl(props, p2)
	local v5

	if props.badgeType == BadgeType.Popular then
		v5 = p2.Popular
	elseif props.badgeType == BadgeType.LastPurchased then
		v5 = p2.LastPurchased
	end

	local v6 = props.badgeType == BadgeType.Popular and "icons/menu/fire_fill" or nil

	local v7 = "size-full-1400 radius-medium padding-x-large row"
	local v8

	if props.selected then
		v8 = v7 .. " bg-surface-200 stroke-system-contrast stroke-thick"
	else
		v8 = v7 .. " bg-surface-300 stroke-emphasis stroke-standard"
	end

	local v9 = props.isCompact and "auto-xy text-title-small content-emphasis text-align-x-left"
		or "auto-xy text-title-large content-emphasis text-align-x-left"

	local v10 = props.isCompact and "auto-xy text-title-small content-muted text-align-x-left"
		or "auto-xy text-title-large content-muted text-align-x-left"

	local v11 = props.isCompact and "auto-xy text-title-small content-emphasis text-align-x-right"
		or "auto-xy text-title-large content-emphasis text-align-x-right"

	local createElement = React.createElement
	local v13 = {
		LayoutOrder = props.layoutOrder,
		onActivated = props.onSelected,
		tag = v8,
		Size = 0
	}

	local v14 = if props.isCompact then UDim2.new(1, 0, 0, 40) else nil
	v13.Size = v14
	local v15 = {
		LeftSide = React.createElement(view, {
			LayoutOrder = 1,
			tag = { ["row align-y-center gap-small"] = true, ["align-x-start"] = true },
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			RobuxAmount = React.createElement(text, {
				LayoutOrder = 1,
				Text = utf8.char(57346) .. " " .. formatNumber(
					LocalizationService.RobloxLocaleId,
					props.product.robuxAmount
				),
				tag = v9
			}),
			RobuxAmountBonus = props.product.robuxAmountBeforeBonus and React.createElement(text, {
				LayoutOrder = 2,
				RichText = true,
				Text = "<s>" .. utf8.char(57346) .. formatNumber(
					LocalizationService.RobloxLocaleId,
					props.product.robuxAmountBeforeBonus
				) .. "</s>",
				tag = v10
			})
		}),
		RightSide = 0
	}

	local createElement2 = React.createElement
	local v17 = {
		LayoutOrder = 2,
		tag = "row align-x-right align-y-center gap-large",
		Size = UDim2.new(0.5, 0, 1, 0)
	}

	local v19 = if v5 then React.createElement(YellowBadge, {
		LayoutOrder = 1,
		Text = v5,
		Icon = v6
	}) else nil
	v15.RightSide = createElement2(view, v17, {
		Badge = v19,
		RobuxPrice = React.createElement(text, {
			LayoutOrder = 2,
			Text = props.product.price or "",
			tag = v11
		})
	})
	return createElement(view, v13, v15)
end

local function UpsellProductDetailsMultiDisplayFixedImpl(props, props2)
	local v5, v6

	if GetFFlagIAPExperienceUseUpsellBadgeHelper() then
		local v7 = getUpsellBadgeInfo(props.badgeType, props2)
		v5 = v7.text
		v6 = v7.icon
	else
		if props.badgeType == BadgeType.Popular then
			v5 = props2.Popular
		elseif props.badgeType == BadgeType.LastPurchased then
			v5 = props2.LastPurchased
		elseif props.badgeType == BadgeType.ForYou then
			v5 = props2.ForYouItem
		elseif props.badgeType == BadgeType.BetterValue then
			v5 = props2.BetterValue
		end

		if props.badgeType == BadgeType.Popular then
			v6 = enums.IconName.Flame
		elseif props.badgeType == BadgeType.ForYou then
			v6 = enums.IconName.CircleStar
		elseif props.badgeType == BadgeType.BetterValue then
			v6 = enums.IconName.Tag
		end
	end

	local v7 = props.isCompact and "size-full-1000 radius-medium padding-small row"
		or "size-full-1400 radius-medium padding-x-large row"
	local v8

	if props.selected then
		v8 = v7 .. " bg-surface-200 stroke-system-contrast stroke-thick"
	else
		v8 = v7 .. " bg-surface-300 stroke-default stroke-standard"
	end

	local v9 = props.isCompact and "auto-xy text-title-small content-emphasis text-align-x-left"
		or "auto-xy text-heading-small content-emphasis text-align-x-left"

	local v10 = props.isCompact and "auto-xy text-title-small content-muted text-align-x-left"
		or "auto-xy text-title-medium content-muted text-align-x-left"

	local v11 = props.isCompact and "auto-xy text-title-small content-emphasis text-align-x-right"
		or "auto-xy text-title-large content-emphasis text-align-x-right"

	local createElement = React.createElement
	local v13 = {
		LayoutOrder = props.layoutOrder,
		onActivated = props.onSelected,
		tag = v8
	}

	local createElement2 = React.createElement
	local v15 = {
		LayoutOrder = 1,
		tag = "row align-x-left align-y-center gap-small",
		Size = UDim2.new(0.5, 0, 1, 0)
	}
	local v16 = {
		RobuxAmount = React.createElement(text, {
			LayoutOrder = 1,
			RichText = true,
			Text = getIconRichText(enums.IconName.Robux) .. " " .. formatNumber(
				LocalizationService.RobloxLocaleId,
				props.product.robuxAmount
			),
			tag = v9
		}),
		RobuxAmountBonus = props.product.robuxAmountBeforeBonus and React.createElement(text, {
			LayoutOrder = 2,
			RichText = true,
			Text = "<s>" .. getIconRichText(enums.IconName.Robux) .. formatNumber(
				LocalizationService.RobloxLocaleId,
				props.product.robuxAmountBeforeBonus
			) .. "</s>",
			tag = v10
		}),
		Badge = 0
	}

	local v17 = if v5 then React.createElement(GrayBadge, {
		LayoutOrder = 3,
		Text = v5,
		iconName = v6
	}) else nil
	v16.Badge = v17
	return createElement(view, v13, {
		LeftSide = createElement2(view, v15, v16),
		RightSide = React.createElement(
			view,
			{
				LayoutOrder = 2,
				tag = "row align-x-right align-y-center gap-large",
				Size = UDim2.new(0.5, 0, 1, 0)
			},
			{
				RobuxPrice = React.createElement(text, {
					LayoutOrder = 1,
					Text = props.product.price or "",
					tag = v11
				})
			}
		)
	})
end

local function UpsellProductDetailsMultiDisplayImpl(props, props2)
	local v5, v6

	if GetFFlagIAPExperienceUseUpsellBadgeHelper() then
		local v7 = getUpsellBadgeInfo(props.badgeType, props2)
		v5 = v7.text
		v6 = v7.icon
	else
		if props.badgeType == BadgeType.Popular then
			v5 = props2.Popular
		elseif props.badgeType == BadgeType.LastPurchased then
			v5 = props2.LastPurchased
		elseif props.badgeType == BadgeType.ForYou then
			v5 = props2.ForYouItem
		elseif props.badgeType == BadgeType.BetterValue then
			v5 = props2.BetterValue
		end

		if props.badgeType == BadgeType.Popular then
			v6 = enums.IconName.Flame
		elseif props.badgeType == BadgeType.ForYou then
			v6 = enums.IconName.CircleStar
		elseif props.badgeType == BadgeType.BetterValue then
			v6 = enums.IconName.Tag
		end
	end

	local v7 = props.isCompact and "size-full-0 auto-y radius-medium padding-small row"
		or "col align-x-left gap-medium size-full-0 auto-y padding-medium radius-medium"
	local v8

	if props.selected then
		v8 = v7 .. " bg-surface-200 stroke-system-contrast stroke-thick"
	else
		v8 = v7 .. " bg-surface-300 stroke-default stroke-standard"
	end

	local v9 = props.isCompact and "auto-xy text-title-small content-emphasis text-align-x-left"
		or "auto-xy text-heading-small content-emphasis text-align-x-left"

	local v10 = props.isCompact and "auto-xy text-title-small content-muted text-align-x-left"
		or "auto-xy text-title-medium content-muted text-align-x-left"

	local v11 = props.isCompact and "auto-xy text-title-small content-emphasis text-align-x-right"
		or "auto-xy text-title-large content-emphasis text-align-x-right"

	local createElement = React.createElement
	local v13 = {
		LayoutOrder = props.layoutOrder,
		onActivated = props.onSelected,
		tag = v8,
		Size = 0
	}

	local v14 = if props.isCompact then UDim2.new(1, 0, 0, 40) else nil
	v13.Size = v14

	local createElement2 = React.createElement
	local v16 = {
		LayoutOrder = 1,
		tag = {
			["row align-x-left align-y-center gap-small"] = true,
			["size-full-0 auto-y"] = not props.isCompact
		},
		Size = 0
	}

	local v17 = if props.isCompact then UDim2.new(0.65, 0, 1, 0) else nil
	v16.Size = v17
	local v18 = {
		RobuxAmount = React.createElement(text, {
			LayoutOrder = 1,
			RichText = true,
			Text = getIconRichText(enums.IconName.Robux) .. " " .. formatNumber(
				LocalizationService.RobloxLocaleId,
				props.product.robuxAmount
			),
			tag = v9
		}),
		RobuxAmountBonus = props.product.robuxAmountBeforeBonus and React.createElement(text, {
			LayoutOrder = 2,
			RichText = true,
			Text = "<s>" .. getIconRichText(enums.IconName.Robux) .. formatNumber(
				LocalizationService.RobloxLocaleId,
				props.product.robuxAmountBeforeBonus
			) .. "</s>",
			tag = v10
		}),
		Badge = 0
	}

	local v19 = if v5 then React.createElement(GrayBadge, {
		LayoutOrder = 3,
		Text = v5,
		iconName = v6
	}) else nil
	v18.Badge = v19
	local children = { LeftSide = createElement2(view, v16, v18), RightSide = 0 }

	local createElement3 = React.createElement
	local v21 = {
		LayoutOrder = 2,
		tag = {
			["row align-x-right align-y-center gap-large"] = true,
			["size-full-0 auto-y"] = not props.isCompact
		},
		Size = 0
	}

	local v22 = if props.isCompact then UDim2.new(0.35, 0, 1, 0) else nil
	v21.Size = v22
	children.RightSide = createElement3(view, v21, {
		RobuxPrice = React.createElement(text, {
			LayoutOrder = 1,
			Text = props.product.price or "",
			tag = v11
		})
	})
	return createElement(view, v13, children)
end

local function UpsellProductDetails(p2)
	local v5 = useLocalization({
		Popular = "IAPExperience.RobuxUpsell.Text.PopularItem",
		LastPurchased = "IAPExperience.RobuxUpsell.Text.LastPurchased",
		ForYouItem = "IAPExperience.RobuxUpsell.Text.ForYou",
		BetterValue = "IAPExperience.RobuxUpsell.Text.BetterValue",
		BestValue = "IAPExperience.RobuxUpsell.Text.BestValue"
	})

	if not GetFFlagIAPExperienceEnableMultiDisplayUpsell() then
		return UpsellProductDetailsLegacyImpl(p2, v5)
	end

	if FFlagFixUpsellModalUnevenLayout then
		return UpsellProductDetailsMultiDisplayFixedImpl(p2, v5)
	end

	return UpsellProductDetailsMultiDisplayImpl(p2, v5)
end

local function resolveRobloxPlusCta(p2)
	local robloxPlusDiscountPercentage = p2.robloxPlusDiscountPercentage

	if type(robloxPlusDiscountPercentage) == "number" then
		return robloxPlusDiscountPercentage, p2.onRobloxPlusButtonActivated
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

	local v5 = useCartPricing({
		product = props.product,
		purchaseModalType = props.purchaseModalType,
		cartPricingResponse = props.cartPricingResponse,
		onCartOfferAppliedChanged = props.onCartOfferAppliedChanged
	})

	local v6 = React.useMemo(function()
		if v5.showCartOfferUi then
			return v5.mergedProductForDetails
		end

		return props.product
	end, { props.product, v5.showCartOfferUi, v5.mergedProductForDetails })

	local v7 = useLocalization({
		Buy = "IAPExperience.PurchasePrompt.Action.Buy",
		GetTenPercentOff = robloxPlusDiscountPercentage ~= nil and {
			"IAPExperience.RobuxUpsell.Action.GetPercentOff",
			discountPercentage = robloxPlusDiscountPercentage
		} or nil,
		Subscribe = fFlagEnableUnifiedPurchaseFlowForDevSubs and "Feature.Subscription.Action.Subscribe" or nil,
		DisclosurePayment = "IAPExperience.RobuxUpsell.Text.DisclosurePayment",
		DisclosureTermsURL = "IAPExperience.RobuxUpsell.Text.DisclosureTermsURL",
		TermsOfUse = "IAPExperience.RobuxUpsell.Text.TermsOfUse",
		BuyRobuxAndExperience = "IAPExperience.PurchasePrompt.BuyRobuxAndExperience",
		BuyRobuxAndItem = "IAPExperience.PurchasePrompt.Title.BuyRobuxAndItem",
		BuyRobuxAndItems = "IAPExperience.PurchasePrompt.Title.BuyRobuxAndItems",
		BuyRobuxOnly = fFlagAXMISWithBlackbird and "IAPExperience.PurchasePrompt.Title.BuyRobuxOnly" or nil,
		BuyRobuxAndAvatar = fFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "IAPExperience.PurchasePrompt.Header.BuyRobuxAndAvatar" or nil,
		BuyRobuxAndSubscription = fFlagEnableUnifiedPurchaseFlowForDevSubs and "IAPExperience.PurchasePrompt.BuyRobuxAndSubscription" or nil,
		PerMonth = (fFlagEnableUnifiedPurchaseFlowForDevSubs or fFlagLuaAppsEnablePromptVIPServerPurchase) and "Feature.Subscription.Text.PerMonth" or nil
	})
	local v8

	if
		fFlagEnableUnifiedPurchaseFlowForDevSubs
		and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	then
		v8 = props.screenSize.Y > 0 and props.screenSize.Y < defineFastInt
	else
		v8 = props.screenSize.Y < defineFastInt
	end

	local v9 = useInitialButtonDisableDelay(false)

	local state, setState = React.useState(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_DEFAULT)

	React.useEffect(function()
		if GetFFlagIAPExperienceEnableMultiDisplayUpsell() and not FFlagFixUpsellModalUnevenLayout then
			if
				fFlagEnableUnifiedPurchaseFlowForDevSubs
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
				fFlagEnableUnifiedPurchaseFlowForDevSubs
				and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
			then
				setState(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES)
			end
		end
	end, { props.upsellSuggestions, props.purchaseModalType })

	local v10 = useScaledValue(state or 0)

	local state2, setState2 = React.useState(v7.BuyRobuxAndItem)
	local useEffect = React.useEffect
	local function fn()
		local purchaseModalType = props.purchaseModalType

		if
			fFlagEnableUnifiedPurchaseFlowForDevSubs
			and purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
		then
			local v11 = v7.BuyRobuxAndItem

			if FFlagShouldFixDevSubsFlashingTitle and v7.BuyRobuxAndSubscription and v7.BuyRobuxAndSubscription ~= "" then
				v11 = v7.BuyRobuxAndSubscription
			end

			setState2(v11)
		elseif purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
			if fFlagAXMISWithBlackbird then
				if
					fFlagUnifiedPurchaseFlowMarketplaceUIImprovements
					and props.product.itemName ~= "RobuxUpsell"
				then
					setState2(v7.BuyRobuxAndAvatar)
				else
					setState2(v7.BuyRobuxOnly)
				end
			elseif fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
				setState2(v7.BuyRobuxAndAvatar)
			else
				setState2(v7.BuyRobuxAndItems)
			end
		elseif purchaseModalType == UnifiedPurchaseModalTypeEnum.Experience then
			setState2(v7.BuyRobuxAndExperience)
		else
			setState2(v7.BuyRobuxAndItem)
		end
	end

	local purchaseModalType = props.purchaseModalType
	local buyRobuxAndAvatar = v7.BuyRobuxAndAvatar
	local buyRobuxAndExperience = v7.BuyRobuxAndExperience
	local buyRobuxAndItem = v7.BuyRobuxAndItem
	local buyRobuxAndItems = v7.BuyRobuxAndItems
	local buyRobuxAndSubscription = v7.BuyRobuxAndSubscription
	local itemName = if fFlagAXMISWithBlackbird then props.product.itemName else nil
	local v12 = if fFlagAXMISWithBlackbird then v7.BuyRobuxOnly else nil
	useEffect(fn, {
		purchaseModalType,
		buyRobuxAndAvatar,
		buyRobuxAndExperience,
		buyRobuxAndItem,
		buyRobuxAndItems,
		buyRobuxAndSubscription,
		itemName,
		v12
	})

	local v13, v14 = useFocusNavigationRefs(props.buttons.cancelPurchaseActivated, props.onBuyItemButtonMounted)

	React.useEffect(function() end, { props.upsellSuggestions })

	local v15 = string.split(v7.DisclosureTermsURL, " {termsofuse} ")
	local v16 = v7.TermsOfUse

	if props.termsOfUseActivated then
		v16 = "<u>" .. v16 .. "</u>"
	end

	local v17 = fFlagEnableUnifiedPurchaseFlowForDevSubs
		and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	local perMonth

	if v17 then
		perMonth = v7.PerMonth
	elseif fFlagLuaAppsEnablePromptVIPServerPurchase and props.isMonthlyPrice then
		perMonth = v7.PerMonth
	end

	local v18 = if v17 then v7.Subscribe else v7.Buy

	local v20 = buildCartPricingOfferCheckboxes({
		cartPricing = v5,
		isDisabled = props.isCartPricingLoading == true or v9
	})
	local v21

	if next(v20) then
		v21 = React.createElement(
			view,
			{ tag = "col gap-medium size-full-0 auto-y", LayoutOrder = 3 },
			v20
		)
	end

	local createElement = React.createElement
	local v23 = {
		purchaseModalType = props.purchaseModalType,
		product = v6,
		isCompact = v8,
		model = v6.model,
		priceSuffix = perMonth,
		includePriceSuffixOnOriginal = 0,
		hideDiscountSummary = 0,
		savingsSummary = 0
	}

	local v24 = if fFlagLuaAppsEnablePromptVIPServerPurchase then props.isMonthlyPrice else nil
	v23.includePriceSuffixOnOriginal = v24
	v23.hideDiscountSummary = props.isCartPricingLoading
	v23.savingsSummary = v5.cartPricingSavingsSummary
	local v25 = createElement(module10, v23)

	local v26 = GetFFlagIAPExperienceEnableMultiDisplayUpsell()
	local v31 = v8 and "Small" or v26 and "Medium" or nil
	local v32 = {
		LayoutOrder = 1,
		text = v18,
		onActivated = props.buttons.buyItemActivated,
		inputDelay = props.buttons.buyItemEnableInputDelayed and not v9 and 2.5 or 0,
		isDisabled = v9,
		ref = v14,
		fillBehavior = fillBehavior.Fill,
		variant = buttonVariant.Emphasis,
		size = v31
	}
	local v33 = v26 and "col align-x-center align-y-center gap-medium size-full-0 auto-y"
		or "col gap-medium auto-y size-full-0 align-x-center align-y-center"
	local createElement2 = React.createElement
	local root = sheet.Root
	local v34 = {
		onClose = props.buttons.cancelPurchaseActivated,
		snapPoints = { v10, 0.8 },
		centerSheetHeight = 0,
		preferCenterSheet = true,
		ref = 0
	}

	if FFlagFixUpsellModalUnevenLayout then
		v10 = nil
	elseif not v26 then
		v10 = nil
	end

	v34.centerSheetHeight = v10

	if v9 then
		v13 = nil
	end

	v34.ref = v13

	local createElement3 = React.createElement
	local header = sheet.Header

	local v36 = if fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then props.hideUserRobuxBalance and true or nil else nil

	local createElement4 = React.createElement
	local v39 = {
		titleText = state2,
		robuxBalanceAmount = props.userBalance,
		hideUserRobuxBalance = 0
	}

	local v40 = if fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then props.hideUserRobuxBalance else nil
	v39.hideUserRobuxBalance = v40
	local children = {
		Header = createElement3(header, { hasCloseAffordance = v36 }, {
			ModalHeader = createElement4(UnifiedPurchaseModalHeader, v39)
		}),
		Content = 0,
		Actions = 0
	}

	local createElement5 = React.createElement
	local content = sheet.Content

	local v42 = { SheetContentContainer = 0 }
	local createElement6 = React.createElement

	if not v25 then
		local createElement7 = React.createElement
		local v48

		if props.purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
			v48 = React.createElement(PriceSummary, { amount = props.product.itemRobuxCost })
		else
			local createElement8 = React.createElement
			local v50 = {
				isPortrait = false,
				isCompact = v8,
				itemIcon = v6.itemIcon,
				itemName = v6.itemName,
				itemRobuxCost = v6.itemRobuxCost,
				model = v6.model,
				priceSuffix = perMonth,
				includePriceSuffixOnOriginal = 0
			}

			local v51 = if fFlagLuaAppsEnablePromptVIPServerPurchase then props.isMonthlyPrice else nil
			v50.includePriceSuffixOnOriginal = v51
			v48 = createElement8(UnifiedProductDetails, v50)
		end

		v25 = createElement7(view, { tag = v33, LayoutOrder = 1 }, {
			ProductDetails = v48
		})
	end

	local children2 = {
		ProductDetailsContainer = v25,
		CartPricingLoading = React.createElement(module11, {
			isLoading = props.isCartPricingLoading,
			LayoutOrder = 1
		}),
		PostPurchaseActions = v21,
		UpsellSuggestions = 0
	}

	local createElement7 = React.createElement
	local children3

	if v26 then
		children3 = {}

		for i, upsellSuggestion in ipairs(props.upsellSuggestions) do
			children3["UpsellPackage" .. tostring(i)] = React.createElement(UpsellProductDetails, {
				layoutOrder = i,
				product = upsellSuggestion,
				selected = props.selectedUpsellIndex == i,
				isCompact = v8,
				onSelected = function()
					local v47 = i
					props.onUpsellSuggestionsSelected(v47)
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
				isCompact = v8,
				onSelected = function()
					props.onUpsellSuggestionsSelected(1)
				end
			}),
			UpsellPackage2 = 0
		}
		local v47

		if #props.upsellSuggestions > 1 then
			v47 = React.createElement(UpsellProductDetails, {
				layoutOrder = 2,
				product = props.upsellSuggestions[2],
				selected = props.selectedUpsellIndex == 2,
				isCompact = v8,
				onSelected = function()
					props.onUpsellSuggestionsSelected(2)
				end,
				badgeType = props.upsellSuggestions[2].badgeType
			})
		end

		children3.UpsellPackage2 = v47
	end

	children2.UpsellSuggestions = createElement7(view, {
		LayoutOrder = 2,
		tag = v26 and "col align-x-center align-y-start gap-medium size-full-0 auto-y padding-x-xsmall" or "col gap-medium auto-y size-full-0 align-x-center align-y-center padding-x-xsmall padding-y-small padding-bottom-xxlarge"
	}, children3)
	v42.SheetContentContainer = createElement6(view, {
		tag = v26 and "col align-x-center align-y-start gap-medium size-full-0 auto-y" or "col gap-medium auto-y size-full-0 align-x-center align-y-start"
	}, children2)
	children.Content = createElement5(content, { LayoutOrder = 2 }, v42)

	local createElement8 = React.createElement
	local actions = sheet.Actions

	local createElement9 = React.createElement

	local v52 = if onRobloxPlusButtonActivated then React.createElement(buttonGroup, {
		LayoutOrder = 1,
		orientation = orientation.Vertical,
		size = v31,
		buttons = {
			{
				text = v32.text,
				onActivated = v32.onActivated,
				inputDelay = v32.inputDelay,
				isDisabled = v32.isDisabled,
				ref = v32.ref,
				variant = v32.variant
			},
			{
				text = v7.GetTenPercentOff,
				onActivated = onRobloxPlusButtonActivated,
				isDisabled = v9,
				variant = buttonVariant.Standard,
				icon = enums.IconName.RobloxPlus
			}
		}
	}) else React.createElement(Foundation.Button, v32)
	children.Actions = createElement8(actions, { LayoutOrder = 3 }, { createElement9(view, {
			LayoutOrder = 1,
			tag = onRobloxPlusButtonActivated and "col gap-small size-full-0 auto-y" or v26 and "row wrap align-x-center align-y-center gap-medium size-full-0 auto-y" or "row wrap auto-xy align-y-center align-x-center size-full-0 gap-medium"
		}, {
			BuyAndPlusRow = v52,
			DisclosureTerms = React.createElement(view, {
				LayoutOrder = 2,
				tag = v26 and "row wrap align-x-left align-y-center gap-xxsmall size-full-0 auto-y" or "row wrap auto-y align-y-center align-x-center size-full-0 gap-xxsmall"
			}, {
				DisclosurePayment = React.createElement(text, {
					LayoutOrder = 1,
					Text = v7.DisclosurePayment,
					tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small"
				}),
				BeforeText = React.createElement(text, {
					LayoutOrder = 2,
					Text = v15[1],
					tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small"
				}),
				TextLink = React.createElement(text, {
					LayoutOrder = 3,
					RichText = true,
					Text = v16,
					tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small",
					onActivated = props.termsOfUseActivated
				}),
				AfterText = React.createElement(text, {
					LayoutOrder = 4,
					Text = v15[2],
					tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small"
				})
			})
		}) })
	return createElement2(root, v34, children)
end

local function UnifiedRobuxUpsellModalContainer(p2)
	return React.createElement(
		localizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			UnifiedRobuxUpsellModal = React.createElement(UnifiedRobuxUpsellModal, p2)
		}
	)
end

return UnifiedRobuxUpsellModalContainer
