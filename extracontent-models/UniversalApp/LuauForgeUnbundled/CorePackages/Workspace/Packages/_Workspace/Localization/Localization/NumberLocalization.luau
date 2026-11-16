local RoundingBehaviour = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/Localization/RoundingBehaviour")

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/Localization/Logger")

game:DefineFastFlag("AllowNumberLocalizationSigFigParam", false)

local v5 = {}

v5["en-us"] = {
	decimalSeparator = ".",
	groupDelimiter = ",",
	{ 1, "" },
	{ 1000, "K" },
	{ 1000000, "M" },
	{ 1000000000, "B" }
}

v5["es-es"] = {
	decimalSeparator = ",",
	groupDelimiter = ".",
	{ 1, "" },
	{ 1000, " mil" },
	{ 1000000, " M" }
}

v5["fr-fr"] = {
	decimalSeparator = ",",
	groupDelimiter = " ",
	{ 1, "" },
	{ 1000, " k" },
	{ 1000000, " M" },
	{ 1000000000, " Md" }
}

v5["de-de"] = {
	decimalSeparator = ",",
	groupDelimiter = " ",
	{ 1, "" },
	{ 1000, " Tsd." },
	{ 1000000, " Mio." },
	{ 1000000000, " Mrd." }
}

v5["pt-br"] = {
	decimalSeparator = ",",
	groupDelimiter = ".",
	{ 1, "" },
	{ 1000, " mil" },
	{ 1000000, " mi" },
	{ 1000000000, " bi" }
}

v5["zh-cn"] = {
	decimalSeparator = ".",
	groupDelimiter = ",",
	{ 1, "" },
	{ 1000, "千" },
	{ 10000, "万" },
	{ 100000000, "亿" }
}

v5["zh-cjv"] = {
	decimalSeparator = ".",
	groupDelimiter = ",",
	{ 1, "" },
	{ 1000, "千" },
	{ 10000, "万" },
	{ 100000000, "亿" }
}

v5["zh-tw"] = {
	decimalSeparator = ".",
	groupDelimiter = ",",
	{ 1, "" },
	{ 1000, "千" },
	{ 10000, "萬" },
	{ 100000000, "億" }
}

v5["ko-kr"] = {
	decimalSeparator = ".",
	groupDelimiter = ",",
	{ 1, "" },
	{ 1000, "천" },
	{ 10000, "만" },
	{ 100000000, "억" }
}

v5["ja-jp"] = {
	decimalSeparator = ".",
	groupDelimiter = ",",
	{ 1, "" },
	{ 1000, "千" },
	{ 10000, "万" },
	{ 100000000, "億" }
}

v5["it-it"] = {
	decimalSeparator = ",",
	groupDelimiter = " ",
	{ 1, "" },
	{ 1000, " mila" },
	{ 1000000, " Mln" },
	{ 1000000000, " Mld" }
}

v5["ru-ru"] = {
	decimalSeparator = ",",
	groupDelimiter = ".",
	{ 1, "" },
	{ 1000, " тыс" },
	{ 1000000, " млн" },
	{ 1000000000, " млрд" }
}

v5["id-id"] = {
	decimalSeparator = ",",
	groupDelimiter = ".",
	{ 1, "" },
	{ 1000, " rb" },
	{ 1000000, " jt" },
	{ 1000000000, " M" }
}

v5["vi-vn"] = {
	decimalSeparator = ".",
	groupDelimiter = " ",
	{ 1, "" },
	{ 1000, " N" },
	{ 1000000, " Tr" },
	{ 1000000000, " T" }
}

v5["tr-tr"] = {
	decimalSeparator = ",",
	groupDelimiter = ".",
	{ 1, "" },
	{ 1000, " B" },
	{ 1000000, " Mn" },
	{ 1000000000, " Mr" }
}

v5["en-gb"] = v5["en-us"]
v5["es-mx"] = v5["es-es"]
v5["th-th"] = v5["en-us"]

local function findDecimalPointIndex(value)
	return string.find(value, "%.") or #value + 1
end

local function findDecimalOffset(p2)
	if p2 == 0 then
		return 0
	end

	return -(math.floor((math.log10((math.abs(p2))))) + 1)
end

local function roundToSignificantDigits(p2, p3, p4)
	local v6 = 10 ^ (p3 + (p2 == 0 and 0 or -(math.floor((math.log10((math.abs(p2))))) + 1)))

	return (if p4 == RoundingBehaviour.Truncate then math.modf(p2 * v6) else math.floor(p2 * v6 + 0.5)) / v6
