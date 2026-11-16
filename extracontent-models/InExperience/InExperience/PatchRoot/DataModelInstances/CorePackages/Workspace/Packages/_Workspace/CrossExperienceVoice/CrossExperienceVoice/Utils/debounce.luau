return function(callback, p: number)
	local thread = nil
	local v = p / 1000
	return {
		cancel = function()
			if thread then
				task.cancel(thread)
				thread = nil
			end
		end,
		call = function(...)
			local v2 = { ... }
			thread = task.delay(v, function()
				callback(unpack(v2))
			end)
		end
	}
end
