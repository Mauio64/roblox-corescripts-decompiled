require(script.Parent.calculateIntersectionRatio)
require(script.Parent.sponsoredAdViewabilityTypes)

local v = { 0, 25, 50, 75, 100 }

local milestoneLabels = {
	IabDisplayStandard = "IabDisplayStandard",
	IabDisplayLarge = "IabDisplayLarge",
	FullView = "FullView",
	IabVideoStandard = "IabVideoStandard",
	FullViewVideo = "FullViewVideo"
}

local function newBand(threshold: number, currentContinuousMs: number?)
	if currentContinuousMs == nil then
		return { threshold = threshold, enteredAtMs = nil, cumulativeMs = 0, maxContinuousMs = 0 }
	end

	return {
		threshold = threshold,
		enteredAtMs = nil,
		currentContinuousMs = currentContinuousMs,
		pendingContinuity = false,
		cumulativeMs = 0,
		maxContinuousMs = 0
	}
end

local function recordClosedWindow(state, maxContinuousMs: number) -- 2 equivalent calls inferred from this helper
	state.cumulativeMs += maxContinuousMs

	if state.maxContinuousMs < maxContinuousMs then
		state.maxContinuousMs = maxContinuousMs
	end

	state.enteredAtMs = nil
end

local function closeWindow(state, p: number?) -- 39 equivalent calls inferred from this helper
	local enteredAtMs = state.enteredAtMs
	local currentContinuousMs = state.currentContinuousMs

	if currentContinuousMs == nil then
		if enteredAtMs == nil then
			return
		end

		recordClosedWindow(state, assert(p, "image band requires an end timestamp") - enteredAtMs) -- inferred equivalent call
	else
		if enteredAtMs == nil and not state.pendingContinuity then
			return
		end

		recordClosedWindow(state, currentContinuousMs) -- inferred equivalent call
		state.currentContinuousMs = 0
		state.pendingContinuity = false
	end
end

local function updateBandTimer(state, p: number, enteredAtMs: number) -- 3 equivalent calls inferred from this helper
	if state.threshold <= p then
		if state.enteredAtMs == nil then
			state.enteredAtMs = enteredAtMs
		end
	else
		closeWindow(state, enteredAtMs) -- inferred equivalent call
	end
end

local function durationAsOf(data, p: number?) -- 6 equivalent calls inferred from this helper
	local cumulativeMs = data.cumulativeMs
	local v2 = data.maxContinuousMs
	local enteredAtMs = data.enteredAtMs
	local currentContinuousMs = data.currentContinuousMs
	local v3 = nil

	if currentContinuousMs == nil then
		if enteredAtMs ~= nil then
			v3 = assert(p, "image band requires the current timestamp") - enteredAtMs
		end
	elseif enteredAtMs ~= nil or data.pendingContinuity then
		v3 = currentContinuousMs
	end

	if v3 ~= nil then
		cumulativeMs += v3

		if v2 < v3 then
			v2 = v3
		end
	end

	return cumulativeMs, v2
end

local function continuousVideoDurationAsOf(p) -- 1 equivalent call inferred from this helper
	if p.enteredAtMs == nil then
		return 0
	end

	return p.currentContinuousMs or 0
end

local function preserveVideoBandAcrossSourceChange(p) -- 3 equivalent calls inferred from this helper
	if p.enteredAtMs ~= nil then
		p.enteredAtMs = nil
		p.pendingContinuity = true
	end
end

local function copyGeometry(p)
	return {
		adSize = p.adSize,
		viewportBounds = { min = p.viewportBounds.min, max = p.viewportBounds.max }
	}
end

local function audioOn(lastSnapshot) -- 3 equivalent calls inferred from this helper
	return lastSnapshot ~= nil and lastSnapshot.isPlaying and lastSnapshot.audioLevel > 0
end

local function isNonnegativeInteger(value): boolean -- 2 equivalent calls inferred from this helper
	return typeof(value) == "number" and value >= 0 and value % 1 == 0
end

local function isValidVideoPlaybackSnapshot(lastSnapshot)
	local playbackPositionMs = lastSnapshot.playbackPositionMs
	local loopCount = lastSnapshot.loopCount
	local endedCount = lastSnapshot.endedCount
	local audioLevel = lastSnapshot.audioLevel
	local videoLengthMs = lastSnapshot.videoLengthMs
	local v2

	if
		typeof(lastSnapshot.isPlaying) == "boolean"
		and typeof(playbackPositionMs) == "number"
		and playbackPositionMs >= 0
	then
		v2 = isNonnegativeInteger(loopCount) -- inferred equivalent call

		if v2 then
			if endedCount == nil then
				if typeof(audioLevel) == "number" and audioLevel >= 0 and audioLevel <= 1 then
					if videoLengthMs == nil then
						return true
					elseif typeof(videoLengthMs) == "number" then
						return videoLengthMs > 0
					else
						return false
					end
				else
					return false
				end
			else
				v2 = isNonnegativeInteger(endedCount) -- inferred equivalent call

				if v2 then
					if typeof(audioLevel) == "number" and audioLevel >= 0 and audioLevel <= 1 then
						if videoLengthMs == nil then
							return true
						elseif typeof(videoLengthMs) == "number" then
							return videoLengthMs > 0
						else
							return false
						end
					else
						return false
					end
				end
			end
		end
	else
		return false
	end

	return v2
