local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/React")
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/RealtimeDelivery")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/SignalsReact")

local CallCardStatus = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/CallCard/CallCardStatus")
local getCallCard = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/CallCard/getCallCard")
require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/CallCard/mapCallCard")
local parseCallCard = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/CallCard/parseCallCard")

local GetFriendsCallingStore = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/FriendsCalling/GetFriendsCallingStore")

local useSignalState = SignalsReact.useSignalState

local set = {
	[CallCardStatus.Answered] = true,
	[CallCardStatus.Declined] = true,
	[CallCardStatus.Cancelled] = true,
	[CallCardStatus.Missed] = true
}

local friendsCallingPhase = Enum.FriendsCallingPhase

local v5 = {
	[friendsCallingPhase.Ringing] = CallCardStatus.Ringing,
	[friendsCallingPhase.Active] = CallCardStatus.Ongoing,
	[friendsCallingPhase.Ended] = CallCardStatus.Ended
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

local function useCallCard(p2)
	local callId = p2.callId
	local state, setState = React.useState(nil)
	local ref = React.useRef(0)
	local ref2 = React.useRef(nil)

	if state == nil or state.callId ~= callId then
		state = p2
	end

	local ref3 = React.useRef(state)
	ref3.current = state

	local v6 = React.useMemo(function()
		return Signals.createComputed(function(p3)
			local callId2 = nil
			local v7 = nil

			for k, v8 in GetFriendsCallingStore(p3).getCalls(p3) do
				if v8.callId == callId then
					v7 = v8
				elseif v8.callId ~= "" and callId2 == nil then
					callId2 = v8.callId
				end
			end

			local v8 = {
				callId = callId,
				status = 0,
				otherCallId = 0,
				initiatorUserId = 0
			}

			local v9 = if v7 ~= nil then v5[v7.phase] else nil
			v8.status = v9
			v8.otherCallId = callId2
			local v10 = if v7 ~= nil then v7.initiatorUserId else nil
			v8.initiatorUserId = v10
			return v8
		end, sameSnapshot)
	end, { callId })
	local v7 = useSignalState(v6)

	if v7.callId ~= callId then
		v7 = nil
	end

	local status = if v7 ~= nil then v7.status else nil

	local v8 = React.useCallback(function()
		if v6(false).status ~= nil or set[ref3.current.status] then
			return
		end

		ref.current += 1
		local current = ref.current
		getCallCard(callId, function(p3)
			if current ~= ref.current then
				return
			end

			setState(parseCallCard.applyCallCardRefresh(p2, p3))
		end)
	end, { callId, v6, p2 })

	React.useEffect(function()
		return function()
			ref.current += 1
		end
	end, {})

	React.useEffect(function()
		local v9 = if status ~= nil then callId else nil

		if ref2.current == callId and v9 == nil then
			v8()
		end

		ref2.current = v9
	end, { callId, status, v8 })

	RealtimeDelivery.useRealtimeNamespace("CallV2", function(p3)
		if p3.type == "CallCardUpdated" and p3.callId == callId then
			v8()
		end
	end, { callId, v8 })

	RealtimeDelivery.useRealtimeConnectionStateChanged("CallV2", function(p3, p4)
		if p3 == Enum.ConnectionState.Connected and p4 then
			v8()
		end
	end, { v8 })

	local otherCallId = if v7 ~= nil then v7.otherCallId else nil
	local initiatorUserId = if v7 ~= nil then v7.initiatorUserId else nil
	local Players = game:GetService("Players")
	local localPlayer = Players.LocalPlayer
	local v9

	if initiatorUserId == nil or initiatorUserId == 0 or localPlayer == nil then
		v9 = state.isInitiator
	else
		v9 = localPlayer.UserId == initiatorUserId
	end

	if status == nil then
		return state, otherCallId, false
	end

	return {
		callId = state.callId,
		isInitiator = v9,
		status = status,
		durationSeconds = nil,
		enableJoin = state.enableJoin
	}, otherCallId, true
end

return useCallCard
