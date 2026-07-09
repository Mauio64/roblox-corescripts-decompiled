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
local v27 = game:DefineFastFlag("UnifiedPurchaseFixTitleFlash", false)
local FFlagPurchasePromptFetchCartPricing = require(ParentParent.Parent.SharedFlags).FFlagPurchasePromptFetchCartPricing

require(script.Parent.cartPricingResponseLineItem)

local function UnifiedProductPurchaseModalV2(t1: {[any]: any}) -- line: 103
	-- upvalues: useLocalization (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), UrlBuilder (copy), UnifiedPurchaseModalTypeEnum (copy), FFlagPurchasePromptFetchCartPricing (copy), useCartPricing (copy), React (copy), v27 (copy), useFocusNavigationRefs (copy), FFlagUnifiedPurchaseAddSkeleton (copy), Checkbox (copy), SubtitleComponentMap (copy), ProductDetailsContainer (copy), CartPricingProductDetails (copy), buildCartPricingOfferCheckboxes (copy), View (copy), ButtonVariant (copy), Foundation (copy), Dialog (copy), DialogSize (copy), BlackbirdUpsellBanner (copy)
	local v32 = useLocalization({
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
	local v33 = if not FFlagEnableUnifiedPurchaseFlowForDevSubs or t1.purchaseModalType ~= UnifiedPurchaseModalTypeEnum.DeveloperSubscription then nil else v32.PerMonth
	local v34 = nil

	if FFlagPurchasePromptFetchCartPricing then
		v34 = useCartPricing({
			product = t1.product,
			purchaseModalType = t1.purchaseModalType,
			cartPricingResponse = t1.cartPricingResponse,
			onCartOfferAppliedChanged = t1.onCartOfferAppliedChanged
		})
	end

	local v35, v36 = React.useState(t1.postPurchaseActions or {})
	local u37 = nil
	local v38

	if not v27 then
		local v39

		v38, v39 = React.useState(v32.BuyItem)
		u37 = v39
		React.useEffect(function() -- line: 148
			-- upvalues: t1 (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), UnifiedPurchaseModalTypeEnum (copy), u37 (ref), v32 (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy)
			local purchaseModalType = t1.purchaseModalType

			if FFlagEnableUnifiedPurchaseFlowForDevSubs and purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription then
				u37(v32.GetSubscription)

				return
			end

			if purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
				if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
					u37(v32.BuyAvatar)

					return
				end

				u37(v32.BuyItems)

				return
			end

			if purchaseModalType == UnifiedPurchaseModalTypeEnum.Experience then
				u37(v32.BuyExperience)

				return
			end

			if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
				u37(v32.BuyItemV2)

				return
			end

			u37(v32.BuyItem)
		end, { t1.purchaseModalType })
	else
		local purchaseModalType = t1.purchaseModalType

		v38 = if not FFlagEnableUnifiedPurchaseFlowForDevSubs or purchaseModalType ~= UnifiedPurchaseModalTypeEnum.DeveloperSubscription then if purchaseModalType ~= UnifiedPurchaseModalTypeEnum.MultiItem then if purchaseModalType ~= UnifiedPurchaseModalTypeEnum.Experience then v32.BuyItemV2 else v32.BuyExperience else v32.BuyAvatar else v32.GetSubscription
	end

	local v41, v42 = useFocusNavigationRefs(t1.buttons.cancelActivated, t1.onBuyItemButtonMounted)
	local v43 = React.useCallback(function() -- line: 191
		-- upvalues: v35 (copy), t1 (copy)
		if v35 and t1.setPostPurchaseActions then
			t1.setPostPurchaseActions(v35)
		end

		t1.buttons.buyItemActivated()
	end, {
		t1.buttons.buyItemActivated,
		v35
	})

	React.useEffect(function() -- line: 199
		-- upvalues: v36 (copy), t1 (copy)
		v36(t1.postPurchaseActions or {})
	end, { t1.postPurchaseActions })

	local u44 = nil
	local n1 = 0

	if FFlagPurchasePromptFetchCartPricing then
		u44 = t1.buttons.isDisabled or (FFlagPurchasePromptFetchCartPricing and t1.isCartPricingLoading == true or FFlagUnifiedPurchaseAddSkeleton and t1.isLoading == true)
		n1 = not v34.showCartOfferUi and 0 or #v34.cartPricingOffers
	end

	local v46 = if FFlagPurchasePromptFetchCartPricing then React.useMemo(function() -- line: 244
		-- upvalues: v35 (copy), React (copy), Checkbox (copy), n1 (ref), u44 (ref), v36 (copy)
		local t2 = {}

		for v65, v66 in v35 do
			t2[v66.actionKey] = React.createElement(Checkbox, {
				size = "XSmall",
				LayoutOrder = n1 + v65,
				label = v66.label,
				isChecked = v66.isActionSelected,
				isDisabled = u44,
				onActivated = function() -- line: 253
					-- upvalues: v36 (copy), v65 (copy), v66 (copy)
					v36(function(p1) -- line: 254
						-- upvalues: v65 (copy), v66 (copy)
						local v70 = table.clone(p1)

						v70[v65] = {
							label = v66.label,
							isActionSelected = not v66.isActionSelected,
							actionKey = v66.actionKey
						}

						return v70
					end)
				end
			})
		end

		return t2
	end, {
		v35,
		n1,
		u44
	}) else React.useMemo(function() -- line: 216
		-- upvalues: v35 (copy), React (copy), Checkbox (copy), t1 (copy), FFlagUnifiedPurchaseAddSkeleton (copy), v36 (copy)
		local t3 = {}

		for i, v in ipairs(v35 or {}) do
			t3["PostPurchaseActionCheckBox_" .. tostring(i)] = React.createElement(Checkbox, {
				size = "XSmall",
				LayoutOrder = i,
				label = v.label,
				isChecked = v.isActionSelected,
				isDisabled = t1.buttons.isDisabled or if not FFlagUnifiedPurchaseAddSkeleton then nil else t1.isLoading,
				onActivated = function() -- line: 227
					-- upvalues: v36 (copy), i (copy), v (copy)
					v36(function(p2) -- line: 228
						-- upvalues: i (copy), v (copy)
						local v68 = table.clone(p2)

						v68[i] = {
							label = v.label,
							isActionSelected = not v.isActionSelected,
							actionKey = v.actionKey
						}

						return v68
					end)
				end
			})
		end

		return t3
	end, {
		v35,
		if not FFlagUnifiedPurchaseAddSkeleton then nil else t1.isLoading
	})
	local v47 = nil

	if t1.subtitleView then
		local v48 = SubtitleComponentMap[t1.subtitleView.componentName]

		if v48 then
			v47 = React.createElement(v48, t1.subtitleView.props)
		end
	end

	local v49 = React.createElement(ProductDetailsContainer, {
		purchaseModalType = t1.purchaseModalType,
		product = t1.product,
		subtitleView = v47,
		priceSuffix = v33,
		isLoading = if not FFlagUnifiedPurchaseAddSkeleton then nil else t1.isLoading
	})

	if FFlagPurchasePromptFetchCartPricing then
		v49 = React.createElement(CartPricingProductDetails, {
			cartPricing = v34,
			purchaseModalType = t1.purchaseModalType,
			subtitleView = v47,
			priceSuffix = v33,
			isLoading = t1.isLoading,
			isCartPricingLoading = t1.isCartPricingLoading
		})
	end

	local v50 = nil
	local v51 = nil

	if FFlagPurchasePromptFetchCartPricing then
		v50 = buildCartPricingOfferCheckboxes({
			cartPricing = v34,
			isDisabled = u44
		})
		v51 = table.clone(v50)

		for k, v in pairs(v46) do
			v51[k] = v
		end
	end

	local v54 = if not (not not FFlagPurchasePromptFetchCartPricing and (next(v50) or next(v46))) and (FFlagPurchasePromptFetchCartPricing or not next(v46)) then nil else React.createElement(View, {
		tag = "col gap-medium auto-y size-full-0 align-x-start align-y-start",
		LayoutOrder = 1
	}, if not FFlagPurchasePromptFetchCartPricing then { v46 } else v51)
	local t4 = {{
		text = if not FFlagEnableUnifiedPurchaseFlowForDevSubs or t1.purchaseModalType ~= UnifiedPurchaseModalTypeEnum.DeveloperSubscription then v32.Buy else v32.Subscribe,
		variant = ButtonVariant.Emphasis,
		onActivated = v43,
		isDisabled = if not FFlagPurchasePromptFetchCartPricing then t1.buttons.isDisabled or if not FFlagUnifiedPurchaseAddSkeleton then nil else t1.isLoading else u44,
		ref = v42,
		inputDelay = (not t1.buttons.buyItemEnableInputDelayed or t1.buttons.isDisabled) and 0 or 2.5
	}}
	local v56 = nil

	if FFlagEnableUnifiedPurchaseFlowForDevSubs and t1.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription then
		local v57 = string.gsub(v32.SubscribeTermsAgreement or "", "<a.->(.-)</a>", "%1")
		local v58 = string.gsub(v57, "<.->", "")

		v56 = React.createElement(Foundation.Text, {
			LayoutOrder = 6,
			tag = "wrap size-full-0 auto-y text-caption-small text-wrap text-align-x-left",
			Text = v58
		})
	end

	return React.createElement(Dialog.Root, {
		disablePortal = false,
		size = DialogSize.Medium,
		onClose = t1.buttons.cancelActivated,
		ref = v41
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			text = v38
		}),
		DialogContent = React.createElement(View, {
			tag = "col gap-medium auto-y size-full-0 align-x-center align-y-center",
			LayoutOrder = 1
		}, {
			ProductDetailsContainer = v49
		}),
		ActionsSection = React.createElement(View, {
			tag = "col size-full-0 auto-y gap-xlarge",
			LayoutOrder = 3
		}, {
			PostPurchaseActions = v54,
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
			Text = v32.TestPurchaseDisclaimer
		}),
		SubscribeTerms = v56
	})
end
local function UnifiedProductPurchaseModalV2Container(t5: {[any]: any}) -- line: 410
	-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), UnifiedProductPurchaseModalV2 (copy)
	return React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		ProductPurchaseModal = React.createElement(UnifiedProductPurchaseModalV2, t5)
	})
end

return UnifiedProductPurchaseModalV2Container
