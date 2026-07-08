local GuiService = game:GetService("GuiService")
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local withStyle = require(ParentParent.Core.Style.withStyle)
local BaseMenu = require(script.Parent.BaseMenu)
local validateButtonProps = require(script.Parent.validateButtonProps)
local validateColorInfo = require(ParentParent.Core.Style.Validator.validateColorInfo)
local v10 = Roact.PureComponent:extend("DropdownMenuList")

v10.validateProps = t.strictInterface({
	buttonProps = validateButtonProps,
	zIndex = t.optional(t.integer),
	open = t.boolean,
	showDropShadow = t.boolean,
	fixedListHeight = t.optional(t.number),
	openPositionY = t.UDim,
	closeBackgroundVisible = t.optional(t.boolean),
	screenSize = t.Vector2,
	onDismiss = t.optional(t.callback),
	buttonSize = t.UDim2,
	menuListBackground = t.optional(validateColorInfo),
	enableTokenOverride = t.optional(t.boolean),
	selectionOrder = t.optional(t.number),
	menuPositionFixed = t.optional(t.boolean)
})
v10.defaultProps = {
	zIndex = 2,
	closeBackgroundVisible = false,
	showDropShadow = false,
	fixedListHeight = nil,
	menuListBackground = nil,
	enableTokenOverride = false,
	menuPositionFixed = false
}

function v10.init(p1) -- line: 50
	p1:setState({
		visible = false,
		absolutePosition = Vector2.new(0, 0)
	})

	function p1.setAbsolutePosition(p2) -- line: 56
		-- upvalues: p1 (copy)
		p1:setState({
			absolutePosition = p2.AbsolutePosition
		})
	end
	function p1.dismissMenu() -- line: 62
		-- upvalues: p1 (copy)
		if p1.state.visible then
			p1:setState({
				visible = false
			})
			p1.props.onDismiss()
		end
	end
end
function v10.render(p3) -- line: 72
	-- upvalues: withStyle (copy), GuiService (copy), Roact (copy), BaseMenu (copy)
	return withStyle(function(p4) -- line: 73
		-- upvalues: GuiService (copy), p3 (copy), Roact (copy), BaseMenu (copy)
		local v19, v20 = GuiService:GetGuiInset()
		local v21 = p3.state.absolutePosition + v19
		local n1 = 0
		local n2 = 1
		local buttonSizeY = p3.props.buttonSize.Y
		local buttonSizeX = p3.props.buttonSize.X

		if p3.state.absolutePosition.Y > p3.props.screenSize.Y / 2 then
			n1 = 1
			n2 = -1
			buttonSizeY = UDim.new(0, 0)
		end

		local v26 = if n2 ~= 1 then buttonSizeY - p3.props.openPositionY else buttonSizeY + p3.props.openPositionY
		local uDim2 = UDim2.new(0, 0, v26.Scale, v26.Offset)

		if p3.props.screenSize.X < 640 and not p3.props.menuPositionFixed then
			n1 = 1
			uDim2 = UDim2.new(-p3.props.buttonSize.X.Scale / 2, -v21.X + p3.props.screenSize.X / 2 - p3.props.buttonSize.X.Offset / 2, 0, p3.props.screenSize.Y - v21.Y - v20.Y - 24)
		end

		local OverlayTransparency = p4.Theme.Overlay.Transparency

		if not p3.props.closeBackgroundVisible then
			OverlayTransparency = 1
		end

		return Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Visible = p3.state.visible,
			ZIndex = p3.props.zIndex,
			[Roact.Change.AbsolutePosition] = p3.setAbsolutePosition
		}, {
			Background = Roact.createElement("TextButton", {
				ZIndex = 1,
				Text = "",
				BorderSizePixel = 0,
				BackgroundColor3 = p4.Theme.Overlay.Color,
				BackgroundTransparency = OverlayTransparency,
				AutoButtonColor = false,
				Selectable = false,
				Position = UDim2.fromOffset(-v21.X, -v21.Y),
				Size = UDim2.fromOffset(p3.props.screenSize.X, p3.props.screenSize.Y),
				[Roact.Event.Activated] = p3.dismissMenu
			}),
			PositionFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1),
				Position = uDim2
			}, {
				BaseMenu = Roact.createElement(BaseMenu, {
					buttonProps = p3.props.buttonProps,
					showDropShadow = p3.props.showDropShadow,
					fixedListHeight = p3.props.fixedListHeight,
					width = buttonSizeX,
					position = UDim2.fromScale(0, 0),
					anchorPoint = Vector2.new(0, n1),
					background = p3.props.menuListBackground,
					enableTokenOverride = p3.props.enableTokenOverride,
					selectionOrder = p3.props.selectionOrder
				})
			})
		})
	end)
end
function v10.didMount(p5) -- line: 155
	if p5.props.open then
		p5:setState({
			visible = true
		})
	end
end
function v10.didUpdate(p6, p7, _) -- line: 163
	if p6.props.open ~= p7.open then
		if p6.props.open then
			p6:setState({
				visible = true
			})

			return
		end

		p6:setState({
			visible = false
		})
	end
end

return v10
