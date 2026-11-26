local v5 = {
	["en-us"] = ",",
	["en-gb"] = ",",
	["es-mx"] = ",",
	["es-es"] = ".",
	["fr-fr"] = " ",
	["de-de"] = " ",
	["pt-br"] = ".",
	["zh-cn"] = ",",
	["zh-cjv"] = ",",
	["zh-tw"] = ",",
	["ko-kr"] = ",",
	["ja-jp"] = ",",
	["it-it"] = " ",
	["ru-ru"] = ".",
	["id-id"] = ".",
	["vi-vn"] = ".",
	["th-th"] = ",",
	["tr-tr"] = "."
}

local function addGroupDelimiters(value, p2)
	local v6 = string.format("%%1%s%%2", p2)

	repeat
		local v7
		value, v7 = string.gsub(value, "^(-?%d+)(%d%d%d)", v6)
	until v7 == 0

	return value
end

return function(p2, p3)
	return addGroupDelimiters(p3, v5[p2] or ",")
end
