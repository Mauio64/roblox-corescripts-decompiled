local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/SignalsReact")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/DataHydration").Presence.PresenceStore.get()

local v6 = { skipFetch = true }

local function useGetPresenceByUserId(p2, p3)
	local v7 = not p2 and "" or tostring(p2)

	local v8 = React.useMemo(function()
		local v9 = if v7 == "" then v6 else p3
		return v5.GetPresenceByUserId(v7, v9)
	end, { v7, p3 })
	local v9 = not (p3 == nil) and p3.forceFetch == true
	React.useEffect(function()
		if v7 ~= "" and v9 then
			v5.RefreshPresenceByUserId(v7)
		end
	end, { v7, v9 })

	return SignalsReact.useSignalState(v8.data), (SignalsReact.useSignalState(v8.status))
end

return useGetPresenceByUserId
