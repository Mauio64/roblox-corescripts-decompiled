local preloadConstants = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Preload/preloadConstants")
local preloadFastInts = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/Preload/preloadFastInts")

local function selectPreloadPolicy(p2)
	return {
		downloadWindow = preloadFastInts.getDownloadWindow(),
		decodeWindow = preloadFastInts.getDecodeWindow(),
		usePoster = preloadConstants.usePoster,
		decodeRetryDelayMs = preloadFastInts.getDecodeRetryDelayMs(),
		maxDecodeRetries = preloadFastInts.getMaxDecodeRetries()
	}
end

return selectPreloadPolicy
