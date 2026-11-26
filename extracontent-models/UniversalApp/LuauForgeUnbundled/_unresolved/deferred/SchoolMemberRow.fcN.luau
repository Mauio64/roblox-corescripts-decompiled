require("@luauforge/deferred/eko")
require("@luauforge/deferred/ekW")
local useSignalProfileInsightsByUserId = require("@luauforge/deferred/fcO").useSignalProfileInsightsByUserId
local useMutualFriendsText = require("@luauforge/deferred/fbZ").Hooks.useMutualFriendsText

local function SchoolMemberRow(p2)
	local v5, v6 = useSignalProfileInsightsByUserId({
		userId = p2.entity.id,
		rankingStrategy = "profile_info_boost"
	})

	local mutualFriends = v5 and v5.mutualFriends
	local v7 = mutualFriends and #mutualFriends or 0
	local v8 = useMutualFriendsText(v7)

	return p2.createRow({
		contextualInfo = v7 > 0 and { text = v8 } or nil,
		loadingState = v6 and { contextualInfo = true } or nil
	})
end

return SchoolMemberRow
