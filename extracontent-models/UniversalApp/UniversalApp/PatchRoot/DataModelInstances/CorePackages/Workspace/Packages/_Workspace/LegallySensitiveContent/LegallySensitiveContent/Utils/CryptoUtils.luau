local function imul32(n1: number, n2: number) -- line: 29
	local v7 = bit32.rshift(n1, 16)
	local v8 = bit32.band(n1, 65535)
	local v9 = bit32.rshift(n2, 16)
	local v10 = bit32.band(n2, 65535)
	local v11 = v8 * v10
	local v12 = v7 * v10 + v8 * v9
	local v13 = v7 * v9
	local v14 = v11 + bit32.lshift(bit32.band(v12, 65535), 16)
	local _ = v13 + bit32.rshift(v12, 16)

	return (bit32.band(v14, 4294967295))
end

return {
	textEncode = function(s1: string) -- line: 10
		local t1 = {}

		for i = 1, #s1 do
			table.insert(t1, (string.byte(s1, i)))
		end

		return t1
	end,
	hashStringWithFnv1a32 = function(s2: string) -- line: 50
		local t2 = {}

		for i = 1, #s2 do
			table.insert(t2, (string.byte(s2, i)))
		end

		local n3 = 2166136261

		for _, v in ipairs(t2) do
			local v22 = bit32.bxor(n3, v)
			local v23 = bit32.rshift(v22, 16)
			local v24 = bit32.band(v22, 65535)
			local v25 = v24 * 403
			local v26 = v23 * 403 + v24 * 256
			local v27 = v23 * 256
			local v28 = v25 + bit32.lshift(bit32.band(v26, 65535), 16)
			local _ = v27 + bit32.rshift(v26, 16)

			n3 = bit32.band(v28, 4294967295)
		end

		return (string.format("%08x", n3))
	end
}
