local parent = script.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local t = require(parent3.t)

local withStyle = require(parent2.Core.Style.withStyle)
local GenericTextLabel = require(parent2.Core.Text.GenericTextLabel.GenericTextLabel)
local KeyLabel = require(parent.Menu.KeyLabel.KeyLabel)

local BarConstants = require(script.Parent.BarConstants)
local ControllerBarHintInternalPadding = BarConstants.ControllerBarHintInternalPadding

local extended = Roact.PureComponent:extend("ControllerBarHint")

extended.validateProps = t.strictInterface({
	layoutOrder = t.optional(t.integer),
	keyCode = t.enum(Enum.KeyCode),
	text = t.string,
	maxWidth = t.optional(t.number),
	hintTextSize = t.optional(t.number)
})

function extended.render(p)
	return withStyle(function(p2)
		local theme = p2.Theme
		local font = p2.Font

		local createElement = Roact.createElement
		local v = {
			LayoutOrder = p.props.layoutOrder,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.X
		}
		local v2 = {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, ControllerBarHintInternalPadding)
			}),
			ControllerBarHintIcon = Roact.createElement(KeyLabel, {
				keyCode = p.props.keyCode,
				LayoutOrder = 1,
				iconThemeKey = "IconEmphasis"
			}),
			ControllerBarHintText = 0
		}

		local createElement2 = Roact.createElement
		local v3 = {
			TextSize = p.props.hintTextSize,
			maxSize = p.props.maxWidth and Vector2.new(p.props.maxWidth) or nil,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			fontStyle = font.Header2,
			colorStyle = theme.TextEmphasis,
			AutomaticSize = 0,
			TextTransparency = 0,
			fluidSizing = 0,
			Text = 0,
			TextTruncate = 0,
			TextXAlignment = 0,
			TextYAlignment = 0
		}
		local automaticSize

		if not p.props.maxWidth then
			automaticSize = Enum.AutomaticSize.X or nil
		end

		v3.AutomaticSize = automaticSize

		v3.TextTransparency = theme.TextEmphasis.TextTransparency
		v3.fluidSizing = p.props.maxWidth and true or false
		v3.Text = p.props.text

		v3.TextTruncate = p.props.maxWidth and Enum.TextTruncate.AtEnd or nil

		v3.TextXAlignment = Enum.TextXAlignment.Left
		v3.TextYAlignment = Enum.TextYAlignment.Center
		v2.ControllerBarHintText = createElement2(GenericTextLabel, v3)
		return createElement("Frame", v, v2)
	end)
end

return extended
