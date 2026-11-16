local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Cryo")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Foundation")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Style").GetTextSize
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local text = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/AppCommonLib").Text

local v5 = { width = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Components/CarouselUserTile/Constants").TILE_SIZE }

return function(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = useStyle()

	local theme = v6.Theme
	local font = v6.Font
	local v7

	if foundationFontFaceMigration then
		v7 = React.useMemo(function()
			return getTextSize(
				joined.name,
				font.BaseSize * font.CaptionHeader.RelativeSize,
				v6.Tokens.Typography.CaptionLarge.Font,
				Vector2.new(10000, 10000)
			).Y
		end, {
			joined.name,
			font.BaseSize * font.CaptionHeader.RelativeSize,
			v6.Tokens.Typography.CaptionLarge.Font
		})
	else
		v7 = React.useMemo(function()
			return text.GetTextHeight(
				joined.name,
				font.CaptionHeader.Font,
				font.BaseSize * font.CaptionHeader.RelativeSize,
				10000
			)
		end, { joined.name, font.CaptionHeader.Font, font.BaseSize * font.CaptionHeader.RelativeSize })
	end

	return React.createElement(styledTextLabel, {
		layoutOrder = joined.layoutOrder,
		text = joined.name,
		fontStyle = font.CaptionHeader,
		colorStyle = theme.TextEmphasis,
		size = UDim2.fromOffset(joined.width, v7),
		textTruncate = Enum.TextTruncate.AtEnd,
		textXAlignment = Enum.TextXAlignment.Left,
		textYAlignment = Enum.TextYAlignment.Center,
		lineHeight = 1,
		fluidSizing = false,
		richText = true
	})
end
