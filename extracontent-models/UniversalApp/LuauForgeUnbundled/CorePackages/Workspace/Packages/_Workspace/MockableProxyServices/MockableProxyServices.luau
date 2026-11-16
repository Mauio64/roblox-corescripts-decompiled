local v5 = {
	game = game,
	waitProxy = function(p2)
		wait(p2)
	end,
	settingsProxy = function()
		return settings()
	end
}

setmetatable(v5, {
	__index = function(p2, serviceName)
		return game:GetService(serviceName)
	end
})

return v5
