local Flags = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local Flags2 = require(script:FindFirstAncestor("ViewRecyclerReact").Flags)
local FFlagViewRecyclerReact08 = Flags2.FFlagViewRecyclerReact08
local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")
local ViewRecycler = require(ViewRecyclerReact.Parent.ViewRecycler)

local CompositionPlacement = require(script.Parent.CompositionPlacement)
local React = require(ViewRecyclerReact.Parent.React)
local RecyclableView = require(script.Parent.RecyclableView)
local RecyclableViewHost = require(ViewRecyclerReact.ReactAdapter.RecyclableViewHost)
local RecyclableViewRegistry = require(script.Parent.RecyclableViewRegistry)
local SignalsExperimental = require(ViewRecyclerReact.Parent.SignalsExperimental)
local vacantHosts

if FFlagViewRecyclerReact084 then
	local ViewRecyclerRoblox = require(ViewRecyclerReact.Parent.ViewRecyclerRoblox)
	vacantHosts = ViewRecyclerRoblox.Internal.VacantHosts
else
	vacantHosts = nil
end

local createElement = React.createElement

local RecyclingRoot = {}

if FFlagViewRecyclerReact084 then
	function RecyclingRoot.new(callback, p: number?)
		local v = {}
		local v2 = 1
		local flag = false
		local scope = nil
		local capacity = p
		local v3 = {}
		local v4 = {}

		local v5 = {
			onPoolChanged = function(data)
				if #v3 == 0 then
					return
				end

				local v5 = {
					kind = ViewRecycler.Diagnostics.EventKind.PoolChanged,
					action = data.action,
					itemViewType = data.viewType,
					occupiedDelta = data.occupiedDelta,
					vacantDelta = data.vacantDelta,
					totalDelta = data.totalDelta
				}

				for _, v6 in table.clone(v3) do
					v6(v5)
				end
			end
		}

		local v6 = nil
		local v7 = vacantHosts.new()

		local function notifyChanged() -- 2 equivalent calls inferred from this helper
			if not flag then
				callback()
			end
		end

		local v8 = {
			allocateId = function()
				assert(not flag, "RecyclingRoot: cannot allocate after destroy")
				local id = v2
				v2 += 1
				return id
			end,
			addHosts = function(items, callback2, callback3)
				assert(not flag, "RecyclingRoot: cannot add hosts after destroy")
				local flag2 = false

				for _, item in items do
					assert(v[item] == nil, "RecyclingRoot: resource host is already registered")
					v[item] = { key = callback2(item), render = callback3(item) }
					flag2 = true
				end

				if flag2 then
					notifyChanged() -- inferred equivalent call
				end
			end,
			removeHosts = function(items)
				local flag2 = false

				for _, item in items do
					if v[item] == nil then
						continue
					end

					v[item] = nil
					flag2 = true
				end

				if flag2 then
					notifyChanged() -- inferred equivalent call
				end
			end
		}

		return {
			getScope = function()
				assert(not flag, "RecyclingRoot: cannot get a Recycling scope after destroy")

				if scope ~= nil then
					return scope
				end

				v5.adapter = {
					create = function(p2)
						assert(
							RecyclableViewRegistry.isRegistered(p2),
							"RecyclingScope: cannot create an unregistered Recyclable view type"
						)

						return RecyclableView(v8.allocateId(), p2, nil, v6)
					end,
					destroy = function(p2)
						p2.destroy()
					end,
					onCreated = function(p2)
						v8.addHosts(p2, function(p3)
							return `RecyclableView{p3.id}`
						end, function(itemView)
							return function(createPortal)
								return createElement(RecyclableViewHost, {
									itemView = itemView,
									createPortal = createPortal
								})
							end
						end)
					end,
					onEvicted = function(p2)
						v8.removeHosts(p2)
					end,
					batch = SignalsExperimental.batch,
					isDestroyed = function(p2)
						return p2.isHostDestroyed()
					end
				}

				local recyclingScope = ViewRecycler.Adapter.createRecyclingScope(v5)
				local v9 = {
					bind = function(p2)
						local clone = table.clone(p2)
						clone.capacity = capacity
						return recyclingScope.bind(clone)
					end,
					dispose = recyclingScope.dispose
				}

				scope = v9
				vacantHosts.register(v9, v7)
				v6 = CompositionPlacement.new(v9)
				return scope
			end,
			setMaxPoolSize = function(p2)
				if p2 == capacity then
					return
				end

				capacity = p2

				if scope ~= nil then
					scope.bind({ releases = {}, requests = {} })
				end
			end,
			observePool = function(p2)
				local v9 = v4[p2]

				if v9 == nil then
					table.insert(v3, p2)
				end

				v4[p2] = (v9 or 0) + 1
				local v10 = true
				return function()
					if not v10 then
						return
					end

					v10 = false
					local v11 = v4[p2] - 1

					if v11 > 0 then
						v4[p2] = v11
						return
					end

					v4[p2] = nil
					table.remove(v3, (table.find(v3, p2)))
				end
			end,
			getPortalChildren = function(p2)
				local portalChildren = {}

				for _, v9 in v do
					portalChildren[v9.key] = v9.render(p2)
				end

				return portalChildren
			end,
			setVacantHostParent = function(p2)
				if not flag then
					v7.setParent(p2)
				end
			end,
			destroy = function()
				if flag then
					return
				end

				flag = true

				if v6 ~= nil then
					v6.destroy()
				end

				v6 = nil

				if scope ~= nil then
					scope.dispose()
				end

				scope = nil
				v7.destroy()
				table.clear(v)
			end
		}
	end
