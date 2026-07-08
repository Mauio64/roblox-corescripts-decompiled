local scriptParent = script.Parent
local forEach = require(scriptParent.Array.forEach)
local map = require(scriptParent.Array.map)

require(scriptParent.types)

local t1 = {}

function t1.new(p1) -- line: 20
	-- upvalues: t1 (copy)
	local t2 = {}
	local t3

	if p1 ~= nil then
		if _G.__DEV__ then
			local v7 = typeof(p1)

			if v7 == "table" then
				if #p1 > 0 and typeof(p1[1]) ~= "table" then
					error("cannot create Map from {K, V} form, it must be { {K, V}... }")
				end
			else
				error(("cannot create array from value of type `%s`"):format(v7))
			end
		end

		local v8 = table.clone(p1)

		t3 = table.create(#v8)

		for _, v11 in v8 do
			local v12 = v11[1]

			if _G.__DEV__ and v12 == nil then
				error("cannot create Map from a table that isn't an array.")
			end

			local v13 = v11[2]

			if t2[v12] == nil then
				table.insert(t3, v12)
			end

			t2[v12] = v13
		end
	else
		t3 = {}
	end

	return (setmetatable({
		size = #t3,
		_map = t2,
		_array = t3
	}, t1))
end
function t1.set(p2, p3, p4) -- line: 64
	if p2._map[p3] == nil then
		p2.size = p2.size + 1
		table.insert(p2._array, p3)
	end

	p2._map[p3] = p4

	return p2
end
function t1.get(p5, p6) -- line: 76
	return p5._map[p6]
end
function t1.clear(p7) -- line: 80
	local _table = table

	p7.size = 0
	_table.clear(p7._map)
	_table.clear(p7._array)
end
function t1.delete(p8, p9) -- line: 87
	if p8._map[p9] == nil then
		return false
	end

	p8.size = p8.size - 1
	p8._map[p9] = nil

	local v23 = table.find(p8._array, p9)

	if v23 then
		table.remove(p8._array, v23)
	end

	return true
end
function t1.forEach(p10, p11, p12) -- line: 103
	-- upvalues: forEach (copy)
	if _G.__DEV__ and typeof(p11) ~= "function" then
		error("callback is not a function")
	end

	forEach(p10._array, function(p13) -- line: 110
		-- upvalues: p10 (copy), p12 (copy), p11 (copy)
		local v41 = p10._map[p13]

		if p12 ~= nil then
			p11(p12, v41, p13, p10)

			return
		end

		p11(v41, p13, p10)
	end)
end
function t1.has(p14, p15) -- line: 121
	return p14._map[p15] ~= nil
end
function t1.keys(p16) -- line: 125
	return p16._array
end
function t1.values(p17) -- line: 129
	-- upvalues: map (copy)
	return map(p17._array, function(p18) -- line: 130
		-- upvalues: p17 (copy)
		return p17._map[p18]
	end)
end
function t1.entries(p19) -- line: 135
	-- upvalues: map (copy)
	return map(p19._array, function(p20) -- line: 136
		-- upvalues: p19 (copy)
		return {
			p20,
			p19._map[p20]
		}
	end)
end
function t1.ipairs(p21) -- line: 141
	if _G.__DEV__ then
		warn(debug.traceback("`for _,_ in myMap:ipairs() do` is deprecated and will be removed in a future release, please use `for _,_ in myMap do` instead\n", 2))
	end

	return ipairs(p21:entries())
end
function t1.__iter(p22) -- line: 153
	return next, p22:entries()
end
function t1.__index(p23, p24) -- line: 157
	-- upvalues: t1 (copy)
	local v36 = rawget(t1, p24)

	if v36 ~= nil then
		return v36
	end

	return t1.get(p23, p24)
end
function t1.__newindex(p25, p26, p27) -- line: 166
	p25:set(p26, p27)
end

return t1
