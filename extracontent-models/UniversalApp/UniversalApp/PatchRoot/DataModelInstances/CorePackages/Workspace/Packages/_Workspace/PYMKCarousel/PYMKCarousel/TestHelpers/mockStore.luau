local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local Rodux = require(PYMKCarousel.dependencies).Rodux

return function(p1, p2) -- line: 6
	-- upvalues: Rodux (copy)
	local v5 = p2 or function(p3) -- line: 7
		return p3
	end

	return Rodux.Store.new(v5, p1 or {}, { Rodux.thunkMiddleware })
end
