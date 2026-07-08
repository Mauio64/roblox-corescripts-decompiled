local ParentParent = script.Parent.Parent
local ParentParent2 = ParentParent.Parent.Parent.Parent
local Cryo = require(ParentParent2.Cryo)

require(ParentParent.StyleTypes)

local _ = {
	BASE_SIZE = 16,
	FACTOR = 1.26
}
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 17
	-- upvalues: t1 (copy)
	local t2 = {
		_tokens = p1
	}

	setmetatable(t2, t1)

	return t2
end
function t1.loadFont(p2) -- line: 25
	-- upvalues: Cryo (copy)
	local _tokens = p2._tokens
	local t3 = {
		BaseSize = 20.16,
		HeadingLarge = {
			Font = Enum.Font.BuilderSansBold,
			RelativeSize = _tokens.Global.Size_350 / 16,
			RelativeMinSize = _tokens.Global.Size_300 / 16
		},
		HeadingSmall = {
			Font = Enum.Font.BuilderSansBold,
			RelativeSize = _tokens.Global.Size_250 / 16,
			RelativeMinSize = _tokens.Global.Size_200 / 16
		},
		TitleLarge = {
			Font = Enum.Font.BuilderSansBold,
			RelativeSize = _tokens.Global.Size_200 / 16,
			RelativeMinSize = _tokens.Global.Size_150 / 16
		},
		BodyLarge = {
			Font = Enum.Font.BuilderSans,
			RelativeSize = _tokens.Global.Size_200 / 16,
			RelativeMinSize = _tokens.Global.Size_150 / 16
		},
		CaptionLarge = {
			Font = Enum.Font.BuilderSansMedium,
			RelativeSize = _tokens.Global.Size_150 / 16,
			RelativeMinSize = _tokens.Global.Size_100 / 16
		},
		BodySmall = {
			Font = Enum.Font.BuilderSans,
			RelativeSize = _tokens.Global.Size_150 / 16,
			RelativeMinSize = _tokens.Global.Size_100 / 16
		},
		CaptionSmall = {
			Font = Enum.Font.BuilderSansMedium,
			RelativeSize = _tokens.Global.Size_125 / 16,
			RelativeMinSize = _tokens.Global.Size_100 / 16
		}
	}
	local v11 = p2:mapLegacyFont(t3, 16)

	return Cryo.Dictionary.join(v11, t3)
end
function t1.mapLegacyFont(_, p4, _) -- line: 78
	return {
		Title = p4.HeadingLarge,
		Header1 = p4.HeadingSmall,
		Header2 = p4.TitleLarge,
		SubHeader1 = p4.TitleLarge,
		Body = p4.BodyLarge,
		CaptionHeader = p4.CaptionLarge,
		CaptionSubHeader = p4.CaptionLarge,
		CaptionBody = p4.BodySmall,
		Footer = p4.CaptionSmall
	}
end

return t1
