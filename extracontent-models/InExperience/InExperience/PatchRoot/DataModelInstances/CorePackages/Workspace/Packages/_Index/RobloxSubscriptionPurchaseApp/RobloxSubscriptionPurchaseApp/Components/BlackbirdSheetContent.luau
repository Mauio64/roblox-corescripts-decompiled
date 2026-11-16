local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local handleBackButtonAction = require(RobloxSubscriptionPurchaseApp.Actions.handleBackButtonAction)
local View = Foundation.View
local Sheet = Foundation.Sheet
local Text = Foundation.Text
local Button = Foundation.Button
local getIconRichText = Foundation.Utility.getIconRichText
local Enums = Foundation.Enums
local IconName = Enums.IconName
local FillBehavior = Enums.FillBehavior
local ButtonVariant = Enums.ButtonVariant
require(RobloxSubscriptionPurchaseApp.types)
local RobloxSubscriptionPriceRow = require(script.Parent.RobloxSubscriptionPriceRow)
local RobloxSubscriptionFeatureList = require(script.Parent.RobloxSubscriptionFeatureList)
local LegalDisclosure = require(script.Parent.LegalDisclosure)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local performRobloxSubscriptionPurchase = require(RobloxSubscriptionPurchaseApp.Actions.performRobloxSubscriptionPurchase)
local finalizeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.finalizeRobloxSubscriptionUpsellFlow)
local completeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.completeRobloxSubscriptionUpsellFlow)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local logRobloxSubscriptionUpsellCounter = require(RobloxSubscriptionPurchaseApp.Utils.logRobloxSubscriptionUpsellCounter)
local logSubscriptionPurchaseFlowEvent = require(RobloxSubscriptionPurchaseApp.Utils.logSubscriptionPurchaseFlowEvent)

local FFlagEnableSubscriptionPurchaseFlowEventIngest = require(RobloxSubscriptionPurchaseApp.Flags.FFlagEnableSubscriptionPurchaseFlowEventIngest)
local isRobloxSubscriptionProductFreeTrial = require(RobloxSubscriptionPurchaseApp.Utils.isRobloxSubscriptionProductFreeTrial)
local getFreeTrialOffer = require(RobloxSubscriptionPurchaseApp.Utils.getFreeTrialOffer)
local RobloxSubscriptionUpsellTelemetry = require(RobloxSubscriptionPurchaseApp.Events.RobloxSubscriptionUpsellTelemetry)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)
local SignalsReact = require(parent.SignalsReact)
local FFlagSupportFreeTrial = require(RobloxSubscriptionPurchaseApp.Flags.FFlagSupportFreeTrial)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnablePlusReferralLandingSheet = SharedFlags.FFlagEnablePlusReferralLandingSheet
local SharedFlags2 = require(parent.SharedFlags)
local FIntPlusReferralRewardRobux = SharedFlags2.FIntPlusReferralRewardRobux
local useReferrerName = require(RobloxSubscriptionPurchaseApp.Hooks.useReferrerName)
local PlusHeroContent = require(script.Parent.PlusHeroContent)
local FoundationCloudAssets = require(parent.FoundationCloudAssets)
local pictogramsplus_robux = FoundationCloudAssets.Assets["pictograms/plus_robux"]
FoundationCloudAssets.preloadAsset("pictograms/plus_robux")
local FFlagRobloxPlusDynamicFreeTrialLength = require(RobloxSubscriptionPurchaseApp.Flags.FFlagRobloxPlusDynamicFreeTrialLength)
local FFlagEnablePlusReferralLegalDisclosure = require(RobloxSubscriptionPurchaseApp.Flags.FFlagEnablePlusReferralLegalDisclosure)
local GuiService = game:GetService("GuiService")

local set = {
	[PromptState.SubscriptionPurchaseInProgress] = true,
	[PromptState.SubscriptionStatusPolling] = true
}

