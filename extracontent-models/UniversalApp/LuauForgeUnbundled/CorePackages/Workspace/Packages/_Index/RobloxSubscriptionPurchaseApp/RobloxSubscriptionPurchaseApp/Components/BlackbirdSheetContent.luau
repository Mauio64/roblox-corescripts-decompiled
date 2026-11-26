local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")
local handleBackButtonAction = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Actions/handleBackButtonAction")
local view = Foundation.View
local sheet = Foundation.Sheet
local text = Foundation.Text
local button = Foundation.Button
local getIconRichText = Foundation.Utility.getIconRichText
local enums = Foundation.Enums
local iconName = enums.IconName
local fillBehavior = enums.FillBehavior
local buttonVariant = enums.ButtonVariant
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/types")
local RobloxSubscriptionPriceRow = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Components/RobloxSubscriptionPriceRow")
local RobloxSubscriptionFeatureList = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Components/RobloxSubscriptionFeatureList")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Components/LegalDisclosure")
local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")
local performRobloxSubscriptionPurchase = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Actions/performRobloxSubscriptionPurchase")
local finalizeRobloxSubscriptionUpsellFlow = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Actions/finalizeRobloxSubscriptionUpsellFlow")
local completeRobloxSubscriptionUpsellFlow = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Actions/completeRobloxSubscriptionUpsellFlow")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Localization").Hooks.useLocalization
local logRobloxSubscriptionUpsellCounter = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/logRobloxSubscriptionUpsellCounter")
local logSubscriptionPurchaseFlowEvent = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/logSubscriptionPurchaseFlowEvent")

local FFlagEnableSubscriptionPurchaseFlowEventIngest = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagEnableSubscriptionPurchaseFlowEventIngest")
local isRobloxSubscriptionProductFreeTrial = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/isRobloxSubscriptionProductFreeTrial")
local getFreeTrialOffer = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/getFreeTrialOffer")
local RobloxSubscriptionUpsellTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Events/RobloxSubscriptionUpsellTelemetry")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/PromptState")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SignalsReact")
local FFlagSupportFreeTrial = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagSupportFreeTrial")
local fFlagEnablePlusReferralLandingSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagEnablePlusReferralLandingSheet
local fIntPlusReferralRewardRobux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FIntPlusReferralRewardRobux
local useReferrerName = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Hooks/useReferrerName")
local PlusHeroContent = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Components/PlusHeroContent")
local FoundationCloudAssets = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/FoundationCloudAssets")
local pictogramsplus_robux = FoundationCloudAssets.Assets["pictograms/plus_robux"]
FoundationCloudAssets.preloadAsset("pictograms/plus_robux")
local FFlagRobloxPlusDynamicFreeTrialLength = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagRobloxPlusDynamicFreeTrialLength")
local FFlagEnablePlusReferralLegalDisclosure = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagEnablePlusReferralLegalDisclosure")
local FFlagTTOnboardingSheet = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagTTOnboardingSheet")
local RobloxPlusSheetKind = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/RobloxPlusSheetKind")
local TTSheetSlots = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Components/TTSheetSlots")
local GuiService = game:GetService("GuiService")

local set = {
	[PromptState.SubscriptionPurchaseInProgress] = true,
	[PromptState.SubscriptionStatusPolling] = true
}

