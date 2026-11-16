local v = newproxy(false)

return function(callback)
	return {
		setTimeout = function(callback2, p: number?, ...)
			local v2 = { ... }
			local v3 = { [v] = 1 }

			callback((p == nil and 0 or p) / 1000, function()
				if v3[v] == 1 then
					callback2(unpack(v2))
					v3[v] = 2
				end
			end)

			return v3
		end,
		clearTimeout = function(p)
			if p == nil then
				return
			end

			if p[v] == 1 then
				p[v] = 3
			end
		end
	}
end
