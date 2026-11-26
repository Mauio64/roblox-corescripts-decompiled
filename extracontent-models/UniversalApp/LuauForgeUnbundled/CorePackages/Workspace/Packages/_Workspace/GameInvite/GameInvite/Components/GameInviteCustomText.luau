local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/UIBlox")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Foundation").Utility.normalizeFontFace
local GameInviteConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/GameInviteConstants")

local useStyle = UIBlox.Core.Style.useStyle

local sidePadding = GameInviteConstants.Layout.SidePadding

return function(props)
	local v5 = useStyle()
	local theme = v5.Theme
	local font = v5.Font

	local v6 = font.BaseSize * font.Body.RelativeSize

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
				PaddingLeft = UDim.new(0, sidePadding),
				PaddingRight = UDim.new(0, sidePadding)
			}),
			CustomText = React.createElement("TextLabel", {
				Text = props.promptMessage,
				TextSize = v6,
				TextColor3 = theme.TextEmphasis.Color,
				TextTransparency = theme.TextEmphasis.Transparency,
				FontFace = normalizeFontFace(v5.Tokens.Typography.BodyLarge.Font),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1
			})
		}
	)
end
