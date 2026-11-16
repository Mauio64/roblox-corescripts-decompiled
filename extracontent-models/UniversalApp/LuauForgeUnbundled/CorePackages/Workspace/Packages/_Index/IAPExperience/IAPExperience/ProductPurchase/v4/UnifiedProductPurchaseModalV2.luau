local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local blackbirdUpsellBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/RobloxSubscriptionPurchaseApp").Components.BlackbirdUpsellBanner

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local buttonVariant = Foundation.Enums.ButtonVariant
local dialog = Foundation.Dialog
local checkbox = Foundation.Checkbox
local view = Foundation.View
local dialogSize = Foundation.Enums.DialogSize

require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/ProductDetailsContainer")
local CartPricingProductDetails = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/CartPricingProductDetails")
local buildCartPricingOfferCheckboxes = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/buildCartPricingOfferCheckboxes")
local useCartPricing = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/useCartPricing")

local useFocusNavigationRefs = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Hooks/useFocusNavigationRefs")

local LocalizationService = game:GetService("LocalizationService")
local localization = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/AppLocales").Localization
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization")
local localizationProvider = Localization.LocalizationProvider
local useLocalization = Localization.Hooks.useLocalization

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UrlBuilder").UrlBuilder

local SubtitleComponentMap = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/SubtitleComponentMap")

require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v3/UnifiedProductPurchaseModalTypes")
local UnifiedPurchaseModalTypeEnum = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/UnifiedPurchaseModalTypeEnum")

local fFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local fFlagUnifiedPurchaseAddSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagUnifiedPurchaseAddSkeleton

local fFlagEnableUnifiedPurchaseFlowForDevSubs = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagEnableUnifiedPurchaseFlowForDevSubs

local fFlagOffersOnlyAffordableLock = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagOffersOnlyAffordableLock

require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/cartPricingResponseLineItem")

