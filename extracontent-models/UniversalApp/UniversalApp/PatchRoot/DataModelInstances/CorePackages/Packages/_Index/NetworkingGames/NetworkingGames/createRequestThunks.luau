local networkRequests = script.Parent.networkRequests
local createGetExperiencesPlayabilityStatus = require(networkRequests.createGetExperiencesPlayabilityStatus)
local createGetExperiencesProductInfo = require(networkRequests.createGetExperiencesProductInfo)
local createGetExperiencesDetails = require(networkRequests.createGetExperiencesDetails)
local createGetExperienceMedia = require(networkRequests.createGetExperienceMedia)

return function(p1) -- line: 8
	-- upvalues: createGetExperiencesPlayabilityStatus (copy), createGetExperiencesProductInfo (copy), createGetExperiencesDetails (copy), createGetExperienceMedia (copy)
	return {
		GetExperiencesPlayabilityStatus = createGetExperiencesPlayabilityStatus(p1),
		GetExperiencesProductInfo = createGetExperiencesProductInfo(p1),
		GetExperiencesDetails = createGetExperiencesDetails(p1),
		GetExperienceMedia = createGetExperienceMedia(p1)
	}
end
