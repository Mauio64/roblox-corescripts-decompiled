local parent = script:FindFirstAncestor("FriendsCommon").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local DataHydration = require(parent.DataHydration)

local v = DataHydration.Presence.PresenceStore.get()

local v2 = { skipFetch = true }

local function useGetPresenceByUserId(p: string?, p2)
	local v3 = not p and "" or tostring(p)

	local v4 = React.useMemo(function()
		local v4 = if v3 == "" then v2 else p2
		return v.GetPresenceByUserId(v3, v4)
	end, { v3, p2 })
	local v5

	if p2 == nil then
		v5 = false
	else
		v5 = p2.forceFetch == true
	end

	React.useEffect(function()
		if v3 ~= "" and v5 then
			v.RefreshPresenceByUserId(v3)
		end
	end, { v3, v5 })

	return SignalsReact.useSignalState(v4.data), (SignalsReact.useSignalState(v4.status))
end

return useGetPresenceByUserId
