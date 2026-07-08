local v1 = newproxy(false)

return function(p1) -- line: 10
	-- upvalues: v1 (copy)
	return {
		setTimeout = function(p2, n1: number?, ...) -- line: 11
			-- upvalues: v1 (copy), p1 (copy)
			local t1 = { ... }
			local t2 = {
				[v1] = 1
			}

			if n1 == nil then
				n1 = 0
			end

			local v7 = n1 / 1000

			p1(v7, function() -- line: 24
				-- upvalues: t2 (copy), v1 (copy), p2 (copy), t1 (copy)
				if t2[v1] == 1 then
					p2(unpack(t1))
					t2[v1] = 2
				end
			end)

			return t2
		end,
		clearTimeout = function(t3: {[any]: any}) -- line: 34
			-- upvalues: v1 (copy)
			if t3 == nil then
				return
			end

			if t3[v1] == 1 then
				t3[v1] = 3
			end
		end
	}
end
