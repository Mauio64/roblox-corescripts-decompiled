local CorePackages = game:GetService("CorePackages")

local Constants = require(script.Parent.Parent.Constants)
local Roact = require(CorePackages.Packages.Roact)

local extended = Roact.Component:extend("NumberInput")

function extended:init()
	self.state = { Value = self.props.DefaultValue }
end

function extended.render(object)
	local props = object.props

	return Roact.createElement("TextBox", {
		Font = Constants.Font.Log,
		Text = `{object.state.Value}`,
		TextColor3 = Constants.Color.Text,
		TextSize = Constants.GeneralFormatting.NumberInputTextSize,
		TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Center,
		BackgroundColor3 = Constants.Color.TextBoxGray,
		BorderColor3 = Constants.GeneralFormatting.LineColor,
		LayoutOrder = props.LayoutOrder,
		Size = props.Size,
		ClearTextOnFocus = true,
		[Roact.Event.FocusLost] = function(p)
			local text = tonumber(p.Text)

			if text == nil or text ~= text then
				p.Text = `{object.state.Value}`
				return
			end

			if props.IntegerOnly then
				text = math.floor(text)
			end

			local v = math.clamp(text, props.Range.Min, props.Range.Max)

			object:setState({ Value = v })

			p.Text = `{v}`

			if props.OnNumberInputChanged then
				props.OnNumberInputChanged(v)
			end
		end
	})
end

return extended
