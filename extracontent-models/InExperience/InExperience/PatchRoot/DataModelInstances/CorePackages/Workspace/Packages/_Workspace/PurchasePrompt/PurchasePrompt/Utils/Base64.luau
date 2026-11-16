local Base64 = {}

function Base64.MakeEncoder(value: string?, value2: string?, value3: string?)
	local encoder = {}

	for k, v in pairs({
		[0] = "A",
		"B",
		"C",
		"D",
		"E",
		"F",
		"G",
		"H",
		"I",
		"J",
		"K",
		"L",
		"M",
		"N",
		"O",
		"P",
		"Q",
		"R",
		"S",
		"T",
		"U",
		"V",
		"W",
		"X",
		"Y",
		"Z",
		"a",
		"b",
		"c",
		"d",
		"e",
		"f",
		"g",
		"h",
		"i",
		"j",
		"k",
		"l",
		"m",
		"n",
		"o",
		"p",
		"q",
		"r",
		"s",
		"t",
		"u",
		"v",
		"w",
		"x",
		"y",
		"z",
		"0",
		"1",
		"2",
		"3",
		"4",
		"5",
		"6",
		"7",
		"8",
		"9",
		value or "+",
		value2 or "/",
		value3 or "="
	}) do
		encoder[k] = v:byte()
	end

	return encoder
end

local encoder = Base64.MakeEncoder()

local char = string.char
local concat = table.concat
local extract = bit32.extract

function Base64.Encode(value: string, p, flag: boolean?)
	local v = p or encoder
	local count = #value
	local v2 = count % 3
	local v3 = {}
	local v4 = {}
	local v5 = 1

	for i = 1, count - v2, 3 do
		local v6, v7, v8 = value:byte(i, i + 2)
		local v9 = v6 * 65536 + v7 * 256 + v8
		local v10

		if flag then
			v10 = v3[v9]

			if not v10 then
				v10 = char(v[extract(v9, 18, 6)], v[extract(v9, 12, 6)], v[extract(v9, 6, 6)], v[extract(v9, 0, 6)])

				v3[v9] = v10
			end
		else
			v10 = char(v[extract(v9, 18, 6)], v[extract(v9, 12, 6)], v[extract(v9, 6, 6)], v[extract(v9, 0, 6)])
		end

		v4[v5] = v10
		v5 += 1
	end

	if v2 == 2 then
		local v6, v7 = value:byte(count - 1, count)
		local v8 = v6 * 65536 + v7 * 256
		v4[v5] = char(v[extract(v8, 18, 6)], v[extract(v8, 12, 6)], v[extract(v8, 6, 6)], v[64])
	elseif v2 == 1 then
		local v6 = value:byte(count) * 65536
		v4[v5] = char(v[extract(v6, 18, 6)], v[extract(v6, 12, 6)], v[64], v[64])
	end

	return concat(v4)
end

return Base64
