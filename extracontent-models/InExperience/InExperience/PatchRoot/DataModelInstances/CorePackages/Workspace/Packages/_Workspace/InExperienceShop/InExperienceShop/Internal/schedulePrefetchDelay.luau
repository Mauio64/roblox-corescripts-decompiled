local function schedulePrefetchDelay(duration: number, callback)
	local function guardedCallback()
		if not game:IsLoaded() then
			return
		end

		callback()
	end
	task.delay(duration, guardedCallback)
end

return schedulePrefetchDelay
