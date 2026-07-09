local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local SharedFlags = require(ParentParentParent.SharedFlags)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local FoundationImage = Foundation.Image
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local Sheet = Foundation.Sheet
local useScaledValue = Foundation.Hooks.useScaledValue
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
local UnifiedPurchaseModalHeader = require(ParentParent.Generic.UnifiedPurchaseModalHeader)
local ProductDetailsContainer = require(ParentParent.Generic.ProductDetailsContainer)
local useInitialButtonDisableDelay = require(ParentParent.Generic.Hooks.useInitialButtonDisableDelay)
local useFocusNavigationRefs = require(ParentParent.Generic.Hooks.useFocusNavigationRefs)
local UnifiedPurchaseModalTypeEnum = require(ParentParent.Enums.UnifiedPurchaseModalTypeEnum)
local formatNumber = require(ParentParent.Utility.formatNumber)
local getUpsellBadgeInfo = require(ParentParent.Utility.getUpsellBadgeInfo)
local Constants = require(ParentParent.Generic.Constants)
local UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_SINGLE_PACKAGE = Constants.UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_SINGLE_PACKAGE
local UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_DEFAULT = Constants.UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_DEFAULT
local UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES = Constants.UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES
local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local FFlagUnifiedPurchaseModalUiImprovements = require(ParentParent.Flags.FFlagUnifiedPurchaseModalUiImprovements)
local FFlagFixUnifiedModalsMountedTwice = require(ParentParent.Flags.FFlagFixUnifiedModalsMountedTwice)
local FFlagAddFocusNavigationToUnifiedPurchase = require(ParentParent.Flags.FFlagAddFocusNavigationToUnifiedPurchase)
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require(ParentParent.Parent.SharedFlags).FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local FFlagAddCompactUnifiedUpsellModalMode = require(ParentParent.Flags.FFlagAddCompactUnifiedUpsellModalMode)
local v41 = game:DefineFastInt("CompactUpsellModalBreakpoint", 400)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = require(ParentParent.Parent.SharedFlags).FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagShouldApplyDevSubsUpsellFix = require(ParentParent.Flags.FFlagShouldApplyDevSubsUpsellFix)
local FFlagShouldFixDevSubsFlashingTitle = require(ParentParent.Flags.FFlagShouldFixDevSubsFlashingTitle)
local GetFFlagIAPExperienceEnableMultiDisplayUpsell = require(ParentParent.Flags.GetFFlagIAPExperienceEnableMultiDisplayUpsell)
local GetFFlagIAPExperienceUseUpsellBadgeHelper = require(ParentParent.Flags.GetFFlagIAPExperienceUseUpsellBadgeHelper)
local FFlagFixUpsellModalUnevenLayout = require(ParentParent.Flags.FFlagFixUpsellModalUnevenLayout)

require(ParentParent.Api.PaymentsGateway.GetUpsellSuggestionsTypes)

local BadgeType = require(ParentParent.Enums.BadgeType)

require(ParentParent.Enums.VirtualItemBadgeType)
require(ParentParent.ProductPurchase.PricingTypes)

