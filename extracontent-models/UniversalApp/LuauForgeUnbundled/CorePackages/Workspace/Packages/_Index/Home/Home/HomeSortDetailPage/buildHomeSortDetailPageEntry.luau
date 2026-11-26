local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SduiSharedUtilities")

local HomeConstants = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomeConstants")
local HomeSortDetailConstants = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomeSortDetailPage/HomeSortDetailConstants")
local isHomeSortDetailSortIncluded = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomeSortDetailPage/isHomeSortDetailSortIncluded")

local function readSortInputData(p2)
	if typeof(p2) ~= "table" then
		return nil
	end

	local input_data = p2.input_data
	local kind = if typeof(input_data) == "table" then input_data.kind else nil

	if typeof(kind) == "table" and typeof(kind.value) == "table" then
		return kind.value
	end

	return nil
end

local function readSortInputDataType(p2)
	local input_data = if typeof(p2) == "table" then p2.input_data else nil
	local kind = if typeof(input_data) == "table" then input_data.kind else nil

	if typeof(kind) == "table" and typeof(kind.type) == "string" then
		return kind.type
	end

	return nil
end

local function matchesSort(p2, p3)
	local value

	if typeof(p2) == "table" then
		local input_data = p2.input_data
		local kind = if typeof(input_data) == "table" then input_data.kind else nil

		if typeof(kind) == "table" and typeof(kind.value) == "table" then
			value = kind.value
		end
	end

	local sort_id = if value then tostring(value.sort_id) else nil
	local v5

	if sort_id == nil or sort_id == "" then
		v5 = false
	else
		local input_data = if typeof(p2) == "table" then p2.input_data else nil
		local kind = if typeof(input_data) == "table" then input_data.kind else nil
		local v7 = if typeof(kind) == "table" and typeof(kind.type) == "string" then kind.type else nil

		v5 = isHomeSortDetailSortIncluded(sort_id, v7) and sort_id == p3
	end

	return v5
end

local function findFeedEntry(entry_order, entry_map, p2, p3)
	if p3 ~= nil and p3 >= 1 and p3 % 1 == 0 then
		local item = entry_order[p3]
		local v5 = if item ~= nil then entry_map[item] else nil
		local value

		if typeof(v5) == "table" then
			local input_data = v5.input_data
			local kind = if typeof(input_data) == "table" then input_data.kind else nil

			if typeof(kind) == "table" and typeof(kind.value) == "table" then
				value = kind.value
			end
		end

		local sort_id = if value then tostring(value.sort_id) else nil
		local v6

		if sort_id == nil or sort_id == "" then
			v6 = false
		else
			local input_data = if typeof(v5) == "table" then v5.input_data else nil
			local kind = if typeof(input_data) == "table" then input_data.kind else nil
			local v8 = if typeof(kind) == "table" and typeof(kind.type) == "string" then kind.type else nil

			v6 = isHomeSortDetailSortIncluded(sort_id, v8) and sort_id == p2
		end

		if v6 then
			return item, v5
		end
	end

	for k, item in entry_order do
		local v5 = entry_map[item]
		local value

		if typeof(v5) == "table" then
			local input_data = v5.input_data
			local kind = if typeof(input_data) == "table" then input_data.kind else nil

			if typeof(kind) == "table" and typeof(kind.value) == "table" then
				value = kind.value
			end
		end

		local sort_id = if value then tostring(value.sort_id) else nil
		local v6

		if sort_id == nil or sort_id == "" then
			v6 = false
		else
			local input_data = if typeof(v5) == "table" then v5.input_data else nil
			local kind = if typeof(input_data) == "table" then input_data.kind else nil
			local v8 = if typeof(kind) == "table" and typeof(kind.type) == "string" then kind.type else nil

			v6 = isHomeSortDetailSortIncluded(sort_id, v8) and sort_id == p2
		end

		if v6 then
			return item, v5
		end
	end

	return nil
end

local function selectHomeSortDetailFeedEntry(data, p2, p3)
	if typeof(data) ~= "table" then
		return nil
	end

	local entry_order = data.entry_order
	local entry_map = data.entry_map

	if typeof(entry_order) ~= "table" or typeof(entry_map) ~= "table" then
		return nil
	end

	local feedEntry, v5 = findFeedEntry(entry_order, entry_map, p2, p3)

	if feedEntry == nil or v5 == nil then
		return nil
	end

	local roblox_component = v5.roblox_component

	if typeof(roblox_component) ~= "string" or roblox_component == "" then
		return nil
	end

	local value

	if typeof(v5) == "table" then
		local input_data = v5.input_data
		local kind = if typeof(input_data) == "table" then input_data.kind else nil

		if typeof(kind) == "table" and typeof(kind.value) == "table" then
			value = kind.value
		end
	end

	if value == nil then
		return nil
	end

	return {
		identifier = feedEntry,
		feedEntry = v5,
		inputData = value,
		contentPools = data.content_pools or {}
	}
end

local function buildVerticalFeedInputData(data)
	local clone = table.clone(data.inputData)
	clone.entry_order = { HomeSortDetailConstants.DropDownIdentifier, data.identifier }

	clone.entry_map = {
		[HomeSortDetailConstants.DropDownIdentifier] = {
			roblox_component = HomeSortDetailConstants.DropDownRobloxComponent
		},
		[data.identifier] = data.feedEntry
	}

	clone.content_pools = data.contentPools
	return clone
end

local function getHomeInputData(p2, p3)
	local inputData = p2.getInputData(HomeConstants.ConfigKey, HomeConstants.ContentIdentifier, p3)

	if inputData == nil then
		return p2.getInputData(HomeConstants.ConfigKey, nil, p3)
	end

	return inputData
end

local function buildHomeSortDetailPageEntry(p2, p3)
	if p2 == "" then
		return nil
	end

	local sduiApiStore = SduiSharedUtilities.getSduiApiStore()
	local v6 = sduiApiStore.getInputData(HomeConstants.ConfigKey, HomeConstants.ContentIdentifier, nil)

	if v6 == nil then
		v6 = sduiApiStore.getInputData(HomeConstants.ConfigKey, nil, nil)
	end

	if selectHomeSortDetailFeedEntry(v6, p2, p3) == nil then
		return nil
	end

	return {
		robloxComponentType = HomeSortDetailConstants.RobloxComponent,
		identifier = HomeSortDetailConstants.Identifier,
		componentInputDataGetter = function(p4)
			local v8 = sduiApiStore
			local v9 = v8.getInputData(HomeConstants.ConfigKey, HomeConstants.ContentIdentifier, p4)

			if v9 == nil then
				v9 = v8.getInputData(HomeConstants.ConfigKey, nil, p4)
			end

			local v10 = selectHomeSortDetailFeedEntry(v9, p2, p3)

			if v10 then
				return buildVerticalFeedInputData(v10)
			end

			return {}
		end
	}
end

return buildHomeSortDetailPageEntry
