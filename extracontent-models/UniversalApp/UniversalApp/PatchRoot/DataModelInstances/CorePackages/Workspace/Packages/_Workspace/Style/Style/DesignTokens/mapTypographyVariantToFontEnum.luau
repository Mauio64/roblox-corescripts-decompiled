local t1 = {
	Black = Enum.Font.GothamBlack,
	Bold = Enum.Font.GothamBold,
	Medium = Enum.Font.GothamMedium,
	Book = Enum.Font.Gotham
}

local function mapTypographyVariantToFontEnum(p1) -- line: 55
	-- upvalues: t1 (copy)
	if p1.Font then
		return p1.Font
	end

	if p1.FontWeight then
		return t1[p1.FontWeight] or t1.Book
	end

	return t1.Book
end

return mapTypographyVariantToFontEnum
