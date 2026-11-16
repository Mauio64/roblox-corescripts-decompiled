local Players = game:GetService("Players")

local formatAlias = require("@luauforge/deferred/gce").SocialLibraries.Utils.formatAlias

local module = require("@luauforge/deferred/gdd")
local module2 = require("@luauforge/deferred/gde")

local module3 = require("@luauforge/deferred/gdf")

local getStandardSizeAvatarHeadShotRbxthumb = require("@luauforge/bundled/cgr").Utils.getStandardSizeAvatarHeadShotRbxthumb

return function(p2, data, p3)
	local userId = tostring(Players.LocalPlayer.UserId)
	local filtered = module2.Filter(data.participants, function(p4): boolean
		return p4 ~= userId
	end)

	local v5 = data.conversationType == module3.Type.ONE_TO_ONE_CONVERSATION
	local lastLocation = nil
	local presence = nil
	local v6 = ""

	if v5 then
		local v7 = p2[filtered[1]]

		if v7 then
			presence = v7.presence
			lastLocation = v7.lastLocation

			local v8 = p3.byUserId[v7.id] or ""

			if v8 ~= "" then
				v6 = formatAlias(v8)
			end
		end
	end

	local v7 = {}

	for k, participant in pairs(data.participants) do
		if v5 and participant ~= userId or not v5 then
			table.insert(v7, (getStandardSizeAvatarHeadShotRbxthumb(participant)))
		end
	end

	local v8 = v5
		and module.PresenceIndicatorImagesBySize[module:GetPresenceIndicatorSizeKey(14)][presence]
		or ""

	return {
		oneToOne = v5,
		lastUpdated = not data.lastUpdated and 0 or data.lastUpdated:GetUnixTimestamp(),
		conversationId = data.id,
		lastLocation = lastLocation,
		presence = presence,
		presenceImage = v8,
		title = data.title,
		thumbnails = v7,
		participants = data.participants,
		alias = v6
	}
end
