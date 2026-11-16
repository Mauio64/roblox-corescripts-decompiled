local parent = script:FindFirstAncestor("Foundation").Parent

local Dash = require(parent.Dash)
local join = Dash.join

local v = {}
local StudioUri = {}

function StudioUri.equals(data, data2): boolean
	if rawequal(data, data2) then
		return true
	end

	return data.DataModel == data2.DataModel
		and data.PluginType == data2.PluginType
		and data.PluginId == data2.PluginId
		and data.Category == data2.Category
		and data.ItemId == data2.ItemId
end

StudioUri.RESTRICTED_Mt = table.freeze({
	__eq = function(p, p2)
		return StudioUri.equals(p, p2)
	end
})

function StudioUri.wrap(list)
	if table.isfrozen(list) and getmetatable(list) == StudioUri.RESTRICTED_Mt then
		return list
	end

	if table.isfrozen(list) then
		list = table.clone(list)
	end

	return table.freeze((setmetatable(list, StudioUri.RESTRICTED_Mt)))
end

function StudioUri.join(p, p2)
	return StudioUri.wrap(join(p, p2))
end

function StudioUri.toString(p)
	local v2 = table.create(5)
	local v3 = p or v

	if not v3 then
		return ""
	end

	if v3.DataModel then
		table.insert(v2, `DataModel:{v3.DataModel}`)
	end

	if v3.PluginType then
		table.insert(v2, `PluginType:{v3.PluginType}`)
	end

	if v3.PluginId then
		table.insert(v2, `PluginId:{v3.PluginId}`)
	end

	if v3.Category then
		table.insert(v2, `Category:{v3.Category}`)
	end

	if v3.ItemId then
		table.insert(v2, `ItemId:{v3.ItemId}`)
	end

	return table.concat(v2, ", ")
end

function StudioUri.child(p, itemId: string)
	local join2 = StudioUri.join

	if p.ItemId then
		itemId = `{p.ItemId}/{itemId}`
	end

	return join2(p, { ItemId = itemId })
end

function StudioUri.isNull(p): boolean
	return p.DataModel == "Null"
end

function StudioUri.isValid(p): boolean
	return type(p) == "table"
end

function StudioUri.isStudioUri(data): boolean
	if type(data) == "table" then
		return data.DataModel ~= nil
			or data.PluginType ~= nil
			or data.PluginId ~= nil
			or data.Category ~= nil
			or data.ItemId ~= nil
	end

	return false
end

function StudioUri.fromAction(pluginId: string, itemId: string)
	return StudioUri.wrap({
		DataModel = "Standalone",
		PluginId = pluginId,
		Category = "Actions",
		ItemId = itemId
	})
end

function StudioUri.fromSetting(pluginId: string, itemId: string)
	return StudioUri.wrap({
		DataModel = "Standalone",
		PluginId = pluginId,
		Category = "Settings",
		ItemId = itemId
	})
end

function StudioUri.fromWidget(pluginId: string, itemId: string)
	return StudioUri.wrap({
		DataModel = "Standalone",
		PluginId = pluginId,
		Category = "Widgets",
		ItemId = itemId
	})
end

function StudioUri.fromPanel(pluginId: string, itemId: string)
	return StudioUri.wrap({
		DataModel = "Standalone",
		PluginId = pluginId,
		Category = "Panels",
		ItemId = itemId
	})
end

return StudioUri
