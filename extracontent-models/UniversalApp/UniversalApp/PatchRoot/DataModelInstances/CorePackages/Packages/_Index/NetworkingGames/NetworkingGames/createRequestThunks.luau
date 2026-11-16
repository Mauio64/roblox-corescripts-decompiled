local networkRequests = script.Parent.networkRequests

local createGetExperiencesPlayabilityStatus = require(networkRequests.createGetExperiencesPlayabilityStatus)
local createGetExperiencesProductInfo = require(networkRequests.createGetExperiencesProductInfo)
local createGetExperiencesDetails = require(networkRequests.createGetExperiencesDetails)
local createGetExperienceMedia = require(networkRequests.createGetExperienceMedia)

return function(p)
	return {
		GetExperiencesPlayabilityStatus = createGetExperiencesPlayabilityStatus(p),
		GetExperiencesProductInfo = createGetExperiencesProductInfo(p),
		GetExperiencesDetails = createGetExperiencesDetails(p),
		GetExperienceMedia = createGetExperienceMedia(p)
	}
end
