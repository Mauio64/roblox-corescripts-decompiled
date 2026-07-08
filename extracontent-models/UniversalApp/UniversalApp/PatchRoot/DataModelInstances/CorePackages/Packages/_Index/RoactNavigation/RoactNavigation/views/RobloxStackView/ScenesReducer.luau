local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local TableUtilities = require(ParentParent.utils.TableUtilities)
local invariant = require(ParentParent.utils.invariant)

local function compareScenes(p1, p2) -- line: 12
	if p1.index == p2.index then
		local v13 = #p1.key - #p2.key

		if v13 == 0 then
			return p1.key < p2.key
		end

		return v13 < 0
	end

	return p1.index < p2.index
end
local function routesAreShallowEqual(p3, p4) -- line: 27
	-- upvalues: TableUtilities (copy)
	if not p3 or not p4 then
		return p3 == p4
	end

	if p3.key ~= p4.key then
		return false
	end

	return TableUtilities.ShallowEqual(p3, p4)
end
local function scenesAreShallowEqual(p5, p6) -- line: 39
	-- upvalues: TableUtilities (copy)
	local v18 = false

	if p5.key == p6.key then
		v18 = false

		if p5.index == p6.index then
			v18 = false

			if p5.isStale == p6.isStale then
				v18 = false

				if p5.isActive == p6.isActive then
					if not p5 or not p6 then
						return p5 == p6
					end

					if p5.key ~= p6.key then
						return false
					end

					v18 = TableUtilities.ShallowEqual(p5, p6)
				end
			end
		end
	end

	return v18
end

return function(p7, p8, p9, p10) -- line: 48
	-- upvalues: Array (copy), invariant (copy), TableUtilities (copy), compareScenes (copy), Object (copy)
	for _, v24 in p7 do
		local route = v24.route

		if p10 and p10[route.key] then
			v24.descriptor = p10[route.key]
		end
	end

	if p9 == p8 then
		return p7
	end

	local t1 = {}
	local t2 = {}
	local t3 = {}

	for _, v30 in p7 do
		local key = v30.key

		if v30.isStale then
			t3[key] = v30
		end

		t1[key] = v30
	end

	local t4 = {}
	local routes = p8.routes

	if #routes > p8.index then
		print("Warning: StackRouter provided invalid state. Index should always be the top route")
		routes = Array.slice(routes, 1, p8.index)
	end

	for v34, v35 in routes do
		local v36 = "scene_" .. v35.key
		local v37 = if not p10 then nil else p10[v35.key]
		local t5 = {
			isActive = false,
			isStale = false,
			index = v34,
			key = v36,
			route = v35,
			descriptor = v37
		}

		invariant(not t4[v36], "navigation.state.routes[%d].key '%s' conflicts with another route!", v34, v36)
		t4[v36] = true

		if t3[v36] then
			t3[v36] = nil
		end

		t2[v36] = t5
	end

	if p9 then
		local routes2 = p9.routes

		if #routes2 > p9.index then
			print("StackRouter provided invalid state. Index should always be the top route.")
			routes2 = Array.slice(routes2, 1, p9.index)
		end

		for v40, v41 in routes2 do
			local v42 = "scene_" .. v41.key

			if not t2[v42] then
				local v43 = nil

				for _, v45 in p7 do
					if v45.route.key == v41.key then
						v43 = v45

						break
					end
				end

				local v46 = p10[v41.key]

				if v43 then
					v46 = v43.descriptor
				end

				if v46 then
					t3[v42] = {
						isActive = false,
						isStale = true,
						index = v40,
						key = v42,
						route = v41,
						descriptor = v46
					}
				end
			end
		end
	end

	local t6 = {}

	local function mergeScene(p11) -- line: 155
		-- upvalues: t1 (copy), TableUtilities (copy), t6 (copy)
		local v63 = t1[p11.key] or nil

		if v63 and (v63.key == p11.key and (v63.index == p11.index and (v63.isStale == p11.isStale and v63.isActive == p11.isActive)) and if not not v63 and p11 then v63.key == p11.key and TableUtilities.ShallowEqual(v63, p11) else v63 == p11) then
			table.insert(t6, v63)

			return
		end

		table.insert(t6, p11)
	end

	for _, v50 in t3 do
		local v51 = t1[v50.key] or nil

		if v51 and (v51.key == v50.key and (v51.index == v50.index and (v51.isStale == v50.isStale and v51.isActive == v50.isActive)) and if not not v51 and v50 then v51.key == v50.key and TableUtilities.ShallowEqual(v51, v50) else v51 == v50) then
			table.insert(t6, v51)
		else
			table.insert(t6, v50)
		end
	end

	for _, v53 in t2 do
		local v54 = t1[v53.key] or nil

		if v54 and (v54.key == v53.key and (v54.index == v53.index and (v54.isStale == v53.isStale and v54.isActive == v53.isActive)) and if not not v54 and v53 then v54.key == v53.key and TableUtilities.ShallowEqual(v54, v53) else v54 == v53) then
			table.insert(t6, v54)
		else
			table.insert(t6, v53)
		end
	end

	table.sort(t6, compareScenes)

	local n1 = 0

	for v56, v57 in t6 do
		local v58 = not v57.isStale and v57.index == p8.index

		if v58 ~= v57.isActive then
			t6[v56] = Object.assign(table.clone(v57), {
				isActive = v58
			})
		end

		if v58 then
			n1 += 1
		end
	end

	invariant(n1 == 1, "There should only be one active scene, not %d", n1)

	if #t6 ~= #p7 then
		return t6
	end

	for v59, v60 in t6 do
		local v61 = p7[v59]

		if v61.key ~= v60.key or (v61.index ~= v60.index or (v61.isStale ~= v60.isStale or v61.isActive ~= v60.isActive)) or not if not not v61 and v60 then v61.key == v60.key and TableUtilities.ShallowEqual(v61, v60) else v61 == v60 then
			return t6
		end
	end

	return p7
end
