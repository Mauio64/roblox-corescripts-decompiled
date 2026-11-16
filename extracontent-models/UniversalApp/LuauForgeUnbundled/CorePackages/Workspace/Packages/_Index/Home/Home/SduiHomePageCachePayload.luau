local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/RobloxAppEnums").AppPage
local homeOmniFeedCache = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/DiscoveryUtils").HomeOmniFeedCache
local getSduiTemplateStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SduiSharedUtilities").getSduiTemplateStore

local v5 = {
	universe = { "player_count" }
}

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

local function takeItems(list, p2)
	local result = {}

	if list == nil then
		return result
	end

	for i = 1, math.min(#list, p2) do
		result[i] = list[i]
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
		local v6 = filterOrder(item.items, clones)

		if not (#v6 > 0) then
			continue
		end

		local clone = table.clone(item)

		clone.items = v6
		clones2[k] = clone
	end

	return clones2
end

local function pruneFeed(value, topicIdToNumCacheItems)
	local clones = {}
	local clonesByPool_id = {}

	local v6 = {}
	local set = {}

	if value.entry_order ~= nil then
		for k, v7 in value.entry_order do
			if set[v7] then
				continue
			end

			set[v7] = true
			table.insert(v6, v7)
		end
	end

	local v7 = {}

	for k in value.entry_map do
		if set[k] then
			continue
		end

		set[k] = true
		table.insert(v7, k)
	end

	table.sort(v7)

	for k, v8 in v7 do
		table.insert(v6, v8)
	end

	for k, v8 in v6 do
		local v9 = value.entry_map[v8]

		if v9 == nil then
			continue
		end

		local input_data = v9.input_data
		local kind = if input_data ~= nil then input_data.kind else nil
		local value2 = if kind ~= nil then kind.value else nil

		if type(value2) ~= "table" then
			continue
		end

		local pool_id = value2.pool_id

		if type(pool_id) ~= "string" or pool_id == "" then
			pool_id = nil
		end

		local v10 = itemListFields(value2)

		if not (pool_id ~= nil or #v10 ~= 0) then
			continue
		end

		local sort_id = value2.sort_id
		local v11

		if sort_id == nil or sort_id == "" then
			warn(`Home SDUI cache entry "{v8}" has no sort_id; using its identifier`)
			v11 = v8
		else
			v11 = tostring(sort_id)
		end

		local v12 = topicIdToNumCacheItems[v11]

		if v12 == nil then
			continue
		end

		local clone = table.clone(value2)

		if pool_id == nil then
			for k2, v13 in v10 do
				local v14 = value2[v13]
				local v15 = math.max(v12.cap - v12.count, 0)
				local v16 = {}

				if v14 ~= nil then
					for i = 1, math.min(#v14, v15) do
						v16[i] = v14[i]
					end
				end

				v12.count += #v16
				clone[v13] = v16
			end
		else
			local v13 = (value.content_pools or {})[pool_id]

			if v13 == nil then
				continue
			end

			if clonesByPool_id[pool_id] == nil then
				local clone2 = table.clone(v13)

				local items = v13.items
				local v14 = math.max(v12.cap - v12.count, 0)
				local v15 = {}

				if items ~= nil then
					for i = 1, math.min(#items, v14) do
						v15[i] = items[i]
					end
				end

				clone2.items = v15
				v12.count += #clone2.items
				clonesByPool_id[pool_id] = clone2
			end
		end

		local clone2 = table.clone(v9)

		local input_data2 = v9.input_data
		local clone3 = table.clone(input_data2)

		clone3.kind = { type = input_data2.kind.type, value = clone }

		clone2.input_data = clone3
		clones[v8] = clone2
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

		local v6 = v5[k]
		local clones = {}

		for k2, v7 in item do
			if not (type(v7) == "table" and p2[tostring(k2)]) then
				continue
			end

			local clone2 = table.clone(v7)

			if v6 ~= nil then
				for k3, v8 in v6 do
					clone2[v8] = nil
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

	for k, v6 in cachedRobloxComponentToTemplateId do
		if clone2[v6] ~= nil then
			continue
		end

		local template = sduiTemplateStore.getTemplate(v6)

		if template ~= nil then
			clone2[v6] = templateEntry.new({ template = template, roblox_component = k })
		end
	end

	clone.templates = clone2
end

return {
	buildSduiHomePageCachePayload = function(p2)
		local topicIdToNumCacheItems = homeOmniFeedCache.getTopicIdToNumCacheItems()

		local clones = {}
		local v6 = {}

		for k, v7 in p2.page_entries or {} do
			local input_data = v7.input_data
			local kind = if input_data ~= nil then input_data.kind else nil
			local value = if kind ~= nil then kind.value else nil

			local v8 = type(value) == "table" and type(value.entry_map) == "table"

			if not v8 then
				continue
			end

			local v9 = pruneFeed(value, topicIdToNumCacheItems)

			if v9 == nil then
				continue
			end

			local clone = table.clone(v7)

			local input_data2 = v7.input_data
			local clone2 = table.clone(input_data2)

			clone2.kind = { type = input_data2.kind.type, value = v9 }

			clone.input_data = clone2
			table.insert(clones, clone)
			collectReferencedKeys(clone, v6)
		end

		if #clones == 0 then
			return nil
		end

		local clone = table.clone(p2)

		clone.page_entries = clones
		clone.hydration_data = pruneHydration(p2.hydration_data, v6)

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

			local v6 = type(value) == "table" and type(value.entry_map) == "table"

			if not v6 then
				continue
			end

			for k2, v7 in value.entry_map do
				local input_data2 = v7.input_data
				local kind2 = if input_data2 ~= nil then input_data2.kind else nil
				local value2 = if kind2 ~= nil then kind2.value else nil

				if type(value2) ~= "table" then
					continue
				end

				local pool_id = value2.pool_id

				if type(pool_id) ~= "string" or pool_id == "" then
					pool_id = nil
				end

				local v8 = itemListFields(value2)

				if not (pool_id ~= nil or #v8 ~= 0) then
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
						return value2[v8[1]]
					end

					local result = {}

					for k3, v9 in ((value.content_pools or {})[pool_id] or {}).items or {} do
						local kind3 = if v9 ~= nil then v9.kind else nil
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
