local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local Roact = require(parent.Roact)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local Style = require(parent.Style)
local AppFonts = Style.AppFonts
local Style2 = require(parent.Style)
local GetTextSize = Style2.GetTextSize

local Style3 = require(parent.Style)
local Colors = Style3.Colors
local White = Colors.White
local Gray2 = Colors.Gray2
Roact.PureComponent:extend("CountryCodeSelectorButton")
local AppCommonLib = require(parent.AppCommonLib)
local Text = AppCommonLib.Text
local GetFFlagCountryCodeBoldPrefixEnabled = require(AuthCommon.Flags.GetFFlagCountryCodeBoldPrefixEnabled)
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
require(AuthCommon.Common.Types)

local function CountryCodeSelectorButton(props)
	local localizedName = props.CountryCode.localizedName or ""
	local text = "+" .. (props.CountryCode.prefix or "")
	local textSize = props.ListButtonProps.TextSize
	local boldPrefixEnabled = GetFFlagCountryCodeBoldPrefixEnabled() and props.BoldPrefixEnabled
	local v

	if FoundationFontFaceMigration then
		v = Foundation.Hooks.useTokens()
	end

	local v2

	if FoundationFontFaceMigration then
		v2 = GetTextSize(text, textSize, v.Typography.BodySmall.Font, Vector2.new(10000, 10000)).X
	else
		v2 = Text.GetTextWidth(text, AppFonts.default:getDefault(), textSize)
	end

	local text2 = string.format("%s (%s)", localizedName, text)
	local size = props.Size
	local layoutOrder = props.LayoutOrder
	local selectionCallback = props.ListButtonProps.SelectionCallback or function(_) end
	local v3 = useStyle()
	local children

	if boldPrefixEnabled then
		children = { FullText = 0 }
		local createElement = Roact.createElement
		local v4 = {
			Size = UDim2.new(1, 0, 1, 0),
			Text = text2,
			BackgroundTransparency = 1,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0,
			TextSize = 0,
			TextXAlignment = 0,
			TextTruncate = 0
		}
		local font

		if not FoundationFontFaceMigration then
			font = v3.Tokens.Typography.BodySmall.Font
		end

		v4.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v.Typography.BodySmall.Font)
		end

		v4.FontFace = fontFace

		v4.TextColor3 = v3.Tokens.Color.Shift.Shift_400.Color3
		v4.TextSize = textSize
		v4.TextXAlignment = Enum.TextXAlignment.Left
		v4.TextTruncate = Enum.TextTruncate.AtEnd
		children.FullText = createElement("TextLabel", v4)
	else
		children = { CountryName = 0, CountryPrefix = 0 }
		local createElement = Roact.createElement
		local v4 = {
			Size = UDim2.new(1, -v2, 1, 0),
			Text = localizedName,
			BackgroundTransparency = 1,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0,
			TextSize = 0,
			TextXAlignment = 0,
			TextTruncate = 0
		}
		local font

		if not FoundationFontFaceMigration then
			font = AppFonts.default:getDefault()
		end

		v4.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v.Typography.BodySmall.Font)
		end

		v4.FontFace = fontFace

		v4.TextColor3 = White
		v4.TextSize = textSize
		v4.TextXAlignment = Enum.TextXAlignment.Left
		v4.TextTruncate = Enum.TextTruncate.AtEnd
		children.CountryName = createElement("TextLabel", v4)

		local createElement2 = Roact.createElement
		local v5 = {
			Size = UDim2.new(1, 0, 1, 0),
			Text = text,
			BackgroundTransparency = 1,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0,
			TextSize = 0,
			TextXAlignment = 0,
			TextTruncate = 0
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = AppFonts.default:getDefault()
		end

		v5.Font = font2
		local fontFace2

		if FoundationFontFaceMigration then
			fontFace2 = normalizeFontFace(v.Typography.BodySmall.Font)
		end

		v5.FontFace = fontFace2

		v5.TextColor3 = Gray2
		v5.TextSize = textSize
		v5.TextXAlignment = Enum.TextXAlignment.Right
		v5.TextTruncate = Enum.TextTruncate.AtEnd
		children.CountryPrefix = createElement2("TextLabel", v5)
	end

	return Roact.createElement("TextButton", {
		Size = size,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		Text = "",
		[Roact.Event.Activated] = function()
			selectionCallback(props.CountryCode)
		end
	}, children)
end

return CountryCodeSelectorButton
