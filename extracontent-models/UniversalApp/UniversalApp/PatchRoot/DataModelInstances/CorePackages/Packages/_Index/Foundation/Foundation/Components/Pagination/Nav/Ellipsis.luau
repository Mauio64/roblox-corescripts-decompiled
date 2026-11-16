local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Text = require(Foundation.Components.Text)
local View = require(Foundation.Components.View)

require(Foundation.Enums.PaginationSize)

local parent2 = script.Parent.Parent
local paginationUtils = require(parent2.paginationUtils)

local function Ellipsis(props)
	return React.createElement(
		View,
		{
			LayoutOrder = props.LayoutOrder,
			tag = paginationUtils.getCircularSlotTag(props.slotSize),
			testId = props.testId
		},
		{
			Text = React.createElement(Text, {
				Text = "...",
				tag = paginationUtils.getPageLabelTag(props.slotSize),
				LayoutOrder = 1
			})
		}
	)
end

return React.memo(Ellipsis)
