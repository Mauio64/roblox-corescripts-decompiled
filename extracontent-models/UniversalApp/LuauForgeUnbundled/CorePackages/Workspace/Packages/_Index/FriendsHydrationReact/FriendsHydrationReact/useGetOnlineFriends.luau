local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsHydrationReact/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsHydrationReact/SignalsReact")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsHydrationReact/Signals")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsHydrationReact/DataHydration").Friends.FriendsStore.get()

local function useGetOnlineFriends()
	local v6 = React.useMemo(function()
		return v5.GetOnlineFriends()
	end, {})

	local v7 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			return v6(p2)
		end)
	end, { v6 })

	local v8 = React.useMemo(function()
		return v5.GetOnlineFriendsStatus()
	end, {})

	return SignalsReact.useSignalState(v7), (SignalsReact.useSignalState(v8))
end

return useGetOnlineFriends
