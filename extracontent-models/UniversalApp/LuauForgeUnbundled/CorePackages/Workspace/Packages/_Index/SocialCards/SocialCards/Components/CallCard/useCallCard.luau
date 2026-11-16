local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/React")
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/RealtimeDelivery")

local CallCardStatus = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/CallCard/CallCardStatus")
local getCallCard = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/CallCard/getCallCard")
require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/CallCard/mapCallCard")
local parseCallCard = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/CallCard/parseCallCard")

local set = {
	[CallCardStatus.Answered] = true,
	[CallCardStatus.Declined] = true,
	[CallCardStatus.Cancelled] = true,
	[CallCardStatus.Missed] = true
}

local v5 = nil
pcall(function()
	local FriendsCallingService = game:GetService("FriendsCallingService")
	v5 = FriendsCallingService
end)

local Players = game:GetService("Players")

local function liveInstance(callId)
	if v5 == nil then
		return nil
	end

	for i, child in v5:GetChildren() do
		if
			child.ClassName == "FriendsCallingInstance"
			and child.CallId ~= ""
			and child.CallId == callId
		then
			local name = child.Phase.Name
			local v6

			if name == "Ringing" then
				v6 = CallCardStatus.Ringing
			elseif name == "Active" then
				v6 = CallCardStatus.Ongoing
			elseif name == "Ended" then
				v6 = CallCardStatus.Ended
			end

			if v6 == nil then
				return nil
			end

			return { status = v6, initiatorUserId = child.InitiatorUserId }
		end
	end

	return nil
end

local function isLocalInitiator(p2, p3)
	local localPlayer = Players.LocalPlayer

	if localPlayer == nil or p2 == 0 then
		return p3
	end

	return localPlayer.UserId == p2
end

local function useCallCard(p2)
	local callId = p2.callId
	local state, setState = React.useState(nil)
	local ref = React.useRef(0)
	local state2, setState2 = React.useState(nil)

	if state == nil or state.callId ~= callId then
		state = p2
	end

	local ref2 = React.useRef(state)
	ref2.current = state

	local v6 = React.useCallback(function()
		if liveInstance(callId) ~= nil or set[ref2.current.status] then
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
	end, { callId, p2 })

	React.useEffect(function()
		return function()
			ref.current += 1
		end
	end, {})

	React.useEffect(function()
		if v5 == nil then
			return
		end

		local connections = {}
		local v7 = true
		local v8 = false

		local function sync()
			local v9 = liveInstance(callId)
			local v10 = v9 ~= nil
			local v11 = not v7 and v8 and not v10
			v7 = false
			v8 = v10

			if v9 == nil then
				setState2(nil)
			else
				local v13 = { callId = callId, status = v9.status, isInitiator = 0 }
				local initiatorUserId = v9.initiatorUserId
				local v14 = ref2.current.isInitiator
				local localPlayer = Players.LocalPlayer

				if localPlayer ~= nil and initiatorUserId ~= 0 then
					v14 = localPlayer.UserId == initiatorUserId
				end

				v13.isInitiator = v14
				setState2(v13)
			end

			if v11 then
				v6()
			end
		end

		local function watch(child)
			if child.ClassName ~= "FriendsCallingInstance" then
				return
			end

			table.insert(connections, child:GetPropertyChangedSignal("CallId"):Connect(sync))
			table.insert(connections, child:GetPropertyChangedSignal("Phase"):Connect(sync))
			table.insert(connections, child:GetPropertyChangedSignal("InitiatorUserId"):Connect(sync))
		end

		for i, child in v5:GetChildren() do
			watch(child)
		end

		table.insert(connections, v5.ChildAdded:Connect(function(child)
			watch(child)
			sync()
		end))

		table.insert(connections, v5.ChildRemoved:Connect(function()
			sync()
		end))

		sync()

		return function()
			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end, { callId, v6 })

	RealtimeDelivery.useRealtimeNamespace("CallV2", function(p3)
		if p3.type == "CallCardUpdated" and p3.callId == callId then
			v6()
		end
	end, { callId, v6 })

	RealtimeDelivery.useRealtimeConnectionStateChanged("CallV2", function(p3, p4)
		if p3 == Enum.ConnectionState.Connected and p4 then
			v6()
		end
	end, { v6 })

	if state2 == nil or state2.callId ~= callId then
		return state
	end

	return {
		callId = state.callId,
		isInitiator = state2.isInitiator,
		status = state2.status,
		durationSeconds = nil,
		enableJoin = true
	}
end

return useCallCard
