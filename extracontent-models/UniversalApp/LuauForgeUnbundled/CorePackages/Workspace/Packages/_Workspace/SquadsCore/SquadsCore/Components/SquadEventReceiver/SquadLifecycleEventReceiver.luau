local MessageBusService = game:GetService("MessageBusService")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Logger")
local RoduxSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/RoduxSquads")

local SquadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadExternalContractContext")
local SquadState = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadState")
local SquadViewFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadViewFlags")
local fetchActiveSquad = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Thunks/fetchActiveSquad")
local serializeTable = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Utils/serializeTable")
local useSquadState = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Hooks/useSquadState")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RealtimeDelivery")
local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/LuauPolyfill")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RobloxAppHooks").useLocalUserId

local clearInterval = LuauPolyfill.clearInterval
local clearTimeout = LuauPolyfill.clearTimeout
local setInterval = LuauPolyfill.setInterval
local setTimeout = LuauPolyfill.setTimeout

local defineFastInt = game:DefineFastInt("ActiveSquadPollingCardIntervalSeconds", 30)
local defineFastInt2 = game:DefineFastInt("ActiveSquadPollingLobbyIntervalSeconds", 60)
local defineFastInt3 = game:DefineFastInt("ActiveSquadPollingIdleIntervalSeconds", 120)
local defineFastInt4 = game:DefineFastInt("ActiveSquadInitPollingDelaySeconds", 3)

local messageId = MessageBusService:GetMessageId("Realtime", "appResume")

return function(p2): nil
	local v5 = useDispatch()
	local v6 = tonumber(useLocalUserId()) or 0
	local state, setState = React.useState(false)

	local v7 = React.useContext(SquadExternalContractContext).useSquadViewFlags()
	local v8 = useSquadState()

	local state2, setState2 = React.useState(-1)

	React.useEffect(function()
		setState(false)
		local v9

		if p2.currentSquadId == "" then
			v9 = nil
		else
			v9 = setTimeout(function()
				v5(fetchActiveSquad())
				setState(true)
			end, defineFastInt4 * 1000)
		end

		return function()
			if v9 then
				clearTimeout(v9)
			end
		end
	end, { p2.currentSquadId })

	React.useEffect(function()
		local v9

		if bit32.band(v7, SquadViewFlags.SquadSystemMessage) == 0 then
			v9 = if bit32.band(v7, SquadViewFlags.SquadLobby) == 0 then defineFastInt3 else defineFastInt2
		else
			v9 = defineFastInt
		end

		local v10

		if state and p2.currentSquadId ~= "" then
			v10 = setInterval(function()
				v5(fetchActiveSquad())
			end, v9 * 1000)
		else
			v10 = nil
		end

		return function()
			if v10 then
				clearInterval(v10)
			end
		end
	end, { p2.currentSquadId, v7, state2, state })

	local v9 = React.useCallback(function(p3)
		if state2 < p3 then
			v5(fetchActiveSquad()):andThen(function()
				setState2(p3)
			end)
		end
	end, { v5, fetchActiveSquad, setState2, state2 })

	RealtimeDelivery.useRealtimeNamespace(Constants.COMMUNICATION_CHANNEL_RTN_NAMESPACE, function(data)
		if data.ChannelType == Constants.SQUAD_CHANNEL_TYPE then
			Logger:debug(
				"Squad RTN received. Detail: {}, CurrentSquadId: {}, LocalUserId: {}",
				serializeTable(data),
				p2.currentSquadId,
				v6
			)

			if p2.currentSquadId == data.ChannelId then
				if
					data.Type == Constants.CHANNEL_LOCAL_USER_REMOVED_DETAIL_TYPE
					or data.Type == Constants.CHANNEL_DELETED_DETAIL_TYPE
				then
					v5(RoduxSquads.Actions.CurrentSquadUpdated(nil))
				elseif
					data.Type == Constants.CHANNEL_PARTICIPANT_ADDED_DETAIL_TYPE
					or data.Type == Constants.CHANNEL_PARTICIPANT_REMOVED_DETAIL_TYPE
					or data.Type == Constants.CHANNEL_UPDATED_DETAIL_TYPE
					or data.Type == Constants.CHANNEL_PARTICIPANT_INVITED_DETAIL_TYPE
				then
					v9(data.SequenceNumber)
				end
			elseif v8 ~= SquadState.Initializing then
				local v10 = data.Actor

				if v10 then
					v10 = data.Actor.Type == "User" and data.Actor.Id == tostring(v6)
				end

				if data.Type == Constants.CHANNEL_CREATED_DETAIL_TYPE and v10 then
					v9(data.SequenceNumber)
				elseif data.Type == Constants.CHANNEL_LOCAL_USER_ADDED_DETAIL_TYPE then
					v9(data.SequenceNumber)
				end
			end
		end
	end, { p2.currentSquadId, v5, v6, v9, v8 })

	React.useEffect(function()
		local connection = MessageBusService:Subscribe(messageId, function()
			if p2.currentSquadId ~= "" then
				v5(fetchActiveSquad())
			end
		end, false, true)
		return function()
			if connection then
				connection:Disconnect()
			end
		end
	end, { p2.currentSquadId, v5 })

	return nil
end
