require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/PlaceVersionHistory")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local function useNextHistoryPage(p2, p3, p4)
	local nextCursor = if not (p4 == nil or not p4.hasMore) then p4.nextCursor else nil
	local v5 = SignalsReact.useSignalState(p2.getIsFetchingMoreHistory(p3))
	local state, setState = React.useState(nil)

	return React.useCallback(function()
		if nextCursor == nil or nextCursor == state or v5 then
			return
		end

		local v6 = nextCursor
		p2.fetchMoreHistory(p3, v6):catch(function()
			setState(v6)
		end)
	end, { p2, p3, nextCursor, state, v5 })
end

return useNextHistoryPage
