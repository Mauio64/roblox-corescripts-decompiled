local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local StateUtils = {}

function StateUtils.get(p, p2)
	for _, route in p.routes do
		if route.key == p2 then
			return route
		end
	end

	return nil
end

function StateUtils.indexOf(p, p2)
	for k, route in p.routes do
		if route.key == p2 then
			return k
		end
	end

	return nil
end

function StateUtils.has(p, p2): boolean
	for _, route in p.routes do
		if route.key == p2 then
			return true
		end
	end

	return false
end

function StateUtils.push(p, p2)
	assert(StateUtils.indexOf(p, p2.key) == nil, ("should not push route with duplicated key %s"):format(p2.key))

	local joined = Array.concat(p.routes, { p2 })
	return Object.assign(table.clone(p), {
		index = #joined,
		routes = joined
	})
end

function StateUtils.pop(p)
	if p.index <= 1 then
		return p
	end

	local clone = table.clone(p.routes)
	table.remove(clone, #clone)
	return Object.assign(table.clone(p), {
		index = #clone,
		routes = clone
	})
end

function StateUtils.jumpToIndex(p, p2)
	if p2 == p.index then
		return p
	end

	assert(p.routes[p2] ~= nil, ("invalid index %d to jump to"):format(p2))

	return Object.assign(table.clone(p), { index = p2 })
end

function StateUtils.jumpTo(p, p2)
	local index = StateUtils.indexOf(p, p2)
	assert(index ~= nil, ("attempt to jump to unknown key \"%s\""):format(p2))

	return StateUtils.jumpToIndex(p, index)
end

function StateUtils.back(p)
	local v = p.index - 1

	if p.routes[v] then
		return StateUtils.jumpToIndex(p, v)
	end

	return p
end

function StateUtils.forward(p)
	local v = p.index + 1

	if p.routes[v] then
		return StateUtils.jumpToIndex(p, v)
	end

	return p
end

function StateUtils.replaceAndPrune(p, p2, p3)
	local index = StateUtils.indexOf(p, p2)
	local v = StateUtils.replaceAtIndex(p, index, p3)

	return Object.assign(table.clone(v), {
		routes = { unpack(v.routes, 1, index) }
	})
end

function StateUtils.replaceAt(p, p2, p3, p4)
	local index = StateUtils.indexOf(p, p2)
	local v = if p4 then p.index else index
	local v2 = StateUtils.replaceAtIndex(p, index, p3)
	v2.index = v
	return v2
end

function StateUtils.replaceAtIndex(p, p2, p3)
	assert(p.routes[p2] ~= nil, ("invalid index %d for replacing route %s"):format(p2, p3.key))

	if p.routes[p2] == p3 and p2 == p.index then
		return p
	end

	local clone = table.clone(p.routes)
	clone[p2] = p3

	return Object.assign(table.clone(p), { index = p2, routes = clone })
end

function StateUtils.reset(p, routes, p2)
	local v = type(routes) == "table" and #routes > 0
	assert(v, "invalid routes to replace")

	local v2 = p2 or #routes

	if #p.routes == #routes and p.index == v2 then
		local flag = true

		for i = 1, #routes do
			if p.routes[i] ~= routes[i] then
				flag = false
				break
			end
		end

		if flag then
			return p
		end
	end

	assert(routes[v2] ~= nil, ("invalid index %d to reset"):format(v2))

	return Object.assign(table.clone(p), { index = v2, routes = routes })
end

return StateUtils
