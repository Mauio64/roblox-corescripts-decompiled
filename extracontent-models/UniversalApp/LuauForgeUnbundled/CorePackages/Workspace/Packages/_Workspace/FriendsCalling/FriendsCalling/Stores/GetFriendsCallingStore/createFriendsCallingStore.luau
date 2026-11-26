local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/Signals")

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/FriendsCalling/Logger")

local friendsCallingEndReason = Enum.FriendsCallingEndReason
local friendsCallingParticipantStatus = Enum.FriendsCallingParticipantStatus
local friendsCallingPhase = Enum.FriendsCallingPhase

local function readParticipant(data)
	return {
		userId = data.UserId,
		status = data.Status,
		leaveReason = data.LeaveReason.Name,
		volume = data.Volume,
		isLocalMuted = data.IsLocalMuted,
		isSpeaking = data.IsSpeaking,
		error = data.Error.Name
	}
end

local function readCall(instance)
	local v5 = {}

	for i, child in instance:GetChildren() do
		if child.ClassName == "FriendsCallingParticipant" then
			table.insert(v5, {
				userId = child.UserId,
				status = child.Status,
				leaveReason = child.LeaveReason.Name,
				volume = child.Volume,
				isLocalMuted = child.IsLocalMuted,
				isSpeaking = child.IsSpeaking,
				error = child.Error.Name
			})
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
		participants = v5
	}
end

local function disconnectObservedCall(p2)
	for k, connection in p2.connections do
		connection:Disconnect()
	end

	for k, participantConnection in p2.participantConnections do
		participantConnection:Disconnect()
	end
end

