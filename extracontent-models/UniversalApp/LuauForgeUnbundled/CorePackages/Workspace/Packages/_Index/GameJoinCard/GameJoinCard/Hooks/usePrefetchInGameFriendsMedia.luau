local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")

local prefetchGameJoinCardMedia = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/prefetchGameJoinCardMedia")

local function usePrefetchInGameFriendsMedia(items)
	local v5 = React.useMemo(function()
		if not items then
			return ""
		end

		local universeIdSet = {}
		local universeIds = {}

		for k, item in items do
			local presence = item.presence

			if not (presence and presence.userPresenceType == "InGame") then
				continue
			end

			local universeId = tostring(presence.universeId or "")

			if universeId == "" or universeIdSet[universeId] then
				continue
			end

			universeIdSet[universeId] = true
			table.insert(universeIds, universeId)
		end

		table.sort(universeIds)
		return table.concat(universeIds, ",")
	end, { items })

	React.useEffect(function()
		if v5 == "" then
			return
		end

		local v6 = {}

		for k, v7 in string.split(v5, ",") do
			table.insert(v6, { universeId = v7 })
		end

		prefetchGameJoinCardMedia(v6)
	end, { v5 })
end

return usePrefetchInGameFriendsMedia
