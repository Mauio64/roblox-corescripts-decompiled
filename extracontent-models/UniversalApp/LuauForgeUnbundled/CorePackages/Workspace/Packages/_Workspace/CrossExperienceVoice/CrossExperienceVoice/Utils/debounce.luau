return function(callback, p2)
	local thread = nil
	local v5 = p2 / 1000
	return {
		cancel = function()
			if thread then
				task.cancel(thread)
				thread = nil
			end
		end,
		call = function(...)
			local v6 = { ... }
			thread = task.delay(v5, function()
				callback(unpack(v6))
			end)
		end
	}
end
