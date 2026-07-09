local t1 = {
	["jest.config"] = script["jest.config"],
	game = game,
	waitProxy = function(p1) -- line: 4
		wait(p1)
	end,
	settingsProxy = function() -- line: 7
		return settings()
	end
}

setmetatable(t1, {
	__index = function(_, p3) -- line: 13
		return game:GetService(p3)
	end
})

return t1
