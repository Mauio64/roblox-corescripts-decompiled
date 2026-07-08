return {
	getDurationSeconds = function(t1: {[any]: any}) -- line: 22
		return t1.frameCount / t1.fps
	end,
	getFrameIndex = function(t2: {[any]: any}, n1: number, b1: boolean) -- line: 26
		local v5 = math.floor(n1 * t2.fps)

		if b1 then
			return v5 % t2.frameCount + 1
		end

		return (math.min(v5 + 1, t2.frameCount))
	end,
	getFrameRect = function(t3: {[any]: any}, n2: number) -- line: 40
		local v9 = math.clamp(n2, 1, t3.frameCount)
		local v10 = v9 - 1
		local v11 = v10 % t3.columns
		local v12 = math.floor(v10 / t3.columns)
		local v13 = t3.stride or (t3.cellSize or t3.frameSize + (t3.padding or 0))

		return {
			frameIndex = v9,
			offset = Vector2.new(v11 * v13, v12 * v13),
			size = Vector2.new(t3.frameSize, t3.frameSize)
		}
	end,
	getFrameStride = function(t4: {[any]: any}) -- line: 36
		return t4.stride or (t4.cellSize or t4.frameSize + (t4.padding or 0))
	end
}