local function UnifiedProductPurchaseModalV2(props)
	local v5 = useLocalization({
		Buy = "IAPExperience.PurchasePrompt.Action.Buy",
		Subscribe = "Feature.Subscription.Action.Subscribe",
		BuyItem = "IAPExperience.PurchasePrompt.Title.BuyItem",
		BuyItemV2 = fFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "IAPExperience.PurchasePrompt.Title.BuyItemV2" or nil,
		GetSubscription = "IAPExperience.SubscriptionPurchasePrompt.Label.GetSubscription",
		BuyExperience = "IAPExperience.PurchasePrompt.Title.BuyExperience",
		BuyItems = "IAPExperience.PurchasePrompt.Title.BuyItems",
		BuyAvatar = fFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "IAPExperience.PurchasePrompt.Header.BuyAvatar" or nil,
		TestPurchaseDisclaimer = "IAPExperience.PurchasePrompt.Text.TestPurchase",
		PerMonth = fFlagEnableUnifiedPurchaseFlowForDevSubs and "Feature.Subscription.Text.PerMonth" or nil,
		SubscribeTermsAgreement = fFlagEnableUnifiedPurchaseFlowForDevSubs and {
			"Feature.Subscription.Footer.PurchasePromptLegalText",
			SubscribeButtonTitle = "\"Subscribe\"",
			tosUrl = urlBuilder.static.about.terms()
		} or nil
	})
	local perMonth

	if
		fFlagEnableUnifiedPurchaseFlowForDevSubs
		and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	then
		perMonth = v5.PerMonth
	end

	local v6 = useCartPricing({
		product = props.product,
		purchaseModalType = props.purchaseModalType,
		cartPricingResponse = props.cartPricingResponse,
		onCartOfferAppliedChanged = props.onCartOfferAppliedChanged
	})

	local state, setState = React.useState(props.postPurchaseActions or {})

	local purchaseModalType = props.purchaseModalType
	local v7

	if fFlagEnableUnifiedPurchaseFlowForDevSubs and purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription then
		v7 = v5.GetSubscription
	elseif purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
		v7 = v5.BuyAvatar
	else
		v7 = if purchaseModalType == UnifiedPurchaseModalTypeEnum.Experience then v5.BuyExperience else v5.BuyItemV2
	end

	local v8, v9 = useFocusNavigationRefs(props.buttons.cancelActivated, props.onBuyItemButtonMounted)

	local v10 = React.useCallback(function()
		if state and props.setPostPurchaseActions then
			props.setPostPurchaseActions(state)
		end

		props.buttons.buyItemActivated()
	end, { props.buttons.buyItemActivated, state })

	React.useEffect(function()
		setState(props.postPurchaseActions or {})
	end, { props.postPurchaseActions })

	local isDisabled = props.buttons.isDisabled
		or props.isCartPricingLoading == true
		or fFlagUnifiedPurchaseAddSkeleton and props.isLoading == true

	local priceWithoutOffersDiscounts = v6.priceWithoutOffersDiscounts
	local priceAfterOffersDiscounts = v6.priceAfterOffersDiscounts
	local v11

	if priceWithoutOffersDiscounts == nil then
		v11 = false
	else
		v11 = props.robuxBalanceAmount < priceWithoutOffersDiscounts
	end

	local v12 = priceAfterOffersDiscounts ~= nil and priceAfterOffersDiscounts <= props.robuxBalanceAmount

	local v14 = v6.showCartOfferUi and #v6.cartPricingOffers or 0

	local v15 = React.useMemo(function()
		local children = {}

		for k, v16 in state do
			children[v16.actionKey] = React.createElement(checkbox, {
				LayoutOrder = v14 + k,
				size = "XSmall",
				label = v16.label,
				isChecked = v16.isActionSelected,
				isDisabled = isDisabled,
				onActivated = function()
					setState(function(p2)
						local clone = table.clone(p2)
						clone[k] = {
							label = v16.label,
							isActionSelected = not v16.isActionSelected,
							actionKey = v16.actionKey
						}

						return clone
					end)
				end
			})
		end

		return children
	end, { state, v14, isDisabled })

	local v16 = nil

	if props.subtitleView then
		local v17 = SubtitleComponentMap[props.subtitleView.componentName]

		if v17 then
			v16 = React.createElement(v17, props.subtitleView.props)
		end
	end

	local element = React.createElement(CartPricingProductDetails, {
		cartPricing = v6,
		purchaseModalType = props.purchaseModalType,
		subtitleView = v16,
		priceSuffix = perMonth,
		isLoading = props.isLoading,
		isCartPricingLoading = props.isCartPricingLoading
	})

	local v17 = buildCartPricingOfferCheckboxes({
		cartPricing = v6,
		isDisabled = isDisabled or v11 and (not fFlagOffersOnlyAffordableLock or v12)
	})

	local clone = table.clone(v17)

	for k, v18 in pairs(v15) do
		clone[k] = v18
	end

	local v18

	if next(v17) or next(v15) then
		v18 = React.createElement(
			view,
			{
				tag = "col gap-medium auto-y size-full-0 align-x-start align-y-start",
				LayoutOrder = 1
			},
			clone
		)
	end

	local v20 = {
		{
			text = if fFlagEnableUnifiedPurchaseFlowForDevSubs and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription then v5.Subscribe else v5.Buy,
			variant = buttonVariant.Emphasis,
			onActivated = v10,
			isDisabled = isDisabled,
			ref = v9,
			inputDelay = props.buttons.buyItemEnableInputDelayed and not props.buttons.isDisabled and 2.5 or 0
		}
	}
	local v21

	if
		fFlagEnableUnifiedPurchaseFlowForDevSubs
		and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	then
		local v22 = string.gsub(v5.SubscribeTermsAgreement or "", "<a.->(.-)</a>", "%1")
		local v23 = string.gsub(v22, "<.->", "")
		v21 = React.createElement(Foundation.Text, {
			LayoutOrder = 6,
			Text = v23,
			tag = "wrap size-full-0 auto-y text-caption-small text-wrap text-align-x-left"
		})
	end

	local createElement = React.createElement
	local root = dialog.Root
	local v22 = {
		size = dialogSize.Medium,
		onClose = props.buttons.cancelActivated,
		ref = v8,
		disablePortal = false
	}

	local v23 = {
		DialogTitle = React.createElement(dialog.Title, { text = v7 }),
		DialogContent = React.createElement(
			view,
			{
				tag = "col gap-medium auto-y size-full-0 align-x-center align-y-center",
				LayoutOrder = 1
			},
			{ ProductDetailsContainer = element }
		),
		ActionsSection = 0,
		TestDisclaimer = 0,
		SubscribeTerms = 0
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement

	local v29 = {
		DialogActions = React.createElement(dialog.Actions, {
			LayoutOrder = 1,
			orientation = Foundation.Enums.Orientation.Horizontal,
			actions = v20
		}),
		BlackbirdUpsellBanner = 0
	}

	local v30 = if props.BlackbirdUpsellBannerProductInfo and props.onBlackbirdUpsellActivated then React.createElement(blackbirdUpsellBanner, {
		productInfo = props.BlackbirdUpsellBannerProductInfo,
		onActivated = props.onBlackbirdUpsellActivated,
		LayoutOrder = 2
	}) else nil
	v29.BlackbirdUpsellBanner = v30
	v23.ActionsSection = createElement2(
		view,
		{ tag = "col size-full-0 auto-y gap-xlarge", LayoutOrder = 3 },
		{
			PostPurchaseActions = v18,
			BuyAndUpsell = createElement3(
				view,
				{ tag = "col size-full-0 auto-y gap-medium", LayoutOrder = 2 },
				v29
			)
		}
	)

	local v31 = if props.isTestPurchase then React.createElement(Foundation.Text, {
		LayoutOrder = 5,
		Text = v5.TestPurchaseDisclaimer,
		tag = "auto-y size-full-0 text-caption-small text-align-x-center text-wrap wrap"
	}) else nil
	v23.TestDisclaimer = v31

	v23.SubscribeTerms = v21
	return createElement(root, v22, v23)
end

local function UnifiedProductPurchaseModalV2Container(p2)
	return React.createElement(
		localizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			ProductPurchaseModal = React.createElement(UnifiedProductPurchaseModalV2, p2)
		}
	)
end

return UnifiedProductPurchaseModalV2Container
