local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Text = require(Foundation.Components.Text)
local View = require(Foundation.Components.View)

require(Foundation.Enums.PaginationSize)

local ParentParent = script.Parent.Parent
local paginationUtils = require(ParentParent.paginationUtils)

local function Ellipsis(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), View (copy), paginationUtils (copy), Text (copy)
	return React.createElement(View, {
		LayoutOrder = t1.layoutOrder,
		tag = paginationUtils.getCircularSlotTag(t1.slotSize),
		testId = t1.testId
	}, {
		Text = React.createElement(Text, {
			Text = "...",
			LayoutOrder = 1,
			tag = paginationUtils.getPageLabelTag(t1.slotSize)
		})
	})
end

return React.memo(Ellipsis)
