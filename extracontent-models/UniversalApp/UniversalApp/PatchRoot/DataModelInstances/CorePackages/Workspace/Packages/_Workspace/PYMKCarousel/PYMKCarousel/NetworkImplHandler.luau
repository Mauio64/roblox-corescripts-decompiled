local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)

require(PYMKCarousel.devDependencies).JestGlobals.beforeAll(function() -- line: 7
	-- upvalues: dependencies (copy)
	dependencies.RoduxNetworking.setNetworkImpl(function(p1) -- line: 8
		error(string.format("🔥 Should have replaced network implementation for url: %s", (tostring(p1))))
	end)
end)
