local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local button = Foundation.Button
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

local function AdCampaignIsActiveCard(props)
	local variant = props.variant or "active"
	local v5

	if props.campaignStartDate == nil or props.campaignStartDate == "" or props.campaignEndDate == nil then
		v5 = false
	else
		v5 = props.campaignEndDate ~= ""
	end

	local v6

	if variant == "complete" then
		v6 = LocalizationStrings.AD_CAMPAIGN_CARD_TITLE_COMPLETE
	else
		v6 = LocalizationStrings.AD_CAMPAIGN_CARD_TITLE_ACTIVE
	end

	local v7

	if variant == "complete" then
		v7 = LocalizationStrings.AD_CAMPAIGN_CARD_DESC_COMPLETE
	else
		v7 = LocalizationStrings.AD_CAMPAIGN_CARD_ACTIVE_DESC
	end

	local v8 = useLocalization({
		title = v6,
		description = {
			v7,
			startDate = props.campaignStartDate or "",
			endDate = props.campaignEndDate or ""
		},
		view = LocalizationStrings.AD_CAMPAIGN_CARD_VIEW
	})

	local createElement = React.createElement
	local v10 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col gap-large size-full-0 auto-y padding-large stroke-standard stroke-default radius-large bg-surface-0",
		testId = "AdCampaignIsActiveCard"
	}

	local createElement2 = React.createElement

	local v13 = {
		Title = React.createElement(text, {
			LayoutOrder = 1,
			Text = v8.title,
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
		}),
		Description = 0
	}

	local v14 = if variant == "complete" or v5 then React.createElement(text, {
		LayoutOrder = 2,
		Text = v8.description,
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis",
		testId = "AdCampaignIsActiveCard.Schedule"
	}) else nil
	v13.Description = v14
	return createElement(view, v10, {
		Content = createElement2(view, {
			LayoutOrder = 1,
			tag = "col gap-xxsmall size-full-0 auto-y"
		}, v13),
		Action = React.createElement(button, {
			LayoutOrder = 2,
			text = v8.view,
			size = inputSize.Small,
			variant = buttonVariant.Standard,
			width = UDim.new(1, 0),
			isDisabled = props.isDisabled == true,
			onActivated = props.onActivated,
			testId = "AdCampaignIsActiveCard.Action"
		})
	})
end

return AdCampaignIsActiveCard
