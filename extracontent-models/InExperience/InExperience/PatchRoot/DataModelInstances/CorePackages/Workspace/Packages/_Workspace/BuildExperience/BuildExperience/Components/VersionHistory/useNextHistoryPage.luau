local parent = script:FindFirstAncestor("BuildExperience").Parent

require(parent.DataHydration.PlaceVersionHistory)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local function useNextHistoryPage(p, p2: number, p3)
	local nextCursor

	if p3 == nil or not p3.hasMore then
		nextCursor = nil
	else
		nextCursor = p3.nextCursor
	end

	local v = SignalsReact.useSignalState(p.getIsFetchingMoreHistory(p2))
	local state, setState = React.useState(nil)

	return React.useCallback(function()
		if nextCursor == nil or nextCursor == state or v then
			return
		end

		local v2 = nextCursor
		p.fetchMoreHistory(p2, v2):catch(function()
			setState(v2)
		end)
	end, { p, p2, nextCursor, state, v })
end

return useNextHistoryPage
