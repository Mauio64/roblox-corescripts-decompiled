local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useDispatch

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Analytics/EventNames")

local SquadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadExternalContractContext")
local SquadRccEventManager = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/ServiceManager/SquadRccEventManager")
local actOnPartyNudge = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Thunks/actOnPartyNudge")
local createConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Thunks/createConversation")
local encodeUserIds = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/encodeUserIds")

return function(p2): nil
	local v5 = React.useContext(SquadExternalContractContext)
	local v6 = v5.useIsChatEnabled()
	local v7 = v5.useIsLoadingChatSettings()

	React.useEffect(function()
		SquadRccEventManager:fireSquadChangeEvent(p2.currentSquadId, v6)
	end, { p2.currentSquadId, v6 })

	local v8 = useDispatch()
	local ref = React.useRef({})

	local v9 = React.useCallback(function()
		for i, v10 in ipairs(ref.current) do
			local partySourceType = v10.partySourceType
			local data = v10.data

			if not (partySourceType == "PartyNudge" and data.nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE) then
				continue
			end

			local guid = HttpService:GenerateGUID(false)
			v5.fireSquadAnalytics(EventNames.SquadCreateOrJoinFromRCC, {
				partySourceType = "PartyNudge",
				nudgeType = data.nudgeType,
				nudgeId = data.nudgeId,
				partyAttemptId = guid,
				inviteeUserIds = encodeUserIds({ data.inviteeId })
			})

			v8(createConversation({
				conversationType = "one_to_one",
				userIds = { (tostring(data.inviteeId)) },
				source = "createOrJoinPartyRemoteEvent",
				squadContext = v5,
				onSuccessCallback = function(p3)
					local v13 = if p2.currentSquadId == "" then Constants.ACCEPT_START_PARTY_REQUEST_ACTION else Constants.REJECT_START_PARTY_REQUEST_ACTION
					v8(actOnPartyNudge(
						v13,
						data.nudgeId,
						false,
						v5.setSquadPrompt,
						v5.fireSquadAnalytics,
						v5.squadLocation,
						v6,
						guid,
						p3
					))
				end,
				onErrorCallback = function()
					v8(actOnPartyNudge(
						Constants.REJECT_START_PARTY_REQUEST_ACTION,
						data.nudgeId,
						false,
						v5.setSquadPrompt,
						v5.fireSquadAnalytics,
						v5.squadLocation,
						v6,
						guid
					))
				end
			}))
		end

		ref.current = {}
	end, { v6, v5, v5.setSquadPrompt, v5.fireSquadAnalytics, v5.squadLocation })

	React.useEffect(function()
		if not v7 then
			if v6 then
				v9()
			else
				ref.current = {}
			end
		end

		local onClientEventConnection = nil
		coroutine.wrap(function()
			onClientEventConnection = RobloxReplicatedStorage:WaitForChild("CreateOrJoinParty", 1e999).OnClientEvent:Connect(function(p3, p4)
				if v7 then
					table.insert(ref.current, { partySourceType = p3, data = p4 })
				elseif v6 then
					v9()
				end
			end)
		end)()

		return function()
			if onClientEventConnection then
				onClientEventConnection:Disconnect()
			end
		end
	end, { v7, v6, v9 })

	return nil
end
