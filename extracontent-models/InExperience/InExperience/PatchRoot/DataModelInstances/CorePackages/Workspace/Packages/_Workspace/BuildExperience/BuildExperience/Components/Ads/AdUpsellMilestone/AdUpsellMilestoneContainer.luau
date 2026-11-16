local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local AdUpsellMilestoneView = require(script.Parent.AdUpsellMilestoneView)
local useAdUpsellMilestoneViewModel = require(script.Parent.useAdUpsellMilestoneViewModel)

local function AdUpsellMilestoneContainer(p)
	local v = useAdUpsellMilestoneViewModel(p)
	return React.createElement(AdUpsellMilestoneView, v)
end

return AdUpsellMilestoneContainer
