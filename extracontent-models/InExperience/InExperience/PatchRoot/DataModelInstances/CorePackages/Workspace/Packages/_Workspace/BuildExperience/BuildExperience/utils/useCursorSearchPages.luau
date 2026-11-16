local parent = script:FindFirstAncestor("BuildExperience").Parent

local DataHydration = require(parent.DataHydration)
local Promise = require(parent.Promise)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

require(parent.DataHydration.UniverseSearch)

local DataStatus = DataHydration.DataStatus
local useSignalState = SignalsReact.useSignalState

local v = {}

local function keyForSources(sources) -- 1 equivalent call inferred from this helper
	if sources == nil then
		return nil
	end

	local v2 = table.create(#sources)

	for k, item in sources do
		v2[k] = item.key
	end

	return table.concat(v2, ";")
end

local function firstPages(sources)
	local result = {}

	for k in sources or {} do
		table.insert(result, { sourceIndex = k, cursor = "" })
	end

	return result
end

local function isPageRequested(pages, p): boolean -- 2 equivalent calls inferred from this helper
	for _, item in pages do
		if item.sourceIndex == p.sourceIndex and item.cursor == p.cursor then
			return true
		end
	end

	return false
end

local function paramsForPage(p, cursor: string) -- 2 equivalent calls inferred from this helper
	local clone = table.clone(p.params)

	if cursor == "" then
		cursor = nil
	end

	clone.cursor = cursor
	return clone
end

local function refreshFirstPages(searchStore, sources)
	local v2 = table.create(#sources)

	for _, item in sources do
		local refreshSearch = searchStore.refreshSearch
		local clone = table.clone(item.params)
		clone.cursor = nil

		table.insert(v2, refreshSearch(clone))
	end

	return Promise.all(v2)
end

local function ignorePromiseRejection() end

local function useCursorSearchPages(p)
	local searchStore = p.searchStore
	local sources = p.sources
	local v2 = keyForSources(sources) -- inferred equivalent call
	local state, setState = React.useState({ sourcesKey = v2, pages = firstPages(sources) })

	if state.sourcesKey ~= v2 then
		state = { sourcesKey = v2, pages = firstPages(sources) }

		setState(state)
	end

	local v3 = React.useMemo(function()
		local result = {}

		if sources ~= nil then
			for _, page in state.pages do
				local clone = paramsForPage(sources[page.sourceIndex], page.cursor) -- inferred equivalent call
				table.insert(result, (searchStore.getSearch(clone)))
			end
		end

		return result
	end, { state, searchStore, sources })

	local ref = React.useRef({ sources = sources, sourcesKey = v2 })
	ref.current = { sources = sources, sourcesKey = v2 }

	local ref2 = React.useRef(v2)

	local ref3 = React.useRef(nil)

	React.useEffect(function()
		local sources2 = ref.current.sources

		if sources2 == nil then
			ref2.current = nil
			return
		end

		if ref2.current == v2 then
			return
		end

		ref2.current = v2

		local current = {
			sourcesKey = v2,
			load = refreshFirstPages(searchStore, sources2)
		}
		ref3.current = current

		current.load:catch(ignorePromiseRejection):finally(function()
			if ref3.current == current then
				ref3.current = nil
			end
		end)
	end, { searchStore, v2 })

	local v4 = useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p2)
			local pages = state.pages

			local v4 = {}
			local idSet = {}

			for k, _ in sources or {} do
				v4[k] = {
					items = {},
					seen = {},
					lastResponse = nil,
					lastPageIndex = nil,
					newItemCount = 0
				}
			end

			local isLoadingMore = false
			local failedPage = nil
			local status2

			if #pages == 0 then
				status2 = DataStatus.Ready
			else
				status2 = DataStatus.NotReady
			end

			local count = 0

			for k, v5 in v3 do
				local page = pages[k]
				local status = v5.status(p2)
				local v6 = page.cursor == ""

				if status == DataStatus.NotReady then
					isLoadingMore = isLoadingMore or not v6
				elseif status == DataStatus.Failed then
					if v6 then
						status2 = DataStatus.Failed
					else
						failedPage = page
					end
				elseif v6 then
					count += 1
				end

				local data = v5.data(p2)

				if data == nil then
					continue
				end

				local v7 = v4[page.sourceIndex]
				v7.lastResponse = data
				v7.lastPageIndex = k
				local count2 = 0

				for _, v8 in data.data or v do
					if not v7.seen[v8.id] then
						v7.seen[v8.id] = true
						count2 += 1
					end

					if idSet[v8.id] then
						continue
					end

					idSet[v8.id] = true
					table.insert(v7.items, v8)
				end

				v7.newItemCount = count2
			end

			if status2 ~= DataStatus.Failed and #pages > 0 and count == #(sources or {}) then
				status2 = DataStatus.Ready
			end

			local items = {}
			local nextPage = nil

			for k, v5 in v4 do
				for _, item in v5.items do
					table.insert(items, item)
				end

				local lastPageIndex = v5.lastPageIndex
				local lastResponse = v5.lastResponse
				local nextCursor

				if lastResponse ~= nil then
					nextCursor = lastResponse.nextCursor
				end

				if not (nextPage == nil and lastPageIndex ~= nil and v3[lastPageIndex].status(p2) == DataStatus.Ready and nextCursor ~= nil) then
					continue
				end

				if
					nextCursor == ""
					or not (v5.newItemCount > 0)
					or isPageRequested(pages, { sourceIndex = k, cursor = nextCursor }) -- inferred equivalent call
				then
					continue
				end

				nextPage = { sourceIndex = k, cursor = nextCursor }
			end

			return {
				sourcesKey = state.sourcesKey,
				items = items,
				status = status2,
				nextPage = nextPage,
				isLoadingMore = isLoadingMore,
				failedPage = failedPage
			}
		end)
	end, { v3, state, sources })))
	local v5

	if sources == nil then
		v5 = false
	else
		v5 = v4.sourcesKey ~= v2
	end

	local ref4 = React.useRef({})

	local loadMore = React.useCallback(function()
		if sources == nil or v5 or ref.current.sourcesKey ~= v2 then
			return
		end

		local function loadPage(p2)
			local formatted = `{p2.sourceIndex}|{p2.cursor}|{v2}`

			if ref4.current[formatted] then
				return
			end

			ref4.current[formatted] = true

			local clone = paramsForPage(sources[p2.sourceIndex], p2.cursor) -- inferred equivalent call
			searchStore.getSearch(clone)
			searchStore.refreshSearch(clone):catch(ignorePromiseRejection):finally(function()
				ref4.current[formatted] = nil
			end)
		end

		local failedPage = v4.failedPage

		if failedPage ~= nil then
			loadPage(failedPage)
			return
		end

		local nextPage = v4.nextPage

		if v4.isLoadingMore or nextPage == nil then
			return
		end

		loadPage(nextPage)
		setState(function(p2)
			if p2.sourcesKey ~= v2 then
				return p2
			end

			if not isPageRequested(p2.pages, nextPage) then -- inferred equivalent call
				local clone = table.clone(p2.pages)
				table.insert(clone, nextPage)
				return { sourcesKey = v2, pages = clone }
			end

			return p2
		end)
	end, { v5, v4, searchStore, sources, v2 })

	local refresh = React.useCallback(function()
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

	local items = if v5 then v else v4.items
	local status

	if sources == nil then
		status = DataStatus.NotReady
	else
		status = if v5 then DataStatus.NotReady else v4.status
	end

	return {
		items = items,
		status = status,
		isLoadingMore = v4.isLoadingMore,
		failedLoadMore = v4.failedPage ~= nil,
		refresh = refresh,
		loadMore = loadMore
	}
end

return useCursorSearchPages