end

local function realEstateOf(p: number, p2) -- 1 equivalent call inferred from this helper
	if p2 == nil then
		return 0
	end

	local viewportBounds = p2.viewportBounds
	local v2 = (viewportBounds.max.X - viewportBounds.min.X) * (viewportBounds.max.Y - viewportBounds.min.Y)

	if v2 <= 0 then
		return 0
	end

	return p * p2.adSize.X * p2.adSize.Y / v2
end

local SponsoredAdViewabilityState = {}
SponsoredAdViewabilityState.__index = SponsoredAdViewabilityState

function SponsoredAdViewabilityState.new(startTimestampMs: number, flag: boolean)
	local v2 = flag == true
	return (setmetatable({
		startTimestampMs = startTimestampMs,
		_achieved = {},
		_band30 = newBand(0.3, v2 and 0 or nil),
		_band50 = newBand(0.5, v2 and 0 or nil),
		_band100 = newBand(1, v2 and 0 or nil),
		_inGridBand50 = v2 and {
			threshold = 0.5,
			enteredAtMs = nil,
			currentContinuousMs = 0,
			pendingContinuity = false,
			cumulativeMs = 0,
			maxContinuousMs = 0
		} or nil,
		_fullscreenBand50 = v2 and {
			threshold = 0.5,
			enteredAtMs = nil,
			currentContinuousMs = 0,
			pendingContinuity = false,
			cumulativeMs = 0,
			maxContinuousMs = 0
		} or nil,
		_displayLabel = nil,
		_lastSampleMs = nil,
		_lastRatio = 0,
		_lastRealEstate = 0,
		_percentWeightedSum = 0,
		_realEstateWeightedSum = 0,
		_visibleWeightedMs = 0,
		_minPercentSeen = nil,
		_maxPercentSeen = nil,
		_latchedGeometry = nil,
		_pausedAtMs = nil,
		_pausedDurationMs = 0,
		_video = v2 and {
			highestProgress = nil,
			lengthMs = nil,
			cumulativePlaytimeMs = 0,
			lastSampleMs = nil,
			lastSnapshot = nil,
			isFullscreen = false,
			cumulativeAudioPlaybackMs = 0,
			cumulative100PercentAudibleMs = 0,
			maxAudioLevel = 0,
			audioOnAtEvent = false
		} or nil,
		_finalized = false,
		_terminalSnapshot = nil
	}, SponsoredAdViewabilityState))
end

function SponsoredAdViewabilityState:_classifyDisplayOnce(vector2: Vector2)
	if self._displayLabel ~= nil then
		return
	end

	local v2 = vector2.X * vector2.Y

	if v2 <= 0 then
		return
	end

	local displayLabel

	if v2 > 242500 then
		displayLabel = milestoneLabels.IabDisplayLarge
	else
		displayLabel = milestoneLabels.IabDisplayStandard
	end

	self._displayLabel = displayLabel
end

