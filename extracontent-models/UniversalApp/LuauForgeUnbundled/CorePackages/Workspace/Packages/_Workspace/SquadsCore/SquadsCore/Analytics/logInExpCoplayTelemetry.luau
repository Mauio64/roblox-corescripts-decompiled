local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Analytics/EventNames")
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadCoplayJoin")
local SquadLocationEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadLocationEnum")
local FFlagEncodeSquadMembersUpdated = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Flags/FFlagEncodeSquadMembersUpdated")
local encodeSquadMembers = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/encodeSquadMembers")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoduxSquads")

local fn = not FFlagEncodeSquadMembersUpdated and function(p2)
	local success, result = pcall(function()
		return HttpService:JSONEncode(p2)
	end)

	if success then
		return result
	end

	return "[]"
end or require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/encodeUserIds")

return function(p2, list, p3, p4, callback)
	if p3 == SquadLocationEnum.InExperience then
		local userIdSet = {}
		local userIds = {}

		for i, item in ipairs(list) do
			userIdSet[item.userId] = true
		end

		for k, v5 in Players:GetPlayers() do
			if userIdSet[v5.UserId] then
				table.insert(userIds, v5.UserId)
			end
		end

		local mapped = nil
		local v5, v6

		if FFlagEncodeSquadMembersUpdated then
			v5 = fn(userIds)
			v6 = encodeSquadMembers(list)
		else
			mapped = Cryo.List.map(list, function(p5)
				return p5.userId
			end)

			v5 = fn(userIds)
			v6 = fn(mapped)
		end

		local partyCoplay = EventNames.PartyCoplay
		local v7 = {
			partyCoplayEvent = p4,
			partyId = p2,
			partyPlayersInGameInstanceCount = #userIds,
			partyPlayersInGameInstanceUserIds = v5,
			partyTotalSize = 0,
			partyTotalSizeUserIds = 0
		}

		local v8 = if FFlagEncodeSquadMembersUpdated then #list else #mapped
		v7.partyTotalSize = v8
		v7.partyTotalSizeUserIds = v6
		callback(partyCoplay, v7)
	end
end
