require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")

local GetConversationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore")
local GetConversationSearchDataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationSearchDataHydration")

local v5 = { query = "", items = {}, status = "Idle", nextCursor = nil }
local v6 = { query = "", pages = {} }

local function normalizeQuery(value, p2)
	if not p2 or value == nil then
		return ""
	end

	local v7 = string.match(value, "^%s*(.-)%s*$") or ""
	local v8 = utf8.len(v7) or #v7

	if v8 < 1 then
		return ""
	end

	if v8 > 200 then
		local v9 = utf8.offset(v7, 201)

		if v9 ~= nil then
			return (string.sub(v7, 1, v9 - 1))
		end
	end

	return v7
end

local function useConversationSearch(p2, p3)
	local v7 = p3 ~= false
	local v8 = GetConversationSearchDataHydration(false)
	local v9 = GetConversationStore(false)

	local query = normalizeQuery(p2, v7)

	local state, setState = React.useState("")

	React.useEffect(function()
		if query == "" then
			setState("")
		else
			local thread = task.delay(0.15, function()
				setState(query)
			end)

			return function()
				task.cancel(thread)
			end
		end
	end, { query })

	local state2, setState2 = React.useState(v6)
	local v10 = SignalsReact.useSignalState(v8.getInvalidationGeneration)

	React.useEffect(function()
		if state == "" then
			setState2(v6)
			return
		end

		local page = v8.fetchPage(state)

		if page == nil then
			setState2({ query = state, pages = {} })
		else
			setState2({
				query = state,
				pages = {
					{ result = page }
				}
			})
		end
	end, { state, v8 })

	local ref = React.useRef(v10)
	React.useEffect(function()
		if ref.current == v10 then
			return
		end

		ref.current = v10

		for k, page in state2.pages do
			v8.fetchPage(state2.query, page.cursor)
		end
	end, { state2, v8, v10 })

	local v11 = React.useCallback(function()
		local pages = state2.pages
		local page = pages[#pages]

		if not (page ~= nil and page.result.status(false) == "Ready") then
			return
		end

		local data = page.result.data(false)
		local nextCursor = if data ~= nil then data.nextCursor else nil

		if nextCursor == nil then
			return
		end

		local page2 = v8.fetchPage(state2.query, nextCursor)

		if page2 == nil then
			return
		end

		setState2(function(p4)
			if p4.query ~= state2.query then
				return p4
			end

			local clone = table.clone(p4.pages)
			table.insert(clone, { result = page2, cursor = nextCursor })
			return { query = p4.query, pages = clone }
		end)
	end, { state2, v8 })

	local v12 = React.useMemo(function()
		return Signals.createComputed(function(p4)
			local function collectItems(pages)
				local matchedConversationIdSet = {}
				local matchedConversationIds = {}

				for k, item in pages do
					local data = item.result.data(p4)

					if not (data ~= nil and data.matchedConversationIds ~= nil) then
						continue
					end

					for k2, matchedConversationId in data.matchedConversationIds do
						if matchedConversationIdSet[matchedConversationId] then
							continue
						end

						matchedConversationIdSet[matchedConversationId] = true
						table.insert(matchedConversationIds, matchedConversationId)
					end
				end

				local conversations = {}

				for k, v13 in matchedConversationIds do
					local conversation = v9.getConversation(v13, p4)

					if conversation ~= nil then
						table.insert(conversations, conversation)
					end
				end

				return conversations
			end

			local pages = state2.pages

			if state2.query == "" or #pages == 0 then
				return v5
			end

			local page = pages[#pages]
			local data = page.result.data(p4)
			local v13 = {
				query = state2.query,
				items = collectItems(pages),
				status = page.result.status(p4),
				nextCursor = 0
			}
			local v14 = if data ~= nil then data.nextCursor else nil
			v13.nextCursor = v14

			return v13
		end)
	end, { state2, v9 })

	local v13 = SignalsReact.useSignalState(v12)

	return {
		items = v13.items,
		status = v13.status,
		isActive = query ~= "",
		debouncedQuery = state,
		isFetching = v13.status == "NotReady",
		isAwaitingResults = query ~= "" and (v13.query ~= query or v13.status == "NotReady" or v13.status == "Idle"),
		hasError = v13.status == "Failed",
		hasSearched = v13.query ~= "",
		nextCursor = v13.nextCursor,
		loadNext = v11
	}
end

return useConversationSearch