local function UpsellProductDetailsLegacyImpl(t1: {[any]: any}, t2: {[any]: any}) -- line: 105
	-- upvalues: BadgeType (copy), FFlagAddCompactUnifiedUpsellModalMode (copy), React (copy), View (copy), FoundationText (copy), formatNumber (copy), LocalizationService (copy), YellowBadge (copy)
	local v57 = if t1.badgeType ~= BadgeType.Popular then if t1.badgeType ~= BadgeType.LastPurchased then nil else t2.LastPurchased else t2.Popular
	local v58 = if t1.badgeType ~= BadgeType.Popular then nil else "icons/menu/fire_fill"
	local s1 = "size-full-1400 radius-medium padding-x-large row"
	local v60 = if not t1.selected then s1 .. " bg-surface-300 stroke-emphasis stroke-standard" else s1 .. " bg-surface-200 stroke-system-contrast stroke-thick"
	local v61 = (not FFlagAddCompactUnifiedUpsellModalMode or not t1.isCompact) and "auto-xy text-title-large content-emphasis text-align-x-left" or "auto-xy text-title-small content-emphasis text-align-x-left"
	local v62 = (not FFlagAddCompactUnifiedUpsellModalMode or not t1.isCompact) and "auto-xy text-title-large content-muted text-align-x-left" or "auto-xy text-title-small content-muted text-align-x-left"
	local v63 = (not FFlagAddCompactUnifiedUpsellModalMode or not t1.isCompact) and "auto-xy text-title-large content-emphasis text-align-x-right" or "auto-xy text-title-small content-emphasis text-align-x-right"

	return React.createElement(View, {
		LayoutOrder = t1.layoutOrder,
		onActivated = t1.onSelected,
		tag = v60,
		Size = if not FFlagAddCompactUnifiedUpsellModalMode or not t1.isCompact then nil else UDim2.new(1, 0, 0, 40)
	}, {
		LeftSide = React.createElement(View, {
			LayoutOrder = 1,
			tag = {
				["row align-y-center gap-small"] = true,
				["align-x-start"] = true
			},
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			RobuxAmount = React.createElement(FoundationText, {
				LayoutOrder = 1,
				Text = utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, t1.product.robuxAmount),
				tag = {
					[v61] = FFlagAddCompactUnifiedUpsellModalMode,
					["auto-xy text-title-large text-align-x-left content-emphasis"] = not FFlagAddCompactUnifiedUpsellModalMode
				}
			}),
			RobuxAmountBonus = t1.product.robuxAmountBeforeBonus and React.createElement(FoundationText, {
				LayoutOrder = 2,
				RichText = true,
				Text = "<s>" .. utf8.char(57346) .. formatNumber(LocalizationService.RobloxLocaleId, t1.product.robuxAmountBeforeBonus) .. "</s>",
				tag = {
					[v62] = FFlagAddCompactUnifiedUpsellModalMode,
					["auto-xy text-title-large text-align-x-left content-muted"] = not FFlagAddCompactUnifiedUpsellModalMode
				}
			})
		}),
		RightSide = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row align-x-right align-y-center gap-large",
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			Badge = if not v57 then nil else React.createElement(YellowBadge, {
				LayoutOrder = 1,
				Text = v57,
				Icon = v58
			}),
			RobuxPrice = React.createElement(FoundationText, {
				LayoutOrder = 2,
				Text = t1.product.price or "",
				tag = {
					[v63] = FFlagAddCompactUnifiedUpsellModalMode,
					["auto-xy text-title-large text-align-x-right content-emphasis"] = not FFlagAddCompactUnifiedUpsellModalMode
				}
			})
		})
	})
end
local function UpsellProductDetailsMultiDisplayFixedImpl(t3: {[any]: any}, t4: {[any]: any}) -- line: 193
	-- upvalues: GetFFlagIAPExperienceUseUpsellBadgeHelper (copy), getUpsellBadgeInfo (copy), BadgeType (copy), Enums (copy), FFlagAddCompactUnifiedUpsellModalMode (copy), React (copy), View (copy), FoundationText (copy), getIconRichText (copy), formatNumber (copy), LocalizationService (copy), GrayBadge (copy)
	local text, icon

	if GetFFlagIAPExperienceUseUpsellBadgeHelper() then
		local v66 = getUpsellBadgeInfo(t3.badgeType, t4)

		text = v66.text
		icon = v66.icon
	else
		text = if t3.badgeType ~= BadgeType.Popular then if t3.badgeType ~= BadgeType.LastPurchased then if t3.badgeType ~= BadgeType.ForYou then if t3.badgeType ~= BadgeType.BetterValue then nil else t4.BetterValue else t4.ForYouItem else t4.LastPurchased else t4.Popular
		icon = if t3.badgeType ~= BadgeType.Popular then if t3.badgeType ~= BadgeType.ForYou then if t3.badgeType ~= BadgeType.BetterValue then nil else Enums.IconName.Tag else Enums.IconName.CircleStar else Enums.IconName.Flame
	end

	local v69 = (not FFlagAddCompactUnifiedUpsellModalMode or not t3.isCompact) and "size-full-1400 radius-medium padding-x-large row" or "size-full-1000 radius-medium padding-small row"
	local v70 = if not t3.selected then v69 .. " bg-surface-300 stroke-default stroke-standard" else v69 .. " bg-surface-200 stroke-system-contrast stroke-thick"
	local v71 = (not FFlagAddCompactUnifiedUpsellModalMode or not t3.isCompact) and "auto-xy text-heading-small content-emphasis text-align-x-left" or "auto-xy text-title-small content-emphasis text-align-x-left"
	local v72 = if not FFlagAddCompactUnifiedUpsellModalMode or not t3.isCompact then not FFlagAddCompactUnifiedUpsellModalMode and "auto-xy text-title-large content-muted text-align-x-left" or "auto-xy text-title-medium content-muted text-align-x-left" else "auto-xy text-title-small content-muted text-align-x-left"
	local v73 = (not FFlagAddCompactUnifiedUpsellModalMode or not t3.isCompact) and "auto-xy text-title-large content-emphasis text-align-x-right" or "auto-xy text-title-small content-emphasis text-align-x-right"

	return React.createElement(View, {
		LayoutOrder = t3.layoutOrder,
		onActivated = t3.onSelected,
		tag = v70
	}, {
		LeftSide = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row align-x-left align-y-center gap-small",
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			RobuxAmount = React.createElement(FoundationText, {
				LayoutOrder = 1,
				RichText = true,
				Text = getIconRichText(Enums.IconName.Robux) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, t3.product.robuxAmount),
				tag = v71
			}),
			RobuxAmountBonus = t3.product.robuxAmountBeforeBonus and React.createElement(FoundationText, {
				LayoutOrder = 2,
				RichText = true,
				Text = "<s>" .. getIconRichText(Enums.IconName.Robux) .. formatNumber(LocalizationService.RobloxLocaleId, t3.product.robuxAmountBeforeBonus) .. "</s>",
				tag = v72
			}),
			Badge = if not text then nil else React.createElement(GrayBadge, {
				LayoutOrder = 3,
				Text = text,
				iconName = icon
			})
		}),
		RightSide = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row align-x-right align-y-center gap-large",
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			RobuxPrice = React.createElement(FoundationText, {
				LayoutOrder = 1,
				Text = t3.product.price or "",
				tag = v73
			})
		})
	})
