local RoundingBehaviour = require(script.Parent.RoundingBehaviour)
local Logger = require(script.Parent.Logger)

game:DefineFastFlag("AllowNumberLocalizationSigFigParam", false)

local t1 = {
	["en-us"] = {
		decimalSeparator = ".",
		groupDelimiter = ",",
		{
			1,
			""
		},
		{
			1000,
			"K"
		},
		{
			1000000,
			"M"
		},
		{
			1000000000,
			"B"
		}
	},
	["es-es"] = {
		decimalSeparator = ",",
		groupDelimiter = ".",
		{
			1,
			""
		},
		{
			1000,
			" mil"
		},
		{
			1000000,
			" M"
		}
	},
	["fr-fr"] = {
		decimalSeparator = ",",
		groupDelimiter = " ",
		{
			1,
			""
		},
		{
			1000,
			" k"
		},
		{
			1000000,
			" M"
		},
		{
			1000000000,
			" Md"
		}
	},
	["de-de"] = {
		decimalSeparator = ",",
		groupDelimiter = " ",
		{
			1,
			""
		},
		{
			1000,
			" Tsd."
		},
		{
			1000000,
			" Mio."
		},
		{
			1000000000,
			" Mrd."
		}
	},
	["pt-br"] = {
		decimalSeparator = ",",
		groupDelimiter = ".",
		{
			1,
			""
		},
		{
			1000,
			" mil"
		},
		{
			1000000,
			" mi"
		},
		{
			1000000000,
			" bi"
		}
	},
	["zh-cn"] = {
		decimalSeparator = ".",
		groupDelimiter = ",",
		{
			1,
			""
		},
		{
			1000,
			"千"
		},
		{
			10000,
			"万"
		},
		{
			100000000,
			"亿"
		}
	},
	["zh-cjv"] = {
		decimalSeparator = ".",
		groupDelimiter = ",",
		{
			1,
			""
		},
		{
			1000,
			"千"
		},
		{
			10000,
			"万"
		},
		{
			100000000,
			"亿"
		}
	},
	["zh-tw"] = {
		decimalSeparator = ".",
		groupDelimiter = ",",
		{
			1,
			""
		},
		{
			1000,
			"千"
		},
		{
			10000,
			"萬"
		},
		{
			100000000,
			"億"
		}
	},
	["ko-kr"] = {
		decimalSeparator = ".",
		groupDelimiter = ",",
		{
			1,
			""
		},
		{
			1000,
			"천"
		},
		{
			10000,
			"만"
		},
		{
			100000000,
			"억"
		}
	},
	["ja-jp"] = {
		decimalSeparator = ".",
		groupDelimiter = ",",
		{
			1,
			""
		},
		{
			1000,
			"千"
		},
		{
			10000,
			"万"
		},
		{
			100000000,
			"億"
		}
	},
	["it-it"] = {
		decimalSeparator = ",",
		groupDelimiter = " ",
		{
			1,
			""
		},
		{
			1000,
			" mila"
		},
		{
			1000000,
			" Mln"
		},
		{
			1000000000,
			" Mld"
		}
	},
	["ru-ru"] = {
		decimalSeparator = ",",
		groupDelimiter = ".",
		{
			1,
			""
		},
		{
			1000,
			" тыс"
		},
		{
			1000000,
			" млн"
		},
		{
			1000000000,
			" млрд"
		}
	},
	["id-id"] = {
		decimalSeparator = ",",
		groupDelimiter = ".",
		{
			1,
			""
		},
		{
			1000,
			" rb"
		},
		{
			1000000,
			" jt"
		},
		{
			1000000000,
			" M"
		}
	},
	["vi-vn"] = {
		decimalSeparator = ".",
		groupDelimiter = " ",
		{
			1,
			""
		},
		{
			1000,
			" N"
		},
		{
			1000000,
			" Tr"
		},
		{
			1000000000,
			" T"
		}
	},
	["tr-tr"] = {
		decimalSeparator = ",",
		groupDelimiter = ".",
		{
			1,
			""
		},
		{
			1000,
			" B"
		},
		{
			1000000,
			" Mn"
		},
		{
			1000000000,
			" Mr"
		}
	}
}

