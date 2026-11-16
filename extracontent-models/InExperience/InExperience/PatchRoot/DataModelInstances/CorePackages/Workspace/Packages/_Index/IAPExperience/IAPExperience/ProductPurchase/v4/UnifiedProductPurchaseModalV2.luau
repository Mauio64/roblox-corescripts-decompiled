local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local RobloxSubscriptionPurchaseApp = require(parent2.RobloxSubscriptionPurchaseApp)
local BlackbirdUpsellBanner = RobloxSubscriptionPurchaseApp.Components.BlackbirdUpsellBanner

local Foundation = require(parent2.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local Checkbox = Foundation.Checkbox
local View = Foundation.View
local DialogSize = Foundation.Enums.DialogSize

require(parent.Generic.ProductDetailsContainer)
local CartPricingProductDetails = require(script.Parent.CartPricingProductDetails)
local buildCartPricingOfferCheckboxes = require(script.Parent.buildCartPricingOfferCheckboxes)
local useCartPricing = require(script.Parent.useCartPricing)

local useFocusNavigationRefs = require(parent.Generic.Hooks.useFocusNavigationRefs)

local LocalizationService = game:GetService("LocalizationService")
local AppLocales = require(parent2.AppLocales)
local Localization = AppLocales.Localization
local Localization2 = require(parent2.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local useLocalization = Localization2.Hooks.useLocalization

local UrlBuilder = require(parent2.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local SubtitleComponentMap = require(script.Parent.SubtitleComponentMap)

require(script.Parent.Parent.v3.UnifiedProductPurchaseModalTypes)
local UnifiedPurchaseModalTypeEnum = require(parent.Enums.UnifiedPurchaseModalTypeEnum)

local SharedFlags = require(parent.Parent.SharedFlags)
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = SharedFlags.FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local SharedFlags2 = require(parent.Parent.SharedFlags)
local FFlagUnifiedPurchaseAddSkeleton = SharedFlags2.FFlagUnifiedPurchaseAddSkeleton

local SharedFlags3 = require(parent.Parent.SharedFlags)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = SharedFlags3.FFlagEnableUnifiedPurchaseFlowForDevSubs

local SharedFlags4 = require(parent.Parent.SharedFlags)
local FFlagOffersOnlyAffordableLock = SharedFlags4.FFlagOffersOnlyAffordableLock

require(script.Parent.cartPricingResponseLineItem)

local function UnifiedProductPurchaseModalV2(props)
	local v = useLocalization({
		Buy = "IAPExperience.PurchasePrompt.Action.Buy",
		Subscribe = "Feature.Subscription.Action.Subscribe",
		BuyItem = "IAPExperience.PurchasePrompt.Title.BuyItem",
		BuyItemV2 = FFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "IAPExperience.PurchasePrompt.Title.BuyItemV2" or nil,
		GetSubscription = "IAPExperience.SubscriptionPurchasePrompt.Label.GetSubscription",
		BuyExperience = "IAPExperience.PurchasePrompt.Title.BuyExperience",
		BuyItems = "IAPExperience.PurchasePrompt.Title.BuyItems",
		BuyAvatar = FFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "IAPExperience.PurchasePrompt.Header.BuyAvatar" or nil,
		TestPurchaseDisclaimer = "IAPExperience.PurchasePrompt.Text.TestPurchase",
		PerMonth = FFlagEnableUnifiedPurchaseFlowForDevSubs and "Feature.Subscription.Text.PerMonth" or nil,
		SubscribeTermsAgreement = FFlagEnableUnifiedPurchaseFlowForDevSubs and {
			"Feature.Subscription.Footer.PurchasePromptLegalText",
			SubscribeButtonTitle = "\"Subscribe\"",
			tosUrl = urlBuilder.static.about.terms()
		} or nil
	})
	local perMonth

	if
		FFlagEnableUnifiedPurchaseFlowForDevSubs
		and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	then
		perMonth = v.PerMonth
	end

	local cartPricing = useCartPricing({
		product = props.product,
		purchaseModalType = props.purchaseModalType,
		cartPricingResponse = props.cartPricingResponse,
		onCartOfferAppliedChanged = props.onCartOfferAppliedChanged
	})

	local state, setState = React.useState(props.postPurchaseActions or {})

	local purchaseModalType = props.purchaseModalType
	local text

	if
		FFlagEnableUnifiedPurchaseFlowForDevSubs
		and purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	then
		text = v.GetSubscription
	elseif purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
		text = v.BuyAvatar
	elseif purchaseModalType == UnifiedPurchaseModalTypeEnum.Experience then
		text = v.BuyExperience
	else
		text = v.BuyItemV2
	end

	local ref, ref2 = useFocusNavigationRefs(props.buttons.cancelActivated, props.onBuyItemButtonMounted)

	local onActivated = React.useCallback(function()
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
		or FFlagUnifiedPurchaseAddSkeleton and props.isLoading == true

	local priceWithoutOffersDiscounts = cartPricing.priceWithoutOffersDiscounts
	local priceAfterOffersDiscounts = cartPricing.priceAfterOffersDiscounts
	local v2

	if priceWithoutOffersDiscounts == nil then
		v2 = false
	else
		v2 = props.robuxBalanceAmount < priceWithoutOffersDiscounts
	end

	local v3 = priceAfterOffersDiscounts ~= nil and priceAfterOffersDiscounts <= props.robuxBalanceAmount

	local v4 = cartPricing.showCartOfferUi and #cartPricing.cartPricingOffers or 0

	local v5 = React.useMemo(function()
		local children = {}

		for k, v5 in state do
			children[v5.actionKey] = React.createElement(Checkbox, {
				LayoutOrder = v4 + k,
				size = "XSmall",
				label = v5.label,
				isChecked = v5.isActionSelected,
				isDisabled = isDisabled,
				onActivated = function()
					setState(function(p)
						local clone = table.clone(p)
						clone[k] = {
							label = v5.label,
							isActionSelected = not v5.isActionSelected,
							actionKey = v5.actionKey
						}

						return clone
					end)
				end
			})
		end

		return children
	end, { state, v4, isDisabled })

	local subtitleView = nil

	if props.subtitleView then
		local subtitleComponent = SubtitleComponentMap[props.subtitleView.componentName]

		if subtitleComponent then
			subtitleView = React.createElement(subtitleComponent, props.subtitleView.props)
		end
	end

	local element = React.createElement(CartPricingProductDetails, {
		cartPricing = cartPricing,
		purchaseModalType = props.purchaseModalType,
		subtitleView = subtitleView,
		priceSuffix = perMonth,
		isLoading = props.isLoading,
		isCartPricingLoading = props.isCartPricingLoading
	})

	local cartPricingOfferCheckboxes = buildCartPricingOfferCheckboxes({
		cartPricing = cartPricing,
		isDisabled = isDisabled or v2 and (not FFlagOffersOnlyAffordableLock or v3)
	})

	local clone = table.clone(cartPricingOfferCheckboxes)

	for k, v6 in pairs(v5) do
		clone[k] = v6
	end

	local postPurchaseActions

	if next(cartPricingOfferCheckboxes) or next(v5) then
		postPurchaseActions = React.createElement(
			View,
			{
				tag = "col gap-medium auto-y size-full-0 align-x-start align-y-start",
				LayoutOrder = 1
			},
			clone
		)
	end

	local text2

	if
		FFlagEnableUnifiedPurchaseFlowForDevSubs
		and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	then
		text2 = v.Subscribe
	else
		text2 = v.Buy
	end

	local actions = {
		{
			text = text2,
			variant = ButtonVariant.Emphasis,
			onActivated = onActivated,
			isDisabled = isDisabled,
			ref = ref2,
			inputDelay = props.buttons.buyItemEnableInputDelayed and not props.buttons.isDisabled and 2.5 or 0
		}
	}
	local subscribeTerms

	if
		FFlagEnableUnifiedPurchaseFlowForDevSubs
		and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	then
		local v6 = string.gsub(v.SubscribeTermsAgreement or "", "<a.->(.-)</a>", "%1")
		local text3 = string.gsub(v6, "<.->", "")
		subscribeTerms = React.createElement(Foundation.Text, {
			LayoutOrder = 6,
			Text = text3,
			tag = "wrap size-full-0 auto-y text-caption-small text-wrap text-align-x-left"
		})
	end

	local createElement = React.createElement
	local root = Dialog.Root
	local v6 = {
		size = DialogSize.Medium,
		onClose = props.buttons.cancelActivated,
		ref = ref,
		disablePortal = false
	}

	local v7 = {
		DialogTitle = React.createElement(Dialog.Title, { text = text }),
		DialogContent = React.createElement(
			View,
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

	local v8 = {
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 1,
			orientation = Foundation.Enums.Orientation.Horizontal,
			actions = actions
		}),
		BlackbirdUpsellBanner = 0
	}
	local blackbirdUpsellBanner

	if props.BlackbirdUpsellBannerProductInfo and props.onBlackbirdUpsellActivated then
		blackbirdUpsellBanner = React.createElement(BlackbirdUpsellBanner, {
			productInfo = props.BlackbirdUpsellBannerProductInfo,
			onActivated = props.onBlackbirdUpsellActivated,
			LayoutOrder = 2
		})
	end

	v8.BlackbirdUpsellBanner = blackbirdUpsellBanner
	v7.ActionsSection = createElement2(View, {
		tag = "col size-full-0 auto-y gap-xlarge",
		LayoutOrder = 3
	}, {
		PostPurchaseActions = postPurchaseActions,
		BuyAndUpsell = createElement3(View, {
			tag = "col size-full-0 auto-y gap-medium",
			LayoutOrder = 2
		}, v8)
	})
	local testDisclaimer

	if props.isTestPurchase then
		testDisclaimer = React.createElement(Foundation.Text, {
			LayoutOrder = 5,
			Text = v.TestPurchaseDisclaimer,
			tag = "auto-y size-full-0 text-caption-small text-align-x-center text-wrap wrap"
		})
	end

	v7.TestDisclaimer = testDisclaimer

	v7.SubscribeTerms = subscribeTerms
	return createElement(root, v6, v7)
end

local function UnifiedProductPurchaseModalV2Container(p)
	return React.createElement(
		LocalizationProvider,
		{
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			ProductPurchaseModal = React.createElement(UnifiedProductPurchaseModalV2, p)
		}
	)
end

return UnifiedProductPurchaseModalV2Container
