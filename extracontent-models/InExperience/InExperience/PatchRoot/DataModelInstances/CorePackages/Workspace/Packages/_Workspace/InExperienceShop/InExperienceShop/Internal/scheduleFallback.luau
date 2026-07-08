local function scheduleFallback(n1: number, p1: ((...any) -> ...any)) -- line: 7
	local function guardedCallback() -- line: 11
		-- upvalues: p1 (copy)
		if not game:IsLoaded() then
			return
		end

		p1()
	end

	if game:IsLoaded() then
		task.delay(n1, guardedCallback)

		return
	end

	game.Loaded:Once(function() -- line: 26
		-- upvalues: n1 (copy), guardedCallback (copy)
		task.delay(n1, guardedCallback)
	end)
end

return scheduleFallback
