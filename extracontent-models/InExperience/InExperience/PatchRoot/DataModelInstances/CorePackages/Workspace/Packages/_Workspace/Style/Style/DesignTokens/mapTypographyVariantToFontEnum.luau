local v = {
	Black = Enum.Font.GothamBlack,
	Bold = Enum.Font.GothamBold,
	Medium = Enum.Font.GothamMedium,
	Book = Enum.Font.Gotham
}

local function mapTypographyVariantToFontEnum(p)
	if p.Font then
		return p.Font
	end

	if p.FontWeight then
		return v[p.FontWeight] or v.Book
	end

	return v.Book
end

return mapTypographyVariantToFontEnum
