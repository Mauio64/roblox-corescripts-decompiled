local HttpService = game:GetService("HttpService")

local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/DiscoveryAnalytics")
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local peopleListInHomePage = DiscoveryAnalytics.Constants.Context.PeopleListInHomePage

require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/Types")

local function logGamePlayIntent(data)
	local userId = data.userId

	if userId == "" then
		return
	end

	local presence = data.presence
	local placeId = presence.placeId
	local rootPlaceId = presence.rootPlaceId
	local v5 = (placeId == nil or tostring(placeId) == "") and "" or tostring(placeId)
	local v6 = tonumber(rootPlaceId)

	if v5 == "" or v6 == nil then
		return
	end

	gamePlayIntent(data.eventIngest, peopleListInHomePage, {
		placeId = v5,
		rootPlaceId = v6,
		friendId = userId,
		joinAttemptId = HttpService:GenerateGUID(false)
	})
end

return logGamePlayIntent