function SponsoredAdViewabilityState:_tryFire(p, milestoneLabel: string, p2: number, p3, list, value: number?)
	if self._achieved[milestoneLabel] then
		return
	end

	local video = self._video
	local v2

	if video == nil then
		local enteredAtMs = p.enteredAtMs

		if enteredAtMs == nil then
			v2 = false
		else
			v2 = p2 - enteredAtMs >= 1000
		end
	else
		local v3 = continuousVideoDurationAsOf(p) -- inferred equivalent call
		v2 = (value or 1000) <= v3
	end

	if not v2 then
		return
	end

	local cumulative30PercentInViewDurationMs, maxContinuous30PercentInViewDurationMs = durationAsOf(self._band30, p2) -- inferred equivalent call
	local cumulative50PercentInViewDurationMs, maxContinuous50PercentInViewDurationMs = durationAsOf(self._band50, p2) -- inferred equivalent call
	local cumulative100PercentInViewDurationMs, maxContinuous100PercentInViewDurationMs = durationAsOf(self._band100, p2) -- inferred equivalent call
	local v3 = {
		milestoneLabel = milestoneLabel,
		geometry = copyGeometry(p3),
		viewabilitySessionStartTimestampMs = self.startTimestampMs,
		cumulative30PercentInViewDurationMs = cumulative30PercentInViewDurationMs,
		cumulative50PercentInViewDurationMs = cumulative50PercentInViewDurationMs,
		cumulative100PercentInViewDurationMs = cumulative100PercentInViewDurationMs,
		maxContinuous30PercentInViewDurationMs = maxContinuous30PercentInViewDurationMs,
		maxContinuous50PercentInViewDurationMs = maxContinuous50PercentInViewDurationMs,
		maxContinuous100PercentInViewDurationMs = maxContinuous100PercentInViewDurationMs
	}

	if video ~= nil then
		local inGridBand50 = self._inGridBand50
		local fullscreenBand50 = self._fullscreenBand50

		if inGridBand50 == nil or fullscreenBand50 == nil then
			return
		end

		v3.isFullScreen = video.isFullscreen
		v3.videoLengthMs = video.lengthMs
		v3.maxAudioLevel = video.maxAudioLevel
		local cumulativeMs = inGridBand50.cumulativeMs
		local maxContinuousMs = inGridBand50.maxContinuousMs
		local enteredAtMs = inGridBand50.enteredAtMs
		local currentContinuousMs = inGridBand50.currentContinuousMs
		local v4 = nil

		if currentContinuousMs == nil then
			if enteredAtMs ~= nil then
				v4 = assert(nil, "image band requires the current timestamp") - enteredAtMs
			end
		elseif enteredAtMs ~= nil or inGridBand50.pendingContinuity then
			v4 = currentContinuousMs
		end

		if v4 ~= nil then
			cumulativeMs += v4
			local _ = maxContinuousMs < v4
		end

		v3.cumulativeInGridViewDurationMs = cumulativeMs
		local cumulativeMs2 = fullscreenBand50.cumulativeMs
		local maxContinuousMs2 = fullscreenBand50.maxContinuousMs
		local enteredAtMs2 = fullscreenBand50.enteredAtMs
		local currentContinuousMs2 = fullscreenBand50.currentContinuousMs
		local v5 = nil

		if currentContinuousMs2 == nil then
			if enteredAtMs2 ~= nil then
				v5 = assert(nil, "image band requires the current timestamp") - enteredAtMs2
			end
		elseif enteredAtMs2 ~= nil or fullscreenBand50.pendingContinuity then
			v5 = currentContinuousMs2
		end

		if v5 ~= nil then
			cumulativeMs2 += v5
			local _ = maxContinuousMs2 < v5
		end

		v3.cumulativeFullScreenViewDurationMs = cumulativeMs2
	end

	self._achieved[milestoneLabel] = true
	table.insert(list, v3)
end

function SponsoredAdViewabilityState:_accumulate(lastSampleMs: number, p: number, p2)
	local _lastSampleMs = self._lastSampleMs

	if _lastSampleMs ~= nil and self._lastRatio > 0 then
		local v2 = lastSampleMs - _lastSampleMs

		if v2 > 0 then
			self._percentWeightedSum += self._lastRatio * v2
			self._realEstateWeightedSum += self._lastRealEstate * v2
			self._visibleWeightedMs += v2
		end
	end

	self._lastSampleMs = lastSampleMs
	self._lastRatio = p
	self._lastRealEstate = realEstateOf(p, p2) -- inferred equivalent call

	if p > 0 then
		if self._minPercentSeen == nil or p < self._minPercentSeen then
			self._minPercentSeen = p
		end

		if self._maxPercentSeen == nil or self._maxPercentSeen < p then
			self._maxPercentSeen = p
		end
	end
end

local function updateVideoBand(state, flag: boolean, flag2: boolean, p: number, p2: number, p3: number, enteredAtMs: number)
	if state.pendingContinuity then
		if flag2 and state.threshold <= p2 then
			state.pendingContinuity = false
			state.enteredAtMs = enteredAtMs
			local currentContinuousMs = state.currentContinuousMs

			if flag and currentContinuousMs ~= nil then
				state.currentContinuousMs = currentContinuousMs + p3
			end
		else
			closeWindow(state) -- inferred equivalent call
		end
	elseif flag and state.threshold <= p2 then
		if p < state.threshold then
			closeWindow(state) -- inferred equivalent call

			if flag2 then
				state.enteredAtMs = enteredAtMs
			end
		else
			if state.enteredAtMs == nil then
				state.enteredAtMs = enteredAtMs
			end

			local currentContinuousMs = state.currentContinuousMs

			if currentContinuousMs == nil then
				state.enteredAtMs = nil
				state.pendingContinuity = false
			else
				state.currentContinuousMs = currentContinuousMs + p3

				if not flag2 then
					closeWindow(state) -- inferred equivalent call
				end
			end
		end
	else
		closeWindow(state) -- inferred equivalent call
	end
end

