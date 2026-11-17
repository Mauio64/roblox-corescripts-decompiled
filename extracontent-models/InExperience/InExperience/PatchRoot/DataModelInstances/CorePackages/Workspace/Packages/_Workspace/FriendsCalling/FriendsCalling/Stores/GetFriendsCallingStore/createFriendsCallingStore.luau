local FriendsCalling = script:FindFirstAncestor("FriendsCalling")
local parent = FriendsCalling.Parent

local Signals = require(parent.Signals)

local Logger = require(FriendsCalling.Logger)

local FriendsCallingEndReason = Enum.FriendsCallingEndReason
local FriendsCallingParticipantStatus = Enum.FriendsCallingParticipantStatus
local FriendsCallingPhase = Enum.FriendsCallingPhase

local function readParticipant(child) -- 1 equivalent call inferred from this helper
	return {
		userId = child.UserId,
		status = child.Status,
		leaveReason = child.LeaveReason.Name,
		volume = child.Volume,
		isLocalMuted = child.IsLocalMuted,
		isSpeaking = child.IsSpeaking,
		error = child.Error.Name
	}
end

local function readCall(instance)
	local participants = {}

	for _, child in instance:GetChildren() do
		if child.ClassName == "FriendsCallingParticipant" then
			table.insert(participants, readParticipant(child)) -- inferred equivalent call
		end
	end

	return {
		callId = instance.CallId,
		phase = instance.Phase,
		initiatorUserId = instance.InitiatorUserId,
		endReason = instance.EndReason,
		volume = instance.Volume,
		isDeafened = instance.IsDeafened,
		conversationId = instance.ConversationId,
		participants = participants
	}
end

local function disconnectObservedCall(p)
	for _, connection in p.connections do
		connection:Disconnect()
	end

	for _, participantConnection in p.participantConnections do
		participantConnection:Disconnect()
	end
end

return function(instance)
	local signal, v = Signals.createSignal({})
	local signal2, v2 = Signals.createSignal(0)
	local count = 0
	local signal3, v3 = Signals.createSignal(0)
	local getCall = Signals.createComputed(function(p)
		return signal(p)[1]
	end)

	local getCallId = Signals.createComputed(function(p)
		local v4 = getCall(p)
		return if v4 then v4.callId else nil
	end)

	local getHasCall = Signals.createComputed(function(p): boolean
		return getCall(p) ~= nil
	end)

	local getWindowView = Signals.createComputed(function(p)
		return { hasCall = getHasCall(p), session = signal2(p) }
	end)

	local v4 = {}
	local count2 = 0
	local count3 = 0
	local v5 = false

	local function publish()
		local clone = table.clone(v4)
		table.sort(clone, function(a, b): boolean
			return a.arrivalOrder < b.arrivalOrder
		end)

		local v6 = {}

		for _, v7 in clone do
			table.insert(v6, readCall(v7.instance))
		end

		local v7 = #v6 > 0
		local v8 = v5 and not v7
		v5 = v7

		v(v6)

		if v8 then
			count3 += 1
			v2(count3)
		end

		local v9 = v6[1]
		Logger:debug(
			"{} - published: hasCall={}, session={}, callId={}, phase={}, endReason={}, participants={}",
			script.Name,
			tostring(v7),
			count3,
			v9 and v9.callId or "",
			not v9 and "" or v9.phase.Name,
			not v9 and "" or v9.endReason.Name,
			v9 and #v9.participants or 0
		)
	end

	local function unobserveCall(child)
		for k, v6 in v4 do
			if v6.instance == child then
				Logger:debug(
					"{} - unobserveCall: callId={}, phase={}",
					script.Name,
					child.CallId or "",
					child.Phase.Name
				)
				disconnectObservedCall(v6)
				table.remove(v4, k)
				publish()
				break
			end
		end
	end

	local function observeCall(child)
		for _, v6 in v4 do
			if v6.instance == child then
				return
			end
		end

		Logger:debug("{} - observeCall: callId={}, phase={}", script.Name, child.CallId or "", child.Phase.Name)
		count2 += 1
		local v6 = {
			instance = child,
			arrivalOrder = count2,
			connections = {},
			participantConnections = {}
		}

		table.insert(v4, v6)

		local function observeParticipant(child2) -- 2 equivalent calls inferred from this helper
			if child2.ClassName == "FriendsCallingParticipant" and not v6.participantConnections[child2] then
				v6.participantConnections[child2] = child2.Changed:Connect(function(p: string)
					Logger:debug(
						"{} - child.Changed: property {}, userId={}, callId={}",
						script.Name,
						p,
						child2.UserId,
						child.CallId or ""
					)

					publish()
				end)
			end
		end

		local function unobserveParticipant(child2) -- 1 equivalent call inferred from this helper
			local participantConnection = v6.participantConnections[child2]

			if participantConnection then
				participantConnection:Disconnect()
				v6.participantConnections[child2] = nil
			end
		end

		table.insert(v6.connections, child.Changed:Connect(function(p: string)
			Logger:debug(
				"{} - call.Changed: property {}, callId={}, phase={}",
				script.Name,
				p,
				child.CallId or "",
				child.Phase.Name
			)

			publish()
		end))

		table.insert(v6.connections, child.ChildAdded:Connect(function(child2)
			if child2.ClassName == "FriendsCallingParticipant" then
				Logger:debug(
					"{} - call.ChildAdded: userId={}, callId={}",
					script.Name,
					child2.UserId,
					child.CallId or ""
				)
			end

			observeParticipant(child2) -- inferred equivalent call
			publish()
		end))

		table.insert(v6.connections, child.ChildRemoved:Connect(function(child2)
			if child2.ClassName == "FriendsCallingParticipant" then
				Logger:debug(
					"{} - call.ChildRemoved: userId={}, callId={}",
					script.Name,
					child2.UserId,
					child.CallId or ""
				)
			end

			unobserveParticipant(child2) -- inferred equivalent call
			publish()
		end))

		for _, child2 in child:GetChildren() do
			observeParticipant(child2) -- inferred equivalent call
		end

		publish()
	end

	Logger:debug("{} - created: watching {} for FriendsCallingInstance", script.Name, instance.ClassName)

	local childAddedConnection = instance.ChildAdded:Connect(function(child)
		if child.ClassName == "FriendsCallingInstance" then
			observeCall(child)
		end
	end)
	local childRemovedConnection = instance.ChildRemoved:Connect(function(child)
		if child.ClassName == "FriendsCallingInstance" then
			unobserveCall(child)
		end
	end)

	for _, child in instance:GetChildren() do
		if child.ClassName == "FriendsCallingInstance" then
			observeCall(child)
		end
	end

	local function cleanup()
		Logger:debug("{} - store cleanup", script.Name)
		childAddedConnection:Disconnect()
		childRemovedConnection:Disconnect()

		for _, v6 in v4 do
			disconnectObservedCall(v6)
		end

		table.clear(v4)
		local v6 = v5
		v5 = false
		v({})

		if v6 then
			count3 += 1
			v2(count3)
		end
	end

	local function expand()
		count += 1
		v3(count)
	end

	return {
		getCalls = signal,
		getCall = getCall,
		getCallId = getCallId,
		getHasCall = getHasCall,
		getSession = signal2,
		getWindowView = getWindowView,
		getExpandCount = signal3,
		expand = expand,
		cleanup = cleanup
	}
end
