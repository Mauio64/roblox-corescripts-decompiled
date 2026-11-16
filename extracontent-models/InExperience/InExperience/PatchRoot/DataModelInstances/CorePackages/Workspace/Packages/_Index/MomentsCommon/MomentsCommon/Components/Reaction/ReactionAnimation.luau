local function getFrameStride(data) -- 1 equivalent call inferred from this helper
	return data.stride or data.cellSize or data.frameSize + (data.padding or 0)
end

local ReactionAnimation = {}

function ReactionAnimation.getDurationSeconds(p)
	return p.frameCount / p.fps
end

function ReactionAnimation.getFrameIndex(p, p2: number, flag: boolean)
	local v = math.floor(p2 * p.fps)

	if flag then
		return v % p.frameCount + 1
	end

	return (math.min(v + 1, p.frameCount))
end

function ReactionAnimation.getFrameRect(data, value: number)
	local frameIndex = math.clamp(value, 1, data.frameCount)
	local v = frameIndex - 1
	local v2 = v % data.columns
	local v3 = math.floor(v / data.columns)
	local frameStride = getFrameStride(data) -- inferred equivalent call
	return {
		frameIndex = frameIndex,
		offset = Vector2.new(v2 * frameStride, v3 * frameStride),
		size = Vector2.new(data.frameSize, data.frameSize)
	}
end

ReactionAnimation.getFrameStride = getFrameStride
return ReactionAnimation
