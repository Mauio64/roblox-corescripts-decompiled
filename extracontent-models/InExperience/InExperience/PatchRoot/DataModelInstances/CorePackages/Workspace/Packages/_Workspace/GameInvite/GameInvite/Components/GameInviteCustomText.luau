local GameInvite = script:FindFirstAncestor("GameInvite")
local parent = GameInvite.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local GameInviteConstants = require(GameInvite.GameInviteConstants)

local useStyle = UIBlox.Core.Style.useStyle

local SidePadding = GameInviteConstants.Layout.SidePadding

return function(props)
	local v = useStyle()
	local theme = v.Theme
	local font = v.Font

	local textSize = font.BaseSize * font.Body.RelativeSize

	local createElement = React.createElement
	local v2 = {
		Size = props.size,
		LayoutOrder = props.layoutOrder,
		BackgroundTransparency = 1,
		ClipsDescendants = true
	}

	local v3 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, SidePadding),
			PaddingRight = UDim.new(0, SidePadding)
		}),
		CustomText = 0
	}

	local createElement2 = React.createElement
	local v4 = {
		Text = props.promptMessage,
		TextSize = textSize,
		TextColor3 = theme.TextEmphasis.Color,
		TextTransparency = theme.TextEmphasis.Transparency,
		Font = 0,
		FontFace = 0,
		TextXAlignment = 0,
		TextWrapped = true,
		TextTruncate = 0,
		Size = 0,
		BackgroundTransparency = 1
	}
	local font2

	if not FoundationFontFaceMigration then
		font2 = font.Body.Font
	end

	v4.Font = font2
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font)
	end

	v4.FontFace = fontFace

	v4.TextXAlignment = Enum.TextXAlignment.Left

	v4.TextTruncate = Enum.TextTruncate.AtEnd
	v4.Size = UDim2.new(1, 0, 1, 0)
	v3.CustomText = createElement2("TextLabel", v4)
	return createElement("Frame", v2, v3)
end
