local parent = script:FindFirstAncestor("FriendsHydrationReact").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local DataHydration = require(parent.DataHydration)

local v = DataHydration.Friends.FriendsStore.get()

local function useGetAllFriends()
	local v2 = React.useMemo(function()
		return v.GetAllFriends()
	end, {})
	local v3 = React.useMemo(function()
		return v.GetAllFriendsStatus()
	end, {})

	return SignalsReact.useSignalState(v2), SignalsReact.useSignalState(v3), (React.useCallback(function()
		v.FetchMoreFriends()
	end, {}))
end

return useGetAllFriends
