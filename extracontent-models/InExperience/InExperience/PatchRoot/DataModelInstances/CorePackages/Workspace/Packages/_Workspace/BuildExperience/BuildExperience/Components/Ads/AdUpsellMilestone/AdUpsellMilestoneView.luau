local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local AdUpsellCard = require(BuildExperience.Components.Ads.AdUpsellCard)
local FFlagBuildAgentAdCampaignCard = require(BuildExperience.Flags.FFlagBuildAgentAdCampaignCard)
local FFlagBuildExperienceChatCardEmphasis = require(BuildExperience.Flags.FFlagBuildExperienceChatCardEmphasis)
local FFlagBuildAdUpsellPinned = require(BuildExperience.Flags.FFlagBuildAdUpsellPinned)

local Text = Foundation.Text
local View = Foundation.View

local function AdUpsellMilestoneView(props)
	local createElement = React.createElement
	local v = {
		LayoutOrder = props.order,
		tag = {
			["size-full-0 auto-y"] = FFlagBuildAdUpsellPinned,
			["col gap-xxlarge size-full-0 auto-y"] = not FFlagBuildAdUpsellPinned
		},
		testId = `AdUpsellMilestone.{props.order}`
	}
	local congrats

	if not FFlagBuildAdUpsellPinned then
		congrats = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.congratsText,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis",
			testId = `AdUpsellCongrats.{props.order}`
		})
	end

	local createElement2 = React.createElement
	local v2 = {
		LayoutOrder = FFlagBuildAdUpsellPinned and 1 or 2,
		containerRef = props.cardRef,
		isCreatePending = props.isCreatePending,
		freePromotionsRemaining = 0,
		isCreateDisabled = 0,
		onCreate = 0,
		onDismiss = 0,
		emphasisOrder = 0
	}
	local freePromotionsRemaining

	if FFlagBuildAgentAdCampaignCard then
		freePromotionsRemaining = props.freePromotionsRemaining
	end

	v2.freePromotionsRemaining = freePromotionsRemaining

	v2.isCreateDisabled = props.isCreateDisabled == true
	v2.onCreate = props.onCreate
	v2.onDismiss = props.onDismiss
	local emphasisOrder

	if FFlagBuildExperienceChatCardEmphasis then
		emphasisOrder = props.order
	end

	v2.emphasisOrder = emphasisOrder
	return createElement(View, v, {
		Congrats = congrats,
		Card = createElement2(AdUpsellCard, v2)
	})
end

return AdUpsellMilestoneView
