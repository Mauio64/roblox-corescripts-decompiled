local function textEncode(value: string) -- 1 equivalent call inferred from this helper
	local result = {}

	for i = 1, #value do
		table.insert(result, (string.byte(value, i)))
	end

	return result
end

local function imul32(p: number, p2: number)
	local v = bit32.rshift(p, 16)
	local v2 = bit32.band(p, 65535)
	local v3 = bit32.rshift(p2, 16)
	local v4 = bit32.band(p2, 65535)

	local v5 = v2 * v4
	local v6 = v * v4 + v2 * v3
	local v7 = v * v3

	local v8 = v5 + bit32.lshift(bit32.band(v6, 65535), 16)
	v7 += bit32.rshift(v6, 16)

	return (bit32.band(v8, 4294967295))
end

return {
	textEncode = textEncode,
	hashStringWithFnv1a32 = function(value: string)
		local result = textEncode(value) -- inferred equivalent call
		local v = 2166136261

		for _, v2 in ipairs(result) do
			local v3 = bit32.bxor(v, v2)
			local v4 = bit32.rshift(v3, 16)
			local v5 = bit32.band(v3, 65535)

			local v6 = v5 * 403
			local v7 = v4 * 403 + v5 * 256
			local v8 = v4 * 256

			local v9 = v6 + bit32.lshift(bit32.band(v7, 65535), 16)
			v8 += bit32.rshift(v7, 16)

			v = bit32.band(v9, 4294967295)
		end

		return (string.format("%08x", v))
	end
}
