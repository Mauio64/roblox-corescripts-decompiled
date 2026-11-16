local CollectionService = game:GetService("CollectionService")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredAdViewability/SponsoredAdViewability/Constants")
local calculateIntersectionRatio = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredAdViewability/SponsoredAdViewability/calculateIntersectionRatio")
local sponsoredAdViewabilityRegistry = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredAdViewability/SponsoredAdViewability/sponsoredAdViewabilityRegistry")
local sponsoredAdViewabilityState = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredAdViewability/SponsoredAdViewability/sponsoredAdViewabilityState")
require("@game/CorePackages/Workspace/Packages/_Index/SponsoredAdViewability/SponsoredAdViewability/sponsoredAdViewabilityTypes")

local v5 = { SurfaceTeardown = "SurfaceTeardown", FeedRefresh = "FeedRefresh" }

local function invokeCallback(p2, callback, ...)
	local v6 = nil

	if not xpcall(callback, function(p3)
		v6 = p3
	end, ...) then
		warn(`SponsoredAdViewability {p2} failed`, v6)
	end
end

local frozen = table.freeze({})

local class = {}
class.__index = class

function class.new(p2)
	return (setmetatable({
		_callbacks = p2,
		_surfaceScope = nil,
		_viewportBounds = nil,
		_sessions = {},
		_running = false,
		_paused = false,
		_scanThread = nil
	}, class))
end

local function isVideoMetadata(p2): boolean
	return p2.mediaType == "video"
end

local function readVideoPlaybackState(p2)
	if p2.mediaType ~= "video" then
		return nil
	end

	local videoPlaybackStateRef = p2.videoPlaybackStateRef
	local current = if videoPlaybackStateRef then videoPlaybackStateRef.current else nil

	if current == nil then
		return nil
	end

	local success, result = pcall(current)

	if success then
		return result
	end

	return nil
end

local function getLayerCollectorAndVisibility(instance)
	local v6 = true

	while instance do
		if instance:IsA("GuiObject") and not instance.Visible then
			v6 = false
		end

		if instance:IsA("LayerCollector") then
			return instance, v6 and instance.Enabled
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

	local v6 = sponsoredAdViewabilityRegistry.get(attribute)

	if v6 == nil then
		return nil, nil, nil
	end

	if v6.isFullscreen == true or guiObject:IsDescendantOf(surfaceScope) then
		return guiObject, attribute, v6
	end

	return nil, nil, nil
end

local function measureRegisteredTile(registeredTile, p2, data, viewportBounds)
	local isFullscreen = data.isFullscreen == true
	local absolutePosition = nil
	local absoluteSize = nil
	local v6 = viewportBounds

	if not pcall(function()
		if isFullscreen then
			local layerCollectorAndVisibility, v7 = getLayerCollectorAndVisibility(registeredTile)

			if layerCollectorAndVisibility == nil or not v7 then
				return
			end

			v6 = {
				min = layerCollectorAndVisibility.AbsolutePosition,
				max = layerCollectorAndVisibility.AbsolutePosition + layerCollectorAndVisibility.AbsoluteSize
			}
		end

		absolutePosition = registeredTile.AbsolutePosition
		absoluteSize = registeredTile.AbsoluteSize
	end) or absolutePosition == nil or absoluteSize == nil then
		return nil
	end

	local v7 = {
		metadata = data,
		geometry = { adSize = absoluteSize, viewportBounds = v6 },
		ratio = calculateIntersectionRatio(absolutePosition, absoluteSize, v6),
		viewabilityTargetId = p2,
		videoStateSnapshot = 0,
		isFullscreen = 0
	}
	local result

	if data.mediaType == "video" then
		local videoPlaybackStateRef = data.videoPlaybackStateRef
		local current = if videoPlaybackStateRef then videoPlaybackStateRef.current else nil

		if current ~= nil then
			local success
			success, result = pcall(current)

			if not success then
				result = nil
			end
		end
	end

	v7.videoStateSnapshot = result
	v7.isFullscreen = isFullscreen

	return v7
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

local function selectBetterMeasurement(p2, p3)
	local encryptedAdTrackingData = p3.metadata.encryptedAdTrackingData
	local v6 = p2[encryptedAdTrackingData]

	if v6 ~= nil and v6.metadata.mediaType ~= p3.metadata.mediaType then
		return
	end

	if v6 == nil or shouldReplaceCandidate(v6, p3) then
		p2[encryptedAdTrackingData] = p3
	end
end

