local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local HttpService = game:GetService("HttpService")

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local Constants = require(SquadsCore.Common.Constants)
local EventNames = require(SquadsCore.Analytics.EventNames)

local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local SquadRccEventManager = require(SquadsCore.ServiceManager.SquadRccEventManager)
local actOnPartyNudge = require(SquadsCore.Thunks.actOnPartyNudge)
local createConversation = require(SquadsCore.Thunks.createConversation)
local encodeUserIds = require(SquadsCore.Common.encodeUserIds)

return function(p): nil
	local squadContext = React.useContext(SquadExternalContractContext)
	local v = squadContext.useIsChatEnabled()
	local v2 = squadContext.useIsLoadingChatSettings()

	React.useEffect(function()
		SquadRccEventManager:fireSquadChangeEvent(p.currentSquadId, v)
	end, { p.currentSquadId, v })

	local v3 = useDispatch()
	local ref = React.useRef({})

	local v4 = React.useCallback(function()
		for _, v4 in ipairs(ref.current) do
			local partySourceType = v4.partySourceType
			local data = v4.data

			if not (partySourceType == "PartyNudge" and data.nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE) then
				continue
			end

			local guid = HttpService:GenerateGUID(false)
			squadContext.fireSquadAnalytics(EventNames.SquadCreateOrJoinFromRCC, {
				partySourceType = "PartyNudge",
				nudgeType = data.nudgeType,
				nudgeId = data.nudgeId,
				partyAttemptId = guid,
				inviteeUserIds = encodeUserIds({ data.inviteeId })
			})

			v3(createConversation({
				conversationType = "one_to_one",
				userIds = { (tostring(data.inviteeId)) },
				source = "createOrJoinPartyRemoteEvent",
				squadContext = squadContext,
				onSuccessCallback = function(p2)
					local v5

					if p.currentSquadId == "" then
						v5 = Constants.ACCEPT_START_PARTY_REQUEST_ACTION
					else
						v5 = Constants.REJECT_START_PARTY_REQUEST_ACTION
					end

					v3(actOnPartyNudge(
						v5,
						data.nudgeId,
						false,
						squadContext.setSquadPrompt,
						squadContext.fireSquadAnalytics,
						squadContext.squadLocation,
						v,
						guid,
						p2
					))
				end,
				onErrorCallback = function()
					v3(actOnPartyNudge(
						Constants.REJECT_START_PARTY_REQUEST_ACTION,
						data.nudgeId,
						false,
						squadContext.setSquadPrompt,
						squadContext.fireSquadAnalytics,
						squadContext.squadLocation,
						v,
						guid
					))
				end
			}))
		end

		ref.current = {}
	end, {
		v,
		squadContext,
		squadContext.setSquadPrompt,
		squadContext.fireSquadAnalytics,
		squadContext.squadLocation
	})

	React.useEffect(function()
		if not v2 then
			if v then
				v4()
			else
				ref.current = {}
			end
		end

		local onClientEventConnection = nil
		coroutine.wrap(function()
			onClientEventConnection = RobloxReplicatedStorage:WaitForChild("CreateOrJoinParty", 1e999).OnClientEvent:Connect(function(partySourceType, p2)
				if v2 then
					table.insert(ref.current, { partySourceType = partySourceType, data = p2 })
				elseif v then
					v4()
				end
			end)
		end)()

		return function()
			if onClientEventConnection then
				onClientEventConnection:Disconnect()
			end
		end
	end, { v2, v, v4 })

	return nil
end
