local function getEventManager(p1) -- line: 3
	local t1 = {}

	local function removeListener(p2, p3) -- line: 6
		-- upvalues: t1 (copy), p1 (copy)
		local v7 = t1[p2]
		local v8 = if not v7 then nil else v7[p1]

		if not v8 then
			return
		end

		local v9 = table.find(v8, p3)

		table.remove(v8, v9)
	end

	return {
		addListener = function(p4, p5) -- line: 18
			-- upvalues: t1 (copy), p1 (copy)
			t1[p4] = t1[p4] or {}
			t1[p4][p1] = t1[p4][p1] or {}
			table.insert(t1[p4][p1], p5)

			return {
				remove = function() -- line: 25
					-- upvalues: p4 (copy), p5 (copy), t1 (copy), p1 (copy)
					local v18 = p4
					local v19 = p5
					local v20 = t1[v18]
					local v21 = if not v20 then nil else v20[p1]

					if not v21 then
						return
					end

					local v22 = table.find(v21, v19)

					table.remove(v21, v22)
				end
			}
		end,
		emit = function(p6, p7) -- line: 33
			-- upvalues: t1 (copy), p1 (copy)
			local v14 = t1[p6] or {}
			local v15 = if not v14[p1] then nil else table.clone(v14[p1])

			if v15 then
				for _, v17 in v15 do
					v17(p7)
				end
			end
		end
	}
end

return getEventManager
