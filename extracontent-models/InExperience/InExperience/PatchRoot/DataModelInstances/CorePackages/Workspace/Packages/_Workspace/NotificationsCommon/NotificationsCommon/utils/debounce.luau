return function(callback, value: number?)
	local thread = nil
	local v = value or 0.5

	return function(...)
		local v2 = { ... }

		if thread then
			task.cancel(thread)
		end

		thread = task.delay(v, function()
			callback(unpack(v2))
			thread = nil
		end)
	end
end
