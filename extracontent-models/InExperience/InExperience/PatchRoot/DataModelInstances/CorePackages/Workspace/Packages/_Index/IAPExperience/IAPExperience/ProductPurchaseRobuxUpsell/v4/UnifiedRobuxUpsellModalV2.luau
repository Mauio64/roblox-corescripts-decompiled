local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local SharedFlags = require(ParentParentParent.SharedFlags)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local FoundationImage = Foundation.Image
local Checkbox = Foundation.Checkbox
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local EnumsOrientation = Foundation.Enums.Orientation
local Enums = Foundation.Enums
local getIconRichText = Foundation.Utility.getIconRichText
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(ParentParentParent.AppLocales).Localization
local Localization2 = require(ParentParentParent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local useLocalization = Localization2.Hooks.useLocalization
local UnifiedProductDetails = require(ParentParent.Generic.UnifiedProductDetails)
local YellowBadge = require(ParentParent.Generic.YellowBadge)
local GrayBadge = require(ParentParent.Generic.GrayBadge)
local PriceSummary = require(ParentParent.Generic.PriceSummary)
local ProductDetailsContainer = require(ParentParent.Generic.ProductDetailsContainer)
local CartPricingLoading = require(ParentParent.ProductPurchase.v4.CartPricingLoading)
local buildCartPricingOfferCheckboxes = require(ParentParent.ProductPurchase.v4.buildCartPricingOfferCheckboxes)
local useCartPricing = require(ParentParent.ProductPurchase.v4.useCartPricing)
local useFocusNavigationRefs = require(ParentParent.Generic.Hooks.useFocusNavigationRefs)
local UnifiedPurchaseModalTypeEnum = require(ParentParent.Enums.UnifiedPurchaseModalTypeEnum)

require(ParentParent.ProductPurchase.v4.cartPricingResponseLineItem)

local formatNumber = require(ParentParent.Utility.formatNumber)
local getUpsellBadgeInfo = require(ParentParent.Utility.getUpsellBadgeInfo)
local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require(ParentParent.Parent.SharedFlags).FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local v35 = game:DefineFastInt("CompactUpsellModalBreakpoint", 400)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = require(ParentParent.Parent.SharedFlags).FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagPurchasePromptFetchCartPricing = SharedFlags.FFlagPurchasePromptFetchCartPricing
local FFlagShouldApplyDevSubsUpsellFix = require(ParentParent.Flags.FFlagShouldApplyDevSubsUpsellFix)
local FFlagShouldFixDevSubsFlashingTitle = require(ParentParent.Flags.FFlagShouldFixDevSubsFlashingTitle)
local GetFFlagIAPExperienceEnableMultiDisplayUpsell = require(ParentParent.Flags.GetFFlagIAPExperienceEnableMultiDisplayUpsell)
local GetFFlagIAPExperienceUseUpsellBadgeHelper = require(ParentParent.Flags.GetFFlagIAPExperienceUseUpsellBadgeHelper)

require(ParentParent.Api.PaymentsGateway.GetUpsellSuggestionsTypes)

local BadgeType = require(ParentParent.Enums.BadgeType)

require(ParentParent.Enums.VirtualItemBadgeType)
require(ParentParent.ProductPurchase.v3.UnifiedProductPurchaseModalTypes)

local function UpsellProductDetailsLegacyImpl(t1: {[any]: any}, t2: {[any]: any}) -- line: 94
	-- upvalues: BadgeType (copy), React (copy), View (copy), FoundationText (copy), formatNumber (copy), LocalizationService (copy), YellowBadge (copy)
	local v50 = if t1.badgeType ~= BadgeType.Popular then if t1.badgeType ~= BadgeType.LastPurchased then nil else t2.LastPurchased else t2.Popular
	local v51 = if t1.badgeType ~= BadgeType.Popular then nil else "icons/menu/fire_fill"
	local s1 = "size-full-1400 radius-medium padding-x-large row"
	local v53 = if not t1.selected then s1 .. " bg-surface-300 stroke-emphasis stroke-standard" else s1 .. " bg-surface-200 stroke-system-contrast stroke-thick"
	local v54 = not t1.isCompact and "auto-xy text-title-large content-emphasis text-align-x-left" or "auto-xy text-title-small content-emphasis text-align-x-left"
	local v55 = not t1.isCompact and "auto-xy text-title-large content-muted text-align-x-left" or "auto-xy text-title-small content-muted text-align-x-left"
	local v56 = not t1.isCompact and "auto-xy text-title-large content-emphasis text-align-x-right" or "auto-xy text-title-small content-emphasis text-align-x-right"

	return React.createElement(View, {
		LayoutOrder = t1.layoutOrder,
		onActivated = t1.onSelected,
		tag = v53,
		Size = if not t1.isCompact then nil else UDim2.new(1, 0, 0, 40)
	}, {
		LeftSide = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row gap-small align-y-center align-x-start",
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			RobuxAmount = React.createElement(FoundationText, {
				LayoutOrder = 1,
				Text = utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, t1.product.robuxAmount),
				tag = v54
			}),
			RobuxAmountBonus = t1.product.robuxAmountBeforeBonus and React.createElement(FoundationText, {
				LayoutOrder = 2,
				RichText = true,
				Text = "<s>" .. utf8.char(57346) .. formatNumber(LocalizationService.RobloxLocaleId, t1.product.robuxAmountBeforeBonus) .. "</s>",
				tag = v55
			})
		}),
		RightSide = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row align-y-center align-x-right gap-large",
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			Badge = if not v50 then nil else React.createElement(YellowBadge, {
				LayoutOrder = 1,
				Text = v50,
				Icon = v51
			}),
			RobuxPrice = React.createElement(FoundationText, {
				LayoutOrder = 2,
				Text = t1.product.price or "",
				tag = v56
			})
		})
	})
