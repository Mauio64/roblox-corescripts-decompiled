local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View

local PastCampaignRow = require(script.Parent.PastCampaignRow)

local function PastCampaignsList(props)
	local testId = props.testId or "PastCampaignsList"

	local children = {}

	for k, row in props.rows do
		local clone = table.clone(row)
		clone.layoutOrder = k
		children[`Row{k}`] = React.createElement(PastCampaignRow, clone)
	end

	return React.createElement(
		View,
		{
			LayoutOrder = props.layoutOrder,
			tag = "col gap-small size-full-0 auto-y",
			testId = testId
		},
		children
	)
end

return PastCampaignsList
