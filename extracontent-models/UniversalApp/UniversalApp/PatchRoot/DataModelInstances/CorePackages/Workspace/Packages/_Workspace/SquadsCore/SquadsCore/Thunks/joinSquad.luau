local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local leaveSquad = require(script.Parent.leaveSquad)
local logInExpCoplayTelemetry = require(SquadsCore.Analytics.logInExpCoplayTelemetry)
local SquadCoplayJoin = require(SquadsCore.Enums.SquadCoplayJoin)

require(SquadsCore.Enums.SquadLocationEnum)

local SquadPromptType = require(SquadsCore.Enums.SquadPromptType)
local NetworkingSquads = require(SquadsCore.Http.NetworkingSquads)
local Promise = require(SquadsCoreParent.Promise)
local SharedFlags = require(SquadsCoreParent.SharedFlags)
local FFlagEnableSquadCoplayAnalytic = SharedFlags.FFlagEnableSquadCoplayAnalytic
local FFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled

return function(s1: string, p1: ((...any) -> ...any), p2: ((...any) -> ...any), p3, b1: boolean) -- line: 62
	-- upvalues: SquadPromptType (copy), Promise (copy), FFlagEnableSquadCoplayAnalytic (copy), NetworkingSquads (copy), logInExpCoplayTelemetry (copy), SquadCoplayJoin (copy), leaveSquad (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy)
	return function(p4) -- line: 69
		-- upvalues: s1 (copy), p1 (copy), SquadPromptType (copy), Promise (copy), FFlagEnableSquadCoplayAnalytic (copy), p2 (copy), p3 (copy), NetworkingSquads (copy), logInExpCoplayTelemetry (copy), SquadCoplayJoin (copy), leaveSquad (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), b1 (copy)
		local v24 = p4:getState()
		local v25 = v24.Squad and (v24.Squad.Squad and (v24.Squad.Squad.currentSquad and v24.Squad.Squad.currentSquad.squadId))

		if v25 == s1 then
			p1(p4, {
				hideCancelButton = true,
				promptType = SquadPromptType.AlreadyJoined
			})

			return Promise.resolve({})
		end

		if not v25 then
			local v26 = s1
			local v27 = p1
			local v28 = if not FFlagEnableSquadCoplayAnalytic then nil else p2
			local v29 = if not FFlagEnableSquadCoplayAnalytic then nil else p3

			return p4:dispatch(function(p5) -- line: 28
				-- upvalues: NetworkingSquads (copy), v26 (copy), FFlagEnableSquadCoplayAnalytic (copy), v29 (copy), logInExpCoplayTelemetry (copy), SquadCoplayJoin (copy), v28 (copy), v27 (copy), SquadPromptType (copy)
				local v35 = p5:dispatch(NetworkingSquads.JoinSquad.API({
					leaveExisting = true,
					squadId = v26,
					squadLocation = if not FFlagEnableSquadCoplayAnalytic then nil else v29
				}))

				if FFlagEnableSquadCoplayAnalytic then
					v35 = v35:andThen(function(p6) -- line: 36
						-- upvalues: logInExpCoplayTelemetry (copy), v29 (copy), SquadCoplayJoin (copy), v28 (copy)
						local groupUpId = p6.responseBody.groupUp.groupUpId
						local members = p6.responseBody.groupUp.members

						if groupUpId and members then
							logInExpCoplayTelemetry(groupUpId, members, v29, SquadCoplayJoin.PartyJoin, v28)
						end
					end)
				end

				return v35:catch(function(_) -- line: 52
					-- upvalues: v27 (copy), p5 (copy), SquadPromptType (copy)
					v27(p5, {
						hideCancelButton = true,
						promptType = SquadPromptType.Error
					})
				end)
			end)
		end

		return p4:dispatch(leaveSquad(SquadPromptType.JoinAnotherSquad, p1, function() -- line: 97
			-- upvalues: p4 (copy), s1 (copy), p1 (copy), FFlagEnableSquadCoplayAnalytic (copy), p2 (copy), p3 (copy), NetworkingSquads (copy), logInExpCoplayTelemetry (copy), SquadCoplayJoin (copy), SquadPromptType (copy)
			local v36 = p4
			local v37 = s1
			local v38 = p1
			local v39 = if not FFlagEnableSquadCoplayAnalytic then nil else p2
			local v40 = if not FFlagEnableSquadCoplayAnalytic then nil else p3

			v36:dispatch(function(p8) -- line: 28
				-- upvalues: NetworkingSquads (copy), v37 (copy), FFlagEnableSquadCoplayAnalytic (copy), v40 (copy), logInExpCoplayTelemetry (copy), SquadCoplayJoin (copy), v39 (copy), v38 (copy), SquadPromptType (copy)
				local v46 = p8:dispatch(NetworkingSquads.JoinSquad.API({
					leaveExisting = true,
					squadId = v37,
					squadLocation = if not FFlagEnableSquadCoplayAnalytic then nil else v40
				}))

				if FFlagEnableSquadCoplayAnalytic then
					v46 = v46:andThen(function(p9) -- line: 36
						-- upvalues: logInExpCoplayTelemetry (copy), v40 (copy), SquadCoplayJoin (copy), v39 (copy)
						local groupUpId = p9.responseBody.groupUp.groupUpId
						local members = p9.responseBody.groupUp.members

						if groupUpId and members then
							logInExpCoplayTelemetry(groupUpId, members, v40, SquadCoplayJoin.PartyJoin, v39)
						end
					end)
				end

				return v46:catch(function(_) -- line: 52
					-- upvalues: v38 (copy), p8 (copy), SquadPromptType (copy)
					v38(p8, {
						hideCancelButton = true,
						promptType = SquadPromptType.Error
					})
				end)
			end)
		end, p3, not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or b1))
	end
end
