local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/DataHydration")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SignalsReact")
local FriendsRequests = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/DataHydration/FriendsRequests")

local v5 = DataHydration.Friends.FriendsStore.get()
local v6 = FriendsRequests.FriendsRequestsStore.get()

local v7 = { skipFetch = true }

local function useGetFriendRequests(p2)
	local v8 = React.useMemo(function()
		if p2 == false then
			return nil
		end

		return (v6.getFriendsRequests())
	end, { p2 })

	local v9 = React.useMemo(function()
		return Signals.createComputed(function(p3)
			local v10 = if v8 then v8.data(p3) else nil

			if not v10 then
				return {}
			end

			local requests = {}

			for k, request in v10.requests do
				local friendshipStatus = v5.GetFriendshipStatus(request.id, v7)
				local v11 = if friendshipStatus then friendshipStatus.data(p3) else nil

				if v11 == nil or v11 == Enum.FriendStatus.FriendRequestReceived then
					table.insert(requests, request)
				end
			end

			return requests
		end)
	end, { v8 })
	return SignalsReact.useSignalState(v9)
end

return useGetFriendRequests
