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
	local getCall = Signals.createComputed(function(p)
		return signal(p)[1]
	end)

	local getCallId = Signals.createComputed(function(p)
		local v3 = getCall(p)
		return if v3 then v3.callId else nil
	end)

	local getHasCall = Signals.createComputed(function(p): boolean
		return getCall(p) ~= nil
	end)

	local getWindowView = Signals.createComputed(function(p)
		return { hasCall = getHasCall(p), session = signal2(p) }
	end)

	local v3 = {}
	local count = 0
	local count2 = 0
	local v4 = false

	local function publish()
		local clone = table.clone(v3)
		table.sort(clone, function(a, b): boolean
			return a.arrivalOrder < b.arrivalOrder
		end)

		local v5 = {}

		for _, v6 in clone do
			table.insert(v5, readCall(v6.instance))
		end

		local v6 = #v5 > 0
		local v7 = v4 and not v6
		v4 = v6

		v(v5)

		if v7 then
			count2 += 1
			v2(count2)
		end

		local v8 = v5[1]
		Logger:debug(
			"{} - published: hasCall={}, session={}, callId={}, phase={}, endReason={}, participants={}",
			script.Name,
			tostring(v6),
			count2,
			v8 and v8.callId or "",
			not v8 and "" or v8.phase.Name,
			not v8 and "" or v8.endReason.Name,
			v8 and #v8.participants or 0
		)
	end

	local function unobserveCall(child)
		for k, v5 in v3 do
			if v5.instance == child then
				Logger:debug(
					"{} - unobserveCall: callId={}, phase={}",
					script.Name,
					child.CallId or "",
					child.Phase.Name
				)
				disconnectObservedCall(v5)
				table.remove(v3, k)
				publish()
				break
			end
		end
	end

	local function observeCall(child)
		for _, v5 in v3 do
			if v5.instance == child then
				return
			end
		end

		Logger:debug("{} - observeCall: callId={}, phase={}", script.Name, child.CallId or "", child.Phase.Name)
		count += 1
		local v5 = {
			instance = child,
			arrivalOrder = count,
			connections = {},
			participantConnections = {}
		}

		table.insert(v3, v5)

		local function observeParticipant(child2) -- 2 equivalent calls inferred from this helper
			if child2.ClassName == "FriendsCallingParticipant" and not v5.participantConnections[child2] then
				v5.participantConnections[child2] = child2.Changed:Connect(function(p: string)
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
			local participantConnection = v5.participantConnections[child2]

			if participantConnection then
				participantConnection:Disconnect()
				v5.participantConnections[child2] = nil
			end
		end

		table.insert(v5.connections, child.Changed:Connect(function(p: string)
			Logger:debug(
				"{} - call.Changed: property {}, callId={}, phase={}",
				script.Name,
				p,
				child.CallId or "",
				child.Phase.Name
			)

			publish()
		end))

		table.insert(v5.connections, child.ChildAdded:Connect(function(child2)
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

		table.insert(v5.connections, child.ChildRemoved:Connect(function(child2)
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

		for _, v5 in v3 do
			disconnectObservedCall(v5)
		end

		table.clear(v3)
		local v5 = v4
		v4 = false
		v({})

		if v5 then
			count2 += 1
			v2(count2)
		end
	end

	return {
		getCalls = signal,
		getCall = getCall,
		getCallId = getCallId,
		getHasCall = getHasCall,
		getSession = signal2,
		getWindowView = getWindowView,
		cleanup = cleanup
	}
end
