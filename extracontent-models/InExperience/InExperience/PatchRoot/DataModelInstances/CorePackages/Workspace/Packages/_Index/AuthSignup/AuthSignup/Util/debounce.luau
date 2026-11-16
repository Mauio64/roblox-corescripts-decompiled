return function(callback, duration: number?)
	local v = 0
	return function(...)
		local v2 = { ... }
		local v3 = time()
		v = v3
		task.delay(duration, function()
			if v == v3 then
				callback(unpack(v2))
			end
		end)
	end
end
