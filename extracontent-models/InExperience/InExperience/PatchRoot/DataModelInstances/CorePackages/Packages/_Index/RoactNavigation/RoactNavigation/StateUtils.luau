local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local t1 = {
	get = function(p1, p2) -- line: 31
		for _, v9 in p1.routes do
			if p2 == v9.key then
				return v9
			end
		end

		return nil
	end,
	indexOf = function(p3, p4) -- line: 42
		for v12, v13 in p3.routes do
			if p4 == v13.key then
				return v12
			end
		end

		return nil
	end,
	has = function(p5, p6) -- line: 54
		for _, v17 in p5.routes do
			if p6 == v17.key then
				return true
			end
		end

		return false
	end
}

function t1.push(p7, p8) -- line: 65
	-- upvalues: t1 (copy), Array (copy), Object (copy)
	assert(t1.indexOf(p7, p8.key) == nil, ("should not push route with duplicated key %s"):format(p8.key))

	local v20 = Array.concat(p7.routes, { p8 })

	return Object.assign(table.clone(p7), {
		index = #v20,
		routes = v20
	})
end
function t1.pop(p9) -- line: 80
	-- upvalues: Object (copy)
	if p9.index <= 1 then
		return p9
	end

	local v22 = table.clone(p9.routes)

	table.remove(v22, #v22)

	return Object.assign(table.clone(p9), {
		index = #v22,
		routes = v22
	})
end
function t1.jumpToIndex(p10, p11) -- line: 95
	-- upvalues: Object (copy)
	if p11 == p10.index then
		return p10
	end

	assert(p10.routes[p11] ~= nil, ("invalid index %d to jump to"):format(p11))

	return Object.assign(table.clone(p10), {
		index = p11
	})
end
function t1.jumpTo(p12, p13) -- line: 108
	-- upvalues: t1 (copy)
	local v27 = t1.indexOf(p12, p13)

	assert(v27 ~= nil, ("attempt to jump to unknown key \"%s\""):format(p13))

	return t1.jumpToIndex(p12, v27)
end
function t1.back(p14) -- line: 116
	-- upvalues: t1 (copy)
	local v29 = p14.index - 1

	if not p14.routes[v29] then
		return p14
	end

	return t1.jumpToIndex(p14, v29)
end
function t1.forward(p15) -- line: 126
	-- upvalues: t1 (copy)
	local v31 = p15.index + 1

	if not p15.routes[v31] then
		return p15
	end

	return t1.jumpToIndex(p15, v31)
end
function t1.replaceAndPrune(p16, p17, p18) -- line: 137
	-- upvalues: t1 (copy), Object (copy)
	local v35 = t1.indexOf(p16, p17)
	local v36 = t1.replaceAtIndex(p16, v35, p18)

	return Object.assign(table.clone(v36), {
		routes = { unpack(v36.routes, 1, v35) }
	})
end
function t1.replaceAt(p19, p20, p21, p22) -- line: 149
	-- upvalues: t1 (copy)
	local v41 = t1.indexOf(p19, p20)
	local v42 = if not p22 then v41 else p19.index
	local v43 = t1.replaceAtIndex(p19, v41, p21)

	v43.index = v42

	return v43
end
function t1.replaceAtIndex(p23, p24, p25) -- line: 159
	-- upvalues: Object (copy)
	assert(p23.routes[p24] ~= nil, ("invalid index %d for replacing route %s"):format(p24, p25.key))

	if p25 == p23.routes[p24] and p24 == p23.index then
		return p23
	end

	local v47 = table.clone(p23.routes)

	v47[p24] = p25

	return Object.assign(table.clone(p23), {
		index = p24,
		routes = v47
	})
end
function t1.reset(p26, p27, p28) -- line: 178
	-- upvalues: Object (copy)
	assert(type(p27) == "table" and #p27 > 0, "invalid routes to replace")

	local v51 = p28 or #p27

	if #p26.routes == #p27 and v51 == p26.index then
		local v52 = true

		for i = 1, #p27 do
			if p26.routes[i] ~= p27[i] then
				v52 = false

				break
			end
		end

		if v52 then
			return p26
		end
	end

	assert(p27[v51] ~= nil, ("invalid index %d to reset"):format(v51))

	return Object.assign(table.clone(p26), {
		index = v51,
		routes = p27
	})
end

return t1
