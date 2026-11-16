local parent = script:FindFirstAncestor("FriendsHydrationReact").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Signals = require(parent.Signals)
local DataHydration = require(parent.DataHydration)

local v = DataHydration.Friends.FriendsStore.get()

local function useGetOnlineFriends()
	local v2 = React.useMemo(function()
		return v.GetOnlineFriends()
	end, {})

	local v3 = React.useMemo(function()
		return Signals.createComputed(function(p)
			return v2(p)
		end)
	end, { v2 })

	local v4 = React.useMemo(function()
		return v.GetOnlineFriendsStatus()
	end, {})

	return SignalsReact.useSignalState(v3), (SignalsReact.useSignalState(v4))
end

return useGetOnlineFriends
