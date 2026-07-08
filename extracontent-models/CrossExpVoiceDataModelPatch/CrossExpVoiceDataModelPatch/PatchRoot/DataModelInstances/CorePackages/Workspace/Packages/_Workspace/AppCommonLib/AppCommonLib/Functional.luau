return {
	Filter = function(p1, p2) -- line: 11
		local t1 = {}

		for i = 1, #p1 do
			local v5 = p1[i]

			if p2(v5, i) then
				table.insert(t1, v5)
			end
		end

		return t1
	end,
	Map = function(p3, p4) -- line: 27
		local t2 = {}

		for i = 1, #p3 do
			t2[i] = p4(p3[i], i)
		end

		return t2
	end,
	MapReverse = function(p5, p6) -- line: 40
		local t3 = {}

		for i = #p5, 1, -1 do
			t3[i] = p6(p5[i], i)
		end

		return t3
	end,
	FilterMap = function(p7, p8) -- line: 56
		local t4 = {}

		for i = 1, #p7 do
			local v18 = p8(p7[i], i)

			if v18 ~= nil then
				table.insert(t4, v18)
			end
		end

		return t4
	end,
	Fold = function(p9, p10, p11) -- line: 74
		for i = 1, #p9 do
			p10 = p11(p10, p9[i], i)
		end

		return p10
	end,
	FoldDictionary = function(p12, p13, p14) -- line: 87
		for k, v in pairs(p12) do
			p13 = p14(p13, k, v)
		end

		return p13
	end,
	Take = function(p15, p16, p17) -- line: 100
		local v31 = p17 or 1
		local v32 = p16 + (v31 - 1)

		if v32 > #p15 then
			v32 = #p15
		end

		local t5 = {}

		for i = v31, v32 do
			local v35 = p15[i]

			t5[i - (v31 - 1)] = v35
		end

		return t5
	end,
	Find = function(p18, p19) -- line: 122
		for i, v in ipairs(p18) do
			if v == p19 then
				return i
			end
		end

		return nil
	end
}
