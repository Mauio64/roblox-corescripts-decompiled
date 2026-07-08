--!native
local t1 = {}
local t2 = {}

for i = 1, 64 do
	local v4 = i - 1
	local byte = string.byte("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", i)

	t1[v4] = byte
	t2[byte] = v4
end

t2[61] = 0

local function buildStringFromCodes(t3: {[any]: any}) -- line: 46
	local t4 = {}

	for i = 1, #t3, 4096 do
		table.insert(t4, (string.char(unpack(t3, i, (math.min(i + 4096 - 1, #t3))))))
	end

	return table.concat(t4, "")
end

return {
	encode = function(s1: string) -- line: 56
		-- upvalues: t1 (copy), buildStringFromCodes (copy)
		local v11 = #s1
		local v12 = math.ceil(v11 / 3) * 4
		local v13 = v11 % 3

		if v13 == 0 then
			s1 ..= "\000"
		end

		local t5 = table.create(v12, 0)

		for i = 0, v12 / 4 - (v13 ~= 0 and 2 or 1) do
			local v16 = i * 3 + 1
			local v17 = i * 4 + 1
			local v18 = bit32.rshift(string.unpack(">J", s1, v16), 8)

			t5[v17] = t1[bit32.rshift(v18, 18)]
			t5[v17 + 1] = t1[bit32.band(bit32.rshift(v18, 12), 63)]
			t5[v17 + 2] = t1[bit32.band(bit32.rshift(v18, 6), 63)]
			t5[v17 + 3] = t1[bit32.band(v18, 63)]
		end

		if v13 == 1 then
			local byte = string.byte(s1, v11)

			t5[v12 - 3] = t1[bit32.rshift(byte, 2)]
			t5[v12 - 2] = t1[bit32.band(bit32.lshift(byte, 4), 63)]
			t5[v12 - 1] = 61
			t5[v12] = 61
		elseif v13 == 2 then
			local v20 = string.unpack(">H", s1, v11 - 1)

			t5[v12 - 3] = t1[bit32.rshift(v20, 10)]
			t5[v12 - 2] = t1[bit32.band(bit32.rshift(v20, 4), 63)]
			t5[v12 - 1] = t1[bit32.band(bit32.lshift(v20, 2), 63)]
			t5[v12] = 61
		end

		return buildStringFromCodes(t5)
	end,
	decode = function(s2: string) -- line: 102
		-- upvalues: t2 (copy), buildStringFromCodes (copy)
		local v22 = #s2
		local v23 = math.ceil(v22 / 4) * 3
		local n1 = 0

		if string.byte(s2, v22 - 1) == 61 then
			n1 = 2
		elseif string.byte(s2, v22) == 61 then
			n1 = 1
		end

		local t6 = table.create(v23 - n1, 0)

		for i = 0, v23 / 3 - 1 do
			local v27 = i * 4 + 1
			local v28 = i * 3 + 1
			local v29, v30, v31, v32 = string.byte(s2, v27, v27 + 3)
			local v33 = bit32.bor(bit32.lshift(t2[v29], 18), bit32.lshift(t2[v30], 12), bit32.lshift(t2[v31], 6), t2[v32])

			t6[v28] = bit32.rshift(v33, 16)
			t6[v28 + 1] = bit32.band(bit32.rshift(v33, 8), 255)
			t6[v28 + 2] = bit32.band(v33, 255)
		end

		if n1 >= 1 then
			t6[v23] = nil

			if n1 >= 2 then
				t6[v23 - 1] = nil
			end
		end

		return buildStringFromCodes(t6)
	end
}
