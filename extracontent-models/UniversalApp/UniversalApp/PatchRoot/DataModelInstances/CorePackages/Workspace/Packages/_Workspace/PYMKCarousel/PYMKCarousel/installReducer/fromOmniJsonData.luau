local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local Result = require(PYMKCarousel.dependencies).Result

return function(p1) -- line: 6
	-- upvalues: Result (copy)
	return Result.success(p1)
end
