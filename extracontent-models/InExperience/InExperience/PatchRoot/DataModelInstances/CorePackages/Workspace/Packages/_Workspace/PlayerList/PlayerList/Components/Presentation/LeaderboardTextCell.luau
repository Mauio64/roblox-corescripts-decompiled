local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text

local function LeaderboardTextCell(t1: {[any]: any}) -- line: 19
	-- upvalues: React (copy), View (copy), FoundationText (copy)
	return React.createElement(View, {
		tag = "clip",
		Size = UDim2.fromOffset(t1.width, t1.rowHeight),
		LayoutOrder = t1.layoutOrder
	}, {
		Text = React.createElement(FoundationText, {
			Text = t1.text,
			tag = t1.textTag or "size-full text-body-small text-align-x-left content-default"
		})
	})
end

return React.memo(LeaderboardTextCell)
