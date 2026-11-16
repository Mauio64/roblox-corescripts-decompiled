local Flags = require(script:FindFirstAncestor("ViewRecyclerRoblox").Flags)
local FFlagViewRecyclerReact08 = Flags.FFlagViewRecyclerReact08
local ViewRecyclerRoblox = script:FindFirstAncestor("ViewRecyclerRoblox")
local ViewRecycler = require(ViewRecyclerRoblox.Parent.ViewRecycler)

local function createRecyclingScope(data)
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

	local v = FFlagViewRecyclerReact08 and {} or nil

	local recyclingScope = ViewRecycler.Adapter.createRecyclingScope({
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
		adapter = {
			create = function(p)
				local v2 = itemViewAdapter.create(p)

				if FFlagViewRecyclerReact08 then
					local guiObject

					if data.getInstance == nil then
						guiObject = v2
					else
						guiObject = data.getInstance(v2)
					end

					local v3 = typeof(guiObject) == "Instance" and guiObject:IsA("GuiObject")
					assert(v3, "createRecyclingScope: ItemView host must be a GuiObject")

					v[v2] = guiObject.Destroying:Connect(function() end)
					return v2
				else
					local guiObject

					if data.getInstance == nil then
						guiObject = v2
					else
						guiObject = data.getInstance(v2)
					end

					local v3 = typeof(guiObject) == "Instance" and guiObject:IsA("GuiObject")
					assert(v3, "createRecyclingScope: ItemView host must be a GuiObject")

					return v2
				end
			end,
			destroy = function(guiObject)
				if FFlagViewRecyclerReact08 then
					local connection = v[guiObject]

					if connection ~= nil then
						connection:Disconnect()
						v[guiObject] = nil
					end
				end

				if data.destroyItemView ~= nil then
					data.destroyItemView(guiObject)
					return
				end

				if data.getInstance ~= nil then
					guiObject = data.getInstance(guiObject)
				end

				local v2 = typeof(guiObject) == "Instance" and guiObject:IsA("GuiObject")
				assert(v2, "createRecyclingScope: ItemView host must be a GuiObject")

				guiObject:Destroy()
			end,
			onCreated = itemViewAdapter.onCreated,
			onEvicted = itemViewAdapter.onEvicted,
			batch = batch,
			isDestroyed = FFlagViewRecyclerReact08 and function(p): boolean
				local v2 = v[p]
				return v2 ~= nil and not v2.Connected
			end or nil
		}
	})

	return {
		bind = function(p)
			local clone = table.clone(p)

			if clone.capacity == nil then
				clone.capacity = maxPoolSize
			end

			return recyclingScope.bind(clone)
		end,
		dispose = recyclingScope.dispose
	}
end

return { create = createRecyclingScope }