end

local function addGroupDelimiters(value, groupDelimiter)
	local v6 = string.format("%%1%s%%2", groupDelimiter)

	repeat
		local v7
		value, v7 = string.gsub(value, "^(-?%d+)(%d%d%d)", v6)
	until v7 == 0

	return value
end

local function findDenominationEntry(list, p2, p3)
	local item = list[1]
	local v6 = math.abs(p2)

	for i = #list, 2, -1 do
		local item2 = list[i]

		local v7 = if p3 == RoundingBehaviour.Truncate then item2[1] else item2[1] - list[i - 1][1] / 2

		if v7 <= v6 then
			return item2
		end
	end

	return item
end

local v6 = {}

function v6.localize(p2, p3)
	if p2 == 0 then
		return "0"
	end

	local v7 = v5[p3]

	if not v7 then
		v7 = v5["en-us"]

		Logger:warning(string.format(
			"Warning: Locale not found: '%s', reverting to '%s' instead.",
			tostring(p3),
			"en-us"
		))
	end

	if v7.groupDelimiter then
		return addGroupDelimiters(p2, v7.groupDelimiter)
	end

	return p2
end

function v6.abbreviate(p2, p3, p4, p5)
	if p2 == 0 then
		return "0"
	end

	if p4 == nil then
		p4 = RoundingBehaviour.RoundToClosest
	end

	local v7 = not game:GetFastFlag("AllowNumberLocalizationSigFigParam") and 3 or p5 == nil and 3 or p5

	local v8 = v5[p3]

	if not v8 then
		v8 = v5["en-us"]

		Logger:warning(string.format(
			"Warning: Locale not found: '%s', reverting to '%s' instead.",
			tostring(p3),
			"en-us"
		))
	end

	local denominationEntry = findDenominationEntry(v8, p2, p4)
	local v9 = denominationEntry[1]
	local v10 = denominationEntry[2]

	local v11 = p2 / v9
	local v12 = 10 ^ (v7 + (v11 == 0 and 0 or -(math.floor((math.log10((math.abs(v11))))) + 1)))

	local v14 = (if p4 == RoundingBehaviour.Truncate then math.modf(v11 * v12) else math.floor(v11 * v12 + 0.5)) / v12
	local v15

	if p4 == RoundingBehaviour.Truncate then
		v15 = math.modf(v14 * 10) / 10
	else
		v15 = math.floor(v14 * 10 + 0.5) / 10
	end

	local v16 = tostring(v15)
	local v17 = string.find(v16, "%.") or #v16 + 1

	local v18 = string.sub(v16, 1, v17 - 1)
	local v19 = string.sub(v16, v17 + 1, #v16)

	if v8.groupDelimiter then
		v18 = addGroupDelimiters(v18, v8.groupDelimiter)
	end

	if #v19 > 0 then
		return v18 .. v8.decimalSeparator .. v19 .. v10
	end

	return v18 .. v10
end

function v6.localizeDecimal(p2, p3, p4)
	if p2 == 0 then
		return "0"
	end

	local v7 = p4 == nil and 2 or p4

	local v8 = v5[p3]

	if not v8 then
		v8 = v5["en-us"]

		Logger:warning(string.format(
			"Warning: Locale not found: '%s', reverting to '%s' instead.",
			tostring(p3),
			"en-us"
		))
	end

	local v9 = 10 ^ v7
	local v10 = math.floor(math.abs(p2) * v9 + 0.5) / v9

	local v11 = p2 < 0 and v10 ~= 0 and "-" or ""

	local v12 = string.format(string.format("%%.%df", v7), v10)
	local v13 = string.find(v12, "%.") or #v12 + 1

	local v14 = string.sub(v12, 1, v13 - 1)
	local v15 = string.sub(v12, v13 + 1, #v12)

	if v8.groupDelimiter then
		v14 = addGroupDelimiters(v14, v8.groupDelimiter)
	end

	local v16 = string.gsub(v15, "0+$", "")

	if #v16 > 0 then
		return v11 .. v14 .. v8.decimalSeparator .. v16
	end

	return v11 .. v14
end

function v6.abbreviateDecimal(p2, p3, p4)
	local denominationEntry = findDenominationEntry(v5[p3] or v5["en-us"], p2, RoundingBehaviour.RoundToClosest)
	return v6.localizeDecimal(p2 / denominationEntry[1], p3, p4) .. denominationEntry[2]
end

v6.logger = Logger

return v6
