local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local UIBlox = require(Parent.UIBlox)
local Text = require(Parent.AppCommonLib).Text
local v5 = Roact.PureComponent:extend("SystemButton")

v5.defaultProps = {
	text = "Text",
	enabled = false,
	onActivated = nil
}

function v5.render(p1) -- line: 17
	-- upvalues: UIBlox (copy), Text (copy), Roact (copy)
	return UIBlox.Style.withStyle(function(p2) -- line: 18
		-- upvalues: p1 (copy), Text (copy), Roact (copy)
		local text = p1.props.text
		local Header1Font = p2.Font.Header1.Font
		local v10 = Text.GetTextWidth(text, Header1Font, 24)
		local v11 = not p1.props.enabled and 0.7 or 0

		return Roact.createElement("TextButton", {
			BackgroundTransparency = 1,
			Text = "",
			Size = UDim2.new(0, v10 + 8, 1, 0),
			[Roact.Event.Activated] = p1.props.onActivated
		}, {
			layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			label = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextSize = 24,
				Size = UDim2.new(0, v10, 0, 24),
				Text = text,
				Font = Header1Font,
				TextColor3 = p2.Theme.SystemPrimaryDefault.Color,
				TextTransparency = v11
			})
		})
	end)
end

return v5