elseif FFlagViewRecyclerReact08 then
	function RecyclingRoot.new(callback, p: number?)
		local v = {}
		local v2 = 1
		local flag = false
		local scope = nil
		local capacity = p
		local v3 = {}
		local v4 = {}

		local v5 = {
			onPoolChanged = function(data)
				if #v3 == 0 then
					return
				end

				local v5 = {
					kind = ViewRecycler.Diagnostics.EventKind.PoolChanged,
					action = data.action,
					itemViewType = data.viewType,
					occupiedDelta = data.occupiedDelta,
					vacantDelta = data.vacantDelta,
					totalDelta = data.totalDelta
				}

				for _, v6 in table.clone(v3) do
					v6(v5)
				end
			end
		}

		local v6 = nil

		local function notifyChanged() -- 2 equivalent calls inferred from this helper
			if not flag then
				callback()
			end
		end

		local v7 = {
			allocateId = function()
				assert(not flag, "RecyclingRoot: cannot allocate after destroy")
				local id = v2
				v2 += 1
				return id
			end,
			addHosts = function(items, callback2, callback3)
				assert(not flag, "RecyclingRoot: cannot add hosts after destroy")
				local flag2 = false

				for _, item in items do
					assert(v[item] == nil, "RecyclingRoot: resource host is already registered")
					v[item] = { key = callback2(item), render = callback3(item) }
					flag2 = true
				end

				if flag2 then
					notifyChanged() -- inferred equivalent call
				end
			end,
			removeHosts = function(items)
				local flag2 = false

				for _, item in items do
					if v[item] == nil then
						continue
					end

					v[item] = nil
					flag2 = true
				end

				if flag2 then
					notifyChanged() -- inferred equivalent call
				end
			end
		}

		return {
			getScope = function()
				assert(not flag, "RecyclingRoot: cannot get a Recycling scope after destroy")

				if scope ~= nil then
					return scope
				end

				v5.adapter = {
					create = function(p2)
						assert(
							RecyclableViewRegistry.isRegistered(p2),
							"RecyclingScope: cannot create an unregistered Recyclable view type"
						)

						return RecyclableView(v7.allocateId(), p2, nil, v6)
					end,
					destroy = function(p2)
						p2.destroy()
					end,
					onCreated = function(p2)
						v7.addHosts(p2, function(p3)
							return `RecyclableView{p3.id}`
						end, function(itemView)
							return function(createPortal)
								return createElement(RecyclableViewHost, {
									itemView = itemView,
									createPortal = createPortal
								})
							end
						end)
					end,
					onEvicted = function(p2)
						v7.removeHosts(p2)
					end,
					batch = SignalsExperimental.batch,
					isDestroyed = function(p2)
						return p2.isHostDestroyed()
					end
				}

				local recyclingScope = ViewRecycler.Adapter.createRecyclingScope(v5)
				local v8 = {
					bind = function(p2)
						local clone = table.clone(p2)
						clone.capacity = capacity
						return recyclingScope.bind(clone)
					end,
					dispose = recyclingScope.dispose
				}

				scope = v8
				v6 = CompositionPlacement.new(v8)
				return scope
			end,
			setMaxPoolSize = function(p2)
				if p2 == capacity then
					return
				end

				capacity = p2

				if scope ~= nil then
					scope.bind({ releases = {}, requests = {} })
				end
			end,
			observePool = function(p2)
				local v8 = v4[p2]

				if v8 == nil then
					table.insert(v3, p2)
				end

				v4[p2] = (v8 or 0) + 1
				local v9 = true
				return function()
					if not v9 then
						return
					end

					v9 = false
					local v10 = v4[p2] - 1

					if v10 > 0 then
						v4[p2] = v10
						return
					end

					v4[p2] = nil
					table.remove(v3, (table.find(v3, p2)))
				end
			end,
			getPortalChildren = function(p2)
				local portalChildren = {}

				for _, v8 in v do
					portalChildren[v8.key] = v8.render(p2)
				end

				return portalChildren
			end,
			destroy = function()
				if flag then
					return
				end

				flag = true

				if v6 ~= nil then
					v6.destroy()
				end

				v6 = nil

				if scope ~= nil then
					scope.dispose()
				end

				scope = nil
				table.clear(v)
			end
		}
	end