end
local function UpsellProductDetailsMultiDisplayImpl(t3: {[any]: any}, t4: {[any]: any}) -- line: 167
	-- upvalues: GetFFlagIAPExperienceUseUpsellBadgeHelper (copy), getUpsellBadgeInfo (copy), BadgeType (copy), Enums (copy), React (copy), View (copy), FoundationText (copy), getIconRichText (copy), formatNumber (copy), LocalizationService (copy), GrayBadge (copy)
	local text, icon

	if GetFFlagIAPExperienceUseUpsellBadgeHelper() then
		local v59 = getUpsellBadgeInfo(t3.badgeType, t4)

		text = v59.text
		icon = v59.icon
	else
		text = if t3.badgeType ~= BadgeType.Popular then if t3.badgeType ~= BadgeType.LastPurchased then if t3.badgeType ~= BadgeType.ForYou then if t3.badgeType ~= BadgeType.BetterValue then nil else t4.BetterValue else t4.ForYouItem else t4.LastPurchased else t4.Popular
		icon = if t3.badgeType ~= BadgeType.Popular then if t3.badgeType ~= BadgeType.ForYou then if t3.badgeType ~= BadgeType.BetterValue then nil else Enums.IconName.Tag else Enums.IconName.CircleStar else Enums.IconName.Flame
	end

	local s2 = "size-full-1400 radius-medium padding-x-large row"
	local v63 = if not t3.selected then s2 .. " bg-surface-300 stroke-emphasis stroke-standard" else s2 .. " bg-surface-200 stroke-system-contrast stroke-thick"
	local v64 = not t3.isCompact and "auto-xy text-title-large content-emphasis text-align-x-left" or "auto-xy text-title-small content-emphasis text-align-x-left"
	local v65 = not t3.isCompact and "auto-xy text-title-large content-muted text-align-x-left" or "auto-xy text-title-small content-muted text-align-x-left"
	local v66 = not t3.isCompact and "auto-xy text-title-large content-emphasis text-align-x-right" or "auto-xy text-title-small content-emphasis text-align-x-right"

	return React.createElement(View, {
		LayoutOrder = t3.layoutOrder,
		onActivated = t3.onSelected,
		tag = v63,
		Size = if not t3.isCompact then nil else UDim2.new(1, 0, 0, 40)
	}, {
		LeftSide = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row gap-small align-y-center align-x-start",
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			RobuxAmount = React.createElement(FoundationText, {
				LayoutOrder = 1,
				RichText = true,
				Text = getIconRichText(Enums.IconName.Robux) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, t3.product.robuxAmount),
				tag = v64
			}),
			RobuxAmountBonus = t3.product.robuxAmountBeforeBonus and React.createElement(FoundationText, {
				LayoutOrder = 2,
				RichText = true,
				Text = "<s>" .. getIconRichText(Enums.IconName.Robux) .. formatNumber(LocalizationService.RobloxLocaleId, t3.product.robuxAmountBeforeBonus) .. "</s>",
				tag = v65
			}),
			Badge = if not text then nil else React.createElement(GrayBadge, {
				LayoutOrder = 3,
				Text = text,
				iconName = icon
			})
		}),
		RightSide = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row align-y-center align-x-right gap-large",
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			RobuxPrice = React.createElement(FoundationText, {
				LayoutOrder = 2,
				Text = t3.product.price or "",
				tag = v66
			})
		})
	})
