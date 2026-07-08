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
local FFlagAddCompactUnifiedUpsellModalMode = require(ParentParent.Flags.FFlagAddCompactUnifiedUpsellModalMode)
local v36 = game:DefineFastInt("CompactUpsellModalBreakpoint", 400)
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

local function UpsellProductDetailsLegacyImpl(t1: {[any]: any}, t2: {[any]: any}) -- line: 95
	-- upvalues: BadgeType (copy), FFlagAddCompactUnifiedUpsellModalMode (copy), React (copy), View (copy), FoundationText (copy), formatNumber (copy), LocalizationService (copy), YellowBadge (copy)
	local v51 = if t1.badgeType ~= BadgeType.Popular then if t1.badgeType ~= BadgeType.LastPurchased then nil else t2.LastPurchased else t2.Popular
	local v52 = if t1.badgeType ~= BadgeType.Popular then nil else "icons/menu/fire_fill"
	local s1 = "size-full-1400 radius-medium padding-x-large row"
	local v54 = if not t1.selected then s1 .. " bg-surface-300 stroke-emphasis stroke-standard" else s1 .. " bg-surface-200 stroke-system-contrast stroke-thick"
	local v55 = (not FFlagAddCompactUnifiedUpsellModalMode or not t1.isCompact) and "auto-xy text-title-large content-emphasis text-align-x-left" or "auto-xy text-title-small content-emphasis text-align-x-left"
	local v56 = (not FFlagAddCompactUnifiedUpsellModalMode or not t1.isCompact) and "auto-xy text-title-large content-muted text-align-x-left" or "auto-xy text-title-small content-muted text-align-x-left"
	local v57 = (not FFlagAddCompactUnifiedUpsellModalMode or not t1.isCompact) and "auto-xy text-title-large content-emphasis text-align-x-right" or "auto-xy text-title-small content-emphasis text-align-x-right"

	return React.createElement(View, {
		LayoutOrder = t1.layoutOrder,
		onActivated = t1.onSelected,
		tag = v54,
		Size = if not FFlagAddCompactUnifiedUpsellModalMode or not t1.isCompact then nil else UDim2.new(1, 0, 0, 40)
	}, {
		LeftSide = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row gap-small align-y-center align-x-start",
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			RobuxAmount = React.createElement(FoundationText, {
				LayoutOrder = 1,
				Text = utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, t1.product.robuxAmount),
				tag = v55
			}),
			RobuxAmountBonus = t1.product.robuxAmountBeforeBonus and React.createElement(FoundationText, {
				LayoutOrder = 2,
				RichText = true,
				Text = "<s>" .. utf8.char(57346) .. formatNumber(LocalizationService.RobloxLocaleId, t1.product.robuxAmountBeforeBonus) .. "</s>",
				tag = v56
			})
		}),
		RightSide = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row align-y-center align-x-right gap-large",
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			Badge = if not v51 then nil else React.createElement(YellowBadge, {
				LayoutOrder = 1,
				Text = v51,
				Icon = v52
			}),
			RobuxPrice = React.createElement(FoundationText, {
				LayoutOrder = 2,
				Text = t1.product.price or "",
				tag = v57
			})
		})
	})
