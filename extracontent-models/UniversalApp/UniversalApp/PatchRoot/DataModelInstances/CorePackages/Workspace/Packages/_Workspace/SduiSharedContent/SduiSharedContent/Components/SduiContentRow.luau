local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View

local function SduiContentRow(t1: {[any]: any}) -- line: 28
	-- upvalues: React (copy), View (copy), Foundation (copy)
	return React.createElement(View, {
		tag = not t1.tag and "row auto-y gap-large" or t1.tag,
		LayoutOrder = t1.layoutOrder,
		Position = t1.position,
		ZIndex = t1.zIndex,
		Active = t1.onActivated ~= nil,
		onActivated = t1.onActivated,
		selection = {
			Selectable = false
		},
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		testId = t1.testId
	}, {
		LeadingColumn = if not t1.leading then nil else React.createElement(View, {
			LayoutOrder = 1,
			tag = t1.leadingTag or "col auto-xy"
		}, t1.leading),
		ContentColumn = if not t1.content then nil else React.createElement(View, {
			LayoutOrder = 2,
			tag = t1.contentTag or "col fill gap-small auto-xy"
		}, t1.content),
		TrailingColumn = if not t1.trailing then nil else React.createElement(View, {
			LayoutOrder = 3,
			tag = t1.trailingTag or "col auto-xy"
		}, t1.trailing)
	})
end

return React.memo(SduiContentRow)
