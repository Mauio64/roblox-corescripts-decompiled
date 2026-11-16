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

function Base64.MakeDecoder(p: string?, p2: string?, p3: string?)
	local decoder = {}

	for k, v in pairs(Base64.MakeEncoder(p, p2, p3)) do
		decoder[v] = k
	end

	return decoder
end

local encoder = Base64.MakeEncoder()
local decoder = Base64.MakeDecoder()

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

function Base64.EncodeUrl(p: string, flag: boolean?)
	local encoded = Base64.Encode(p, nil, flag)
	return Base64.ToUrlSafeBase64(encoded)
end

function Base64.Decode(value: string, p, flag: boolean?)
	local v = p or decoder
	local v2 = nil
	local v3 = nil

	for k, v4 in pairs(v) do
		if v4 == 62 then
			v2 = k
		elseif v4 == 63 then
			v3 = k
		end
	end

	local v4 = value:gsub(("[^%%w%%%s%%%s%%=]"):format(char(v2), (char(v3))), "")

	local v5 = {}
	local v6 = {}
	local v7 = 1
	local count = #v4
	local v8 = v4:sub(-2) == "==" and 2 or v4:sub(-1) == "=" and 1 or 0
	local v9

	if v8 > 0 then
		v9 = count - 4
	else
		v9 = count
	end

	for i = 1, v9, 4 do
		local v10, v11, v12, v13 = v4:byte(i, i + 3)
		local v14

		if flag then
			local v15 = v10 * 16777216 + v11 * 65536 + v12 * 256 + v13
			v14 = v5[v15]

			if not v14 then
				local v16 = v[v10] * 262144 + v[v11] * 4096 + v[v12] * 64 + v[v13]
				v14 = char(extract(v16, 16, 8), extract(v16, 8, 8), (extract(v16, 0, 8)))
				v5[v15] = v14
			end
		else
			local v15 = v[v10] * 262144 + v[v11] * 4096 + v[v12] * 64 + v[v13]
			v14 = char(extract(v15, 16, 8), extract(v15, 8, 8), (extract(v15, 0, 8)))
		end

		v6[v7] = v14
		v7 += 1
	end

	if v8 == 1 then
		local v10, v11, v12 = v4:byte(count - 3, count - 1)
		local v13 = v[v10] * 262144 + v[v11] * 4096 + v[v12] * 64
		v6[v7] = char(extract(v13, 16, 8), (extract(v13, 8, 8)))
	elseif v8 == 2 then
		local v10, v11 = v4:byte(count - 3, count - 2)
		v6[v7] = char((extract(v[v10] * 262144 + v[v11] * 4096, 16, 8)))
	end

	return concat(v6)
end

function Base64.DecodeUrl(p: string, flag: boolean?)
	local v = Base64.FromUrlSafeBase64(p)
	return Base64.Decode(v, nil, flag)
end

function Base64.ToUrlSafeBase64(value: string)
	local v = string.gsub(value, "+", "-")
	local v2 = string.gsub(v, "/", "_")
	return (string.gsub(v2, "=", ""))
end

function Base64.FromUrlSafeBase64(value: string)
	local v = value:gsub("[^%w%-_]", "")

	local v2 = (4 - #v % 4) % 4
	local v3 = v .. string.rep("=", v2)
	local v4 = string.gsub(v3, "_", "/")
	return (string.gsub(v4, "-", "+"))
end

return Base64
