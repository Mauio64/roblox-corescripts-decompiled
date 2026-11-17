local parent = script:FindFirstAncestor("SocialCards").Parent

local React = require(parent.React)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local CallCardStatus = require(script.Parent.CallCardStatus)
local getCallCard = require(script.Parent.getCallCard)
require(script.Parent.mapCallCard)
local parseCallCard = require(script.Parent.parseCallCard)

local GetFriendsCallingStore = require(parent.FriendsCalling.GetFriendsCallingStore)

local useSignalState = SignalsReact.useSignalState

local set = {
	[CallCardStatus.Answered] = true,
	[CallCardStatus.Declined] = true,
	[CallCardStatus.Cancelled] = true,
	[CallCardStatus.Missed] = true
}

local FriendsCallingPhase = Enum.FriendsCallingPhase

local v = {
	[FriendsCallingPhase.Ringing] = CallCardStatus.Ringing,
	[FriendsCallingPhase.Active] = CallCardStatus.Ongoing,
	[FriendsCallingPhase.Ended] = CallCardStatus.Ended
}

local function sameSnapshot(data, data2): boolean
	if data == nil or data2 == nil then
		return data == data2
	end

	return data.callId == data2.callId
		and data.status == data2.status
		and data.otherCallId == data2.otherCallId
		and data.initiatorUserId == data2.initiatorUserId
end

local function useCallCard(p)
	local callId = p.callId
	local state, setState = React.useState(nil)
	local ref = React.useRef(0)
	local ref2 = React.useRef(nil)

	if state == nil or state.callId ~= callId then
		state = p
	end

	local ref3 = React.useRef(state)
	ref3.current = state

	local v2 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			local callId2 = nil
			local v2 = nil

			for _, v3 in GetFriendsCallingStore(p2).getCalls(p2) do
				if v3.callId == callId then
					v2 = v3
				elseif v3.callId ~= "" and callId2 == nil then
					callId2 = v3.callId
				end
			end

			local v3 = { callId = callId, status = 0, otherCallId = 0, initiatorUserId = 0 }
			local status

			if v2 ~= nil then
				status = v[v2.phase]
			end

			v3.status = status
			v3.otherCallId = callId2
			local initiatorUserId

			if v2 ~= nil then
				initiatorUserId = v2.initiatorUserId
			end

			v3.initiatorUserId = initiatorUserId
			return v3
		end, sameSnapshot)
	end, { callId })
	local v3 = useSignalState(v2)

	if v3.callId ~= callId then
		v3 = nil
	end

	local status

	if v3 == nil then
		status = nil
	else
		status = v3.status
	end

	local v4 = React.useCallback(function()
		if v2(false).status ~= nil or set[ref3.current.status] then
			return
		end

		ref.current += 1
		local current = ref.current
		getCallCard(callId, function(p2)
			if current ~= ref.current then
				return
			end

			setState(parseCallCard.applyCallCardRefresh(p, p2))
		end)
	end, { callId, v2, p })

	React.useEffect(function()
		return function()
			ref.current += 1
		end
	end, {})

	React.useEffect(function()
		local current

		if status ~= nil then
			current = callId
		end

		if ref2.current == callId and current == nil then
			v4()
		end

		ref2.current = current
	end, { callId, status, v4 })

	RealtimeDelivery.useRealtimeNamespace("CallV2", function(p2)
		if p2.type == "CallCardUpdated" and p2.callId == callId then
			v4()
		end
	end, { callId, v4 })

	RealtimeDelivery.useRealtimeConnectionStateChanged("CallV2", function(p2, p3)
		if p2 == Enum.ConnectionState.Connected and p3 then
			v4()
		end
	end, { v4 })
	local otherCallId

	if v3 ~= nil then
		otherCallId = v3.otherCallId
	end

	local initiatorUserId

	if v3 ~= nil then
		initiatorUserId = v3.initiatorUserId
	end

	local Players = game:GetService("Players")
	local localPlayer = Players.LocalPlayer
	local isInitiator

	if initiatorUserId == nil or initiatorUserId == 0 or localPlayer == nil then
		isInitiator = state.isInitiator
	else
		isInitiator = localPlayer.UserId == initiatorUserId
	end

	if status == nil then
		return state, otherCallId, false
	end

	return {
		callId = state.callId,
		isInitiator = isInitiator,
		status = status,
		durationSeconds = nil,
		enableJoin = state.enableJoin
	}, otherCallId, true
end

return useCallCard
