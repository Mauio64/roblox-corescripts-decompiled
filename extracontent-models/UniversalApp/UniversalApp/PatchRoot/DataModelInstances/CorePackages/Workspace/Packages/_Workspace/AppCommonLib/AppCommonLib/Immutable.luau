local v1 = game:DefineFastFlag("ImmutableJoinDictionariesUseTableClone", false)

return {
	JoinDictionaries = function(...) -- line: 12
		-- upvalues: v1 (copy)
		local v2 = select("#", ...)

		if v1 and v2 > 0 then
			local v3 = table.clone(select(1, ...))

			for i = 2, v2 do
				for v5, v6 in (select(i, ...)) do
					v3[v5] = v6
				end
			end

			return v3
		end

		local t1 = {}

		for i = 1, v2 do
			local v9 = select(i, ...)

			for k, v in pairs(v9) do
				t1[k] = v
			end
		end

		return t1
	end,
	JoinLists = function(...) -- line: 44
		local t2 = {}

		for i = 1, select("#", ...) do
			local v14 = select(i, ...)
			local v15 = #t2

			for j = 1, #v14 do
				t2[v15 + j] = v14[j]
			end
		end

		return t2
	end,
	Set = function(p1, p2, p3) -- line: 62
		local v20 = table.clone(p1)

		v20[p2] = p3

		return v20
	end,
	Append = function(p4, ...) -- line: 71
		local t3 = {}
		local v23 = #p4

		for i = 1, v23 do
			t3[i] = p4[i]
		end

		for i = 1, select("#", ...) do
			t3[v23 + i] = select(i, ...)
		end

		return t3
	end,
	RemoveFromDictionary = function(p5, ...) -- line: 89
		local t4 = {}

		for k, v in pairs(p5) do
			local v30 = false

			for i = 1, select("#", ...) do
				if k == select(i, ...) then
					v30 = true

					break
				end
			end

			if not v30 then
				t4[k] = v
			end
		end

		return t4
	end,
	RemoveFromList = function(p6, p7) -- line: 111
		local t5 = {}

		for i = 1, #p6 do
			if i ~= p7 then
				table.insert(t5, p6[i])
			end
		end

		return t5
	end,
	RemoveRangeFromList = function(p8, p9, p10) -- line: 126
		local t6 = {}

		for i = 1, #p8 do
			if i < p9 or i >= p9 + p10 then
				table.insert(t6, p8[i])
			end
		end

		return t6
	end,
	RemoveValueFromList = function(p11, p12) -- line: 141
		local t7 = {}

		for i = 1, #p11 do
			if p12 ~= p11[i] then
				table.insert(t7, p11[i])
			end
		end

		return t7
	end
}
