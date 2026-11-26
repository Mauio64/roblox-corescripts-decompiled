return function(callback, value)
	local thread = nil
	local v5 = value or 0.5

	return function(...)
		local v6 = { ... }

		if thread then
			task.cancel(thread)
		end

		thread = task.delay(v5, function()
			callback(unpack(v6))
			thread = nil
		end)
	end
end