local function updateModeBand(p, flag: boolean, flag2: boolean, flag3: boolean, p2: number, p3: number, p4: number, lastSampleMs: number) -- 2 equivalent calls inferred from this helper
	local v2 = flag or p.pendingContinuity == true
	updateVideoBand(p, flag2 and v2, flag3 and v2, p2, p3, p4, lastSampleMs)
end

local function observedVideoMovementMs(playbackPositionMs: number?, playbackPositionMs2: number?, p: number?, loopCount: number?, lengthMs: number?) -- 1 equivalent call inferred from this helper
	if playbackPositionMs == nil or playbackPositionMs2 == nil or p == nil or loopCount == nil then
		return 0
	end

	if loopCount < p then
		return 0
	end

	local v2 = loopCount - p

	if v2 == 0 then
		return (math.max(0, playbackPositionMs2 - playbackPositionMs))
	end

	if lengthMs == nil or lengthMs <= 0 then
		return 0
	end

	return (math.max(0, v2 * lengthMs + playbackPositionMs2 - playbackPositionMs))
end

local function videoProgressPercent(flag: boolean, lengthMs: number?, playbackPositionMs: number) -- 1 equivalent call inferred from this helper
	if flag then
		return 100
	end

	if lengthMs == nil or lengthMs <= 0 then
		return 0
	end

	return (math.clamp(playbackPositionMs / lengthMs * 100, 0, 100))
end

function SponsoredAdViewabilityState:_buildVideoProgressMilestone(videoProgress: number, p)
	local video = self._video
	local inGridBand50 = self._inGridBand50
	local fullscreenBand50 = self._fullscreenBand50

	if video == nil or inGridBand50 == nil or fullscreenBand50 == nil then
		return nil
	end

	local cumulative30PercentInViewDurationMs, maxContinuous30PercentInViewDurationMs = durationAsOf(self._band30) -- inferred equivalent call
	local cumulative50PercentInViewDurationMs, maxContinuous50PercentInViewDurationMs = durationAsOf(self._band50) -- inferred equivalent call
	local cumulative100PercentInViewDurationMs, maxContinuous100PercentInViewDurationMs = durationAsOf(self._band100) -- inferred equivalent call
	local cumulativeMs = inGridBand50.cumulativeMs
	local maxContinuousMs = inGridBand50.maxContinuousMs
	local enteredAtMs = inGridBand50.enteredAtMs
	local currentContinuousMs = inGridBand50.currentContinuousMs
	local v2 = nil

	if currentContinuousMs == nil then
		if enteredAtMs ~= nil then
			v2 = assert(nil, "image band requires the current timestamp") - enteredAtMs
		end
	elseif enteredAtMs ~= nil or inGridBand50.pendingContinuity then
		v2 = currentContinuousMs
	end

	if v2 ~= nil then
		cumulativeMs += v2
		local _ = maxContinuousMs < v2
	end

	local cumulativeMs2 = fullscreenBand50.cumulativeMs
	local maxContinuousMs2 = fullscreenBand50.maxContinuousMs
	local enteredAtMs2 = fullscreenBand50.enteredAtMs
	local currentContinuousMs2 = fullscreenBand50.currentContinuousMs
	local v3 = nil

	if currentContinuousMs2 == nil then
		if enteredAtMs2 ~= nil then
			v3 = assert(nil, "image band requires the current timestamp") - enteredAtMs2
		end
	elseif enteredAtMs2 ~= nil or fullscreenBand50.pendingContinuity then
		v3 = currentContinuousMs2
	end

	if v3 ~= nil then
		cumulativeMs2 += v3
		local _ = maxContinuousMs2 < v3
	end

	return {
		geometry = copyGeometry(p),
		viewabilitySessionStartTimestampMs = self.startTimestampMs,
		cumulative30PercentInViewDurationMs = cumulative30PercentInViewDurationMs,
		cumulative50PercentInViewDurationMs = cumulative50PercentInViewDurationMs,
		cumulative100PercentInViewDurationMs = cumulative100PercentInViewDurationMs,
		maxContinuous30PercentInViewDurationMs = maxContinuous30PercentInViewDurationMs,
		maxContinuous50PercentInViewDurationMs = maxContinuous50PercentInViewDurationMs,
		maxContinuous100PercentInViewDurationMs = maxContinuous100PercentInViewDurationMs,
		videoProgress = videoProgress,
		videoLengthMs = video.lengthMs,
		videoCumulativePlaytimeMs = video.cumulativePlaytimeMs,
		cumulativeAudioPlaybackDurationMs = video.cumulativeAudioPlaybackMs,
		cumulative100PercentAudibleTimeMs = video.cumulative100PercentAudibleMs,
		maxAudioLevel = video.maxAudioLevel,
		audioOnAtEvent = video.audioOnAtEvent,
		isFullScreen = video.isFullscreen,
		cumulativeInGridViewDurationMs = cumulativeMs,
		cumulativeFullScreenViewDurationMs = cumulativeMs2
	}
