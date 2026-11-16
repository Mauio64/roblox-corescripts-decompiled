local Flags = require(script:FindFirstAncestor("ViewRecycler").Flags)
local FFlagViewRecyclerReact08 = Flags.FFlagViewRecyclerReact08
local ViewRecycler = script:FindFirstAncestor("ViewRecycler")
local Diagnostics = require(ViewRecycler.Core.Diagnostics)
local frozen = table.freeze({})

local function validCapacity(capacity: number?): boolean -- 1 equivalent call inferred from this helper
	if capacity == nil then
		return true
	elseif capacity >= 0 then
		return capacity % 1 == 0
	else
		return false
	end
end

local function appendChange(list, p, viewType, p2, p3, p4) -- 9 equivalent calls inferred from this helper
	table.insert(list, { p, viewType, p2, p3, p4 })
end

local function createRecyclingScope(p)
	local adapter = p.adapter
	local v = {}
	local v2 = {}
	local flag = false
	local v3 = false
	local batch = adapter.batch or function(callback)
		callback()
	end

	local function poolFor(viewType)
		local v4 = v[viewType]

		if v4 == nil then
			v4 = { viewType = viewType, items = {}, first = 1, last = 0 }
			v[viewType] = v4
		end

		return v4
	end

	local function forget(p2) -- 2 equivalent calls inferred from this helper
		v2[p2] = nil
	end

	local function notify(action, viewType, occupiedDelta, vacantDelta, totalDelta)
		if p.onPoolChanged ~= nil then
			p.onPoolChanged({
				action = action,
				viewType = viewType,
				occupiedDelta = occupiedDelta,
				vacantDelta = vacantDelta,
				totalDelta = totalDelta
			})
		end
	end

	local function finalize(list, list2, list3, flag2: boolean?)
		if
			(list == nil or #list == 0)
			and #list2 == 0
			and (list3 == nil or #list3 == 0 or adapter.onCreated == nil)
		then
			return true, nil
		end

		local v4 = nil
		local function captureFailure(success: boolean, result) -- 4 equivalent calls inferred from this helper
			if not success and v4 == nil then
				v4 = result
			end
		end
		local v5 = table.pack(pcall(batch, function()
			if list ~= nil then
				for _, item in list do
					local success, result = pcall(notify, item[1], item[2], item[3], item[4], item[5])
					captureFailure(success, result) -- inferred equivalent call
				end
			end

			if flag2 ~= false and #list2 > 0 and adapter.onEvicted ~= nil then
				local success, result = pcall(adapter.onEvicted, list2)
				captureFailure(success, result) -- inferred equivalent call
			end

			for _, item in list2 do
				local success, result = pcall(adapter.destroy, item)
				captureFailure(success, result) -- inferred equivalent call
			end

			if list3 ~= nil and #list3 > 0 and adapter.onCreated ~= nil then
				local success, result = pcall(adapter.onCreated, list3)
				captureFailure(success, result) -- inferred equivalent call
			end

			if v4 ~= nil then
				error(v4, 0)
			end
		end))
		return v5[1], v5[2]
	end

	local function trimPoolExcess(state, capacity: number, list, list2)
		while capacity < state.last - state.first + 1 do
			local item = state.items[state.first]
			state.items[state.first] = nil
			state.first += 1
			forget(item) -- inferred equivalent call
			table.insert(list, item)

			if list2 ~= nil then
				appendChange(list2, Diagnostics.PoolAction.Evict, state.viewType, 0, -1, -1) -- inferred equivalent call
			end
		end
	end

	local function uniformDirectReuse(releases, requests)
		local count = #releases

		if count == 0 or count ~= #requests then
			return nil
		end

		local viewType = requests[1].viewType

		for i = 2, count do
			if requests[i].viewType ~= viewType then
				return nil
			end
		end

		for k, item in releases do
			local v4 = v2[item]

			if v4 == nil or not v4.active then
				error("RecyclingScope: can only release an active view", 3)
			end

			if v4.viewType ~= viewType then
				return nil
			end

			for i = 1, k - 1 do
				if releases[i] == item then
					error("RecyclingScope: cannot release one view more than once", 3)
				end
			end
		end

		local acquired = table.create(count)

		for i = 1, count do
			acquired[i] = releases[count - i + 1]
		end

		return { acquired = acquired, releasedCount = 0 }
	end

	local set = {}
	local v4 = {}

	local function exchangeWithoutCreation(releases, requests, list)
		if #requests == 0 then
			for _, item in releases do
				local v5 = v2[item]

				if v5 == nil or not v5.active then
					table.clear(set)
					error("RecyclingScope: can only release an active view", 3)
				end

				if set[item] then
					table.clear(set)
					error("RecyclingScope: cannot release one view more than once", 3)
				end

				set[item] = true
			end

			table.clear(set)

			for _, item in releases do
				local v5 = v2[item]
				v5.active = false
				local pool = v5.pool
				pool.last += 1
				pool.items[pool.last] = item

				if list ~= nil then
					appendChange(list, Diagnostics.PoolAction.Release, v5.viewType, -1, 1, 0) -- inferred equivalent call
				end
			end

			return {
				acquired = frozen,
				releasedCount = #releases
			}
		else
			if #releases ~= 0 then
				return nil
			end

			local v5 = true

			for _, item in requests do
				local viewType = item.viewType
				local v6 = v4[viewType]

				if v6 == nil then
					local v7 = v[viewType]
					v6 = v7 == nil and 0 or v7.last - v7.first + 1
				end

				if v6 == 0 then
					v5 = false
					break
				end

				v4[viewType] = v6 - 1
			end

			table.clear(v4)

			if not v5 then
				return nil
			end

			local acquired = table.create(#requests)

			for k, item in requests do
				local v6 = v[item.viewType]
				local item2 = v6.items[v6.last]
				v6.items[v6.last] = nil
				v6.last -= 1
				v2[item2].active = true
				acquired[k] = item2

				if list ~= nil then
					appendChange(list, Diagnostics.PoolAction.Acquire, item.viewType, 1, -1, 0) -- inferred equivalent call
				end
			end

			return { acquired = acquired, releasedCount = 0 }
		end
	end

	return {
		bind = function(data)
			assert(not flag, "RecyclingScope: cannot bind after disposal")
			assert(not v3, "RecyclingScope: cannot bind reentrantly")
			assert(validCapacity(data.capacity), "RecyclingScope: capacity must be a non-negative integer") -- inferred equivalent call
			local releases = data.releases
			local requests = data.requests

			local v5 = nil
			local v6

			if FFlagViewRecyclerReact08 then
				if adapter.isDestroyed ~= nil then
					for _, releas in releases do
						if not adapter.isDestroyed(releas) then
							continue
						end

						v5 = v5 or {}
						v5[releas] = true
					end
				end

				if v5 == nil then
					v6 = uniformDirectReuse(releases, requests)
				end
			else
				v6 = uniformDirectReuse(releases, requests)
			end

			if v6 == nil then
				local v7 = p.onPoolChanged ~= nil and {} or nil
				local v8

				if FFlagViewRecyclerReact08 then
					if v5 == nil then
						v8 = exchangeWithoutCreation(releases, requests, v7)
					end
				else
					v8 = exchangeWithoutCreation(releases, requests, v7)
				end

				if v8 == nil then
					v3 = true

					local releasSet = {}
					local v9 = {}

					for _, releas in releases do
						local v10 = v2[releas]

						if v10 == nil or not v10.active then
							v3 = false
							error("RecyclingScope: can only release an active view", 2)
						end

						if releasSet[releas] then
							v3 = false
							error("RecyclingScope: cannot release one view more than once", 2)
						end

						releasSet[releas] = true

						if not (not FFlagViewRecyclerReact08 or v5 == nil or not v5[releas]) then
							continue
						end

						local releas2 = v9[v10.viewType]

						if releas2 == nil then
							releas2 = {}
							v9[v10.viewType] = releas2
						end

						table.insert(releas2, releas)
					end

					local v10 = {}
					local v11 = {}
					local set2 = {}
					local set3 = {}
					local v12 = {}
					local set4 = {}
					local success, result = pcall(function()
						for k, request in requests do
							local v13 = v9[request.viewType]
							local v14

							if v13 ~= nil then
								v14 = table.remove(v13)
							end

							if v14 == nil then
								local v15 = v10[request.viewType]

								if v15 == nil then
									local v16 = v[request.viewType]
									v15 = v16 == nil and 0 or v16.last - v16.first + 1
								end

								if v15 > 0 then
									v10[request.viewType] = v15 - 1
									set2[k] = true
								else
									v10[request.viewType] = 0
									local v16 = adapter.create(request.viewType)

									local v17 = v2[v16] == nil and not set4[v16]
									assert(v17, "RecyclingScope: create must return a new view")

									set4[v16] = true
									v12[k] = v16
								end
							else
								v11[k] = v14
								set3[v14] = true
							end
						end
					end)

					if not success then
						finalize(nil, v12, nil, false)
						v3 = false
						error(result, 0)
					end

					local acquired

					if #requests == 0 then
						acquired = frozen
					else
						acquired = table.create(#requests)
					end

					local result2 = { acquired = acquired, releasedCount = 0 }

					local v13 = p.onPoolChanged ~= nil and {} or nil
					local releas = {}

					for _, releas2 in releases do
						if FFlagViewRecyclerReact08 then
							if v5 == nil or not v5[releas2] then
								if not set3[releas2] then
									local v14 = v2[releas2]
									v14.active = false
									local pool = v14.pool
									pool.last += 1
									pool.items[pool.last] = releas2
									result2.releasedCount += 1

									if v13 ~= nil then
										appendChange(v13, Diagnostics.PoolAction.Release, v14.viewType, -1, 1, 0) -- inferred equivalent call
									end
								end
							else
								local v14 = v2[releas2]
								forget(releas2) -- inferred equivalent call
								table.insert(releas, releas2)

								if v13 ~= nil then
									appendChange(v13, Diagnostics.PoolAction.Evict, v14.viewType, -1, 0, -1) -- inferred equivalent call
								end
							end
						elseif not set3[releas2] then
							local v14 = v2[releas2]
							v14.active = false
							local pool = v14.pool
							pool.last += 1
							pool.items[pool.last] = releas2
							result2.releasedCount += 1

							if v13 ~= nil then
								appendChange(v13, Diagnostics.PoolAction.Release, v14.viewType, -1, 1, 0) -- inferred equivalent call
							end
						end
					end

					for k, request in requests do
						local v14 = v11[k]

						if v14 == nil and set2[k] then
							local v15 = v[request.viewType]
							v14 = v15.items[v15.last]
							v15.items[v15.last] = nil
							v15.last -= 1
							v2[v14].active = true

							if v13 ~= nil then
								appendChange(v13, Diagnostics.PoolAction.Acquire, request.viewType, 1, -1, 0) -- inferred equivalent call
							end
						elseif v14 == nil then
							v14 = v12[k]
							v2[v14] = {
								viewType = request.viewType,
								pool = poolFor(request.viewType),
								active = true
							}

							if v13 ~= nil then
								appendChange(v13, Diagnostics.PoolAction.Create, request.viewType, 1, 0, 1) -- inferred equivalent call
							end
						end

						table.insert(result2.acquired, v14)
					end

					local capacity = data.capacity

					if capacity ~= nil then
						for _, v14 in v do
							trimPoolExcess(v14, capacity, releas, v13)
						end
					end

					local v14 = {}

					for _, v15 in v12 do
						table.insert(v14, v15)
					end

					local v15, v16 = finalize(v13, releas, v14)
					v3 = false

					if not v15 then
						error(v16, 0)
					end

					return result2
				else
					local v9 = frozen
					local capacity = data.capacity

					if capacity ~= nil then
						v9 = {}

						for _, v10 in v do
							trimPoolExcess(v10, capacity, v9, v7)
						end
					end

					v3 = true
					local v10, v11 = finalize(v7, v9, nil)
					v3 = false

					if not v10 then
						error(v11, 0)
					end

					return v8
				end
			else
				local capacity = data.capacity

				if capacity == nil then
					return v6
				end

				local v7 = p.onPoolChanged ~= nil and {} or nil
				local v8 = {}

				for _, v9 in v do
					trimPoolExcess(v9, capacity, v8, v7)
				end

				if #v8 > 0 then
					v3 = true
					local v9, v10 = finalize(v7, v8, nil)
					v3 = false

					if not v9 then
						error(v10, 0)
					end
				end

				return v6
			end
		end,
		dispose = function()
			if flag then
				return
			end

			assert(not v3, "RecyclingScope: cannot dispose during bind")
			flag = true

			local v5 = p.onPoolChanged ~= nil and {} or nil
			local v6 = {}

			for k, v7 in v2 do
				table.insert(v6, k)

				if v5 ~= nil then
					table.insert(v5, { viewType = v7.viewType, occupied = v7.active })
				end
			end

			table.clear(v2)
			table.clear(v)
			local v7

			if v5 ~= nil then
				v7 = table.create(#v6)
			end

			if v7 ~= nil then
				for _, v8 in v5 do
					appendChange( -- inferred equivalent call
						v7,
						Diagnostics.PoolAction.Evict,
						v8.viewType,
						v8.occupied and -1 or 0,
						v8.occupied and 0 or -1,
						-1
					)
				end
			end

			local v8, v9 = finalize(v7, v6, nil)

			if not v8 then
				error(v9, 0)
			end
		end
	}
end

return createRecyclingScope
