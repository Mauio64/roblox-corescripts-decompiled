local t1 = {}

t1.__index = t1

function t1.new(p1, p2, ...) -- line: 51
	-- upvalues: t1 (copy)
	local t2 = {
		keys = {},
		values = {},
		getId = p1,
		sortPredicate = p2
	}

	setmetatable(t2, t1)
	t1._InsertInPlace(t2, ...)

	return t2
end
function t1.Get(p3, p4) -- line: 69
	return p3.values[p4]
end
function t1.GetByIndex(p5, p6) -- line: 76
	local v9 = p5.keys[p6]

	if v9 == nil then
		return nil
	end

	return p5.values[v9]
end
function t1.GetIds(p7) -- line: 89
	return p7.keys
end
function t1.Length(p8) -- line: 96
	return #p8.keys
end
function t1.Delete(p9, ...) -- line: 109
	-- upvalues: t1 (copy)
	local v13 = t1.new(p9.getId, p9.sortPredicate)
	local v14 = select("#", ...)

	for k, v in pairs(p9.values) do
		v13.values[k] = v
	end

	for i = 1, v14 do
		local v18 = select(i, ...)

		v13.values[v18] = nil
	end

	for _, v in ipairs(p9.keys) do
		if v13.values[v] ~= nil then
			v13.keys[#v13.keys + 1] = v
		end
	end

	return v13
end
function t1.Insert(p10, ...) -- line: 143
	-- upvalues: t1 (copy)
	local v22 = p10:_Copy()

	t1._InsertInPlace(v22, ...)

	return v22
end
function t1.First(p11) -- line: 154
	if p11.keys[1] then
		return p11:Get(p11.keys[1])
	end

	return nil
end
function t1.Last(p12) -- line: 164
	local v25 = #p12.keys

	if p12.keys[v25] then
		return p12:Get(p12.keys[v25])
	end

	return nil
end
function t1.CreateIterator(p13) -- line: 181
	local n1 = 0
	local v28 = #p13.keys

	return function() -- line: 186
		-- upvalues: n1 (ref), v28 (copy), p13 (copy)
		n1 += 1

		if n1 <= v28 then
			local v54 = p13.keys[n1]

			return v54, p13.values[v54], n1
		end

		return nil, nil, nil
	end
end
function t1.CreateReverseIterator(p14) -- line: 206
	local u30 = #p14.keys + 1

	return function() -- line: 210
		-- upvalues: u30 (ref), p14 (copy)
		u30 -= 1

		if u30 > 0 then
			local v55 = p14.keys[u30]

			return v55, p14.values[v55], u30
		end

		return nil, nil, nil
	end
end
function t1.Map(p15, p16) -- line: 233
	-- upvalues: t1 (copy)
	local v33 = t1.new(p15.getId, p15.sortPredicate)

	for v34, v35 in p15:CreateIterator() do
		v33:_InsertInPlaceUnsorted(p16(v35, v34))
	end

	v33:_Sort()

	return v33
end
function t1.Merge(p17, ...) -- line: 260
	local v37 = nil

	for i = 1, select("#", ...) do
		local v39 = select(i, ...)

		if v39:Length() > 0 then
			if not v37 then
				v37 = p17:_Copy()
			end

			for _, v41 in v39:CreateIterator() do
				v37:_InsertInPlaceUnsorted(v41)
			end
		end
	end

	if v37 then
		v37:_Sort()

		return v37
	end

	return p17
end
function t1._Copy(p18) -- line: 289
	-- upvalues: t1 (copy)
	local v43 = t1.new(p18.getId, p18.sortPredicate)

	for i, v in ipairs(p18.keys) do
		v43.keys[i] = v
	end

	for k, v in pairs(p18.values) do
		v43.values[k] = v
	end

	return v43
end
function t1._InsertInPlaceUnsorted(p19, ...) -- line: 309
	for i = 1, select("#", ...) do
		local v50 = select(i, ...)
		local v51 = p19.getId(v50)

		if not p19.values[v51] then
			table.insert(p19.keys, v51)
		end

		p19.values[v51] = v50
	end
end
function t1._Sort(p20) -- line: 328
	table.sort(p20.keys, function(p21, p22) -- line: 329
		-- upvalues: p20 (copy)
		local v58 = p20.values[p21]
		local v59 = p20.values[p22]

		return p20.sortPredicate(v58, v59)
	end)
end
function t1._InsertInPlace(p23, ...) -- line: 342
	p23:_InsertInPlaceUnsorted(...)
	p23:_Sort()
end

return t1
