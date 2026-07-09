local Parent = script:FindFirstAncestor("ChallengeDialog").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local FitTextLabel = require(Parent.LuaSocialLibrariesDeps).RoactFitComponents.FitTextLabel
local withStyle = UIBlox.Style.withStyle

return function(t1: {[any]: any}) -- line: 17
	-- upvalues: withStyle (copy), React (copy), FitTextLabel (copy)
	local contentWidth = t1.contentWidth
	local layoutOrder = t1.layoutOrder
	local errorText = t1.errorText

	return withStyle(function(p1) -- line: 22
		-- upvalues: React (copy), FitTextLabel (copy), contentWidth (copy), layoutOrder (copy), errorText (copy)
		return React.createElement(FitTextLabel, {
			BackgroundTransparency = 1,
			TextWrapped = true,
			width = FitTextLabel.Width.FitToText,
			maximumWidth = contentWidth,
			Font = p1.Font.Footer.Font,
			LayoutOrder = layoutOrder or nil,
			Text = errorText,
			TextColor3 = p1.Theme.Alert.Color,
			TextSize = p1.Font.BaseSize * p1.Font.Footer.RelativeSize,
			TextTransparency = p1.Theme.TextDefault.Transparency,
			TextXAlignment = Enum.TextXAlignment.Center,
			AnchorPoint = Vector2.new(0, 0)
		})
	end)
end
