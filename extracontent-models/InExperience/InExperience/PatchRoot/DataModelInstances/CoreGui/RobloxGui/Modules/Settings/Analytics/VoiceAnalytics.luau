local Constants = require(script.Parent.Parent.Resources.Constants)

local VoiceAnalytics = {}
VoiceAnalytics.__index = VoiceAnalytics

function VoiceAnalytics.new(eventStreamImpl, value)
	local v = {
		_eventStreamImpl = eventStreamImpl,
		_target = "EventIngest",
		_context = value or "SettingsHub"
	}

	setmetatable(v, VoiceAnalytics)
	return v
end

function VoiceAnalytics:onToggleMuteAll(p)
	if p then
		self:onMuteAll()
	else
		self:onUnmuteAll()
	end
end

function VoiceAnalytics:onToggleMuteSelf(p)
	if p then
		self:onMuteSelf()
	else
		self:onUnmuteSelf()
	end
end

function VoiceAnalytics:onToggleMutePlayer(p, p2)
	if p2 then
		self:onMutePlayer(p)
	else
		self:onUnmutePlayer(p)
	end
end

function VoiceAnalytics:onMuteSelf()
	local muteSelf = Constants.VoiceAnalytics.MuteSelf
	self._eventStreamImpl:setRBXEventStream(self._target, self._context, muteSelf, {})
end

function VoiceAnalytics:onUnmuteSelf()
	local unmuteSelf = Constants.VoiceAnalytics.UnmuteSelf
	self._eventStreamImpl:setRBXEventStream(self._target, self._context, unmuteSelf, {})
end

function VoiceAnalytics:onMuteAll()
	local muteAll = Constants.VoiceAnalytics.MuteAll
	self._eventStreamImpl:setRBXEventStream(self._target, self._context, muteAll, {})
end

function VoiceAnalytics:onUnmuteAll()
	local unmuteAll = Constants.VoiceAnalytics.UnmuteAll
	self._eventStreamImpl:setRBXEventStream(self._target, self._context, unmuteAll, {})
end

function VoiceAnalytics:onMutePlayer(mutedUserId)
	local mutePlayer = Constants.VoiceAnalytics.MutePlayer
	self._eventStreamImpl:setRBXEventStream(self._target, self._context, mutePlayer, {
		mutedUserId = mutedUserId
	})
end

function VoiceAnalytics:onUnmutePlayer(mutedUserId)
	local unmutePlayer = Constants.VoiceAnalytics.UnmutePlayer
	self._eventStreamImpl:setRBXEventStream(self._target, self._context, unmutePlayer, {
		mutedUserId = mutedUserId
	})
end

return VoiceAnalytics
