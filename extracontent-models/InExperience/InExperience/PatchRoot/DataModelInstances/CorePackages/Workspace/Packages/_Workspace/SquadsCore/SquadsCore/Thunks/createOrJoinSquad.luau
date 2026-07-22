local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local logInExpCoplayTelemetry = require(SquadsCore.Analytics.logInExpCoplayTelemetry)
local SquadCoplayJoin = require(SquadsCore.Enums.SquadCoplayJoin)

require(SquadsCore.Enums.SquadLocationEnum)

local SquadPromptType = require(SquadsCore.Enums.SquadPromptType)
local NetworkingSquads = require(SquadsCore.Http.NetworkingSquads)
local FFlagEnableSquadCoplayAnalytic = require(SquadsCoreParent.SharedFlags).FFlagEnableSquadCoplayAnalytic

return function(s1: string, p1: ((...any) -> ...any), p2: ((...any) -> ...any), p3, s2: string?, p4: ((...any) -> ...any)?, s3: string?) -- line: 16
	-- upvalues: NetworkingSquads (copy), FFlagEnableSquadCoplayAnalytic (copy), logInExpCoplayTelemetry (copy), SquadCoplayJoin (copy), SquadPromptType (copy)
	return function(p5) -- line: 25
		-- upvalues: NetworkingSquads (copy), s1 (copy), FFlagEnableSquadCoplayAnalytic (copy), p3 (copy), s2 (copy), s3 (copy), logInExpCoplayTelemetry (copy), SquadCoplayJoin (copy), p2 (copy), p1 (copy), SquadPromptType (copy), p4 (copy)
		local v16 = p5:dispatch(NetworkingSquads.CreateOrJoinSquad.API({
			leaveExisting = true,
			parentChannelId = s1,
			squadLocation = if not FFlagEnableSquadCoplayAnalytic then nil else p3,
			partyAttemptId = s2,
			scheduledSquadId = s3
		}))

		if FFlagEnableSquadCoplayAnalytic then
			v16 = v16:andThen(function(p6) -- line: 35
				-- upvalues: logInExpCoplayTelemetry (copy), p3 (copy), SquadCoplayJoin (copy), p2 (copy)
				local groupUpId = p6.responseBody.groupUp.groupUpId
				local members = p6.responseBody.groupUp.members

				if groupUpId and members then
					logInExpCoplayTelemetry(groupUpId, members, p3, SquadCoplayJoin.PartyJoin, p2)
				end
			end)
		end

		return v16:catch(function(_) -- line: 51
			-- upvalues: p1 (copy), p5 (copy), SquadPromptType (copy), p4 (copy)
			p1(p5, {
				hideCancelButton = true,
				promptType = SquadPromptType.Error,
				onConfirm = p4
			})
		end)
	end
end
