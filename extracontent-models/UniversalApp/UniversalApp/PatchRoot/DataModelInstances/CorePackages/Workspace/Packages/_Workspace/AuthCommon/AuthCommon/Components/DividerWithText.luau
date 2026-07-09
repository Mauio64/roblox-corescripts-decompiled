local Parent = script:FindFirstAncestor("AuthCommon").Parent
local React = require(Parent.React)
local TextService = game:GetService("TextService")

return function(t1: {[any]: any}) -- line: 20
	-- upvalues: TextService (copy), React (copy)
	local X = TextService:GetTextSize(t1.text, t1.fontSize, t1.font, Vector2.new(1e999, t1.fontSize)).X

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		Size = if not t1.size then UDim2.new(0, t1.width, 0, t1.height) else t1.size
	}, React.createElement("Frame", {
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0.5, -X / 2 - t1.padding, 0, 1),
		BackgroundTransparency = t1.transparency,
		BackgroundColor3 = t1.color3
	}), React.createElement("Frame", {
		Position = UDim2.new(0.5, X / 2 + t1.padding, 0.5, 0),
		Size = UDim2.new(0.5, -X / 2 - t1.padding, 0, 1),
		BackgroundTransparency = t1.transparency,
		BackgroundColor3 = t1.color3
	}), React.createElement("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Text = t1.text,
		TextSize = t1.fontSize,
		Font = t1.font,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextTransparency = t1.transparency,
		TextColor3 = t1.color3
	}))
end
