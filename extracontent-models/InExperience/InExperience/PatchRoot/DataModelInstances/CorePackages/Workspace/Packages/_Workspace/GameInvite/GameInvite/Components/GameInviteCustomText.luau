local GameInvite = script:FindFirstAncestor("GameInvite")
local parent = GameInvite.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local GameInviteConstants = require(GameInvite.GameInviteConstants)

local useStyle = UIBlox.Core.Style.useStyle

local SidePadding = GameInviteConstants.Layout.SidePadding

return function(props)
	local v = useStyle()
	local theme = v.Theme
	local font = v.Font

	local textSize = font.BaseSize * font.Body.RelativeSize

	return React.createElement(
		"Frame",
		{
			Size = props.size,
			LayoutOrder = props.layoutOrder,
			BackgroundTransparency = 1,
			ClipsDescendants = true
		},
		{
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, SidePadding),
				PaddingRight = UDim.new(0, SidePadding)
			}),
			CustomText = React.createElement("TextLabel", {
				Text = props.promptMessage,
				TextSize = textSize,
				TextColor3 = theme.TextEmphasis.Color,
				TextTransparency = theme.TextEmphasis.Transparency,
				FontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1
			})
		}
	)
end
