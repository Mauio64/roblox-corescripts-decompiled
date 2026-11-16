local v = newproxy(false)

return function(callback)
	return {
		setInterval = function(callback2, p: number, ...)
			local v2 = { ... }
			local v3 = { [v] = 1 }

			local v4 = (p == nil and 0 or p) / 1000
			local function fn()
				callback(v4, function()
					if v3[v] == 1 then
						callback2(unpack(v2))
						fn()
					end
				end)
			end

			fn()

			return v3
		end,
		clearInterval = function(p)
			if p[v] == 1 then
				p[v] = 3
			end
		end
	}
end