else
	function RecyclingRoot.new(callback, _: number?)
		local v = {}
		local v2 = 1
		local flag = false
		local scope = nil

		local function notifyChanged() -- 2 equivalent calls inferred from this helper
			if not flag then
				callback()
			end
		end

		local v3 = {
			allocateId = function()
				assert(not flag, "RecyclingRoot: cannot allocate after destroy")
				local id = v2
				v2 += 1
				return id
			end,
			addHosts = function(items, callback2, callback3)
				assert(not flag, "RecyclingRoot: cannot add hosts after destroy")
				local flag2 = false

				for _, item in items do
					assert(v[item] == nil, "RecyclingRoot: resource host is already registered")
					v[item] = { key = callback2(item), render = callback3(item) }
					flag2 = true
				end

				if flag2 then
					notifyChanged() -- inferred equivalent call
				end
			end,
			removeHosts = function(items)
				local flag2 = false

				for _, item in items do
					if v[item] == nil then
						continue
					end

					v[item] = nil
					flag2 = true
				end

				if flag2 then
					notifyChanged() -- inferred equivalent call
				end
			end
		}

		return {
			getScope = function(p)
				assert(not flag, "RecyclingRoot: cannot get a Recycling scope after destroy")

				if scope ~= nil then
					return scope
				end

				local capacity = p.maxPoolSize
				local recyclingScope = ViewRecycler.Adapter.createRecyclingScope({
					onPoolChanged = p.diagnostics ~= nil and function(data)
						p.diagnostics({
							kind = ViewRecycler.Diagnostics.EventKind.PoolChanged,
							action = data.action,
							itemViewType = data.viewType,
							occupiedDelta = data.occupiedDelta,
							vacantDelta = data.vacantDelta,
							totalDelta = data.totalDelta
						})
					end or nil,
					adapter = {
						create = function(p2)
							local metadata = RecyclableViewRegistry.getMetadata(p2)
							assert(
								metadata ~= nil,
								"RecyclingScope: cannot create an unregistered Recyclable view type"
							)

							return RecyclableView(
								v3.allocateId(),
								p2,
								nil,
								metadata.readiness,
								metadata.hideWhilePending
							)
						end,
						destroy = function(p2)
							p2.destroy()
						end,
						onCreated = function(p2)
							v3.addHosts(p2, function(p3)
								return `RecyclableView{p3.id}`
							end, function(itemView)
								return function(createPortal)
									return createElement(RecyclableViewHost, {
										itemView = itemView,
										createPortal = createPortal
									})
								end
							end)
						end,
						onEvicted = function(p2)
							v3.removeHosts(p2)
						end,
						batch = SignalsExperimental.batch
					}
				})

				scope = {
					bind = function(p2)
						local clone = table.clone(p2)

						if clone.updateCapacity then
							capacity = clone.capacity
							clone.updateCapacity = nil
						elseif clone.capacity == nil then
							clone.capacity = capacity
						else
							capacity = clone.capacity
						end

						return recyclingScope.bind(clone)
					end,
					dispose = recyclingScope.dispose
				}
				return scope
			end,
			getPortalChildren = function(p)
				local portalChildren = {}

				for _, v4 in v do
					portalChildren[v4.key] = v4.render(p)
				end

				return portalChildren
			end,
			destroy = function()
				if flag then
					return
				end

				flag = true

				if scope ~= nil then
					scope.dispose()
				end

				scope = nil
				table.clear(v)
			end
		}
	end
end

return RecyclingRoot
