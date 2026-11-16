local RoundingBehaviour = require(script.Parent.RoundingBehaviour)

local Logger = require(script.Parent.Logger)

game:DefineFastFlag("AllowNumberLocalizationSigFigParam", false)

local v = {}

v["en-us"] = {
	decimalSeparator = ".",
	groupDelimiter = ",",
	{ 1, "" },
	{ 1000, "K" },
	{ 1000000, "M" },
	{ 1000000000, "B" }
}

v["es-es"] = {
	decimalSeparator = ",",
	groupDelimiter = ".",
	{ 1, "" },
	{ 1000, " mil" },
	{ 1000000, " M" }
}

v["fr-fr"] = {
	decimalSeparator = ",",
	groupDelimiter = " ",
	{ 1, "" },
	{ 1000, " k" },
	{ 1000000, " M" },
	{ 1000000000, " Md" }
}

v["de-de"] = {
	decimalSeparator = ",",
	groupDelimiter = " ",
	{ 1, "" },
	{ 1000, " Tsd." },
	{ 1000000, " Mio." },
	{ 1000000000, " Mrd." }
}

v["pt-br"] = {
	decimalSeparator = ",",
	groupDelimiter = ".",
	{ 1, "" },
	{ 1000, " mil" },
	{ 1000000, " mi" },
	{ 1000000000, " bi" }
}

v["zh-cn"] = {
	decimalSeparator = ".",
	groupDelimiter = ",",
	{ 1, "" },
	{ 1000, "千" },
	{ 10000, "万" },
	{ 100000000, "亿" }
}

v["zh-cjv"] = {
	decimalSeparator = ".",
	groupDelimiter = ",",
	{ 1, "" },
	{ 1000, "千" },
	{ 10000, "万" },
	{ 100000000, "亿" }
}

v["zh-tw"] = {
	decimalSeparator = ".",
	groupDelimiter = ",",
	{ 1, "" },
	{ 1000, "千" },
	{ 10000, "萬" },
	{ 100000000, "億" }
}

v["ko-kr"] = {
	decimalSeparator = ".",
	groupDelimiter = ",",
	{ 1, "" },
	{ 1000, "천" },
	{ 10000, "만" },
	{ 100000000, "억" }
}

v["ja-jp"] = {
	decimalSeparator = ".",
	groupDelimiter = ",",
	{ 1, "" },
	{ 1000, "千" },
	{ 10000, "万" },
	{ 100000000, "億" }
}

v["it-it"] = {
	decimalSeparator = ",",
	groupDelimiter = " ",
	{ 1, "" },
	{ 1000, " mila" },
	{ 1000000, " Mln" },
	{ 1000000000, " Mld" }
}

v["ru-ru"] = {
	decimalSeparator = ",",
	groupDelimiter = ".",
	{ 1, "" },
	{ 1000, " тыс" },
	{ 1000000, " млн" },
	{ 1000000000, " млрд" }
}

v["id-id"] = {
	decimalSeparator = ",",
	groupDelimiter = ".",
	{ 1, "" },
	{ 1000, " rb" },
	{ 1000000, " jt" },
	{ 1000000000, " M" }
}

v["vi-vn"] = {
	decimalSeparator = ".",
	groupDelimiter = " ",
	{ 1, "" },
	{ 1000, " N" },
	{ 1000000, " Tr" },
	{ 1000000000, " T" }
}

v["tr-tr"] = {
	decimalSeparator = ",",
	groupDelimiter = ".",
	{ 1, "" },
	{ 1000, " B" },
	{ 1000000, " Mn" },
	{ 1000000000, " Mr" }
}

v["en-gb"] = v["en-us"]
v["es-mx"] = v["es-es"]
v["th-th"] = v["en-us"]

local function findDecimalPointIndex(value) -- 2 equivalent calls inferred from this helper
	return string.find(value, "%.") or #value + 1
end

local function findDecimalOffset(p) -- 1 equivalent call inferred from this helper
	if p == 0 then
		return 0
	end

	return -(math.floor((math.log10((math.abs(p))))) + 1)
end

local function roundToSignificantDigits(p, p2, p3) -- 1 equivalent call inferred from this helper
	local v2 = 10 ^ (p2 + findDecimalOffset(p)) -- inferred equivalent call
	local v3

	if p3 == RoundingBehaviour.Truncate then
		v3 = math.modf(p * v2)
	else
		v3 = math.floor(p * v2 + 0.5)
	end

	return v3 / v2
