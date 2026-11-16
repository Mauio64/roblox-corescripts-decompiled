local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local AdUpsellCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/AdUpsellCard")
local FFlagBuildAgentAdCampaignCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAgentAdCampaignCard")
local FFlagBuildExperienceChatCardEmphasis = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatCardEmphasis")
local FFlagBuildAdUpsellPinned = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdUpsellPinned")

local text = Foundation.Text
local view = Foundation.View

local function AdUpsellMilestoneView(props)
	local createElement = React.createElement
	local v6 = {
		LayoutOrder = props.order,
		tag = {
			["size-full-0 auto-y"] = FFlagBuildAdUpsellPinned,
			["col gap-xxlarge size-full-0 auto-y"] = not FFlagBuildAdUpsellPinned
		},
		testId = `AdUpsellMilestone.{props.order}`
	}

	local v8 = if not FFlagBuildAdUpsellPinned then React.createElement(text, {
		LayoutOrder = 1,
		Text = props.congratsText,
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis",
		testId = `AdUpsellCongrats.{props.order}`
	}) else nil

	local createElement2 = React.createElement
	local v10 = {
		LayoutOrder = FFlagBuildAdUpsellPinned and 1 or 2,
		containerRef = props.cardRef,
		isCreatePending = props.isCreatePending,
		freePromotionsRemaining = 0,
		isCreateDisabled = 0,
		onCreate = 0,
		onDismiss = 0,
		emphasisOrder = 0
	}

	local v11 = if FFlagBuildAgentAdCampaignCard then props.freePromotionsRemaining else nil
	v10.freePromotionsRemaining = v11

	v10.isCreateDisabled = props.isCreateDisabled == true
	v10.onCreate = props.onCreate
	v10.onDismiss = props.onDismiss
	local v12 = if FFlagBuildExperienceChatCardEmphasis then props.order else nil
	v10.emphasisOrder = v12
	return createElement(view, v6, {
		Congrats = v8,
		Card = createElement2(AdUpsellCard, v10)
	})
end

return AdUpsellMilestoneView
