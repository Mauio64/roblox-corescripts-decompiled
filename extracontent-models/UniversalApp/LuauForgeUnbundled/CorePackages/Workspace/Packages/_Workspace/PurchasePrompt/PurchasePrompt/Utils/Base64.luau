local v5 = {}

function v5.MakeEncoder(value, value2, value3)
	local encoder = {}

	for k, v6 in pairs({
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
		encoder[k] = v6:byte()
	end

	return encoder
end

local encoder = v5.MakeEncoder()

local char = string.char
local concat = table.concat
local extract = bit32.extract

function v5.Encode(value, p2, p3)
	local v6 = p2 or encoder
	local count = #value
	local v7 = count % 3
	local v8 = {}
	local v9 = {}
	local v10 = 1

	for i = 1, count - v7, 3 do
		local v11, v12, v13 = value:byte(i, i + 2)
		local v14 = v11 * 65536 + v12 * 256 + v13
		local v15

		if p3 then
			v15 = v8[v14]

			if not v15 then
				v15 = char(
					v6[extract(v14, 18, 6)],
					v6[extract(v14, 12, 6)],
					v6[extract(v14, 6, 6)],
					v6[extract(v14, 0, 6)]
				)

				v8[v14] = v15
			end
		else
			v15 = char(
				v6[extract(v14, 18, 6)],
				v6[extract(v14, 12, 6)],
				v6[extract(v14, 6, 6)],
				v6[extract(v14, 0, 6)]
			)
		end

		v9[v10] = v15
		v10 += 1
	end

	if v7 == 2 then
		local v11, v12 = value:byte(count - 1, count)
		local v13 = v11 * 65536 + v12 * 256
		v9[v10] = char(v6[extract(v13, 18, 6)], v6[extract(v13, 12, 6)], v6[extract(v13, 6, 6)], v6[64])
	elseif v7 == 1 then
		local v11 = value:byte(count) * 65536
		v9[v10] = char(v6[extract(v11, 18, 6)], v6[extract(v11, 12, 6)], v6[64], v6[64])
	end

	return concat(v9)
end

return v5
