local Parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

return function(t1: {[any]: any}) -- line: 14
	-- upvalues: React (copy), Foundation (copy)
	local v5 = (t1.sideChipText or "") ~= "" and t1.showSideChip ~= false

	return React.createElement(Foundation.Text, {
		tag = "text-caption-medium text-wrap content-emphasis",
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromScale(0, 1),
		Text = t1.sideChipText or "",
		TextTransparency = t1.transparency or 1,
		Visible = v5,
		[React.Change.AbsoluteSize] = t1.onAbsoluteSizeChanged,
		onActivated = t1.onSideChipActivated
	})
end
