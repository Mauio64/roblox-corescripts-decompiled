local parent = script:FindFirstAncestor("SocialCarousel").Parent

local DataHydration = require(parent.DataHydration)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local FriendsRequests = require(parent.DataHydration.FriendsRequests)

local v = DataHydration.Friends.FriendsStore.get()
local v2 = FriendsRequests.FriendsRequestsStore.get()

local v3 = { skipFetch = true }

local function useGetFriendRequests(flag: boolean?)
	local v4 = React.useMemo(function()
		if flag == false then
			return nil
		end

		return (v2.getFriendsRequests())
	end, { flag })

	local v5 = React.useMemo(function()
		return Signals.createComputed(function(p)
			local v5

			if v4 then
				v5 = v4.data(p)
			end

			if not v5 then
				return {}
			end

			local requests = {}

			for _, request in v5.requests do
				local friendshipStatus = v.GetFriendshipStatus(request.id, v3)
				local v6

				if friendshipStatus then
					v6 = friendshipStatus.data(p)
				end

				if v6 == nil or v6 == Enum.FriendStatus.FriendRequestReceived then
					table.insert(requests, request)
				end
			end

			return requests
		end)
	end, { v4 })
	return SignalsReact.useSignalState(v5)
end

return useGetFriendRequests