return function(instance)
	local signal, v5 = Signals.createSignal({})
	local signal2, v6 = Signals.createSignal(0)
	local count = 0
	local signal3, v7 = Signals.createSignal(0)
	local computed = Signals.createComputed(function(p2)
		return signal(p2)[1]
	end)

	local computed2 = Signals.createComputed(function(p2)
		local v8 = computed(p2)

		if v8 then
			return v8.callId
		end

		return nil
	end)

	local computed3 = Signals.createComputed(function(p2): boolean
		return computed(p2) ~= nil
	end)

	local computed4 = Signals.createComputed(function(p2)
		return { hasCall = computed3(p2), session = signal2(p2) }
	end)

	local v8 = {}
	local count2 = 0
	local count3 = 0
	local v9 = false

	local function publish()
		local clone = table.clone(v8)
		table.sort(clone, function(a, b): boolean
			return a.arrivalOrder < b.arrivalOrder
		end)

		local v10 = {}

		for k, v11 in clone do
			table.insert(v10, readCall(v11.instance))
		end

		local v11 = #v10 > 0
		local v12 = v9 and not v11
		v9 = v11

		v5(v10)

		if v12 then
			count3 += 1
			v6(count3)
		end

		local v13 = v10[1]
		Logger:debug(
			"{} - published: hasCall={}, session={}, callId={}, phase={}, endReason={}, participants={}",
			"createFriendsCallingStore",
			tostring(v11),
			count3,
			v13 and v13.callId or "",
			not v13 and "" or v13.phase.Name,
			not v13 and "" or v13.endReason.Name,
			v13 and #v13.participants or 0
		)
	end

	local function unobserveCall(child)
		for k, v10 in v8 do
			if v10.instance == child then
				Logger:debug(
					"{} - unobserveCall: callId={}, phase={}",
					"createFriendsCallingStore",
					child.CallId or "",
					child.Phase.Name
				)
				disconnectObservedCall(v10)
				table.remove(v8, k)
				publish()
				break
			end
		end
	end

	local function observeCall(child)
		for k, v10 in v8 do
			if v10.instance == child then
				return
			end
		end

		Logger:debug(
			"{} - observeCall: callId={}, phase={}",
			"createFriendsCallingStore",
			child.CallId or "",
			child.Phase.Name
		)
		count2 += 1
		local v10 = {
			instance = child,
			arrivalOrder = count2,
			connections = {},
			participantConnections = {}
		}

		table.insert(v8, v10)

		local function observeParticipant(instance2)
			if
				instance2.ClassName == "FriendsCallingParticipant"
				and not v10.participantConnections[instance2]
			then
				v10.participantConnections[instance2] = instance2.Changed:Connect(function(p2)
					Logger:debug(
						"{} - child.Changed: property {}, userId={}, callId={}",
						"createFriendsCallingStore",
						p2,
						instance2.UserId,
						child.CallId or ""
					)

					publish()
				end)
			end
		end

		local function unobserveParticipant(p2)
			local participantConnection = v10.participantConnections[p2]

			if participantConnection then
				participantConnection:Disconnect()
				v10.participantConnections[p2] = nil
			end
		end

		table.insert(v10.connections, child.Changed:Connect(function(p2)
			Logger:debug(
				"{} - call.Changed: property {}, callId={}, phase={}",
				"createFriendsCallingStore",
				p2,
				child.CallId or "",
				child.Phase.Name
			)

			publish()
		end))

		table.insert(v10.connections, child.ChildAdded:Connect(function(child2)
			if child2.ClassName == "FriendsCallingParticipant" then
				Logger:debug(
					"{} - call.ChildAdded: userId={}, callId={}",
					"createFriendsCallingStore",
					child2.UserId,
					child.CallId or ""
				)
			end

			if
				child2.ClassName == "FriendsCallingParticipant"
				and not v10.participantConnections[child2]
			then
				v10.participantConnections[child2] = child2.Changed:Connect(function(p2)
					Logger:debug(
						"{} - child.Changed: property {}, userId={}, callId={}",
						"createFriendsCallingStore",
						p2,
						child2.UserId,
						child.CallId or ""
					)

					publish()
				end)
			end

			publish()
		end))

		table.insert(v10.connections, child.ChildRemoved:Connect(function(child2)
			if child2.ClassName == "FriendsCallingParticipant" then
				Logger:debug(
					"{} - call.ChildRemoved: userId={}, callId={}",
					"createFriendsCallingStore",
					child2.UserId,
					child.CallId or ""
				)
			end

			local participantConnection = v10.participantConnections[child2]

			if participantConnection then
				participantConnection:Disconnect()
				v10.participantConnections[child2] = nil
			end

			publish()
		end))

		for i, child2 in child:GetChildren() do
			if child2.ClassName ~= "FriendsCallingParticipant" or v10.participantConnections[child2] then
				continue
			end

			v10.participantConnections[child2] = child2.Changed:Connect(function(p2)
				Logger:debug(
					"{} - child.Changed: property {}, userId={}, callId={}",
					"createFriendsCallingStore",
					p2,
					child2.UserId,
					child.CallId or ""
				)

				publish()
			end)
		end

		publish()
	end

	Logger:debug(
		"{} - created: watching {} for FriendsCallingInstance",
		"createFriendsCallingStore",
		instance.ClassName
	)

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

	for i, child in instance:GetChildren() do
		if child.ClassName == "FriendsCallingInstance" then
			observeCall(child)
		end
	end

	local function cleanup()
		Logger:debug("{} - store cleanup", "createFriendsCallingStore")
		childAddedConnection:Disconnect()
		childRemovedConnection:Disconnect()

		for k, v10 in v8 do
			disconnectObservedCall(v10)
		end

		table.clear(v8)
		local v10 = v9
		v9 = false
		v5({})

		if v10 then
			count3 += 1
			v6(count3)
		end
	end

	local function expand()
		count += 1
		v7(count)
	end

	return {
		getCalls = signal,
		getCall = computed,
		getCallId = computed2,
		getHasCall = computed3,
		getSession = signal2,
		getWindowView = computed4,
		getExpandCount = signal3,
		expand = expand,
		cleanup = cleanup
	}
end
