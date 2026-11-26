local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/RobloxAppEnums").AppPage
local homeOmniFeedCache = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/DiscoveryUtils").HomeOmniFeedCache
local getSduiTemplateStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SduiSharedUtilities").getSduiTemplateStore

local fFlagSduiUniverseItemConnectionsPlayed = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SharedFlags").FFlagSduiUniverseItemConnectionsPlayed

local v5 = {
	universe = { "player_count" }
}

local v6 = fFlagSduiUniverseItemConnectionsPlayed
	and {
		"connection_played_display_name",
		"connection_played_num_others",
		"connection_played_total_count"
	}
	or nil

local function cloneMessage(p2)
	return table.clone(p2)
end

local function readInputValue(p2)
	local kind = if p2 ~= nil then p2.kind else nil

	if kind == nil then
		return nil
	end

	return kind.value
end

local function replaceInputValue(p2, p3)
	local clone = table.clone(p2)

	clone.kind = { type = p2.kind.type, value = p3 }
	return clone
end

local function isFeed(p2): boolean
	return type(p2) == "table" and type(p2.entry_map) == "table"
end

local function itemListFields(value)
	local result = {}

	for k, item in value do
		if not (type(item) == "table" and #item > 0 and type(item[1]) == "table") then
			continue
		end

		table.insert(result, k)
	end

	table.sort(result)
	return result
end

local function readPoolId(p2)
	local pool_id = p2.pool_id

	if type(pool_id) == "string" and pool_id ~= "" then
		return pool_id
	end

	return nil
end

local function hasViewerScopedItemField(p2): boolean
	for k, v7 in v6 do
		if p2[v7] ~= nil then
			return true
		end
	end

	return false
end

local function clearViewerFields(p2)
	local flag = true
	local v7

	for k, v8 in v6 do
		if p2[v8] ~= nil then
			v7 = true
			flag = false
			break
		end
	end

	if flag then
		v7 = false
	end

	if not v7 then
		return p2
	end

	local clone = table.clone(p2)

	for k, v8 in v6 do
		clone[v8] = nil
	end

	return clone
end

local function clearItemViewerFields(p2)
	if type(p2) ~= "table" then
		return p2
	end

	local kind = p2.kind

	if type(kind) == "table" and type(kind.value) == "table" then
		local value = kind.value
		local flag = true
		local flag2

		for k, v7 in v6 do
			if value[v7] ~= nil then
				flag2 = true
				flag = false
				break
			end
		end

		if flag then
			flag2 = false
		end

		if flag2 then
			value = table.clone(value)

			for k, v7 in v6 do
				value[v7] = nil
			end
		end

		if value == kind.value then
			return p2
		end

		local clone = table.clone(p2)

		clone.kind = { type = kind.type, value = value }
		return clone
	else
		local flag = true
		local v7

		for k, v8 in v6 do
			if p2[v8] ~= nil then
				v7 = true
				flag = false
				break
			end
		end

		if flag then
			v7 = false
		end

		if not v7 then
			return p2
		end

		local clone = table.clone(p2)

		for k, v8 in v6 do
			clone[v8] = nil
		end

		return clone
	end
end

local function takeItems(list, p2)
	local result = {}

	if list == nil then
		return result
	end

	for i = 1, math.min(#list, p2) do
		local v7 = if fFlagSduiUniverseItemConnectionsPlayed then clearItemViewerFields(list[i]) else list[i]
		result[i] = v7
	end

	return result
end

local function readSortId(p2, p3)
	local sort_id = p3.sort_id

	if sort_id ~= nil and sort_id ~= "" then
		return (tostring(sort_id))
	end

	warn(`Home SDUI cache entry "{p2}" has no sort_id; using its identifier`)
	return p2
end

local function collectReferencedKeys(clone, p2)
	local typeName = type(clone)

	if typeName == "table" then
		for k, item in clone do
			collectReferencedKeys(item, p2)
		end
	elseif typeName == "string" or typeName == "number" then
		p2[tostring(clone)] = true
	end
end

local function filterOrder(items, p2)
	local result = {}

	if items == nil then
		return result
	end

	for k, item in items do
		if p2[item] ~= nil then
			table.insert(result, item)
		end
	end

	return result
end

local function filterOrderMap(entry_order_map, clones)
	local clones2 = {}

	if entry_order_map == nil then
		return clones2
	end

	for k, item in entry_order_map do
		local v7 = filterOrder(item.items, clones)

		if not (#v7 > 0) then
			continue
		end

		local clone = table.clone(item)

		clone.items = v7
		clones2[k] = clone
	end

	return clones2
end

local function pruneFeed(value, topicIdToNumCacheItems)
	local clones = {}
	local clonesByPool_id = {}

	local v7 = {}
	local set = {}

	if value.entry_order ~= nil then
		for k, v8 in value.entry_order do
			if set[v8] then
				continue
			end

			set[v8] = true
			table.insert(v7, v8)
		end
	end

	local v8 = {}

	for k in value.entry_map do
		if set[k] then
			continue
		end

		set[k] = true
		table.insert(v8, k)
	end

	table.sort(v8)

	for k, v9 in v8 do
		table.insert(v7, v9)
	end

	for k, v9 in v7 do
		local v10 = value.entry_map[v9]

		if v10 == nil then
			continue
		end

		local input_data = v10.input_data
		local kind = if input_data ~= nil then input_data.kind else nil
		local value2 = if kind ~= nil then kind.value else nil

		if type(value2) ~= "table" then
			continue
		end

		local pool_id = value2.pool_id

		if type(pool_id) ~= "string" or pool_id == "" then
			pool_id = nil
		end

		local v11 = itemListFields(value2)

		if not (pool_id ~= nil or #v11 ~= 0) then
			continue
		end

		local sort_id = value2.sort_id
		local v12

		if sort_id == nil or sort_id == "" then
			warn(`Home SDUI cache entry "{v9}" has no sort_id; using its identifier`)
			v12 = v9
		else
			v12 = tostring(sort_id)
		end

		local v13 = topicIdToNumCacheItems[v12]

		if v13 == nil then
			continue
		end

		local clone = table.clone(value2)

		if pool_id == nil then
			for k2, v14 in v11 do
				local v15 = takeItems(value2[v14], math.max(v13.cap - v13.count, 0))
				v13.count += #v15
				clone[v14] = v15
			end
		else
			local v14 = (value.content_pools or {})[pool_id]

			if v14 == nil then
				continue
			end

			if clonesByPool_id[pool_id] == nil then
				local clone2 = table.clone(v14)

				clone2.items = takeItems(v14.items, math.max(v13.cap - v13.count, 0))
				v13.count += #clone2.items
				clonesByPool_id[pool_id] = clone2
			end
		end

		local clone2 = table.clone(v10)

		local input_data2 = v10.input_data
		local clone3 = table.clone(input_data2)

		clone3.kind = { type = input_data2.kind.type, value = clone }

		clone2.input_data = clone3
		clones[v9] = clone2
	end

	if next(clones) == nil then
		return nil
	end

	local clone = table.clone(value)

	clone.entry_map = clones

	if value.content_pools ~= nil then
		clone.content_pools = clonesByPool_id
	end

	if value.entry_order ~= nil then
		clone.entry_order = filterOrder(value.entry_order, clones)
	end

	if value.entry_order_map ~= nil then
		clone.entry_order_map = filterOrderMap(value.entry_order_map, clones)
	end

	return clone
end

local function pruneHydration(hydration_data, p2)
	if hydration_data == nil then
		return nil
	end

	local clone = table.clone(hydration_data)

	for k, item in hydration_data do
		if type(item) ~= "table" then
			continue
		end

		local v7 = v5[k]
		local clones = {}

		for k2, v8 in item do
			if not (type(v8) == "table" and p2[tostring(k2)]) then
				continue
			end

			local clone2 = table.clone(v8)

			if v7 ~= nil then
				for k3, v9 in v7 do
					clone2[v9] = nil
				end
			end

			clones[k2] = clone2
		end

		clone[k] = clones
	end

	return clone
end

local function fillMissingTemplatesFromStore(clone)
	local sduiTemplateStore = getSduiTemplateStore()
	local cachedRobloxComponentToTemplateId = sduiTemplateStore.getCachedRobloxComponentToTemplateId(appPage.Home)

	if next(cachedRobloxComponentToTemplateId) == nil then
		return
	end

	local templates = clone.templates or {}
	local clone2 = table.clone(templates)

	local templateEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/ServiceContractsProto").apppageplatform.shared.template_entry.TemplateEntry

	for k, v7 in cachedRobloxComponentToTemplateId do
		if clone2[v7] ~= nil then
			continue
		end

		local template = sduiTemplateStore.getTemplate(v7)

		if template ~= nil then
			clone2[v7] = templateEntry.new({ template = template, roblox_component = k })
		end
	end

	clone.templates = clone2
end

return {
	buildSduiHomePageCachePayload = function(p2)
		local topicIdToNumCacheItems = homeOmniFeedCache.getTopicIdToNumCacheItems()

		local clones = {}
		local v7 = {}

		for k, v8 in p2.page_entries or {} do
			local input_data = v8.input_data
			local kind = if input_data ~= nil then input_data.kind else nil
			local value = if kind ~= nil then kind.value else nil

			local v9 = type(value) == "table" and type(value.entry_map) == "table"

			if not v9 then
				continue
			end

			local v10 = pruneFeed(value, topicIdToNumCacheItems)

			if v10 == nil then
				continue
			end

			local clone = table.clone(v8)

			local input_data2 = v8.input_data
			local clone2 = table.clone(input_data2)

			clone2.kind = { type = input_data2.kind.type, value = v10 }

			clone.input_data = clone2
			table.insert(clones, clone)
			collectReferencedKeys(clone, v7)
		end

		if #clones == 0 then
			return nil
		end

		local clone = table.clone(p2)

		clone.page_entries = clones
		clone.hydration_data = pruneHydration(p2.hydration_data, v7)

		clone.request_id = ""
		fillMissingTemplatesFromStore(clone)
		return clone
	end,
	serializeSduiHomePageCache = function(object)
		return require("@game/CorePackages/Workspace/Packages/_Workspace/Home/ServiceContractsProto").proto.json.serializeBuffer(object:encode())
	end,
	deserializeSduiHomePageCache = function(p2)
		if p2 == nil then
			return nil
		end

		local module = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/ServiceContractsProto")
		local deserializeBuffer = module.proto.json.deserializeBuffer(p2)
		return module.apppageplatform.home.home_page.HomePageResponse.decode(deserializeBuffer)
	end,
	getSduiHomePageItemsForSortId = function(p2)
		local cachedSduiHomePageData = homeOmniFeedCache.getCachedSduiHomePageData()
		local decoded

		if cachedSduiHomePageData ~= nil then
			local module = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/ServiceContractsProto")
			local deserializeBuffer = module.proto.json.deserializeBuffer(cachedSduiHomePageData)
			decoded = module.apppageplatform.home.home_page.HomePageResponse.decode(deserializeBuffer)
		end

		if decoded == nil then
			return nil
		end

		for k, page_entry in decoded.page_entries do
			local input_data = page_entry.input_data
			local kind = if input_data ~= nil then input_data.kind else nil
			local value = if kind ~= nil then kind.value else nil

			local v7 = type(value) == "table" and type(value.entry_map) == "table"

			if not v7 then
				continue
			end

			for k2, v8 in value.entry_map do
				local input_data2 = v8.input_data
				local kind2 = if input_data2 ~= nil then input_data2.kind else nil
				local value2 = if kind2 ~= nil then kind2.value else nil

				if type(value2) ~= "table" then
					continue
				end

				local pool_id = value2.pool_id

				if type(pool_id) ~= "string" or pool_id == "" then
					pool_id = nil
				end

				local v9 = itemListFields(value2)

				if not (pool_id ~= nil or #v9 ~= 0) then
					continue
				end

				local sort_id = value2.sort_id

				if sort_id == nil or sort_id == "" then
					warn(`Home SDUI cache entry "{k2}" has no sort_id; using its identifier`)
				else
					k2 = tostring(sort_id)
				end

				if k2 == p2 then
					if pool_id == nil then
						return value2[v9[1]]
					end

					local result = {}

					for k3, v10 in ((value.content_pools or {})[pool_id] or {}).items or {} do
						local kind3 = if v10 ~= nil then v10.kind else nil
						local value3 = if kind3 ~= nil then kind3.value else nil

						if value3 ~= nil then
							table.insert(result, value3)
						end
					end

					return result
				end
			end
		end

		return nil
	end
}
