local App = script:FindFirstAncestor("App")
local AppParent = App.Parent
local Core = AppParent.Core
local AppParentParent = AppParent.Parent
local t = require(AppParentParent.t)
local Roact = require(AppParentParent.Roact)
local Button = require(App.Button.Button)
local ButtonType = require(App.Button.Enum.ButtonType)
local ControlState = require(Core.Control.Enum.ControlState)
local v10 = Roact.PureComponent:extend("PlayerTileButton")

v10.validateProps = t.strictInterface({
	buttonHeight = t.optional(t.number),
	buttonWidth = t.optional(t.number),
	outerButtonPadding = t.optional(t.number),
	icon = t.union(t.string, t.table),
	onActivated = t.optional(t.callback),
	isSecondary = t.optional(t.boolean),
	isDisabled = t.optional(t.boolean),
	tileSize = t.optional(t.UDim2),
	mouseEnter = t.optional(t.callback),
	mouseLeave = t.optional(t.callback),
	isRoactGamepadEnabled = t.optional(t.boolean)
})
v10.defaultProps = {
	isSecondary = false,
	isDisabled = false,
	buttonHeight = 36,
	outerButtonPadding = 10,
	isRoactGamepadEnabled = true,
	tileSize = UDim2.new(0, 150, 0, 150)
}

function v10.render(p1) -- line: 42
	-- upvalues: ButtonType (copy), Roact (copy), Button (copy), ControlState (copy)
	local isSecondary = p1.props.isSecondary
	local onActivated = p1.props.onActivated
	local isDisabled = p1.props.isDisabled
	local icon = p1.props.icon
	local buttonHeight = p1.props.buttonHeight
	local outerButtonPadding = p1.props.outerButtonPadding
	local v18 = p1.props.tileSize.X.Offset / 2 - outerButtonPadding * 1.5
	local uDim2 = UDim2.new(0, v18, 0, buttonHeight)
	local v20 = isSecondary and ButtonType.Secondary or ButtonType.PrimarySystem

	return Roact.createElement(Button, {
		buttonType = v20,
		automaticSize = Enum.AutomaticSize.XY,
		position = UDim2.new(1, 0, 1, 0),
		size = uDim2,
		anchorPoint = Vector2.new(1, 1),
		onActivated = onActivated or function() -- line: 62
		end,
		isDisabled = isDisabled,
		icon = icon,
		isRoactGamepadEnabled = p1.props.isRoactGamepadEnabled,
		onStateChanged = function(p2, p3) -- line: 66
			-- upvalues: ControlState (copy), p1 (copy)
			if p2 == ControlState.Hover then
				p1.props.mouseEnter()

				return
			end

			if p3 == ControlState.Hover then
				p1.props.mouseLeave()
			end
		end
	})
end

return v10
