local function getFontFace(p)
	local font = p and p.Font

	if typeof(font) == "EnumItem" and font:IsA("Font") then
		return Font.fromEnum(font)
	end

	return font
end

return getFontFace
