local Flags = require(script:FindFirstAncestor("ViewRecycler").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local Flags2 = require(script:FindFirstAncestor("ViewRecycler").Flags)
local FFlagViewRecyclerReact08 = Flags2.FFlagViewRecyclerReact08
local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

require(ViewRecycler.Core.Recycling.RecyclingScope)

local frozen = table.freeze({})

local frozen2 = table.freeze({ entered = frozen, updated = frozen, departed = frozen })

local function createSlotBinder(data)
	local recyclingScope = data.recyclingScope
	local prepareDesiredAssignment = data.prepareDesiredAssignment
	local name

	if FFlagViewRecyclerReact084 then
		name = data.name or "SlotBinder"
	else
		name = FFlagViewRecyclerReact08 and (data.name or "SlotBinder") or nil
	end

	local v = {}
	local v2 = {}
	local flag = false

	local set = {}
	local set2 = {}
	local set3 = {}
	local makeAssignment

	if FFlagViewRecyclerReact084 then
		makeAssignment = function(p)
			if prepareDesiredAssignment == nil then
				return table.freeze({ key = p.key, value = p.value })
			end

			local v3 = prepareDesiredAssignment(p)
			return table.freeze({ key = v3.key, value = v3.value })
		end
	elseif FFlagViewRecyclerReact08 then
		makeAssignment = function(p)
			if prepareDesiredAssignment == nil then
				return table.freeze({ key = p.key, value = p.value })
			end

			local v3 = prepareDesiredAssignment(p)
			return table.freeze({ key = v3.key, value = v3.value })
		end
	else
		makeAssignment = function(p: string, p2)
			if prepareDesiredAssignment == nil then
				return table.freeze({ key = p, value = p2 })
			end

			local v3 = prepareDesiredAssignment({ key = p, value = p2 })
			return table.freeze({ key = v3.key, value = v3.value })
		end
	end

	local function requestFor(viewType) -- 1 equivalent call inferred from this helper
		local v3 = v2[viewType]

		if v3 == nil then
			v3 = table.freeze({ viewType = viewType })
			v2[viewType] = v3
		end

		return v3
	end

	local function apply(items, list)
		assert(not flag, "SlotBinder: cannot apply after destruction")
		local views = {}
		local flag2 = false

		for _, item in items do
			local v3 = v[item]

			if v3 == nil then
				continue
			end

			table.insert(views, v3.view)
			set[item] = true
			flag2 = true
		end

		local v3 = #list > 1
		local v4 = nil
		local entered = {}
		local requests = {}

		for _, item in list do
			local key = item.key

			if v3 then
				if set2[key] then
					table.clear(set2)
					table.clear(set)
					local v5

					if FFlagViewRecyclerReact084 then
						v5 = `{name}: duplicate key "{key}"`
					elseif FFlagViewRecyclerReact08 then
						v5 = `{name}: duplicate key "{key}"`
					else
						v5 = `Virtualizer: duplicate key "{key}"`
					end

					error(v5, 0)
				end

				set2[key] = true
			end

			local v5 = v[key]
			local v6

			if v5 == nil then
				v6 = false
			else
				v6 = not (flag2 and set[key])
			end

			if v6 and v5.viewType == item.viewType then
				if item.changed or v5.value ~= item.value then
					v4 = v4 or {}
					table.insert(v4, item)
				end
			else
				if v6 then
					table.insert(views, v5.view)
				end

				table.insert(entered, item)
				table.insert(requests, requestFor(item.viewType)) -- inferred equivalent call
			end
		end

		if v3 then
			table.clear(set2)
		end

		if #views == 0 and #requests == 0 and v4 == nil then
			return frozen2
		end

		local v5 = frozen

		if #views > 0 or #requests > 0 then
			local success, result = pcall(recyclingScope.bind, {
				releases = views,
				requests = requests
			})

			if not success then
				table.clear(set)
				error(result, 0)
			end

			v5 = result.acquired
		end

		if flag2 then
			for k in set do
				v[k] = nil
			end

			table.clear(set)
		end

		local v6

		if #views > 0 then
			v6 = #entered > 0
		else
			v6 = false
		end

		for k, v7 in entered do
			local view = v5[k]

			v7.view = view

			if FFlagViewRecyclerReact084 then
				v7.assignment = makeAssignment(v7)
			elseif FFlagViewRecyclerReact08 then
				v7.assignment = makeAssignment(v7)
			else
				v7.assignment = makeAssignment(v7.key, v7.value)
			end

			v[v7.key] = v7

			if v6 then
				set3[view] = true
			end
		end

		local updated = frozen

		if v4 ~= nil then
			updated = table.create(#v4)

			for k, v7 in v4 do
				local v8 = v[v7.key]
				v8.value = v7.value

				if FFlagViewRecyclerReact084 then
					v8.assignment = makeAssignment(v7)
				elseif FFlagViewRecyclerReact08 then
					v8.assignment = makeAssignment(v7)
				else
					v8.assignment = makeAssignment(v7.key, v7.value)
				end

				updated[k] = v8
			end
		end

		local departed = frozen

		if #views > 0 then
			if v6 then
				departed = {}

				for _, v7 in views do
					if not set3[v7] then
						table.insert(departed, v7)
					end
				end

				table.clear(set3)
			else
				departed = views
			end
		end

		if #entered == 0 then
			entered = frozen
		end

		return { entered = entered, updated = updated, departed = departed }
	end

	local function releaseAll()
		local views = {}

		for _, v3 in v do
			table.insert(views, v3.view)
		end

		table.clear(v)

		if #views > 0 then
			recyclingScope.bind({ releases = views, requests = {} })
		end

		return views
	end

	return {
		apply = apply,
		sync = function(items)
			local set4 = {}

			for _, item in items do
				set4[item.key] = true
			end

			local v3 = {}

			for k in v do
				if not set4[k] then
					table.insert(v3, k)
				end
			end

			return apply(v3, items)
		end,
		get = function(p)
			return v[p]
		end,
		releaseAll = function()
			assert(not flag, "SlotBinder: cannot release after destruction")
			return releaseAll()
		end,
		destroy = function()
			if flag then
				return
			end

			releaseAll()
			flag = true
		end
	}
end

return createSlotBinder
