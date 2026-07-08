local ServiceLocator = require(script.ServiceLocator)

return {
	ServiceLocator = ServiceLocator,
	getService = function(p1) -- line: 11
		-- upvalues: ServiceLocator (copy)
		return ServiceLocator.get(p1)
	end,
	setupMockServices = function(p2) -- line: 16
		-- upvalues: ServiceLocator (copy)
		ServiceLocator.clear()

		for k, v in pairs(p2) do
			ServiceLocator.register(k, v)
		end
	end,
	["jest.config"] = script["jest.config"]
}
