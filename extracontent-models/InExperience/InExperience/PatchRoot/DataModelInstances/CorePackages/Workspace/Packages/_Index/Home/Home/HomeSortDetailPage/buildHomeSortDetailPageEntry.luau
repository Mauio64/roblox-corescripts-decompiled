local Home = script:FindFirstAncestor("Home")
local parent = Home.Parent

local SduiSharedUtilities = require(parent.SduiSharedUtilities)

local HomeConstants = require(Home.HomeConstants)
local HomeSortDetailConstants = require(Home.HomeSortDetailPage.HomeSortDetailConstants)
local isHomeSortDetailSortIncluded = require(Home.HomeSortDetailPage.isHomeSortDetailSortIncluded)

local function readSortInputData(p) -- 2 equivalent calls inferred from this helper
	if typeof(p) ~= "table" then
		return nil
	end

	local input_data = p.input_data
	local kind

	if typeof(input_data) == "table" then
		kind = input_data.kind
	end

	if typeof(kind) == "table" and typeof(kind.value) == "table" then
		return kind.value
	end

	return nil
end

local function readSortInputDataType(p) -- 1 equivalent call inferred from this helper
	local input_data

	if typeof(p) == "table" then
		input_data = p.input_data
	end

	local kind

	if typeof(input_data) == "table" then
		kind = input_data.kind
	end

	if typeof(kind) == "table" and typeof(kind.type) == "string" then
		return kind.type
	end

	return nil
end

local function matchesSort(p, p2: string) -- 2 equivalent calls inferred from this helper
	local sortInputData = readSortInputData(p) -- inferred equivalent call
	local sort_id

	if sortInputData then
		sort_id = tostring(sortInputData.sort_id)
	end

	return sort_id ~= nil
		and sort_id ~= ""
		and isHomeSortDetailSortIncluded(sort_id, readSortInputDataType(p)) -- inferred equivalent call
		and sort_id == p2
end

local function findFeedEntry(entry_order, entry_map, p: string, p2: number?)
	if p2 ~= nil and p2 >= 1 and p2 % 1 == 0 then
		local item = entry_order[p2]
		local v

		if item ~= nil then
			v = entry_map[item]
		end

		if matchesSort(v, p) then -- inferred equivalent call
			return item, v
		end
	end

	for _, item in entry_order do
		local v = entry_map[item]

		if matchesSort(v, p) then -- inferred equivalent call
			return item, v
		end
	end

	return nil
end

local function selectHomeSortDetailFeedEntry(data, p: string, p2: number?)
	if typeof(data) ~= "table" then
		return nil
	end

	local entry_order = data.entry_order
	local entry_map = data.entry_map

	if typeof(entry_order) ~= "table" or typeof(entry_map) ~= "table" then
		return nil
	end

	local feedEntry, feedEntry2 = findFeedEntry(entry_order, entry_map, p, p2)

	if feedEntry == nil or feedEntry2 == nil then
		return nil
	end

	local roblox_component = feedEntry2.roblox_component

	if typeof(roblox_component) ~= "string" or roblox_component == "" then
		return nil
	end

	local inputData = readSortInputData(feedEntry2) -- inferred equivalent call

	if inputData == nil then
		return nil
	end

	return {
		identifier = feedEntry,
		feedEntry = feedEntry2,
		inputData = inputData,
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

local function getHomeInputData(sduiApiStore, p) -- 2 equivalent calls inferred from this helper
	local inputData = sduiApiStore.getInputData(HomeConstants.ConfigKey, HomeConstants.ContentIdentifier, p)

	if inputData == nil then
		return sduiApiStore.getInputData(HomeConstants.ConfigKey, nil, p)
	end

	return inputData
end

local function buildHomeSortDetailPageEntry(p: string, p2: number?)
	if p == "" then
		return nil
	end

	local sduiApiStore = SduiSharedUtilities.getSduiApiStore()

	if selectHomeSortDetailFeedEntry(getHomeInputData(sduiApiStore), p, p2) == nil then -- inferred equivalent call
		return nil
	end

	return {
		robloxComponentType = HomeSortDetailConstants.RobloxComponent,
		identifier = HomeSortDetailConstants.Identifier,
		componentInputDataGetter = function(p3)
			local v = selectHomeSortDetailFeedEntry(getHomeInputData(sduiApiStore, p3), p, p2) -- inferred equivalent call

			if v then
				return buildVerticalFeedInputData(v)
			end

			return {}
		end
	}
end

return buildHomeSortDetailPageEntry
