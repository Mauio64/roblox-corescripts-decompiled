local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsHydrationReact/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsHydrationReact/SignalsReact")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsHydrationReact/Signals")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsHydrationReact/DataHydration")

local v5 = DataHydration.Friends.FriendsStore.get()
local dataStatus = DataHydration.DataStatus

local function useGetIsFriendWith(p2)
	local v6 = not p2 and "" or tostring(p2)

	local v7 = React.useMemo(function()
		if v6 == "" then
			return nil
		end

		return v5.GetIsFriendWith(v6)
	end, { v6 })

	local v8 = React.useMemo(function()
		return Signals.createComputed(function(p3)
			if v7 then
				return (v7.data(p3))
			end

			return nil
		end)
	end, { v7 })

	local v9 = React.useMemo(function()
		return Signals.createComputed(function(p3)
			if v7 then
				return (v7.status(p3))
			end

			return dataStatus.NotReady
		end)
	end, { v7 })

	return SignalsReact.useSignalState(v8), (SignalsReact.useSignalState(v9))
end

return useGetIsFriendWith
