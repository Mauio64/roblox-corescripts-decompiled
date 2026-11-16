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

function v5.MakeDecoder(p2, p3, p4)
	local decoder = {}

	for k, v6 in pairs(v5.MakeEncoder(p2, p3, p4)) do
		decoder[v6] = k
	end

	return decoder
end

local encoder = v5.MakeEncoder()
local decoder = v5.MakeDecoder()

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

function v5.EncodeUrl(p2, p3)
	local encoded = v5.Encode(p2, nil, p3)
	return v5.ToUrlSafeBase64(encoded)
end

function v5.Decode(value, p2, p3)
	local v6 = p2 or decoder
	local v7 = nil
	local v8 = nil

	for k, v9 in pairs(v6) do
		if v9 == 62 then
			v7 = k
		elseif v9 == 63 then
			v8 = k
		end
	end

	local v9 = value:gsub(("[^%%w%%%s%%%s%%=]"):format((char)(v7), ((char)(v8))), "")

	local v10 = {}
	local v11 = {}
	local v12 = 1
	local count = #v9
	local v13 = v9:sub(-2) == "==" and 2 or v9:sub(-1) == "=" and 1 or 0
	local v15 = if v13 > 0 then count - 4 else count

	for i = 1, v15, 4 do
		local v16, v17, v18, v19 = v9:byte(i, i + 3)
		local v20

		if p3 then
			local v21 = v16 * 16777216 + v17 * 65536 + v18 * 256 + v19
			v20 = v10[v21]

			if not v20 then
				local v22 = v6[v16] * 262144 + v6[v17] * 4096 + v6[v18] * 64 + v6[v19]
				v20 = char(extract(v22, 16, 8), extract(v22, 8, 8), (extract(v22, 0, 8)))
				v10[v21] = v20
			end
		else
			local v21 = v6[v16] * 262144 + v6[v17] * 4096 + v6[v18] * 64 + v6[v19]
			v20 = char(extract(v21, 16, 8), extract(v21, 8, 8), (extract(v21, 0, 8)))
		end

		v11[v12] = v20
		v12 += 1
	end

	if v13 == 1 then
		local v16, v17, v18 = v9:byte(count - 3, count - 1)
		local v19 = v6[v16] * 262144 + v6[v17] * 4096 + v6[v18] * 64
		v11[v12] = char(extract(v19, 16, 8), (extract(v19, 8, 8)))
	elseif v13 == 2 then
		local v16, v17 = v9:byte(count - 3, count - 2)
		v11[v12] = char((extract(v6[v16] * 262144 + v6[v17] * 4096, 16, 8)))
	end

	return concat(v11)
end

function v5.DecodeUrl(p2, p3)
	local v6 = v5.FromUrlSafeBase64(p2)
	return v5.Decode(v6, nil, p3)
end

function v5.ToUrlSafeBase64(value)
	local v6 = string.gsub(value, "+", "-")
	local v7 = string.gsub(v6, "/", "_")
	return (string.gsub(v7, "=", ""))
end

function v5.FromUrlSafeBase64(value)
	local v6 = value:gsub("[^%w%-_]", "")

	local v7 = (4 - #v6 % 4) % 4
	local v8 = v6 .. string.rep("=", v7)
	local v9 = string.gsub(v8, "_", "/")
	return (string.gsub(v9, "-", "+"))
end

return v5
