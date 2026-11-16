local parent = script:FindFirstAncestor("SocialCards").Parent

local React = require(parent.React)
local RealtimeDelivery = require(parent.RealtimeDelivery)

local CallCardStatus = require(script.Parent.CallCardStatus)
local getCallCard = require(script.Parent.getCallCard)
require(script.Parent.mapCallCard)
local parseCallCard = require(script.Parent.parseCallCard)

local set = {
	[CallCardStatus.Answered] = true,
	[CallCardStatus.Declined] = true,
	[CallCardStatus.Cancelled] = true,
	[CallCardStatus.Missed] = true
}

local v = nil
pcall(function()
	local FriendsCallingService = game:GetService("FriendsCallingService")
	v = FriendsCallingService
end)

local Players = game:GetService("Players")

local function liveInstance(callId: string)
	if v == nil then
		return nil
	end

	for _, child in v:GetChildren() do
		if child.ClassName == "FriendsCallingInstance" and child.CallId ~= "" and child.CallId == callId then
			local name = child.Phase.Name
			local status

			if name == "Ringing" then
				status = CallCardStatus.Ringing
			elseif name == "Active" then
				status = CallCardStatus.Ongoing
			elseif name == "Ended" then
				status = CallCardStatus.Ended
			end

			if status == nil then
				return nil
			end

			return { status = status, initiatorUserId = child.InitiatorUserId }
		end
	end

	return nil
end

local function isLocalInitiator(initiatorUserId: number, isInitiator: boolean) -- 1 equivalent call inferred from this helper
	local localPlayer = Players.LocalPlayer

	if localPlayer == nil or initiatorUserId == 0 then
		return isInitiator
	end

	return localPlayer.UserId == initiatorUserId
end

local function useCallCard(p)
	local callId = p.callId
	local state, setState = React.useState(nil)
	local ref = React.useRef(0)
	local state2, setState2 = React.useState(nil)

	if state == nil or state.callId ~= callId then
		state = p
	end

	local ref2 = React.useRef(state)
	ref2.current = state

	local v2 = React.useCallback(function()
		if liveInstance(callId) ~= nil or set[ref2.current.status] then
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
	end, { callId, p })

	React.useEffect(function()
		return function()
			ref.current += 1
		end
	end, {})

	React.useEffect(function()
		if v == nil then
			return
		end

		local connections = {}
		local v3 = true
		local v4 = false

		local function sync()
			local v5 = liveInstance(callId)
			local v6 = v5 ~= nil
			local v7 = not v3 and v4 and not v6
			v3 = false
			v4 = v6

			if v5 == nil then
				setState2(nil)
			else
				setState2({
					callId = callId,
					status = v5.status,
					isInitiator = isLocalInitiator(v5.initiatorUserId, ref2.current.isInitiator) -- inferred equivalent call
				})
			end

			if v7 then
				v2()
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

		for _, child in v:GetChildren() do
			watch(child)
		end

		table.insert(connections, v.ChildAdded:Connect(function(child)
			watch(child)
			sync()
		end))

		table.insert(connections, v.ChildRemoved:Connect(function()
			sync()
		end))

		sync()

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { callId, v2 })

	RealtimeDelivery.useRealtimeNamespace("CallV2", function(p2)
		if p2.type == "CallCardUpdated" and p2.callId == callId then
			v2()
		end
	end, { callId, v2 })

	RealtimeDelivery.useRealtimeConnectionStateChanged("CallV2", function(p2, p3)
		if p2 == Enum.ConnectionState.Connected and p3 then
			v2()
		end
	end, { v2 })

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
