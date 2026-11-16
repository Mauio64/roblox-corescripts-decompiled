local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local Button = Foundation.Button
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function AdCampaignIsActiveCard(props)
	local variant = props.variant or "active"
	local v

	if props.campaignStartDate == nil or props.campaignStartDate == "" or props.campaignEndDate == nil then
		v = false
	else
		v = props.campaignEndDate ~= ""
	end

	local title

	if variant == "complete" then
		title = LocalizationStrings.AD_CAMPAIGN_CARD_TITLE_COMPLETE
	else
		title = LocalizationStrings.AD_CAMPAIGN_CARD_TITLE_ACTIVE
	end

	local v2

	if variant == "complete" then
		v2 = LocalizationStrings.AD_CAMPAIGN_CARD_DESC_COMPLETE
	else
		v2 = LocalizationStrings.AD_CAMPAIGN_CARD_ACTIVE_DESC
	end

	local v3 = useLocalization({
		title = title,
		description = {
			v2,
			startDate = props.campaignStartDate or "",
			endDate = props.campaignEndDate or ""
		},
		view = LocalizationStrings.AD_CAMPAIGN_CARD_VIEW
	})

	local createElement = React.createElement
	local v4 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col gap-large size-full-0 auto-y padding-large stroke-standard stroke-default radius-large bg-surface-0",
		testId = "AdCampaignIsActiveCard"
	}

	local createElement2 = React.createElement

	local v5 = {
		Title = React.createElement(Text, {
			LayoutOrder = 1,
			Text = v3.title,
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
		}),
		Description = 0
	}
	local description

	if variant == "complete" or v then
		description = React.createElement(Text, {
			LayoutOrder = 2,
			Text = v3.description,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis",
			testId = "AdCampaignIsActiveCard.Schedule"
		})
	end

	v5.Description = description
	return createElement(View, v4, {
		Content = createElement2(View, {
			LayoutOrder = 1,
			tag = "col gap-xxsmall size-full-0 auto-y"
		}, v5),
		Action = React.createElement(Button, {
			LayoutOrder = 2,
			text = v3.view,
			size = InputSize.Small,
			variant = ButtonVariant.Standard,
			width = UDim.new(1, 0),
			isDisabled = props.isDisabled == true,
			onActivated = props.onActivated,
			testId = "AdCampaignIsActiveCard.Action"
		})
	})
end

return AdCampaignIsActiveCard
