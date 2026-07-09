local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local getDeepValue = require(PYMKCarousel.dependencies).SocialLibraries.Dictionary.getDeepValue

return function(p1, s1: string) -- line: 7
	-- upvalues: getDeepValue (copy)
	return getDeepValue(p1, string.format("metadata.%s", s1)) or {}
end