end
local function UpsellProductDetailsMultiDisplayImpl(t3: {[any]: any}, t4: {[any]: any}) -- line: 168
	-- upvalues: GetFFlagIAPExperienceUseUpsellBadgeHelper (copy), getUpsellBadgeInfo (copy), BadgeType (copy), Enums (copy), FFlagAddCompactUnifiedUpsellModalMode (copy), React (copy), View (copy), FoundationText (copy), getIconRichText (copy), formatNumber (copy), LocalizationService (copy), GrayBadge (copy)
	local text, icon

	if GetFFlagIAPExperienceUseUpsellBadgeHelper() then
		local v60 = getUpsellBadgeInfo(t3.badgeType, t4)

		text = v60.text
		icon = v60.icon
	else
		text = if t3.badgeType ~= BadgeType.Popular then if t3.badgeType ~= BadgeType.LastPurchased then if t3.badgeType ~= BadgeType.ForYou then if t3.badgeType ~= BadgeType.BetterValue then nil else t4.BetterValue else t4.ForYouItem else t4.LastPurchased else t4.Popular
		icon = if t3.badgeType ~= BadgeType.Popular then if t3.badgeType ~= BadgeType.ForYou then if t3.badgeType ~= BadgeType.BetterValue then nil else Enums.IconName.Tag else Enums.IconName.CircleStar else Enums.IconName.Flame
	end

	local s2 = "size-full-1400 radius-medium padding-x-large row"
	local v64 = if not t3.selected then s2 .. " bg-surface-300 stroke-emphasis stroke-standard" else s2 .. " bg-surface-200 stroke-system-contrast stroke-thick"
	local v65 = (not FFlagAddCompactUnifiedUpsellModalMode or not t3.isCompact) and "auto-xy text-title-large content-emphasis text-align-x-left" or "auto-xy text-title-small content-emphasis text-align-x-left"
	local v66 = (not FFlagAddCompactUnifiedUpsellModalMode or not t3.isCompact) and "auto-xy text-title-large content-muted text-align-x-left" or "auto-xy text-title-small content-muted text-align-x-left"
	local v67 = (not FFlagAddCompactUnifiedUpsellModalMode or not t3.isCompact) and "auto-xy text-title-large content-emphasis text-align-x-right" or "auto-xy text-title-small content-emphasis text-align-x-right"

	return React.createElement(View, {
		LayoutOrder = t3.layoutOrder,
		onActivated = t3.onSelected,
		tag = v64,
		Size = if not FFlagAddCompactUnifiedUpsellModalMode or not t3.isCompact then nil else UDim2.new(1, 0, 0, 40)
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
				tag = v65
			}),
			RobuxAmountBonus = t3.product.robuxAmountBeforeBonus and React.createElement(FoundationText, {
				LayoutOrder = 2,
				RichText = true,
				Text = "<s>" .. getIconRichText(Enums.IconName.Robux) .. formatNumber(LocalizationService.RobloxLocaleId, t3.product.robuxAmountBeforeBonus) .. "</s>",
				tag = v66
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
				tag = v67
			})
		})
	})
end
local function UpsellProductDetails(t5: {[any]: any}) -- line: 259
	-- upvalues: useLocalization (copy), GetFFlagIAPExperienceEnableMultiDisplayUpsell (copy), UpsellProductDetailsMultiDisplayImpl (copy), UpsellProductDetailsLegacyImpl (copy)
	local v69 = useLocalization({
		Popular = "IAPExperience.RobuxUpsell.Text.PopularItem",
		LastPurchased = "IAPExperience.RobuxUpsell.Text.LastPurchased",
		ForYouItem = "IAPExperience.RobuxUpsell.Text.ForYou",
		BetterValue = "IAPExperience.RobuxUpsell.Text.BetterValue",
		BestValue = "IAPExperience.RobuxUpsell.Text.BestValue"
	})

	if GetFFlagIAPExperienceEnableMultiDisplayUpsell() then
		return UpsellProductDetailsMultiDisplayImpl(t5, v69)
	end

	return UpsellProductDetailsLegacyImpl(t5, v69)
