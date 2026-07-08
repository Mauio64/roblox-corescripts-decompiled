local function getFontFace(t1: {[any]: any}?) -- line: 9
	local v3 = t1 and t1.Font

	if typeof(v3) == "EnumItem" and v3:IsA("Font") then
		return Font.fromEnum(v3)
	end

	return v3
end

return getFontFace
