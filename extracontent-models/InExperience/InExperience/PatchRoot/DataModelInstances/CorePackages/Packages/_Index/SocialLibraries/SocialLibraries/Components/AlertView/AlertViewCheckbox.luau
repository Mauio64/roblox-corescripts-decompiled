local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local CheckIcon = require(script.Parent.CheckIcon)
local foundationFontFaceMigration = dependencies.Foundation.Utility.Flags.FoundationFontFaceMigration
local normalizeFontFace = dependencies.Foundation.Utility.normalizeFontFace

local extended = roact.Component:extend("AlertViewCheckbox")

extended.defaultProps = {
	Text = "",
	LayoutOrder = 0,
	onActivated = function() end,
	checked = false
}

function extended.render(p)
	return uiBlox.Style.withStyle(function(p2)
		local createElement = roact.createElement
		local v = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = p.props.LayoutOrder,
			Size = UDim2.new(1, 0, 0, 35)
		}
		local v2 = {
			List = roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 10)
			}),
			Checkbox = roact.createElement(CheckIcon, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				checked = p.props.checked,
				onActivated = p.props.onActivated
			}),
			Label = 0
		}

		local createElement2 = roact.createElement
		local v3 = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			Size = UDim2.new(0.7, 0, 1, 0),
			Text = p.props.Text,
			TextColor3 = p.props.TextColor3 or p2.Theme.TextDefault.Color,
			TextSize = p.props.TextSize or p2.Font.Body.RelativeSize * p2.Font.BaseSize,
			Font = 0,
			FontFace = 0,
			TextXAlignment = 0
		}
		local font

		if not foundationFontFaceMigration then
			font = p.props.Font or p2.Font.CaptionSubHeader.Font
		end

		v3.Font = font
		local fontFace

		if foundationFontFaceMigration then
			fontFace = normalizeFontFace(p.props.Font or p2.Font.CaptionSubHeader.Font)
		end

		v3.FontFace = fontFace

		v3.TextXAlignment = Enum.TextXAlignment.Left
		v2.Label = createElement2("TextLabel", v3)
		return createElement("Frame", v, v2)
	end)
end

return extended
