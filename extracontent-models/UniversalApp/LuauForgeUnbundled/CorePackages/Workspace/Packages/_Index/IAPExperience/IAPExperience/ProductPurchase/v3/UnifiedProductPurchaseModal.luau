local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local buttonVariant = Foundation.Enums.ButtonVariant
local checkbox = Foundation.Checkbox
local sheet = Foundation.Sheet
local button = Foundation.Button
local view = Foundation.View
local text = Foundation.Text
local fillBehavior = Foundation.Enums.FillBehavior

local UnifiedProductDetails = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/UnifiedProductDetails")
local PriceSummary = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/PriceSummary")
local UnifiedPurchaseModalHeader = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/UnifiedPurchaseModalHeader")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/ProductDetailsContainer")

local useCartPricing = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/useCartPricing")
local buildCartPricingOfferCheckboxes = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/buildCartPricingOfferCheckboxes")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/cartPricingResponseLineItem")
local CartPricingProductDetails = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/CartPricingProductDetails")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UrlBuilder").UrlBuilder

local useInitialButtonDisableDelay = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Hooks/useInitialButtonDisableDelay")
local useFocusNavigationRefs = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Hooks/useFocusNavigationRefs")

local LocalizationService = game:GetService("LocalizationService")
local localization = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/AppLocales").Localization
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization")
local localizationProvider = Localization.LocalizationProvider
local useLocalization = Localization.Hooks.useLocalization

require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v3/UnifiedProductPurchaseModalTypes")
local UnifiedPurchaseModalTypeEnum = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/UnifiedPurchaseModalTypeEnum")

local fFlagEnableUnifiedPurchaseFlowForDevSubs = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagEnableUnifiedPurchaseFlowForDevSubs

local fFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local fFlagOffersOnlyAffordableLock = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagOffersOnlyAffordableLock

local fFlagLuaAppsEnablePromptVIPServerPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagLuaAppsEnablePromptVIPServerPurchase

require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/PricingTypes")

local blackbirdUpsellBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/RobloxSubscriptionPurchaseApp").Components.BlackbirdUpsellBanner

