local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)
local RoactGamepad = require(ParentParent.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local t = require(ParentParent.t)
local v6 = Roact.Component:extend("FocusControllerProvider")

v6.validateProps = t.strictInterface({
	captureFocusOnMount = t.boolean,
	[Roact.Children] = t.table,
	focusController = t.optional(t.table)
})

function v6.init(p1) -- line: 17
	-- upvalues: RoactGamepad (copy)
	p1.focusController = p1.props.focusController or RoactGamepad.createFocusController()
end
function v6.render(p2) -- line: 21
	-- upvalues: Roact (copy), Focusable (copy)
	return Roact.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		focusController = p2.focusController,
		Size = UDim2.fromScale(1, 1)
	}, p2.props[Roact.Children])
end
function v6.didMount(p3) -- line: 30
	if p3.props.captureFocusOnMount then
		p3.focusController.captureFocus()
	end
end

return v6
