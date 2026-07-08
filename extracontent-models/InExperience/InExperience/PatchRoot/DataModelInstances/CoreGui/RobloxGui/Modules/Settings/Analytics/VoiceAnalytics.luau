local Constants = require(script.Parent.Parent.Resources.Constants)
local t1 = {}

t1.__index = t1

function t1.new(p1, p2) -- line: 6
	-- upvalues: t1 (copy)
	local t2 = {
		_target = "EventIngest",
		_eventStreamImpl = p1,
		_context = p2 or "SettingsHub"
	}

	setmetatable(t2, t1)

	return t2
end
function t1.onToggleMuteAll(p3, p4) -- line: 17
	if p4 then
		p3:onMuteAll()

		return
	end

	p3:onUnmuteAll()
end
function t1.onToggleMuteSelf(p5, p6) -- line: 25
	if p6 then
		p5:onMuteSelf()

		return
	end

	p5:onUnmuteSelf()
end
function t1.onToggleMutePlayer(p7, p8, p9) -- line: 33
	if p9 then
		p7:onMutePlayer(p8)

		return
	end

	p7:onUnmutePlayer(p8)
end
function t1.onMuteSelf(p10) -- line: 41
	-- upvalues: Constants (copy)
	local MuteSelf = Constants.VoiceAnalytics.MuteSelf

	p10._eventStreamImpl:setRBXEventStream(p10._target, p10._context, MuteSelf, {})
end
function t1.onUnmuteSelf(p11) -- line: 46
	-- upvalues: Constants (copy)
	local UnmuteSelf = Constants.VoiceAnalytics.UnmuteSelf

	p11._eventStreamImpl:setRBXEventStream(p11._target, p11._context, UnmuteSelf, {})
end
function t1.onMuteAll(p12) -- line: 51
	-- upvalues: Constants (copy)
	local MuteAll = Constants.VoiceAnalytics.MuteAll

	p12._eventStreamImpl:setRBXEventStream(p12._target, p12._context, MuteAll, {})
end
function t1.onUnmuteAll(p13) -- line: 56
	-- upvalues: Constants (copy)
	local UnmuteAll = Constants.VoiceAnalytics.UnmuteAll

	p13._eventStreamImpl:setRBXEventStream(p13._target, p13._context, UnmuteAll, {})
end
function t1.onMutePlayer(p14, p15) -- line: 61
	-- upvalues: Constants (copy)
	local MutePlayer = Constants.VoiceAnalytics.MutePlayer

	p14._eventStreamImpl:setRBXEventStream(p14._target, p14._context, MutePlayer, {
		mutedUserId = p15
	})
end
function t1.onUnmutePlayer(p16, p17) -- line: 68
	-- upvalues: Constants (copy)
	local UnmutePlayer = Constants.VoiceAnalytics.UnmutePlayer

	p16._eventStreamImpl:setRBXEventStream(p16._target, p16._context, UnmutePlayer, {
		mutedUserId = p17
	})
end

return t1
