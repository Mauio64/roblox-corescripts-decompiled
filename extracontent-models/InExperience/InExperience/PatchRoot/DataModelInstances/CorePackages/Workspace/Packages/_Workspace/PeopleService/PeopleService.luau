local ServiceLocator = require(script.ServiceLocator)

return {
	ServiceLocator = ServiceLocator,
	getService = function(p)
		return ServiceLocator.get(p)
	end,
	setupMockServices = function(items)
		ServiceLocator.clear()

		for k, item in pairs(items) do
			ServiceLocator.register(k, item)
		end
	end,
	["jest.config"] = script["jest.config"]
}
