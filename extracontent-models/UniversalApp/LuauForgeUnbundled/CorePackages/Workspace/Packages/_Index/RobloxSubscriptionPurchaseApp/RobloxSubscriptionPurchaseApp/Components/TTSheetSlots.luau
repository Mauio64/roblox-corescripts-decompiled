local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SignalsReact")
local FoundationCloudAssets = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/FoundationCloudAssets")
local view = Foundation.View
local sheet = Foundation.Sheet
local button = Foundation.Button
local iconName = Foundation.Enums.IconName
local fillBehavior = Foundation.Enums.FillBehavior
local buttonVariant = Foundation.Enums.ButtonVariant
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/types")
local FeatureRow = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Components/FeatureRow")
local PlusHeroContent = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Components/PlusHeroContent")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Components/LegalDisclosure")
local usePlaceholderLocalization = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Hooks/usePlaceholderLocalization")
local CampaignLocalizations = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/CampaignLocalizations")

if require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagTTOnboardingSheet") then
	FoundationCloudAssets.preloadAsset("pictograms/gift")
	FoundationCloudAssets.preloadAsset("pictograms/plus")
end

local v5 = {
	title = "Feature.RobloxSubscription.Heading.TTGrant",
	description = "Feature.RobloxSubscription.Description.TTGrant",
	ctaText = "Feature.RobloxSubscription.Action.TTClaim",
	benefitCustomize = "Feature.RobloxSubscription.Label.TTBenefitCustomize",
	benefitDiscount = "Feature.RobloxSubscription.Label.TTBenefitDiscount",
	benefitPrivateServer = "Feature.RobloxSubscription.Label.TTBenefitPrivateServer",
	benefitRobux = "Feature.RobloxSubscription.Label.TTBenefitRobux"
}

local v6 = {
	{ iconName = iconName.PaintBrush, stringName = "benefitCustomize" },
	{ iconName = iconName.Tag, stringName = "benefitDiscount" },
	{ iconName = iconName.Controller, stringName = "benefitPrivateServer" },
	{ iconName = iconName.Robux, stringName = "benefitRobux" }
}

local function useTTSheetSlots(props)
	local v7 = usePlaceholderLocalization(v5)
	local featureRobloxSubscriptionDisclosureTTClaimTerms = SignalsReact.useSignalState(CampaignLocalizations.getCampaignLocalizations)["Feature.RobloxSubscription.Disclosure.TTClaimTerms"]
	local purchaseUIOptions = props.purchaseUIOptions

	local ctaText = purchaseUIOptions.ctaText or v7.ctaText

	local children = {}

	for k, v8 in v6 do
		children[`Benefit{k}`] = React.createElement(FeatureRow, {
			layoutOrder = k,
			iconName = v8.iconName,
			text = v7[v8.stringName]
		})
	end

	local v8 = {
		Header = React.createElement(sheet.Header, { hasCloseAffordance = true }),
		Content = React.createElement(sheet.Content, nil, {
			Body = React.createElement(view, {
				tag = "col gap-large size-full-0 auto-y"
			}, {
				Hero = React.createElement(PlusHeroContent, {
					layoutOrder = 1,
					pictogram = FoundationCloudAssets.Assets["pictograms/gift"],
					accentPictogram = FoundationCloudAssets.Assets["pictograms/plus"],
					title = purchaseUIOptions.title or v7.title,
					subtitle = purchaseUIOptions.description or v7.description
				}),
				Benefits = React.createElement(
					view,
					{
						LayoutOrder = 2,
						tag = "col align-x-left gap-small size-full-0 auto-y"
					},
					children
				)
			})
		}),
		Actions = 0
	}

	local createElement = React.createElement
	local actions = sheet.Actions
	local createElement2 = React.createElement

	local v13 = {
		Claim = React.createElement(button, {
			LayoutOrder = 1,
			ref = props.onButtonMounted,
			text = ctaText,
			onActivated = props.onActivated,
			isLoading = props.isLoading,
			fillBehavior = fillBehavior.Fill,
			variant = buttonVariant.Emphasis,
			testId = "BlackbirdSheet--tt-claim"
		}),
		LegalDisclosure = 0
	}

	local v14 = if featureRobloxSubscriptionDisclosureTTClaimTerms and featureRobloxSubscriptionDisclosureTTClaimTerms ~= "" then React.createElement(module7, {
		layoutOrder = 2,
		ctaText = ctaText,
		textTemplate = featureRobloxSubscriptionDisclosureTTClaimTerms
	}) else nil
	v13.LegalDisclosure = v14
	v8.Actions = createElement(actions, nil, {
		ActionsContainer = createElement2(
			view,
			{
				LayoutOrder = 1,
				tag = "row wrap align-x-center gap-medium size-full-0 auto-xy"
			},
			v13
		)
	})
	return v8
end

return useTTSheetSlots
