local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)
local rodux = dependencies.Rodux

return function(options, p)
	return rodux.Store.new(p or function(p2)
		return p2
	end, options or {}, { rodux.thunkMiddleware })
end