local function UnifiedProductPurchaseModal(props)
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
		PerMonth = (fFlagEnableUnifiedPurchaseFlowForDevSubs or fFlagLuaAppsEnablePromptVIPServerPurchase) and "Feature.Subscription.Text.PerMonth" or nil,
		Free = fFlagLuaAppsEnablePromptVIPServerPurchase and "Feature.Catalog.LabelFree" or nil,
		FreeWithPlus = fFlagLuaAppsEnablePromptVIPServerPurchase and "Feature.PrivateServers.Action.FreeWithBlackbird" or nil,
		CreatePrivateServer = fFlagLuaAppsEnablePromptVIPServerPurchase and "Feature.PrivateServers.Action.CreatePrivateServer" or nil,
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
	elseif fFlagLuaAppsEnablePromptVIPServerPurchase and props.isMonthlyPrice then
		perMonth = v5.PerMonth
	end

	local state, setState = React.useState(props.postPurchaseActions or {})
	local state2, setState2 = React.useState(v5.BuyItem)

	local v6 = useInitialButtonDisableDelay(props.buttons.isDisabled)

	local v7 = useCartPricing({
		product = props.product,
		purchaseModalType = props.purchaseModalType,
		cartPricingResponse = props.cartPricingResponse,
		onCartOfferAppliedChanged = props.onCartOfferAppliedChanged
	})

	local isDisabled = props.buttons.isDisabled or props.isCartPricingLoading == true or v6 == true

	local priceWithoutOffersDiscounts = v7.priceWithoutOffersDiscounts
	local priceAfterOffersDiscounts = v7.priceAfterOffersDiscounts
	local v8

	if priceWithoutOffersDiscounts == nil then
		v8 = false
	else
		v8 = props.robuxBalanceAmount < priceWithoutOffersDiscounts
	end

	local v9 = priceAfterOffersDiscounts ~= nil and priceAfterOffersDiscounts <= props.robuxBalanceAmount

	local v11 = v7.showCartOfferUi and #v7.cartPricingOffers or 0

	React.useEffect(function()
		local purchaseModalType = props.purchaseModalType

		if
			fFlagEnableUnifiedPurchaseFlowForDevSubs
			and purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
		then
			setState2(v5.GetSubscription)
		elseif purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
			if fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
				setState2(v5.BuyAvatar)
			else
				setState2(v5.BuyItems)
			end
		elseif purchaseModalType == UnifiedPurchaseModalTypeEnum.Experience then
			setState2(v5.BuyExperience)
		elseif fFlagLuaAppsEnablePromptVIPServerPurchase and purchaseModalType == UnifiedPurchaseModalTypeEnum.VIPServer then
			setState2(v5.CreatePrivateServer)
		elseif fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
			setState2(v5.BuyItemV2)
		else
			setState2(v5.BuyItem)
		end
	end, { props.purchaseModalType })

	local v12, v13 = useFocusNavigationRefs(props.buttons.cancelActivated, props.onBuyItemButtonMounted)

	local v14 = React.useCallback(function()
		if state and props.setPostPurchaseActions then
			props.setPostPurchaseActions(state)
		end

		props.buttons.buyItemActivated()
	end, { props.buttons.buyItemActivated, state })

	React.useEffect(function()
		setState(props.postPurchaseActions or {})
	end, { props.postPurchaseActions })
	local v15

	if
		fFlagEnableUnifiedPurchaseFlowForDevSubs
		and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	then
		v15 = v5.Subscribe
	else
		v15 = v5.Buy
	end

	local v16 = React.useMemo(function()
		local children = {}

		for k, v17 in state do
			children[v17.actionKey] = React.createElement(checkbox, {
				LayoutOrder = v11 + k,
				size = "XSmall",
				label = v17.label,
				isChecked = v17.isActionSelected,
				isDisabled = isDisabled,
				onActivated = function()
					setState(function(p2)
						local clone = table.clone(p2)
						clone[k] = {
							label = v17.label,
							isActionSelected = not v17.isActionSelected,
							actionKey = v17.actionKey
						}

						return clone
					end)
				end
			})
		end

		return children
	end, { state, v11, isDisabled })

	local v17 = buildCartPricingOfferCheckboxes({
		cartPricing = v7,
		isDisabled = isDisabled or v8 and (not fFlagOffersOnlyAffordableLock or v9)
	})

	local clone = table.clone(v17)

	for k, v18 in pairs(v16) do
		clone[k] = v18
	end

	local element = React.createElement(
		view,
		{
			tag = "col gap-medium auto-y size-full-0 align-x-start align-y-start",
			LayoutOrder = 2
		},
		clone
	)

	local itemPrice = props.product.itemPrice
	local v18 = if itemPrice then itemPrice.priceInRobux else props.product.itemRobuxCost
	local v19

	if fFlagLuaAppsEnablePromptVIPServerPurchase and v18 == 0 then
		if props.isFreeWithRobloxPlus then
			v19 = v5.FreeWithPlus
		elseif props.isMonthlyPrice then
			v19 = v5.Free
		end
	end

	local v20

	if
		fFlagEnableUnifiedPurchaseFlowForDevSubs
		and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	then
		local v21 = string.gsub(v5.SubscribeTermsAgreement or "", "<a.->(.-)</a>", "%1")
		local v22 = string.gsub(v21, "<.->", "")
		v20 = React.createElement(text, {
			LayoutOrder = 4,
			Text = v22,
			tag = "wrap size-full-0 auto-y text-caption-small text-wrap text-align-x-left"
		})
	end

	local createElement = React.createElement
	local v22 = {
		cartPricing = v7,
		purchaseModalType = props.purchaseModalType,
		priceSuffix = perMonth,
		priceText = 0,
		includePriceSuffixOnOriginal = 0,
		isCartPricingLoading = 0
	}

	if not fFlagLuaAppsEnablePromptVIPServerPurchase then
		v19 = nil
	end

	v22.priceText = v19
	local v23 = if fFlagLuaAppsEnablePromptVIPServerPurchase then props.isMonthlyPrice else nil
	v22.includePriceSuffixOnOriginal = v23
	v22.isCartPricingLoading = props.isCartPricingLoading
	local v24 = createElement(CartPricingProductDetails, v22)

	local createElement2 = React.createElement
	local root = sheet.Root
	local v25 = {
		onClose = props.buttons.cancelActivated,
		preferCenterSheet = true,
		ref = 0
	}

	if v6 then
		v12 = nil
	end

	v25.ref = v12

	local createElement3 = React.createElement
	local header = sheet.Header

	local v27 = if fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then props.hideUserRobuxBalance and true or nil else nil

	local createElement4 = React.createElement
	local v30 = {
		titleText = state2,
		robuxBalanceAmount = props.robuxBalanceAmount,
		hideUserRobuxBalance = 0
	}

	local v31 = if fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then props.hideUserRobuxBalance else nil
	v30.hideUserRobuxBalance = v31
	local children = {
		Header = createElement3(header, { hasCloseAffordance = v27 }, {
			ModalHeader = createElement4(UnifiedPurchaseModalHeader, v30)
		}),
		Content = 0,
		Actions = 0
	}

	local createElement5 = React.createElement
	local content = sheet.Content

	local createElement6 = React.createElement

	if not v24 then
		local createElement7 = React.createElement
		local v40

		if props.purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
			v40 = React.createElement(PriceSummary, { amount = v18, itemPrice = itemPrice })
		else
			local createElement8 = React.createElement
			local v42 = {
				isPortrait = false,
				itemIcon = props.product.itemIcon,
				itemName = props.product.itemName,
				itemRobuxCost = v18,
				itemPrice = itemPrice,
				itemDisplayPrice = 0,
				priceSuffix = 0,
				model = 0
			}

			local v43 = if fFlagEnableUnifiedPurchaseFlowForDevSubs then props.product.itemDisplayPrice else nil
			v42.itemDisplayPrice = v43

			v42.priceSuffix = perMonth
			v42.model = props.product.model
			v40 = createElement8(UnifiedProductDetails, v42)
		end

		v24 = createElement7(
			view,
			{
				tag = "col gap-medium auto-y size-full-0 align-x-center align-y-center",
				LayoutOrder = 1
			},
			{ ProductDetails = v40 }
		)
	end

	children.Content = createElement5(content, { LayoutOrder = 2 }, {
		SheetContentContainer = createElement6(
			view,
			{ tag = "col gap-medium auto-y size-full-0 align-x-center align-y-center" },
			{ ProductDetailsContainer = v24, PostPurchaseActions = element }
		)
	})

	local createElement7 = React.createElement
	local actions = sheet.Actions

	local createElement8 = React.createElement

	local v41 = {
		BuyButton = React.createElement(button, {
			text = v15,
			onActivated = v14,
			inputDelay = props.buttons.buyItemEnableInputDelayed and not v6 and 2.5 or 0,
			isDisabled = isDisabled,
			ref = v13,
			fillBehavior = fillBehavior.Fill,
			variant = buttonVariant.Emphasis,
			LayoutOrder = 1
		}),
		BlackbirdUpsellBanner = 0,
		TestPurchaseDisclaimer = 0,
		SubscribeTerms = 0
	}
	local v42

	if props.BlackbirdUpsellBannerProductInfo and props.onBlackbirdUpsellActivated then
		local createElement9 = React.createElement
		local v44 = {
			productInfo = props.BlackbirdUpsellBannerProductInfo,
			onActivated = props.onBlackbirdUpsellActivated,
			bannerText = 0,
			LayoutOrder = 2
		}

		local v45 = if fFlagLuaAppsEnablePromptVIPServerPurchase and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.VIPServer then v5.FreeWithPlus else nil
		v44.bannerText = v45
		v42 = createElement9(blackbirdUpsellBanner, v44)
	end

	v41.BlackbirdUpsellBanner = v42

	local v43 = if props.isTestPurchase then React.createElement(text, {
		Text = v5.TestPurchaseDisclaimer,
		tag = "auto-y size-full-0 text-caption-small text-align-x-center text-wrap wrap",
		LayoutOrder = 3
	}) else nil
	v41.TestPurchaseDisclaimer = v43

	v41.SubscribeTerms = v20
	children.Actions = createElement7(actions, { LayoutOrder = 3 }, {
		createElement8(
			view,
			{
				tag = "row wrap auto-xy align-y-center align-x-center size-full-0 gap-medium",
				LayoutOrder = 1
			},
			v41
		)
	})
	return createElement2(root, v25, children)
end

local function UnifiedProductPurchaseModalContainer(p2)
	return React.createElement(
		localizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			ProductPurchaseModal = React.createElement(UnifiedProductPurchaseModal, p2)
		}
	)
end

return UnifiedProductPurchaseModalContainer
