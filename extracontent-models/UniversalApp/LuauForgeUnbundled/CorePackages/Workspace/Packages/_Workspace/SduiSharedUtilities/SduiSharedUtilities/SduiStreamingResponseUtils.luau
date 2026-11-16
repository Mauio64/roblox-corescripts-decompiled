local function readFrameLength(value, p2)
	local v5 = 1
	local total = 0

	for i = p2, math.min(p2 + 5 - 1, #value) do
		local v6 = string.byte(value, i)

		total += v6 % 128 * v5

		if v6 < 128 then
			return total, i - p2 + 1
		end

		v5 *= 128
	end

	if #value - p2 + 1 >= 5 then
		error("Frame length varint exceeds maximum size")
	end

	return nil, 0
end

return {
	isEmptyResponseBody = function(value): boolean
		if value == nil then
			return true
		end

		if typeof(value) == "string" then
			return value == ""
		end

		if typeof(value) == "buffer" then
			return buffer.len(value) == 0
		end

		return false
	end,
	extractFrames = function(value)
		local v5 = 1
		local result = {}

		while v5 <= #value do
			local v6, v7 = readFrameLength(value, v5)

			if v6 == nil then
				break
			end

			if v6 == 0 then
				error("Frame length of zero is not a valid frame")
			end

			if v6 > 52428800 then
				error(`Frame length {v6} exceeds maximum supported size`)
			end

			local v8 = v5 + v7
			local v9 = v8 + v6 - 1

			if #value < v9 then
				break
			end

			table.insert(result, (string.sub(value, v8, v9)))
			v5 = v9 + 1
		end

		return result, (string.sub(value, v5))
	end
}
