local roactFitComponents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LuaSocialLibrariesDeps").RoactFitComponents

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo

local v5 = {
	Text = "Default Title",
	LayoutOrder = 0,
	marginTop = 8,
	marginBottom = 14,
	style = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries").Components.TestStyle
}

function LUAUFORGE_MODULE_GLOBALS_hDN_SectionHeader(p2)
	local joined = Cryo.Dictionary.join(v5, p2)

	local style = joined.style
	local theme = style.Theme
	local font = style.Font

	return React.createElement(roactFitComponents.FitFrameVertical, {
		BackgroundTransparency = 1,
		LayoutOrder = joined.LayoutOrder,
		width = UDim.new(1, 0),
		margin = {
			top = joined.marginTop,
			left = 12,
			right = 0,
			bottom = joined.marginBottom
		}
	}, {
		SectionHeader = React.createElement(roactFitComponents.FitTextLabel, {
			width = roactFitComponents.FitTextLabel.Width.FitToText,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = joined.Text,
			TextColor3 = theme.TextDefault.Color,
			TextSize = font.CaptionHeader.RelativeSize * font.BaseSize,
			Font = font.CaptionHeader.Font,
			TextXAlignment = Enum.TextXAlignment.Left,
			AnchorPoint = Vector2.new(0, 1)
		})
	})
end

return memo(LUAUFORGE_MODULE_GLOBALS_hDN_SectionHeader)