end

function SponsoredAdViewabilityState:_advanceVideo(lastSampleMs: number, p: number, p2: number, p3, lastSnapshot, isFullscreen: boolean)
	local result = {}

	if self._video == nil or self._inGridBand50 == nil or self._fullscreenBand50 == nil then
		closeWindow(self._band30) -- inferred equivalent call
		closeWindow(self._band50) -- inferred equivalent call
		closeWindow(self._band100) -- inferred equivalent call
		return result, false, false
	else
		local video = self._video
		local inGridBand50 = self._inGridBand50
		local fullscreenBand50 = self._fullscreenBand50
		local lastSampleMs2 = video.lastSampleMs
		local lastSnapshot2 = video.lastSnapshot

		if lastSnapshot ~= nil and not isValidVideoPlaybackSnapshot(lastSnapshot) then
			lastSnapshot = nil
		end

		video.isFullscreen = isFullscreen
		video.audioOnAtEvent = audioOn(lastSnapshot) -- inferred equivalent call

		if lastSnapshot == nil then
			local band30 = self._band30

			if band30.pendingContinuity then
			end

			closeWindow(band30) -- inferred equivalent call
			local band50 = self._band50

			if band50.pendingContinuity then
			end

			closeWindow(band50) -- inferred equivalent call
			local band100 = self._band100

			if band100.pendingContinuity then
			end

			closeWindow(band100) -- inferred equivalent call

			if inGridBand50.pendingContinuity then
			end

			closeWindow(inGridBand50) -- inferred equivalent call

			if fullscreenBand50.pendingContinuity then
			end

			closeWindow(fullscreenBand50) -- inferred equivalent call
			video.lastSampleMs = lastSampleMs
			video.lastSnapshot = nil
			return result, false, false
		else
			if lastSnapshot.videoLengthMs ~= nil then
				video.lengthMs = lastSnapshot.videoLengthMs
			end

			local playbackPositionMs = lastSnapshot.playbackPositionMs
			local loopCount = lastSnapshot.loopCount
			local endedCount = lastSnapshot.endedCount or 0
			local endedCount2 = lastSnapshot2 and (lastSnapshot2.endedCount or 0) or nil
			local playbackPositionMs2

			if lastSnapshot2 then
				playbackPositionMs2 = lastSnapshot2.playbackPositionMs
			end

			local v2

			if lastSnapshot2 then
				v2 = lastSnapshot2.loopCount
			end

			local v3 = observedVideoMovementMs(playbackPositionMs2, playbackPositionMs, v2, loopCount, video.lengthMs) -- inferred equivalent call
			local v4

			if lastSnapshot2 == nil then
				v4 = false
			else
				v4 = lastSnapshot2.loopCount < loopCount
			end

			local v5

			if endedCount2 == nil then
				v5 = false
			else
				v5 = endedCount < endedCount2
			end

			local v6

			if endedCount2 == nil then
				v6 = false
			else
				v6 = not v5 and endedCount2 < endedCount
			end

			local v7 = v4 or v6
			local v8

			if lastSnapshot2 == nil then
				v8 = false
			else
				v8 = lastSnapshot2.isPlaying
			end

			local isPlaying = lastSnapshot.isPlaying

			if v8 then
				if v3 > 0 then
					v8 = not v5 and (isPlaying or v6)
				else
					v8 = false
				end
			end

			local v9 = lastSampleMs2 == nil and 0 or lastSampleMs - lastSampleMs2

			local v10 = not v8 and 0 or math.min(v9, v3)
			local v11 = v6 and v8 and p3 ~= nil
			local v12 = isPlaying or v11

			for _, v13 in { self._band30, self._band50, self._band100 } do
				updateVideoBand(v13, v8, v12, p, p2, v10, lastSampleMs)
			end

			updateModeBand(inGridBand50, not isFullscreen, v8, v12, p, p2, v10, lastSampleMs) -- inferred equivalent call
			updateModeBand(fullscreenBand50, isFullscreen, v8, v12, p, p2, v10, lastSampleMs) -- inferred equivalent call

			if v8 then
				video.cumulativePlaytimeMs += v10

				if lastSnapshot2 ~= nil and audioOn(lastSnapshot2) and (audioOn(lastSnapshot) or v6) then -- inferred equivalent call
					video.cumulativeAudioPlaybackMs += v10
					video.maxAudioLevel = math.max(
						video.maxAudioLevel,
						lastSnapshot2.audioLevel,
						lastSnapshot.audioLevel
					)

					if p >= 1 and p2 >= 1 then
						video.cumulative100PercentAudibleMs += v10
					end
				end
			end

			if (v8 or v7) and p3 ~= nil then
				local v13 = videoProgressPercent(v7, video.lengthMs, playbackPositionMs) -- inferred equivalent call

				for _, highestProgress in v do
					if not ((video.highestProgress == nil or video.highestProgress < highestProgress) and highestProgress <= v13) then
						continue
					end

					local videoProgressMilestone = self:_buildVideoProgressMilestone(highestProgress, p3)

					if videoProgressMilestone == nil then
						continue
					end

					video.highestProgress = highestProgress
					table.insert(result, videoProgressMilestone)
				end
			end

			video.lastSampleMs = lastSampleMs
			video.lastSnapshot = lastSnapshot

			return result, v8 and isPlaying and not v6, v11
		end
	end
