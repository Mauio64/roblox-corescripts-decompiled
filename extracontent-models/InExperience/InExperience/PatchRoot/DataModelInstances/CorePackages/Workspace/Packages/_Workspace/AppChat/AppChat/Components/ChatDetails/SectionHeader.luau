local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local RoactFitComponents = LuaSocialLibrariesDeps.RoactFitComponents

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local memo = React.memo

local SocialLibraries = require(AppChat.SocialLibraries)
local v = {
	Text = "Default Title",
	LayoutOrder = 0,
	marginTop = 8,
	marginBottom = 14,
	style = SocialLibraries.Components.TestStyle
}

function SectionHeader(p)
	local joined = Cryo.Dictionary.join(v, p)

	local style = joined.style
	local theme = style.Theme
	local font = style.Font

	return React.createElement(RoactFitComponents.FitFrameVertical, {
		BackgroundTransparency = 1,
		LayoutOrder = joined.LayoutOrder,
		width = UDim.new(1, 0),
		margin = { top = joined.marginTop, left = 12, right = 0, bottom = joined.marginBottom }
	}, {
		SectionHeader = React.createElement(RoactFitComponents.FitTextLabel, {
			width = RoactFitComponents.FitTextLabel.Width.FitToText,
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

return memo(SectionHeader)
