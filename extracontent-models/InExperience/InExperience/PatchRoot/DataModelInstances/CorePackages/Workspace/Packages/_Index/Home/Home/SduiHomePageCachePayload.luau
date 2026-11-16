local parent = script:FindFirstAncestor("Home").Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local DiscoveryUtils = require(parent.DiscoveryUtils)
local HomeOmniFeedCache = DiscoveryUtils.HomeOmniFeedCache
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local getSduiTemplateStore = SduiSharedUtilities.getSduiTemplateStore

local v = {
	universe = { "player_count" }
}

local function cloneMessage(p) -- 11 equivalent calls inferred from this helper
	return table.clone(p)
end

local function readInputValue(p) -- 5 equivalent calls inferred from this helper
	local kind

	if p ~= nil then
		kind = p.kind
	end

	return if kind ~= nil then kind.value else nil
end

local function replaceInputValue(input_data, p) -- 2 equivalent calls inferred from this helper
	local message = cloneMessage(input_data) -- inferred equivalent call
	message.kind = { type = input_data.kind.type, value = p }
	return message
end

local function isFeed(p): boolean -- 2 equivalent calls inferred from this helper
	return type(p) == "table" and type(p.entry_map) == "table"
end

local function itemListFields(items)
	local result = {}

	for k, item in items do
		if not (type(item) == "table" and #item > 0 and type(item[1]) == "table") then
			continue
		end

		table.insert(result, k)
	end

	table.sort(result)
	return result
end

local function readPoolId(p) -- 2 equivalent calls inferred from this helper
	local pool_id = p.pool_id

	if type(pool_id) == "string" and pool_id ~= "" then
		return pool_id
	end

	return nil
end

local function takeItems(list, p: number) -- 2 equivalent calls inferred from this helper
	local result = {}

	if list == nil then
		return result
	end

	for i = 1, math.min(#list, p) do
		result[i] = list[i]
	end

	return result
end

local function readSortId(p: string, p2) -- 2 equivalent calls inferred from this helper
	local sort_id = p2.sort_id

	if sort_id ~= nil and sort_id ~= "" then
		return (tostring(sort_id))
	end

	warn(`Home SDUI cache entry "{p}" has no sort_id; using its identifier`)
	return p
end

local function collectReferencedKeys(message, p)
	local typeName = type(message)

	if typeName == "table" then
		for _, item in message do
			collectReferencedKeys(item, p)
		end
	elseif typeName == "string" or typeName == "number" then
		p[tostring(message)] = true
	end
end

local function filterOrder(items, p)
	local result = {}

	if items == nil then
		return result
	end

	for _, item in items do
		if p[item] ~= nil then
			table.insert(result, item)
		end
	end

	return result
end

local function filterOrderMap(entry_order_map, messages)
	local messages2 = {}

	if entry_order_map == nil then
		return messages2
	end

	for k, item in entry_order_map do
		local items = filterOrder(item.items, messages)

		if not (#items > 0) then
			continue
		end

		local message = cloneMessage(item) -- inferred equivalent call
		message.items = items
		messages2[k] = message
	end

	return messages2
end

local function pruneFeed(data, topicIdToNumCacheItems)
	local messages = {}
	local messages2 = {}

	local v2 = {}
	local set = {}

	if data.entry_order ~= nil then
		for _, v3 in data.entry_order do
			if set[v3] then
				continue
			end

			set[v3] = true
			table.insert(v2, v3)
		end
	end

	local v3 = {}

	for k in data.entry_map do
		if set[k] then
			continue
		end

		set[k] = true
		table.insert(v3, k)
	end

	table.sort(v3)

	for _, v4 in v3 do
		table.insert(v2, v4)
	end

	for _, v4 in v2 do
		local v5 = data.entry_map[v4]

		if v5 == nil then
			continue
		end

		local inputValue = readInputValue(v5.input_data) -- inferred equivalent call

		if type(inputValue) ~= "table" then
			continue
		end

		local pool_id = readPoolId(inputValue) -- inferred equivalent call
		local v6 = itemListFields(inputValue)

		if not (pool_id ~= nil or #v6 ~= 0) then
			continue
		end

		local v7 = topicIdToNumCacheItems[readSortId(v4, inputValue)] -- inferred equivalent call

		if v7 == nil then
			continue
		end

		local message = cloneMessage(inputValue) -- inferred equivalent call

		if pool_id == nil then
			for _, v8 in v6 do
				local result = takeItems(inputValue[v8], math.max(v7.cap - v7.count, 0)) -- inferred equivalent call
				v7.count += #result
				message[v8] = result
			end
		else
			local v8 = (data.content_pools or {})[pool_id]

			if v8 == nil then
				continue
			end

			if messages2[pool_id] == nil then
				local message2 = cloneMessage(v8) -- inferred equivalent call
				message2.items = takeItems(v8.items, math.max(v7.cap - v7.count, 0)) -- inferred equivalent call
				v7.count += #message2.items
				messages2[pool_id] = message2
			end
		end

		local message2 = cloneMessage(v5) -- inferred equivalent call
		message2.input_data = replaceInputValue(v5.input_data, message) -- inferred equivalent call
		messages[v4] = message2
	end

	if next(messages) == nil then
		return nil
	end

	local message = cloneMessage(data) -- inferred equivalent call
	message.entry_map = messages

	if data.content_pools ~= nil then
		message.content_pools = messages2
	end

	if data.entry_order ~= nil then
		message.entry_order = filterOrder(data.entry_order, messages)
	end

	if data.entry_order_map ~= nil then
		message.entry_order_map = filterOrderMap(data.entry_order_map, messages)
	end

	return message
end

local function pruneHydration(hydration_data, p)
	if hydration_data == nil then
		return nil
	end

	local message = cloneMessage(hydration_data) -- inferred equivalent call

	for k, item in hydration_data do
		if type(item) ~= "table" then
			continue
		end

		local v2 = v[k]
		local messages = {}

		for k2, v3 in item do
			if not (type(v3) == "table" and p[tostring(k2)]) then
				continue
			end

			local message2 = cloneMessage(v3) -- inferred equivalent call

			if v2 ~= nil then
				for _, v4 in v2 do
					message2[v4] = nil
				end
			end

			messages[k2] = message2
		end

		message[k] = messages
	end

	return message
end

local function fillMissingTemplatesFromStore(message)
	local sduiTemplateStore = getSduiTemplateStore()
	local cachedRobloxComponentToTemplateId = sduiTemplateStore.getCachedRobloxComponentToTemplateId(AppPage.Home)

	if next(cachedRobloxComponentToTemplateId) == nil then
		return
	end

	local message2 = cloneMessage(message.templates or {}) -- inferred equivalent call
	local ServiceContractsProto = require(parent.ServiceContractsProto)
	local templateEntry = ServiceContractsProto.apppageplatform.shared.template_entry.TemplateEntry

	for k, v2 in cachedRobloxComponentToTemplateId do
		if message2[v2] ~= nil then
			continue
		end

		local template = sduiTemplateStore.getTemplate(v2)

		if template ~= nil then
			message2[v2] = templateEntry.new({ template = template, roblox_component = k })
		end
	end

	message.templates = message2
end

local function deserializeSduiHomePageCache(p: string?) -- 1 equivalent call inferred from this helper
	if p == nil then
		return nil
	end

	local ServiceContractsProto = require(parent.ServiceContractsProto)
	local deserializeBuffer = ServiceContractsProto.proto.json.deserializeBuffer(p)
	return ServiceContractsProto.apppageplatform.home.home_page.HomePageResponse.decode(deserializeBuffer)
end

local SduiHomePageCachePayload = {}

function SduiHomePageCachePayload.buildSduiHomePageCachePayload(p)
	local topicIdToNumCacheItems = HomeOmniFeedCache.getTopicIdToNumCacheItems()

	local messages = {}
	local v2 = {}

	for _, v3 in p.page_entries or {} do
		local inputValue = readInputValue(v3.input_data) -- inferred equivalent call

		if not isFeed(inputValue) then -- inferred equivalent call
			continue
		end

		local v4 = pruneFeed(inputValue, topicIdToNumCacheItems)

		if v4 == nil then
			continue
		end

		local message = cloneMessage(v3) -- inferred equivalent call
		message.input_data = replaceInputValue(v3.input_data, v4) -- inferred equivalent call
		table.insert(messages, message)
		collectReferencedKeys(message, v2)
	end

	if #messages == 0 then
		return nil
	end

	local message = cloneMessage(p) -- inferred equivalent call
	message.page_entries = messages
	message.hydration_data = pruneHydration(p.hydration_data, v2)

	message.request_id = ""
	fillMissingTemplatesFromStore(message)
	return message
end

function SduiHomePageCachePayload.serializeSduiHomePageCache(object)
	local ServiceContractsProto = require(parent.ServiceContractsProto)
	return ServiceContractsProto.proto.json.serializeBuffer(object:encode())
end

SduiHomePageCachePayload.deserializeSduiHomePageCache = deserializeSduiHomePageCache

function SduiHomePageCachePayload.getSduiHomePageItemsForSortId(p: string)
	local v2 = deserializeSduiHomePageCache(HomeOmniFeedCache.getCachedSduiHomePageData()) -- inferred equivalent call

	if v2 == nil then
		return nil
	end

	for _, page_entry in v2.page_entries do
		local inputValue = readInputValue(page_entry.input_data) -- inferred equivalent call

		if not isFeed(inputValue) then -- inferred equivalent call
			continue
		end

		for k, v3 in inputValue.entry_map do
			local inputValue2 = readInputValue(v3.input_data) -- inferred equivalent call

			if type(inputValue2) ~= "table" then
				continue
			end

			local pool_id = readPoolId(inputValue2) -- inferred equivalent call
			local v4 = itemListFields(inputValue2)

			if not (pool_id ~= nil or #v4 ~= 0) then
				continue
			end

			k = readSortId(k, inputValue2) -- inferred equivalent call

			if k == p then
				if pool_id == nil then
					return inputValue2[v4[1]]
				end

				local result = {}

				for _, v5 in ((inputValue.content_pools or {})[pool_id] or {}).items or {} do
					local inputValue3 = readInputValue(v5) -- inferred equivalent call

					if inputValue3 ~= nil then
						table.insert(result, inputValue3)
					end
				end

				return result
			end
		end
	end

	return nil
end

return SduiHomePageCachePayload
