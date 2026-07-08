local t2 = {
	MakeEncoder = function(s1: string?, s2: string?, s3: string?) -- line: 8
		local t1 = {}

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
			s1 or "+",
			s2 or "/",
			s3 or "="
		}) do
			t1[k] = v:byte()
		end

		return t1
	end
}

function t2.MakeDecoder(s4: string?, s5: string?, s6: string?) -- line: 82
	-- upvalues: t2 (copy)
	local t3 = {}

	for k, v in pairs(t2.MakeEncoder(s4, s5, s6)) do
		t3[v] = k
	end

	return t3
end

local v2 = t2.MakeEncoder()
local v3 = t2.MakeDecoder()
local char = string.char
local concat = table.concat
local extract = bit32.extract

function t2.Encode(s7: string, t4: {[any]: any}?, b1: boolean?) -- line: 97
	-- upvalues: v2 (copy), extract (copy), char (copy), concat (copy)
	local v22 = t4 or v2
	local t5 = {}
	local n1 = 1
	local v25 = #s7
	local v26 = v25 % 3
	local t6 = {}

	for i = 1, v25 - v26, 3 do
		local v29, v30, v31 = s7:byte(i, i + 2)
		local v32 = v29 * 65536 + v30 * 256 + v31
		local v33

		if b1 then
			v33 = t6[v32]

			if not v33 then
				v33 = char(v22[extract(v32, 18, 6)], v22[extract(v32, 12, 6)], v22[extract(v32, 6, 6)], v22[extract(v32, 0, 6)])
				t6[v32] = v33
			end
		else
			v33 = char(v22[extract(v32, 18, 6)], v22[extract(v32, 12, 6)], v22[extract(v32, 6, 6)], v22[extract(v32, 0, 6)])
		end

		t5[n1] = v33
		n1 += 1
	end

	if v26 == 2 then
		local v34, v35 = s7:byte(v25 - 1, v25)
		local v36 = v34 * 65536 + v35 * 256

		t5[n1] = char(v22[extract(v36, 18, 6)], v22[extract(v36, 12, 6)], v22[extract(v36, 6, 6)], v22[64])
	elseif v26 == 1 then
		local v37 = s7:byte(v25) * 65536

		t5[n1] = char(v22[extract(v37, 18, 6)], v22[extract(v37, 12, 6)], v22[64], v22[64])
	end

	return concat(t5)
end
function t2.EncodeUrl(s8: string, b2: boolean?) -- line: 152
	-- upvalues: t2 (copy)
	local v40 = t2.Encode(s8, nil, b2)

	return t2.ToUrlSafeBase64(v40)
end
function t2.Decode(s9: string, t7: {[any]: any}?, b3: boolean?) -- line: 158
	-- upvalues: v3 (copy), char (copy), extract (copy), concat (copy)
	local v44 = t7 or v3
	local v45 = nil
	local v46 = nil

	for k, v in pairs(v44) do
		if v == 62 then
			v45 = k
		elseif v == 63 then
			v46 = k
		end
	end

	local v49 = s9:gsub(("[^%%w%%%s%%%s%%=]"):format(char(v45), (char(v46))), "")
	local t8 = {}
	local t9 = {}
	local n2 = 1
	local v53 = #v49
	local v54 = if v49:sub(-2) ~= "==" then v49:sub(-1) ~= "=" and 0 or 1 else 2

	for i = 1, if not (v54 > 0) then v53 else v53 - 4, 4 do
		local v56, v57, v58, v59 = v49:byte(i, i + 3)
		local v61

		if b3 then
			local v60 = v56 * 16777216 + v57 * 65536 + v58 * 256 + v59

			v61 = t8[v60]

			if not v61 then
				local v62 = v44[v56] * 262144 + v44[v57] * 4096 + v44[v58] * 64 + v44[v59]

				v61 = char(extract(v62, 16, 8), extract(v62, 8, 8), (extract(v62, 0, 8)))
				t8[v60] = v61
			end
		else
			local v63 = v44[v56] * 262144 + v44[v57] * 4096 + v44[v58] * 64 + v44[v59]

			v61 = char(extract(v63, 16, 8), extract(v63, 8, 8), (extract(v63, 0, 8)))
		end

		t9[n2] = v61
		n2 += 1
	end

	if v54 == 1 then
		local v64, v65, v66 = v49:byte(v53 - 3, v53 - 1)
		local v67 = v44[v64] * 262144 + v44[v65] * 4096 + v44[v66] * 64

		t9[n2] = char(extract(v67, 16, 8), (extract(v67, 8, 8)))
	elseif v54 == 2 then
		local v68, v69 = v49:byte(v53 - 3, v53 - 2)

		t9[n2] = char((extract(v44[v68] * 262144 + v44[v69] * 4096, 16, 8)))
	end

	return concat(t9)
end
function t2.DecodeUrl(s10: string, b4: boolean?) -- line: 213
	-- upvalues: t2 (copy)
	local v72 = t2.FromUrlSafeBase64(s10)

	return t2.Decode(v72, nil, b4)
end
function t2.ToUrlSafeBase64(s11: string) -- line: 218
	local v74 = string.gsub(s11, "+", "-")
	local v75 = string.gsub(v74, "/", "_")

	return (string.gsub(v75, "=", ""))
end
function t2.FromUrlSafeBase64(s12: string) -- line: 225
	local v77 = s12:gsub("[^%w%-_]", "")
	local v78 = (4 - #v77 % 4) % 4
	local v79 = v77 .. string.rep("=", v78)
	local v80 = string.gsub(v79, "_", "/")

	return (string.gsub(v80, "-", "+"))
end

return t2
