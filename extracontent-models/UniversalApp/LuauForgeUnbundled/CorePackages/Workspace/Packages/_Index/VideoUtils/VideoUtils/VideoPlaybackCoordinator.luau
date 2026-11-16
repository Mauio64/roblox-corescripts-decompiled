local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/AppCommonLib")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/ArgCheck")
local signal = AppCommonLib.Signal

require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/Analytics/VideoAnalyticsTypes")
local getIsInstanceVisible = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/getIsInstanceVisible")

local fFlagLuaAppEdpMediaGalleryFullScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppEdpMediaGalleryFullScreen
local fFlagLuaAppOneByTwoHoverIdleAutoplay = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppOneByTwoHoverIdleAutoplay

local fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback

local class = {}
class.__index = class

class.preferredFramerateThrottling = false
class.isSettingFramerateThrottleAllowedByPolicy = false

local v5 = 0

function class.new()
	local v6 = {
		changed = signal.new(),
		playingVideoKey = nil,
		currentPlaybackSessionId = nil,
		currentplaybackSessionStartTime = nil,
		videoAnalytics = nil,
		playingVideoItemIndex = nil,
		videoDwellTaskHandles = {}
	}

	setmetatable(v6, class)

	return v6
end

function class:__setRunServiceThrottleFramerateEnabled(p3)
	if not class.isSettingFramerateThrottleAllowedByPolicy then
		return
	end

	RunService:setThrottleFramerateEnabled(p3)
end

function class:isPlaybackAllowed(p3, p4): boolean
	if fFlagLuaAppEdpMediaGalleryFullScreen and p4 or not p3 then
		return false
	end

	return true
end

function class:isPlaybackCandidate(p2, p3, p4, p5, p6)
	if self:isPlaybackAllowed(p2, p3) then
		return getIsInstanceVisible(p4.current, p5, p6)
	end

	return false
end

function class:forcePlayback(p2, p3, p4, p5)
	if self.playingVideoKey == p2 then
		return
	end

	self:__cancelCurrentPlayback(p3, p4, nil, self.videoAnalytics)
	self:requestPlayback(p2, false, 0, p4, p5)
end

function class:requestPlayback(p2, p3, duration, p4, p5)
	if not (self.playingVideoKey ~= p2 and self.videoDwellTaskHandles[p2] == nil) then
		return
	end

	if not p3 then
		self:__startPlayback(p2, p4, p5)

		return
	end

	local thread = task.delay(duration, function()
		self.videoDwellTaskHandles[p2] = nil
		self:__startPlayback(p2, p4, p5)
	end)

	self.videoDwellTaskHandles[p2] = thread
end

function class:__startPlayback(playingVideoKey, playingVideoItemIndex, videoAnalytics)
	self:__setRunServiceThrottleFramerateEnabled(false)

	if self.playingVideoKey == nil then
		v5 += 1
	end

	self.playingVideoKey = playingVideoKey
	self.currentPlaybackSessionId = HttpService:GenerateGUID(false)
	self.currentPlaybackSessionStartTime = tick()
	self.videoAnalytics = videoAnalytics
	self.playingVideoItemIndex = playingVideoItemIndex

	if videoAnalytics then
		videoAnalytics.reportVideoPlay(playingVideoItemIndex, self.currentPlaybackSessionId)
	end

	self.changed:fire(playingVideoKey)
end

function class:cancelPlayback(p2, p3, p4, p5)
	if self.playingVideoKey == p2 then
		self:__cancelCurrentPlayback(p3, p4, nil, p5)
	elseif self.videoDwellTaskHandles[p2] ~= nil then
		local videoDwellTaskHandle = self.videoDwellTaskHandles[p2]
		task.cancel(videoDwellTaskHandle)
		self.videoDwellTaskHandles[p2] = nil
	end

	if v5 == 0 then
		self:__setRunServiceThrottleFramerateEnabled(class.preferredFramerateThrottling)
	end
end

function class:reset(p2, p3, p4, p5)
	if self.playingVideoKey ~= nil then
		self:__cancelCurrentPlayback(p2, self.playingVideoItemIndex, p4, self.videoAnalytics)
	end

	for k, videoDwellTaskHandle in self.videoDwellTaskHandles do
		if videoDwellTaskHandle ~= nil then
			task.cancel(videoDwellTaskHandle)
		end
	end

	self.videoDwellTaskHandles = {}

	if v5 == 0 then
		self:__setRunServiceThrottleFramerateEnabled(class.preferredFramerateThrottling)
	end

	if fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback and self.onPlaybackReset then
		self.onPlaybackReset(p2, p4)
	end
end

function class:cancelPendingDwells()
	for k, videoDwellTaskHandle in self.videoDwellTaskHandles do
		if videoDwellTaskHandle ~= nil then
			task.cancel(videoDwellTaskHandle)
		end
	end

	self.videoDwellTaskHandles = {}
end

function class:__cancelCurrentPlayback(p2, p3, p4, p5)
	local currentPlaybackSessionStartTime = self.currentPlaybackSessionStartTime

	if p5 then
		local now = tick()
		ArgCheck.assert(currentPlaybackSessionStartTime and currentPlaybackSessionStartTime <= now)

		local v6 = not (currentPlaybackSessionStartTime and currentPlaybackSessionStartTime <= now)
			and -1
			or now - currentPlaybackSessionStartTime

		p5.reportVideoEnd(p3, p2, self.currentPlaybackSessionId, v6, p4)
	end

	if self.playingVideoKey ~= nil then
		v5 -= 1
	end

	self.playingVideoKey = nil
	self.currentPlaybackSessionId = nil
	self.currentPlaybackSessionStartTime = nil
	self.videoAnalytics = nil
	self.playingVideoItemIndex = nil

	if fFlagLuaAppOneByTwoHoverIdleAutoplay then
		self.changed:fire(nil, p2)
	else
		self.changed:fire(nil)
	end
end

function class:setIsSettingFramerateThrottleAllowedByPolicy(isSettingFramerateThrottleAllowedByPolicy)
	class.isSettingFramerateThrottleAllowedByPolicy = isSettingFramerateThrottleAllowedByPolicy
end

function class:setPreferredFramerateThrottling(preferredFramerateThrottling)
	class.preferredFramerateThrottling = preferredFramerateThrottling
end
function class.isAnyPlaying(): boolean
	return v5 > 0
end

class.default = class.new()

return class
