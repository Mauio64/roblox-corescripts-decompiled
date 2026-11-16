local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent

local t = require(parent2.t)

local validateFontInfo = require(parent.Core.Style.Validator.validateFontInfo)

local strictInterface = t.strictInterface({
	BaseSize = t.numberMinExclusive(0),
	Title = validateFontInfo,
	Header1 = validateFontInfo,
	Header2 = validateFontInfo,
	SubHeader1 = validateFontInfo,
	Body = validateFontInfo,
	CaptionHeader = validateFontInfo,
	CaptionSubHeader = validateFontInfo,
	CaptionBody = validateFontInfo,
	Footer = validateFontInfo
})

local strictInterface2 = t.strictInterface({
	BaseSize = t.numberMinExclusive(0),
	Title = validateFontInfo,
	Header1 = validateFontInfo,
	Header2 = validateFontInfo,
	SubHeader1 = validateFontInfo,
	Body = validateFontInfo,
	CaptionHeader = validateFontInfo,
	CaptionSubHeader = validateFontInfo,
	CaptionBody = validateFontInfo,
	Footer = validateFontInfo,
	HeadingLarge = validateFontInfo,
	HeadingSmall = validateFontInfo,
	TitleLarge = validateFontInfo,
	BodyLarge = validateFontInfo,
	CaptionLarge = validateFontInfo,
	BodySmall = validateFontInfo,
	CaptionSmall = validateFontInfo
})

return t.union(strictInterface, strictInterface2)
