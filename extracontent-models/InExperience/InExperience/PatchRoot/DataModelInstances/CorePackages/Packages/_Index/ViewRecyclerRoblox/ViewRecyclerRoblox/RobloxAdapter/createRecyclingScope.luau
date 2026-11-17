local Flags = require(script:FindFirstAncestor("ViewRecyclerRoblox").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local Flags2 = require(script:FindFirstAncestor("ViewRecyclerRoblox").Flags)
local FFlagViewRecyclerReact08 = Flags2.FFlagViewRecyclerReact08
local ViewRecyclerRoblox = script:FindFirstAncestor("ViewRecyclerRoblox")
local ViewRecycler = require(ViewRecyclerRoblox.Parent.ViewRecycler)

local VacantHosts = require(ViewRecyclerRoblox.RobloxAdapter.VacantHosts)

local function createRecyclingScope(data)
	if FFlagViewRecyclerReact084 then
		assert(
			typeof(data.vacantHostParent) == "Instance",
			"createRecyclingScope: vacantHostParent must be an Instance"
		)
	end

	local itemViewAdapter = data.itemViewAdapter
	local maxPoolSize = data.maxPoolSize

	local function getInstance(guiObject)
		if data.getInstance ~= nil then
			guiObject = data.getInstance(guiObject)
		end

		local v = typeof(guiObject) == "Instance" and guiObject:IsA("GuiObject")
		assert(v, "createRecyclingScope: ItemView host must be a GuiObject")

		return guiObject
	end

	local batch = itemViewAdapter.batch or function(callback)
		callback()
	end

	local v = FFlagViewRecyclerReact084 and {} or FFlagViewRecyclerReact08 and {} or nil

	local createRecyclingScope2 = ViewRecycler.Adapter.createRecyclingScope
	local v2 = {
		onPoolChanged = data.diagnostics ~= nil and function(data2)
			data.diagnostics({
				kind = ViewRecycler.Diagnostics.EventKind.PoolChanged,
				action = data2.action,
				itemViewType = data2.viewType,
				occupiedDelta = data2.occupiedDelta,
				vacantDelta = data2.vacantDelta,
				totalDelta = data2.totalDelta
			})
		end or nil,
		adapter = 0
	}
	local adapter = {
		create = function(p)
			local v3 = itemViewAdapter.create(p)

			if FFlagViewRecyclerReact084 then
				local guiObject

				if data.getInstance == nil then
					guiObject = v3
				else
					guiObject = data.getInstance(v3)
				end

				local v4 = typeof(guiObject) == "Instance" and guiObject:IsA("GuiObject")
				assert(v4, "createRecyclingScope: ItemView host must be a GuiObject")

				v[v3] = guiObject.Destroying:Connect(function() end)
				return v3
			elseif FFlagViewRecyclerReact08 then
				local guiObject

				if data.getInstance == nil then
					guiObject = v3
				else
					guiObject = data.getInstance(v3)
				end

				local v4 = typeof(guiObject) == "Instance" and guiObject:IsA("GuiObject")
				assert(v4, "createRecyclingScope: ItemView host must be a GuiObject")

				v[v3] = guiObject.Destroying:Connect(function() end)
				return v3
			else
				local guiObject

				if data.getInstance == nil then
					guiObject = v3
				else
					guiObject = data.getInstance(v3)
				end

				local v4 = typeof(guiObject) == "Instance" and guiObject:IsA("GuiObject")
				assert(v4, "createRecyclingScope: ItemView host must be a GuiObject")

				return v3
			end
		end,
		destroy = function(guiObject)
			local connection

			if FFlagViewRecyclerReact084 then
				connection = v[guiObject]
			end

			local v3

			if FFlagViewRecyclerReact084 then
				v3 = connection ~= nil
			else
				v3 = FFlagViewRecyclerReact08
			end

			if v3 then
				if FFlagViewRecyclerReact084 then
					connection:Disconnect()
					v[guiObject] = nil
				else
					local connection2 = v[guiObject]

					if connection2 ~= nil then
						connection2:Disconnect()
						v[guiObject] = nil
					end
				end
			end

			if data.destroyItemView ~= nil then
				data.destroyItemView(guiObject)
				return
			end

			if data.getInstance ~= nil then
				guiObject = data.getInstance(guiObject)
			end

			local v4 = typeof(guiObject) == "Instance" and guiObject:IsA("GuiObject")
			assert(v4, "createRecyclingScope: ItemView host must be a GuiObject")

			guiObject:Destroy()
		end,
		onCreated = itemViewAdapter.onCreated,
		onEvicted = itemViewAdapter.onEvicted,
		batch = batch,
		isDestroyed = 0
	}
	local isDestroyed

	if FFlagViewRecyclerReact084 then
		isDestroyed = function(p): boolean
			local v3 = v[p]
			return v3 ~= nil and not v3.Connected
		end
	else
		isDestroyed = FFlagViewRecyclerReact08 and function(p): boolean
			local v3 = v[p]
			return v3 ~= nil and not v3.Connected
		end or nil
	end

	adapter.isDestroyed = isDestroyed
	v2.adapter = adapter
	local recyclingScope = createRecyclingScope2(v2)

	local v3 = nil
	local v4

	if FFlagViewRecyclerReact084 then
		v3 = VacantHosts.new()
		v3.setParent(data.vacantHostParent)

		v4 = {
			bind = function(p)
				local clone = table.clone(p)

				if clone.capacity == nil then
					clone.capacity = maxPoolSize
				end

				return recyclingScope.bind(clone)
			end,
			dispose = function()
				recyclingScope.dispose()
				v3.destroy()
			end
		}

		VacantHosts.register(v4, v3)
	end

	return not FFlagViewRecyclerReact084 and {
		bind = function(p)
			local clone = table.clone(p)

			if clone.capacity == nil then
				clone.capacity = maxPoolSize
			end

			return recyclingScope.bind(clone)
		end,
		dispose = recyclingScope.dispose
	} or v4
end

return { create = createRecyclingScope }