end
local function UnifiedRobuxUpsellModalV2(t6: {[any]: any}) -- line: 308
	-- upvalues: FFlagPurchasePromptFetchCartPricing (copy), useCartPricing (copy), React (copy), useLocalization (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), FFlagAXMISWithBlackbird (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), FFlagAddCompactUnifiedUpsellModalMode (copy), UnifiedPurchaseModalTypeEnum (copy), v36 (copy), FFlagShouldFixDevSubsFlashingTitle (copy), useFocusNavigationRefs (copy), buildCartPricingOfferCheckboxes (copy), Checkbox (copy), View (copy), FFlagShouldApplyDevSubsUpsellFix (copy), FoundationImage (copy), FoundationText (copy), ProductDetailsContainer (copy), Dialog (copy), DialogSize (copy), PriceSummary (copy), UnifiedProductDetails (copy), CartPricingLoading (copy), GetFFlagIAPExperienceEnableMultiDisplayUpsell (copy), UpsellProductDetails (copy), EnumsOrientation (copy), ButtonVariant (copy)
	local u71 = nil
	local u72 = nil
	local u73 = nil
	local v74 = nil
	local v75 = nil

	if FFlagPurchasePromptFetchCartPricing then
		u71 = useCartPricing({
			product = t6.product,
			purchaseModalType = t6.purchaseModalType,
			cartPricingResponse = t6.cartPricingResponse,
			onCartOfferAppliedChanged = t6.onCartOfferAppliedChanged
		})

		local v76, v77 = React.useState(t6.postPurchaseActions or {})

		u72 = v76
		u73 = v77
		v74 = React.useCallback(function() -- line: 328
			-- upvalues: u72 (ref), t6 (copy)
			if u72 and t6.setPostPurchaseActions then
				t6.setPostPurchaseActions(u72)
			end

			t6.buttons.buyItemActivated()
		end, {
			t6.buttons.buyItemActivated,
			t6.setPostPurchaseActions,
			u72
		})
		v75 = React.useMemo(function() -- line: 336
			-- upvalues: u71 (ref), t6 (copy)
			if u71.showCartOfferUi then
				return u71.mergedProductForDetails
			end

			return t6.product
		end, {
			t6.product,
			u71.showCartOfferUi,
			u71.mergedProductForDetails
		})
	end

	local v78 = useLocalization({
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
	local u79 = nil

	if FFlagAddCompactUnifiedUpsellModalMode then
		u79 = if not FFlagEnableUnifiedPurchaseFlowForDevSubs or t6.purchaseModalType ~= UnifiedPurchaseModalTypeEnum.DeveloperSubscription then t6.screenSize.Y < v36 else t6.screenSize.Y > 0 and t6.screenSize.Y < v36
	end

	local v80, v81 = React.useState(v78.BuyRobuxAndItem)

	React.useEffect(function() -- line: 377
		-- upvalues: t6 (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), UnifiedPurchaseModalTypeEnum (copy), v78 (copy), FFlagShouldFixDevSubsFlashingTitle (copy), v81 (copy), FFlagAXMISWithBlackbird (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy)
		local purchaseModalType = t6.purchaseModalType

		if FFlagEnableUnifiedPurchaseFlowForDevSubs and purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription then
			local BuyRobuxAndItem = v78.BuyRobuxAndItem

			if FFlagShouldFixDevSubsFlashingTitle and v78.BuyRobuxAndSubscription and v78.BuyRobuxAndSubscription ~= "" then
				BuyRobuxAndItem = v78.BuyRobuxAndSubscription
			end

			v81(BuyRobuxAndItem)

			return
		end

		if purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
			if FFlagAXMISWithBlackbird then
				if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements and t6.product.itemName ~= "RobuxUpsell" then
					v81(v78.BuyRobuxAndAvatar)

					return
				end

				v81(v78.BuyRobuxOnly)

				return
			end

			if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
				v81(v78.BuyRobuxAndAvatar)

				return
			end

			v81(v78.BuyRobuxAndItems)

			return
		end

		if purchaseModalType == UnifiedPurchaseModalTypeEnum.Experience then
			v81(v78.BuyRobuxAndExperience)

			return
		end

		v81(v78.BuyRobuxAndItem)
	end, {
		t6.purchaseModalType,
		v78.BuyRobuxAndAvatar,
		v78.BuyRobuxAndExperience,
		v78.BuyRobuxAndItem,
		v78.BuyRobuxAndItems,
		v78.BuyRobuxAndSubscription,
		if not FFlagAXMISWithBlackbird then nil else t6.product.itemName,
		if not FFlagAXMISWithBlackbird then nil else v78.BuyRobuxOnly
	})

	local v82, v83 = useFocusNavigationRefs(t6.buttons.cancelPurchaseActivated, t6.onBuyItemButtonMounted)

	React.useEffect(function() -- line: 432
	end, { t6.upsellSuggestions })

	local parts = string.split(v78.DisclosureTermsURL, " {termsofuse} ")
	local TermsOfUse = v78.TermsOfUse

	if t6.termsOfUseActivated then
		TermsOfUse = "<u>" .. TermsOfUse .. "</u>"
	end

	local v86 = FFlagEnableUnifiedPurchaseFlowForDevSubs and t6.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	local v87 = if not v86 then nil else v78.PerMonth
	local v88 = if not v86 then v78.Buy else v78.Subscribe
	local u89 = nil
	local t7 = {}

	if FFlagPurchasePromptFetchCartPricing then
		u89 = t6.buttons.buyItemDisabled == true or t6.isCartPricingLoading == true
		t7 = buildCartPricingOfferCheckboxes({
			cartPricing = u71,
			isDisabled = u89
		})
	end

	local n1 = 0

	if FFlagPurchasePromptFetchCartPricing then
		n1 = not u71.showCartOfferUi and 0 or #u71.cartPricingOffers
	end

	local v92 = nil

	if FFlagPurchasePromptFetchCartPricing then
		local v93 = React.useMemo(function() -- line: 472
			-- upvalues: u72 (ref), React (copy), Checkbox (copy), n1 (ref), u89 (ref), u73 (ref)
			local t8 = {}

			for v103, v104 in u72 do
				t8[v104.actionKey] = React.createElement(Checkbox, {
					size = "XSmall",
					LayoutOrder = n1 + v103,
					label = v104.label,
					isChecked = v104.isActionSelected,
					isDisabled = u89,
					onActivated = function() -- line: 481
						-- upvalues: u73 (ref), v103 (copy), v104 (copy)
						u73(function(p1) -- line: 482
							-- upvalues: v103 (copy), v104 (copy)
							local v110 = table.clone(p1)

							v110[v103] = {
								label = v104.label,
								isActionSelected = not v104.isActionSelected,
								actionKey = v104.actionKey
							}

							return v110
						end)
					end
				})
			end

			return t8
		end, {
			u72,
			u89,
			n1
		})
		local v94 = table.clone(t7)

		for k, v in pairs(v93) do
			v94[k] = v
		end

		v92 = if not next(v94) then nil else React.createElement(View, {
			tag = "col gap-medium size-full-0 auto-y",
			LayoutOrder = 3
		}, v94)
	end

	local v97 = if not v86 or not FFlagShouldApplyDevSubsUpsellFix then React.createElement(ProductDetailsContainer, {
		purchaseModalType = t6.purchaseModalType,
		product = if not FFlagPurchasePromptFetchCartPricing then t6.product else v75,
		isCompact = u79,
		model = if not FFlagPurchasePromptFetchCartPricing then t6.product.model else v75.model,
		priceSuffix = v87,
		hideProductDetails = if not FFlagPurchasePromptFetchCartPricing then nil else t6.purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem,
		hideDiscountSummary = if not FFlagPurchasePromptFetchCartPricing then nil else t6.isCartPricingLoading,
		savingsSummary = if not FFlagPurchasePromptFetchCartPricing then nil else u71.cartPricingSavingsSummary
	}) else React.createElement(View, {
		LayoutOrder = 1,
		tag = "row align-y-center gap-medium size-full-0 auto-y"
	}, {
		ItemIcon = React.createElement(FoundationImage, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(72, 72),
			ScaleType = Enum.ScaleType.Fit,
			Image = if not FFlagPurchasePromptFetchCartPricing then t6.product.itemIcon else v75.itemIcon
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
				Text = if not FFlagPurchasePromptFetchCartPricing then t6.product.itemName or "" else v75.itemName or ""
			}),
			ItemPrice = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "auto-y text-title-medium text-align-x-left content-emphasis",
				RichText = true,
				Size = UDim2.new(1, 0, 0, 0),
				Text = utf8.char(57346) .. " " .. tostring((if not FFlagPurchasePromptFetchCartPricing then t6.product.itemRobuxCost or 0 else v75.itemRobuxCost or 0)) .. (v87 or "")
			})
		})
	})

	return React.createElement(Dialog.Root, {
		disablePortal = false,
		size = DialogSize.Medium,
		onClose = t6.buttons.cancelPurchaseActivated,
		ref = v82
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			text = v80
		}),
		DialogContent = React.createElement(Dialog.Content, nil, {
			ContentView = React.createElement(View, {
				tag = {
					["col align-x-center align-y-top gap-medium size-full-0 auto-y"] = FFlagPurchasePromptFetchCartPricing,
					["col gap-medium auto-y size-full-0 align-x-center align-y-start"] = not FFlagPurchasePromptFetchCartPricing
				}
			}, {
				ProductDetailsContainer = v97 or React.createElement(View, {
					LayoutOrder = 1,
					tag = {
						["col align-x-center align-y-center gap-medium size-full-0"] = FFlagPurchasePromptFetchCartPricing,
						["col gap-medium size-full-0 align-x-center align-y-center"] = not FFlagPurchasePromptFetchCartPricing
					}
				}, {
					ProductDetails = if t6.purchaseModalType ~= UnifiedPurchaseModalTypeEnum.MultiItem then React.createElement(UnifiedProductDetails, {
						isPortrait = false,
						isCompact = if not FFlagAddCompactUnifiedUpsellModalMode then nil else u79,
						itemIcon = if not FFlagPurchasePromptFetchCartPricing then t6.product.itemIcon else v75.itemIcon,
						itemName = if not FFlagPurchasePromptFetchCartPricing then t6.product.itemName else v75.itemName,
						itemRobuxCost = if not FFlagPurchasePromptFetchCartPricing then t6.product.itemRobuxCost else v75.itemRobuxCost,
						itemPrice = if not FFlagPurchasePromptFetchCartPricing then nil else v75.itemPrice,
						model = if not FFlagPurchasePromptFetchCartPricing then t6.product.model else v75.model,
						priceSuffix = v87
					}) else React.createElement(PriceSummary, {
						amount = if not FFlagPurchasePromptFetchCartPricing then t6.product.itemRobuxCost else v75.itemRobuxCost,
						itemPrice = if not FFlagPurchasePromptFetchCartPricing then nil else v75.itemPrice
					})
				}),
				CartPricingLoading = if not FFlagPurchasePromptFetchCartPricing then nil else React.createElement(CartPricingLoading, {
					isLoading = t6.isCartPricingLoading
				}),
				PostPurchaseActions = if not FFlagPurchasePromptFetchCartPricing then nil else v92,
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
						isCompact = if not FFlagAddCompactUnifiedUpsellModalMode then nil else u79,
						onSelected = function() -- line: 659
							-- upvalues: t6 (copy)
							t6.onUpsellSuggestionsSelected(1)
						end
					}),
					UpsellPackage2 = if not (#t6.upsellSuggestions > 1) then nil else React.createElement(UpsellProductDetails, {
						layoutOrder = 2,
						product = t6.upsellSuggestions[2],
						selected = t6.selectedUpsellIndex == 2,
						isCompact = if not FFlagAddCompactUnifiedUpsellModalMode then nil else u79,
						onSelected = function() -- line: 669
							-- upvalues: t6 (copy)
							t6.onUpsellSuggestionsSelected(2)
						end,
						badgeType = t6.upsellSuggestions[2].badgeType
					})
				} else (function() -- line: 636
					-- upvalues: t6 (copy), React (copy), UpsellProductDetails (copy), FFlagAddCompactUnifiedUpsellModalMode (copy), u79 (ref)
					local t9 = {}

					for i, v in ipairs(t6.upsellSuggestions) do
						t9["UpsellPackage" .. tostring(i)] = React.createElement(UpsellProductDetails, {
							layoutOrder = i,
							product = v,
							selected = i == t6.selectedUpsellIndex,
							isCompact = if not FFlagAddCompactUnifiedUpsellModalMode then nil else u79,
							onSelected = function() -- line: 645
								-- upvalues: i (copy), t6 (copy)
								local v108 = i

								t6.onUpsellSuggestionsSelected(v108)
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
				text = v88,
				variant = ButtonVariant.Emphasis,
				onActivated = if not FFlagPurchasePromptFetchCartPricing then t6.buttons.buyItemActivated else v74,
				isDisabled = if not FFlagPurchasePromptFetchCartPricing then t6.buttons.buyItemDisabled else u89,
				ref = v83,
				inputDelay = if not FFlagPurchasePromptFetchCartPricing then (not t6.buttons.buyItemEnableInputDelayed or t6.buttons.buyItemDisabled) and 0 or 2.5 else (not t6.buttons.buyItemEnableInputDelayed or u89) and 0 or 2.5
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
				Text = v78.DisclosurePayment
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
local function UnifiedRobuxUpsellModalV2Container(t10: {[any]: any}) -- line: 735
	-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), UnifiedRobuxUpsellModalV2 (copy)
	return React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		UnifiedRobuxUpsellModalV2 = React.createElement(UnifiedRobuxUpsellModalV2, t10)
	})
end

return UnifiedRobuxUpsellModalV2Container
