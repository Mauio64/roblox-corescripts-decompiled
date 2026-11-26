local function imul32(p2, p3)
	local v5 = bit32.rshift(p2, 16)
	local v6 = bit32.band(p2, 65535)
	local v7 = bit32.rshift(p3, 16)
	local v8 = bit32.band(p3, 65535)

	local v9 = v6 * v8
	local v10 = v5 * v8 + v6 * v7
	local v11 = v5 * v7

	local v12 = v9 + bit32.lshift(bit32.band(v10, 65535), 16)
	v11 += bit32.rshift(v10, 16)

	return (bit32.band(v12, 4294967295))
end

return {
	textEncode = function(value)
		local result = {}

		for i = 1, #value do
			table.insert(result, (string.byte(value, i)))
		end

		return result
	end,
	hashStringWithFnv1a32 = function(value)
		local v5 = {}

		for i = 1, #value do
			table.insert(v5, (string.byte(value, i)))
		end

		local v6 = 2166136261

		for i, v7 in ipairs(v5) do
			local v8 = bit32.bxor(v6, v7)
			local v9 = bit32.rshift(v8, 16)
			local v10 = bit32.band(v8, 65535)

			local v11 = v10 * 403
			local v12 = v9 * 403 + v10 * 256
			local v13 = v9 * 256

			local v14 = v11 + bit32.lshift(bit32.band(v12, 65535), 16)
			v13 += bit32.rshift(v12, 16)

			v6 = bit32.band(v14, 4294967295)
		end

		return (string.format("%08x", v6))
	end
}
