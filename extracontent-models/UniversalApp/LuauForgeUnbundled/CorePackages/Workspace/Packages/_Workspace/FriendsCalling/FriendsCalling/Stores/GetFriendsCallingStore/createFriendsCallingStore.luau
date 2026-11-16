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
	local computed = Signals.createComputed(function(p2)
		return signal(p2)[1]
	end)

	local computed2 = Signals.createComputed(function(p2)
		local v7 = computed(p2)

		if v7 then
			return v7.callId
		end

		return nil
	end)

	local computed3 = Signals.createComputed(function(p2): boolean
		return computed(p2) ~= nil
	end)

	local computed4 = Signals.createComputed(function(p2)
		return { hasCall = computed3(p2), session = signal2(p2) }
	end)

	local v7 = {}
	local count = 0
	local count2 = 0
	local v8 = false

	local function publish()
		local clone = table.clone(v7)
		table.sort(clone, function(a, b): boolean
			return a.arrivalOrder < b.arrivalOrder
		end)

		local v9 = {}

		for k, v10 in clone do
			table.insert(v9, readCall(v10.instance))
		end

		local v10 = #v9 > 0
		local v11 = v8 and not v10
		v8 = v10

		v5(v9)

		if v11 then
			count2 += 1
			v6(count2)
		end

		local v12 = v9[1]
		Logger:debug(
			"{} - published: hasCall={}, session={}, callId={}, phase={}, endReason={}, participants={}",
			"createFriendsCallingStore",
			tostring(v10),
			count2,
			v12 and v12.callId or "",
			not v12 and "" or v12.phase.Name,
			not v12 and "" or v12.endReason.Name,
			v12 and #v12.participants or 0
		)
	end

	local function unobserveCall(child)
		for k, v9 in v7 do
			if v9.instance == child then
				Logger:debug(
					"{} - unobserveCall: callId={}, phase={}",
					"createFriendsCallingStore",
					child.CallId or "",
					child.Phase.Name
				)
				disconnectObservedCall(v9)
				table.remove(v7, k)
				publish()
				break
			end
		end
	end

	local function observeCall(child)
		for k, v9 in v7 do
			if v9.instance == child then
				return
			end
		end

		Logger:debug(
			"{} - observeCall: callId={}, phase={}",
			"createFriendsCallingStore",
			child.CallId or "",
			child.Phase.Name
		)
		count += 1
		local v9 = {
			instance = child,
			arrivalOrder = count,
			connections = {},
			participantConnections = {}
		}

		table.insert(v7, v9)

		local function observeParticipant(instance2)
			if
				instance2.ClassName == "FriendsCallingParticipant"
				and not v9.participantConnections[instance2]
			then
				v9.participantConnections[instance2] = instance2.Changed:Connect(function(p2)
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
			local participantConnection = v9.participantConnections[p2]

			if participantConnection then
				participantConnection:Disconnect()
				v9.participantConnections[p2] = nil
			end
		end

		table.insert(v9.connections, child.Changed:Connect(function(p2)
			Logger:debug(
				"{} - call.Changed: property {}, callId={}, phase={}",
				"createFriendsCallingStore",
				p2,
				child.CallId or "",
				child.Phase.Name
			)

			publish()
		end))

		table.insert(v9.connections, child.ChildAdded:Connect(function(child2)
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
				and not v9.participantConnections[child2]
			then
				v9.participantConnections[child2] = child2.Changed:Connect(function(p2)
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

		table.insert(v9.connections, child.ChildRemoved:Connect(function(child2)
			if child2.ClassName == "FriendsCallingParticipant" then
				Logger:debug(
					"{} - call.ChildRemoved: userId={}, callId={}",
					"createFriendsCallingStore",
					child2.UserId,
					child.CallId or ""
				)
			end

			local participantConnection = v9.participantConnections[child2]

			if participantConnection then
				participantConnection:Disconnect()
				v9.participantConnections[child2] = nil
			end

			publish()
		end))

		for i, child2 in child:GetChildren() do
			if child2.ClassName ~= "FriendsCallingParticipant" or v9.participantConnections[child2] then
				continue
			end

			v9.participantConnections[child2] = child2.Changed:Connect(function(p2)
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

		for k, v9 in v7 do
			disconnectObservedCall(v9)
		end

		table.clear(v7)
		local v9 = v8
		v8 = false
		v5({})

		if v9 then
			count2 += 1
			v6(count2)
		end
	end

	return {
		getCalls = signal,
		getCall = computed,
		getCallId = computed2,
		getHasCall = computed3,
		getSession = signal2,
		getWindowView = computed4,
		cleanup = cleanup
	}
end
