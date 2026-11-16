local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local useLocalization = Localization.Hooks.useLocalization
local ButtonVariant = Foundation.Enums.ButtonVariant

local function useAdCampaignCardViewModel(data)
	local v = data.variant == "active"

	local startDate = data.campaignStartTime == nil and ""
		or LocalizationStrings.formatCampaignDate(data.campaignStartTime)

	local endDate = data.campaignEndTime == nil and "" or LocalizationStrings.formatCampaignDate(data.campaignEndTime)

	local v2 = useLocalization({
		titleFree = LocalizationStrings.AD_CAMPAIGN_CARD_TITLE_FREE,
		titleActive = LocalizationStrings.AD_CAMPAIGN_CARD_TITLE_ACTIVE,
		descFree = LocalizationStrings.AD_CAMPAIGN_CARD_DESC_FREE,
		activeDesc = {
			LocalizationStrings.AD_CAMPAIGN_CARD_ACTIVE_DESC,
			startDate = startDate,
			endDate = endDate
		},
		view = LocalizationStrings.AD_CAMPAIGN_CARD_VIEW
	})

	local title = if v then v2.titleActive else v2.titleFree
	local description = if v then v2.activeDesc else v2.descFree
	local v3 = {
		title = title,
		description = description,
		actionText = v2.view,
		buttonVariant = 0,
		isLoading = 0,
		onActivated = 0
	}
	local buttonVariant

	if v then
		buttonVariant = ButtonVariant.Standard
	else
		buttonVariant = ButtonVariant.SoftEmphasis
	end

	v3.buttonVariant = buttonVariant
	v3.isLoading = data.isPrimaryPending == true
	v3.onActivated = data.onPrimary
	return v3
end

return useAdCampaignCardViewModel
