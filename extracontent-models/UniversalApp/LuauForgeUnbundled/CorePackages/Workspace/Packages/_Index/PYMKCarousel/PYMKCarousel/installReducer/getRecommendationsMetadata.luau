local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies").SocialLibraries.Dictionary.getDeepValue

return function(p2, p3)
	return getDeepValue(p2, string.format("metadata.%s", p3)) or {}
end
