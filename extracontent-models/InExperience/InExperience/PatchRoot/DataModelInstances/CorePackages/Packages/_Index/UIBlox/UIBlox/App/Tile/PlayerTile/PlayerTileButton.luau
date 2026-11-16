local App = script:FindFirstAncestor("App")
local parent = App.Parent
local core = parent.Core
local parent2 = parent.Parent

local t = require(parent2.t)
local Roact = require(parent2.Roact)

local Button = require(App.Button.Button)
local ButtonType = require(App.Button.Enum.ButtonType)
local ControlState = require(core.Control.Enum.ControlState)

local extended = Roact.PureComponent:extend("PlayerTileButton")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = {
	isSecondary = false,
	isDisabled = false,
	buttonHeight = 36,
	outerButtonPadding = 10,
	tileSize = UDim2.new(0, 150, 0, 150),
	isRoactGamepadEnabled = true
}

function extended.render(p)
	local isSecondary = p.props.isSecondary
	local onActivated = p.props.onActivated
	local isDisabled = p.props.isDisabled
	local icon = p.props.icon
	local buttonHeight = p.props.buttonHeight
	local outerButtonPadding = p.props.outerButtonPadding
	local v = p.props.tileSize.X.Offset / 2 - outerButtonPadding * 1.5
	local udim = UDim2.new(0, v, 0, buttonHeight)

	local secondary = isSecondary and ButtonType.Secondary or ButtonType.PrimarySystem

	return Roact.createElement(Button, {
		buttonType = secondary,
		automaticSize = Enum.AutomaticSize.XY,
		position = UDim2.new(1, 0, 1, 0),
		size = udim,
		anchorPoint = Vector2.new(1, 1),
		onActivated = onActivated or function() end,
		isDisabled = isDisabled,
		icon = icon,
		isRoactGamepadEnabled = p.props.isRoactGamepadEnabled,
		onStateChanged = function(p2, p3)
			if p2 == ControlState.Hover then
				p.props.mouseEnter()
			elseif p3 == ControlState.Hover then
				p.props.mouseLeave()
			end
		end
	})
end

return extended
