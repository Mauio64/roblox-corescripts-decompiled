local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/DataHydration")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/SignalsReact")

require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Stores/createCanGiftStore")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/FindRecipientsResponseModel")
local getCanGiftStore = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Stores/getCanGiftStore")
local itemGiftabilityCacheKey = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Stores/itemGiftabilityCacheKey")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Types")

local dataStatus = DataHydration.DataStatus
local buildItemGiftabilityKey = itemGiftabilityCacheKey.buildItemGiftabilityKey

local v5 = {}

local v6 = {
	recipients = {},
	isLoading = false,
	isLoadingMore = false,
	hasFailed = false,
	nextCursor = nil
}

local function buildItemsSignature(current)
	if current == nil or #current == 0 then
		return nil
	end

	local v7 = {}

	for k, item in current do
		table.insert(v7, buildItemGiftabilityKey(item))
	end

	return table.concat(v7, ",")
end

local function requestPages(p2, current, p3, items, p4)
	local pages = {}
	local function requestPage(p5)
		local v7 = p4[#pages + 1]

		if v7 ~= nil and v7.query.cursor == p5 then
			table.insert(pages, v7)
			return
		end

		local v8 = { items = current, searchTerm = p3, cursor = p5 }
		table.insert(pages, { query = v8, result = p2.getAndFetchRecipients(v8) })
	end

	requestPage(nil)

	for k, item in items do
		requestPage(item)
	end

	return pages
end

local function createPagesSignal(list)
	return Signals.createComputed(function(p2)
		local recipients = {}
		local v7 = false
		local v8 = false
		local v9 = false
		local nextCursor = nil

		for k, item in list do
			local status = item.result.status(p2)
			local data = item.result.data(p2)

			if status == dataStatus.NotReady then
				if k == 1 then
					v7 = true
				else
					v8 = true
				end
			elseif status == dataStatus.Failed then
				v9 = true
			end

			if data ~= nil and status ~= dataStatus.Failed then
				for k2, recipient in data.recipients do
					table.insert(recipients, recipient)
				end
			end

			if k ~= #list then
				continue
			end

			nextCursor = if status == dataStatus.Ready and data ~= nil then data.nextCursor else nil
		end

		return {
			recipients = recipients,
			isLoading = v7,
			isLoadingMore = v8,
			hasFailed = v9,
			nextCursor = nextCursor
		}
	end)
end

local computed = Signals.createComputed(function()
	return v6
end)

local function useGiftRecipients(current, value)
	local v7 = getCanGiftStore(false)

	local v8 = value or ""
	local state, setState = React.useState(nil)

	local itemsSignature = buildItemsSignature(current)
	local formatted = ("%*\0%*"):format(itemsSignature or "", v8)
	local v9 = if state == nil or state.searchKey ~= formatted then v5 else state.cursors

	local ref = React.useRef(current)
	ref.current = current

	local ref2 = React.useRef(nil)
	local v10 = React.useMemo(function()
		local current2 = ref.current

		if current2 == nil or itemsSignature == nil then
			return {}
		end

		local current3 = ref2.current
		local v12 = requestPages(
			v7,
			current2,
			v8,
			v9,
			(current3 == nil or current3.searchKey ~= formatted) and {} or current3.pages
		)
		ref2.current = { searchKey = formatted, pages = v12 }
		return v12
	end, { v7, itemsSignature, v8, v9 })

	local v11 = React.useMemo(function()
		if #v10 == 0 then
			return computed
		end

		return createPagesSignal(v10)
	end, { v10 })

	local v12 = SignalsReact.useSignalState(v11)

	local nextCursor = v12.nextCursor
	local v13 = React.useCallback(function()
		if nextCursor == nil then
			return
		end

		local clone = table.clone(v9)
		table.insert(clone, nextCursor)
		setState({ searchKey = formatted, cursors = clone })
	end, { nextCursor, v9, formatted })

	local v14 = React.useCallback(function()
		for k, v15 in v10 do
			if v15.result.status(false) == dataStatus.Failed then
				v7.getAndFetchRecipients(v15.query)
			end
		end
	end, { v7, v10 })

	return {
		recipients = v12.recipients,
		isLoading = v12.isLoading,
		isLoadingMore = v12.isLoadingMore,
		hasFailed = v12.hasFailed,
		hasMore = nextCursor ~= nil,
		loadMore = v13,
		retry = v14
	}
end

return useGiftRecipients
