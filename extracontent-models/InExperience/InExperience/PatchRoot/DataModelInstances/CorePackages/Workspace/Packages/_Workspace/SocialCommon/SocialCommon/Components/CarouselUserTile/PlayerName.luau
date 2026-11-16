local parent = script:FindFirstAncestor("SocialCommon").Parent
local React = require(parent.React)
local Cryo = require(parent.Cryo)

local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local AppCommonLib = require(parent.AppCommonLib)
local Text = AppCommonLib.Text

local Constants = require(script.Parent.Constants)

local v = { width = Constants.TILE_SIZE }

return function(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useStyle()

	local theme = v2.Theme
	local font = v2.Font
	local v3

	if FoundationFontFaceMigration then
		v3 = React.useMemo(function()
			return GetTextSize(
				joined.name,
				font.BaseSize * font.CaptionHeader.RelativeSize,
				v2.Tokens.Typography.CaptionLarge.Font,
				Vector2.new(10000, 10000)
			).Y
		end, { joined.name, font.BaseSize * font.CaptionHeader.RelativeSize, v2.Tokens.Typography.CaptionLarge.Font })
	else
		v3 = React.useMemo(function()
			return Text.GetTextHeight(
				joined.name,
				font.CaptionHeader.Font,
				font.BaseSize * font.CaptionHeader.RelativeSize,
				10000
			)
		end, { joined.name, font.CaptionHeader.Font, font.BaseSize * font.CaptionHeader.RelativeSize })
	end

	return React.createElement(StyledTextLabel, {
		layoutOrder = joined.layoutOrder,
		text = joined.name,
		fontStyle = font.CaptionHeader,
		colorStyle = theme.TextEmphasis,
		size = UDim2.fromOffset(joined.width, v3),
		textTruncate = Enum.TextTruncate.AtEnd,
		textXAlignment = Enum.TextXAlignment.Left,
		textYAlignment = Enum.TextYAlignment.Center,
		lineHeight = 1,
		fluidSizing = false,
		richText = true
	})
end
