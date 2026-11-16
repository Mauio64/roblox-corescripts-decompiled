local v = {
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

local function addGroupDelimiters(value: string, p: string)
	local v2 = string.format("%%1%s%%2", p)

	repeat
		local v3
		value, v3 = string.gsub(value, "^(-?%d+)(%d%d%d)", v2)
	until v3 == 0

	return value
end

return function(p: string, p2: number)
	return addGroupDelimiters(p2, v[p] or ",")
end
