local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local t = InGameMenuDependencies.t
local Roact = InGameMenuDependencies.Roact

local CloseMenuButton = require(script.Parent.CloseMenuButton)
local GameIconButton = require(script.Parent.GameIconButton)

local extended = Roact.PureComponent:extend("SystemMenuButton")

extended.validateProps = t.strictInterface({
	on = t.optional(t.boolean),
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	layoutOrder = t.optional(t.integer),
	onActivated = t.callback,
	onClose = t.callback,
	canCaptureFocus = t.optional(t.boolean)
})

extended.defaultProps = { on = false, canCaptureFocus = false }

function extended:tryCaptureFocus(p)
	if
		self.props.canCaptureFocus and not p.canCaptureFocus
		or self.props.canCaptureFocus and self.props.on ~= p.on and self.state.isIconFocused
	then
		GuiService.SelectedCoreObject = self.iconRef:getValue()
	end
end

function extended:init()
	self.iconRef = Roact.createRef()

	self:setState({ isIconFocused = false })

	function self.onIconSelectionGained()
		self:setState({ isIconFocused = true })
	end

	function self.onIconSelectionLost()
		self:setState({ isIconFocused = false })
	end
end

function extended:didMount()
	self:tryCaptureFocus({ canCaptureFocus = false })
end

function extended:didUpdate(p)
	self:tryCaptureFocus(p)
end

function extended.render(props)
	if props.props.on then
		return Roact.createElement(CloseMenuButton, {
			onActivated = props.props.onClose,
			layoutOrder = props.props.layoutOrder,
			AnchorPoint = props.props.anchorPoint,
			Position = props.props.position,
			onSelectionGained = props.onIconSelectionGained,
			onSelectionLost = props.onIconSelectionLost,
			[Roact.Ref] = props.iconRef
		})
	end

	return Roact.createElement(GameIconButton, {
		onActivated = props.props.onActivated,
		layoutOrder = props.props.layoutOrder,
		anchorPoint = props.props.anchorPoint,
		position = props.props.position,
		onSelectionGained = props.onIconSelectionGained,
		onSelectionLost = props.onIconSelectionLost,
		[Roact.Ref] = props.iconRef
	})
end

return extended
