local parent = script.Parent.Parent
local parent2 = parent.Parent.Parent.Parent
local Cryo = require(parent2.Cryo)
local Foundation = require(parent2.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local Constants = require(parent.Constants)
require(parent.StyleTypes)

local _ = { BASE_SIZE = 16, FACTOR = 1.26 }

local function getOverrideFontFace(font, fontFace) -- 1 equivalent call inferred from this helper
	if typeof(font) == "Font" then
		return font
	end

	if font == Enum.Font.Cartoon then
		return Font.new(Constants.ComicNeueFontFamily, fontFace.Weight, fontFace.Style)
	end

	return Font.fromEnum(font)
end

local FontLoader = {}
FontLoader.__index = FontLoader

function FontLoader.new(tokens)
	local v = { _tokens = tokens }

	setmetatable(v, FontLoader)
	return v
end

function FontLoader:loadFont(font)
	local tokens = self._tokens

	local v = {
		BaseSize = 20.16,
		HeadingLarge = {
			Font = Enum.Font.BuilderSansBold,
			FontFace = normalizeFontFace(tokens.Typography.HeadingLarge.Font),
			RelativeSize = tokens.Size.Size_700 / 16,
			RelativeMinSize = tokens.Size.Size_600 / 16
		},
		HeadingSmall = {
			Font = Enum.Font.BuilderSansBold,
			FontFace = normalizeFontFace(tokens.Typography.HeadingSmall.Font),
			RelativeSize = tokens.Size.Size_500 / 16,
			RelativeMinSize = tokens.Size.Size_400 / 16
		},
		TitleLarge = {
			Font = Enum.Font.BuilderSansBold,
			FontFace = normalizeFontFace(tokens.Typography.TitleLarge.Font),
			RelativeSize = tokens.Size.Size_400 / 16,
			RelativeMinSize = tokens.Size.Size_300 / 16
		},
		BodyLarge = {
			Font = Enum.Font.BuilderSans,
			FontFace = normalizeFontFace(tokens.Typography.BodyLarge.Font),
			RelativeSize = tokens.Size.Size_400 / 16,
			RelativeMinSize = tokens.Size.Size_300 / 16
		},
		CaptionLarge = {
			Font = Enum.Font.BuilderSansMedium,
			FontFace = normalizeFontFace(tokens.Typography.CaptionLarge.Font),
			RelativeSize = tokens.Size.Size_300 / 16,
			RelativeMinSize = tokens.Size.Size_200 / 16
		},
		BodySmall = {
			Font = Enum.Font.BuilderSans,
			FontFace = normalizeFontFace(tokens.Typography.BodySmall.Font),
			RelativeSize = tokens.Size.Size_300 / 16,
			RelativeMinSize = tokens.Size.Size_200 / 16
		},
		CaptionSmall = {
			Font = Enum.Font.BuilderSansMedium,
			FontFace = normalizeFontFace(tokens.Typography.CaptionSmall.Font),
			RelativeSize = tokens.Size.Size_250 / 16,
			RelativeMinSize = tokens.Size.Size_200 / 16
		}
	}

	if font ~= nil then
		for _, v2 in v do
			if not (type(v2) == "table" and v2.Font ~= nil) then
				continue
			end

			v2.Font = font
			v2.FontFace = getOverrideFontFace(font, v2.FontFace) -- inferred equivalent call
		end
	end

	local mapLegacyFont = self:mapLegacyFont(v, 16)
	return Cryo.Dictionary.join(mapLegacyFont, v)
end

function FontLoader:mapLegacyFont(data, _)
	return {
		Title = data.HeadingLarge,
		Header1 = data.HeadingSmall,
		Header2 = data.TitleLarge,
		SubHeader1 = data.TitleLarge,
		Body = data.BodyLarge,
		CaptionHeader = data.CaptionLarge,
		CaptionSubHeader = data.CaptionLarge,
		CaptionBody = data.BodySmall,
		Footer = data.CaptionSmall
	}
end

return FontLoader
