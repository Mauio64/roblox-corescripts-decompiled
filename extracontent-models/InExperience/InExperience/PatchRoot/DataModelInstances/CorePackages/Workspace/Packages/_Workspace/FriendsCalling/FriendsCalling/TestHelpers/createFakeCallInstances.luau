local function createFakeSignal()
	local v = {}
	local count = 0
	local fakeSignal = {}

	function fakeSignal.Connect(_, p)
		count += 1
		local v2 = count
		v[v2] = p
		return {
			Disconnect = function()
				v[v2] = nil
			end
		}
	end

	function fakeSignal.fire(...)
		for _, v2 in table.clone(v) do
			v2(...)
		end
	end

	return fakeSignal
end

local function createFakeInstance(className: string, p)
	local v = {}
	local fakeSignal = createFakeSignal()
	local fakeSignal2 = createFakeSignal()
	local fakeSignal3 = createFakeSignal()

	local clone = table.clone(p)
	clone.ClassName = className
	clone.Changed = fakeSignal
	clone.ChildAdded = fakeSignal2
	clone.ChildRemoved = fakeSignal3

	function clone.GetChildren(_)
		return table.clone(v)
	end

	function clone.addChild(p2)
		table.insert(v, p2)
		fakeSignal2.fire(p2)
	end

	function clone.removeChild(p2)
		local index = table.find(v, p2)

		if index then
			table.remove(v, index)
			fakeSignal3.fire(p2)
		end
	end

	function clone.setProperty(p2: string, p3)
		clone[p2] = p3
		fakeSignal.fire(p2)
	end

	return clone
end

local FriendsCallingEndReason = Enum.FriendsCallingEndReason
local FriendsCallingParticipantStatus = Enum.FriendsCallingParticipantStatus
local FriendsCallingPhase = Enum.FriendsCallingPhase

local function enumItem(name: string) -- 2 equivalent calls inferred from this helper
	return { Name = name }
end

local CreateFakeCallInstances = {}

function CreateFakeCallInstances.createFakeCall(items)
	local v = {
		CallId = "call-1",
		Phase = FriendsCallingPhase.Active,
		InitiatorUserId = 1,
		EndReason = FriendsCallingEndReason.None,
		Volume = 1,
		IsDeafened = false,
		ConversationId = 0
	}

	if items then
		for k, item in items do
			v[k] = item
		end
	end

	return createFakeInstance("FriendsCallingInstance", v)
end

CreateFakeCallInstances.createFakeInstance = createFakeInstance

function CreateFakeCallInstances.createFakeParticipant(userId: number, items)
	local v = {
		UserId = userId,
		Status = FriendsCallingParticipantStatus.Joined,
		LeaveReason = enumItem("None"), -- inferred equivalent call
		Volume = 1,
		IsLocalMuted = false,
		IsSpeaking = false,
		Error = enumItem("None") -- inferred equivalent call
	}

	if items then
		for k, item in items do
			v[k] = item
		end
	end

	return createFakeInstance("FriendsCallingParticipant", v)
end

CreateFakeCallInstances.enumItem = enumItem
return CreateFakeCallInstances
