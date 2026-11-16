local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local MessageBusService = game:GetService("MessageBusService")

local Constants = require(SquadsCore.Common.Constants)
local Logger = require(SquadsCore.Logger)
local RoduxSquads = require(SquadsCore.RoduxSquads)

local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local SquadState = require(SquadsCore.Enums.SquadState)
local SquadViewFlags = require(SquadsCore.Components.SquadExternalContractProvider.SquadViewFlags)
local fetchActiveSquad = require(SquadsCore.Thunks.fetchActiveSquad)
local serializeTable = require(SquadsCore.Utils.serializeTable)
local useSquadState = require(SquadsCore.Hooks.useSquadState)

local React = require(parent.React)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local LuauPolyfill = require(parent.LuauPolyfill)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId

local clearInterval = LuauPolyfill.clearInterval
local clearTimeout = LuauPolyfill.clearTimeout
local setInterval = LuauPolyfill.setInterval
local setTimeout = LuauPolyfill.setTimeout

local defineFastInt = game:DefineFastInt("ActiveSquadPollingCardIntervalSeconds", 30)
local defineFastInt2 = game:DefineFastInt("ActiveSquadPollingLobbyIntervalSeconds", 60)
local defineFastInt3 = game:DefineFastInt("ActiveSquadPollingIdleIntervalSeconds", 120)
local defineFastInt4 = game:DefineFastInt("ActiveSquadInitPollingDelaySeconds", 3)

local messageId = MessageBusService:GetMessageId("Realtime", "appResume")

return function(p): nil
	local v = useDispatch()
	local v2 = tonumber(useLocalUserId()) or 0
	local state, setState = React.useState(false)

	local v3 = React.useContext(SquadExternalContractContext).useSquadViewFlags()
	local v4 = useSquadState()

	local state2, setState2 = React.useState(-1)

	React.useEffect(function()
		setState(false)
		local v5

		if p.currentSquadId == "" then
			v5 = nil
		else
			v5 = setTimeout(function()
				v(fetchActiveSquad())
				setState(true)
			end, defineFastInt4 * 1000)
		end

		return function()
			if v5 then
				clearTimeout(v5)
			end
		end
	end, { p.currentSquadId })

	React.useEffect(function()
		local v5

		if bit32.band(v3, SquadViewFlags.SquadSystemMessage) == 0 then
			if bit32.band(v3, SquadViewFlags.SquadLobby) == 0 then
				v5 = defineFastInt3
			else
				v5 = defineFastInt2
			end
		else
			v5 = defineFastInt
		end

		local v6

		if state and p.currentSquadId ~= "" then
			v6 = setInterval(function()
				v(fetchActiveSquad())
			end, v5 * 1000)
		else
			v6 = nil
		end

		return function()
			if v6 then
				clearInterval(v6)
			end
		end
	end, { p.currentSquadId, v3, state2, state })

	local v5 = React.useCallback(function(p2: number)
		if state2 < p2 then
			v(fetchActiveSquad()):andThen(function()
				setState2(p2)
			end)
		end
	end, { v, fetchActiveSquad, setState2, state2 })

	RealtimeDelivery.useRealtimeNamespace(Constants.COMMUNICATION_CHANNEL_RTN_NAMESPACE, function(data)
		if data.ChannelType == Constants.SQUAD_CHANNEL_TYPE then
			Logger:debug(
				"Squad RTN received. Detail: {}, CurrentSquadId: {}, LocalUserId: {}",
				serializeTable(data),
				p.currentSquadId,
				v2
			)

			if p.currentSquadId == data.ChannelId then
				if
					data.Type == Constants.CHANNEL_LOCAL_USER_REMOVED_DETAIL_TYPE
					or data.Type == Constants.CHANNEL_DELETED_DETAIL_TYPE
				then
					v(RoduxSquads.Actions.CurrentSquadUpdated(nil))
				elseif
					data.Type == Constants.CHANNEL_PARTICIPANT_ADDED_DETAIL_TYPE
					or data.Type == Constants.CHANNEL_PARTICIPANT_REMOVED_DETAIL_TYPE
					or data.Type == Constants.CHANNEL_UPDATED_DETAIL_TYPE
					or data.Type == Constants.CHANNEL_PARTICIPANT_INVITED_DETAIL_TYPE
				then
					v5(data.SequenceNumber)
				end
			elseif v4 ~= SquadState.Initializing then
				local v6 = data.Actor

				if v6 then
					if data.Actor.Type == "User" then
						v6 = data.Actor.Id == tostring(v2)
					else
						v6 = false
					end
				end

				if data.Type == Constants.CHANNEL_CREATED_DETAIL_TYPE and v6 then
					v5(data.SequenceNumber)
				elseif data.Type == Constants.CHANNEL_LOCAL_USER_ADDED_DETAIL_TYPE then
					v5(data.SequenceNumber)
				end
			end
		end
	end, { p.currentSquadId, v, v2, v5, v4 })

	React.useEffect(function()
		local connection = MessageBusService:Subscribe(messageId, function()
			if p.currentSquadId ~= "" then
				v(fetchActiveSquad())
			end
		end, false, true)
		return function()
			if connection then
				connection:Disconnect()
			end
		end
	end, { p.currentSquadId, v })

	return nil
end
