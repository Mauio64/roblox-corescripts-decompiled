local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsHydrationReact/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsHydrationReact/SignalsReact")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsHydrationReact/DataHydration").Friends.FriendsStore.get()

local function useGetAllFriends()
	local v6 = React.useMemo(function()
		return v5.GetAllFriends()
	end, {})
	local v7 = React.useMemo(function()
		return v5.GetAllFriendsStatus()
	end, {})

	return SignalsReact.useSignalState(v6), SignalsReact.useSignalState(v7), (React.useCallback(function()
		v5.FetchMoreFriends()
	end, {}))
end

return useGetAllFriends
