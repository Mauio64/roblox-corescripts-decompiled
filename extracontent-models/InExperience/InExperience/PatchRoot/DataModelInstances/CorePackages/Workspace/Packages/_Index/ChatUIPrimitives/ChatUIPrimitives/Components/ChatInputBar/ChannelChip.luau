local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

return function(props)
	local visible = (props.sideChipText or "") ~= "" and props.showSideChip ~= false

	return React.createElement(Foundation.Text, {
		tag = "text-caption-medium text-wrap content-emphasis",
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromScale(0, 1),
		Text = props.sideChipText or "",
		TextTransparency = props.transparency or 1,
		Visible = visible,
		[React.Change.AbsoluteSize] = props.onAbsoluteSizeChanged,
		onActivated = props.onSideChipActivated
	})
end
