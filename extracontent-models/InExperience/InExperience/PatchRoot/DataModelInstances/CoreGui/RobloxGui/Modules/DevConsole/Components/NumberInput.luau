local CorePackages = game:GetService("CorePackages")
local Constants = require(script.Parent.Parent.Constants)
local Roact = require(CorePackages.Packages.Roact)
local v4 = Roact.Component:extend("NumberInput")

function v4.init(p1) -- line: 18
	p1.state = {
		Value = p1.props.DefaultValue
	}
end
function v4.render(p2) -- line: 26
	-- upvalues: Roact (copy), Constants (copy)
	local props = p2.props

	return Roact.createElement("TextBox", {
		Font = Constants.Font.Log,
		Text = `{ p2.state.Value }`,
		TextColor3 = Constants.Color.Text,
		TextSize = Constants.GeneralFormatting.NumberInputTextSize,
		TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Center,
		BackgroundColor3 = Constants.Color.TextBoxGray,
		BorderColor3 = Constants.GeneralFormatting.LineColor,
		LayoutOrder = props.LayoutOrder,
		Size = props.Size,
		ClearTextOnFocus = true,
		[Roact.Event.FocusLost] = function(p3) -- line: 43
			-- upvalues: p2 (copy), props (copy)
			local num = tonumber(p3.Text)

			if num == nil or num ~= num then
				p3.Text = `{ p2.state.Value }`

				return
			end

			if props.IntegerOnly then
				num = math.floor(num)
			end

			local v10 = math.clamp(num, props.Range.Min, props.Range.Max)

			p2:setState({
				Value = v10
			})
			p3.Text = `{ v10 }`

			if props.OnNumberInputChanged then
				props.OnNumberInputChanged(v10)
			end
		end
	})
end

return v4
