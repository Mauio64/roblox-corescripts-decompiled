local v5 = {
	Black = Enum.Font.GothamBlack,
	Bold = Enum.Font.GothamBold,
	Medium = Enum.Font.GothamMedium,
	Book = Enum.Font.Gotham
}

local function mapTypographyVariantToFontEnum(p2)
	if p2.Font then
		return p2.Font
	end

	if p2.FontWeight then
		return v5[p2.FontWeight] or v5.Book
	end

	return v5.Book
end

return mapTypographyVariantToFontEnum
