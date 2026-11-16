local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local FFlagBuildAgentAdCampaignCard = require(BuildExperience.Flags.FFlagBuildAgentAdCampaignCard)

local FFlagBuildAgentAdCampaignRefreshEligibility = require(BuildExperience.Flags.FFlagBuildAgentAdCampaignRefreshEligibility)
local FFlagBuildExperienceChatCardEmphasis = require(BuildExperience.Flags.FFlagBuildExperienceChatCardEmphasis)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)
local ChatCardPriority = require(BuildExperience.Components.Chat.ChatCardEmphasis.ChatCardPriority)
local useChatCardEmphasis = require(BuildExperience.Components.Chat.ChatCardEmphasis.useChatCardEmphasis)

local Button = Foundation.Button
local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize

local function AdUpsellCard(props)
	local v = Foundation.Hooks.useTokens()

	local v2 = {
		title = LocalizationStrings.AD_UPSELL_CARD_TITLE,
		description = LocalizationStrings.AD_UPSELL_CARD_DESC,
		freeTitle = 0,
		freeTitlePlural = 0,
		freeDescription = 0,
		noFreeTitle = 0,
		noFreeDescription = 0,
		create = 0,
		dontShowAgain = 0,
		eligibilityError = 0
	}
	local freeTitle

	if FFlagBuildAgentAdCampaignCard then
		freeTitle = LocalizationStrings.AD_UPSELL_FREE_TITLE
	end

	v2.freeTitle = freeTitle
	v2.freeTitlePlural = FFlagBuildAgentAdCampaignCard and {
		LocalizationStrings.AD_UPSELL_FREE_TITLE_PLURAL,
		promotionCount = props.freePromotionsRemaining
	} or nil
	local freeDescription

	if FFlagBuildAgentAdCampaignCard then
		freeDescription = LocalizationStrings.AD_UPSELL_FREE_DESC
	end

	v2.freeDescription = freeDescription
	local noFreeTitle

	if FFlagBuildAgentAdCampaignCard then
		noFreeTitle = LocalizationStrings.AD_UPSELL_NO_FREE_TITLE
	end

	v2.noFreeTitle = noFreeTitle
	local noFreeDescription

	if FFlagBuildAgentAdCampaignCard then
		noFreeDescription = LocalizationStrings.AD_UPSELL_NO_FREE_DESC
	end

	v2.noFreeDescription = noFreeDescription

	v2.create = LocalizationStrings.AD_UPSELL_CARD_CREATE
	v2.dontShowAgain = LocalizationStrings.AD_UPSELL_CARD_DONT_SHOW_AGAIN
	local eligibilityError

	if FFlagBuildAgentAdCampaignRefreshEligibility then
		if props.eligibilityError == "unavailable" then
			eligibilityError = LocalizationStrings.AD_CAMPAIGN_SHEET_FORBIDDEN_ERROR
		else
			eligibilityError = LocalizationStrings.AD_CAMPAIGN_SHEET_INTERNAL_ERROR
		end
	end

	v2.eligibilityError = eligibilityError
	local v3 = useLocalization(v2)

	local text = v3.title
	local text2 = v3.description

	if FFlagBuildAgentAdCampaignCard then
		if props.fundingType == "paid" then
			text = v3.noFreeTitle
			text2 = v3.noFreeDescription
		elseif props.freePromotionsRemaining == 1 then
			text = v3.freeTitle
			text2 = v3.freeDescription
		elseif props.freePromotionsRemaining > 0 then
			text = v3.freeTitlePlural
			text2 = v3.freeDescription
		else
			text = v3.noFreeTitle
			text2 = v3.noFreeDescription
		end
	end

	local create = v3.create
	local dontShowAgain = v3.dontShowAgain
	local v4

	if FFlagBuildExperienceChatCardEmphasis then
		v4 = useChatCardEmphasis(ChatCardPriority.AdUpsell, props.emphasisOrder)
	end

	local createElement = React.createElement
	local v5 = {
		LayoutOrder = props.LayoutOrder,
		ref = props.containerRef,
		tag = "col gap-large size-full-0 auto-y padding-large stroke-standard stroke-default radius-large",
		testId = "AdUpsellCard"
	}

	local createElement2 = React.createElement

	local v6 = {
		Title = React.createElement(
			View,
			{ LayoutOrder = 1, tag = "row align-y-center gap-small size-full-0 auto-y" },
			{
				Icon = React.createElement(Icon, {
					LayoutOrder = 1,
					name = IconName.Megaphone,
					style = v.Color.Content.Emphasis,
					testId = "AdUpsellCard.Icon"
				}),
				Label = React.createElement(Text, {
					LayoutOrder = 2,
					Text = text,
					tag = "fill auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
				})
			}
		),
		Description = React.createElement(Text, {
			LayoutOrder = 2,
			Text = text2,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis"
		}),
		EligibilityError = 0
	}
	local eligibilityError2

	if FFlagBuildAgentAdCampaignRefreshEligibility and props.eligibilityError ~= nil then
		eligibilityError2 = React.createElement(Text, {
			LayoutOrder = 3,
			Text = v3.eligibilityError,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-alert",
			testId = "AdUpsellCard.EligibilityError"
		})
	end

	v6.EligibilityError = eligibilityError2
	local children = {
		Content = createElement2(View, {
			LayoutOrder = 1,
			tag = "col gap-xxsmall size-full-0 auto-y"
		}, v6),
		Actions = 0
	}

	local createElement3 = React.createElement

	local createElement4 = React.createElement
	local v7 = {
		LayoutOrder = 1,
		text = create,
		size = InputSize.Small,
		variant = 0,
		fillBehavior = 0,
		width = 0,
		isLoading = 0,
		isDisabled = 0,
		onActivated = 0,
		testId = "AdUpsellCard.Create"
	}
	local variant

	if v4 == true then
		variant = ButtonVariant.Emphasis
	else
		variant = ButtonVariant.SoftEmphasis
	end

	v7.variant = variant

	v7.fillBehavior = FillBehavior.Fill
	v7.width = UDim.new(1, 0)
	v7.isLoading = props.isCreatePending == true
	v7.isDisabled = (FFlagBuildAgentAdCampaignCard or FFlagBuildCheckGamePermissions) and props.isCreateDisabled == true
	v7.onActivated = props.onCreate
	local v8 = { Create = createElement4(Button, v7), DontShowAgain = 0 }
	local dontShowAgain2

	if not (FFlagBuildAgentAdCampaignCard and props.onDismiss == nil) then
		dontShowAgain2 = React.createElement(Button, {
			LayoutOrder = 2,
			text = dontShowAgain,
			size = InputSize.Small,
			variant = ButtonVariant.Standard,
			fillBehavior = FillBehavior.Fill,
			width = UDim.new(1, 0),
			onActivated = props.onDismiss,
			testId = "AdUpsellCard.DontShowAgain"
		})
	end

	v8.DontShowAgain = dontShowAgain2
	children.Actions = createElement3(View, {
		LayoutOrder = 2,
		tag = "row gap-small size-full-0 auto-y"
	}, v8)
	return createElement(View, v5, children)
end

return AdUpsellCard
