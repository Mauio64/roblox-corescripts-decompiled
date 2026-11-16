local MockableProxyServices = {
	["jest.config"] = script["jest.config"],
	game = game,
	waitProxy = function(p)
		wait(p)
	end,
	settingsProxy = function()
		return settings()
	end
}

setmetatable(MockableProxyServices, {
	__index = function(_, serviceName)
		return game:GetService(serviceName)
	end
})

return MockableProxyServices