end
local function UpsellProductDetails(t5: {[any]: any}) -- line: 258
	-- upvalues: useLocalization (copy), GetFFlagIAPExperienceEnableMultiDisplayUpsell (copy), UpsellProductDetailsMultiDisplayImpl (copy), UpsellProductDetailsLegacyImpl (copy)
	local v68 = useLocalization({
		Popular = "IAPExperience.RobuxUpsell.Text.PopularItem",
		LastPurchased = "IAPExperience.RobuxUpsell.Text.LastPurchased",
		ForYouItem = "IAPExperience.RobuxUpsell.Text.ForYou",
		BetterValue = "IAPExperience.RobuxUpsell.Text.BetterValue",
		BestValue = "IAPExperience.RobuxUpsell.Text.BestValue"
	})

	if GetFFlagIAPExperienceEnableMultiDisplayUpsell() then
		return UpsellProductDetailsMultiDisplayImpl(t5, v68)
	end

	return UpsellProductDetailsLegacyImpl(t5, v68)
end
local function UnifiedRobuxUpsellModalV2(t6: {[any]: any}) -- line: 307
	-- upvalues: FFlagPurchasePromptFetchCartPricing (copy), useCartPricing (copy), React (copy), useLocalization (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), FFlagAXMISWithBlackbird (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), UnifiedPurchaseModalTypeEnum (copy), v35 (copy), FFlagShouldFixDevSubsFlashingTitle (copy), useFocusNavigationRefs (copy), buildCartPricingOfferCheckboxes (copy), Checkbox (copy), View (copy), FFlagShouldApplyDevSubsUpsellFix (copy), FoundationImage (copy), FoundationText (copy), ProductDetailsContainer (copy), Dialog (copy), DialogSize (copy), PriceSummary (copy), UnifiedProductDetails (copy), CartPricingLoading (copy), GetFFlagIAPExperienceEnableMultiDisplayUpsell (copy), UpsellProductDetails (copy), EnumsOrientation (copy), ButtonVariant (copy)
	local u70 = nil
	local u71 = nil
	local u72 = nil
	local v73 = nil
	local v74 = nil

	if FFlagPurchasePromptFetchCartPricing then
		u70 = useCartPricing({
			product = t6.product,
			purchaseModalType = t6.purchaseModalType,
			cartPricingResponse = t6.cartPricingResponse,
			onCartOfferAppliedChanged = t6.onCartOfferAppliedChanged
		})

		local v75, v76 = React.useState(t6.postPurchaseActions or {})

		u71 = v75
		u72 = v76
		v73 = React.useCallback(function() -- line: 327
			-- upvalues: u71 (ref), t6 (copy)
			if u71 and t6.setPostPurchaseActions then
				t6.setPostPurchaseActions(u71)
			end

			t6.buttons.buyItemActivated()
		end, {
			t6.buttons.buyItemActivated,
			t6.setPostPurchaseActions,
			u71
		})
		v74 = React.useMemo(function() -- line: 335
			-- upvalues: u70 (ref), t6 (copy)
			if u70.showCartOfferUi then
				return u70.mergedProductForDetails
			end

			return t6.product
		end, {
			t6.product,
			u70.showCartOfferUi,
			u70.mergedProductForDetails
		})
	end

	local v77 = useLocalization({
		Buy = "IAPExperience.PurchasePrompt.Action.Buy",
		DisclosurePayment = "IAPExperience.RobuxUpsell.Text.DisclosurePayment",
		DisclosureTermsURL = "IAPExperience.RobuxUpsell.Text.DisclosureTermsURL",
		TermsOfUse = "IAPExperience.RobuxUpsell.Text.TermsOfUse",
		BuyRobuxAndExperience = "IAPExperience.PurchasePrompt.BuyRobuxAndExperience",
		BuyRobuxAndItem = "IAPExperience.PurchasePrompt.Title.BuyRobuxAndItem",
		BuyRobuxAndItems = "IAPExperience.PurchasePrompt.Title.BuyRobuxAndItems",
		Subscribe = if not FFlagEnableUnifiedPurchaseFlowForDevSubs then nil else "Feature.Subscription.Action.Subscribe",
		BuyRobuxOnly = if not FFlagAXMISWithBlackbird then nil else "IAPExperience.PurchasePrompt.Title.BuyRobuxOnly",
		BuyRobuxAndAvatar = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else "IAPExperience.PurchasePrompt.Header.BuyRobuxAndAvatar",
		BuyRobuxAndSubscription = if not FFlagEnableUnifiedPurchaseFlowForDevSubs then nil else "IAPExperience.PurchasePrompt.BuyRobuxAndSubscription",
		PerMonth = if not FFlagEnableUnifiedPurchaseFlowForDevSubs then nil else "Feature.Subscription.Text.PerMonth"
	})
	local u78 = if not FFlagEnableUnifiedPurchaseFlowForDevSubs or t6.purchaseModalType ~= UnifiedPurchaseModalTypeEnum.DeveloperSubscription then t6.screenSize.Y < v35 else t6.screenSize.Y > 0 and t6.screenSize.Y < v35
	local v79, v80 = React.useState(v77.BuyRobuxAndItem)

	React.useEffect(function() -- line: 374
		-- upvalues: t6 (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), UnifiedPurchaseModalTypeEnum (copy), v77 (copy), FFlagShouldFixDevSubsFlashingTitle (copy), v80 (copy), FFlagAXMISWithBlackbird (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy)
		local purchaseModalType = t6.purchaseModalType

		if FFlagEnableUnifiedPurchaseFlowForDevSubs and purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription then
			local BuyRobuxAndItem = v77.BuyRobuxAndItem

			if FFlagShouldFixDevSubsFlashingTitle and v77.BuyRobuxAndSubscription and v77.BuyRobuxAndSubscription ~= "" then
				BuyRobuxAndItem = v77.BuyRobuxAndSubscription
			end

			v80(BuyRobuxAndItem)

			return
		end

		if purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
			if FFlagAXMISWithBlackbird then
				if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements and t6.product.itemName ~= "RobuxUpsell" then
					v80(v77.BuyRobuxAndAvatar)

					return
				end

				v80(v77.BuyRobuxOnly)

				return
			end

			if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
				v80(v77.BuyRobuxAndAvatar)

				return
			end

			v80(v77.BuyRobuxAndItems)

			return
		end

		if purchaseModalType == UnifiedPurchaseModalTypeEnum.Experience then
			v80(v77.BuyRobuxAndExperience)

			return
		end

		v80(v77.BuyRobuxAndItem)
	end, {
		t6.purchaseModalType,
		v77.BuyRobuxAndAvatar,
		v77.BuyRobuxAndExperience,
		v77.BuyRobuxAndItem,
		v77.BuyRobuxAndItems,
		v77.BuyRobuxAndSubscription,
		if not FFlagAXMISWithBlackbird then nil else t6.product.itemName,
		if not FFlagAXMISWithBlackbird then nil else v77.BuyRobuxOnly
	})

	local v81, v82 = useFocusNavigationRefs(t6.buttons.cancelPurchaseActivated, t6.onBuyItemButtonMounted)

	React.useEffect(function() -- line: 429
	end, { t6.upsellSuggestions })

	local parts = string.split(v77.DisclosureTermsURL, " {termsofuse} ")
	local TermsOfUse = v77.TermsOfUse

	if t6.termsOfUseActivated then
		TermsOfUse = "<u>" .. TermsOfUse .. "</u>"
	end

	local v85 = FFlagEnableUnifiedPurchaseFlowForDevSubs and t6.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	local v86 = if not v85 then nil else v77.PerMonth
	local v87 = if not v85 then v77.Buy else v77.Subscribe
	local u88 = nil
	local t7 = {}

	if FFlagPurchasePromptFetchCartPricing then
		u88 = t6.buttons.buyItemDisabled == true or t6.isCartPricingLoading == true
		t7 = buildCartPricingOfferCheckboxes({
			cartPricing = u70,
			isDisabled = u88
		})
	end

	local n1 = 0

	if FFlagPurchasePromptFetchCartPricing then
		n1 = not u70.showCartOfferUi and 0 or #u70.cartPricingOffers
	end

	local v91 = nil

	if FFlagPurchasePromptFetchCartPricing then
		local v92 = React.useMemo(function() -- line: 469
			-- upvalues: u71 (ref), React (copy), Checkbox (copy), n1 (ref), u88 (ref), u72 (ref)
			local t8 = {}

			for v102, v103 in u71 do
				t8[v103.actionKey] = React.createElement(Checkbox, {
					size = "XSmall",
					LayoutOrder = n1 + v102,
					label = v103.label,
					isChecked = v103.isActionSelected,
					isDisabled = u88,
					onActivated = function() -- line: 478
						-- upvalues: u72 (ref), v102 (copy), v103 (copy)
						u72(function(p1) -- line: 479
							-- upvalues: v102 (copy), v103 (copy)
							local v109 = table.clone(p1)

							v109[v102] = {
								label = v103.label,
								isActionSelected = not v103.isActionSelected,
								actionKey = v103.actionKey
							}

							return v109
						end)
					end
				})
			end

			return t8
		end, {
			u71,
			u88,
			n1
		})
		local v93 = table.clone(t7)

		for k, v in pairs(v92) do
			v93[k] = v
		end

		v91 = if not next(v93) then nil else React.createElement(View, {
			tag = "col gap-medium size-full-0 auto-y",
			LayoutOrder = 3
		}, v93)
	end

	local v96 = if not v85 or not FFlagShouldApplyDevSubsUpsellFix then React.createElement(ProductDetailsContainer, {
		purchaseModalType = t6.purchaseModalType,
		product = if not FFlagPurchasePromptFetchCartPricing then t6.product else v74,
		isCompact = u78,
		model = if not FFlagPurchasePromptFetchCartPricing then t6.product.model else v74.model,
		priceSuffix = v86,
		hideProductDetails = if not FFlagPurchasePromptFetchCartPricing then nil else t6.purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem,
		hideDiscountSummary = if not FFlagPurchasePromptFetchCartPricing then nil else t6.isCartPricingLoading,
		savingsSummary = if not FFlagPurchasePromptFetchCartPricing then nil else u70.cartPricingSavingsSummary
	}) else React.createElement(View, {
		LayoutOrder = 1,
		tag = "row align-y-center gap-medium size-full-0 auto-y"
	}, {
		ItemIcon = React.createElement(FoundationImage, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(72, 72),
			ScaleType = Enum.ScaleType.Fit,
			Image = if not FFlagPurchasePromptFetchCartPricing then t6.product.itemIcon else v74.itemIcon
		}),
		ItemInfo = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col gap-xxsmall auto-y",
			Size = UDim2.new(1, -84, 0, 0)
		}, {
			ItemName = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
				Size = UDim2.new(1, 0, 0, 0),
				Text = if not FFlagPurchasePromptFetchCartPricing then t6.product.itemName or "" else v74.itemName or ""
			}),
			ItemPrice = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "auto-y text-title-medium text-align-x-left content-emphasis",
				RichText = true,
				Size = UDim2.new(1, 0, 0, 0),
				Text = utf8.char(57346) .. " " .. tostring((if not FFlagPurchasePromptFetchCartPricing then t6.product.itemRobuxCost or 0 else v74.itemRobuxCost or 0)) .. (v86 or "")
			})
		})
	})

	return React.createElement(Dialog.Root, {
		disablePortal = false,
		size = DialogSize.Medium,
		onClose = t6.buttons.cancelPurchaseActivated,
		ref = v81
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			text = v79
		}),
		DialogContent = React.createElement(Dialog.Content, nil, {
			ContentView = React.createElement(View, {
				tag = {
					["col align-x-center align-y-top gap-medium size-full-0 auto-y"] = FFlagPurchasePromptFetchCartPricing,
					["col gap-medium auto-y size-full-0 align-x-center align-y-start"] = not FFlagPurchasePromptFetchCartPricing
				}
			}, {
				ProductDetailsContainer = v96 or React.createElement(View, {
					LayoutOrder = 1,
					tag = {
						["col align-x-center align-y-center gap-medium size-full-0"] = FFlagPurchasePromptFetchCartPricing,
						["col gap-medium size-full-0 align-x-center align-y-center"] = not FFlagPurchasePromptFetchCartPricing
					}
				}, {
					ProductDetails = if t6.purchaseModalType ~= UnifiedPurchaseModalTypeEnum.MultiItem then React.createElement(UnifiedProductDetails, {
						isPortrait = false,
						isCompact = u78,
						itemIcon = if not FFlagPurchasePromptFetchCartPricing then t6.product.itemIcon else v74.itemIcon,
						itemName = if not FFlagPurchasePromptFetchCartPricing then t6.product.itemName else v74.itemName,
						itemRobuxCost = if not FFlagPurchasePromptFetchCartPricing then t6.product.itemRobuxCost else v74.itemRobuxCost,
						itemPrice = if not FFlagPurchasePromptFetchCartPricing then nil else v74.itemPrice,
						model = if not FFlagPurchasePromptFetchCartPricing then t6.product.model else v74.model,
						priceSuffix = v86
					}) else React.createElement(PriceSummary, {
						amount = if not FFlagPurchasePromptFetchCartPricing then t6.product.itemRobuxCost else v74.itemRobuxCost,
						itemPrice = if not FFlagPurchasePromptFetchCartPricing then nil else v74.itemPrice
					})
				}),
				CartPricingLoading = if not FFlagPurchasePromptFetchCartPricing then nil else React.createElement(CartPricingLoading, {
					isLoading = t6.isCartPricingLoading
				}),
				PostPurchaseActions = if not FFlagPurchasePromptFetchCartPricing then nil else v91,
				UpsellSuggestions = React.createElement(View, {
					LayoutOrder = not FFlagPurchasePromptFetchCartPricing and 2 or 3,
					tag = {
						["col align-x-center align-y-center gap-medium size-full-0 auto-y padding-x-xsmall padding-bottom-xxlarge padding-top-small"] = FFlagPurchasePromptFetchCartPricing,
						["col gap-medium auto-y size-full-0 align-x-center align-y-center padding-x-xsmall padding-y-small padding-bottom-xxlarge"] = not FFlagPurchasePromptFetchCartPricing
					}
				}, if not GetFFlagIAPExperienceEnableMultiDisplayUpsell() then {
					UpsellPackage1 = React.createElement(UpsellProductDetails, {
						layoutOrder = 1,
						product = t6.upsellSuggestions[1],
						selected = t6.selectedUpsellIndex == 1,
						isCompact = u78,
						onSelected = function() -- line: 656
							-- upvalues: t6 (copy)
							t6.onUpsellSuggestionsSelected(1)
						end
					}),
					UpsellPackage2 = if not (#t6.upsellSuggestions > 1) then nil else React.createElement(UpsellProductDetails, {
						layoutOrder = 2,
						product = t6.upsellSuggestions[2],
						selected = t6.selectedUpsellIndex == 2,
						isCompact = u78,
						onSelected = function() -- line: 666
							-- upvalues: t6 (copy)
							t6.onUpsellSuggestionsSelected(2)
						end,
						badgeType = t6.upsellSuggestions[2].badgeType
					})
				} else (function() -- line: 633
					-- upvalues: t6 (copy), React (copy), UpsellProductDetails (copy), u78 (ref)
					local t9 = {}

					for i, v in ipairs(t6.upsellSuggestions) do
						t9["UpsellPackage" .. tostring(i)] = React.createElement(UpsellProductDetails, {
							layoutOrder = i,
							product = v,
							selected = i == t6.selectedUpsellIndex,
							isCompact = u78,
							onSelected = function() -- line: 642
								-- upvalues: i (copy), t6 (copy)
								local v107 = i

								t6.onUpsellSuggestionsSelected(v107)
							end,
							badgeType = v.badgeType
						})
					end

					return t9
				end)())
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 4,
			orientation = EnumsOrientation.Horizontal,
			actions = {{
				text = v87,
				variant = ButtonVariant.Emphasis,
				onActivated = if not FFlagPurchasePromptFetchCartPricing then t6.buttons.buyItemActivated else v73,
				isDisabled = if not FFlagPurchasePromptFetchCartPricing then t6.buttons.buyItemDisabled else u88,
				ref = v82,
				inputDelay = if not FFlagPurchasePromptFetchCartPricing then (not t6.buttons.buyItemEnableInputDelayed or t6.buttons.buyItemDisabled) and 0 or 2.5 else (not t6.buttons.buyItemEnableInputDelayed or u88) and 0 or 2.5
			}}
		}),
		DisclosureTerms = React.createElement(View, {
			LayoutOrder = 5,
			tag = {
				["row wrap align-x-center align-y-center gap-xxsmall size-full-0 auto-y"] = FFlagPurchasePromptFetchCartPricing,
				["row wrap auto-y align-y-center align-x-center size-full-0 gap-xxsmall"] = not FFlagPurchasePromptFetchCartPricing
			}
		}, {
			DisclosurePayment = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small",
				Text = v77.DisclosurePayment
			}),
			BeforeText = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small",
				Text = parts[1]
			}),
			TextLink = React.createElement(FoundationText, {
				LayoutOrder = 3,
				RichText = true,
				tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small",
				Text = TermsOfUse,
				onActivated = t6.termsOfUseActivated
			}),
			AfterText = React.createElement(FoundationText, {
				LayoutOrder = 4,
				tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small",
				Text = parts[2]
			})
		})
	})
end
local function UnifiedRobuxUpsellModalV2Container(t10: {[any]: any}) -- line: 732
	-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), UnifiedRobuxUpsellModalV2 (copy)
	return React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		UnifiedRobuxUpsellModalV2 = React.createElement(UnifiedRobuxUpsellModalV2, t10)
	})
end

return UnifiedRobuxUpsellModalV2Container
