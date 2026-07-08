local scriptParent = script.Parent
local isArray = require(scriptParent.Array.isArray)
local fromString = require(scriptParent.Array.from.fromString)
local forEach = require(scriptParent.Array.forEach)

require(scriptParent.types)

local inspect = require(scriptParent.util.inspect)
local t1 = {
	__iter = function(p1) -- line: 22
		return next, p1._array
	end,
	__tostring = function(p2) -- line: 25
		-- upvalues: inspect (copy)
		local s1 = "Set "

		if #p2._array > 0 then
			s1 ..= "(" .. tostring(#p2._array) .. ") "
		end

		return s1 .. inspect(p2._array)
	end
}

t1.__index = t1

function t1.new(p3) -- line: 37
	-- upvalues: isArray (copy), fromString (copy), t1 (copy)
	local t2 = {}
	local t3

	if p3 ~= nil then
		local v12 = nil

		if typeof(p3) == "table" then
			if isArray(p3) then
				v12 = table.clone(p3)
			else
				local mt = getmetatable(p3)

				if mt and rawget(mt, "__iter") then
					v12 = p3
				elseif _G.__DEV__ then
					error("cannot create array from an object-like table")
				end
			end
		elseif typeof(p3) == "string" then
			v12 = fromString(p3)
		else
			error(("cannot create array from value of type `%s`"):format((typeof(p3))))
		end

		if v12 then
			t3 = table.create(#v12)

			for _, v16 in v12 do
				if not t2[v16] then
					t2[v16] = true
					table.insert(t3, v16)
				end
			end
		else
			t3 = {}
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
function t1.add(p4, p5) -- line: 83
	if not p4._map[p5] then
		p4.size = p4.size + 1
		p4._map[p5] = true
		table.insert(p4._array, p5)
	end

	return p4
end
function t1.clear(p6) -- line: 93
	p6.size = 0
	table.clear(p6._map)
	table.clear(p6._array)
end
function t1.delete(p7, p8) -- line: 99
	if not p7._map[p8] then
		return false
	end

	p7.size = p7.size - 1
	p7._map[p8] = nil

	local v22 = table.find(p7._array, p8)

	if v22 then
		table.remove(p7._array, v22)
	end

	return true
end
function t1.forEach(p9, p10, p11) -- line: 115
	-- upvalues: forEach (copy)
	if typeof(p10) ~= "function" then
		error("callback is not a function")
	end

	forEach(p9._array, function(p12) -- line: 121
		-- upvalues: p11 (copy), p10 (copy), p9 (copy)
		if p11 ~= nil then
			p10(p11, p12, p12, p9)

			return
		end

		p10(p12, p12, p9)
	end)
end
function t1.has(p13, p14) -- line: 130
	return p13._map[p14] ~= nil
end
function t1.ipairs(p15) -- line: 134
	if _G.__DEV__ then
		warn(debug.traceback("`for _,_ in mySet:ipairs() do` is deprecated and will be removed in a future release, please use `for _,_ in mySet do` instead\n", 2))
	end

	return ipairs(p15._array)
end

return t1
