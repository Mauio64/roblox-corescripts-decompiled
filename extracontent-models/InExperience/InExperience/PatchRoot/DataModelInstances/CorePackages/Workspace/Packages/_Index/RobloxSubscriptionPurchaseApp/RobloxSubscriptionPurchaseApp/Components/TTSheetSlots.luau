local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local FoundationCloudAssets = require(parent.FoundationCloudAssets)
local View = Foundation.View
local Sheet = Foundation.Sheet
local Button = Foundation.Button
local IconName = Foundation.Enums.IconName
local FillBehavior = Foundation.Enums.FillBehavior
local ButtonVariant = Foundation.Enums.ButtonVariant
require(RobloxSubscriptionPurchaseApp.types)
local FeatureRow = require(script.Parent.FeatureRow)
local PlusHeroContent = require(script.Parent.PlusHeroContent)
local LegalDisclosure = require(script.Parent.LegalDisclosure)
local usePlaceholderLocalization = require(RobloxSubscriptionPurchaseApp.Hooks.usePlaceholderLocalization)
local CampaignLocalizations = require(RobloxSubscriptionPurchaseApp.Store.CampaignLocalizations)
local FFlagTTOnboardingSheet = require(RobloxSubscriptionPurchaseApp.Flags.FFlagTTOnboardingSheet)

if FFlagTTOnboardingSheet then
	FoundationCloudAssets.preloadAsset("pictograms/gift")
	FoundationCloudAssets.preloadAsset("pictograms/plus")
end

local v = {
	title = "Feature.RobloxSubscription.Heading.TTGrant",
	description = "Feature.RobloxSubscription.Description.TTGrant",
	ctaText = "Feature.RobloxSubscription.Action.TTClaim",
	benefitCustomize = "Feature.RobloxSubscription.Label.TTBenefitCustomize",
	benefitDiscount = "Feature.RobloxSubscription.Label.TTBenefitDiscount",
	benefitPrivateServer = "Feature.RobloxSubscription.Label.TTBenefitPrivateServer",
	benefitRobux = "Feature.RobloxSubscription.Label.TTBenefitRobux"
}

local v2 = {
	{ iconName = IconName.PaintBrush, stringName = "benefitCustomize" },
	{ iconName = IconName.Tag, stringName = "benefitDiscount" },
	{ iconName = IconName.Controller, stringName = "benefitPrivateServer" },
	{ iconName = IconName.Robux, stringName = "benefitRobux" }
}

local function useTTSheetSlots(props)
	local v3 = usePlaceholderLocalization(v)
	local featureRobloxSubscriptionDisclosureTTClaimTerms = SignalsReact.useSignalState(CampaignLocalizations.getCampaignLocalizations)["Feature.RobloxSubscription.Disclosure.TTClaimTerms"]
	local purchaseUIOptions = props.purchaseUIOptions

	local ctaText = purchaseUIOptions.ctaText or v3.ctaText

	local children = {}

	for k, v4 in v2 do
		children[`Benefit{k}`] = React.createElement(FeatureRow, {
			layoutOrder = k,
			iconName = v4.iconName,
			text = v3[v4.stringName]
		})
	end

	local v4 = {
		Header = React.createElement(Sheet.Header, { hasCloseAffordance = true }),
		Content = React.createElement(Sheet.Content, nil, {
			Body = React.createElement(View, { tag = "col gap-large size-full-0 auto-y" }, {
				Hero = React.createElement(PlusHeroContent, {
					layoutOrder = 1,
					pictogram = FoundationCloudAssets.Assets["pictograms/gift"],
					accentPictogram = FoundationCloudAssets.Assets["pictograms/plus"],
					title = purchaseUIOptions.title or v3.title,
					subtitle = purchaseUIOptions.description or v3.description
				}),
				Benefits = React.createElement(
					View,
					{ LayoutOrder = 2, tag = "col align-x-left gap-small size-full-0 auto-y" },
					children
				)
			})
		}),
		Actions = 0
	}

	local createElement = React.createElement
	local actions = Sheet.Actions
	local createElement2 = React.createElement

	local v5 = {
		Claim = React.createElement(Button, {
			LayoutOrder = 1,
			ref = props.onButtonMounted,
			text = ctaText,
			onActivated = props.onActivated,
			isLoading = props.isLoading,
			fillBehavior = FillBehavior.Fill,
			variant = ButtonVariant.Emphasis,
			testId = "BlackbirdSheet--tt-claim"
		}),
		LegalDisclosure = 0
	}
	local legalDisclosure

	if featureRobloxSubscriptionDisclosureTTClaimTerms and featureRobloxSubscriptionDisclosureTTClaimTerms ~= "" then
		legalDisclosure = React.createElement(LegalDisclosure, {
			layoutOrder = 2,
			ctaText = ctaText,
			textTemplate = featureRobloxSubscriptionDisclosureTTClaimTerms
		})
	end

	v5.LegalDisclosure = legalDisclosure
	v4.Actions = createElement(actions, nil, {
		ActionsContainer = createElement2(
			View,
			{ LayoutOrder = 1, tag = "row wrap align-x-center gap-medium size-full-0 auto-xy" },
			v5
		)
	})
	return v4
end

return useTTSheetSlots
