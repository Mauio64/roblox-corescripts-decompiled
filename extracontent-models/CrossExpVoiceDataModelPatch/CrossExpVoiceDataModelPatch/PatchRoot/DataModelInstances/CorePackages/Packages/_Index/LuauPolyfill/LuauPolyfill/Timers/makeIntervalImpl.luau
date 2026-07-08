local v1 = newproxy(false)

return function(p1) -- line: 9
	-- upvalues: v1 (copy)
	return {
		setInterval = function(p2, n1: number, ...) -- line: 10
			-- upvalues: v1 (copy), p1 (copy)
			local t1 = { ... }
			local t2 = {
				[v1] = 1
			}

			if n1 == nil then
				n1 = 0
			end

			local v7 = n1 / 1000

			local function u8() -- line: 24
				-- upvalues: p1 (copy), v7 (copy), t2 (copy), v1 (copy), p2 (copy), t1 (copy), u8 (ref)
				p1(v7, function() -- line: 25
					-- upvalues: t2 (copy), v1 (copy), p2 (copy), t1 (copy), u8 (ref)
					if t2[v1] == 1 then
						p2(unpack(t1))
						u8()
					end
				end)
			end

			u8()

			return t2
		end,
		clearInterval = function(t3: {[any]: any}) -- line: 38
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