end
local function UpsellProductDetailsMultiDisplayImpl(t5: {[any]: any}, t6: {[any]: any}) -- line: 286
	-- upvalues: GetFFlagIAPExperienceUseUpsellBadgeHelper (copy), getUpsellBadgeInfo (copy), BadgeType (copy), Enums (copy), FFlagAddCompactUnifiedUpsellModalMode (copy), React (copy), View (copy), FoundationText (copy), getIconRichText (copy), formatNumber (copy), LocalizationService (copy), GrayBadge (copy)
	local text, icon

	if GetFFlagIAPExperienceUseUpsellBadgeHelper() then
		local v76 = getUpsellBadgeInfo(t5.badgeType, t6)

		text = v76.text
		icon = v76.icon
	else
		text = if t5.badgeType ~= BadgeType.Popular then if t5.badgeType ~= BadgeType.LastPurchased then if t5.badgeType ~= BadgeType.ForYou then if t5.badgeType ~= BadgeType.BetterValue then nil else t6.BetterValue else t6.ForYouItem else t6.LastPurchased else t6.Popular
		icon = if t5.badgeType ~= BadgeType.Popular then if t5.badgeType ~= BadgeType.ForYou then if t5.badgeType ~= BadgeType.BetterValue then nil else Enums.IconName.Tag else Enums.IconName.CircleStar else Enums.IconName.Flame
	end

	local v79 = (not FFlagAddCompactUnifiedUpsellModalMode or not t5.isCompact) and "col align-x-left gap-medium size-full-0 auto-y padding-medium radius-medium" or "size-full-0 auto-y radius-medium padding-small row"
	local v80 = if not t5.selected then v79 .. " bg-surface-300 stroke-default stroke-standard" else v79 .. " bg-surface-200 stroke-system-contrast stroke-thick"
	local v81 = (not FFlagAddCompactUnifiedUpsellModalMode or not t5.isCompact) and "auto-xy text-heading-small content-emphasis text-align-x-left" or "auto-xy text-title-small content-emphasis text-align-x-left"
	local v82 = if not FFlagAddCompactUnifiedUpsellModalMode or not t5.isCompact then not FFlagAddCompactUnifiedUpsellModalMode and "auto-xy text-title-large content-muted text-align-x-left" or "auto-xy text-title-medium content-muted text-align-x-left" else "auto-xy text-title-small content-muted text-align-x-left"
	local v83 = (not FFlagAddCompactUnifiedUpsellModalMode or not t5.isCompact) and "auto-xy text-title-large content-emphasis text-align-x-right" or "auto-xy text-title-small content-emphasis text-align-x-right"

	return React.createElement(View, {
		LayoutOrder = t5.layoutOrder,
		onActivated = t5.onSelected,
		tag = v80,
		Size = if not FFlagAddCompactUnifiedUpsellModalMode or not t5.isCompact then nil else UDim2.new(1, 0, 0, 40)
	}, {
		LeftSide = React.createElement(View, {
			LayoutOrder = 1,
			tag = {
				["row align-x-left align-y-center gap-small"] = true,
				["size-full-0 auto-y"] = not (FFlagAddCompactUnifiedUpsellModalMode and t5.isCompact)
			},
			Size = if not FFlagAddCompactUnifiedUpsellModalMode or not t5.isCompact then nil else UDim2.new(0.65, 0, 1, 0)
		}, {
			RobuxAmount = React.createElement(FoundationText, {
				LayoutOrder = 1,
				RichText = true,
				Text = getIconRichText(Enums.IconName.Robux) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, t5.product.robuxAmount),
				tag = v81
			}),
			RobuxAmountBonus = t5.product.robuxAmountBeforeBonus and React.createElement(FoundationText, {
				LayoutOrder = 2,
				RichText = true,
				Text = "<s>" .. getIconRichText(Enums.IconName.Robux) .. formatNumber(LocalizationService.RobloxLocaleId, t5.product.robuxAmountBeforeBonus) .. "</s>",
				tag = v82
			}),
			Badge = if not text then nil else React.createElement(GrayBadge, {
				LayoutOrder = 3,
				Text = text,
				iconName = icon
			})
		}),
		RightSide = React.createElement(View, {
			LayoutOrder = 2,
			tag = {
				["row align-x-right align-y-center gap-large"] = true,
				["size-full-0 auto-y"] = not (FFlagAddCompactUnifiedUpsellModalMode and t5.isCompact)
			},
			Size = if not FFlagAddCompactUnifiedUpsellModalMode or not t5.isCompact then nil else UDim2.new(0.35, 0, 1, 0)
		}, {
			RobuxPrice = React.createElement(FoundationText, {
				LayoutOrder = 1,
				Text = t5.product.price or "",
				tag = v83
			})
		})
	})
