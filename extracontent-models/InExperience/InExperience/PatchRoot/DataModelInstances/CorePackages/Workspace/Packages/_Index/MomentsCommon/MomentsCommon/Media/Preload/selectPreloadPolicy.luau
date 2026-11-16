local MomentsCommon = script:FindFirstAncestor("MomentsCommon")

local preloadConstants = require(MomentsCommon.Media.Preload.preloadConstants)
local preloadFastInts = require(MomentsCommon.Media.Preload.preloadFastInts)

local function selectPreloadPolicy(_)
	return {
		downloadWindow = preloadFastInts.getDownloadWindow(),
		decodeWindow = preloadFastInts.getDecodeWindow(),
		usePoster = preloadConstants.usePoster,
		decodeRetryDelayMs = preloadFastInts.getDecodeRetryDelayMs(),
		maxDecodeRetries = preloadFastInts.getMaxDecodeRetries()
	}
end

return selectPreloadPolicy
