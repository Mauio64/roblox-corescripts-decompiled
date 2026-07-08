local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local t = require(ParentParentParent.t)
local validateFontInfo = require(ParentParent.Core.Style.Validator.validateFontInfo)
local v5 = t.strictInterface({
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
local v6 = t.strictInterface({
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

return t.union(v5, v6)
