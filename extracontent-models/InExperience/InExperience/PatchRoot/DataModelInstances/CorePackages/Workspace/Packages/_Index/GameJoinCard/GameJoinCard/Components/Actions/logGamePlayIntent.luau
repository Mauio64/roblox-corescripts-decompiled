local parent = script:FindFirstAncestor("GameJoinCard").Parent
local HttpService = game:GetService("HttpService")

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local PeopleListInHomePage = DiscoveryAnalytics.Constants.Context.PeopleListInHomePage

require(script.Parent.Types)

local function logGamePlayIntent(data)
	local userId = data.userId

	if userId == "" then
		return
	end

	local presence = data.presence
	local placeId = presence.placeId
	local rootPlaceId = presence.rootPlaceId
	local placeId2 = (placeId == nil or tostring(placeId) == "") and "" or tostring(placeId)
	local rootPlaceId2 = tonumber(rootPlaceId)

	if placeId2 == "" or rootPlaceId2 == nil then
		return
	end

	gamePlayIntent(data.eventIngest, PeopleListInHomePage, {
		placeId = placeId2,
		rootPlaceId = rootPlaceId2,
		friendId = userId,
		joinAttemptId = HttpService:GenerateGUID(false)
	})
end

return logGamePlayIntent
