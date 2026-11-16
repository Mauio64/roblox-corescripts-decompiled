local audioDuckingFastInts = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon").Media.audioDuckingFastInts

local function getTtsDuckScalar()
	local compressorParams = audioDuckingFastInts.getCompressorParams()

	if compressorParams.ratio <= 0 then
		return 1
	end

	local v5 = -compressorParams.threshold * (1 - 1 / compressorParams.ratio)
	return (math.clamp(10 ^ ((compressorParams.makeupGain - v5) / 20), 0, 1))
end

return getTtsDuckScalar
