local parent = script:FindFirstAncestor("FriendsHydrationReact").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Signals = require(parent.Signals)
local DataHydration = require(parent.DataHydration)

local v = DataHydration.Friends.FriendsStore.get()
local DataStatus = DataHydration.DataStatus

local function useGetFriendsCountByUserId(p: string?, p2)
	local v2 = not p and "" or tostring(p)

	local v3 = React.useMemo(function()
		if v2 == "" then
			return nil
		end

		return v.GetFriendsCountByUserId(v2, p2)
	end, { v2, p2 })

	local v4 = React.useMemo(function()
		return Signals.createComputed(function(p3)
			if v3 then
				return (v3.data(p3))
			end

			return nil
		end)
	end, { v3 })

	local v5 = React.useMemo(function()
		return Signals.createComputed(function(p3)
			if v3 then
				return (v3.status(p3))
			end

			return DataStatus.NotReady
		end)
	end, { v3 })

	return SignalsReact.useSignalState(v4), (SignalsReact.useSignalState(v5))
end

return useGetFriendsCountByUserId