end

function SponsoredAdViewabilityState:transitionVideoSource(p: number, flag: boolean?)
	local video = self._video
	local inGridBand50 = self._inGridBand50
	local fullscreenBand50 = self._fullscreenBand50

	if self._finalized or self._pausedAtMs ~= nil or video == nil or inGridBand50 == nil or fullscreenBand50 == nil then
		return
	end

	local lastSampleMs = math.max(p, video.lastSampleMs or self.startTimestampMs)

	if flag then
		for _, v2 in { self._band30, self._band50, self._band100 } do
			preserveVideoBandAcrossSourceChange(v2) -- inferred equivalent call
		end

		if video.isFullscreen then
			closeWindow(inGridBand50) -- inferred equivalent call
			preserveVideoBandAcrossSourceChange(fullscreenBand50) -- inferred equivalent call
		else
			preserveVideoBandAcrossSourceChange(inGridBand50) -- inferred equivalent call
			closeWindow(fullscreenBand50) -- inferred equivalent call
		end
	else
		for _, v2 in { self._band30, self._band50, self._band100 } do
			closeWindow(v2) -- inferred equivalent call
		end

		closeWindow(inGridBand50) -- inferred equivalent call
		closeWindow(fullscreenBand50) -- inferred equivalent call
	end

	if not flag then
		video.lastSampleMs = nil
		video.lastSnapshot = nil
	end

	video.audioOnAtEvent = false
	self._lastSampleMs = lastSampleMs
	self._lastRatio = 0
	self._lastRealEstate = 0
end

function SponsoredAdViewabilityState:pause(pausedAtMs: number)
	local v2 = self._video ~= nil

	if v2 then
		if self._finalized or self._pausedAtMs ~= nil then
			return
		end

		pausedAtMs = math.max(pausedAtMs, self._lastSampleMs or self.startTimestampMs)
	else
		assert(not self._finalized, "pause called after finalize")
		assert(self._pausedAtMs == nil, "pause called while already paused")
		assert((self._lastSampleMs or self.startTimestampMs) <= pausedAtMs, "pause timestamp precedes the last sample")
	end

	self:_accumulate(pausedAtMs, 0, nil)

	if v2 then
		local video = self._video
		closeWindow(self._band30) -- inferred equivalent call
		closeWindow(self._band50) -- inferred equivalent call
		closeWindow(self._band100) -- inferred equivalent call
		local inGridBand50 = self._inGridBand50
		local fullscreenBand50 = self._fullscreenBand50

		if inGridBand50 ~= nil then
			closeWindow(inGridBand50) -- inferred equivalent call
		end

		if fullscreenBand50 ~= nil then
			closeWindow(fullscreenBand50) -- inferred equivalent call
		end

		video.lastSampleMs = nil
		video.lastSnapshot = nil
		video.audioOnAtEvent = false
	else
		closeWindow(self._band30, pausedAtMs) -- inferred equivalent call
		closeWindow(self._band50, pausedAtMs) -- inferred equivalent call
		closeWindow(self._band100, pausedAtMs) -- inferred equivalent call
	end

	self._pausedAtMs = pausedAtMs
end

function SponsoredAdViewabilityState:resume(lastSampleMs: number)
	local pausedAtMs = self._pausedAtMs

	if self._video ~= nil then
		if self._finalized or pausedAtMs == nil then
			return
		end

		lastSampleMs = math.max(lastSampleMs, pausedAtMs)
	else
		assert(not self._finalized, "resume called after finalize")
		assert(pausedAtMs ~= nil, "resume called while not paused")
		assert(pausedAtMs <= lastSampleMs, "resume timestamp precedes pause")
	end

	self._pausedDurationMs += lastSampleMs - pausedAtMs
	self._pausedAtMs = nil
	self._lastSampleMs = lastSampleMs
	self._lastRatio = 0
	self._lastRealEstate = 0
end