end

local function addGroupDelimiters(value, groupDelimiter)
	local v2 = string.format("%%1%s%%2", groupDelimiter)

	repeat
		local v3
		value, v3 = string.gsub(value, "^(-?%d+)(%d%d%d)", v2)
	until v3 == 0

	return value
end

local function findDenominationEntry(list, p, p2)
	local item = list[1]
	local v2 = math.abs(p)

	for i = #list, 2, -1 do
		local item2 = list[i]
		local v3

		if p2 == RoundingBehaviour.Truncate then
			v3 = item2[1]
		else
			v3 = item2[1] - list[i - 1][1] / 2
		end

		if v3 <= v2 then
			return item2
		end
	end

	return item
end

local NumberLocalization = {}

function NumberLocalization.localize(p, p2)
	if p == 0 then
		return "0"
	end

	local v2 = v[p2]

	if not v2 then
		v2 = v["en-us"]

		Logger:warning(string.format(
			"Warning: Locale not found: '%s', reverting to '%s' instead.",
			tostring(p2),
			"en-us"
		))
	end

	if v2.groupDelimiter then
		return addGroupDelimiters(p, v2.groupDelimiter)
	end

	return p
end

function NumberLocalization.abbreviate(p, p2, p3, p4)
	if p == 0 then
		return "0"
	end

	if p3 == nil then
		p3 = RoundingBehaviour.RoundToClosest
	end

	local v2 = not game:GetFastFlag("AllowNumberLocalizationSigFigParam") and 3 or p4 == nil and 3 or p4

	local v3 = v[p2]

	if not v3 then
		v3 = v["en-us"]

		Logger:warning(string.format(
			"Warning: Locale not found: '%s', reverting to '%s' instead.",
			tostring(p2),
			"en-us"
		))
	end

	local denominationEntry = findDenominationEntry(v3, p, p3)
	local v4 = denominationEntry[1]
	local v5 = denominationEntry[2]

	local v6 = roundToSignificantDigits(p / v4, v2, p3) -- inferred equivalent call
	local v7

	if p3 == RoundingBehaviour.Truncate then
		v7 = math.modf(v6 * 10) / 10
	else
		v7 = math.floor(v6 * 10 + 0.5) / 10
	end

	local v8 = tostring(v7)
	local decimalPointIndex = findDecimalPointIndex(v8) -- inferred equivalent call
	local v9 = string.sub(v8, 1, decimalPointIndex - 1)
	local v10 = string.sub(v8, decimalPointIndex + 1, #v8)

	if v3.groupDelimiter then
		v9 = addGroupDelimiters(v9, v3.groupDelimiter)
	end

	if #v10 > 0 then
		return v9 .. v3.decimalSeparator .. v10 .. v5
	end

	return v9 .. v5
end

function NumberLocalization.localizeDecimal(p, p2, p3)
	if p == 0 then
		return "0"
	end

	local v2 = p3 == nil and 2 or p3

	local v3 = v[p2]

	if not v3 then
		v3 = v["en-us"]

		Logger:warning(string.format(
			"Warning: Locale not found: '%s', reverting to '%s' instead.",
			tostring(p2),
			"en-us"
		))
	end

	local v4 = 10 ^ v2
	local v5 = math.floor(math.abs(p) * v4 + 0.5) / v4

	local v6 = p < 0 and v5 ~= 0 and "-" or ""

	local v7 = string.format(string.format("%%.%df", v2), v5)
	local decimalPointIndex = findDecimalPointIndex(v7) -- inferred equivalent call
	local v8 = string.sub(v7, 1, decimalPointIndex - 1)
	local v9 = string.sub(v7, decimalPointIndex + 1, #v7)

	if v3.groupDelimiter then
		v8 = addGroupDelimiters(v8, v3.groupDelimiter)
	end

	local v10 = string.gsub(v9, "0+$", "")

	if #v10 > 0 then
		return v6 .. v8 .. v3.decimalSeparator .. v10
	end

	return v6 .. v8
end

function NumberLocalization.abbreviateDecimal(p, p2, p3)
	local denominationEntry = findDenominationEntry(v[p2] or v["en-us"], p, RoundingBehaviour.RoundToClosest)
	return NumberLocalization.localizeDecimal(p / denominationEntry[1], p2, p3) .. denominationEntry[2]
end

NumberLocalization.logger = Logger

return NumberLocalization
