require("@luauforge/bundled/dFH")
local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/LuauPolyfill")
local array = LuauPolyfill.Array
local object = LuauPolyfill.Object

local v5 = {}

function v5.get(p2, p3)
	for k, route in p2.routes do
		if route.key == p3 then
			return route
		end
	end

	return nil
end

function v5.indexOf(p2, p3)
	for k, route in p2.routes do
		if route.key == p3 then
			return k
		end
	end

	return nil
end

function v5.has(p2, p3): boolean
	for k, route in p2.routes do
		if route.key == p3 then
			return true
		end
	end

	return false
end

function v5.push(p2, p3)
	assert(v5.indexOf(p2, p3.key) == nil, ("should not push route with duplicated key %s"):format(p3.key))

	local joined = array.concat(p2.routes, { p3 })
	return object.assign(table.clone(p2), {
		index = #joined,
		routes = joined
	})
end

function v5.pop(p2)
	if p2.index <= 1 then
		return p2
	end

	local clone = table.clone(p2.routes)
	table.remove(clone, #clone)
	return object.assign(table.clone(p2), {
		index = #clone,
		routes = clone
	})
end

function v5.jumpToIndex(p2, p3)
	if p3 == p2.index then
		return p2
	end

	assert(p2.routes[p3] ~= nil, ("invalid index %d to jump to"):format(p3))

	return object.assign(table.clone(p2), { index = p3 })
end

function v5.jumpTo(p2, p3)
	local index = v5.indexOf(p2, p3)
	assert(index ~= nil, ("attempt to jump to unknown key \"%s\""):format(p3))

	return v5.jumpToIndex(p2, index)
end

function v5.back(p2)
	local v6 = p2.index - 1

	if p2.routes[v6] then
		return v5.jumpToIndex(p2, v6)
	end

	return p2
end

function v5.forward(p2)
	local v6 = p2.index + 1

	if p2.routes[v6] then
		return v5.jumpToIndex(p2, v6)
	end

	return p2
end

function v5.replaceAndPrune(p2, p3, p4)
	local index = v5.indexOf(p2, p3)
	local v6 = v5.replaceAtIndex(p2, index, p4)

	return object.assign(table.clone(v6), {
		routes = { unpack(v6.routes, 1, index) }
	})
end

function v5.replaceAt(p2, p3, p4, p5)
	local index = v5.indexOf(p2, p3)
	local v6 = if p5 then p2.index else index
	local v7 = v5.replaceAtIndex(p2, index, p4)
	v7.index = v6
	return v7
end

function v5.replaceAtIndex(p2, p3, p4)
	assert(p2.routes[p3] ~= nil, ("invalid index %d for replacing route %s"):format(p3, p4.key))

	if p2.routes[p3] == p4 and p3 == p2.index then
		return p2
	end

	local clone = table.clone(p2.routes)
	clone[p3] = p4

	return object.assign(table.clone(p2), { index = p3, routes = clone })
end

function v5.reset(p2, list, p3)
	local v6 = type(list) == "table" and #list > 0
	assert(v6, "invalid routes to replace")

	local v7 = p3 or #list

	if #p2.routes == #list and p2.index == v7 then
		local flag = true

		for i = 1, #list do
			if p2.routes[i] ~= list[i] then
				flag = false
				break
			end
		end

		if flag then
			return p2
		end
	end

	assert(list[v7] ~= nil, ("invalid index %d to reset"):format(v7))

	return object.assign(table.clone(p2), { index = v7, routes = list })
end

return v5
