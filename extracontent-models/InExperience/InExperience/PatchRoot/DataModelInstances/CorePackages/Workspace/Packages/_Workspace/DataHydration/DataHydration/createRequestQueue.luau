local function createRequestQueue() -- line: 1
	local t1 = {}
	local n1 = 1

	return {
		push = function(s1: string) -- line: 8
			-- upvalues: t1 (copy), n1 (ref)
			if t1[s1] == nil then
				t1[s1] = n1
				n1 += 1
			end
		end,
		pop = function(n2: number) -- line: 15
			-- upvalues: t1 (copy)
			local t2 = {}

			for v7, _ in t1 do
				table.insert(t2, v7)
			end

			table.sort(t2, function(p1, p2) -- line: 20
				-- upvalues: t1 (copy)
				return t1[p1] < t1[p2]
			end)

			if n2 < #t2 then
				local t3 = {}

				for i = 1, n2 do
					local v11 = t2[i]

					table.insert(t3, v11)
					t1[v11] = nil
				end

				return t3
			end

			table.clear(t1)

			return t2
		end,
		isEmpty = function() -- line: 38
			-- upvalues: t1 (copy)
			for _, _ in t1 do
				return false
			end

			return true
		end,
		hasItem = function(s2: string) -- line: 45
			-- upvalues: t1 (copy)
			return t1[s2] ~= nil
		end,
		clear = function() -- line: 49
			-- upvalues: t1 (copy), n1 (ref)
			table.clear(t1)
			n1 = 1
		end
	}
end

return createRequestQueue
