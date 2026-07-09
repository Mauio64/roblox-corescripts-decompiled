local t1 = {
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

local function addGroupDelimiters(s1: string, s2: string) -- line: 35
	local v5 = string.format("%%1%s%%2", s2)

	repeat
		local count

		s1, count = string.gsub(s1, "^(-?%d+)(%d%d%d)", v5)
	until count == 0

	return s1
end

return function(s3: string, n1: number) -- line: 47
	-- upvalues: t1 (copy), addGroupDelimiters (copy)
	local v9 = t1[s3] or ","

	return (addGroupDelimiters(n1, v9))
end
