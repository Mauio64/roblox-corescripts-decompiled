local parent = script:FindFirstAncestor("MomentsCreation").Parent

local MomentsCommon = require(parent.MomentsCommon)
local audioDuckingFastInts = MomentsCommon.Media.audioDuckingFastInts

local function getTtsDuckScalar()
	local compressorParams = audioDuckingFastInts.getCompressorParams()

	if compressorParams.ratio <= 0 then
		return 1
	end

	local v = -compressorParams.threshold * (1 - 1 / compressorParams.ratio)
	return (math.clamp(10 ^ ((compressorParams.makeupGain - v) / 20), 0, 1))
end

return getTtsDuckScalar
