local Parent = script:FindFirstAncestor("MockEngineServices").Parent
local waitForEvents = require(Parent.TestUtils).DeferredLuaHelpers.waitForEvents

local function v3() -- line: 5
end

local BindableEvent = Instance.new("BindableEvent")
local BindableEvent2 = Instance.new("BindableEvent")
local BindableEvent3 = Instance.new("BindableEvent")
local t1 = {
	groupId = 10000,
	publishPaused = false,
	available = true,
	joinCalled = false,
	policyMapper = nil,
	makeMockUser = function(p1, p2) -- line: 16
		return {
			isMuted = false,
			userId = tostring(p1),
			UserId = tostring(p1),
			isMutedLocally = not not p2
		}
	end,
	ParticipantsStateChanged = BindableEvent.Event,
	StateChanged = BindableEvent3.Event,
	LocalPlayerModerated = BindableEvent2.Event
}
local n1 = 0

function t1.GetVoiceChatApiVersionCB() -- line: 7
	-- upvalues: n1 (copy)
	return n1
end

t1.GetVoiceChatAvailableCB = v3
t1.IsSubscribePausedCB = v3
t1.SubscribePauseCB = v3
t1.SubscribeBlockCB = v3
t1.SubscribeUnblockCB = v3
t1.SubscribePauseAllCB = v3

function t1.Disconnect(_) -- line: 44
end
function t1.Leave(_) -- line: 49
end
function t1.GetGroupId(p5) -- line: 53
	return p5.groupId
end
function t1.IsPublishPaused(p6) -- line: 56
	return p6.publishPaused
end
function t1.JoinByGroupIdToken(p7) -- line: 59
	p7.joinCalled = true

	return true
end
function t1.IsSubscribePaused(p8) -- line: 64
	return p8.IsSubscribePausedCB()
end
function t1.SubscribePause(p9, p10) -- line: 67
	return p9.SubscribePauseCB(p10)
end
function t1.GetVoiceChatApiVersion(p11) -- line: 71
	return p11.GetVoiceChatApiVersionCB()
end
function t1.GetVoiceChatAvailable(p12) -- line: 74
	return p12.GetVoiceChatAvailableCB()
end
function t1.SubscribeBlock(p13) -- line: 77
	return p13.SubscribeBlockCB()
end
function t1.SubscribePauseAll(p14) -- line: 81
	return p14.SubscribePauseAllCB()
end
function t1.SubscribeUnblock(p15) -- line: 84
	return p15.SubscribeUnblockCB()
end
function t1.kickUsers(_, p17) -- line: 88
	-- upvalues: BindableEvent (ref), waitForEvents (copy)
	BindableEvent:Fire(p17, {}, {})
	waitForEvents()
end
function t1.ModerateLocalPlayer(_) -- line: 93
	-- upvalues: BindableEvent2 (ref), waitForEvents (copy)
	BindableEvent2:Fire()
	waitForEvents()
end
function t1.addUsers(_, p20) -- line: 98
	-- upvalues: BindableEvent (ref), waitForEvents (copy)
	BindableEvent:Fire({}, {}, p20)
	waitForEvents()
end
function t1.setUserStates(_, p22) -- line: 103
	-- upvalues: BindableEvent (ref), waitForEvents (copy)
	BindableEvent:Fire({}, {}, p22)
	waitForEvents()
end
function t1.GetSessionId(_) -- line: 108
	return 1
end
function t1.GetChannelId(_) -- line: 112
	return 1
end
function t1.resetMocks(p25) -- line: 116
	-- upvalues: BindableEvent (ref), BindableEvent3 (ref), BindableEvent2 (ref)
	BindableEvent = Instance.new("BindableEvent")
	BindableEvent3 = Instance.new("BindableEvent")
	BindableEvent2 = Instance.new("BindableEvent")
	p25.LocalPlayerModerated = BindableEvent2.Event
	p25.ParticipantsStateChanged = BindableEvent.Event
	p25.StateChanged = BindableEvent3.Event
	p25.joinCalled = false
end

return t1