local function useBlackbirdSheetSlots()
	local v5 = RobloxSubscriptionStore.get()
	local v6 = v5.getOnCtaOverride()

	local v7 = SignalsReact.useSignalState(v5.getPurchaseUIOptions)
	local v8 = SignalsReact.useSignalState(v5.getPromptState)
	local v9

	if fFlagEnablePlusReferralLandingSheet then
		v9 = SignalsReact.useSignalState(v5.getReferrerId)
	end

	local v10 = if fFlagEnablePlusReferralLandingSheet then useReferrerName(v9) else nil

	local v11 = useLocalization({
		title = "Feature.RobloxSubscription.Title.GetBlackbird",
		buttonText = "Feature.RobloxSubscription.Action.Subscribe",
		getFreeTrialText = "Feature.RobloxSubscription.Action.TryItForFree",
		referralTitle = fFlagEnablePlusReferralLandingSheet and "Feature.RobloxSubscription.Heading.ReferralRecipientJoin" or nil,
		referralInvite = fFlagEnablePlusReferralLandingSheet and {
			"Feature.RobloxSubscription.Description.ReferralRecipientInvite",
			username = v10 or "",
			amount = tostring(fIntPlusReferralRewardRobux)
		} or nil
	})

	local v12 = SignalsReact.useSignalState(v5.getRobloxSubscriptionProduct)
	local v13 = isRobloxSubscriptionProductFreeTrial(v12)

	local v14 = if FFlagRobloxPlusDynamicFreeTrialLength then getFreeTrialOffer(v12) else nil
	local referralInvite

	if fFlagEnablePlusReferralLandingSheet and v10 and v10 ~= "" then
		referralInvite = v11.referralInvite
	end

	local v15

	if v7.description then
		v15 = v7.description
	else
		v15 = fFlagEnablePlusReferralLandingSheet and referralInvite or nil
	end

	local v16 = if v13 then v11.getFreeTrialText else v11.buttonText
	local v17 = v7.showLegalDisclosure == nil or v7.showLegalDisclosure

	local v18 = not (v7.noPurchaseMethodRequired == nil) and v7.noPurchaseMethodRequired

	local v19 = React.useCallback(function(p2)
		if p2 then
			if FFlagEnableSubscriptionPurchaseFlowEventIngest then
				logSubscriptionPurchaseFlowEvent("SubscriptionUpsellModalShown")
			end

			logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellModalShownCounter)
		end
	end, {})

	local function onSubscribe()
		if FFlagEnableSubscriptionPurchaseFlowEventIngest then
			logSubscriptionPurchaseFlowEvent("SubscriptionUpsellSubscribeClicked")
		end

		logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellModalBuyButtonClickedCounter)

		if not v6 then
			performRobloxSubscriptionPurchase()
			return
		end

		v5.setPromptState(PromptState.SubscriptionPurchaseRequested)
		v6(function()
			v5.setDidTryPurchasing(true)
			finalizeRobloxSubscriptionUpsellFlow(true)
		end, function()
			completeRobloxSubscriptionUpsellFlow()
		end)
	end

	local v20 = set[v8] == true
	local v21 = fFlagEnablePlusReferralLandingSheet and referralInvite ~= nil
	local v22

	if fFlagEnablePlusReferralLandingSheet then
		v22 = GuiService.ViewportDisplaySize ~= Enum.DisplaySize.Small
	else
		v22 = false
	end

	local v23

	if FFlagTTOnboardingSheet then
		v23 = TTSheetSlots({
			purchaseUIOptions = v7,
			isLoading = v20,
			onActivated = onSubscribe,
			onButtonMounted = v19
		})
	end

	if v23 and v7.sheetKind == RobloxPlusSheetKind.TT then
		return v23
	end

	local createElement = React.createElement
	local header = sheet.Header
	local v26

	if not v21 then
		local createElement2 = React.createElement

		local v30 = if v7.showBackButton then React.createElement(text, {
			LayoutOrder = 1,
			Text = `{getIconRichText(iconName.ChevronLargeLeft)}`,
			tag = "gap-small auto-xy text-heading-small text-align-x-center content-emphasis",
			RichText = true,
			onActivated = handleBackButtonAction
		}) else nil
		v26 = createElement2(view, { LayoutOrder = 1, tag = "row gap-small auto-xy" }, {
			BackButton = v30,
			Title = React.createElement(text, {
				LayoutOrder = 2,
				Text = `{getIconRichText(iconName.RobloxPlus)} {v7.title or v11.title}`,
				tag = "auto-xy text-heading-small text-align-x-center content-emphasis",
				RichText = true
			})
		})
	end

	local children = {
		Header = createElement(header, { hasCloseAffordance = true }, { View = v26 }),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = sheet.Content

	local createElement3 = React.createElement
	local v30 = {
		tag = v21 and not v22 and "col gap-xsmall size-full-0 auto-y padding-bottom-large" or v21 and v22 and "col gap-xsmall size-full-0" or v15 == nil and "col" or "col size-full-0 auto-y",
		Size = 0
	}
	local udim

	if v21 and v22 then
		udim = UDim2.new(1, 0, 0, 300)
	elseif not (v21 or v15 ~= nil) then
		udim = UDim2.new(1, 0, 0, 140)
	end

	v30.Size = udim

	local v32 = if v21 then React.createElement(PlusHeroContent, {
		layoutOrder = 1,
		pictogram = pictogramsplus_robux,
		title = `{v11.referralTitle} {getIconRichText(iconName.Robux)} {tostring(fIntPlusReferralRewardRobux)}`,
		titleRichText = true,
		subtitle = referralInvite
	}) else nil
	local v33

	if v21 then
		v33 = React.createElement(RobloxSubscriptionPriceRow, {
			layoutOrder = fFlagEnablePlusReferralLandingSheet and 4 or 1,
			isFreeTrial = v13
		})
	elseif v15 == nil then
		v33 = React.createElement(RobloxSubscriptionPriceRow, {
			layoutOrder = fFlagEnablePlusReferralLandingSheet and 4 or 1,
			isFreeTrial = v13
		})
	else
		v33 = React.createElement(text, {
			LayoutOrder = fFlagEnablePlusReferralLandingSheet and 4 or 1,
			Text = v15,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
		})
	end

	children.Content = createElement2(content, { LayoutOrder = 2 }, {
		ContentContainer = createElement3(view, v30, {
			HeroContent = v32,
			PriceRow = v33,
			FeatureList = React.createElement(RobloxSubscriptionFeatureList, {
				layoutOrder = fFlagEnablePlusReferralLandingSheet and 5 or 2,
				noPurchaseMethodRequired = v18,
				compact = v21 and v22
			})
		})
	})

	local createElement4 = React.createElement
	local actions = sheet.Actions

	local createElement5 = React.createElement

	local createElement6 = React.createElement

	local v41 = if v7.ctaText then v7.ctaText else v16
	local v38 = {
		SubscribeButton = createElement6(button, {
			LayoutOrder = 1,
			ref = v19,
			text = v41,
			onActivated = onSubscribe,
			fillBehavior = fillBehavior.Fill,
			variant = buttonVariant.Emphasis,
			isLoading = v20
		}),
		LegalDisclosure = 0
	}
	local v42

	if v17 then
		local createElement7 = React.createElement

		if v7.ctaText then
			v16 = v7.ctaText
		end

		if not FFlagSupportFreeTrial then
			v13 = nil
		end

		if not FFlagEnablePlusReferralLegalDisclosure then
			v21 = nil
		end

		local v45 = if v14 then v14.Duration else nil
		local v46 = if v14 then v14.PeriodType else nil

		local v47 = if v14 and v12 then v12.PeriodType else nil
		v42 = createElement7(module6, {
			layoutOrder = 2,
			ctaText = v16,
			isFreeTrial = v13,
			isReferral = v21,
			shortenFreeTrialTerms = v18,
			trialDuration = v45,
			trialPeriodType = v46,
			billingPeriodType = v47
		})
	end

	v38.LegalDisclosure = v42
	children.Actions = createElement4(actions, { LayoutOrder = 3 }, {
		ActionsContainer = createElement5(
			view,
			{
				LayoutOrder = 1,
				tag = "row wrap align-x-center gap-medium size-full-0 auto-xy"
			},
			v38
		)
	})
	return children
end

return useBlackbirdSheetSlots
