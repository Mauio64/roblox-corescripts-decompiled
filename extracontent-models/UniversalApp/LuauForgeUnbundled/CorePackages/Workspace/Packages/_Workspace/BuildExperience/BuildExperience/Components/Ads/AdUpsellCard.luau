local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local FFlagBuildAgentAdCampaignCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAgentAdCampaignCard")

local FFlagBuildAgentAdCampaignRefreshEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAgentAdCampaignRefreshEligibility")
local FFlagBuildExperienceChatCardEmphasis = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatCardEmphasis")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")
local ChatCardPriority = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCardEmphasis/ChatCardPriority")
local useChatCardEmphasis = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCardEmphasis/useChatCardEmphasis")

local button = Foundation.Button
local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize

local function AdUpsellCard(props)
	local v5 = Foundation.Hooks.useTokens()

	local v7 = {
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
	local v8 = if FFlagBuildAgentAdCampaignCard then LocalizationStrings.AD_UPSELL_FREE_TITLE else nil
	v7.freeTitle = v8
	v7.freeTitlePlural = FFlagBuildAgentAdCampaignCard and {
		LocalizationStrings.AD_UPSELL_FREE_TITLE_PLURAL,
		promotionCount = props.freePromotionsRemaining
	} or nil

	local v9 = if FFlagBuildAgentAdCampaignCard then LocalizationStrings.AD_UPSELL_FREE_DESC else nil
	v7.freeDescription = v9

	local v10 = if FFlagBuildAgentAdCampaignCard then LocalizationStrings.AD_UPSELL_NO_FREE_TITLE else nil
	v7.noFreeTitle = v10

	local v11 = if FFlagBuildAgentAdCampaignCard then LocalizationStrings.AD_UPSELL_NO_FREE_DESC else nil
	v7.noFreeDescription = v11

	v7.create = LocalizationStrings.AD_UPSELL_CARD_CREATE
	v7.dontShowAgain = LocalizationStrings.AD_UPSELL_CARD_DONT_SHOW_AGAIN
	local v12

	if FFlagBuildAgentAdCampaignRefreshEligibility then
		if props.eligibilityError == "unavailable" then
			v12 = LocalizationStrings.AD_CAMPAIGN_SHEET_FORBIDDEN_ERROR
		else
			v12 = LocalizationStrings.AD_CAMPAIGN_SHEET_INTERNAL_ERROR
		end
	end

	v7.eligibilityError = v12
	local v13 = useLocalization(v7)

	local v14 = v13.title
	local v15 = v13.description

	if FFlagBuildAgentAdCampaignCard then
		if props.fundingType == "paid" then
			v14 = v13.noFreeTitle
			v15 = v13.noFreeDescription
		elseif props.freePromotionsRemaining == 1 then
			v14 = v13.freeTitle
			v15 = v13.freeDescription
		elseif props.freePromotionsRemaining > 0 then
			v14 = v13.freeTitlePlural
			v15 = v13.freeDescription
		else
			v14 = v13.noFreeTitle
			v15 = v13.noFreeDescription
		end
	end

	local create = v13.create
	local dontShowAgain = v13.dontShowAgain

	local v16 = if FFlagBuildExperienceChatCardEmphasis then useChatCardEmphasis(ChatCardPriority.AdUpsell, props.emphasisOrder) else nil

	local createElement = React.createElement
	local v18 = {
		LayoutOrder = props.LayoutOrder,
		ref = props.containerRef,
		tag = "col gap-large size-full-0 auto-y padding-large stroke-standard stroke-default radius-large",
		testId = "AdUpsellCard"
	}

	local createElement2 = React.createElement

	local v21 = {
		Title = React.createElement(
			view,
			{ LayoutOrder = 1, tag = "row align-y-center gap-small size-full-0 auto-y" },
			{
				Icon = React.createElement(icon, {
					LayoutOrder = 1,
					name = iconName.Megaphone,
					style = v5.Color.Content.Emphasis,
					testId = "AdUpsellCard.Icon"
				}),
				Label = React.createElement(text, {
					LayoutOrder = 2,
					Text = v14,
					tag = "fill auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
				})
			}
		),
		Description = React.createElement(text, {
			LayoutOrder = 2,
			Text = v15,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis"
		}),
		EligibilityError = 0
	}

	local v22 = if FFlagBuildAgentAdCampaignRefreshEligibility and props.eligibilityError ~= nil then React.createElement(text, {
		LayoutOrder = 3,
		Text = v13.eligibilityError,
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-alert",
		testId = "AdUpsellCard.EligibilityError"
	}) else nil
	v21.EligibilityError = v22
	local children = {
		Content = createElement2(view, {
			LayoutOrder = 1,
			tag = "col gap-xxsmall size-full-0 auto-y"
		}, v21),
		Actions = 0
	}

	local createElement3 = React.createElement

	local createElement4 = React.createElement
	local v27 = {
		LayoutOrder = 1,
		text = create,
		size = inputSize.Small,
		variant = 0,
		fillBehavior = 0,
		width = 0,
		isLoading = 0,
		isDisabled = 0,
		onActivated = 0,
		testId = "AdUpsellCard.Create"
	}
	local v28 = if v16 == true then buttonVariant.Emphasis else buttonVariant.SoftEmphasis
	v27.variant = v28

	v27.fillBehavior = fillBehavior.Fill
	v27.width = UDim.new(1, 0)
	v27.isLoading = props.isCreatePending == true
	v27.isDisabled = (FFlagBuildAgentAdCampaignCard or FFlagBuildCheckGamePermissions) and props.isCreateDisabled == true
	v27.onActivated = props.onCreate
	local v25 = { Create = createElement4(button, v27), DontShowAgain = 0 }

	local v29 = if not FFlagBuildAgentAdCampaignCard or props.onDismiss ~= nil then React.createElement(button, {
		LayoutOrder = 2,
		text = dontShowAgain,
		size = inputSize.Small,
		variant = buttonVariant.Standard,
		fillBehavior = fillBehavior.Fill,
		width = UDim.new(1, 0),
		onActivated = props.onDismiss,
		testId = "AdUpsellCard.DontShowAgain"
	}) else nil
	v25.DontShowAgain = v29
	children.Actions = createElement3(
		view,
		{ LayoutOrder = 2, tag = "row gap-small size-full-0 auto-y" },
		v25
	)
	return createElement(view, v18, children)
end

return AdUpsellCard
