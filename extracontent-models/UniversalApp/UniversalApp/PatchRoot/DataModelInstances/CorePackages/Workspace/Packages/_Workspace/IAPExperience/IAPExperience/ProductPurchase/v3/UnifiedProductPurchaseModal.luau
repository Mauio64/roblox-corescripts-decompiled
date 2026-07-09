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
local FFlagFixUnifiedModalsMountedTwice = require(ParentParent.Flags.FFlagFixUnifiedModalsMountedTwice)
local FFlagAddFocusNavigationToUnifiedPurchase = require(ParentParent.Flags.FFlagAddFocusNavigationToUnifiedPurchase)
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require(ParentParent.Parent.SharedFlags).FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local FFlagEnableDiscountInfoInUnifiedPurchaseModal = require(ParentParent.Parent.SharedFlags).FFlagEnableDiscountInfoInUnifiedPurchaseModal

require(ParentParent.ProductPurchase.PricingTypes)

local BlackbirdUpsellBanner = require(ParentParentParent.RobloxSubscriptionPurchaseApp).Components.BlackbirdUpsellBanner

local function UnifiedProductPurchaseModal(t1: {[any]: any}) -- line: 90
	-- upvalues: useLocalization (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), UrlBuilder (copy), UnifiedPurchaseModalTypeEnum (copy), React (copy), useInitialButtonDisableDelay (copy), FFlagFixUnifiedModalsMountedTwice (copy), FFlagAddFocusNavigationToUnifiedPurchase (copy), useFocusNavigationRefs (copy), Checkbox (copy), FFlagEnableDiscountInfoInUnifiedPurchaseModal (copy), FoundationText (copy), ProductDetailsContainer (copy), Sheet (copy), UnifiedPurchaseModalHeader (copy), View (copy), PriceSummary (copy), UnifiedProductDetails (copy), Button (copy), FillBehavior (copy), ButtonVariant (copy), BlackbirdUpsellBanner (copy)
	local v34 = useLocalization({
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
	local v35 = if not FFlagEnableUnifiedPurchaseFlowForDevSubs or t1.purchaseModalType ~= UnifiedPurchaseModalTypeEnum.DeveloperSubscription then nil else v34.PerMonth
	local v36, v37 = React.useState(t1.postPurchaseActions or {})
	local v38, v39 = React.useState(v34.BuyItem)
	local v40 = useInitialButtonDisableDelay(t1.buttons.isDisabled)

	React.useEffect(function() -- line: 127
		-- upvalues: t1 (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), UnifiedPurchaseModalTypeEnum (copy), v39 (copy), v34 (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy)
		local purchaseModalType = t1.purchaseModalType

		if FFlagEnableUnifiedPurchaseFlowForDevSubs and purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription then
			v39(v34.GetSubscription)

			return
		end

		if purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
			if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
				v39(v34.BuyAvatar)

				return
			end

			v39(v34.BuyItems)

			return
		end

		if purchaseModalType == UnifiedPurchaseModalTypeEnum.Experience then
			v39(v34.BuyExperience)

			return
		end

		if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
			v39(v34.BuyItemV2)

			return
		end

		v39(v34.BuyItem)
	end, { t1.purchaseModalType })

	local v41 = React.useCallback(function(p1) -- line: 151
		-- upvalues: t1 (copy)
		if p1 and t1.onBuyItemButtonMounted then
			t1.onBuyItemButtonMounted(p1)
		end
	end, { t1.onBuyItemButtonMounted })

	if FFlagFixUnifiedModalsMountedTwice then
		v41 = React.useCallback(function(p2) -- line: 160
			-- upvalues: t1 (copy), v40 (copy)
			if p2 and (t1.onBuyItemButtonMounted and not v40) then
				t1.onBuyItemButtonMounted(p2)
			end
		end, {
			t1.onBuyItemButtonMounted,
			v40
		})
	end

	local v42 = nil
	local v43 = nil

	if FFlagAddFocusNavigationToUnifiedPurchase then
		v42, v43 = useFocusNavigationRefs(t1.buttons.cancelActivated, t1.onBuyItemButtonMounted)
	end

	local v44 = React.useCallback(function() -- line: 174
		-- upvalues: v36 (copy), t1 (copy)
		if v36 and t1.setPostPurchaseActions then
			t1.setPostPurchaseActions(v36)
		end

		t1.buttons.buyItemActivated()
	end, {
		t1.buttons.buyItemActivated,
		v36
	})

	React.useEffect(function() -- line: 182
		-- upvalues: v37 (copy), t1 (copy)
		v37(t1.postPurchaseActions or {})
	end, { t1.postPurchaseActions })

	local v45 = if not FFlagEnableUnifiedPurchaseFlowForDevSubs or t1.purchaseModalType ~= UnifiedPurchaseModalTypeEnum.DeveloperSubscription then v34.Buy else v34.Subscribe
	local v46 = React.useMemo(function() -- line: 191
		-- upvalues: v36 (copy), React (copy), Checkbox (copy), v40 (copy), v37 (copy)
		local t2 = {}

		for i, v in ipairs(v36 or {}) do
			t2["PostPurchaseActionCheckBox_" .. tostring(i)] = React.createElement(Checkbox, {
				size = "XSmall",
				LayoutOrder = i,
				label = v.label,
				isChecked = not v40 and v.isActionSelected,
				isDisabled = v40,
				onActivated = function() -- line: 200
					-- upvalues: v37 (copy), i (copy), v (copy)
					v37(function(p3) -- line: 201
						-- upvalues: i (copy), v (copy)
						local v61 = table.clone(p3)

						v61[i] = {
							label = v.label,
							isActionSelected = not v.isActionSelected,
							actionKey = v.actionKey
						}

						return v61
					end)
				end
			})
		end

		return t2
	end, {
		v36,
		v40
	})
	local v47 = if not FFlagEnableDiscountInfoInUnifiedPurchaseModal then nil else t1.product.itemPrice
	local v48 = if not v47 then t1.product.itemRobuxCost else v47.priceInRobux
	local v49 = nil

	if FFlagEnableUnifiedPurchaseFlowForDevSubs and t1.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription then
		local v50 = string.gsub(v34.SubscribeTermsAgreement or "", "<a.->(.-)</a>", "%1")
		local v51 = string.gsub(v50, "<.->", "")

		v49 = React.createElement(FoundationText, {
			LayoutOrder = 4,
			tag = "wrap size-full-0 auto-y text-caption-small text-wrap text-align-x-left",
			Text = v51
		})
	end

	local v52 = React.createElement(ProductDetailsContainer, {
		purchaseModalType = t1.purchaseModalType,
		product = t1.product,
		priceSuffix = v35
	})

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		onClose = t1.buttons.cancelActivated,
		ref = if not v40 then if not FFlagAddFocusNavigationToUnifiedPurchase then nil else v42 else nil
	}, {
		Header = React.createElement(Sheet.Header, {
			hasCloseAffordance = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else not not t1.hideUserRobuxBalance or nil
		}, {
			ModalHeader = React.createElement(UnifiedPurchaseModalHeader, {
				titleText = v38,
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
				ProductDetailsContainer = v52 or React.createElement(View, {
					tag = "col gap-medium auto-y size-full-0 align-x-center align-y-center",
					LayoutOrder = 1
				}, {
					ProductDetails = if t1.purchaseModalType ~= UnifiedPurchaseModalTypeEnum.MultiItem then React.createElement(UnifiedProductDetails, {
						isPortrait = false,
						itemIcon = t1.product.itemIcon,
						itemName = t1.product.itemName,
						itemRobuxCost = v48,
						itemPrice = v47,
						itemDisplayPrice = if not FFlagEnableUnifiedPurchaseFlowForDevSubs then nil else t1.product.itemDisplayPrice,
						priceSuffix = v35,
						model = t1.product.model
					}) else React.createElement(PriceSummary, {
						amount = v48,
						itemPrice = v47
					})
				}),
				PostPurchaseActions = if not next(v46) then nil else React.createElement(View, {
					LayoutOrder = 3,
					tag = not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "col gap-medium auto-y size-full-0 align-x-start align-y-start" or "col gap-medium auto-y size-full-0 align-x-start align-y-start padding-top-small"
				}, { v46 })
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
				text = v45,
				onActivated = v44,
				inputDelay = (not t1.buttons.buyItemEnableInputDelayed or v40) and 0 or 2.5,
				isDisabled = v40,
				ref = if not FFlagAddFocusNavigationToUnifiedPurchase then v41 else v43,
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
				Text = v34.TestPurchaseDisclaimer
			}),
			SubscribeTerms = v49
		}) })
	})
end
local function UnifiedProductPurchaseModalContainer(t3: {[any]: any}) -- line: 341
	-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), UnifiedProductPurchaseModal (copy)
	return React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		ProductPurchaseModal = React.createElement(UnifiedProductPurchaseModal, t3)
	})
end

return UnifiedProductPurchaseModalContainer
