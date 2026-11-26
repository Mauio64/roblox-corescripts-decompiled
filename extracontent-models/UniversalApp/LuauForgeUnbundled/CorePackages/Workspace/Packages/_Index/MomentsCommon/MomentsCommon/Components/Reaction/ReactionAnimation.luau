return {
	getDurationSeconds = function(p2)
		return p2.frameCount / p2.fps
	end,
	getFrameIndex = function(p2, p3, p4)
		local v5 = math.floor(p3 * p2.fps)

		if p4 then
			return v5 % p2.frameCount + 1
		end

		return (math.min(v5 + 1, p2.frameCount))
	end,
	getFrameRect = function(data, value)
		local v5 = math.clamp(value, 1, data.frameCount)
		local v6 = v5 - 1
		local v7 = v6 % data.columns
		local v8 = math.floor(v6 / data.columns)
		local stride = data.stride or data.cellSize or data.frameSize + (data.padding or 0)

		return {
			frameIndex = v5,
			offset = Vector2.new(v7 * stride, v8 * stride),
			size = Vector2.new(data.frameSize, data.frameSize)
		}
	end,
	getFrameStride = function(data)
		return data.stride or data.cellSize or data.frameSize + (data.padding or 0)
	end
}
