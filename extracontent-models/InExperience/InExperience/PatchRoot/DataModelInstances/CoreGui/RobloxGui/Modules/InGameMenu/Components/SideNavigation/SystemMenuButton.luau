local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local t = InGameMenuDependencies.t
local Roact = InGameMenuDependencies.Roact
local CloseMenuButton = require(script.Parent.CloseMenuButton)
local GameIconButton = require(script.Parent.GameIconButton)
local v8 = Roact.PureComponent:extend("SystemMenuButton")

v8.validateProps = t.strictInterface({
	on = t.optional(t.boolean),
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	layoutOrder = t.optional(t.integer),
	onActivated = t.callback,
	onClose = t.callback,
	canCaptureFocus = t.optional(t.boolean)
})
v8.defaultProps = {
	on = false,
	canCaptureFocus = false
}

function v8.tryCaptureFocus(p1, p2) -- line: 28
	-- upvalues: GuiService (copy)
	if p1.props.canCaptureFocus and not p2.canCaptureFocus or p1.props.canCaptureFocus and p1.props.on ~= p2.on and p1.state.isIconFocused then
		GuiService.SelectedCoreObject = p1.iconRef:getValue()
	end
end
function v8.init(p3) -- line: 37
	-- upvalues: Roact (copy)
	p3.iconRef = Roact.createRef()
	p3:setState({
		isIconFocused = false
	})

	function p3.onIconSelectionGained() -- line: 44
		-- upvalues: p3 (copy)
		p3:setState({
			isIconFocused = true
		})
	end
	function p3.onIconSelectionLost() -- line: 50
		-- upvalues: p3 (copy)
		p3:setState({
			isIconFocused = false
		})
	end
end
function v8.didMount(p4) -- line: 57
	p4:tryCaptureFocus({
		canCaptureFocus = false
	})
end
function v8.didUpdate(p5, p6) -- line: 62
	p5:tryCaptureFocus(p6)
end
function v8.render(p7) -- line: 66
	-- upvalues: Roact (copy), CloseMenuButton (copy), GameIconButton (copy)
	if p7.props.on then
		return Roact.createElement(CloseMenuButton, {
			onActivated = p7.props.onClose,
			layoutOrder = p7.props.layoutOrder,
			AnchorPoint = p7.props.anchorPoint,
			Position = p7.props.position,
			onSelectionGained = p7.onIconSelectionGained,
			onSelectionLost = p7.onIconSelectionLost,
			[Roact.Ref] = p7.iconRef
		})
	end

	return Roact.createElement(GameIconButton, {
		onActivated = p7.props.onActivated,
		layoutOrder = p7.props.layoutOrder,
		anchorPoint = p7.props.anchorPoint,
		position = p7.props.position,
		onSelectionGained = p7.onIconSelectionGained,
		onSelectionLost = p7.onIconSelectionLost,
		[Roact.Ref] = p7.iconRef
	})
end

return v8