local function useBlackbirdSheetSlots()
	local v = RobloxSubscriptionStore.get()
	local v2 = v.getOnCtaOverride()

	local v3 = SignalsReact.useSignalState(v.getPurchaseUIOptions)
	local v4 = SignalsReact.useSignalState(v.getPromptState)
	local v5

	if FFlagEnablePlusReferralLandingSheet then
		v5 = SignalsReact.useSignalState(v.getReferrerId)
	end

	local v6

	if FFlagEnablePlusReferralLandingSheet then
		v6 = useReferrerName(v5)
	end

	local v7 = useLocalization({
		title = "Feature.RobloxSubscription.Title.GetBlackbird",
		buttonText = "Feature.RobloxSubscription.Action.Subscribe",
		getFreeTrialText = "Feature.RobloxSubscription.Action.TryItForFree",
		referralTitle = FFlagEnablePlusReferralLandingSheet and "Feature.RobloxSubscription.Heading.ReferralRecipientJoin" or nil,
		referralInvite = FFlagEnablePlusReferralLandingSheet and {
			"Feature.RobloxSubscription.Description.ReferralRecipientInvite",
			username = v6 or "",
			amount = tostring(FIntPlusReferralRewardRobux)
		} or nil
	})

	local v8 = SignalsReact.useSignalState(v.getRobloxSubscriptionProduct)
	local robloxSubscriptionProductFreeTrial = isRobloxSubscriptionProductFreeTrial(v8)
	local v9

	if FFlagRobloxPlusDynamicFreeTrialLength then
		v9 = getFreeTrialOffer(v8)
	end

	local referralInvite

	if FFlagEnablePlusReferralLandingSheet and v6 and v6 ~= "" then
		referralInvite = v7.referralInvite
	end

	local text

	if v3.description then
		text = v3.description
	else
		text = FFlagEnablePlusReferralLandingSheet and referralInvite or nil
	end

	local ctaText

	if robloxSubscriptionProductFreeTrial then
		ctaText = v7.getFreeTrialText
	else
		ctaText = v7.buttonText
	end

	local v10 = v3.showLegalDisclosure == nil or v3.showLegalDisclosure
	local v11

	if v3.noPurchaseMethodRequired == nil then
		v11 = false
	else
		v11 = v3.noPurchaseMethodRequired
	end

	local ref = React.useCallback(function(p)
		if p then
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

		if not v2 then
			performRobloxSubscriptionPurchase()
			return
		end

		v.setPromptState(PromptState.SubscriptionPurchaseRequested)
		v2(function()
			v.setDidTryPurchasing(true)
			finalizeRobloxSubscriptionUpsellFlow(true)
		end, function()
			completeRobloxSubscriptionUpsellFlow()
		end)
	end

	local isLoading = set[v4] == true
	local isReferral = FFlagEnablePlusReferralLandingSheet and referralInvite ~= nil
	local v12

	if FFlagEnablePlusReferralLandingSheet then
		v12 = GuiService.ViewportDisplaySize ~= Enum.DisplaySize.Small
	else
		v12 = false
	end

	local createElement = React.createElement
	local header = Sheet.Header
	local view

	if not isReferral then
		local createElement2 = React.createElement
		local backButton

		if v3.showBackButton then
			backButton = React.createElement(Text, {
				LayoutOrder = 1,
				Text = `{getIconRichText(IconName.ChevronLargeLeft)}`,
				tag = "gap-small auto-xy text-heading-small text-align-x-center content-emphasis",
				RichText = true,
				onActivated = handleBackButtonAction
			})
		end

		view = createElement2(View, { LayoutOrder = 1, tag = "row gap-small auto-xy" }, {
			BackButton = backButton,
			Title = React.createElement(Text, {
				LayoutOrder = 2,
				Text = `{getIconRichText(IconName.RobloxPlus)} {v3.title or v7.title}`,
				tag = "auto-xy text-heading-small text-align-x-center content-emphasis",
				RichText = true
			})
		})
	end

	local children = {
		Header = createElement(header, { hasCloseAffordance = true }, { View = view }),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = Sheet.Content

	local createElement3 = React.createElement
	local v13 = {
		tag = isReferral and not v12 and "col gap-xsmall size-full-0 auto-y padding-bottom-large" or isReferral and v12 and "col gap-xsmall size-full-0" or text == nil and "col" or "col size-full-0 auto-y",
		Size = 0
	}
	local udim

	if isReferral and v12 then
		udim = UDim2.new(1, 0, 0, 300)
	elseif not (isReferral or text ~= nil) then
		udim = UDim2.new(1, 0, 0, 140)
	end

	v13.Size = udim
	local heroContent

	if isReferral then
		heroContent = React.createElement(PlusHeroContent, {
			layoutOrder = 1,
			pictogram = pictogramsplus_robux,
			title = `{v7.referralTitle} {getIconRichText(IconName.Robux)} {tostring(FIntPlusReferralRewardRobux)}`,
			titleRichText = true,
			subtitle = referralInvite
		})
	end

	local priceRow

	if isReferral then
		priceRow = React.createElement(RobloxSubscriptionPriceRow, {
			layoutOrder = FFlagEnablePlusReferralLandingSheet and 4 or 1,
			isFreeTrial = robloxSubscriptionProductFreeTrial
		})
	elseif text == nil then
		priceRow = React.createElement(RobloxSubscriptionPriceRow, {
			layoutOrder = FFlagEnablePlusReferralLandingSheet and 4 or 1,
			isFreeTrial = robloxSubscriptionProductFreeTrial
		})
	else
		priceRow = React.createElement(Text, {
			LayoutOrder = FFlagEnablePlusReferralLandingSheet and 4 or 1,
			Text = text,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
		})
	end

	children.Content = createElement2(content, { LayoutOrder = 2 }, {
		ContentContainer = createElement3(View, v13, {
			HeroContent = heroContent,
			PriceRow = priceRow,
			FeatureList = React.createElement(RobloxSubscriptionFeatureList, {
				layoutOrder = FFlagEnablePlusReferralLandingSheet and 5 or 2,
				noPurchaseMethodRequired = v11,
				compact = isReferral and v12
			})
		})
	})

	local createElement4 = React.createElement
	local actions = Sheet.Actions

	local createElement5 = React.createElement

	local createElement6 = React.createElement

	local text2 = if v3.ctaText then v3.ctaText else ctaText
	local v14 = {
		SubscribeButton = createElement6(Button, {
			LayoutOrder = 1,
			ref = ref,
			text = text2,
			onActivated = onSubscribe,
			fillBehavior = FillBehavior.Fill,
			variant = ButtonVariant.Emphasis,
			isLoading = isLoading
		}),
		LegalDisclosure = 0
	}
	local legalDisclosure

	if v10 then
		local createElement7 = React.createElement

		if v3.ctaText then
			ctaText = v3.ctaText
		end

		if not FFlagSupportFreeTrial then
			robloxSubscriptionProductFreeTrial = nil
		end

		if not FFlagEnablePlusReferralLegalDisclosure then
			isReferral = nil
		end

		local trialDuration

		if v9 then
			trialDuration = v9.Duration
		end

		local trialPeriodType

		if v9 then
			trialPeriodType = v9.PeriodType
		end

		local billingPeriodType

		if v9 and v8 then
			billingPeriodType = v8.PeriodType
		end

		legalDisclosure = createElement7(LegalDisclosure, {
			layoutOrder = 2,
			ctaText = ctaText,
			isFreeTrial = robloxSubscriptionProductFreeTrial,
			isReferral = isReferral,
			shortenFreeTrialTerms = v11,
			trialDuration = trialDuration,
			trialPeriodType = trialPeriodType,
			billingPeriodType = billingPeriodType
		})
	end

	v14.LegalDisclosure = legalDisclosure
	children.Actions = createElement4(actions, { LayoutOrder = 3 }, {
		ActionsContainer = createElement5(
			View,
			{ LayoutOrder = 1, tag = "row wrap align-x-center gap-medium size-full-0 auto-xy" },
			v14
		)
	})
	return children
end

return useBlackbirdSheetSlots
