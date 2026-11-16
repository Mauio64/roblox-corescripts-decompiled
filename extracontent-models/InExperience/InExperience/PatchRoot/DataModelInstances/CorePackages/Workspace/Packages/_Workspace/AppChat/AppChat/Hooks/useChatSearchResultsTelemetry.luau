local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)

local ChatLandingTelemetryEvents = require(AppChat.Components.ChatLanding.ChatLandingTelemetryEvents)
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local ChatSearchResultType = require(AppChat.Analytics.Enums.ChatSearchResultType)
require(AppChat.Hooks.useConversationSearch)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)

local function useChatSearchResultsTelemetry(data, p: number?)
	local v = useTelemetry(ChatLandingTelemetryLayer.Context)
	local ref = React.useRef(v.emit)
	ref.current = v.emit
	local ref2 = React.useRef(nil)

	local ref3 = React.useRef({ query = "", startedAt = 0 })
	local ref4 = React.useRef({ query = "", startedAt = 0 })

	local debouncedQuery = data.debouncedQuery

	if ref4.current.query ~= debouncedQuery then
		ref3.current = {
			query = debouncedQuery,
			startedAt = debouncedQuery == "" and 0 or os.clock()
		}
	end

	React.useLayoutEffect(function()
		ref4.current = ref3.current
	end, { debouncedQuery })

	local searchResultCount = p == nil and #data.items or p
	local hasError = data.hasError
	local v2

	if debouncedQuery == "" then
		v2 = false
	else
		v2 = data.isActive and not data.isAwaitingResults
	end

	React.useEffect(function()
		if v2 then
			if ref2.current == debouncedQuery then
				return
			end

			ref2.current = debouncedQuery

			local current = ref.current
			local searchResultsRendered = ChatLandingTelemetryEvents.SearchResultsRendered
			local v3 = {
				searchResultCount = searchResultCount,
				searchResultType = 0,
				searchLatencyMs = 0
			}
			local searchResultType

			if hasError then
				searchResultType = ChatSearchResultType.Error
			elseif searchResultCount == 0 then
				searchResultType = ChatSearchResultType.NoResults
			else
				searchResultType = ChatSearchResultType.Results
			end

			v3.searchResultType = searchResultType

			v3.searchLatencyMs = math.round((os.clock() - ref4.current.startedAt) * 1000)
			current(searchResultsRendered, v3)
		elseif debouncedQuery == "" then
			ref2.current = nil
		end
	end, { v2, debouncedQuery, searchResultCount, hasError })
end

return useChatSearchResultsTelemetry
