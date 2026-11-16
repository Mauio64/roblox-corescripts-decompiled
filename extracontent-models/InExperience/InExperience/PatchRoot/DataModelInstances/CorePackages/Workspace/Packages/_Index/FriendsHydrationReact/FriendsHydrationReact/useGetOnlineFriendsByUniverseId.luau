local parent = script:FindFirstAncestor("FriendsHydrationReact").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Signals = require(parent.Signals)
local DataHydration = require(parent.DataHydration)

local v = DataHydration.Friends.FriendsStore.get()

local function useGetOnlineFriendsByUniverseId(p: string)
	local v2 = React.useMemo(function()
		return v.GetOnlineFriendsByUniverseId(p)
	end, { p })

	local v3 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			return v2(p2)
		end)
	end, { v2 })

	local v4 = React.useMemo(function()
		return v.GetOnlineFriendsStatus()
	end, {})

	return SignalsReact.useSignalState(v3), (SignalsReact.useSignalState(v4))
end

return useGetOnlineFriendsByUniverseId
