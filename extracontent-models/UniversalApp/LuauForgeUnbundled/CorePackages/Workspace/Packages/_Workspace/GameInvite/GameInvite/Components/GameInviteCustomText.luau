local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local GameInviteConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/GameInviteConstants")

local useStyle = UIBlox.Core.Style.useStyle

local sidePadding = GameInviteConstants.Layout.SidePadding

return function(props)
	local v5 = useStyle()
	local theme = v5.Theme
	local font = v5.Font

	local v6 = font.BaseSize * font.Body.RelativeSize

	local createElement = React.createElement
	local v8 = {
		Size = props.size,
		LayoutOrder = props.layoutOrder,
		BackgroundTransparency = 1,
		ClipsDescendants = true
	}

	local v9 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, sidePadding),
			PaddingRight = UDim.new(0, sidePadding)
		}),
		CustomText = 0
	}

	local createElement2 = React.createElement
	local v11 = {
		Text = props.promptMessage,
		TextSize = v6,
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
	local v12 = if not foundationFontFaceMigration then font.Body.Font else nil
	v11.Font = v12

	local v13 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.BodyLarge.Font) else nil
	v11.FontFace = v13

	v11.TextXAlignment = Enum.TextXAlignment.Left

	v11.TextTruncate = Enum.TextTruncate.AtEnd
	v11.Size = UDim2.new(1, 0, 1, 0)
	v9.CustomText = createElement2("TextLabel", v11)
	return createElement("Frame", v8, v9)
end
