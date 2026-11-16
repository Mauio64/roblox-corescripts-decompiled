local CollectionService = game:GetService("CollectionService")

local Constants = require(script.Parent.Constants)
local calculateIntersectionRatio = require(script.Parent.calculateIntersectionRatio)
local sponsoredAdViewabilityRegistry = require(script.Parent.sponsoredAdViewabilityRegistry)
local sponsoredAdViewabilityState = require(script.Parent.sponsoredAdViewabilityState)
require(script.Parent.sponsoredAdViewabilityTypes)

local terminalReason = { SurfaceTeardown = "SurfaceTeardown", FeedRefresh = "FeedRefresh" }

local function invokeCallback(p: string, callback, ...)
	local v = nil

	if not xpcall(callback, function(p2)
		v = p2
	end, ...) then
		warn(`SponsoredAdViewability {p} failed`, v)
	end
end

local frozen = table.freeze({})

local SponsoredAdViewabilityDetector = {}
SponsoredAdViewabilityDetector.__index = SponsoredAdViewabilityDetector

function SponsoredAdViewabilityDetector.new(callbacks)
	return (setmetatable({
		_callbacks = callbacks,
		_surfaceScope = nil,
		_viewportBounds = nil,
		_sessions = {},
		_running = false,
		_paused = false,
		_scanThread = nil
	}, SponsoredAdViewabilityDetector))
end

local function isVideoMetadata(p): boolean -- 5 equivalent calls inferred from this helper
	return p.mediaType == "video"
end

local function readVideoPlaybackState(p)
	if not isVideoMetadata(p) then -- inferred equivalent call
		return nil
	end

	local videoPlaybackStateRef = p.videoPlaybackStateRef
	local current

	if videoPlaybackStateRef then
		current = videoPlaybackStateRef.current
	end

	if current == nil then
		return nil
	end

	local success, result = pcall(current)
	return if success then result else nil
end

local function getLayerCollectorAndVisibility(instance)
	local v = true

	while instance do
		if instance:IsA("GuiObject") and not instance.Visible then
			v = false
		end

		if instance:IsA("LayerCollector") then
			return instance, v and instance.Enabled
		end

		instance = instance.Parent
	end

	return nil, false
end

local function getRegisteredTile(guiObject, surfaceScope)
	if not guiObject:IsA("GuiObject") then
		return nil, nil, nil
	end

	local attribute = guiObject:GetAttribute(Constants.ViewabilityTargetIdAttribute)

	if typeof(attribute) ~= "string" then
		return nil, nil, nil
	end

	local v = sponsoredAdViewabilityRegistry.get(attribute)

	if v == nil then
		return nil, nil, nil
	end

	if v.isFullscreen == true or guiObject:IsDescendantOf(surfaceScope) then
		return guiObject, attribute, v
	end

	return nil, nil, nil
end

local function measureRegisteredTile(registeredTile, viewabilityTargetId: string, metadata, viewportBounds)
	local isFullscreen = metadata.isFullscreen == true
	local absolutePosition = nil
	local absoluteSize = nil
	local viewportBounds2 = viewportBounds

	if not pcall(function()
		if isFullscreen then
			local layerCollectorAndVisibility, v = getLayerCollectorAndVisibility(registeredTile)

			if layerCollectorAndVisibility == nil or not v then
				return
			end

			viewportBounds2 = {
				min = layerCollectorAndVisibility.AbsolutePosition,
				max = layerCollectorAndVisibility.AbsolutePosition + layerCollectorAndVisibility.AbsoluteSize
			}
		end

		absolutePosition = registeredTile.AbsolutePosition
		absoluteSize = registeredTile.AbsoluteSize
	end) or absolutePosition == nil or absoluteSize == nil then
		return nil
	end

	local v = {
		metadata = metadata,
		geometry = { adSize = absoluteSize, viewportBounds = viewportBounds2 },
		ratio = calculateIntersectionRatio(absolutePosition, absoluteSize, viewportBounds2),
		viewabilityTargetId = viewabilityTargetId,
		videoStateSnapshot = 0,
		isFullscreen = 0
	}
	local result

	if metadata.mediaType == "video" then
		local videoPlaybackStateRef = metadata.videoPlaybackStateRef
		local current

		if videoPlaybackStateRef then
			current = videoPlaybackStateRef.current
		end

		if current ~= nil then
			local success
			success, result = pcall(current)

			if not success then
				result = nil
			end
		end
	end

	v.videoStateSnapshot = result
	v.isFullscreen = isFullscreen

	return v
end

local function shouldReplaceCandidate(data, data2)
	if data.isFullscreen == data2.isFullscreen then
		if data.ratio ~= data2.ratio then
			return data2.ratio > data.ratio
		end

		if (data.videoStateSnapshot ~= nil) ~= (data2.videoStateSnapshot ~= nil) then
			return data2.videoStateSnapshot ~= nil
		end

		local viewabilityTargetId = tonumber(data2.viewabilityTargetId)
		local viewabilityTargetId2 = tonumber(data.viewabilityTargetId)

		if viewabilityTargetId == nil or viewabilityTargetId2 == nil then
			return viewabilityTargetId ~= nil
		end

		return viewabilityTargetId2 < viewabilityTargetId
	elseif (data.videoStateSnapshot ~= nil) == (data2.videoStateSnapshot ~= nil) then
		return data2.isFullscreen
	else
		return data2.videoStateSnapshot ~= nil
	end
