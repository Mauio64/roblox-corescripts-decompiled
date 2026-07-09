local function readFrameLength(s1: string, n1: number) -- line: 27
	local n2 = 0
	local n3 = 1

	for i = n1, math.min(n1 + 5 - 1, #s1) do
		local byte = string.byte(s1, i)

		n2 += byte % 128 * n3

		if byte < 128 then
			return n2, i - n1 + 1
		end

		n3 *= 128
	end

	if #s1 - n1 + 1 >= 5 then
		error("Frame length varint exceeds maximum size")
	end

	return nil, 0
end

return {
	isEmptyResponseBody = function(p1) -- line: 9
		if p1 == nil then
			return true
		end

		if typeof(p1) == "string" then
			return p1 == ""
		end

		if typeof(p1) == "buffer" then
			return buffer.len(p1) == 0
		end

		return false
	end,
	extractFrames = function(s2: string) -- line: 51
		-- upvalues: readFrameLength (copy)
		local t1 = {}
		local n4 = 1

		while n4 <= #s2 do
			local v12, v13 = readFrameLength(s2, n4)

			if v12 == nil then
				return t1, (string.sub(s2, n4))
			end

			if v12 == 0 then
				error("Frame length of zero is not a valid protobuf message")
			end

			if v12 > 52428800 then
				error(`Frame length { v12 } exceeds maximum supported size`)
			end

			local v14 = n4 + v13
			local v15 = v14 + v12 - 1

			if v15 > #s2 then
				return t1, (string.sub(s2, n4))
			end

			table.insert(t1, (string.sub(s2, v14, v15)))
			n4 = v15 + 1
		end

		return t1, (string.sub(s2, n4))
	end
}
