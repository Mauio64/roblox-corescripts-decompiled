local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local parent = GameJoinCard.Parent

local React = require(parent.React)

local prefetchGameJoinCardMedia = require(GameJoinCard.prefetchGameJoinCardMedia)

local function usePrefetchInGameFriendsMedia(items)
	local v = React.useMemo(function()
		if not items then
			return ""
		end

		local universeIdSet = {}
		local universeIds = {}

		for _, item in items do
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
		if v == "" then
			return
		end

		local v2 = {}

		for _, universeId in string.split(v, ",") do
			table.insert(v2, { universeId = universeId })
		end

		prefetchGameJoinCardMedia(v2)
	end, { v })
end

return usePrefetchInGameFriendsMedia
