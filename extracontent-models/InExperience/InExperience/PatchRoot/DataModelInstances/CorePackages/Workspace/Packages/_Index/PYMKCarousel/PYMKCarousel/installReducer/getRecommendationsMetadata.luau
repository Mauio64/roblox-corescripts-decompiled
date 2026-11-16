local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)

local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue

return function(p, p2: string)
	return getDeepValue(p, string.format("metadata.%s", p2)) or {}
end
