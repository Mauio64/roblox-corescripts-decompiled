local parent = script.Parent.Parent.Parent.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text

local function LeaderboardTextCell(props)
	return React.createElement(
		View,
		{
			Size = UDim2.fromOffset(props.width, props.rowHeight),
			LayoutOrder = props.layoutOrder,
			tag = "clip"
		},
		{
			Text = React.createElement(Text, {
				Text = props.text,
				tag = props.textTag or "size-full text-body-small text-align-x-left content-default"
			})
		}
	)
end

return React.memo(LeaderboardTextCell)
