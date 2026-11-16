local function readFrameLength(value: string, p: number)
	local v = 1
	local total = 0

	for i = p, math.min(p + 5 - 1, #value) do
		local v2 = string.byte(value, i)

		total += v2 % 128 * v

		if v2 < 128 then
			return total, i - p + 1
		end

		v *= 128
	end

	if #value - p + 1 >= 5 then
		error("Frame length varint exceeds maximum size")
	end

	return nil, 0
end

local SduiStreamingResponseUtils = {}

function SduiStreamingResponseUtils.isEmptyResponseBody(value): boolean
	if value == nil then
		return true
	end

	if typeof(value) == "string" then
		return value == ""
	end

	return typeof(value) == "buffer" and buffer.len(value) == 0
end

function SduiStreamingResponseUtils.extractFrames(value: string)
	local v = 1
	local result = {}

	while v <= #value do
		local v2, v3 = readFrameLength(value, v)

		if v2 == nil then
			break
		end

		if v2 == 0 then
			error("Frame length of zero is not a valid frame")
		end

		if v2 > 52428800 then
			error(`Frame length {v2} exceeds maximum supported size`)
		end

		local v4 = v + v3
		local v5 = v4 + v2 - 1

		if #value < v5 then
			break
		end

		table.insert(result, (string.sub(value, v4, v5)))
		v = v5 + 1
	end

	return result, (string.sub(value, v))
end

return SduiStreamingResponseUtils