function SponsoredAdViewabilityState:_advance_deprecated(enteredAtMs: number, p: number, latchedGeometry)
	assert(not self._finalized, "advance called after finalize")
	assert(self._pausedAtMs == nil, "advance called while paused")
	local v2 = {}

	if latchedGeometry ~= nil then
		self:_classifyDisplayOnce(latchedGeometry.adSize)
		self._latchedGeometry = latchedGeometry
	end

	self:_accumulate(enteredAtMs, p, latchedGeometry)

	updateBandTimer(self._band30, p, enteredAtMs) -- inferred equivalent call
	updateBandTimer(self._band50, p, enteredAtMs) -- inferred equivalent call
	updateBandTimer(self._band100, p, enteredAtMs) -- inferred equivalent call

	if latchedGeometry == nil then
		return v2
	end

	local displayLabel = self._displayLabel

	if displayLabel ~= nil then
		local v3

		if displayLabel == milestoneLabels.IabDisplayLarge then
			v3 = self._band30
		else
			v3 = self._band50
		end

		self:_tryFire(v3, displayLabel, enteredAtMs, latchedGeometry, v2)
	end

	self:_tryFire(self._band100, milestoneLabels.FullView, enteredAtMs, latchedGeometry, v2)

	return v2
end

function SponsoredAdViewabilityState:advance(p: number, p2: number, latchedGeometry, p3, flag: boolean?)
	if self._video == nil then
		return self:_advance_deprecated(p, p2, latchedGeometry)
	end

	local v2 = {}

	if self._finalized or self._pausedAtMs ~= nil or p < (self._lastSampleMs or self.startTimestampMs) then
		return v2, {}
	end

	if latchedGeometry ~= nil then
		self._latchedGeometry = latchedGeometry
	end

	local lastRatio = self._lastRatio
	self:_accumulate(p, p2, latchedGeometry)

	local v3, v4, v5 = self:_advanceVideo(p, lastRatio, p2, latchedGeometry, p3, flag == true)

	if latchedGeometry == nil then
		return v2, v3
	end

	if v4 or v5 then
		self:_tryFire(self._band50, milestoneLabels.IabVideoStandard, p, latchedGeometry, v2, 2000)

		self:_tryFire(self._band100, milestoneLabels.FullViewVideo, p, latchedGeometry, v2, 1000)
	end

	if not v5 then
		return v2, v3
	end

	closeWindow(self._band30) -- inferred equivalent call
	closeWindow(self._band50) -- inferred equivalent call
	closeWindow(self._band100) -- inferred equivalent call
	local inGridBand50 = self._inGridBand50
	local fullscreenBand50 = self._fullscreenBand50

	if inGridBand50 ~= nil then
		closeWindow(inGridBand50) -- inferred equivalent call
	end

	if fullscreenBand50 ~= nil then
		closeWindow(fullscreenBand50) -- inferred equivalent call
	end

	return v2, v3
end

function SponsoredAdViewabilityState:_finalize_deprecated(viewabilitySessionEndTimestampMs: number)
	assert(not self._finalized, "finalize called more than once on the same session")
	self._finalized = true

	self:_accumulate(viewabilitySessionEndTimestampMs, self._lastRatio, self._latchedGeometry)
	closeWindow(self._band30, viewabilitySessionEndTimestampMs) -- inferred equivalent call
	closeWindow(self._band50, viewabilitySessionEndTimestampMs) -- inferred equivalent call
	closeWindow(self._band100, viewabilitySessionEndTimestampMs) -- inferred equivalent call

	local visibleWeightedMs = self._visibleWeightedMs
	local latchedGeometry = self._latchedGeometry
	local pausedDurationMs = self._pausedDurationMs
	local pausedAtMs = self._pausedAtMs

	if pausedAtMs ~= nil then
		assert(pausedAtMs <= viewabilitySessionEndTimestampMs, "session end precedes pause")
		pausedDurationMs += viewabilitySessionEndTimestampMs - pausedAtMs
	end

	local geometry

	if latchedGeometry == nil then
		geometry = {
			adSize = Vector2.zero,
			viewportBounds = { min = Vector2.zero, max = Vector2.zero }
		}
	else
		geometry = {
			adSize = latchedGeometry.adSize,
			viewportBounds = {
				min = latchedGeometry.viewportBounds.min,
				max = latchedGeometry.viewportBounds.max
			}
		}
	end

	return {
		geometry = geometry,
		viewabilitySessionStartTimestampMs = self.startTimestampMs,
		viewabilitySessionEndTimestampMs = viewabilitySessionEndTimestampMs,
		dwellDurationMs = viewabilitySessionEndTimestampMs - self.startTimestampMs - pausedDurationMs,
		cumulative30PercentInViewDurationMs = self._band30.cumulativeMs,
		cumulative50PercentInViewDurationMs = self._band50.cumulativeMs,
		cumulative100PercentInViewDurationMs = self._band100.cumulativeMs,
		maxContinuous30PercentInViewDurationMs = self._band30.maxContinuousMs,
		maxContinuous50PercentInViewDurationMs = self._band50.maxContinuousMs,
		maxContinuous100PercentInViewDurationMs = self._band100.maxContinuousMs,
		averagePercentSeen = not (visibleWeightedMs > 0) and 0 or self._percentWeightedSum / visibleWeightedMs,
		minPercentSeen = self._minPercentSeen or 0,
		maxPercentSeen = self._maxPercentSeen or 0,
		averageOnScreenRealEstate = not (visibleWeightedMs > 0) and 0 or self._realEstateWeightedSum / visibleWeightedMs
	}