end

local function selectBetterMeasurement(p, p2) -- 2 equivalent calls inferred from this helper
	local encryptedAdTrackingData = p2.metadata.encryptedAdTrackingData
	local v = p[encryptedAdTrackingData]

	if v ~= nil and v.metadata.mediaType ~= p2.metadata.mediaType then
		return
	end

	if v == nil or shouldReplaceCandidate(v, p2) then
		p[encryptedAdTrackingData] = p2
	end
end

local function canStartOrContinueSession(p, p2) -- 2 equivalent calls inferred from this helper
	local v = not p.isFullscreen

	if not v then
		if p2 == nil then
			return false
		end

		return p2.video ~= nil
	end

	return v
end

local function canMeasureViewport(viewportBounds): boolean -- 2 equivalent calls inferred from this helper
	return viewportBounds.max.X > viewportBounds.min.X and viewportBounds.max.Y > viewportBounds.min.Y
end

local function hasVideoSession(sessions): boolean -- 1 equivalent call inferred from this helper
	for _, item in sessions do
		if item.video ~= nil then
			return true
		end
	end

	return false
end

function SponsoredAdViewabilityDetector:_advanceSession(p, p2: number, p3: number, p4, p5, flag: boolean, p6)
	local v, v2 = p.state:advance(p2, p3, p4, p5, flag)
	local v3 = p6 or p.metadata

	for _, v4 in v do
		invokeCallback("onMilestone", self._callbacks.onMilestone, v3, v4)
	end

	local onVideoProgress = self._callbacks.onVideoProgress

	if onVideoProgress ~= nil and v2 ~= nil then
		for _, v4 in v2 do
			invokeCallback("onVideoProgress", onVideoProgress, v3, v4)
		end
	end
end

function SponsoredAdViewabilityDetector:_processMeasurement(p: string, data, p2: number)
	local metadata = data.metadata
	local videoMetadata = isVideoMetadata(metadata) -- inferred equivalent call
	local v = self._sessions[p]

	if not v then
		v = {
			state = sponsoredAdViewabilityState.new(p2, videoMetadata),
			metadata = metadata,
			video = videoMetadata and {
				viewabilityTargetId = data.viewabilityTargetId,
				isFullscreen = data.isFullscreen
			} or nil
		}

		self._sessions[p] = v
		invokeCallback(
			"onSessionStart",
			self._callbacks.onSessionStart,
			metadata,
			data.geometry,
			p2,
			data.videoStateSnapshot
		)
	end

	if videoMetadata then
		self:_applySelectedVideoMeasurement(v, data, p2)
		return
	end

	if v.video ~= nil then
		return
	end

	self:_advanceSession(v, p2, data.ratio, data.geometry, nil, false, metadata)
end

function SponsoredAdViewabilityDetector:_applySelectedVideoMeasurement(state, data, p: number)
	local video = state.video

	if video == nil then
		return
	end

	if data == nil then
		self:_advanceSession(state, p, 0, nil, nil, video.isFullscreen)
		return
	end

	local metadata = data.metadata

	if not isVideoMetadata(metadata) then -- inferred equivalent call
		return
	end

	if video.viewabilityTargetId ~= data.viewabilityTargetId then
		local v = video.isFullscreen ~= data.isFullscreen
		state.state:transitionVideoSource(p, v)
	end

	state.metadata = metadata
	video.viewabilityTargetId = data.viewabilityTargetId
	video.isFullscreen = data.isFullscreen
	self:_advanceSession(state, p, data.ratio, data.geometry, data.videoStateSnapshot, data.isFullscreen)
end

function SponsoredAdViewabilityDetector:_collectCurrentVideoMeasurements()
	if not hasVideoSession(self._sessions) then -- inferred equivalent call
		return frozen
	end

	local v = {}
	local surfaceScope = self._surfaceScope
	local viewportBounds = self._viewportBounds

	if surfaceScope == nil or viewportBounds == nil or not canMeasureViewport(viewportBounds) then -- inferred equivalent call
		return v
	end

	for _, v2 in CollectionService:GetTagged(Constants.CandidateTag) do
		local registeredTile, viewabilityTargetId, metadata = getRegisteredTile(v2, surfaceScope)

		if not (registeredTile ~= nil and viewabilityTargetId ~= nil and metadata ~= nil and isVideoMetadata(metadata)) then -- inferred equivalent call
			continue
		end

		local v3 = measureRegisteredTile(registeredTile, viewabilityTargetId, metadata, viewportBounds)

		if v3 ~= nil and canStartOrContinueSession(v3, self._sessions[metadata.encryptedAdTrackingData]) then -- inferred equivalent call
			selectBetterMeasurement(v, v3) -- inferred equivalent call
		end
	end

	return v
end

function SponsoredAdViewabilityDetector:setSurfaceScope(surfaceScope)
	self._surfaceScope = surfaceScope
