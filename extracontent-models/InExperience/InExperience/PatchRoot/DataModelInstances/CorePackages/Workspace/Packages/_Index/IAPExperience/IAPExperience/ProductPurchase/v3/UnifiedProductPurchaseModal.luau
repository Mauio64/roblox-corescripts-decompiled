local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local Foundation = require(parent2.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Checkbox = Foundation.Checkbox
local Sheet = Foundation.Sheet
local Button = Foundation.Button
local View = Foundation.View
local Text = Foundation.Text
local FillBehavior = Foundation.Enums.FillBehavior

local UnifiedProductDetails = require(parent.Generic.UnifiedProductDetails)
local PriceSummary = require(parent.Generic.PriceSummary)
local UnifiedPurchaseModalHeader = require(parent.Generic.UnifiedPurchaseModalHeader)
require(parent.Generic.ProductDetailsContainer)

local useCartPricing = require(parent.ProductPurchase.v4.useCartPricing)
local buildCartPricingOfferCheckboxes = require(parent.ProductPurchase.v4.buildCartPricingOfferCheckboxes)
require(parent.ProductPurchase.v4.cartPricingResponseLineItem)
local CartPricingProductDetails = require(parent.ProductPurchase.v4.CartPricingProductDetails)

local UrlBuilder = require(parent2.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local useInitialButtonDisableDelay = require(parent.Generic.Hooks.useInitialButtonDisableDelay)
local useFocusNavigationRefs = require(parent.Generic.Hooks.useFocusNavigationRefs)

local LocalizationService = game:GetService("LocalizationService")
local AppLocales = require(parent2.AppLocales)
local Localization = AppLocales.Localization
local Localization2 = require(parent2.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local useLocalization = Localization2.Hooks.useLocalization

require(script.Parent.UnifiedProductPurchaseModalTypes)
local UnifiedPurchaseModalTypeEnum = require(parent.Enums.UnifiedPurchaseModalTypeEnum)

local SharedFlags = require(parent.Parent.SharedFlags)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = SharedFlags.FFlagEnableUnifiedPurchaseFlowForDevSubs

local SharedFlags2 = require(parent.Parent.SharedFlags)
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = SharedFlags2.FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local SharedFlags3 = require(parent.Parent.SharedFlags)
local FFlagOffersOnlyAffordableLock = SharedFlags3.FFlagOffersOnlyAffordableLock

local SharedFlags4 = require(parent.Parent.SharedFlags)
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags4.FFlagLuaAppsEnablePromptVIPServerPurchase

require(parent.ProductPurchase.PricingTypes)

local RobloxSubscriptionPurchaseApp = require(parent2.RobloxSubscriptionPurchaseApp)
local BlackbirdUpsellBanner = RobloxSubscriptionPurchaseApp.Components.BlackbirdUpsellBanner

local function UnifiedProductPurchaseModal(props)
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
		PerMonth = (FFlagEnableUnifiedPurchaseFlowForDevSubs or FFlagLuaAppsEnablePromptVIPServerPurchase) and "Feature.Subscription.Text.PerMonth" or nil,
		Free = FFlagLuaAppsEnablePromptVIPServerPurchase and "Feature.Catalog.LabelFree" or nil,
		FreeWithPlus = FFlagLuaAppsEnablePromptVIPServerPurchase and "Feature.PrivateServers.Action.FreeWithBlackbird" or nil,
		CreatePrivateServer = FFlagLuaAppsEnablePromptVIPServerPurchase and "Feature.PrivateServers.Action.CreatePrivateServer" or nil,
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
	elseif FFlagLuaAppsEnablePromptVIPServerPurchase and props.isMonthlyPrice then
		perMonth = v.PerMonth
	end

	local state, setState = React.useState(props.postPurchaseActions or {})
	local state2, setState2 = React.useState(v.BuyItem)

	local v2 = useInitialButtonDisableDelay(props.buttons.isDisabled)

	local cartPricing = useCartPricing({
		product = props.product,
		purchaseModalType = props.purchaseModalType,
		cartPricingResponse = props.cartPricingResponse,
		onCartOfferAppliedChanged = props.onCartOfferAppliedChanged
	})

	local isDisabled = props.buttons.isDisabled or props.isCartPricingLoading == true or v2 == true

	local priceWithoutOffersDiscounts = cartPricing.priceWithoutOffersDiscounts
	local priceAfterOffersDiscounts = cartPricing.priceAfterOffersDiscounts
	local v3

	if priceWithoutOffersDiscounts == nil then
		v3 = false
	else
		v3 = props.robuxBalanceAmount < priceWithoutOffersDiscounts
	end

	local v4 = priceAfterOffersDiscounts ~= nil and priceAfterOffersDiscounts <= props.robuxBalanceAmount

	local v5 = cartPricing.showCartOfferUi and #cartPricing.cartPricingOffers or 0

	React.useEffect(function()
		local purchaseModalType = props.purchaseModalType

		if
			FFlagEnableUnifiedPurchaseFlowForDevSubs
			and purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
		then
			setState2(v.GetSubscription)
		elseif purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
			if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
				setState2(v.BuyAvatar)
			else
				setState2(v.BuyItems)
			end
		elseif purchaseModalType == UnifiedPurchaseModalTypeEnum.Experience then
			setState2(v.BuyExperience)
		elseif
			FFlagLuaAppsEnablePromptVIPServerPurchase
			and purchaseModalType == UnifiedPurchaseModalTypeEnum.VIPServer
		then
			setState2(v.CreatePrivateServer)
		elseif FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
			setState2(v.BuyItemV2)
		else
			setState2(v.BuyItem)
		end
	end, { props.purchaseModalType })

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
	local text

	if
		FFlagEnableUnifiedPurchaseFlowForDevSubs
		and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	then
		text = v.Subscribe
	else
		text = v.Buy
	end

	local v6 = React.useMemo(function()
		local children = {}

		for k, v6 in state do
			children[v6.actionKey] = React.createElement(Checkbox, {
				LayoutOrder = v5 + k,
				size = "XSmall",
				label = v6.label,
				isChecked = v6.isActionSelected,
				isDisabled = isDisabled,
				onActivated = function()
					setState(function(p)
						local clone = table.clone(p)
						clone[k] = {
							label = v6.label,
							isActionSelected = not v6.isActionSelected,
							actionKey = v6.actionKey
						}

						return clone
					end)
				end
			})
		end

		return children
	end, { state, v5, isDisabled })

	local cartPricingOfferCheckboxes = buildCartPricingOfferCheckboxes({
		cartPricing = cartPricing,
		isDisabled = isDisabled or v3 and (not FFlagOffersOnlyAffordableLock or v4)
	})

	local clone = table.clone(cartPricingOfferCheckboxes)

	for k, v7 in pairs(v6) do
		clone[k] = v7
	end

	local element = React.createElement(
		View,
		{ tag = "col gap-medium auto-y size-full-0 align-x-start align-y-start", LayoutOrder = 2 },
		clone
	)

	local itemPrice = props.product.itemPrice
	local v7

	if itemPrice then
		v7 = itemPrice.priceInRobux
	else
		v7 = props.product.itemRobuxCost
	end

	local priceText

	if FFlagLuaAppsEnablePromptVIPServerPurchase and v7 == 0 then
		if props.isFreeWithRobloxPlus then
			priceText = v.FreeWithPlus
		elseif props.isMonthlyPrice then
			priceText = v.Free
		end
	end

	local subscribeTerms

	if
		FFlagEnableUnifiedPurchaseFlowForDevSubs
		and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	then
		local v8 = string.gsub(v.SubscribeTermsAgreement or "", "<a.->(.-)</a>", "%1")
		local text2 = string.gsub(v8, "<.->", "")
		subscribeTerms = React.createElement(Text, {
			LayoutOrder = 4,
			Text = text2,
			tag = "wrap size-full-0 auto-y text-caption-small text-wrap text-align-x-left"
		})
	end

	local createElement = React.createElement
	local v8 = {
		cartPricing = cartPricing,
		purchaseModalType = props.purchaseModalType,
		priceSuffix = perMonth,
		priceText = 0,
		includePriceSuffixOnOriginal = 0,
		isCartPricingLoading = 0
	}

	if not FFlagLuaAppsEnablePromptVIPServerPurchase then
		priceText = nil
	end

	v8.priceText = priceText
	local includePriceSuffixOnOriginal

	if FFlagLuaAppsEnablePromptVIPServerPurchase then
		includePriceSuffixOnOriginal = props.isMonthlyPrice
	end

	v8.includePriceSuffixOnOriginal = includePriceSuffixOnOriginal
	v8.isCartPricingLoading = props.isCartPricingLoading
	local productDetailsContainer = createElement(CartPricingProductDetails, v8)

	local createElement2 = React.createElement
	local root = Sheet.Root
	local v9 = { onClose = props.buttons.cancelActivated, preferCenterSheet = true, ref = 0 }

	if v2 then
		ref = nil
	end

	v9.ref = ref

	local createElement3 = React.createElement
	local header = Sheet.Header
	local hasCloseAffordance

	if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
		hasCloseAffordance = props.hideUserRobuxBalance and true or nil
	end

	local createElement4 = React.createElement
	local v10 = {
		titleText = state2,
		robuxBalanceAmount = props.robuxBalanceAmount,
		hideUserRobuxBalance = 0
	}
	local hideUserRobuxBalance

	if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
		hideUserRobuxBalance = props.hideUserRobuxBalance
	end

	v10.hideUserRobuxBalance = hideUserRobuxBalance
	local children = {
		Header = createElement3(header, { hasCloseAffordance = hasCloseAffordance }, {
			ModalHeader = createElement4(UnifiedPurchaseModalHeader, v10)
		}),
		Content = 0,
		Actions = 0
	}

	local createElement5 = React.createElement
	local content = Sheet.Content

	local createElement6 = React.createElement

	if not productDetailsContainer then
		local createElement7 = React.createElement
		local productDetails

		if props.purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
			productDetails = React.createElement(PriceSummary, {
				amount = v7,
				itemPrice = itemPrice
			})
		else
			local createElement8 = React.createElement
			local v11 = {
				isPortrait = false,
				itemIcon = props.product.itemIcon,
				itemName = props.product.itemName,
				itemRobuxCost = v7,
				itemPrice = itemPrice,
				itemDisplayPrice = 0,
				priceSuffix = 0,
				model = 0
			}
			local itemDisplayPrice

			if FFlagEnableUnifiedPurchaseFlowForDevSubs then
				itemDisplayPrice = props.product.itemDisplayPrice
			end

			v11.itemDisplayPrice = itemDisplayPrice

			v11.priceSuffix = perMonth
			v11.model = props.product.model
			productDetails = createElement8(UnifiedProductDetails, v11)
		end

		productDetailsContainer = createElement7(
			View,
			{
				tag = "col gap-medium auto-y size-full-0 align-x-center align-y-center",
				LayoutOrder = 1
			},
			{ ProductDetails = productDetails }
		)
	end

	children.Content = createElement5(content, { LayoutOrder = 2 }, {
		SheetContentContainer = createElement6(
			View,
			{ tag = "col gap-medium auto-y size-full-0 align-x-center align-y-center" },
			{ ProductDetailsContainer = productDetailsContainer, PostPurchaseActions = element }
		)
	})

	local createElement7 = React.createElement
	local actions = Sheet.Actions

	local createElement8 = React.createElement

	local v11 = {
		BuyButton = React.createElement(Button, {
			text = text,
			onActivated = onActivated,
			inputDelay = props.buttons.buyItemEnableInputDelayed and not v2 and 2.5 or 0,
			isDisabled = isDisabled,
			ref = ref2,
			fillBehavior = FillBehavior.Fill,
			variant = ButtonVariant.Emphasis,
			LayoutOrder = 1
		}),
		BlackbirdUpsellBanner = 0,
		TestPurchaseDisclaimer = 0,
		SubscribeTerms = 0
	}
	local blackbirdUpsellBanner

	if props.BlackbirdUpsellBannerProductInfo and props.onBlackbirdUpsellActivated then
		local createElement9 = React.createElement
		local v12 = {
			productInfo = props.BlackbirdUpsellBannerProductInfo,
			onActivated = props.onBlackbirdUpsellActivated,
			bannerText = 0,
			LayoutOrder = 2
		}
		local bannerText

		if
			FFlagLuaAppsEnablePromptVIPServerPurchase
			and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.VIPServer
		then
			bannerText = v.FreeWithPlus
		end

		v12.bannerText = bannerText
		blackbirdUpsellBanner = createElement9(BlackbirdUpsellBanner, v12)
	end

	v11.BlackbirdUpsellBanner = blackbirdUpsellBanner
	local testPurchaseDisclaimer

	if props.isTestPurchase then
		testPurchaseDisclaimer = React.createElement(Text, {
			Text = v.TestPurchaseDisclaimer,
			tag = "auto-y size-full-0 text-caption-small text-align-x-center text-wrap wrap",
			LayoutOrder = 3
		})
	end

	v11.TestPurchaseDisclaimer = testPurchaseDisclaimer

	v11.SubscribeTerms = subscribeTerms
	children.Actions = createElement7(actions, { LayoutOrder = 3 }, {
		createElement8(
			View,
			{
				tag = "row wrap auto-xy align-y-center align-x-center size-full-0 gap-medium",
				LayoutOrder = 1
			},
			v11
		)
	})
	return createElement2(root, v9, children)
end

local function UnifiedProductPurchaseModalContainer(p)
	return React.createElement(
		LocalizationProvider,
		{
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			ProductPurchaseModal = React.createElement(UnifiedProductPurchaseModal, p)
		}
	)
end

return UnifiedProductPurchaseModalContainer
