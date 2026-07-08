local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local RoactFitComponents = require(AppChatParent.LuaSocialLibrariesDeps).RoactFitComponents
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local memo = React.memo
local TestStyle = require(AppChat.SocialLibraries).Components.TestStyle
local t1 = {
	Text = "Default Title",
	LayoutOrder = 0,
	marginTop = 8,
	marginBottom = 14,
	style = TestStyle
}

function SectionHeader(t2: {[any]: any}) -- line: 30
	-- upvalues: Cryo (copy), t1 (copy), React (copy), RoactFitComponents (copy)
	local v10 = Cryo.Dictionary.join(t1, t2)
	local style = v10.style
	local Theme = style.Theme
	local styleFont = style.Font

	return React.createElement(RoactFitComponents.FitFrameVertical, {
		BackgroundTransparency = 1,
		LayoutOrder = v10.LayoutOrder,
		width = UDim.new(1, 0),
		margin = {
			left = 12,
			right = 0,
			top = v10.marginTop,
			bottom = v10.marginBottom
		}
	}, {
		SectionHeader = React.createElement(RoactFitComponents.FitTextLabel, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			width = RoactFitComponents.FitTextLabel.Width.FitToText,
			Text = v10.Text,
			TextColor3 = Theme.TextDefault.Color,
			TextSize = styleFont.CaptionHeader.RelativeSize * styleFont.BaseSize,
			Font = styleFont.CaptionHeader.Font,
			TextXAlignment = Enum.TextXAlignment.Left,
			AnchorPoint = Vector2.new(0, 1)
		})
	})
end

return memo(SectionHeader)
