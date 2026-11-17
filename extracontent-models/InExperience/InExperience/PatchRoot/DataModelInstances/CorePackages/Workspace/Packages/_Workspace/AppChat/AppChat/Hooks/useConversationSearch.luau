local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(parent.DataHydration)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local GetConversationSearchDataHydration = require(AppChat.Stores.GetConversationSearchDataHydration)

local v = { query = "", items = {}, status = "Idle", nextCursor = nil }
local v2 = { query = "", pages = {} }

local function normalizeQuery(value: string?, flag: boolean)
	if not flag or value == nil then
		return ""
	end

	local v3 = string.match(value, "^%s*(.-)%s*$") or ""
	local v4 = utf8.len(v3) or #v3

	if v4 < 1 then
		return ""
	end

	if v4 > 200 then
		local v5 = utf8.offset(v3, 201)

		if v5 ~= nil then
			return (string.sub(v3, 1, v5 - 1))
		end
	end

	return v3
end

local function useConversationSearch(p: string?, flag: boolean?, p2: string?)
	local v3 = flag ~= false
	local conversationSearchDataHydration = GetConversationSearchDataHydration(false)
	local conversationStore = GetConversationStore(false)

	local query = normalizeQuery(p, v3)

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

	local state2, setState2 = React.useState(v2)
	local current = SignalsReact.useSignalState(conversationSearchDataHydration.getInvalidationGeneration)

	React.useEffect(function()
		if state == "" then
			setState2(v2)
			return
		end

		local page = conversationSearchDataHydration.fetchPage(state, nil, p2)

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
	end, { state, conversationSearchDataHydration, p2 })

	local ref = React.useRef(current)
	React.useEffect(function()
		if ref.current == current then
			return
		end

		ref.current = current

		for _, page in state2.pages do
			conversationSearchDataHydration.fetchPage(state2.query, page.cursor, p2)
		end
	end, { state2, conversationSearchDataHydration, current, p2 })

	local loadNext = React.useCallback(function()
		local pages = state2.pages
		local page = pages[#pages]

		if not (page ~= nil and page.result.status(false) == "Ready") then
			return
		end

		local data = page.result.data(false)
		local nextCursor

		if data == nil then
			nextCursor = nil
		else
			nextCursor = data.nextCursor
		end

		if nextCursor == nil then
			return
		end

		local page2 = conversationSearchDataHydration.fetchPage(state2.query, nextCursor, p2)

		if page2 == nil then
			return
		end

		setState2(function(p3)
			if p3.query ~= state2.query then
				return p3
			end

			local clone = table.clone(p3.pages)
			table.insert(clone, { result = page2, cursor = nextCursor })
			return { query = p3.query, pages = clone }
		end)
	end, { state2, conversationSearchDataHydration, p2 })

	local v4 = React.useMemo(function()
		return Signals.createComputed(function(p3)
			local function collectItems(pages)
				local matchedConversationIdSet = {}
				local matchedConversationIds = {}

				for _, item in pages do
					local data = item.result.data(p3)

					if not (data ~= nil and data.matchedConversationIds ~= nil) then
						continue
					end

					for _, matchedConversationId in data.matchedConversationIds do
						if matchedConversationIdSet[matchedConversationId] then
							continue
						end

						matchedConversationIdSet[matchedConversationId] = true
						table.insert(matchedConversationIds, matchedConversationId)
					end
				end

				local conversations = {}

				for _, v4 in matchedConversationIds do
					local conversation = conversationStore.getConversation(v4, p3)

					if conversation ~= nil then
						table.insert(conversations, conversation)
					end
				end

				return conversations
			end

			local pages = state2.pages

			if state2.query == "" or #pages == 0 then
				return v
			end

			local page = pages[#pages]
			local data = page.result.data(p3)
			local v4 = {
				query = state2.query,
				items = collectItems(pages),
				status = page.result.status(p3),
				nextCursor = 0
			}
			local nextCursor

			if data ~= nil then
				nextCursor = data.nextCursor
			end

			v4.nextCursor = nextCursor

			return v4
		end)
	end, { state2, conversationStore })

	local v5 = SignalsReact.useSignalState(v4)

	return {
		items = v5.items,
		status = v5.status,
		isActive = query ~= "",
		debouncedQuery = state,
		isFetching = v5.status == "NotReady",
		isAwaitingResults = query ~= "" and (v5.query ~= query or v5.status == "NotReady" or v5.status == "Idle"),
		hasError = v5.status == "Failed",
		hasSearched = v5.query ~= "",
		nextCursor = v5.nextCursor,
		loadNext = loadNext
	}
end

return useConversationSearch
