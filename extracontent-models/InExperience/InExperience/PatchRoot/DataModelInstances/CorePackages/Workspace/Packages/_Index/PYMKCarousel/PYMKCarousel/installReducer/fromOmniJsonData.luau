local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)
local result = dependencies.Result

return function(p)
	return result.success(p)
end