end
local function UpsellProductDetails(t7: {[any]: any}) -- line: 386
	-- upvalues: useLocalization (copy), GetFFlagIAPExperienceEnableMultiDisplayUpsell (copy), FFlagFixUpsellModalUnevenLayout (copy), UpsellProductDetailsMultiDisplayFixedImpl (copy), UpsellProductDetailsMultiDisplayImpl (copy), UpsellProductDetailsLegacyImpl (copy)
	local v85 = useLocalization({
		Popular = "IAPExperience.RobuxUpsell.Text.PopularItem",
		LastPurchased = "IAPExperience.RobuxUpsell.Text.LastPurchased",
		ForYouItem = "IAPExperience.RobuxUpsell.Text.ForYou",
		BetterValue = "IAPExperience.RobuxUpsell.Text.BetterValue",
		BestValue = "IAPExperience.RobuxUpsell.Text.BestValue"
	})

	if GetFFlagIAPExperienceEnableMultiDisplayUpsell() then
		if FFlagFixUpsellModalUnevenLayout then
			return UpsellProductDetailsMultiDisplayFixedImpl(t7, v85)
		end

		return UpsellProductDetailsMultiDisplayImpl(t7, v85)
	end

	return UpsellProductDetailsLegacyImpl(t7, v85)
end
local function UnifiedRobuxUpsellModal(t8: {[any]: any}) -- line: 430
	-- upvalues: useLocalization (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), FFlagAXMISWithBlackbird (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), FFlagAddCompactUnifiedUpsellModalMode (copy), UnifiedPurchaseModalTypeEnum (copy), v41 (copy), useInitialButtonDisableDelay (copy), FFlagUnifiedPurchaseModalUiImprovements (copy), React (copy), UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_DEFAULT (copy), GetFFlagIAPExperienceEnableMultiDisplayUpsell (copy), FFlagFixUpsellModalUnevenLayout (copy), UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES (copy), UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_SINGLE_PACKAGE (copy), useScaledValue (copy), FFlagShouldFixDevSubsFlashingTitle (copy), FFlagFixUnifiedModalsMountedTwice (copy), FFlagAddFocusNavigationToUnifiedPurchase (copy), useFocusNavigationRefs (copy), FFlagShouldApplyDevSubsUpsellFix (copy), View (copy), FoundationImage (copy), FoundationText (copy), ProductDetailsContainer (copy), Sheet (copy), UnifiedPurchaseModalHeader (copy), PriceSummary (copy), UnifiedProductDetails (copy), UpsellProductDetails (copy), Foundation (copy), FillBehavior (copy), ButtonVariant (copy)
	local v87 = useLocalization({
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
	local u88 = nil

	if FFlagAddCompactUnifiedUpsellModalMode then
		u88 = if not FFlagEnableUnifiedPurchaseFlowForDevSubs or t8.purchaseModalType ~= UnifiedPurchaseModalTypeEnum.DeveloperSubscription then t8.screenSize.Y < v41 else t8.screenSize.Y > 0 and t8.screenSize.Y < v41
	end

	local v89 = useInitialButtonDisableDelay(false)
	local v90 = nil
	local u91 = nil

	if FFlagUnifiedPurchaseModalUiImprovements then
		local v92

		v90, v92 = React.useState(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_DEFAULT)
		u91 = v92
	end

	if FFlagUnifiedPurchaseModalUiImprovements then
		React.useEffect(function() -- line: 475
			-- upvalues: GetFFlagIAPExperienceEnableMultiDisplayUpsell (copy), FFlagFixUpsellModalUnevenLayout (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), t8 (copy), UnifiedPurchaseModalTypeEnum (copy), u91 (ref), UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES (copy), UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_SINGLE_PACKAGE (copy), UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_DEFAULT (copy)
			if GetFFlagIAPExperienceEnableMultiDisplayUpsell() and not FFlagFixUpsellModalUnevenLayout then
				if FFlagEnableUnifiedPurchaseFlowForDevSubs and t8.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription then
					u91(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES)

					return
				end

				local v113 = #t8.upsellSuggestions

				if v113 == 1 then
					u91(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_SINGLE_PACKAGE)

					return
				end

				if v113 == 2 then
					u91(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_DEFAULT)

					return
				end

				u91(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES)

				return
			end

			if #t8.upsellSuggestions > 1 then
				u91(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES)
			end

			if FFlagEnableUnifiedPurchaseFlowForDevSubs and t8.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription then
				u91(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES)
			end
		end, {
			t8.upsellSuggestions,
			t8.purchaseModalType
		})
	end

	local v93 = useScaledValue(v90 or 0)
	local v94, v95 = React.useState(v87.BuyRobuxAndItem)

	React.useEffect(function() -- line: 509
		-- upvalues: t8 (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), UnifiedPurchaseModalTypeEnum (copy), v87 (copy), FFlagShouldFixDevSubsFlashingTitle (copy), v95 (copy), FFlagAXMISWithBlackbird (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy)
		local purchaseModalType = t8.purchaseModalType

		if FFlagEnableUnifiedPurchaseFlowForDevSubs and purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription then
			local BuyRobuxAndItem = v87.BuyRobuxAndItem

			if FFlagShouldFixDevSubsFlashingTitle and v87.BuyRobuxAndSubscription and v87.BuyRobuxAndSubscription ~= "" then
				BuyRobuxAndItem = v87.BuyRobuxAndSubscription
			end

			v95(BuyRobuxAndItem)

			return
		end

		if purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
			if FFlagAXMISWithBlackbird then
				if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements and t8.product.itemName ~= "RobuxUpsell" then
					v95(v87.BuyRobuxAndAvatar)

					return
				end

				v95(v87.BuyRobuxOnly)

				return
			end

			if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
				v95(v87.BuyRobuxAndAvatar)

				return
			end

			v95(v87.BuyRobuxAndItems)

			return
		end

		if purchaseModalType == UnifiedPurchaseModalTypeEnum.Experience then
			v95(v87.BuyRobuxAndExperience)

			return
		end

		v95(v87.BuyRobuxAndItem)
	end, {
		t8.purchaseModalType,
		v87.BuyRobuxAndAvatar,
		v87.BuyRobuxAndExperience,
		v87.BuyRobuxAndItem,
		v87.BuyRobuxAndItems,
		v87.BuyRobuxAndSubscription,
		if not FFlagAXMISWithBlackbird then nil else t8.product.itemName,
		if not FFlagAXMISWithBlackbird then nil else v87.BuyRobuxOnly
	})

	local v96 = React.useCallback(function(p1) -- line: 559
		-- upvalues: t8 (copy)
		if p1 and t8.onBuyItemButtonMounted then
			t8.onBuyItemButtonMounted(p1)
		end
	end, { t8.onBuyItemButtonMounted })

	if FFlagFixUnifiedModalsMountedTwice then
		v96 = React.useCallback(function(p2) -- line: 568
			-- upvalues: t8 (copy), v89 (copy)
			if p2 and (t8.onBuyItemButtonMounted and not v89) then
				t8.onBuyItemButtonMounted(p2)
			end
		end, {
			t8.onBuyItemButtonMounted,
			v89
		})
	end

	local v97 = nil
	local v98 = nil

	if FFlagAddFocusNavigationToUnifiedPurchase then
		v97, v98 = useFocusNavigationRefs(t8.buttons.cancelPurchaseActivated, t8.onBuyItemButtonMounted)
	end

	React.useEffect(function() -- line: 583
	end, { t8.upsellSuggestions })

	local parts = string.split(v87.DisclosureTermsURL, " {termsofuse} ")
	local TermsOfUse = v87.TermsOfUse

	if t8.termsOfUseActivated then
		TermsOfUse = "<u>" .. TermsOfUse .. "</u>"
	end

	local v101 = FFlagEnableUnifiedPurchaseFlowForDevSubs and t8.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	local v102 = if not v101 then nil else v87.PerMonth
	local v103 = if not v101 then v87.Buy else v87.Subscribe
	local v104 = if not v101 or not FFlagShouldApplyDevSubsUpsellFix then React.createElement(ProductDetailsContainer, {
		purchaseModalType = t8.purchaseModalType,
		product = t8.product,
		isCompact = u88,
		model = t8.product.model,
		priceSuffix = v102
	}) else React.createElement(View, {
		LayoutOrder = 1,
		tag = "row align-y-center gap-medium size-full-0 auto-y"
	}, {
		ItemIcon = React.createElement(FoundationImage, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(72, 72),
			ScaleType = Enum.ScaleType.Fit,
			Image = t8.product.itemIcon
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
				Text = t8.product.itemName or ""
			}),
			ItemPrice = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "auto-y text-title-medium text-align-x-left content-emphasis",
				RichText = true,
				Size = UDim2.new(1, 0, 0, 0),
				Text = utf8.char(57346) .. " " .. tostring(t8.product.itemRobuxCost or 0) .. (v102 or "")
			})
		})
	})
	local v105 = GetFFlagIAPExperienceEnableMultiDisplayUpsell()
	local v106 = not v105 and "col gap-medium auto-y size-full-0 align-x-center align-y-start" or "col align-x-center align-y-start gap-medium size-full-0 auto-y"
	local v107 = not v105 and "col gap-medium auto-y size-full-0 align-x-center align-y-center padding-x-xsmall padding-y-small padding-bottom-xxlarge" or "col align-x-center align-y-start gap-medium size-full-0 auto-y padding-x-xsmall"
	local v108 = not v105 and "row wrap auto-xy align-y-center align-x-center size-full-0 gap-medium" or "row wrap align-x-center align-y-center gap-medium size-full-0 auto-y"
	local v109 = not v105 and "row wrap auto-y align-y-center align-x-center size-full-0 gap-xxsmall" or "row wrap align-x-left align-y-center gap-xxsmall size-full-0 auto-y"
	local v110 = if not FFlagAddCompactUnifiedUpsellModalMode or not u88 then if not v105 then nil else "Medium" else "Small"
	local v111 = not v105 and "col gap-medium auto-y size-full-0 align-x-center align-y-center" or "col align-x-center align-y-center gap-medium size-full-0 auto-y"

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		onClose = t8.buttons.cancelPurchaseActivated,
		snapPoints = if not FFlagUnifiedPurchaseModalUiImprovements then {
			0.52,
			0.8
		} else {
			v93,
			0.8
		},
		centerSheetHeight = if not FFlagFixUpsellModalUnevenLayout then if not FFlagUnifiedPurchaseModalUiImprovements or not v105 then nil else v93 else nil,
		ref = if not FFlagAddFocusNavigationToUnifiedPurchase then nil else if not v89 then v97 else nil
	}, {
		Header = React.createElement(Sheet.Header, {
			hasCloseAffordance = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else not not t8.hideUserRobuxBalance or nil
		}, {
			ModalHeader = React.createElement(UnifiedPurchaseModalHeader, {
				titleText = v94,
				robuxBalanceAmount = t8.userBalance,
				hideUserRobuxBalance = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else t8.hideUserRobuxBalance
			})
		}),
		Content = React.createElement(Sheet.Content, {
			LayoutOrder = 2
		}, {
			SheetContentContainer = React.createElement(View, {
				tag = v106
			}, {
				ProductDetailsContainer = v104 or React.createElement(View, {
					LayoutOrder = 1,
					tag = v111
				}, {
					ProductDetails = if t8.purchaseModalType ~= UnifiedPurchaseModalTypeEnum.MultiItem then React.createElement(UnifiedProductDetails, {
						isPortrait = false,
						isCompact = if not FFlagAddCompactUnifiedUpsellModalMode then nil else u88,
						itemIcon = t8.product.itemIcon,
						itemName = t8.product.itemName,
						itemRobuxCost = t8.product.itemRobuxCost,
						model = t8.product.model,
						priceSuffix = v102
					}) else React.createElement(PriceSummary, {
						amount = t8.product.itemRobuxCost
					})
				}),
				UpsellSuggestions = React.createElement(View, {
					LayoutOrder = 2,
					tag = v107
				}, if not v105 then {
					UpsellPackage1 = React.createElement(UpsellProductDetails, {
						layoutOrder = 1,
						product = t8.upsellSuggestions[1],
						selected = t8.selectedUpsellIndex == 1,
						isCompact = if not FFlagAddCompactUnifiedUpsellModalMode then nil else u88,
						onSelected = function() -- line: 755
							-- upvalues: t8 (copy)
							t8.onUpsellSuggestionsSelected(1)
						end
					}),
					UpsellPackage2 = if not (#t8.upsellSuggestions > 1) then nil else React.createElement(UpsellProductDetails, {
						layoutOrder = 2,
						product = t8.upsellSuggestions[2],
						selected = t8.selectedUpsellIndex == 2,
						isCompact = if not FFlagAddCompactUnifiedUpsellModalMode then nil else u88,
						onSelected = function() -- line: 765
							-- upvalues: t8 (copy)
							t8.onUpsellSuggestionsSelected(2)
						end,
						badgeType = t8.upsellSuggestions[2].badgeType
					})
				} else (function() -- line: 732
					-- upvalues: t8 (copy), React (copy), UpsellProductDetails (copy), FFlagAddCompactUnifiedUpsellModalMode (copy), u88 (ref)
					local t9 = {}

					for i, v in ipairs(t8.upsellSuggestions) do
						t9["UpsellPackage" .. tostring(i)] = React.createElement(UpsellProductDetails, {
							layoutOrder = i,
							product = v,
							selected = i == t8.selectedUpsellIndex,
							isCompact = if not FFlagAddCompactUnifiedUpsellModalMode then nil else u88,
							onSelected = function() -- line: 741
								-- upvalues: i (copy), t8 (copy)
								local v122 = i

								t8.onUpsellSuggestionsSelected(v122)
							end,
							badgeType = v.badgeType
						})
					end

					return t9
				end)())
			})
		}),
		Actions = React.createElement(Sheet.Actions, {
			LayoutOrder = 3
		}, { React.createElement(View, {
			LayoutOrder = 1,
			tag = v108
		}, {
			React.createElement(Foundation.Button, {
				LayoutOrder = 1,
				text = v103,
				onActivated = t8.buttons.buyItemActivated,
				inputDelay = (not t8.buttons.buyItemEnableInputDelayed or v89) and 0 or 2.5,
				isDisabled = v89,
				ref = if not FFlagAddFocusNavigationToUnifiedPurchase then v96 else v98,
				fillBehavior = FillBehavior.Fill,
				variant = ButtonVariant.Emphasis,
				size = v110
			}),
			DisclosureTerms = React.createElement(View, {
				LayoutOrder = 2,
				tag = v109
			}, {
				DisclosurePayment = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small",
					Text = v87.DisclosurePayment
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
					onActivated = t8.termsOfUseActivated
				}),
				AfterText = React.createElement(FoundationText, {
					LayoutOrder = 4,
					tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small",
					Text = parts[2]
				})
			})
		}) })
	})
end
local function UnifiedRobuxUpsellModalContainer(t10: {[any]: any}) -- line: 826
	-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), UnifiedRobuxUpsellModal (copy)
	return React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		UnifiedRobuxUpsellModal = React.createElement(UnifiedRobuxUpsellModal, t10)
	})
end

return UnifiedRobuxUpsellModalContainer
