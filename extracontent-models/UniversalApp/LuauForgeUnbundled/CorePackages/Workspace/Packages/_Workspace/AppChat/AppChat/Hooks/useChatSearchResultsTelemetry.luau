local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local ChatLandingTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLandingTelemetryEvents")
local ChatLandingTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatLandingTelemetryLayer")
local ChatSearchResultType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/Enums/ChatSearchResultType")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useConversationSearch")
local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")

local function useChatSearchResultsTelemetry(data, p2)
	local v5 = useTelemetry(ChatLandingTelemetryLayer.Context)
	local ref = React.useRef(v5.emit)
	ref.current = v5.emit
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

	local v6 = p2 == nil and #data.items or p2
	local hasError = data.hasError

	local v7 = not (debouncedQuery == "") and (data.isActive and not data.isAwaitingResults)

	React.useEffect(function()
		if v7 then
			if ref2.current == debouncedQuery then
				return
			end

			ref2.current = debouncedQuery

			local current = ref.current
			local searchResultsRendered = ChatLandingTelemetryEvents.SearchResultsRendered
			local v8 = {
				searchResultCount = v6,
				searchResultType = 0,
				searchLatencyMs = 0
			}

			local v9 = if hasError then ChatSearchResultType.Error elseif v6 == 0 then ChatSearchResultType.NoResults else ChatSearchResultType.Results
			v8.searchResultType = v9

			v8.searchLatencyMs = math.round((os.clock() - ref4.current.startedAt) * 1000)
			current(searchResultsRendered, v8)
		elseif debouncedQuery == "" then
			ref2.current = nil
		end
	end, { v7, debouncedQuery, v6, hasError })
end

return useChatSearchResultsTelemetry
