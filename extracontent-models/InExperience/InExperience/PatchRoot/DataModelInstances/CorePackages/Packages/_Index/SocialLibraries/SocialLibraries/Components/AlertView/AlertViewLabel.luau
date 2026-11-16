local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local foundationFontFaceMigration = dependencies.Foundation.Utility.Flags.FoundationFontFaceMigration
local normalizeFontFace = dependencies.Foundation.Utility.normalizeFontFace

local extended = roact.PureComponent:extend("AlertViewLabel")
extended.defaultProps = {
	BackgroundTransparency = 1,
	Size = UDim2.new(1, 0, 0, 40),
	Text = "",
	TextXAlignment = Enum.TextXAlignment.Center
}

function extended.render(p)
	return uiBlox.Style.withStyle(function(p2)
		local backgroundTransparency = p.props.BackgroundTransparency
		local font = p.props.Font or p2.Font.Body.Font
		local text = p.props.Text
		local textColor3 = p.props.TextColor3 or p2.Theme.TextDefault.Color
		local textSize = p.props.TextSize or p2.Font.Body.RelativeSize * p2.Font.BaseSize
		local textXAlignment = p.props.TextXAlignment

		local createElement = roact.createElement
		local font2

		if not foundationFontFaceMigration then
			font2 = font
		end

		local fontFace

		if foundationFontFaceMigration then
			fontFace = normalizeFontFace(font)
		end

		return createElement("TextLabel", {
			BackgroundTransparency = backgroundTransparency,
			Font = font2,
			FontFace = fontFace,
			LayoutOrder = p.props.LayoutOrder,
			Size = p.props.Size,
			Text = text,
			TextColor3 = textColor3,
			TextSize = textSize,
			TextWrapped = true,
			TextXAlignment = textXAlignment
		})
	end)
end

return extended
