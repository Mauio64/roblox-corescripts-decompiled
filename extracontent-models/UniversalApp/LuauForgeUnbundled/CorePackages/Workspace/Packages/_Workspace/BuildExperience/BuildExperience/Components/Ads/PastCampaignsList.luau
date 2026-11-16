local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation").View

local PastCampaignRow = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/PastCampaignRow")

local function PastCampaignsList(props)
	local testId = props.testId or "PastCampaignsList"

	local children = {}

	for k, row in props.rows do
		local clone = table.clone(row)
		clone.layoutOrder = k
		children[`Row{k}`] = React.createElement(PastCampaignRow, clone)
	end

	return React.createElement(
		view,
		{
			LayoutOrder = props.layoutOrder,
			tag = "col gap-small size-full-0 auto-y",
			testId = testId
		},
		children
	)
end

return PastCampaignsList
