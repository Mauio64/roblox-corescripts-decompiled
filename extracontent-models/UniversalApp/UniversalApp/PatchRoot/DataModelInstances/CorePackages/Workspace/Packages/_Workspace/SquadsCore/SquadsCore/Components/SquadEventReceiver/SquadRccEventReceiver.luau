local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local HttpService = game:GetService("HttpService")
local React = require(SquadsCoreParent.React)
local useDispatch = require(SquadsCoreParent.RoactUtils).Hooks.RoactRodux.useDispatch
local Constants = require(SquadsCore.Common.Constants)
local EventNames = require(SquadsCore.Analytics.EventNames)
local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local SquadRccEventManager = require(SquadsCore.ServiceManager.SquadRccEventManager)
local actOnPartyNudge = require(SquadsCore.Thunks.actOnPartyNudge)
local createConversation = require(SquadsCore.Thunks.createConversation)
local encodeUserIds = require(SquadsCore.Common.encodeUserIds)

return function(t1: {[any]: any}) -- line: 24
	-- upvalues: React (copy), SquadExternalContractContext (copy), SquadRccEventManager (copy), useDispatch (copy), Constants (copy), HttpService (copy), EventNames (copy), encodeUserIds (copy), createConversation (copy), actOnPartyNudge (copy), RobloxReplicatedStorage (copy)
	local v15 = React.useContext(SquadExternalContractContext)
	local v16 = v15.useIsChatEnabled()
	local v17 = v15.useIsLoadingChatSettings()

	React.useEffect(function() -- line: 29
		-- upvalues: SquadRccEventManager (copy), t1 (copy), v16 (copy)
		SquadRccEventManager:fireSquadChangeEvent(t1.currentSquadId, v16)
	end, {
		t1.currentSquadId,
		v16
	})

	local v18 = useDispatch()
	local v19 = React.useRef({})
	local v20 = React.useCallback(function() -- line: 36
		-- upvalues: v19 (copy), Constants (copy), HttpService (copy), v15 (copy), EventNames (copy), encodeUserIds (copy), v18 (copy), createConversation (copy), actOnPartyNudge (copy), t1 (copy), v16 (copy)
		for _, v in ipairs(v19.current) do
			local partySourceType = v.partySourceType
			local data = v.data

			if partySourceType == "PartyNudge" and data.nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE then
				local guid = HttpService:GenerateGUID(false)

				v15.fireSquadAnalytics(EventNames.SquadCreateOrJoinFromRCC, {
					partySourceType = partySourceType,
					nudgeType = data.nudgeType,
					nudgeId = data.nudgeId,
					partyAttemptId = guid,
					inviteeUserIds = encodeUserIds({ data.inviteeId })
				})
				v18(createConversation({
					conversationType = "one_to_one",
					source = "createOrJoinPartyRemoteEvent",
					userIds = { (tostring(data.inviteeId)) },
					squadContext = v15,
					onSuccessCallback = function(p1) -- line: 56
						-- upvalues: v18 (copy), actOnPartyNudge (copy), t1 (copy), Constants (copy), data (copy), v15 (copy), v16 (copy), guid (copy)
						v18(actOnPartyNudge(if t1.currentSquadId ~= "" then Constants.REJECT_START_PARTY_REQUEST_ACTION else Constants.ACCEPT_START_PARTY_REQUEST_ACTION, data.nudgeId, false, v15.setSquadPrompt, v15.fireSquadAnalytics, v15.squadLocation, v16, guid, p1))
					end,
					onErrorCallback = function() -- line: 73
						-- upvalues: v18 (copy), actOnPartyNudge (copy), Constants (copy), data (copy), v15 (copy), v16 (copy), guid (copy)
						v18(actOnPartyNudge(Constants.REJECT_START_PARTY_REQUEST_ACTION, data.nudgeId, false, v15.setSquadPrompt, v15.fireSquadAnalytics, v15.squadLocation, v16, guid))
					end
				}))
			end
		end

		v19.current = {}
	end, {
		v16,
		v15,
		v15.setSquadPrompt,
		v15.fireSquadAnalytics,
		v15.squadLocation
	})

	React.useEffect(function() -- line: 101
		-- upvalues: v17 (copy), v16 (copy), v20 (copy), v19 (copy), RobloxReplicatedStorage (copy)
		if not v17 then
			if v16 then
				v20()
			else
				v19.current = {}
			end
		end

		local connection = nil

		coroutine.wrap(function() -- line: 111
			-- upvalues: RobloxReplicatedStorage (copy), connection (ref), v17 (copy), v19 (copy), v16 (copy), v20 (copy)
			connection = RobloxReplicatedStorage:WaitForChild("CreateOrJoinParty", 1e999).OnClientEvent:Connect(function(p2, p3) -- line: 115
				-- upvalues: v17 (copy), v19 (copy), v16 (copy), v20 (copy)
				if v17 then
					table.insert(v19.current, {
						partySourceType = p2,
						data = p3
					})

					return
				end

				if v16 then
					v20()
				end
			end)
		end)()

		return function() -- line: 128
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, {
		v17,
		v16,
		v20
	})

	return nil
end
