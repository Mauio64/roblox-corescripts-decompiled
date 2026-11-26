local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local AdUpsellMilestoneView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/AdUpsellMilestone/AdUpsellMilestoneView")
local useAdUpsellMilestoneViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/AdUpsellMilestone/useAdUpsellMilestoneViewModel")

local function AdUpsellMilestoneContainer(p2)
	local v5 = useAdUpsellMilestoneViewModel(p2)
	return React.createElement(AdUpsellMilestoneView, v5)
end

return AdUpsellMilestoneContainer
