local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local preloadConstants = require(MomentsCommon.Media.Preload.preloadConstants)

local function selectPreloadPolicy(_: {[any]: any}?) -- line: 28
	-- upvalues: preloadConstants (copy)
	return {
		downloadWindow = preloadConstants.downloadWindow,
		decodeWindow = preloadConstants.decodeWindow,
		usePoster = preloadConstants.usePoster
	}
end

return selectPreloadPolicy
