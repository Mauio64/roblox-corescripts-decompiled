local function scheduleFallback(duration: number, callback)
	local function guardedCallback()
		if not game:IsLoaded() then
			return
		end

		callback()
	end

	if game:IsLoaded() then
		task.delay(duration, guardedCallback)
	else
		game.Loaded:Once(function()
			task.delay(duration, guardedCallback)
		end)
	end
end

return scheduleFallback
