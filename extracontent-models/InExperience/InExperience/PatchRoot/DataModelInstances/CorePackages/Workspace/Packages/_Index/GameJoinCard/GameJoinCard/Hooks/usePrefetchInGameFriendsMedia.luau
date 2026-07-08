local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local GameJoinCardParent = GameJoinCard.Parent
local React = require(GameJoinCardParent.React)
local prefetchGameJoinCardMedia = require(GameJoinCard.prefetchGameJoinCardMedia)

local function usePrefetchInGameFriendsMedia(t1: {[any]: any}?) -- line: 21
	-- upvalues: React (copy), prefetchGameJoinCardMedia (copy)
	local v7 = React.useMemo(function() -- line: 24
		-- upvalues: t1 (copy)
		if not t1 then
			return ""
		end

		local t2 = {}
		local t3 = {}

		for _, v11 in t1 do
			local presence = v11.presence

			if presence and presence.userPresenceType == "InGame" then
				local str = tostring(presence.universeId or "")

				if str ~= "" and not t2[str] then
					t2[str] = true
					table.insert(t3, str)
				end
			end
		end

		table.sort(t3)

		return table.concat(t3, ",")
	end, { t1 })

	React.useEffect(function() -- line: 45
		-- upvalues: v7 (copy), prefetchGameJoinCardMedia (copy)
		if v7 == "" then
			return
		end

		local t4 = {}

		for _, v16 in string.split(v7, ",") do
			table.insert(t4, {
				universeId = v16
			})
		end

		prefetchGameJoinCardMedia(t4)
	end, { v7 })
end

return usePrefetchInGameFriendsMedia
