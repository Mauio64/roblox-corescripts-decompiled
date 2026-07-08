local GET = require(script.Parent.GET)
local POST = require(script.Parent.POST)
local PATCH = require(script.Parent.PATCH)
local DELETE = require(script.Parent.DELETE)

require(script.Parent.Types)

return function(p1) -- line: 8
	-- upvalues: GET (copy), POST (copy), PATCH (copy), DELETE (copy)
	assert(p1, "Expected options to be passed into RoduxNetworking")
	assert(p1.keyPath, "Expected options.keyPath to be passed into RoduxNetworking")
	assert(p1.networkImpl, "Expected options.networkImpl to be passed into RoduxNetworking")

	return {
		GET = function(p2, p3) -- line: 14
			-- upvalues: GET (copy), p1 (copy)
			assert(p2, "RoduxNetworking:GET expects moduleScript argument")
			assert(p2, "RoduxNetworking:GET expects constructBuilderFunction argument")

			return GET(p1)(p2, p3)
		end,
		POST = function(p4, p5) -- line: 19
			-- upvalues: POST (copy), p1 (copy)
			return POST(p1)(p4, p5)
		end,
		PATCH = function(p6, p7) -- line: 22
			-- upvalues: PATCH (copy), p1 (copy)
			return PATCH(p1)(p6, p7)
		end,
		DELETE = function(p8, p9) -- line: 25
			-- upvalues: DELETE (copy), p1 (copy)
			return DELETE(p1)(p8, p9)
		end,
		getNetworkImpl = function() -- line: 28
			-- upvalues: p1 (copy)
			return p1.networkImpl
		end,
		setNetworkImpl = function(p10) -- line: 31
			-- upvalues: p1 (copy)
			p1.networkImpl = p10
		end
	}
end
