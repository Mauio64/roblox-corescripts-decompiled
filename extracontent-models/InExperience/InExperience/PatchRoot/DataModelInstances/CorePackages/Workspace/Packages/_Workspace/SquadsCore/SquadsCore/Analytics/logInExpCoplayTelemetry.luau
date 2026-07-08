local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local EventNames = require(SquadsCore.Analytics.EventNames)

require(SquadsCore.Enums.SquadCoplayJoin)

local SquadLocationEnum = require(SquadsCore.Enums.SquadLocationEnum)
local FFlagEncodeSquadMembersUpdated = require(SquadsCore.Flags.FFlagEncodeSquadMembersUpdated)
local encodeSquadMembers = require(SquadsCore.Common.encodeSquadMembers)
local Cryo = require(SquadsCoreParent.Cryo)

require(SquadsCoreParent.RoduxSquads)

local v10 = not FFlagEncodeSquadMembersUpdated and function(p1) -- line: 21
	-- upvalues: HttpService (copy)
	local ok, result = pcall(function() -- line: 22
		-- upvalues: HttpService (copy), p1 (copy)
		return HttpService:JSONEncode(p1)
	end)

	if ok then
		return result
	end

	return "[]"
end or require(SquadsCore.Common.encodeUserIds)

return function(s1: string, t1: {[any]: any}, p2, p3, p4: ((...any) -> ...any)) -- line: 33
	-- upvalues: SquadLocationEnum (copy), Players (copy), FFlagEncodeSquadMembersUpdated (copy), v10 (copy), encodeSquadMembers (copy), Cryo (copy), EventNames (copy)
	if p2 == SquadLocationEnum.InExperience then
		local t2 = {}
		local t3 = {}

		for _, v in ipairs(t1) do
			t2[v.userId] = true
		end

		for _, player in Players:GetPlayers() do
			if t2[player.UserId] then
				table.insert(t3, player.UserId)
			end
		end

		local v25 = nil
		local v26, v27

		if FFlagEncodeSquadMembersUpdated then
			v26 = v10(t3)
			v27 = encodeSquadMembers(t1)
		else
			v25 = Cryo.List.map(t1, function(p5) -- line: 63
				return p5.userId
			end)
			v26 = v10(t3)
			v27 = v10(v25)
		end

		p4(EventNames.PartyCoplay, {
			partyCoplayEvent = p3,
			partyId = s1,
			partyPlayersInGameInstanceCount = #t3,
			partyPlayersInGameInstanceUserIds = v26,
			partyTotalSize = if not FFlagEncodeSquadMembersUpdated then #v25 else #t1,
			partyTotalSizeUserIds = v27
		})
	end
end