end

function SponsoredAdViewabilityState:finalize(p: number)
	if self._video == nil then
		return self:_finalize_deprecated(p)
	end

	if self._finalized then
		return self._terminalSnapshot
	end

	local video = self._video
	local inGridBand50 = self._inGridBand50
	local fullscreenBand50 = self._fullscreenBand50
	local viewabilitySessionEndTimestampMs = math.max(
		p,
		self.startTimestampMs,
		self._lastSampleMs or self.startTimestampMs,
		self._pausedAtMs or self.startTimestampMs
	)

	if video == nil or inGridBand50 == nil or fullscreenBand50 == nil then
		local finalize_deprecated = self:_finalize_deprecated(viewabilitySessionEndTimestampMs)
		self._terminalSnapshot = finalize_deprecated
		return finalize_deprecated
	else
		self._finalized = true

		self:_accumulate(viewabilitySessionEndTimestampMs, self._lastRatio, self._latchedGeometry)
		closeWindow(self._band30) -- inferred equivalent call
		closeWindow(self._band50) -- inferred equivalent call
		closeWindow(self._band100) -- inferred equivalent call
		closeWindow(inGridBand50) -- inferred equivalent call
		closeWindow(fullscreenBand50) -- inferred equivalent call
		local visibleWeightedMs = self._visibleWeightedMs
		local latchedGeometry = self._latchedGeometry
		local pausedDurationMs = self._pausedDurationMs
		local pausedAtMs = self._pausedAtMs

		if pausedAtMs ~= nil then
			pausedDurationMs += viewabilitySessionEndTimestampMs - pausedAtMs
		end

		local geometry

		if latchedGeometry == nil then
			geometry = {
				adSize = Vector2.zero,
				viewportBounds = { min = Vector2.zero, max = Vector2.zero }
			}
		else
			geometry = copyGeometry(latchedGeometry)
		end

		local terminalSnapshot = {
			geometry = geometry,
			viewabilitySessionStartTimestampMs = self.startTimestampMs,
			viewabilitySessionEndTimestampMs = viewabilitySessionEndTimestampMs,
			dwellDurationMs = viewabilitySessionEndTimestampMs - self.startTimestampMs - pausedDurationMs,
			cumulative30PercentInViewDurationMs = self._band30.cumulativeMs,
			cumulative50PercentInViewDurationMs = self._band50.cumulativeMs,
			cumulative100PercentInViewDurationMs = self._band100.cumulativeMs,
			maxContinuous30PercentInViewDurationMs = self._band30.maxContinuousMs,
			maxContinuous50PercentInViewDurationMs = self._band50.maxContinuousMs,
			maxContinuous100PercentInViewDurationMs = self._band100.maxContinuousMs,
			averagePercentSeen = not (visibleWeightedMs > 0) and 0 or self._percentWeightedSum / visibleWeightedMs,
			minPercentSeen = self._minPercentSeen or 0,
			maxPercentSeen = self._maxPercentSeen or 0,
			averageOnScreenRealEstate = not (visibleWeightedMs > 0) and 0 or self._realEstateWeightedSum / visibleWeightedMs,
			isFullScreen = video.isFullscreen,
			videoProgress = video.highestProgress,
			videoLengthMs = video.lengthMs,
			videoCumulativePlaytimeMs = video.cumulativePlaytimeMs,
			cumulativeAudioPlaybackDurationMs = video.cumulativeAudioPlaybackMs,
			cumulative100PercentAudibleTimeMs = video.cumulative100PercentAudibleMs,
			maxAudioLevel = video.maxAudioLevel,
			audioOnAtEvent = 0,
			cumulativeInGridViewDurationMs = 0,
			cumulativeFullScreenViewDurationMs = 0
		}
		local audioOnAtEvent

		if video.highestProgress ~= nil then
			audioOnAtEvent = video.audioOnAtEvent
		end

		terminalSnapshot.audioOnAtEvent = audioOnAtEvent
		terminalSnapshot.cumulativeInGridViewDurationMs = inGridBand50.cumulativeMs
		terminalSnapshot.cumulativeFullScreenViewDurationMs = fullscreenBand50.cumulativeMs

		self._terminalSnapshot = terminalSnapshot
		return terminalSnapshot
	end
end

SponsoredAdViewabilityState.MilestoneLabels = milestoneLabels
SponsoredAdViewabilityState.MilestoneDurationMs = 1000

return SponsoredAdViewabilityState
