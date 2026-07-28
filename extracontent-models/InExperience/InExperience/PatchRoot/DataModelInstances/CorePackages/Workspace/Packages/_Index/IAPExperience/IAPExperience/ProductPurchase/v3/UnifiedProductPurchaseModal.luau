local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Checkbox = Foundation.Checkbox
local Sheet = Foundation.Sheet
local Button = Foundation.Button
local View = Foundation.View
local FoundationText = Foundation.Text
local FillBehavior = Foundation.Enums.FillBehavior
local UnifiedProductDetails = require(ParentParent.Generic.UnifiedProductDetails)
local PriceSummary = require(ParentParent.Generic.PriceSummary)
local UnifiedPurchaseModalHeader = require(ParentParent.Generic.UnifiedPurchaseModalHeader)
local ProductDetailsContainer = require(ParentParent.Generic.ProductDetailsContainer)
local UrlBuilder = require(ParentParentParent.UrlBuilder).UrlBuilder
local useInitialButtonDisableDelay = require(ParentParent.Generic.Hooks.useInitialButtonDisableDelay)
local useFocusNavigationRefs = require(ParentParent.Generic.Hooks.useFocusNavigationRefs)
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(ParentParentParent.AppLocales).Localization
local Localization2 = require(ParentParentParent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local useLocalization = Localization2.Hooks.useLocalization

require(script.Parent.UnifiedProductPurchaseModalTypes)

local UnifiedPurchaseModalTypeEnum = require(ParentParent.Enums.UnifiedPurchaseModalTypeEnum)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = require(ParentParent.Parent.SharedFlags).FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require(ParentParent.Parent.SharedFlags).FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local FFlagEnableDiscountInfoInUnifiedPurchaseModal = require(ParentParent.Parent.SharedFlags).FFlagEnableDiscountInfoInUnifiedPurchaseModal

require(ParentParent.ProductPurchase.PricingTypes)

local BlackbirdUpsellBanner = require(ParentParentParent.RobloxSubscriptionPurchaseApp).Components.BlackbirdUpsellBanner

local function UnifiedProductPurchaseModal(t1: {[any]: any}) -- line: 87
	-- upvalues: useLocalization (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), UrlBuilder (copy), UnifiedPurchaseModalTypeEnum (copy), React (copy), useInitialButtonDisableDelay (copy), useFocusNavigationRefs (copy), Checkbox (copy), FFlagEnableDiscountInfoInUnifiedPurchaseModal (copy), FoundationText (copy), ProductDetailsContainer (copy), Sheet (copy), UnifiedPurchaseModalHeader (copy), View (copy), PriceSummary (copy), UnifiedProductDetails (copy), Button (copy), FillBehavior (copy), ButtonVariant (copy), BlackbirdUpsellBanner (copy)
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
	local v34, v35 = React.useState(t1.postPurchaseActions or {})
	local v36, v37 = React.useState(v32.BuyItem)
	local v38 = useInitialButtonDisableDelay(t1.buttons.isDisabled)

	React.useEffect(function() -- line: 124
		-- upvalues: t1 (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), UnifiedPurchaseModalTypeEnum (copy), v37 (copy), v32 (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy)
		local purchaseModalType = t1.purchaseModalType

		if FFlagEnableUnifiedPurchaseFlowForDevSubs and purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription then
			v37(v32.GetSubscription)

			return
		end

		if purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
			if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
				v37(v32.BuyAvatar)

				return
			end

			v37(v32.BuyItems)

			return
		end

		if purchaseModalType == UnifiedPurchaseModalTypeEnum.Experience then
			v37(v32.BuyExperience)

			return
		end

		if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
			v37(v32.BuyItemV2)

			return
		end

		v37(v32.BuyItem)
	end, { t1.purchaseModalType })

	local v39, v40 = useFocusNavigationRefs(t1.buttons.cancelActivated, t1.onBuyItemButtonMounted)
	local v41 = React.useCallback(function() -- line: 150
		-- upvalues: v34 (copy), t1 (copy)
		if v34 and t1.setPostPurchaseActions then
			t1.setPostPurchaseActions(v34)
		end

		t1.buttons.buyItemActivated()
	end, {
		t1.buttons.buyItemActivated,
		v34
	})

	React.useEffect(function() -- line: 158
		-- upvalues: v35 (copy), t1 (copy)
		v35(t1.postPurchaseActions or {})
	end, { t1.postPurchaseActions })

	local v42 = if not FFlagEnableUnifiedPurchaseFlowForDevSubs or t1.purchaseModalType ~= UnifiedPurchaseModalTypeEnum.DeveloperSubscription then v32.Buy else v32.Subscribe
	local v43 = React.useMemo(function() -- line: 167
		-- upvalues: v34 (copy), React (copy), Checkbox (copy), v38 (copy), v35 (copy)
		local t2 = {}

		for i, v in ipairs(v34 or {}) do
			t2["PostPurchaseActionCheckBox_" .. tostring(i)] = React.createElement(Checkbox, {
				size = "XSmall",
				LayoutOrder = i,
				label = v.label,
				isChecked = not v38 and v.isActionSelected,
				isDisabled = v38,
				onActivated = function() -- line: 176
					-- upvalues: v35 (copy), i (copy), v (copy)
					v35(function(p1) -- line: 177
						-- upvalues: i (copy), v (copy)
						local v56 = table.clone(p1)

						v56[i] = {
							label = v.label,
							isActionSelected = not v.isActionSelected,
							actionKey = v.actionKey
						}

						return v56
					end)
				end
			})
		end

		return t2
	end, {
		v34,
		v38
	})
	local v44 = if not FFlagEnableDiscountInfoInUnifiedPurchaseModal then nil else t1.product.itemPrice
	local v45 = if not v44 then t1.product.itemRobuxCost else v44.priceInRobux
	local v46 = nil

	if FFlagEnableUnifiedPurchaseFlowForDevSubs and t1.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription then
		local v47 = string.gsub(v32.SubscribeTermsAgreement or "", "<a.->(.-)</a>", "%1")
		local v48 = string.gsub(v47, "<.->", "")

		v46 = React.createElement(FoundationText, {
			LayoutOrder = 4,
			tag = "wrap size-full-0 auto-y text-caption-small text-wrap text-align-x-left",
			Text = v48
		})
	end

	local v49 = React.createElement(ProductDetailsContainer, {
		purchaseModalType = t1.purchaseModalType,
		product = t1.product,
		priceSuffix = v33
	})

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		onClose = t1.buttons.cancelActivated,
		ref = if not v38 then v39 else nil
	}, {
		Header = React.createElement(Sheet.Header, {
			hasCloseAffordance = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else not not t1.hideUserRobuxBalance or nil
		}, {
			ModalHeader = React.createElement(UnifiedPurchaseModalHeader, {
				titleText = v36,
				robuxBalanceAmount = t1.robuxBalanceAmount,
				hideUserRobuxBalance = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else t1.hideUserRobuxBalance
			})
		}),
		Content = React.createElement(Sheet.Content, {
			LayoutOrder = 2
		}, {
			SheetContentContainer = React.createElement(View, {
				tag = "col gap-medium auto-y size-full-0 align-x-center align-y-center"
			}, {
				ProductDetailsContainer = v49 or React.createElement(View, {
					tag = "col gap-medium auto-y size-full-0 align-x-center align-y-center",
					LayoutOrder = 1
				}, {
					ProductDetails = if t1.purchaseModalType ~= UnifiedPurchaseModalTypeEnum.MultiItem then React.createElement(UnifiedProductDetails, {
						isPortrait = false,
						itemIcon = t1.product.itemIcon,
						itemName = t1.product.itemName,
						itemRobuxCost = v45,
						itemPrice = v44,
						itemDisplayPrice = if not FFlagEnableUnifiedPurchaseFlowForDevSubs then nil else t1.product.itemDisplayPrice,
						priceSuffix = v33,
						model = t1.product.model
					}) else React.createElement(PriceSummary, {
						amount = v45,
						itemPrice = v44
					})
				}),
				PostPurchaseActions = if not next(v43) then nil else React.createElement(View, {
					LayoutOrder = 3,
					tag = not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "col gap-medium auto-y size-full-0 align-x-start align-y-start" or "col gap-medium auto-y size-full-0 align-x-start align-y-start padding-top-small"
				}, { v43 })
			})
		}),
		Actions = React.createElement(Sheet.Actions, {
			LayoutOrder = 3
		}, { React.createElement(View, {
			tag = "row wrap auto-xy align-y-center align-x-center size-full-0 gap-medium",
			LayoutOrder = 1
		}, {
			BuyButton = React.createElement(Button, {
				LayoutOrder = 1,
				text = v42,
				onActivated = v41,
				inputDelay = (not t1.buttons.buyItemEnableInputDelayed or v38) and 0 or 2.5,
				isDisabled = v38,
				ref = v40,
				fillBehavior = FillBehavior.Fill,
				variant = ButtonVariant.Emphasis
			}),
			BlackbirdUpsellBanner = if not t1.BlackbirdUpsellBannerProductInfo or not t1.onBlackbirdUpsellActivated then nil else React.createElement(BlackbirdUpsellBanner, {
				LayoutOrder = 2,
				productInfo = t1.BlackbirdUpsellBannerProductInfo,
				onActivated = t1.onBlackbirdUpsellActivated
			}),
			TestPurchaseDisclaimer = if not t1.isTestPurchase then nil else React.createElement(FoundationText, {
				tag = "auto-y size-full-0 text-caption-small text-align-x-center text-wrap wrap",
				LayoutOrder = 3,
				Text = v32.TestPurchaseDisclaimer
			}),
			SubscribeTerms = v46
		}) })
	})
end
local function UnifiedProductPurchaseModalContainer(t3: {[any]: any}) -- line: 315
	-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), UnifiedProductPurchaseModal (copy)
	return React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		ProductPurchaseModal = React.createElement(UnifiedProductPurchaseModal, t3)
	})
end

return UnifiedProductPurchaseModalContainer
