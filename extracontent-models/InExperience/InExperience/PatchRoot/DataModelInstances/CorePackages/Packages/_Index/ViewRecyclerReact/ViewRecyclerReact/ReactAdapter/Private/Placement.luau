local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")
local ViewRecycler = require(ViewRecyclerReact.Parent.ViewRecycler)
local Destination = require(script.Parent.Destination)
require(script.Parent.RecyclableView)
require(script.Parent.RecyclableViewRegistry)
local SignalsExperimental = require(ViewRecyclerReact.Parent.SignalsExperimental)

return {
	new = function(recyclingScope, p)
		local name = p.name
		local namespace = p.namespace
		local slotBinder = ViewRecycler.Adapter.createSlotBinder({
			recyclingScope = recyclingScope,
			name = name,
			prepareDesiredAssignment = function(data)
				return {
					key = data.assignmentKey or namespace .. ":" .. data.key,
					value = data.value
				}
			end
		})

		local v = {}
		local flag = false
		local flag2 = false
		local flag3 = false

		local function publish(departed, items)
			for _, item in departed do
				item.transition(nil)
			end

			for _, item in items do
				local key = item.key
				local v2 = slotBinder.get(key)
				local view = v2.view
				local v3 = v[key]

				if
					v3 == nil
					or v3.view ~= view
					or v3.assignment ~= v2.assignment
					or v3.destination ~= item.destination
				then
					v3 = { view = view, assignment = v2.assignment, destination = item.destination }

					v[key] = v3
					view.transition(table.freeze({
						assignment = v2.assignment,
						index = nil,
						destination = item.destination
					}))
				end

				local geometry = item.geometry
				local portalFrame = view.portalFrame(false)

				if not (geometry ~= nil and portalFrame ~= nil) then
					continue
				end

				assert(
					item.destination.kind == Destination.Kind.Rect,
					"Placement: geometry requires a Rect Destination"
				)

				local position = geometry.position
				local size = geometry.size

				if v3.position ~= position then
					v3.position = position
					portalFrame.Position = UDim2.fromOffset(position.X, position.Y)
				end

				if v3.size ~= size then
					v3.size = size
					portalFrame.Size = UDim2.fromOffset(size.X, size.Y)
				end

				if v3.zIndex == geometry.zIndex then
					continue
				end

				v3.zIndex = geometry.zIndex
				portalFrame.ZIndex = geometry.zIndex
			end
		end

		local function apply(items, list)
			local assignmentEntries = table.create(#list)

			for k, item in list do
				local key = item.key
				local assignmentKey = item.assignmentKey
				local changed = item.changed == true

				if assignmentKey ~= nil then
					local v2 = v[key]

					if not changed then
						if v2 == nil then
							changed = false
						else
							changed = v2.assignment.key ~= assignmentKey
						end
					end
				end

				assignmentEntries[k] = {
					key = key,
					value = item.value,
					viewType = item.viewType,
					changed = changed,
					assignmentKey = assignmentKey
				}
			end

			local v2

			if items == nil then
				v2 = slotBinder.sync(assignmentEntries)

				for k in v do
					if slotBinder.get(k) == nil then
						v[k] = nil
					end
				end
			else
				v2 = slotBinder.apply(items, assignmentEntries)

				for _, item in items do
					if slotBinder.get(item) == nil then
						v[item] = nil
					end
				end
			end

			flag2 = true

			if #v2.departed + #list > 1 or list[1] ~= nil and list[1].geometry ~= nil then
				SignalsExperimental.batch(function()
					publish(v2.departed, list)
				end)
			else
				publish(v2.departed, list)
			end

			flag2 = false
		end

		local function exchange(p2, p3)
			if flag3 then
				error(`{name}: cannot place views after destruction`)
			elseif flag then
				error(`{name}: cannot place views reentrantly`)
			elseif flag2 then
				error(`{name}: cannot place views after a publication failure`)
			end

			flag = true
			local success, result = pcall(apply, p2, p3)
			flag = false

			if not success then
				error(result, 0)
			end
		end

		local function releaseAll()
			assert(not flag, `{name}: cannot release views during placement`)
			table.clear(v)
			local v2 = slotBinder.releaseAll()
			SignalsExperimental.batch(function()
				for _, v3 in v2 do
					v3.transition(nil)
				end
			end)
		end

		return {
			exchange = exchange,
			sync = function(p2)
				exchange(nil, p2)
			end,
			releaseAll = function()
				if not flag3 then
					releaseAll()
				end
			end,
			hasDestroyedView = function(): boolean
				for _, v2 in v do
					if v2.view.isHostDestroyed() then
						return true
					end
				end

				return false
			end,
			destroy = function()
				if flag3 then
					return
				end

				releaseAll()
				slotBinder.destroy()
				flag3 = true
			end
		}
	end
}
