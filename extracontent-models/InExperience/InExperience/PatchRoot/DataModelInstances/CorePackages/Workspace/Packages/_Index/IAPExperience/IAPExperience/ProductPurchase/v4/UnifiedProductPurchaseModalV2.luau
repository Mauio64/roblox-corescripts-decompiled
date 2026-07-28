local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local BlackbirdUpsellBanner = require(ParentParentParent.RobloxSubscriptionPurchaseApp).Components.BlackbirdUpsellBanner
local Foundation = require(ParentParentParent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local Checkbox = Foundation.Checkbox
local View = Foundation.View
local DialogSize = Foundation.Enums.DialogSize
local ProductDetailsContainer = require(ParentParent.Generic.ProductDetailsContainer)
local CartPricingProductDetails = require(script.Parent.CartPricingProductDetails)
local buildCartPricingOfferCheckboxes = require(script.Parent.buildCartPricingOfferCheckboxes)
local useCartPricing = require(script.Parent.useCartPricing)
local useFocusNavigationRefs = require(ParentParent.Generic.Hooks.useFocusNavigationRefs)
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(ParentParentParent.AppLocales).Localization
local Localization2 = require(ParentParentParent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local useLocalization = Localization2.Hooks.useLocalization
local UrlBuilder = require(ParentParentParent.UrlBuilder).UrlBuilder
local SubtitleComponentMap = require(script.Parent.SubtitleComponentMap)

require(script.Parent.Parent.v3.UnifiedProductPurchaseModalTypes)

local UnifiedPurchaseModalTypeEnum = require(ParentParent.Enums.UnifiedPurchaseModalTypeEnum)
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require(ParentParent.Parent.SharedFlags).FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local FFlagUnifiedPurchaseAddSkeleton = require(ParentParent.Parent.SharedFlags).FFlagUnifiedPurchaseAddSkeleton
local FFlagEnableUnifiedPurchaseFlowForDevSubs = require(ParentParent.Parent.SharedFlags).FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagPurchasePromptFetchCartPricing = require(ParentParent.Parent.SharedFlags).FFlagPurchasePromptFetchCartPricing

require(script.Parent.cartPricingResponseLineItem)

local function UnifiedProductPurchaseModalV2(t1: {[any]: any}) -- line: 102
	-- upvalues: useLocalization (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), UrlBuilder (copy), UnifiedPurchaseModalTypeEnum (copy), FFlagPurchasePromptFetchCartPricing (copy), useCartPricing (copy), React (copy), useFocusNavigationRefs (copy), FFlagUnifiedPurchaseAddSkeleton (copy), Checkbox (copy), SubtitleComponentMap (copy), ProductDetailsContainer (copy), CartPricingProductDetails (copy), buildCartPricingOfferCheckboxes (copy), View (copy), ButtonVariant (copy), Foundation (copy), Dialog (copy), DialogSize (copy), BlackbirdUpsellBanner (copy)
	local v31 = useLocalization({
		Buy = "IAPExperience.PurchasePrompt.Action.Buy",
		Subscribe = "Feature.Subscription.Action.Subscribe",
		BuyItem = "IAPExperience.PurchasePrompt.Title.BuyItem",
		GetSubscription = "IAPExperience.SubscriptionPurchasePrompt.Label.GetSubscription",
		BuyExperience = "IAPExperience.PurchasePrompt.Title.BuyExperience",
		BuyItems = "IAPExperience.PurchasePrompt.Title.BuyItems",
		TestPurchaseDisclaimer = "IAPExperience.PurchasePrompt.Text.TestPurchase",
		BuyItemV2 = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else "IAPExperience.PurchasePrompt.Title.BuyItemV2",
		BuyAvatar = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else "IAPExperience.PurchasePrompt.Header.BuyAvatar",
		PerMonth = if not FFlagEnableUnifiedPurchaseFlowForDevSubs then nil else "Feature.Subscription.Text.PerMonth",
		SubscribeTermsAgreement = if not FFlagEnableUnifiedPurchaseFlowForDevSubs then nil else {
			"Feature.Subscription.Footer.PurchasePromptLegalText",
			SubscribeButtonTitle = "\"Subscribe\"",
			tosUrl = UrlBuilder.static.about.terms()
		}
	})
	local v32 = if not FFlagEnableUnifiedPurchaseFlowForDevSubs or t1.purchaseModalType ~= UnifiedPurchaseModalTypeEnum.DeveloperSubscription then nil else v31.PerMonth
	local v33 = nil

	if FFlagPurchasePromptFetchCartPricing then
		v33 = useCartPricing({
			product = t1.product,
			purchaseModalType = t1.purchaseModalType,
			cartPricingResponse = t1.cartPricingResponse,
			onCartOfferAppliedChanged = t1.onCartOfferAppliedChanged
		})
	end

	local v34, v35 = React.useState(t1.postPurchaseActions or {})
	local purchaseModalType = t1.purchaseModalType
	local v37 = if not FFlagEnableUnifiedPurchaseFlowForDevSubs or purchaseModalType ~= UnifiedPurchaseModalTypeEnum.DeveloperSubscription then if purchaseModalType ~= UnifiedPurchaseModalTypeEnum.MultiItem then if purchaseModalType ~= UnifiedPurchaseModalTypeEnum.Experience then v31.BuyItemV2 else v31.BuyExperience else v31.BuyAvatar else v31.GetSubscription
	local v38, v39 = useFocusNavigationRefs(t1.buttons.cancelActivated, t1.onBuyItemButtonMounted)
	local v40 = React.useCallback(function() -- line: 160
		-- upvalues: v34 (copy), t1 (copy)
		if v34 and t1.setPostPurchaseActions then
			t1.setPostPurchaseActions(v34)
		end

		t1.buttons.buyItemActivated()
	end, {
		t1.buttons.buyItemActivated,
		v34
	})

	React.useEffect(function() -- line: 168
		-- upvalues: v35 (copy), t1 (copy)
		v35(t1.postPurchaseActions or {})
	end, { t1.postPurchaseActions })

	local u41 = nil
	local n1 = 0

	if FFlagPurchasePromptFetchCartPricing then
		u41 = t1.buttons.isDisabled or (FFlagPurchasePromptFetchCartPricing and t1.isCartPricingLoading == true or FFlagUnifiedPurchaseAddSkeleton and t1.isLoading == true)
		n1 = not v33.showCartOfferUi and 0 or #v33.cartPricingOffers
	end

	local v43 = if FFlagPurchasePromptFetchCartPricing then React.useMemo(function() -- line: 213
		-- upvalues: v34 (copy), React (copy), Checkbox (copy), n1 (ref), u41 (ref), v35 (copy)
		local t2 = {}

		for v61, v62 in v34 do
			t2[v62.actionKey] = React.createElement(Checkbox, {
				size = "XSmall",
				LayoutOrder = n1 + v61,
				label = v62.label,
				isChecked = v62.isActionSelected,
				isDisabled = u41,
				onActivated = function() -- line: 222
					-- upvalues: v35 (copy), v61 (copy), v62 (copy)
					v35(function(p1) -- line: 223
						-- upvalues: v61 (copy), v62 (copy)
						local v66 = table.clone(p1)

						v66[v61] = {
							label = v62.label,
							isActionSelected = not v62.isActionSelected,
							actionKey = v62.actionKey
						}

						return v66
					end)
				end
			})
		end

		return t2
	end, {
		v34,
		n1,
		u41
	}) else React.useMemo(function() -- line: 185
		-- upvalues: v34 (copy), React (copy), Checkbox (copy), t1 (copy), FFlagUnifiedPurchaseAddSkeleton (copy), v35 (copy)
		local t3 = {}

		for i, v in ipairs(v34 or {}) do
			t3["PostPurchaseActionCheckBox_" .. tostring(i)] = React.createElement(Checkbox, {
				size = "XSmall",
				LayoutOrder = i,
				label = v.label,
				isChecked = v.isActionSelected,
				isDisabled = t1.buttons.isDisabled or if not FFlagUnifiedPurchaseAddSkeleton then nil else t1.isLoading,
				onActivated = function() -- line: 196
					-- upvalues: v35 (copy), i (copy), v (copy)
					v35(function(p2) -- line: 197
						-- upvalues: i (copy), v (copy)
						local v64 = table.clone(p2)

						v64[i] = {
							label = v.label,
							isActionSelected = not v.isActionSelected,
							actionKey = v.actionKey
						}

						return v64
					end)
				end
			})
		end

		return t3
	end, {
		v34,
		if not FFlagUnifiedPurchaseAddSkeleton then nil else t1.isLoading
	})
	local v44 = nil

	if t1.subtitleView then
		local v45 = SubtitleComponentMap[t1.subtitleView.componentName]

		if v45 then
			v44 = React.createElement(v45, t1.subtitleView.props)
		end
	end

	local v46 = React.createElement(ProductDetailsContainer, {
		purchaseModalType = t1.purchaseModalType,
		product = t1.product,
		subtitleView = v44,
		priceSuffix = v32,
		isLoading = if not FFlagUnifiedPurchaseAddSkeleton then nil else t1.isLoading
	})

	if FFlagPurchasePromptFetchCartPricing then
		v46 = React.createElement(CartPricingProductDetails, {
			cartPricing = v33,
			purchaseModalType = t1.purchaseModalType,
			subtitleView = v44,
			priceSuffix = v32,
			isLoading = t1.isLoading,
			isCartPricingLoading = t1.isCartPricingLoading
		})
	end

	local v47 = nil
	local v48 = nil

	if FFlagPurchasePromptFetchCartPricing then
		v47 = buildCartPricingOfferCheckboxes({
			cartPricing = v33,
			isDisabled = u41
		})
		v48 = table.clone(v47)

		for k, v in pairs(v43) do
			v48[k] = v
		end
	end

	local v51 = if not (not not FFlagPurchasePromptFetchCartPricing and (next(v47) or next(v43))) and (FFlagPurchasePromptFetchCartPricing or not next(v43)) then nil else React.createElement(View, {
		tag = "col gap-medium auto-y size-full-0 align-x-start align-y-start",
		LayoutOrder = 1
	}, if not FFlagPurchasePromptFetchCartPricing then { v43 } else v48)
	local t4 = {{
		text = if not FFlagEnableUnifiedPurchaseFlowForDevSubs or t1.purchaseModalType ~= UnifiedPurchaseModalTypeEnum.DeveloperSubscription then v31.Buy else v31.Subscribe,
		variant = ButtonVariant.Emphasis,
		onActivated = v40,
		isDisabled = if not FFlagPurchasePromptFetchCartPricing then t1.buttons.isDisabled or if not FFlagUnifiedPurchaseAddSkeleton then nil else t1.isLoading else u41,
		ref = v39,
		inputDelay = (not t1.buttons.buyItemEnableInputDelayed or t1.buttons.isDisabled) and 0 or 2.5
	}}
	local v53 = nil

	if FFlagEnableUnifiedPurchaseFlowForDevSubs and t1.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription then
		local v54 = string.gsub(v31.SubscribeTermsAgreement or "", "<a.->(.-)</a>", "%1")
		local v55 = string.gsub(v54, "<.->", "")

		v53 = React.createElement(Foundation.Text, {
			LayoutOrder = 6,
			tag = "wrap size-full-0 auto-y text-caption-small text-wrap text-align-x-left",
			Text = v55
		})
	end

	return React.createElement(Dialog.Root, {
		disablePortal = false,
		size = DialogSize.Medium,
		onClose = t1.buttons.cancelActivated,
		ref = v38
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			text = v37
		}),
		DialogContent = React.createElement(View, {
			tag = "col gap-medium auto-y size-full-0 align-x-center align-y-center",
			LayoutOrder = 1
		}, {
			ProductDetailsContainer = v46
		}),
		ActionsSection = React.createElement(View, {
			tag = "col size-full-0 auto-y gap-xlarge",
			LayoutOrder = 3
		}, {
			PostPurchaseActions = v51,
			BuyAndUpsell = React.createElement(View, {
				tag = "col size-full-0 auto-y gap-medium",
				LayoutOrder = 2
			}, {
				DialogActions = React.createElement(Dialog.Actions, {
					LayoutOrder = 1,
					orientation = Foundation.Enums.Orientation.Horizontal,
					actions = t4
				}),
				BlackbirdUpsellBanner = if not t1.BlackbirdUpsellBannerProductInfo or not t1.onBlackbirdUpsellActivated then nil else React.createElement(BlackbirdUpsellBanner, {
					LayoutOrder = 2,
					productInfo = t1.BlackbirdUpsellBannerProductInfo,
					onActivated = t1.onBlackbirdUpsellActivated
				})
			})
		}),
		TestDisclaimer = if not t1.isTestPurchase then nil else React.createElement(Foundation.Text, {
			LayoutOrder = 5,
			tag = "auto-y size-full-0 text-caption-small text-align-x-center text-wrap wrap",
			Text = v31.TestPurchaseDisclaimer
		}),
		SubscribeTerms = v53
	})
end
local function UnifiedProductPurchaseModalV2Container(t5: {[any]: any}) -- line: 379
	-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), UnifiedProductPurchaseModalV2 (copy)
	return React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		ProductPurchaseModal = React.createElement(UnifiedProductPurchaseModalV2, t5)
	})
end

return UnifiedProductPurchaseModalV2Container
