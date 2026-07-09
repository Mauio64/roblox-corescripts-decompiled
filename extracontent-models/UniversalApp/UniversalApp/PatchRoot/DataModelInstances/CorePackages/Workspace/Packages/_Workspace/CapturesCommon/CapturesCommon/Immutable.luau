return {
	JoinDictionaries = function(...) -- line: 10
		local t1 = {}

		for i = 1, select("#", ...) do
			local v3 = select(i, ...)

			for k, v in pairs(v3) do
				t1[k] = v
			end
		end

		return t1
	end,
	JoinLists = function(...) -- line: 29
		local t2 = {}

		for i = 1, select("#", ...) do
			local v8 = select(i, ...)
			local v9 = #t2

			for j = 1, #v8 do
				t2[v9 + j] = v8[j]
			end
		end

		return t2
	end,
	Set = function(p1, p2, p3) -- line: 47
		local v14 = table.clone(p1)

		v14[p2] = p3

		return v14
	end,
	Append = function(p4, ...) -- line: 56
		local t3 = {}
		local v17 = #p4

		for i = 1, v17 do
			t3[i] = p4[i]
		end

		for i = 1, select("#", ...) do
			t3[v17 + i] = select(i, ...)
		end

		return t3
	end,
	RemoveFromDictionary = function(p5, ...) -- line: 74
		local t4 = {}

		for k, v in pairs(p5) do
			local v24 = false

			for i = 1, select("#", ...) do
				if k == select(i, ...) then
					v24 = true

					break
				end
			end

			if not v24 then
				t4[k] = v
			end
		end

		return t4
	end,
	RemoveFromList = function(p6, p7) -- line: 96
		local t5 = {}

		for i = 1, #p6 do
			if i ~= p7 then
				table.insert(t5, p6[i])
			end
		end

		return t5
	end,
	RemoveRangeFromList = function(p8, p9, p10) -- line: 111
		local t6 = {}

		for i = 1, #p8 do
			if i < p9 or i >= p9 + p10 then
				table.insert(t6, p8[i])
			end
		end

		return t6
	end,
	RemoveValueFromList = function(p11, p12) -- line: 126
		local t7 = {}

		for i = 1, #p11 do
			if p12 ~= p11[i] then
				table.insert(t7, p11[i])
			end
		end

		return t7
	end
}
