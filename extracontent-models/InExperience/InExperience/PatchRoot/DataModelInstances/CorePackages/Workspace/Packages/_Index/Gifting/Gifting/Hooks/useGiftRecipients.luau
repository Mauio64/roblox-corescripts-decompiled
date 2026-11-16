local Gifting = script:FindFirstAncestor("Gifting")
local parent = Gifting.Parent

local DataHydration = require(parent.DataHydration)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

require(Gifting.Stores.createCanGiftStore)
require(Gifting.Models.FindRecipientsResponseModel)
local getCanGiftStore = require(Gifting.Stores.getCanGiftStore)
local itemGiftabilityCacheKey = require(Gifting.Stores.itemGiftabilityCacheKey)
require(Gifting.Types)

local DataStatus = DataHydration.DataStatus
local buildItemGiftabilityKey = itemGiftabilityCacheKey.buildItemGiftabilityKey

local v = {}

local v2 = {
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

	local v3 = {}

	for _, item in current do
		table.insert(v3, buildItemGiftabilityKey(item))
	end

	return table.concat(v3, ",")
end

local function requestPages(canGiftStore, current, searchTerm: string, items, p)
	local pages = {}
	local function requestPage(cursor: string?)
		local v3 = p[#pages + 1]

		if v3 ~= nil and v3.query.cursor == cursor then
			table.insert(pages, v3)
			return
		end

		local query = { items = current, searchTerm = searchTerm, cursor = cursor }
		table.insert(pages, {
			query = query,
			result = canGiftStore.getAndFetchRecipients(query)
		})
	end

	requestPage(nil)

	for _, item in items do
		requestPage(item)
	end

	return pages
end

local function createPagesSignal(list)
	return Signals.createComputed(function(p)
		local recipients = {}
		local isLoading = false
		local isLoadingMore = false
		local hasFailed = false
		local nextCursor = nil

		for k, item in list do
			local status = item.result.status(p)
			local data = item.result.data(p)

			if status == DataStatus.NotReady then
				if k == 1 then
					isLoading = true
				else
					isLoadingMore = true
				end
			elseif status == DataStatus.Failed then
				hasFailed = true
			end

			if data ~= nil and status ~= DataStatus.Failed then
				for _, recipient in data.recipients do
					table.insert(recipients, recipient)
				end
			end

			if k ~= #list then
				continue
			end

			if status == DataStatus.Ready and data ~= nil then
				nextCursor = data.nextCursor
			else
				nextCursor = nil
			end
		end

		return {
			recipients = recipients,
			isLoading = isLoading,
			isLoadingMore = isLoadingMore,
			hasFailed = hasFailed,
			nextCursor = nextCursor
		}
	end)
end

local computed = Signals.createComputed(function()
	return v2
end)

local function useGiftRecipients(current, value: string?)
	local canGiftStore = getCanGiftStore(false)

	local searchTerm = value or ""
	local state, setState = React.useState(nil)

	local itemsSignature = buildItemsSignature(current)
	local formatted = ("%*\0%*"):format(itemsSignature or "", searchTerm)
	local v3

	if state == nil or state.searchKey ~= formatted then
		v3 = v
	else
		v3 = state.cursors
	end

	local ref = React.useRef(current)
	ref.current = current

	local ref2 = React.useRef(nil)
	local v4 = React.useMemo(function()
		local current2 = ref.current

		if current2 == nil or itemsSignature == nil then
			return {}
		end

		local current3 = ref2.current
		local pages = requestPages(
			canGiftStore,
			current2,
			searchTerm,
			v3,
			(current3 == nil or current3.searchKey ~= formatted) and {} or current3.pages
		)
		ref2.current = { searchKey = formatted, pages = pages }
		return pages
	end, { canGiftStore, itemsSignature, searchTerm, v3 })

	local v5 = React.useMemo(function()
		if #v4 == 0 then
			return computed
		end

		return createPagesSignal(v4)
	end, { v4 })

	local v6 = SignalsReact.useSignalState(v5)

	local nextCursor = v6.nextCursor
	local loadMore = React.useCallback(function()
		if nextCursor == nil then
			return
		end

		local clone = table.clone(v3)
		table.insert(clone, nextCursor)
		setState({ searchKey = formatted, cursors = clone })
	end, { nextCursor, v3, formatted })

	local retry = React.useCallback(function()
		for _, v7 in v4 do
			if v7.result.status(false) == DataStatus.Failed then
				canGiftStore.getAndFetchRecipients(v7.query)
			end
		end
	end, { canGiftStore, v4 })

	return {
		recipients = v6.recipients,
		isLoading = v6.isLoading,
		isLoadingMore = v6.isLoadingMore,
		hasFailed = v6.hasFailed,
		hasMore = nextCursor ~= nil,
		loadMore = loadMore,
		retry = retry
	}
end

return useGiftRecipients
