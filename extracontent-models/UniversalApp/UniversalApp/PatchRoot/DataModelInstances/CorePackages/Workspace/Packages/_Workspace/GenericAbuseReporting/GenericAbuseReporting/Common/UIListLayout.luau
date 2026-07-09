local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local React = require(GenericAbuseReporting.Parent.React)

local function UIListLayout(t1: {[any]: any}) -- line: 12
	-- upvalues: React (copy)
	return React.createElement("UIListLayout", {
		FillDirection = t1.FillDirection,
		HorizontalAlignment = t1.HorizontalAlignment,
		Padding = t1.Padding,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = t1.VerticalAlignment,
		ref = t1.Ref
	})
end

return UIListLayout
