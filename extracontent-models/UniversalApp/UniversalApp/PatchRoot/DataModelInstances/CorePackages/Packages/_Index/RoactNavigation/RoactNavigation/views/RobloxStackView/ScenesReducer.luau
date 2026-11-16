local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local TableUtilities = require(parent.utils.TableUtilities)
local invariant = require(parent.utils.invariant)

local function compareScenes(p, p2): boolean
	if p.index ~= p2.index then
		return p.index < p2.index
	end

	local v = #p.key - #p2.key

	if v == 0 then
		return p.key < p2.key
	end

	return v < 0
end

local function routesAreShallowEqual(p, p2)
	if p and p2 then
		if p.key == p2.key then
			return TableUtilities.ShallowEqual(p, p2)
		end

		return false
	end

	return p == p2
end

local function scenesAreShallowEqual(data, data2) -- 4 equivalent calls inferred from this helper
	local _

	if
		data.key ~= data2.key
		or data.index ~= data2.index
		or data.isStale ~= data2.isStale
		or data.isActive ~= data2.isActive
	then
		_ = false
		return false
	end

	if not (data and data2) then
		return data == data2
	end

	return data.key == data2.key and TableUtilities.ShallowEqual(data, data2)
end

return function(list, p, p2, p3)
	for _, item in list do
		local route = item.route

		if p3 and p3[route.key] then
			item.descriptor = p3[route.key]
		end
	end

	if p2 == p then
		return list
	end

	local v = {}
	local v2 = {}
	local v3 = {}

	for _, item in list do
		local key = item.key

		if item.isStale then
			v[key] = item
		end

		v2[key] = item
	end

	local set = {}
	local routes = p.routes

	if #routes > p.index then
		print("Warning: StackRouter provided invalid state. Index should always be the top route")
		routes = Array.slice(routes, 1, p.index)
	end

	for k, route in routes do
		local v4 = "scene_" .. route.key
		local descriptor

		if p3 then
			descriptor = p3[route.key]
		end

		invariant(not set[v4], "navigation.state.routes[%d].key '%s' conflicts with another route!", k, v4)
		set[v4] = true

		if v[v4] then
			v[v4] = nil
		end

		v3[v4] = {
			index = k,
			isActive = false,
			isStale = false,
			key = v4,
			route = route,
			descriptor = descriptor
		}
	end

	if p2 then
		local routes2 = p2.routes

		if #routes2 > p2.index then
			print("StackRouter provided invalid state. Index should always be the top route.")
			routes2 = Array.slice(routes2, 1, p2.index)
		end

		for k, route in routes2 do
			local v4 = "scene_" .. route.key

			if v3[v4] then
				continue
			end

			local v5 = nil

			for _, item in list do
				if item.route.key == route.key then
					v5 = item
					break
				end
			end

			local descriptor = p3[route.key]

			if v5 then
				descriptor = v5.descriptor
			end

			if descriptor then
				v[v4] = {
					index = k,
					isActive = false,
					isStale = true,
					key = v4,
					route = route,
					descriptor = descriptor
				}
			end
		end
	end

	local result = {}

	local function mergeScene(data)
		local v4 = v2[data.key] or nil

		if v4 and scenesAreShallowEqual(v4, data) then -- inferred equivalent call
			table.insert(result, v4)
			return
		end

		table.insert(result, data)
	end

	for _, v4 in v do
		local v5 = v2[v4.key] or nil

		if v5 and scenesAreShallowEqual(v5, v4) then -- inferred equivalent call
			table.insert(result, v5)
			continue
		end

		table.insert(result, v4)
	end

	for _, v4 in v3 do
		local v5 = v2[v4.key] or nil

		if v5 and scenesAreShallowEqual(v5, v4) then -- inferred equivalent call
			table.insert(result, v5)
			continue
		end

		table.insert(result, v4)
	end

	table.sort(result, compareScenes)
	local count = 0

	for k, v4 in result do
		local isActive = not v4.isStale and v4.index == p.index

		if isActive ~= v4.isActive then
			result[k] = Object.assign(table.clone(v4), { isActive = isActive })
		end

		if isActive then
			count += 1
		end
	end

	invariant(count == 1, "There should only be one active scene, not %d", count)

	if #result ~= #list then
		return result
	end

	for k, v4 in result do
		if not scenesAreShallowEqual(list[k], v4) then -- inferred equivalent call
			return result
		end
	end

	return list
end
