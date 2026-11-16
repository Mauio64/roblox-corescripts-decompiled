local parent = script.Parent.Parent.Parent
require(parent.Core.Style.Validator.validateFontInfo)
require(parent.App.Style.StyleTypes)

local function getFontFromFontStyle(p)
	return p.FontFace or p.Font
end

return getFontFromFontStyle