t1["en-gb"] = t1["en-us"]
t1["es-mx"] = t1["es-es"]
t1["th-th"] = t1["en-us"]

local function findDecimalPointIndex(p1) -- line: 172
	return string.find(p1, "%.") or #p1 + 1
end
local function findDecimalOffset(p2) -- line: 177
	if p2 == 0 then
		return 0
	end

	return -(math.floor((math.log10((math.abs(p2))))) + 1)
end
local function roundToSignificantDigits(p3, p4, p5) -- line: 186
	-- upvalues: RoundingBehaviour (copy)
	local v14 = 10 ^ (p4 + if p3 ~= 0 then -(math.floor((math.log10((math.abs(p3))))) + 1) else 0)

	return ((if p5 ~= RoundingBehaviour.Truncate then math.floor(p3 * v14 + 0.5) else math.modf(p3 * v14))) / v14
end
local function addGroupDelimiters(p6, p7) -- line: 198
	local v17 = string.format("%%1%s%%2", p7)

	repeat
		local count

		p6, count = string.gsub(p6, "^(-?%d+)(%d%d%d)", v17)
	until count == 0

	return p6
end
local function findDenominationEntry(p8, p9, p10) -- line: 211
	-- upvalues: RoundingBehaviour (copy)
	local v22 = p8[1]
	local v23 = math.abs(p9)

	for i = #p8, 2, -1 do
		local v25 = p8[i]

		if v23 >= if p10 ~= RoundingBehaviour.Truncate then v25[1] - p8[i - 1][1] / 2 else v25[1] then
			return v25
		end
	end

	return v22
end

return {
	localize = function(p11, p12) -- line: 232
		-- upvalues: t1 (copy), Logger (copy), addGroupDelimiters (copy)
		if p11 == 0 then
			return "0"
		end

		local v28 = t1[p12]

		if not v28 then
			v28 = t1["en-us"]
			Logger:warning(string.format("Warning: Locale not found: '%s', reverting to '%s' instead.", tostring(p12), "en-us"))
		end

		if v28.groupDelimiter then
			return (addGroupDelimiters(p11, v28.groupDelimiter))
		end

		return p11
	end,
	abbreviate = function(p13, p14, p15, p16) -- line: 257
		-- upvalues: RoundingBehaviour (copy), t1 (copy), Logger (copy), findDenominationEntry (copy), addGroupDelimiters (copy)
		if p13 == 0 then
			return "0"
		end

		if p15 == nil then
			p15 = RoundingBehaviour.RoundToClosest
		end

		if game:GetFastFlag("AllowNumberLocalizationSigFigParam") then
			if p16 == nil then
				p16 = 3
			end
		else
			p16 = 3
		end

		local v33 = t1[p14]

		if not v33 then
			v33 = t1["en-us"]
			Logger:warning(string.format("Warning: Locale not found: '%s', reverting to '%s' instead.", tostring(p14), "en-us"))
		end

		local v34 = findDenominationEntry(v33, p13, p15)
		local v35 = v34[1]
		local v36 = v34[2]
		local v37 = p13 / v35
		local v38 = 10 ^ (p16 + if v37 ~= 0 then -(math.floor((math.log10((math.abs(v37))))) + 1) else 0)
		local v39 = ((if p15 ~= RoundingBehaviour.Truncate then math.floor(v37 * v38 + 0.5) else math.modf(v37 * v38))) / v38
		local str = tostring(if p15 ~= RoundingBehaviour.Truncate then math.floor(v39 * 10 + 0.5) / 10 else math.modf(v39 * 10) / 10)
		local v41 = string.find(str, "%.") or #str + 1
		local v42 = string.sub(str, 1, v41 - 1)
		local v43 = string.sub(str, v41 + 1, #str)

		if v33.groupDelimiter then
			v42 = addGroupDelimiters(v42, v33.groupDelimiter)
		end

		if #v43 > 0 then
			return v42 .. v33.decimalSeparator .. v43 .. v36
		end

		return v42 .. v36
	end,
	logger = Logger
}
