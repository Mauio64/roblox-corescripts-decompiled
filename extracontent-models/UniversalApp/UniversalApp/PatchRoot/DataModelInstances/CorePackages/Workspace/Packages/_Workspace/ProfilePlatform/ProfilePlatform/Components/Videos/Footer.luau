local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local function Footer(t1: {[any]: any}) -- line: 16
	-- upvalues: useTokens (copy), React (copy), FoundationText (copy)
	local v8 = useTokens()

	return React.createElement("Frame", {
		ClipsDescendants = false,
		BackgroundTransparency = 1,
		ZIndex = 3,
		LayoutOrder = t1.LayoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = t1.Position,
		AnchorPoint = t1.AnchorPoint
	}, {
		Text = React.createElement(FoundationText, {
			Text = t1.text,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			textStyle = v8.Color.Content.Emphasis,
			fontStyle = v8.Typography.TitleMedium,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.SplitWord
		})
	})
end

return Footer