local function canStartOrContinueSession(p2, p3)
	local v6 = not p2.isFullscreen

	if not v6 then
		v6 = not (p3 == nil) and p3.video ~= nil
	end

	return v6
end

local function canMeasureViewport(p2): boolean
	return p2.max.X > p2.min.X and p2.max.Y > p2.min.Y
end

local function hasVideoSession(items): boolean
	for k, item in items do
		if item.video ~= nil then
			return true
		end
	end

	return false
end

function class:_advanceSession(p3, p4, p5, p6, p7, p8, p9)
	local v6, v7 = p3.state:advance(p4, p5, p6, p7, p8)
	local v8 = p9 or p3.metadata

	for k, v9 in v6 do
		invokeCallback("onMilestone", self._callbacks.onMilestone, v8, v9)
	end

	local onVideoProgress = self._callbacks.onVideoProgress

	if onVideoProgress ~= nil and v7 ~= nil then
		for k, v9 in v7 do
			invokeCallback("onVideoProgress", onVideoProgress, v8, v9)
		end
	end
end

function class:_processMeasurement(p2, data, p3)
	local metadata = data.metadata
	local v6 = metadata.mediaType == "video"

	local v7 = self._sessions[p2]

	if not v7 then
		v7 = {
			state = sponsoredAdViewabilityState.new(p3, v6),
			metadata = metadata,
			video = v6 and {
				viewabilityTargetId = data.viewabilityTargetId,
				isFullscreen = data.isFullscreen
			} or nil
		}

		self._sessions[p2] = v7
		invokeCallback(
			"onSessionStart",
			self._callbacks.onSessionStart,
			metadata,
			data.geometry,
			p3,
			data.videoStateSnapshot
		)
	end

	if v6 then
		self:_applySelectedVideoMeasurement(v7, data, p3)
		return
	end

	if v7.video ~= nil then
		return
	end

	self:_advanceSession(v7, p3, data.ratio, data.geometry, nil, false, metadata)
end

function class:_applySelectedVideoMeasurement(state, data, p2)
	local video = state.video

	if video == nil then
		return
	end

	if data == nil then
		self:_advanceSession(state, p2, 0, nil, nil, video.isFullscreen)
		return
	end

	local metadata = data.metadata

	if metadata.mediaType ~= "video" then
		return
	end

	if video.viewabilityTargetId ~= data.viewabilityTargetId then
		local v6 = video.isFullscreen ~= data.isFullscreen
		state.state:transitionVideoSource(p2, v6)
	end

	state.metadata = metadata
	video.viewabilityTargetId = data.viewabilityTargetId
	video.isFullscreen = data.isFullscreen
	self:_advanceSession(state, p2, data.ratio, data.geometry, data.videoStateSnapshot, data.isFullscreen)
end

function class:_collectCurrentVideoMeasurements()
	local flag = true
	local v6

	for k, session in self._sessions do
		if session.video ~= nil then
			v6 = true
			flag = false
			break
		end
	end

	if flag then
		v6 = false
	end

	if not v6 then
		return frozen
	end

	local result = {}
	local surfaceScope = self._surfaceScope
	local viewportBounds = self._viewportBounds

	if surfaceScope == nil or viewportBounds == nil then
		return result
	end

	local v7

	if viewportBounds.max.X > viewportBounds.min.X then
		v7 = viewportBounds.max.Y > viewportBounds.min.Y
	else
		v7 = false
	end

	if not v7 then
		return result
	end

	for k, v8 in CollectionService:GetTagged(Constants.CandidateTag) do
		local registeredTile, v9, v10 = getRegisteredTile(v8, surfaceScope)

		if not (registeredTile ~= nil and v9 ~= nil and v10 ~= nil and v10.mediaType == "video") then
			continue
		end

		local v11 = measureRegisteredTile(registeredTile, v9, v10, viewportBounds)

		if v11 == nil then
			continue
		end

		local session = self._sessions[v10.encryptedAdTrackingData]
		local v12 = not v11.isFullscreen

		if not v12 then
			v12 = not (session == nil) and session.video ~= nil
		end

		if not v12 then
			continue
		end

		local encryptedAdTrackingData = v11.metadata.encryptedAdTrackingData
		local v13 = result[encryptedAdTrackingData]

		if not ((v13 == nil or v13.metadata.mediaType == v11.metadata.mediaType) and (v13 == nil or shouldReplaceCandidate(v13, v11))) then
			continue
		end

		result[encryptedAdTrackingData] = v11
	end

	return result
end

function class:setSurfaceScope(surfaceScope)
	self._surfaceScope = surfaceScope
end

function class:setViewportBounds(viewportBounds)
	self._viewportBounds = viewportBounds
