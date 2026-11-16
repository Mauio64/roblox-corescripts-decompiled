local GuiService = game:GetService("GuiService")

local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local t = require(parent2.t)

local withStyle = require(parent.Core.Style.withStyle)
local BaseMenu = require(script.Parent.BaseMenu)
local validateButtonProps = require(script.Parent.validateButtonProps)
local validateColorInfo = require(parent.Core.Style.Validator.validateColorInfo)

local extended = Roact.PureComponent:extend("DropdownMenuList")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = {
	zIndex = 2,
	closeBackgroundVisible = false,
	showDropShadow = false,
	fixedListHeight = nil,
	menuListBackground = nil,
	enableTokenOverride = false,
	menuPositionFixed = false
}

function extended:init()
	self:setState({ absolutePosition = Vector2.new(0, 0), visible = false })

	function self.setAbsolutePosition(p)
		self:setState({ absolutePosition = p.AbsolutePosition })
	end

	function self.dismissMenu()
		if self.state.visible then
			self:setState({ visible = false })

			self.props.onDismiss()
		end
	end
end

function extended.render(data)
	return withStyle(function(p)
		local guiInset, v = GuiService:GetGuiInset()
		local v2 = data.state.absolutePosition + guiInset

		local v3 = data.props.buttonSize.Y
		local x = data.props.buttonSize.X
		local v4, v5

		if data.state.absolutePosition.Y > data.props.screenSize.Y / 2 then
			v3 = UDim.new(0, 0)
			v4 = -1
			v5 = 1
		else
			v4 = 1
			v5 = 0
		end

		local v6

		if v4 == 1 then
			v6 = v3 + data.props.openPositionY
		else
			v6 = v3 - data.props.openPositionY
		end

		local udim = UDim2.new(0, 0, v6.Scale, v6.Offset)

		if data.props.screenSize.X < 640 and not data.props.menuPositionFixed then
			udim = UDim2.new(
				-data.props.buttonSize.X.Scale / 2,
				-v2.X + data.props.screenSize.X / 2 - data.props.buttonSize.X.Offset / 2,
				0,
				data.props.screenSize.Y - v2.Y - v.Y - 24
			)
			v5 = 1
		end

		local transparency = p.Theme.Overlay.Transparency
		local backgroundTransparency = not data.props.closeBackgroundVisible and 1 or transparency

		return Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Visible = data.state.visible,
			ZIndex = data.props.zIndex,
			[Roact.Change.AbsolutePosition] = data.setAbsolutePosition
		}, {
			Background = Roact.createElement("TextButton", {
				ZIndex = 1,
				Text = "",
				BorderSizePixel = 0,
				BackgroundColor3 = p.Theme.Overlay.Color,
				BackgroundTransparency = backgroundTransparency,
				AutoButtonColor = false,
				Selectable = false,
				Position = UDim2.fromOffset(-v2.X, -v2.Y),
				Size = UDim2.fromOffset(data.props.screenSize.X, data.props.screenSize.Y),
				[Roact.Event.Activated] = data.dismissMenu
			}),
			PositionFrame = Roact.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					Position = udim,
					ZIndex = 2
				},
				{
					BaseMenu = Roact.createElement(BaseMenu, {
						buttonProps = data.props.buttonProps,
						showDropShadow = data.props.showDropShadow,
						fixedListHeight = data.props.fixedListHeight,
						width = x,
						position = UDim2.fromScale(0, 0),
						anchorPoint = Vector2.new(0, v5),
						background = data.props.menuListBackground,
						enableTokenOverride = data.props.enableTokenOverride,
						selectionOrder = data.props.selectionOrder
					})
				}
			)
		})
	end)
end

function extended.didMount(object)
	if object.props.open then
		object:setState({ visible = true })
	end
end

function extended.didUpdate(object, p, _)
	if object.props.open ~= p.open then
		if object.props.open then
			object:setState({ visible = true })
		else
			object:setState({ visible = false })
		end
	end
end

return extended
