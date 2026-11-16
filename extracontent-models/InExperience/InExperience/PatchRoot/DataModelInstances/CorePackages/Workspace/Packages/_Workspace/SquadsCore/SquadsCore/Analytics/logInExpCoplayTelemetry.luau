local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local EventNames = require(SquadsCore.Analytics.EventNames)
require(SquadsCore.Enums.SquadCoplayJoin)
local SquadLocationEnum = require(SquadsCore.Enums.SquadLocationEnum)
local FFlagEncodeSquadMembersUpdated = require(SquadsCore.Flags.FFlagEncodeSquadMembersUpdated)
local encodeSquadMembers = require(SquadsCore.Common.encodeSquadMembers)

local Cryo = require(parent.Cryo)
require(parent.RoduxSquads)

local fn = not FFlagEncodeSquadMembersUpdated and function(p)
	local success, result = pcall(function()
		return HttpService:JSONEncode(p)
	end)
	return if success then result else "[]"
end or require(SquadsCore.Common.encodeUserIds)

return function(partyId: string, list, p, partyCoplayEvent, callback)
	if p == SquadLocationEnum.InExperience then
		local userIdSet = {}
		local userIds = {}

		for _, item in ipairs(list) do
			userIdSet[item.userId] = true
		end

		for _, v in Players:GetPlayers() do
			if userIdSet[v.UserId] then
				table.insert(userIds, v.UserId)
			end
		end

		local mapped = nil
		local partyPlayersInGameInstanceUserIds, partyTotalSizeUserIds

		if FFlagEncodeSquadMembersUpdated then
			partyPlayersInGameInstanceUserIds = fn(userIds)
			partyTotalSizeUserIds = encodeSquadMembers(list)
		else
			mapped = Cryo.List.map(list, function(p2)
				return p2.userId
			end)

			partyPlayersInGameInstanceUserIds = fn(userIds)
			partyTotalSizeUserIds = fn(mapped)
		end

		local partyCoplay = EventNames.PartyCoplay
		local v = {
			partyCoplayEvent = partyCoplayEvent,
			partyId = partyId,
			partyPlayersInGameInstanceCount = #userIds,
			partyPlayersInGameInstanceUserIds = partyPlayersInGameInstanceUserIds,
			partyTotalSize = 0,
			partyTotalSizeUserIds = 0
		}
		local partyTotalSize

		if FFlagEncodeSquadMembersUpdated then
			partyTotalSize = #list
		else
			partyTotalSize = #mapped
		end

		v.partyTotalSize = partyTotalSize
		v.partyTotalSizeUserIds = partyTotalSizeUserIds
		callback(partyCoplay, v)
	end
end