end

function class:start()
	if self._running then
		return
	end

	self._running = true

	if not self._paused then
		self:_scheduleNextScan()
	end
end

function class:_cancelScheduledScan()
	local scanThread = self._scanThread

	if scanThread ~= nil and coroutine.status(scanThread) == "suspended" then
		task.cancel(scanThread)
	end

	self._scanThread = nil
end

function class:_scheduleNextScan()
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

function class:_scanTick(p2)
	local surfaceScope = self._surfaceScope
	local viewportBounds = self._viewportBounds

	if surfaceScope == nil or viewportBounds == nil then
		return
	end

	local v6

	if viewportBounds.max.X > viewportBounds.min.X then
		v6 = viewportBounds.max.Y > viewportBounds.min.Y
	else
		v6 = false
	end

	if not v6 then
		return
	end

	local encryptedAdTrackingDataSet = {}

	local v7 = {}
	local encryptedAdTrackingDataSet2 = {}

	for k, v8 in CollectionService:GetTagged(Constants.CandidateTag) do
		local registeredTile, v9, v10 = getRegisteredTile(v8, surfaceScope)

		if not (registeredTile ~= nil and v9 ~= nil and v10 ~= nil) then
			continue
		end

		local encryptedAdTrackingData = v10.encryptedAdTrackingData
		local v11 = measureRegisteredTile(registeredTile, v9, v10, viewportBounds)

		if v11 == nil then
			local session = self._sessions[encryptedAdTrackingData]

			if
				v10.isFullscreen == true
				and v10.mediaType == "video"
				and session ~= nil
				and session.video ~= nil
			then
				encryptedAdTrackingDataSet2[encryptedAdTrackingData] = true
			end
		else
			local session = self._sessions[encryptedAdTrackingData]
			local v12 = not v11.isFullscreen

			if not v12 then
				v12 = not (session == nil) and session.video ~= nil
			end

			if v12 then
				encryptedAdTrackingDataSet[encryptedAdTrackingData] = true
				local encryptedAdTrackingData2 = v11.metadata.encryptedAdTrackingData
				local v13 = v7[encryptedAdTrackingData2]

				if
					(v13 == nil or v13.metadata.mediaType == v11.metadata.mediaType)
					and (v13 == nil or shouldReplaceCandidate(v13, v11))
				then
					v7[encryptedAdTrackingData2] = v11
				end
			end
		end
	end

	for k, v8 in v7 do
		if not encryptedAdTrackingDataSet2[k] or v8.isFullscreen then
			self:_processMeasurement(k, v8, p2)
		end
	end

	for k, session in self._sessions do
		if encryptedAdTrackingDataSet[k] or encryptedAdTrackingDataSet2[k] then
			continue
		end

		local video = session.video
		self:_advanceSession(session, p2, 0, nil, nil, video ~= nil and video.isFullscreen)
	end
end

function class:pause(p2)
	if self._paused then
		return
	end

	local v6 = p2 or DateTime.now().UnixTimestampMillis
	local currentVideoMeasurements = self:_collectCurrentVideoMeasurements()

	for k, session in self._sessions do
		if session.video ~= nil then
			self:_applySelectedVideoMeasurement(session, currentVideoMeasurements[k], v6)
		end

		session.state:pause(v6)
	end

	self._paused = true
	self:_cancelScheduledScan()
end

function class:resume(p2)
	if not self._paused then
		return
	end

	local v6 = p2 or DateTime.now().UnixTimestampMillis

	for k, session in self._sessions do
		session.state:resume(v6)
	end

	self._paused = false

	if self._running then
		self:_scheduleNextScan()
	end
end

function class:_terminateAllSessions(p2, p3)
	local sessions = self._sessions
	local v6 = self._paused and {} or self:_collectCurrentVideoMeasurements()
	self._sessions = {}

	for k, session in sessions do
		if not self._paused and session.video ~= nil then
			self:_applySelectedVideoMeasurement(session, v6[k], p2)
		end

		local finalize = session.state:finalize(p2)
		invokeCallback("onUnload", self._callbacks.onUnload, session.metadata, finalize, p3)
	end
end

function class:onFeedRefresh(p2)
	self:_terminateAllSessions(p2 or DateTime.now().UnixTimestampMillis, v5.FeedRefresh)
end

function class:reset(p2)
	self._running = false
	self:_cancelScheduledScan()

	self:_terminateAllSessions(p2 or DateTime.now().UnixTimestampMillis, v5.SurfaceTeardown)
end

class.TerminalReason = v5

return class
