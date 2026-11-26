local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Promise")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseSearch")

local dataStatus = DataHydration.DataStatus
local useSignalState = SignalsReact.useSignalState

local v5 = {}

local function keyForSources(list)
	if list == nil then
		return nil
	end

	local v6 = table.create(#list)

	for k, item in list do
		v6[k] = item.key
	end

	return table.concat(v6, ";")
end

local function firstPages(sources)
	local result = {}

	for k in sources or {} do
		table.insert(result, { sourceIndex = k, cursor = "" })
	end

	return result
end

local function isPageRequested(items, p2): boolean
	for k, item in items do
		if item.sourceIndex == p2.sourceIndex and item.cursor == p2.cursor then
			return true
		end
	end

	return false
end

local function paramsForPage(p2, cursor)
	local clone = table.clone(p2.params)

	if cursor == "" then
		cursor = nil
	end

	clone.cursor = cursor
	return clone
end

local function refreshFirstPages(searchStore, sources)
	local v6 = table.create(#sources)

	for k, item in sources do
		local refreshSearch = searchStore.refreshSearch
		local clone = table.clone(item.params)
		clone.cursor = nil

		table.insert(v6, refreshSearch(clone))
	end

	return Promise.all(v6)
end

local function ignorePromiseRejection() end

local function useCursorSearchPages(p2)
	local searchStore = p2.searchStore
	local sources = p2.sources
	local joined

	if sources == nil then
		joined = nil
	else
		local v6 = table.create(#sources)

		for k, source in sources do
			v6[k] = source.key
		end

		joined = table.concat(v6, ";")
	end

	local state, setState = React.useState({
		sourcesKey = joined,
		pages = firstPages(sources)
	})

	if state.sourcesKey ~= joined then
		state = { sourcesKey = joined, pages = firstPages(sources) }

		setState(state)
	end

	local v6 = React.useMemo(function()
		local result = {}

		if sources == nil then
			return result
		end

		for k, page in state.pages do
			local source = sources[page.sourceIndex]
			local cursor = page.cursor
			local clone = table.clone(source.params)

			if cursor == "" then
				cursor = nil
			end

			clone.cursor = cursor

			table.insert(result, (searchStore.getSearch(clone)))
		end

		return result
	end, { state, searchStore, sources })

	local ref = React.useRef({ sources = sources, sourcesKey = joined })
	ref.current = { sources = sources, sourcesKey = joined }

	local ref2 = React.useRef(joined)

	local ref3 = React.useRef(nil)

	React.useEffect(function()
		local sources2 = ref.current.sources

		if sources2 == nil then
			ref2.current = nil
			return
		end

		if ref2.current == joined then
			return
		end

		ref2.current = joined

		local v7 = {
			sourcesKey = joined,
			load = refreshFirstPages(searchStore, sources2)
		}
		ref3.current = v7

		v7.load:catch(ignorePromiseRejection):finally(function()
			if ref3.current == v7 then
				ref3.current = nil
			end
		end)
	end, { searchStore, joined })

	local v8 = useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p3)
			local pages = state.pages

			local v8 = {}
			local idSet = {}

			for k, v9 in sources or {} do
				v8[k] = {
					items = {},
					seen = {},
					lastResponse = nil,
					lastPageIndex = nil,
					newItemCount = 0
				}
			end

			local v9 = false
			local v10 = nil
			local v11 = if #pages == 0 then dataStatus.Ready else dataStatus.NotReady
			local count = 0

			for k, v12 in v6 do
				local page = pages[k]
				local status = v12.status(p3)
				local v13 = page.cursor == ""

				if status == dataStatus.NotReady then
					v9 = v9 or not v13
				elseif status == dataStatus.Failed then
					if v13 then
						v11 = dataStatus.Failed
					else
						v10 = page
					end
				elseif v13 then
					count += 1
				end

				local data = v12.data(p3)

				if data == nil then
					continue
				end

				local v14 = v8[page.sourceIndex]
				v14.lastResponse = data
				v14.lastPageIndex = k
				local count2 = 0

				for k2, v15 in data.data or v5 do
					if not v14.seen[v15.id] then
						v14.seen[v15.id] = true
						count2 += 1
					end

					if idSet[v15.id] then
						continue
					end

					idSet[v15.id] = true
					table.insert(v14.items, v15)
				end

				v14.newItemCount = count2
			end

			if v11 ~= dataStatus.Failed and #pages > 0 and count == #(sources or {}) then
				v11 = dataStatus.Ready
			end

			local v12 = {}
			local v13 = nil

			for k, v14 in v8 do
				for k2, item in v14.items do
					table.insert(v12, item)
				end

				local lastPageIndex = v14.lastPageIndex
				local lastResponse = v14.lastResponse
				local nextCursor = if lastResponse ~= nil then lastResponse.nextCursor else nil

				if not (v13 == nil and lastPageIndex ~= nil and v6[lastPageIndex].status(p3) == dataStatus.Ready and nextCursor ~= nil) then
					continue
				end

				if not (nextCursor ~= "" and v14.newItemCount > 0) then
					continue
				end

				local v15 = { sourceIndex = k, cursor = nextCursor }
				local flag = true
				local v16

				for k2, page in pages do
					if page.sourceIndex == v15.sourceIndex and page.cursor == v15.cursor then
						v16 = true
						flag = false
						break
					end
				end

				if flag then
					v16 = false
				end

				if not v16 then
					v13 = { sourceIndex = k, cursor = nextCursor }
				end
			end

			return {
				sourcesKey = state.sourcesKey,
				items = v12,
				status = v11,
				nextPage = v13,
				isLoadingMore = v9,
				failedPage = v10
			}
		end)
	end, { v6, state, sources })))

	local v9 = not (sources == nil) and v8.sourcesKey ~= joined

	local ref4 = React.useRef({})

	local v10 = React.useCallback(function()
		if sources == nil or v9 or ref.current.sourcesKey ~= joined then
			return
		end

		local function loadPage(p3)
			local formatted = `{p3.sourceIndex}|{p3.cursor}|{joined}`

			if ref4.current[formatted] then
				return
			end

			ref4.current[formatted] = true

			local source = sources[p3.sourceIndex]
			local cursor = p3.cursor
			local clone = table.clone(source.params)

			if cursor == "" then
				cursor = nil
			end

			clone.cursor = cursor

			searchStore.getSearch(clone)
			searchStore.refreshSearch(clone):catch(ignorePromiseRejection):finally(function()
				ref4.current[formatted] = nil
			end)
		end

		local failedPage = v8.failedPage

		if failedPage ~= nil then
			loadPage(failedPage)
			return
		end

		local nextPage = v8.nextPage

		if v8.isLoadingMore or nextPage == nil then
			return
		end

		loadPage(nextPage)
		setState(function(p3)
			if p3.sourcesKey ~= joined then
				return p3
			end

			local v11 = nextPage
			local flag = true
			local v12

			for k, page in p3.pages do
				if page.sourceIndex == v11.sourceIndex and page.cursor == v11.cursor then
					v12 = true
					flag = false
					break
				end
			end

			if flag then
				v12 = false
			end

			if not v12 then
				local clone = table.clone(p3.pages)
				table.insert(clone, nextPage)
				return { sourcesKey = joined, pages = clone }
			end

			return p3
		end)
	end, { v9, v8, searchStore, sources, joined })

	local v11 = React.useCallback(function()
		local current = ref.current
		local sources2 = current.sources

		if sources2 == nil then
			return Promise.resolve()
		end

		setState({ sourcesKey = current.sourcesKey, pages = firstPages(sources2) })

		local current2 = ref3.current

		if current2 == nil or current2.sourcesKey ~= current.sourcesKey then
			return refreshFirstPages(searchStore, sources2)
		end

		return current2.load
	end, { searchStore })

	local v13 = if v9 then v5 else v8.items
	local v14

	if sources == nil then
		v14 = dataStatus.NotReady
	else
		v14 = if v9 then dataStatus.NotReady else v8.status
	end

	return {
		items = v13,
		status = v14,
		isLoadingMore = v8.isLoadingMore,
		failedLoadMore = v8.failedPage ~= nil,
		refresh = v11,
		loadMore = v10
	}
end

return useCursorSearchPages
