local GET = require(script.Parent.GET)
local POST = require(script.Parent.POST)
local PATCH = require(script.Parent.PATCH)
local DELETE = require(script.Parent.DELETE)
require(script.Parent.Types)

return function(state)
	assert(state, "Expected options to be passed into RoduxNetworking")
	assert(state.keyPath, "Expected options.keyPath to be passed into RoduxNetworking")
	assert(state.networkImpl, "Expected options.networkImpl to be passed into RoduxNetworking")

	return {
		GET = function(p, p2)
			assert(p, "RoduxNetworking:GET expects moduleScript argument")
			assert(p, "RoduxNetworking:GET expects constructBuilderFunction argument")
			return GET(state)(p, p2)
		end,
		POST = function(p, p2)
			return POST(state)(p, p2)
		end,
		PATCH = function(p, p2)
			return PATCH(state)(p, p2)
		end,
		DELETE = function(p, p2)
			return DELETE(state)(p, p2)
		end,
		getNetworkImpl = function()
			return state.networkImpl
		end,
		setNetworkImpl = function(networkImpl)
			state.networkImpl = networkImpl
		end
	}
end
