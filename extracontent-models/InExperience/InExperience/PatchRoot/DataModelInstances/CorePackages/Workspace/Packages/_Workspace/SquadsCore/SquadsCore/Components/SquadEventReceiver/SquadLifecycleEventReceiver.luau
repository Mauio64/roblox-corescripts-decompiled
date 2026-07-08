local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
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
local React = require(SquadsCoreParent.React)
local RealtimeDelivery = require(SquadsCoreParent.RealtimeDelivery)
local LuauPolyfill = require(SquadsCoreParent.LuauPolyfill)
local useDispatch = require(SquadsCoreParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalUserId = require(SquadsCoreParent.RobloxAppHooks).useLocalUserId
local clearInterval = LuauPolyfill.clearInterval
local clearTimeout = LuauPolyfill.clearTimeout
local setInterval = LuauPolyfill.setInterval
local setTimeout = LuauPolyfill.setTimeout
local v22 = game:DefineFastInt("ActiveSquadPollingCardIntervalSeconds", 30)
local v23 = game:DefineFastInt("ActiveSquadPollingLobbyIntervalSeconds", 60)
local v24 = game:DefineFastInt("ActiveSquadPollingIdleIntervalSeconds", 120)
local v25 = game:DefineFastInt("ActiveSquadInitPollingDelaySeconds", 3)
local MessageId = MessageBusService:GetMessageId("Realtime", "appResume")

return function(p1) -- line: 41
	-- upvalues: useDispatch (copy), useLocalUserId (copy), React (copy), SquadExternalContractContext (copy), useSquadState (copy), setTimeout (copy), fetchActiveSquad (copy), v25 (copy), clearTimeout (copy), SquadViewFlags (copy), v22 (copy), v23 (copy), v24 (copy), setInterval (copy), clearInterval (copy), RealtimeDelivery (copy), Constants (copy), Logger (copy), serializeTable (copy), RoduxSquads (copy), SquadState (copy), MessageBusService (copy), MessageId (copy)
	local v28 = useDispatch()
	local v29 = tonumber(useLocalUserId()) or 0
	local v30, v31 = React.useState(false)
	local v32 = React.useContext(SquadExternalContractContext).useSquadViewFlags()
	local v33 = useSquadState()
	local v34, v35 = React.useState(-1)

	React.useEffect(function() -- line: 54
		-- upvalues: v31 (copy), p1 (copy), setTimeout (copy), v28 (copy), fetchActiveSquad (copy), v25 (copy), clearTimeout (copy)
		v31(false)

		local v37 = if p1.currentSquadId == "" then nil else setTimeout(function() -- line: 57
			-- upvalues: v28 (copy), fetchActiveSquad (copy), v31 (copy)
			v28(fetchActiveSquad())
			v31(true)
		end, v25 * 1000)

		return function() -- line: 63
			-- upvalues: v37 (copy), clearTimeout (copy)
			if v37 then
				clearTimeout(v37)
			end
		end
	end, { p1.currentSquadId })
	React.useEffect(function() -- line: 73
		-- upvalues: v32 (copy), SquadViewFlags (copy), v22 (copy), v23 (copy), v24 (copy), v30 (copy), p1 (copy), setInterval (copy), v28 (copy), fetchActiveSquad (copy), clearInterval (copy)
		local v38 = if bit32.band(v32, SquadViewFlags.SquadSystemMessage) == 0 then if bit32.band(v32, SquadViewFlags.SquadLobby) == 0 then v24 else v23 else v22
		local u39 = if not v30 or p1.currentSquadId == "" then nil else setInterval(function() -- line: 85
			-- upvalues: v28 (copy), fetchActiveSquad (copy)
			v28(fetchActiveSquad())
		end, v38 * 1000)

		return function() -- line: 90
			-- upvalues: u39 (ref), clearInterval (copy)
			if u39 then
				clearInterval(u39)
			end
		end
	end, {
		p1.currentSquadId,
		v32,
		v34,
		v30
	})

	local v36 = React.useCallback(function(n1: number) -- line: 101
		-- upvalues: v34 (copy), v28 (copy), fetchActiveSquad (copy), v35 (copy)
		if n1 > v34 then
			v28(fetchActiveSquad()):andThen(function() -- line: 103
				-- upvalues: v35 (copy), n1 (copy)
				v35(n1)
			end)
		end
	end, {
		v28,
		fetchActiveSquad,
		v35,
		v34
	})

	RealtimeDelivery.useRealtimeNamespace(Constants.COMMUNICATION_CHANNEL_RTN_NAMESPACE, function(p2) -- line: 110
		-- upvalues: Constants (copy), Logger (copy), serializeTable (copy), p1 (copy), v29 (copy), v28 (copy), RoduxSquads (copy), v36 (copy), v33 (copy), SquadState (copy)
		if p2.ChannelType == Constants.SQUAD_CHANNEL_TYPE then
			Logger:debug("Squad RTN received. Detail: {}, CurrentSquadId: {}, LocalUserId: {}", serializeTable(p2), p1.currentSquadId, v29)

			if p1.currentSquadId == p2.ChannelId then
				if p2.Type == Constants.CHANNEL_LOCAL_USER_REMOVED_DETAIL_TYPE or p2.Type == Constants.CHANNEL_DELETED_DETAIL_TYPE then
					v28(RoduxSquads.Actions.CurrentSquadUpdated(nil))

					return
				end

				if p2.Type == Constants.CHANNEL_PARTICIPANT_ADDED_DETAIL_TYPE or p2.Type == Constants.CHANNEL_PARTICIPANT_REMOVED_DETAIL_TYPE or p2.Type == Constants.CHANNEL_UPDATED_DETAIL_TYPE or p2.Type == Constants.CHANNEL_PARTICIPANT_INVITED_DETAIL_TYPE then
					v36(p2.SequenceNumber)

					return
				end
			elseif v33 ~= SquadState.Initializing then
				local v42 = p2.Actor and (p2.Actor.Type == "User" and p2.Actor.Id == tostring(v29))

				if p2.Type == Constants.CHANNEL_CREATED_DETAIL_TYPE and v42 then
					v36(p2.SequenceNumber)

					return
				end

				if p2.Type == Constants.CHANNEL_LOCAL_USER_ADDED_DETAIL_TYPE then
					v36(p2.SequenceNumber)
				end
			end
		end
	end, {
		p1.currentSquadId,
		v28,
		v29,
		v36,
		v33
	})
	React.useEffect(function() -- line: 166
		-- upvalues: MessageBusService (copy), MessageId (copy), p1 (copy), v28 (copy), fetchActiveSquad (copy)
		local v43 = MessageBusService:Subscribe(MessageId, function() -- line: 167
			-- upvalues: p1 (copy), v28 (copy), fetchActiveSquad (copy)
			if p1.currentSquadId ~= "" then
				v28(fetchActiveSquad())
			end
		end, false, true)

		return function() -- line: 172
			-- upvalues: v43 (copy)
			if v43 then
				v43:Disconnect()
			end
		end
	end, {
		p1.currentSquadId,
		v28
	})

	return nil
end
