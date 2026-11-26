return function(callback, p2)
	local v5 = 0
	return function(...)
		local v6 = { ... }
		local v7 = time()
		v5 = v7
		delay(p2, function()
			if v5 == v7 then
				callback(unpack(v6))
			end
		end)
	end
end
