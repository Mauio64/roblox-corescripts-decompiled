local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local leaveSquad = require(script.Parent.leaveSquad)
local Constants = require(SquadsCore.Common.Constants)
local logInExpCoplayTelemetry = require(SquadsCore.Analytics.logInExpCoplayTelemetry)
local SquadCoplayJoin = require(SquadsCore.Enums.SquadCoplayJoin)

require(SquadsCore.Enums.SquadLocationEnum)

local SquadPromptType = require(SquadsCore.Enums.SquadPromptType)
local NetworkingSquads = require(SquadsCore.Http.NetworkingSquads)
local Promise = require(SquadsCoreParent.Promise)
local SharedFlags = require(SquadsCoreParent.SharedFlags)
local FFlagEnableSquadCoplayAnalytic = SharedFlags.FFlagEnableSquadCoplayAnalytic
local FFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled
local v13 = game:DefineFastFlag("FixPartyNudgeNilThunkWhenLeave", false)

return function(s1: string, s2: string, b1: boolean, p1: ((...any) -> ...any), p2: ((...any) -> ...any), p3, b2: boolean, s3: string?, s4: string?) -- line: 80
	-- upvalues: NetworkingSquads (copy), FFlagEnableSquadCoplayAnalytic (copy), Constants (copy), SquadCoplayJoin (copy), logInExpCoplayTelemetry (copy), SquadPromptType (copy), v13 (copy), Promise (copy), leaveSquad (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy)
	return function(p4) -- line: 91
		-- upvalues: b1 (copy), s1 (copy), s2 (copy), p1 (copy), p2 (copy), p3 (copy), s3 (copy), s4 (copy), NetworkingSquads (copy), FFlagEnableSquadCoplayAnalytic (copy), Constants (copy), SquadCoplayJoin (copy), logInExpCoplayTelemetry (copy), SquadPromptType (copy), v13 (copy), Promise (copy), leaveSquad (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), b2 (copy)
		local v33 = p4:getState()
		local v34 = v33.Squad and (v33.Squad.Squad and (v33.Squad.Squad.currentSquad and v33.Squad.Squad.currentSquad.squadId))

		if not v34 or (v34 == "" or not b1) then
			local v35 = s1
			local v36 = s2
			local v37 = p1
			local v38 = p2
			local v39 = p3
			local v40 = s3
			local v41 = s4

			return p4:dispatch(function(p5) -- line: 33
				-- upvalues: NetworkingSquads (copy), v35 (copy), v36 (copy), v40 (copy), v39 (copy), v41 (copy), FFlagEnableSquadCoplayAnalytic (copy), Constants (copy), SquadCoplayJoin (copy), logInExpCoplayTelemetry (copy), v38 (copy), v37 (copy), SquadPromptType (copy)
				local v48 = p5:dispatch(NetworkingSquads.ActOnPartyNudge.API({
					leaveExisting = true,
					action = v35,
					nudgeId = v36,
					partyAttemptId = v40,
					squadLocation = v39,
					parentChannelId = v41
				}))

				if FFlagEnableSquadCoplayAnalytic then
					v48 = v48:andThen(function(p6) -- line: 44
						-- upvalues: v35 (copy), Constants (copy), SquadCoplayJoin (copy), logInExpCoplayTelemetry (copy), v39 (copy), v38 (copy)
						if v35 == Constants.ACCEPT_START_PARTY_REQUEST_ACTION or v35 == Constants.ACCEPT_PARTY_INVITE_ACTION then
							local groupUpId = p6.responseBody.groupUp.groupUpId
							local members = p6.responseBody.groupUp.members

							if groupUpId and members then
								local v62 = if v35 ~= Constants.ACCEPT_START_PARTY_REQUEST_ACTION then SquadCoplayJoin.SquadNudgeJoin else SquadCoplayJoin.SquadNudgeCreation

								logInExpCoplayTelemetry(groupUpId, members, v39, v62, v38)
							end
						end
					end)
				end

				return v48:catch(function(_) -- line: 65
					-- upvalues: v35 (copy), Constants (copy), v37 (copy), p5 (copy), SquadPromptType (copy)
					if v35 == Constants.ACCEPT_START_PARTY_REQUEST_ACTION or v35 == Constants.ACCEPT_PARTY_INVITE_ACTION then
						v37(p5, {
							hideCancelButton = true,
							promptType = SquadPromptType.Error
						})
					end
				end)
			end)
		end

		if v13 then
			return Promise.new(function(resolve, reject) -- line: 113
				-- upvalues: p4 (copy), leaveSquad (copy), SquadPromptType (copy), p1 (copy), s1 (copy), s2 (copy), p2 (copy), p3 (copy), s3 (copy), s4 (copy), NetworkingSquads (copy), FFlagEnableSquadCoplayAnalytic (copy), Constants (copy), SquadCoplayJoin (copy), logInExpCoplayTelemetry (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), b2 (copy)
				p4:dispatch(leaveSquad(SquadPromptType.JoinAnotherSquad, p1, function() -- line: 118
					-- upvalues: p4 (copy), s1 (copy), s2 (copy), p1 (copy), p2 (copy), p3 (copy), s3 (copy), s4 (copy), NetworkingSquads (copy), FFlagEnableSquadCoplayAnalytic (copy), Constants (copy), SquadCoplayJoin (copy), logInExpCoplayTelemetry (copy), SquadPromptType (copy), resolve (copy), reject (copy)
					local v64 = p4
					local v65 = s1
					local v66 = s2
					local v67 = p1
					local v68 = p2
					local v69 = p3
					local v70 = s3
					local v71 = s4

					v64:dispatch(function(p8) -- line: 33
						-- upvalues: NetworkingSquads (copy), v65 (copy), v66 (copy), v70 (copy), v69 (copy), v71 (copy), FFlagEnableSquadCoplayAnalytic (copy), Constants (copy), SquadCoplayJoin (copy), logInExpCoplayTelemetry (copy), v68 (copy), v67 (copy), SquadPromptType (copy)
						local v75 = p8:dispatch(NetworkingSquads.ActOnPartyNudge.API({
							leaveExisting = true,
							action = v65,
							nudgeId = v66,
							partyAttemptId = v70,
							squadLocation = v69,
							parentChannelId = v71
						}))

						if FFlagEnableSquadCoplayAnalytic then
							v75 = v75:andThen(function(p9) -- line: 44
								-- upvalues: v65 (copy), Constants (copy), SquadCoplayJoin (copy), logInExpCoplayTelemetry (copy), v69 (copy), v68 (copy)
								if v65 == Constants.ACCEPT_START_PARTY_REQUEST_ACTION or v65 == Constants.ACCEPT_PARTY_INVITE_ACTION then
									local groupUpId = p9.responseBody.groupUp.groupUpId
									local members = p9.responseBody.groupUp.members

									if groupUpId and members then
										local v84 = if v65 ~= Constants.ACCEPT_START_PARTY_REQUEST_ACTION then SquadCoplayJoin.SquadNudgeJoin else SquadCoplayJoin.SquadNudgeCreation

										logInExpCoplayTelemetry(groupUpId, members, v69, v84, v68)
									end
								end
							end)
						end

						return v75:catch(function(_) -- line: 65
							-- upvalues: v65 (copy), Constants (copy), v67 (copy), p8 (copy), SquadPromptType (copy)
							if v65 == Constants.ACCEPT_START_PARTY_REQUEST_ACTION or v65 == Constants.ACCEPT_PARTY_INVITE_ACTION then
								v67(p8, {
									hideCancelButton = true,
									promptType = SquadPromptType.Error
								})
							end
						end)
					end):andThen(resolve):catch(reject)
				end, p3, not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or b2))
			end)
		end

		return p4:dispatch(leaveSquad(SquadPromptType.JoinAnotherSquad, p1, function() -- line: 140
			-- upvalues: p4 (copy), s1 (copy), s2 (copy), p1 (copy), p2 (copy), p3 (copy), s3 (copy), s4 (copy), NetworkingSquads (copy), FFlagEnableSquadCoplayAnalytic (copy), Constants (copy), SquadCoplayJoin (copy), logInExpCoplayTelemetry (copy), SquadPromptType (copy)
			local v51 = p4
			local v52 = s1
			local v53 = s2
			local v54 = p1
			local v55 = p2
			local v56 = p3
			local v57 = s3
			local v58 = s4

			v51:dispatch(function(p11) -- line: 33
				-- upvalues: NetworkingSquads (copy), v52 (copy), v53 (copy), v57 (copy), v56 (copy), v58 (copy), FFlagEnableSquadCoplayAnalytic (copy), Constants (copy), SquadCoplayJoin (copy), logInExpCoplayTelemetry (copy), v55 (copy), v54 (copy), SquadPromptType (copy)
				local v73 = p11:dispatch(NetworkingSquads.ActOnPartyNudge.API({
					leaveExisting = true,
					action = v52,
					nudgeId = v53,
					partyAttemptId = v57,
					squadLocation = v56,
					parentChannelId = v58
				}))

				if FFlagEnableSquadCoplayAnalytic then
					v73 = v73:andThen(function(p12) -- line: 44
						-- upvalues: v52 (copy), Constants (copy), SquadCoplayJoin (copy), logInExpCoplayTelemetry (copy), v56 (copy), v55 (copy)
						if v52 == Constants.ACCEPT_START_PARTY_REQUEST_ACTION or v52 == Constants.ACCEPT_PARTY_INVITE_ACTION then
							local groupUpId = p12.responseBody.groupUp.groupUpId
							local members = p12.responseBody.groupUp.members

							if groupUpId and members then
								local v79 = if v52 ~= Constants.ACCEPT_START_PARTY_REQUEST_ACTION then SquadCoplayJoin.SquadNudgeJoin else SquadCoplayJoin.SquadNudgeCreation

								logInExpCoplayTelemetry(groupUpId, members, v56, v79, v55)
							end
						end
					end)
				end

				return v73:catch(function(_) -- line: 65
					-- upvalues: v52 (copy), Constants (copy), v54 (copy), p11 (copy), SquadPromptType (copy)
					if v52 == Constants.ACCEPT_START_PARTY_REQUEST_ACTION or v52 == Constants.ACCEPT_PARTY_INVITE_ACTION then
						v54(p11, {
							hideCancelButton = true,
							promptType = SquadPromptType.Error
						})
					end
				end)
			end)
		end, p3, not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or b2))
	end
end
