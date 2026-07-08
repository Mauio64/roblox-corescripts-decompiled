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
local v2 = t2.MakeEncoder()
local char = string.char
local concat = table.concat
local extract = bit32.extract

function t2.Encode(s4: string, t3: {[any]: any}?, b1: boolean?) -- line: 88
	-- upvalues: v2 (copy), extract (copy), char (copy), concat (copy)
	local v15 = t3 or v2
	local t4 = {}
	local n1 = 1
	local v18 = #s4
	local v19 = v18 % 3
	local t5 = {}

	for i = 1, v18 - v19, 3 do
		local v22, v23, v24 = s4:byte(i, i + 2)
		local v25 = v22 * 65536 + v23 * 256 + v24
		local v26

		if b1 then
			v26 = t5[v25]

			if not v26 then
				v26 = char(v15[extract(v25, 18, 6)], v15[extract(v25, 12, 6)], v15[extract(v25, 6, 6)], v15[extract(v25, 0, 6)])
				t5[v25] = v26
			end
		else
			v26 = char(v15[extract(v25, 18, 6)], v15[extract(v25, 12, 6)], v15[extract(v25, 6, 6)], v15[extract(v25, 0, 6)])
		end

		t4[n1] = v26
		n1 += 1
	end

	if v19 == 2 then
		local v27, v28 = s4:byte(v18 - 1, v18)
		local v29 = v27 * 65536 + v28 * 256

		t4[n1] = char(v15[extract(v29, 18, 6)], v15[extract(v29, 12, 6)], v15[extract(v29, 6, 6)], v15[64])
	elseif v19 == 1 then
		local v30 = s4:byte(v18) * 65536

		t4[n1] = char(v15[extract(v30, 18, 6)], v15[extract(v30, 12, 6)], v15[64], v15[64])
	end

	return concat(t4)
end

return t2