end

function SponsoredAdViewabilityDetector:setViewportBounds(viewportBounds)
	self._viewportBounds = viewportBounds
end

function SponsoredAdViewabilityDetector:start()
	if self._running then
		return
	end

	self._running = true

	if not self._paused then
		self:_scheduleNextScan()
	end
end

function SponsoredAdViewabilityDetector:_cancelScheduledScan()
	local scanThread = self._scanThread

	if scanThread ~= nil and coroutine.status(scanThread) == "suspended" then
		task.cancel(scanThread)
	end

	self._scanThread = nil
end

function SponsoredAdViewabilityDetector:_scheduleNextScan()
	if self._scanThread ~= nil then
		return
	end

	self._scanThread = task.delay(0.2, function()
		self._scanThread = nil

		if not self._running or self._paused then
			return
		end

		local success, result = pcall(self._scanTick, self, DateTime.now().UnixTimestampMillis)

		if success then
			if self._running and not self._paused then
				self:_scheduleNextScan()
			end
		else
			warn("SponsoredAdViewability scan failed; disabling detector", result)

			self._running = false
			self._sessions = {}
		end
	end)
end

function SponsoredAdViewabilityDetector:_scanTick(p: number)
	local surfaceScope = self._surfaceScope
	local viewportBounds = self._viewportBounds

	if surfaceScope == nil or viewportBounds == nil or not canMeasureViewport(viewportBounds) then -- inferred equivalent call
		return
	end

	local encryptedAdTrackingDataSet = {}

	local v = {}
	local encryptedAdTrackingDataSet2 = {}

	for _, v2 in CollectionService:GetTagged(Constants.CandidateTag) do
		local registeredTile, viewabilityTargetId, metadata = getRegisteredTile(v2, surfaceScope)

		if not (registeredTile ~= nil and viewabilityTargetId ~= nil and metadata ~= nil) then
			continue
		end

		local encryptedAdTrackingData = metadata.encryptedAdTrackingData
		local v3 = measureRegisteredTile(registeredTile, viewabilityTargetId, metadata, viewportBounds)

		if v3 == nil then
			local session = self._sessions[encryptedAdTrackingData]

			if
				metadata.isFullscreen == true
				and isVideoMetadata(metadata) -- inferred equivalent call
				and session ~= nil
				and session.video ~= nil
			then
				encryptedAdTrackingDataSet2[encryptedAdTrackingData] = true
			end
		elseif canStartOrContinueSession(v3, self._sessions[encryptedAdTrackingData]) then -- inferred equivalent call
			encryptedAdTrackingDataSet[encryptedAdTrackingData] = true
			selectBetterMeasurement(v, v3) -- inferred equivalent call
		end
	end

	for k, v2 in v do
		if not encryptedAdTrackingDataSet2[k] or v2.isFullscreen then
			self:_processMeasurement(k, v2, p)
		end
	end

	for k, session in self._sessions do
		if encryptedAdTrackingDataSet[k] or encryptedAdTrackingDataSet2[k] then
			continue
		end

		local video = session.video
		self:_advanceSession(session, p, 0, nil, nil, video ~= nil and video.isFullscreen)
	end
end

function SponsoredAdViewabilityDetector:pause(p: number?)
	if self._paused then
		return
	end

	local v = p or DateTime.now().UnixTimestampMillis
	local currentVideoMeasurements = self:_collectCurrentVideoMeasurements()

	for k, session in self._sessions do
		if session.video ~= nil then
			self:_applySelectedVideoMeasurement(session, currentVideoMeasurements[k], v)
		end

		session.state:pause(v)
	end

	self._paused = true
	self:_cancelScheduledScan()
end

function SponsoredAdViewabilityDetector:resume(p: number?)
	if not self._paused then
		return
	end

	local v = p or DateTime.now().UnixTimestampMillis

	for _, session in self._sessions do
		session.state:resume(v)
	end

	self._paused = false

	if self._running then
		self:_scheduleNextScan()
	end
end

function SponsoredAdViewabilityDetector:_terminateAllSessions(p: number, p2: string)
	local sessions = self._sessions
	local v = self._paused and {} or self:_collectCurrentVideoMeasurements()
	self._sessions = {}

	for k, session in sessions do
		if not self._paused and session.video ~= nil then
			self:_applySelectedVideoMeasurement(session, v[k], p)
		end

		local finalize = session.state:finalize(p)
		invokeCallback("onUnload", self._callbacks.onUnload, session.metadata, finalize, p2)
	end
end

function SponsoredAdViewabilityDetector:onFeedRefresh(p: number?)
	self:_terminateAllSessions(p or DateTime.now().UnixTimestampMillis, terminalReason.FeedRefresh)
end

function SponsoredAdViewabilityDetector:reset(p: number?)
	self._running = false
	self:_cancelScheduledScan()

	self:_terminateAllSessions(p or DateTime.now().UnixTimestampMillis, terminalReason.SurfaceTeardown)
end

SponsoredAdViewabilityDetector.TerminalReason = terminalReason

return SponsoredAdViewabilityDetector
