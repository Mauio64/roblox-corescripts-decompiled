local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local VideoUtils = script:FindFirstAncestor("VideoUtils")
local parent = VideoUtils.Parent
local AppCommonLib = require(parent.AppCommonLib)
local ArgCheck = require(parent.ArgCheck)
local Signal = AppCommonLib.Signal

require(VideoUtils.Analytics.VideoAnalyticsTypes)
local getIsInstanceVisible = require(VideoUtils.getIsInstanceVisible)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEdpMediaGalleryFullScreen = SharedFlags.FFlagLuaAppEdpMediaGalleryFullScreen
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags2.FFlagLuaAppOneByTwoHoverIdleAutoplay

local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback = SharedFlags3.FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback

local VideoPlaybackCoordinator = {}
VideoPlaybackCoordinator.__index = VideoPlaybackCoordinator

VideoPlaybackCoordinator.preferredFramerateThrottling = false
VideoPlaybackCoordinator.isSettingFramerateThrottleAllowedByPolicy = false

local v = 0

function VideoPlaybackCoordinator.new()
	local v2 = {
		changed = Signal.new(),
		playingVideoKey = nil,
		currentPlaybackSessionId = nil,
		currentplaybackSessionStartTime = nil,
		videoAnalytics = nil,
		playingVideoItemIndex = nil,
		videoDwellTaskHandles = {}
	}

	setmetatable(v2, VideoPlaybackCoordinator)

	return v2
end

function VideoPlaybackCoordinator:__setRunServiceThrottleFramerateEnabled(flag: boolean)
	if not VideoPlaybackCoordinator.isSettingFramerateThrottleAllowedByPolicy then
		return
	end

	RunService:setThrottleFramerateEnabled(flag)
end

function VideoPlaybackCoordinator:isPlaybackAllowed(flag: boolean, flag2: boolean?): boolean
	return not (FFlagLuaAppEdpMediaGalleryFullScreen and flag2 or not flag)
end

function VideoPlaybackCoordinator:isPlaybackCandidate(flag: boolean, flag2: boolean?, p, p2, p3: number)
	if self:isPlaybackAllowed(flag, flag2) then
		return getIsInstanceVisible(p.current, p2, p3)
	end

	return false
end

function VideoPlaybackCoordinator:forcePlayback(p: string, p2: string, p3: number?, p4)
	if self.playingVideoKey == p then
		return
	end

	self:__cancelCurrentPlayback(p2, p3, nil, self.videoAnalytics)
	self:requestPlayback(p, false, 0, p3, p4)
end

function VideoPlaybackCoordinator:requestPlayback(p: string, flag: boolean, duration: number, p2: number?, p3)
	if not (self.playingVideoKey ~= p and self.videoDwellTaskHandles[p] == nil) then
		return
	end

	if not flag then
		self:__startPlayback(p, p2, p3)

		return
	end

	local thread = task.delay(duration, function()
		self.videoDwellTaskHandles[p] = nil
		self:__startPlayback(p, p2, p3)
	end)

	self.videoDwellTaskHandles[p] = thread
end

function VideoPlaybackCoordinator:__startPlayback(playingVideoKey: string, playingVideoItemIndex: number?, videoAnalytics)
	self:__setRunServiceThrottleFramerateEnabled(false)

	if self.playingVideoKey == nil then
		v += 1
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

function VideoPlaybackCoordinator:cancelPlayback(p: string, p2: string, p3: number?, p4)
	if self.playingVideoKey == p then
		self:__cancelCurrentPlayback(p2, p3, nil, p4)
	elseif self.videoDwellTaskHandles[p] ~= nil then
		local videoDwellTaskHandle = self.videoDwellTaskHandles[p]
		task.cancel(videoDwellTaskHandle)
		self.videoDwellTaskHandles[p] = nil
	end

	if v == 0 then
		self:__setRunServiceThrottleFramerateEnabled(VideoPlaybackCoordinator.preferredFramerateThrottling)
	end
end

function VideoPlaybackCoordinator:reset(p: string, _: number?, p2: string?, _)
	if self.playingVideoKey ~= nil then
		self:__cancelCurrentPlayback(p, self.playingVideoItemIndex, p2, self.videoAnalytics)
	end

	for _, videoDwellTaskHandle in self.videoDwellTaskHandles do
		if videoDwellTaskHandle ~= nil then
			task.cancel(videoDwellTaskHandle)
		end
	end

	self.videoDwellTaskHandles = {}

	if v == 0 then
		self:__setRunServiceThrottleFramerateEnabled(VideoPlaybackCoordinator.preferredFramerateThrottling)
	end

	if FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback and self.onPlaybackReset then
		self.onPlaybackReset(p, p2)
	end
end

function VideoPlaybackCoordinator:cancelPendingDwells()
	for _, videoDwellTaskHandle in self.videoDwellTaskHandles do
		if videoDwellTaskHandle ~= nil then
			task.cancel(videoDwellTaskHandle)
		end
	end

	self.videoDwellTaskHandles = {}
end

function VideoPlaybackCoordinator:__cancelCurrentPlayback(p: string, p2: number?, p3: string?, p4)
	local currentPlaybackSessionStartTime = self.currentPlaybackSessionStartTime

	if p4 then
		local now = tick()
		ArgCheck.assert(currentPlaybackSessionStartTime and currentPlaybackSessionStartTime <= now)

		local v2 = not (currentPlaybackSessionStartTime and currentPlaybackSessionStartTime <= now) and -1
			or now - currentPlaybackSessionStartTime

		p4.reportVideoEnd(p2, p, self.currentPlaybackSessionId, v2, p3)
	end

	if self.playingVideoKey ~= nil then
		v -= 1
	end

	self.playingVideoKey = nil
	self.currentPlaybackSessionId = nil
	self.currentPlaybackSessionStartTime = nil
	self.videoAnalytics = nil
	self.playingVideoItemIndex = nil

	if FFlagLuaAppOneByTwoHoverIdleAutoplay then
		self.changed:fire(nil, p)
	else
		self.changed:fire(nil)
	end
end

function VideoPlaybackCoordinator.setIsSettingFramerateThrottleAllowedByPolicy(_, isSettingFramerateThrottleAllowedByPolicy: boolean)
	VideoPlaybackCoordinator.isSettingFramerateThrottleAllowedByPolicy = isSettingFramerateThrottleAllowedByPolicy
end

function VideoPlaybackCoordinator.setPreferredFramerateThrottling(_, preferredFramerateThrottling: boolean)
	VideoPlaybackCoordinator.preferredFramerateThrottling = preferredFramerateThrottling
end
function VideoPlaybackCoordinator.isAnyPlaying(): boolean
	return v > 0
end

VideoPlaybackCoordinator.default = VideoPlaybackCoordinator.new()

return VideoPlaybackCoordinator
