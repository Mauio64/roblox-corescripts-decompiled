require("@game/CorePackages/Workspace/Packages/_Index/SponsoredAdViewability/SponsoredAdViewability/calculateIntersectionRatio")
require("@game/CorePackages/Workspace/Packages/_Index/SponsoredAdViewability/SponsoredAdViewability/sponsoredAdViewabilityTypes")

local v5 = { 0, 25, 50, 75, 100 }

local v6 = {
	IabDisplayStandard = "IabDisplayStandard",
	IabDisplayLarge = "IabDisplayLarge",
	FullView = "FullView",
	IabVideoStandard = "IabVideoStandard",
	FullViewVideo = "FullViewVideo"
}

local function newBand(p2, p3)
	if p3 == nil then
		return {
			threshold = p2,
			enteredAtMs = nil,
			cumulativeMs = 0,
			maxContinuousMs = 0
		}
	end

	return {
		threshold = p2,
		enteredAtMs = nil,
		currentContinuousMs = p3,
		pendingContinuity = false,
		cumulativeMs = 0,
		maxContinuousMs = 0
	}
end

local function recordClosedWindow(state, maxContinuousMs)
	state.cumulativeMs += maxContinuousMs

	if state.maxContinuousMs < maxContinuousMs then
		state.maxContinuousMs = maxContinuousMs
	end

	state.enteredAtMs = nil
end

local function closeWindow(state, p2)
	local enteredAtMs = state.enteredAtMs
	local currentContinuousMs = state.currentContinuousMs

	if currentContinuousMs == nil then
		if enteredAtMs == nil then
			return
		end

		local v7 = assert(p2, "image band requires an end timestamp") - enteredAtMs
		state.cumulativeMs += v7

		if state.maxContinuousMs < v7 then
			state.maxContinuousMs = v7
		end

		state.enteredAtMs = nil
	else
		if enteredAtMs == nil and not state.pendingContinuity then
			return
		end

		state.cumulativeMs += currentContinuousMs

		if state.maxContinuousMs < currentContinuousMs then
			state.maxContinuousMs = currentContinuousMs
		end

		state.enteredAtMs = nil

		state.currentContinuousMs = 0
		state.pendingContinuity = false
	end
end

local function updateBandTimer(state, p2, enteredAtMs)
	if state.threshold <= p2 then
		if state.enteredAtMs == nil then
			state.enteredAtMs = enteredAtMs
		end
	else
		local enteredAtMs2 = state.enteredAtMs
		local currentContinuousMs = state.currentContinuousMs

		if currentContinuousMs == nil then
			if enteredAtMs2 == nil then
				return
			end

			local v7 = assert(enteredAtMs, "image band requires an end timestamp") - enteredAtMs2
			state.cumulativeMs += v7

			if state.maxContinuousMs < v7 then
				state.maxContinuousMs = v7
			end

			state.enteredAtMs = nil
		else
			if enteredAtMs2 == nil and not state.pendingContinuity then
				return
			end

			state.cumulativeMs += currentContinuousMs

			if state.maxContinuousMs < currentContinuousMs then
				state.maxContinuousMs = currentContinuousMs
			end

			state.enteredAtMs = nil

			state.currentContinuousMs = 0
			state.pendingContinuity = false
		end
	end
end

local function durationAsOf(data, p2)
	local cumulativeMs = data.cumulativeMs
	local v7 = data.maxContinuousMs
	local enteredAtMs = data.enteredAtMs
	local currentContinuousMs = data.currentContinuousMs
	local v8 = nil

	if currentContinuousMs == nil then
		if enteredAtMs ~= nil then
			v8 = assert(p2, "image band requires the current timestamp") - enteredAtMs
		end
	elseif enteredAtMs ~= nil or data.pendingContinuity then
		v8 = currentContinuousMs
	end

	if v8 ~= nil then
		cumulativeMs += v8

		if v7 < v8 then
			v7 = v8
		end
	end

	return cumulativeMs, v7
end

local function continuousVideoDurationAsOf(p2)
	if p2.enteredAtMs == nil then
		return 0
	end

	return p2.currentContinuousMs or 0
end

local function preserveVideoBandAcrossSourceChange(p2)
	if p2.enteredAtMs ~= nil then
		p2.enteredAtMs = nil
		p2.pendingContinuity = true
	end
end

local function copyGeometry(p2)
	return {
		adSize = p2.adSize,
		viewportBounds = { min = p2.viewportBounds.min, max = p2.viewportBounds.max }
	}
end

local function audioOn(p2)
	return p2 ~= nil and p2.isPlaying and p2.audioLevel > 0
end

local function isNonnegativeInteger(value): boolean
	return typeof(value) == "number" and value >= 0 and value % 1 == 0
end

local function isValidVideoPlaybackSnapshot(lastSnapshot)
	local playbackPositionMs = lastSnapshot.playbackPositionMs
	local loopCount = lastSnapshot.loopCount
	local endedCount = lastSnapshot.endedCount
	local audioLevel = lastSnapshot.audioLevel
	local videoLengthMs = lastSnapshot.videoLengthMs
	local v7

	if
		typeof(lastSnapshot.isPlaying) == "boolean"
		and typeof(playbackPositionMs) == "number"
		and playbackPositionMs >= 0
	then
		v7 = typeof(loopCount) == "number" and loopCount >= 0 and loopCount % 1 == 0

		if v7 then
			if endedCount == nil then
				if typeof(audioLevel) == "number" and audioLevel >= 0 and audioLevel <= 1 then
					v7 = videoLengthMs == nil or typeof(videoLengthMs) == "number" and videoLengthMs > 0
				else
					v7 = false
				end
			else
				v7 = typeof(endedCount) == "number" and endedCount >= 0 and endedCount % 1 == 0

				if v7 then
					if typeof(audioLevel) == "number" and audioLevel >= 0 and audioLevel <= 1 then
						v7 = videoLengthMs == nil or typeof(videoLengthMs) == "number" and videoLengthMs > 0
					else
						v7 = false
					end
				end
			end
		end
	else
		v7 = false
	end

	return v7
end

local function realEstateOf(p2, p3)
	if p3 == nil then
		return 0
	end

	local viewportBounds = p3.viewportBounds
	local v7 = (viewportBounds.max.X - viewportBounds.min.X) * (viewportBounds.max.Y - viewportBounds.min.Y)

	if v7 <= 0 then
		return 0
	end

	return p2 * p3.adSize.X * p3.adSize.Y / v7
end

local class = {}
class.__index = class

function class.new(p2, p3)
	local v7 = p3 == true
	return (setmetatable({
		startTimestampMs = p2,
		_achieved = {},
		_band30 = newBand(0.3, v7 and 0 or nil),
		_band50 = newBand(0.5, v7 and 0 or nil),
		_band100 = newBand(1, v7 and 0 or nil),
		_inGridBand50 = v7 and {
			threshold = 0.5,
			enteredAtMs = nil,
			currentContinuousMs = 0,
			pendingContinuity = false,
			cumulativeMs = 0,
			maxContinuousMs = 0
		} or nil,
		_fullscreenBand50 = v7 and {
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
		_video = v7 and {
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
	}, class))
end

function class:_classifyDisplayOnce(p3)
	if self._displayLabel ~= nil then
		return
	end

	local v7 = p3.X * p3.Y

	if v7 <= 0 then
		return
	end

	local v8 = if v7 > 242500 then v6.IabDisplayLarge else v6.IabDisplayStandard
	self._displayLabel = v8
end

function class:_tryFire(p2, p3, p4, p5, list, value)
	if self._achieved[p3] then
		return
	end

	local video = self._video
	local v7

	if video == nil then
		local enteredAtMs = p2.enteredAtMs
		v7 = not (enteredAtMs == nil) and p4 - enteredAtMs >= 1000
	else
		v7 = (value or 1000) <= (p2.enteredAtMs == nil and 0 or p2.currentContinuousMs or 0)
	end

	if not v7 then
		return
	end

	local band30 = self._band30
	local cumulativeMs = band30.cumulativeMs
	local v8 = band30.maxContinuousMs
	local enteredAtMs = band30.enteredAtMs
	local currentContinuousMs = band30.currentContinuousMs
	local v9 = nil

	if currentContinuousMs == nil then
		if enteredAtMs ~= nil then
			v9 = assert(p4, "image band requires the current timestamp") - enteredAtMs
		end
	elseif enteredAtMs ~= nil or band30.pendingContinuity then
		v9 = currentContinuousMs
	end

	if v9 ~= nil then
		cumulativeMs += v9

		if v8 < v9 then
			v8 = v9
		end
	end

	local band50 = self._band50
	local cumulativeMs2 = band50.cumulativeMs
	local v10 = band50.maxContinuousMs
	local enteredAtMs2 = band50.enteredAtMs
	local currentContinuousMs2 = band50.currentContinuousMs
	local v11 = nil

	if currentContinuousMs2 == nil then
		if enteredAtMs2 ~= nil then
			v11 = assert(p4, "image band requires the current timestamp") - enteredAtMs2
		end
	elseif enteredAtMs2 ~= nil or band50.pendingContinuity then
		v11 = currentContinuousMs2
	end

	if v11 ~= nil then
		cumulativeMs2 += v11

		if v10 < v11 then
			v10 = v11
		end
	end

	local band100 = self._band100
	local cumulativeMs3 = band100.cumulativeMs
	local v12 = band100.maxContinuousMs
	local enteredAtMs3 = band100.enteredAtMs
	local currentContinuousMs3 = band100.currentContinuousMs
	local v13 = nil

	if currentContinuousMs3 == nil then
		if enteredAtMs3 ~= nil then
			v13 = assert(p4, "image band requires the current timestamp") - enteredAtMs3
		end
	elseif enteredAtMs3 ~= nil or band100.pendingContinuity then
		v13 = currentContinuousMs3
	end

	if v13 ~= nil then
		cumulativeMs3 += v13

		if v12 < v13 then
			v12 = v13
		end
	end

	local v14 = {
		milestoneLabel = p3,
		geometry = copyGeometry(p5),
		viewabilitySessionStartTimestampMs = self.startTimestampMs,
		cumulative30PercentInViewDurationMs = cumulativeMs,
		cumulative50PercentInViewDurationMs = cumulativeMs2,
		cumulative100PercentInViewDurationMs = cumulativeMs3,
		maxContinuous30PercentInViewDurationMs = v8,
		maxContinuous50PercentInViewDurationMs = v10,
		maxContinuous100PercentInViewDurationMs = v12
	}

	if video ~= nil then
		local inGridBand50 = self._inGridBand50
		local fullscreenBand50 = self._fullscreenBand50

		if inGridBand50 == nil or fullscreenBand50 == nil then
			return
		end

		v14.isFullScreen = video.isFullscreen
		v14.videoLengthMs = video.lengthMs
		v14.maxAudioLevel = video.maxAudioLevel
		local cumulativeMs4 = inGridBand50.cumulativeMs
		local maxContinuousMs = inGridBand50.maxContinuousMs
		local enteredAtMs4 = inGridBand50.enteredAtMs
		local currentContinuousMs4 = inGridBand50.currentContinuousMs
		local v15 = nil

		if currentContinuousMs4 == nil then
			if enteredAtMs4 ~= nil then
				v15 = assert(nil, "image band requires the current timestamp") - enteredAtMs4
			end
		elseif enteredAtMs4 ~= nil or inGridBand50.pendingContinuity then
			v15 = currentContinuousMs4
		end

		if v15 ~= nil then
			cumulativeMs4 += v15
			local v16 = maxContinuousMs < v15
		end

		v14.cumulativeInGridViewDurationMs = cumulativeMs4
		local cumulativeMs5 = fullscreenBand50.cumulativeMs
		local maxContinuousMs2 = fullscreenBand50.maxContinuousMs
		local enteredAtMs5 = fullscreenBand50.enteredAtMs
		local currentContinuousMs5 = fullscreenBand50.currentContinuousMs
		local v16 = nil

		if currentContinuousMs5 == nil then
			if enteredAtMs5 ~= nil then
				v16 = assert(nil, "image band requires the current timestamp") - enteredAtMs5
			end
		elseif enteredAtMs5 ~= nil or fullscreenBand50.pendingContinuity then
			v16 = currentContinuousMs5
		end

		if v16 ~= nil then
			cumulativeMs5 += v16
			local v17 = maxContinuousMs2 < v16
		end

		v14.cumulativeFullScreenViewDurationMs = cumulativeMs5
	end

	self._achieved[p3] = true
	table.insert(list, v14)
end

function class:_accumulate(lastSampleMs, p2, p3)
	local lastSampleMs2 = self._lastSampleMs

	if lastSampleMs2 ~= nil and self._lastRatio > 0 then
		local v7 = lastSampleMs - lastSampleMs2

		if v7 > 0 then
			self._percentWeightedSum += self._lastRatio * v7
			self._realEstateWeightedSum += self._lastRealEstate * v7
			self._visibleWeightedMs += v7
		end
	end

	self._lastSampleMs = lastSampleMs
	self._lastRatio = p2
	local v7

	if p3 == nil then
		v7 = 0
	else
		local viewportBounds = p3.viewportBounds
		local v8 = (viewportBounds.max.X - viewportBounds.min.X) * (viewportBounds.max.Y - viewportBounds.min.Y)
		v7 = v8 <= 0 and 0 or p2 * p3.adSize.X * p3.adSize.Y / v8
	end

	self._lastRealEstate = v7

	if p2 > 0 then
		if self._minPercentSeen == nil or p2 < self._minPercentSeen then
			self._minPercentSeen = p2
		end

		if self._maxPercentSeen == nil or self._maxPercentSeen < p2 then
			self._maxPercentSeen = p2
		end
	end
end

local function updateVideoBand(state, p2, p3, p4, p5, p6, enteredAtMs)
	if state.pendingContinuity then
		if p3 and state.threshold <= p5 then
			state.pendingContinuity = false
			state.enteredAtMs = enteredAtMs
			local currentContinuousMs = state.currentContinuousMs

			if p2 and currentContinuousMs ~= nil then
				state.currentContinuousMs = currentContinuousMs + p6
			end
		else
			local enteredAtMs2 = state.enteredAtMs
			local currentContinuousMs = state.currentContinuousMs

			if currentContinuousMs == nil then
				if enteredAtMs2 == nil then
					return
				end

				local v7 = assert(nil, "image band requires an end timestamp") - enteredAtMs2
				state.cumulativeMs += v7

				if state.maxContinuousMs < v7 then
					state.maxContinuousMs = v7
				end

				state.enteredAtMs = nil
			else
				if enteredAtMs2 == nil and not state.pendingContinuity then
					return
				end

				state.cumulativeMs += currentContinuousMs

				if state.maxContinuousMs < currentContinuousMs then
					state.maxContinuousMs = currentContinuousMs
				end

				state.enteredAtMs = nil

				state.currentContinuousMs = 0
				state.pendingContinuity = false
			end
		end
	elseif p2 and state.threshold <= p5 then
		if p4 < state.threshold then
			local enteredAtMs2 = state.enteredAtMs
			local currentContinuousMs = state.currentContinuousMs

			if currentContinuousMs == nil then
				if enteredAtMs2 ~= nil then
					local v7 = assert(nil, "image band requires an end timestamp") - enteredAtMs2
					state.cumulativeMs += v7

					if state.maxContinuousMs < v7 then
						state.maxContinuousMs = v7
					end

					state.enteredAtMs = nil
				end
			elseif enteredAtMs2 ~= nil or state.pendingContinuity then
				state.cumulativeMs += currentContinuousMs

				if state.maxContinuousMs < currentContinuousMs then
					state.maxContinuousMs = currentContinuousMs
				end

				state.enteredAtMs = nil

				state.currentContinuousMs = 0
				state.pendingContinuity = false
			end

			if p3 then
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
				state.currentContinuousMs = currentContinuousMs + p6

				if not p3 then
					local enteredAtMs2 = state.enteredAtMs
					local currentContinuousMs2 = state.currentContinuousMs

					if currentContinuousMs2 == nil then
						if enteredAtMs2 == nil then
							return
						end

						local v7 = assert(nil, "image band requires an end timestamp") - enteredAtMs2
						state.cumulativeMs += v7

						if state.maxContinuousMs < v7 then
							state.maxContinuousMs = v7
						end

						state.enteredAtMs = nil
					else
						if enteredAtMs2 == nil and not state.pendingContinuity then
							return
						end

						state.cumulativeMs += currentContinuousMs2

						if state.maxContinuousMs < currentContinuousMs2 then
							state.maxContinuousMs = currentContinuousMs2
						end

						state.enteredAtMs = nil

						state.currentContinuousMs = 0
						state.pendingContinuity = false
					end
				end
			end
		end
	else
		local enteredAtMs2 = state.enteredAtMs
		local currentContinuousMs = state.currentContinuousMs

		if currentContinuousMs == nil then
			if enteredAtMs2 == nil then
				return
			end

			local v7 = assert(nil, "image band requires an end timestamp") - enteredAtMs2
			state.cumulativeMs += v7

			if state.maxContinuousMs < v7 then
				state.maxContinuousMs = v7
			end

			state.enteredAtMs = nil
		else
			if enteredAtMs2 == nil and not state.pendingContinuity then
				return
			end

			state.cumulativeMs += currentContinuousMs

			if state.maxContinuousMs < currentContinuousMs then
				state.maxContinuousMs = currentContinuousMs
			end

			state.enteredAtMs = nil

			state.currentContinuousMs = 0
			state.pendingContinuity = false
		end
	end
end

local function updateModeBand(p2, p3, p4, p5, p6, p7, p8, p9)
	local v7 = p3 or p2.pendingContinuity == true
	updateVideoBand(p2, p4 and v7, p5 and v7, p6, p7, p8, p9)
end

local function observedVideoMovementMs(p2, p3, p4, p5, p6)
	if p2 == nil or p3 == nil or p4 == nil or p5 == nil then
		return 0
	end

	if p5 < p4 then
		return 0
	end

	local v7 = p5 - p4

	if v7 == 0 then
		return (math.max(0, p3 - p2))
	end

	if p6 == nil or p6 <= 0 then
		return 0
	end

	return (math.max(0, v7 * p6 + p3 - p2))
end

local function videoProgressPercent(p2, p3, p4)
	if p2 then
		return 100
	end

	if p3 == nil or p3 <= 0 then
		return 0
	end

	return (math.clamp(p4 / p3 * 100, 0, 100))
end

function class:_buildVideoProgressMilestone(p2, p3)
	local video = self._video
	local inGridBand50 = self._inGridBand50
	local fullscreenBand50 = self._fullscreenBand50

	if video == nil or inGridBand50 == nil or fullscreenBand50 == nil then
		return nil
	end

	local band30 = self._band30
	local cumulativeMs = band30.cumulativeMs
	local v7 = band30.maxContinuousMs
	local enteredAtMs = band30.enteredAtMs
	local currentContinuousMs = band30.currentContinuousMs
	local v8 = nil

	if currentContinuousMs == nil then
		if enteredAtMs ~= nil then
			v8 = assert(nil, "image band requires the current timestamp") - enteredAtMs
		end
	elseif enteredAtMs ~= nil or band30.pendingContinuity then
		v8 = currentContinuousMs
	end

	if v8 ~= nil then
		cumulativeMs += v8

		if v7 < v8 then
			v7 = v8
		end
	end

	local band50 = self._band50
	local cumulativeMs2 = band50.cumulativeMs
	local v9 = band50.maxContinuousMs
	local enteredAtMs2 = band50.enteredAtMs
	local currentContinuousMs2 = band50.currentContinuousMs
	local v10 = nil

	if currentContinuousMs2 == nil then
		if enteredAtMs2 ~= nil then
			v10 = assert(nil, "image band requires the current timestamp") - enteredAtMs2
		end
	elseif enteredAtMs2 ~= nil or band50.pendingContinuity then
		v10 = currentContinuousMs2
	end

	if v10 ~= nil then
		cumulativeMs2 += v10

		if v9 < v10 then
			v9 = v10
		end
	end

	local band100 = self._band100
	local cumulativeMs3 = band100.cumulativeMs
	local v11 = band100.maxContinuousMs
	local enteredAtMs3 = band100.enteredAtMs
	local currentContinuousMs3 = band100.currentContinuousMs
	local v12 = nil

	if currentContinuousMs3 == nil then
		if enteredAtMs3 ~= nil then
			v12 = assert(nil, "image band requires the current timestamp") - enteredAtMs3
		end
	elseif enteredAtMs3 ~= nil or band100.pendingContinuity then
		v12 = currentContinuousMs3
	end

	if v12 ~= nil then
		cumulativeMs3 += v12

		if v11 < v12 then
			v11 = v12
		end
	end

	local cumulativeMs4 = inGridBand50.cumulativeMs
	local maxContinuousMs = inGridBand50.maxContinuousMs
	local enteredAtMs4 = inGridBand50.enteredAtMs
	local currentContinuousMs4 = inGridBand50.currentContinuousMs
	local v13 = nil

	if currentContinuousMs4 == nil then
		if enteredAtMs4 ~= nil then
			v13 = assert(nil, "image band requires the current timestamp") - enteredAtMs4
		end
	elseif enteredAtMs4 ~= nil or inGridBand50.pendingContinuity then
		v13 = currentContinuousMs4
	end

	if v13 ~= nil then
		cumulativeMs4 += v13
		local v14 = maxContinuousMs < v13
	end

	local cumulativeMs5 = fullscreenBand50.cumulativeMs
	local maxContinuousMs2 = fullscreenBand50.maxContinuousMs
	local enteredAtMs5 = fullscreenBand50.enteredAtMs
	local currentContinuousMs5 = fullscreenBand50.currentContinuousMs
	local v14 = nil

	if currentContinuousMs5 == nil then
		if enteredAtMs5 ~= nil then
			v14 = assert(nil, "image band requires the current timestamp") - enteredAtMs5
		end
	elseif enteredAtMs5 ~= nil or fullscreenBand50.pendingContinuity then
		v14 = currentContinuousMs5
	end

	if v14 ~= nil then
		cumulativeMs5 += v14
		local v15 = maxContinuousMs2 < v14
	end

	return {
		geometry = copyGeometry(p3),
		viewabilitySessionStartTimestampMs = self.startTimestampMs,
		cumulative30PercentInViewDurationMs = cumulativeMs,
		cumulative50PercentInViewDurationMs = cumulativeMs2,
		cumulative100PercentInViewDurationMs = cumulativeMs3,
		maxContinuous30PercentInViewDurationMs = v7,
		maxContinuous50PercentInViewDurationMs = v9,
		maxContinuous100PercentInViewDurationMs = v11,
		videoProgress = p2,
		videoLengthMs = video.lengthMs,
		videoCumulativePlaytimeMs = video.cumulativePlaytimeMs,
		cumulativeAudioPlaybackDurationMs = video.cumulativeAudioPlaybackMs,
		cumulative100PercentAudibleTimeMs = video.cumulative100PercentAudibleMs,
		maxAudioLevel = video.maxAudioLevel,
		audioOnAtEvent = video.audioOnAtEvent,
		isFullScreen = video.isFullscreen,
		cumulativeInGridViewDurationMs = cumulativeMs4,
		cumulativeFullScreenViewDurationMs = cumulativeMs5
	}
end

function class:_advanceVideo(lastSampleMs, p2, p3, p4, lastSnapshot, isFullscreen)
	local result = {}

	if self._video == nil or self._inGridBand50 == nil or self._fullscreenBand50 == nil then
		local band30 = self._band30
		local enteredAtMs = band30.enteredAtMs
		local currentContinuousMs = band30.currentContinuousMs

		if currentContinuousMs == nil then
			if enteredAtMs ~= nil then
				local v7 = assert(nil, "image band requires an end timestamp") - enteredAtMs
				band30.cumulativeMs += v7

				if band30.maxContinuousMs < v7 then
					band30.maxContinuousMs = v7
				end

				band30.enteredAtMs = nil
			end
		elseif enteredAtMs ~= nil or band30.pendingContinuity then
			band30.cumulativeMs += currentContinuousMs

			if band30.maxContinuousMs < currentContinuousMs then
				band30.maxContinuousMs = currentContinuousMs
			end

			band30.enteredAtMs = nil

			band30.currentContinuousMs = 0
			band30.pendingContinuity = false
		end

		local band50 = self._band50
		local enteredAtMs2 = band50.enteredAtMs
		local currentContinuousMs2 = band50.currentContinuousMs

		if currentContinuousMs2 == nil then
			if enteredAtMs2 ~= nil then
				local v7 = assert(nil, "image band requires an end timestamp") - enteredAtMs2
				band50.cumulativeMs += v7

				if band50.maxContinuousMs < v7 then
					band50.maxContinuousMs = v7
				end

				band50.enteredAtMs = nil
			end
		elseif enteredAtMs2 ~= nil or band50.pendingContinuity then
			band50.cumulativeMs += currentContinuousMs2

			if band50.maxContinuousMs < currentContinuousMs2 then
				band50.maxContinuousMs = currentContinuousMs2
			end

			band50.enteredAtMs = nil

			band50.currentContinuousMs = 0
			band50.pendingContinuity = false
		end

		local band100 = self._band100
		local enteredAtMs3 = band100.enteredAtMs
		local currentContinuousMs3 = band100.currentContinuousMs

		if currentContinuousMs3 == nil then
			if enteredAtMs3 ~= nil then
				local v7 = assert(nil, "image band requires an end timestamp") - enteredAtMs3
				band100.cumulativeMs += v7

				if band100.maxContinuousMs < v7 then
					band100.maxContinuousMs = v7
				end

				band100.enteredAtMs = nil
			end
		elseif enteredAtMs3 ~= nil or band100.pendingContinuity then
			band100.cumulativeMs += currentContinuousMs3

			if band100.maxContinuousMs < currentContinuousMs3 then
				band100.maxContinuousMs = currentContinuousMs3
			end

			band100.enteredAtMs = nil

			band100.currentContinuousMs = 0
			band100.pendingContinuity = false
		end

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
		video.audioOnAtEvent = lastSnapshot ~= nil
			and lastSnapshot.isPlaying
			and lastSnapshot.audioLevel > 0

		if lastSnapshot == nil then
			local band30 = self._band30

			if band30.pendingContinuity then
			end

			local enteredAtMs = band30.enteredAtMs
			local currentContinuousMs = band30.currentContinuousMs

			if currentContinuousMs == nil then
				if enteredAtMs ~= nil then
					local v8 = assert(nil, "image band requires an end timestamp") - enteredAtMs
					band30.cumulativeMs += v8

					if band30.maxContinuousMs < v8 then
						band30.maxContinuousMs = v8
					end

					band30.enteredAtMs = nil
				end
			elseif enteredAtMs ~= nil or band30.pendingContinuity then
				band30.cumulativeMs += currentContinuousMs

				if band30.maxContinuousMs < currentContinuousMs then
					band30.maxContinuousMs = currentContinuousMs
				end

				band30.enteredAtMs = nil

				band30.currentContinuousMs = 0
				band30.pendingContinuity = false
			end

			local band50 = self._band50

			if band50.pendingContinuity then
			end

			local enteredAtMs2 = band50.enteredAtMs
			local currentContinuousMs2 = band50.currentContinuousMs

			if currentContinuousMs2 == nil then
				if enteredAtMs2 ~= nil then
					local v8 = assert(nil, "image band requires an end timestamp") - enteredAtMs2
					band50.cumulativeMs += v8

					if band50.maxContinuousMs < v8 then
						band50.maxContinuousMs = v8
					end

					band50.enteredAtMs = nil
				end
			elseif enteredAtMs2 ~= nil or band50.pendingContinuity then
				band50.cumulativeMs += currentContinuousMs2

				if band50.maxContinuousMs < currentContinuousMs2 then
					band50.maxContinuousMs = currentContinuousMs2
				end

				band50.enteredAtMs = nil

				band50.currentContinuousMs = 0
				band50.pendingContinuity = false
			end

			local band100 = self._band100

			if band100.pendingContinuity then
			end

			local enteredAtMs3 = band100.enteredAtMs
			local currentContinuousMs3 = band100.currentContinuousMs

			if currentContinuousMs3 == nil then
				if enteredAtMs3 ~= nil then
					local v8 = assert(nil, "image band requires an end timestamp") - enteredAtMs3
					band100.cumulativeMs += v8

					if band100.maxContinuousMs < v8 then
						band100.maxContinuousMs = v8
					end

					band100.enteredAtMs = nil
				end
			elseif enteredAtMs3 ~= nil or band100.pendingContinuity then
				band100.cumulativeMs += currentContinuousMs3

				if band100.maxContinuousMs < currentContinuousMs3 then
					band100.maxContinuousMs = currentContinuousMs3
				end

				band100.enteredAtMs = nil

				band100.currentContinuousMs = 0
				band100.pendingContinuity = false
			end

			if inGridBand50.pendingContinuity then
			end

			local enteredAtMs4 = inGridBand50.enteredAtMs
			local currentContinuousMs4 = inGridBand50.currentContinuousMs

			if currentContinuousMs4 == nil then
				if enteredAtMs4 ~= nil then
					local v8 = assert(nil, "image band requires an end timestamp") - enteredAtMs4
					inGridBand50.cumulativeMs += v8

					if inGridBand50.maxContinuousMs < v8 then
						inGridBand50.maxContinuousMs = v8
					end

					inGridBand50.enteredAtMs = nil
				end
			elseif enteredAtMs4 ~= nil or inGridBand50.pendingContinuity then
				inGridBand50.cumulativeMs += currentContinuousMs4

				if inGridBand50.maxContinuousMs < currentContinuousMs4 then
					inGridBand50.maxContinuousMs = currentContinuousMs4
				end

				inGridBand50.enteredAtMs = nil

				inGridBand50.currentContinuousMs = 0
				inGridBand50.pendingContinuity = false
			end

			if fullscreenBand50.pendingContinuity then
			end

			local enteredAtMs5 = fullscreenBand50.enteredAtMs
			local currentContinuousMs5 = fullscreenBand50.currentContinuousMs

			if currentContinuousMs5 == nil then
				if enteredAtMs5 ~= nil then
					local v8 = assert(nil, "image band requires an end timestamp") - enteredAtMs5
					fullscreenBand50.cumulativeMs += v8

					if fullscreenBand50.maxContinuousMs < v8 then
						fullscreenBand50.maxContinuousMs = v8
					end

					fullscreenBand50.enteredAtMs = nil
				end
			elseif enteredAtMs5 ~= nil or fullscreenBand50.pendingContinuity then
				fullscreenBand50.cumulativeMs += currentContinuousMs5

				if fullscreenBand50.maxContinuousMs < currentContinuousMs5 then
					fullscreenBand50.maxContinuousMs = currentContinuousMs5
				end

				fullscreenBand50.enteredAtMs = nil

				fullscreenBand50.currentContinuousMs = 0
				fullscreenBand50.pendingContinuity = false
			end

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

			local playbackPositionMs2 = if lastSnapshot2 then lastSnapshot2.playbackPositionMs else nil

			local loopCount2 = if lastSnapshot2 then lastSnapshot2.loopCount else nil

			local lengthMs = video.lengthMs
			local v8

			if
				playbackPositionMs2 == nil
				or playbackPositionMs == nil
				or loopCount2 == nil
				or loopCount == nil
				or loopCount < loopCount2
			then
				v8 = 0
			else
				local v9 = loopCount - loopCount2

				if v9 == 0 then
					v8 = math.max(0, playbackPositionMs - playbackPositionMs2)
				else
					v8 = (lengthMs == nil or lengthMs <= 0) and 0
						or math.max(0, v9 * lengthMs + playbackPositionMs - playbackPositionMs2)
				end
			end

			local v9 = not (lastSnapshot2 == nil) and lastSnapshot2.loopCount < loopCount
			local v10 = not (endedCount2 == nil) and endedCount < endedCount2
			local v11 = not (endedCount2 == nil) and (not v10 and endedCount2 < endedCount)
			local v12 = v9 or v11
			local v13 = not (lastSnapshot2 == nil) and lastSnapshot2.isPlaying
			local isPlaying = lastSnapshot.isPlaying

			if v13 then
				v13 = v8 > 0 and (not v10 and (isPlaying or v11))
			end

			local v14 = lastSampleMs2 == nil and 0 or lastSampleMs - lastSampleMs2

			local v15 = not v13 and 0 or math.min(v14, v8)
			local v16 = v11 and v13 and p4 ~= nil
			local v17 = isPlaying or v16

			for k, v19 in { self._band30, self._band50, self._band100 } do
				updateVideoBand(v19, v13, v17, p2, p3, v15, lastSampleMs)
			end

			local v19 = not isFullscreen or inGridBand50.pendingContinuity == true
			updateVideoBand(inGridBand50, v13 and v19, v17 and v19, p2, p3, v15, lastSampleMs)
			local v20 = isFullscreen or fullscreenBand50.pendingContinuity == true
			updateVideoBand(fullscreenBand50, v13 and v20, v17 and v20, p2, p3, v15, lastSampleMs)

			if v13 then
				video.cumulativePlaytimeMs += v15

				if lastSnapshot2 ~= nil then
					local v21 = not (lastSnapshot2 == nil)
						and (lastSnapshot2.isPlaying and lastSnapshot2.audioLevel > 0)

					if v21 then
						local v22 = not (lastSnapshot == nil)
							and (lastSnapshot.isPlaying and lastSnapshot.audioLevel > 0)

						if v22 or v11 then
							video.cumulativeAudioPlaybackMs += v15
							video.maxAudioLevel = math.max(
								video.maxAudioLevel,
								lastSnapshot2.audioLevel,
								lastSnapshot.audioLevel
							)

							if p2 >= 1 and p3 >= 1 then
								video.cumulative100PercentAudibleMs += v15
							end
						end
					end
				end
			end

			if (v13 or v12) and p4 ~= nil then
				local lengthMs2 = video.lengthMs
				local v21

				if v12 then
					v21 = 100
				elseif lengthMs2 == nil or lengthMs2 <= 0 then
					v21 = 0
				else
					v21 = math.clamp(playbackPositionMs / lengthMs2 * 100, 0, 100)
				end

				for k, v22 in v5 do
					if not ((video.highestProgress == nil or video.highestProgress < v22) and v22 <= v21) then
						continue
					end

					local videoProgressMilestone = self:_buildVideoProgressMilestone(v22, p4)

					if videoProgressMilestone == nil then
						continue
					end

					video.highestProgress = v22
					table.insert(result, videoProgressMilestone)
				end
			end

			video.lastSampleMs = lastSampleMs
			video.lastSnapshot = lastSnapshot

			return result, v13 and isPlaying and not v11, v16
		end
	end
end

function class:transitionVideoSource(p2, p3)
	local video = self._video
	local inGridBand50 = self._inGridBand50
	local fullscreenBand50 = self._fullscreenBand50

	if
		self._finalized
		or self._pausedAtMs ~= nil
		or video == nil
		or inGridBand50 == nil
		or fullscreenBand50 == nil
	then
		return
	end

	local v7 = math.max(p2, video.lastSampleMs or self.startTimestampMs)

	if p3 then
		for k, v8 in { self._band30, self._band50, self._band100 } do
			if v8.enteredAtMs == nil then
				continue
			end

			v8.enteredAtMs = nil
			v8.pendingContinuity = true
		end

		if video.isFullscreen then
			local enteredAtMs = inGridBand50.enteredAtMs
			local currentContinuousMs = inGridBand50.currentContinuousMs

			if currentContinuousMs == nil then
				if enteredAtMs ~= nil then
					local v8 = assert(nil, "image band requires an end timestamp") - enteredAtMs
					inGridBand50.cumulativeMs += v8

					if inGridBand50.maxContinuousMs < v8 then
						inGridBand50.maxContinuousMs = v8
					end

					inGridBand50.enteredAtMs = nil
				end
			elseif enteredAtMs ~= nil or inGridBand50.pendingContinuity then
				inGridBand50.cumulativeMs += currentContinuousMs

				if inGridBand50.maxContinuousMs < currentContinuousMs then
					inGridBand50.maxContinuousMs = currentContinuousMs
				end

				inGridBand50.enteredAtMs = nil

				inGridBand50.currentContinuousMs = 0
				inGridBand50.pendingContinuity = false
			end

			if fullscreenBand50.enteredAtMs ~= nil then
				fullscreenBand50.enteredAtMs = nil
				fullscreenBand50.pendingContinuity = true
			end
		else
			if inGridBand50.enteredAtMs ~= nil then
				inGridBand50.enteredAtMs = nil
				inGridBand50.pendingContinuity = true
			end

			local enteredAtMs = fullscreenBand50.enteredAtMs
			local currentContinuousMs = fullscreenBand50.currentContinuousMs

			if currentContinuousMs == nil then
				if enteredAtMs ~= nil then
					local v8 = assert(nil, "image band requires an end timestamp") - enteredAtMs
					fullscreenBand50.cumulativeMs += v8

					if fullscreenBand50.maxContinuousMs < v8 then
						fullscreenBand50.maxContinuousMs = v8
					end

					fullscreenBand50.enteredAtMs = nil
				end
			elseif enteredAtMs ~= nil or fullscreenBand50.pendingContinuity then
				fullscreenBand50.cumulativeMs += currentContinuousMs

				if fullscreenBand50.maxContinuousMs < currentContinuousMs then
					fullscreenBand50.maxContinuousMs = currentContinuousMs
				end

				fullscreenBand50.enteredAtMs = nil

				fullscreenBand50.currentContinuousMs = 0
				fullscreenBand50.pendingContinuity = false
			end
		end
	else
		for k, v8 in { self._band30, self._band50, self._band100 } do
			local enteredAtMs = v8.enteredAtMs
			local currentContinuousMs = v8.currentContinuousMs

			if currentContinuousMs == nil then
				if enteredAtMs ~= nil then
					local v9 = assert(nil, "image band requires an end timestamp") - enteredAtMs
					v8.cumulativeMs += v9

					if v8.maxContinuousMs < v9 then
						v8.maxContinuousMs = v9
					end

					v8.enteredAtMs = nil
				end
			elseif enteredAtMs ~= nil or v8.pendingContinuity then
				v8.cumulativeMs += currentContinuousMs

				if v8.maxContinuousMs < currentContinuousMs then
					v8.maxContinuousMs = currentContinuousMs
				end

				v8.enteredAtMs = nil

				v8.currentContinuousMs = 0
				v8.pendingContinuity = false
			end
		end

		local enteredAtMs = inGridBand50.enteredAtMs
		local currentContinuousMs = inGridBand50.currentContinuousMs

		if currentContinuousMs == nil then
			if enteredAtMs ~= nil then
				local v8 = assert(nil, "image band requires an end timestamp") - enteredAtMs
				inGridBand50.cumulativeMs += v8

				if inGridBand50.maxContinuousMs < v8 then
					inGridBand50.maxContinuousMs = v8
				end

				inGridBand50.enteredAtMs = nil
			end
		elseif enteredAtMs ~= nil or inGridBand50.pendingContinuity then
			inGridBand50.cumulativeMs += currentContinuousMs

			if inGridBand50.maxContinuousMs < currentContinuousMs then
				inGridBand50.maxContinuousMs = currentContinuousMs
			end

			inGridBand50.enteredAtMs = nil

			inGridBand50.currentContinuousMs = 0
			inGridBand50.pendingContinuity = false
		end

		local enteredAtMs2 = fullscreenBand50.enteredAtMs
		local currentContinuousMs2 = fullscreenBand50.currentContinuousMs

		if currentContinuousMs2 == nil then
			if enteredAtMs2 ~= nil then
				local v8 = assert(nil, "image band requires an end timestamp") - enteredAtMs2
				fullscreenBand50.cumulativeMs += v8

				if fullscreenBand50.maxContinuousMs < v8 then
					fullscreenBand50.maxContinuousMs = v8
				end

				fullscreenBand50.enteredAtMs = nil
			end
		elseif enteredAtMs2 ~= nil or fullscreenBand50.pendingContinuity then
			fullscreenBand50.cumulativeMs += currentContinuousMs2

			if fullscreenBand50.maxContinuousMs < currentContinuousMs2 then
				fullscreenBand50.maxContinuousMs = currentContinuousMs2
			end

			fullscreenBand50.enteredAtMs = nil

			fullscreenBand50.currentContinuousMs = 0
			fullscreenBand50.pendingContinuity = false
		end
	end

	if not p3 then
		video.lastSampleMs = nil
		video.lastSnapshot = nil
	end

	video.audioOnAtEvent = false
	self._lastSampleMs = v7
	self._lastRatio = 0
	self._lastRealEstate = 0
end

function class:pause(pausedAtMs)
	local v7 = self._video ~= nil

	if v7 then
		if self._finalized or self._pausedAtMs ~= nil then
			return
		end

		pausedAtMs = math.max(pausedAtMs, self._lastSampleMs or self.startTimestampMs)
	else
		assert(not self._finalized, "pause called after finalize")
		assert(self._pausedAtMs == nil, "pause called while already paused")
		assert(
			(self._lastSampleMs or self.startTimestampMs) <= pausedAtMs,
			"pause timestamp precedes the last sample"
		)
	end

	self:_accumulate(pausedAtMs, 0, nil)

	if v7 then
		local video = self._video
		local band30 = self._band30
		local enteredAtMs = band30.enteredAtMs
		local currentContinuousMs = band30.currentContinuousMs

		if currentContinuousMs == nil then
			if enteredAtMs ~= nil then
				local v8 = assert(nil, "image band requires an end timestamp") - enteredAtMs
				band30.cumulativeMs += v8

				if band30.maxContinuousMs < v8 then
					band30.maxContinuousMs = v8
				end

				band30.enteredAtMs = nil
			end
		elseif enteredAtMs ~= nil or band30.pendingContinuity then
			band30.cumulativeMs += currentContinuousMs

			if band30.maxContinuousMs < currentContinuousMs then
				band30.maxContinuousMs = currentContinuousMs
			end

			band30.enteredAtMs = nil

			band30.currentContinuousMs = 0
			band30.pendingContinuity = false
		end

		local band50 = self._band50
		local enteredAtMs2 = band50.enteredAtMs
		local currentContinuousMs2 = band50.currentContinuousMs

		if currentContinuousMs2 == nil then
			if enteredAtMs2 ~= nil then
				local v8 = assert(nil, "image band requires an end timestamp") - enteredAtMs2
				band50.cumulativeMs += v8

				if band50.maxContinuousMs < v8 then
					band50.maxContinuousMs = v8
				end

				band50.enteredAtMs = nil
			end
		elseif enteredAtMs2 ~= nil or band50.pendingContinuity then
			band50.cumulativeMs += currentContinuousMs2

			if band50.maxContinuousMs < currentContinuousMs2 then
				band50.maxContinuousMs = currentContinuousMs2
			end

			band50.enteredAtMs = nil

			band50.currentContinuousMs = 0
			band50.pendingContinuity = false
		end

		local band100 = self._band100
		local enteredAtMs3 = band100.enteredAtMs
		local currentContinuousMs3 = band100.currentContinuousMs

		if currentContinuousMs3 == nil then
			if enteredAtMs3 ~= nil then
				local v8 = assert(nil, "image band requires an end timestamp") - enteredAtMs3
				band100.cumulativeMs += v8

				if band100.maxContinuousMs < v8 then
					band100.maxContinuousMs = v8
				end

				band100.enteredAtMs = nil
			end
		elseif enteredAtMs3 ~= nil or band100.pendingContinuity then
			band100.cumulativeMs += currentContinuousMs3

			if band100.maxContinuousMs < currentContinuousMs3 then
				band100.maxContinuousMs = currentContinuousMs3
			end

			band100.enteredAtMs = nil

			band100.currentContinuousMs = 0
			band100.pendingContinuity = false
		end

		local inGridBand50 = self._inGridBand50
		local fullscreenBand50 = self._fullscreenBand50

		if inGridBand50 ~= nil then
			local enteredAtMs4 = inGridBand50.enteredAtMs
			local currentContinuousMs4 = inGridBand50.currentContinuousMs

			if currentContinuousMs4 == nil then
				if enteredAtMs4 ~= nil then
					local v8 = assert(nil, "image band requires an end timestamp") - enteredAtMs4
					inGridBand50.cumulativeMs += v8

					if inGridBand50.maxContinuousMs < v8 then
						inGridBand50.maxContinuousMs = v8
					end

					inGridBand50.enteredAtMs = nil
				end
			elseif enteredAtMs4 ~= nil or inGridBand50.pendingContinuity then
				inGridBand50.cumulativeMs += currentContinuousMs4

				if inGridBand50.maxContinuousMs < currentContinuousMs4 then
					inGridBand50.maxContinuousMs = currentContinuousMs4
				end

				inGridBand50.enteredAtMs = nil

				inGridBand50.currentContinuousMs = 0
				inGridBand50.pendingContinuity = false
			end
		end

		if fullscreenBand50 ~= nil then
			local enteredAtMs4 = fullscreenBand50.enteredAtMs
			local currentContinuousMs4 = fullscreenBand50.currentContinuousMs

			if currentContinuousMs4 == nil then
				if enteredAtMs4 ~= nil then
					local v8 = assert(nil, "image band requires an end timestamp") - enteredAtMs4
					fullscreenBand50.cumulativeMs += v8

					if fullscreenBand50.maxContinuousMs < v8 then
						fullscreenBand50.maxContinuousMs = v8
					end

					fullscreenBand50.enteredAtMs = nil
				end
			elseif enteredAtMs4 ~= nil or fullscreenBand50.pendingContinuity then
				fullscreenBand50.cumulativeMs += currentContinuousMs4

				if fullscreenBand50.maxContinuousMs < currentContinuousMs4 then
					fullscreenBand50.maxContinuousMs = currentContinuousMs4
				end

				fullscreenBand50.enteredAtMs = nil

				fullscreenBand50.currentContinuousMs = 0
				fullscreenBand50.pendingContinuity = false
			end
		end

		video.lastSampleMs = nil
		video.lastSnapshot = nil
		video.audioOnAtEvent = false
	else
		local band30 = self._band30
		local enteredAtMs = band30.enteredAtMs
		local currentContinuousMs = band30.currentContinuousMs

		if currentContinuousMs == nil then
			if enteredAtMs ~= nil then
				local v8 = assert(pausedAtMs, "image band requires an end timestamp") - enteredAtMs
				band30.cumulativeMs += v8

				if band30.maxContinuousMs < v8 then
					band30.maxContinuousMs = v8
				end

				band30.enteredAtMs = nil
			end
		elseif enteredAtMs ~= nil or band30.pendingContinuity then
			band30.cumulativeMs += currentContinuousMs

			if band30.maxContinuousMs < currentContinuousMs then
				band30.maxContinuousMs = currentContinuousMs
			end

			band30.enteredAtMs = nil

			band30.currentContinuousMs = 0
			band30.pendingContinuity = false
		end

		local band50 = self._band50
		local enteredAtMs2 = band50.enteredAtMs
		local currentContinuousMs2 = band50.currentContinuousMs

		if currentContinuousMs2 == nil then
			if enteredAtMs2 ~= nil then
				local v8 = assert(pausedAtMs, "image band requires an end timestamp") - enteredAtMs2
				band50.cumulativeMs += v8

				if band50.maxContinuousMs < v8 then
					band50.maxContinuousMs = v8
				end

				band50.enteredAtMs = nil
			end
		elseif enteredAtMs2 ~= nil or band50.pendingContinuity then
			band50.cumulativeMs += currentContinuousMs2

			if band50.maxContinuousMs < currentContinuousMs2 then
				band50.maxContinuousMs = currentContinuousMs2
			end

			band50.enteredAtMs = nil

			band50.currentContinuousMs = 0
			band50.pendingContinuity = false
		end

		local band100 = self._band100
		local enteredAtMs3 = band100.enteredAtMs
		local currentContinuousMs3 = band100.currentContinuousMs

		if currentContinuousMs3 == nil then
			if enteredAtMs3 ~= nil then
				local v8 = assert(pausedAtMs, "image band requires an end timestamp") - enteredAtMs3
				band100.cumulativeMs += v8

				if band100.maxContinuousMs < v8 then
					band100.maxContinuousMs = v8
				end

				band100.enteredAtMs = nil
			end
		elseif enteredAtMs3 ~= nil or band100.pendingContinuity then
			band100.cumulativeMs += currentContinuousMs3

			if band100.maxContinuousMs < currentContinuousMs3 then
				band100.maxContinuousMs = currentContinuousMs3
			end

			band100.enteredAtMs = nil

			band100.currentContinuousMs = 0
			band100.pendingContinuity = false
		end
	end

	self._pausedAtMs = pausedAtMs
end

function class:resume(lastSampleMs)
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

function class:_advance_deprecated(enteredAtMs, p2, latchedGeometry)
	assert(not self._finalized, "advance called after finalize")
	assert(self._pausedAtMs == nil, "advance called while paused")
	local v7 = {}

	if latchedGeometry ~= nil then
		self:_classifyDisplayOnce(latchedGeometry.adSize)
		self._latchedGeometry = latchedGeometry
	end

	self:_accumulate(enteredAtMs, p2, latchedGeometry)

	local band30 = self._band30

	if band30.threshold <= p2 then
		if band30.enteredAtMs == nil then
			band30.enteredAtMs = enteredAtMs
		end
	else
		local enteredAtMs2 = band30.enteredAtMs
		local currentContinuousMs = band30.currentContinuousMs

		if currentContinuousMs == nil then
			if enteredAtMs2 ~= nil then
				local v8 = assert(enteredAtMs, "image band requires an end timestamp") - enteredAtMs2
				band30.cumulativeMs += v8

				if band30.maxContinuousMs < v8 then
					band30.maxContinuousMs = v8
				end

				band30.enteredAtMs = nil
			end
		elseif enteredAtMs2 ~= nil or band30.pendingContinuity then
			band30.cumulativeMs += currentContinuousMs

			if band30.maxContinuousMs < currentContinuousMs then
				band30.maxContinuousMs = currentContinuousMs
			end

			band30.enteredAtMs = nil

			band30.currentContinuousMs = 0
			band30.pendingContinuity = false
		end
	end

	local band50 = self._band50

	if band50.threshold <= p2 then
		if band50.enteredAtMs == nil then
			band50.enteredAtMs = enteredAtMs
		end
	else
		local enteredAtMs2 = band50.enteredAtMs
		local currentContinuousMs = band50.currentContinuousMs

		if currentContinuousMs == nil then
			if enteredAtMs2 ~= nil then
				local v8 = assert(enteredAtMs, "image band requires an end timestamp") - enteredAtMs2
				band50.cumulativeMs += v8

				if band50.maxContinuousMs < v8 then
					band50.maxContinuousMs = v8
				end

				band50.enteredAtMs = nil
			end
		elseif enteredAtMs2 ~= nil or band50.pendingContinuity then
			band50.cumulativeMs += currentContinuousMs

			if band50.maxContinuousMs < currentContinuousMs then
				band50.maxContinuousMs = currentContinuousMs
			end

			band50.enteredAtMs = nil

			band50.currentContinuousMs = 0
			band50.pendingContinuity = false
		end
	end

	local band100 = self._band100

	if band100.threshold <= p2 then
		if band100.enteredAtMs == nil then
			band100.enteredAtMs = enteredAtMs
		end
	else
		local enteredAtMs2 = band100.enteredAtMs
		local currentContinuousMs = band100.currentContinuousMs

		if currentContinuousMs == nil then
			if enteredAtMs2 ~= nil then
				local v8 = assert(enteredAtMs, "image band requires an end timestamp") - enteredAtMs2
				band100.cumulativeMs += v8

				if band100.maxContinuousMs < v8 then
					band100.maxContinuousMs = v8
				end

				band100.enteredAtMs = nil
			end
		elseif enteredAtMs2 ~= nil or band100.pendingContinuity then
			band100.cumulativeMs += currentContinuousMs

			if band100.maxContinuousMs < currentContinuousMs then
				band100.maxContinuousMs = currentContinuousMs
			end

			band100.enteredAtMs = nil

			band100.currentContinuousMs = 0
			band100.pendingContinuity = false
		end
	end

	if latchedGeometry == nil then
		return v7
	end

	local displayLabel = self._displayLabel

	if displayLabel ~= nil then
		local v8 = if displayLabel == v6.IabDisplayLarge then self._band30 else self._band50
		self:_tryFire(v8, displayLabel, enteredAtMs, latchedGeometry, v7)
	end

	self:_tryFire(self._band100, v6.FullView, enteredAtMs, latchedGeometry, v7)

	return v7
end

function class:advance(p2, p3, latchedGeometry, p4, p5)
	if self._video == nil then
		return self:_advance_deprecated(p2, p3, latchedGeometry)
	end

	local v7 = {}

	if self._finalized or self._pausedAtMs ~= nil or p2 < (self._lastSampleMs or self.startTimestampMs) then
		return v7, {}
	end

	if latchedGeometry ~= nil then
		self._latchedGeometry = latchedGeometry
	end

	local lastRatio = self._lastRatio
	self:_accumulate(p2, p3, latchedGeometry)

	local v8, v9, v10 = self:_advanceVideo(p2, lastRatio, p3, latchedGeometry, p4, p5 == true)

	if latchedGeometry == nil then
		return v7, v8
	end

	if v9 or v10 then
		self:_tryFire(self._band50, v6.IabVideoStandard, p2, latchedGeometry, v7, 2000)

		self:_tryFire(self._band100, v6.FullViewVideo, p2, latchedGeometry, v7, 1000)
	end

	if not v10 then
		return v7, v8
	end

	local band30 = self._band30
	local enteredAtMs = band30.enteredAtMs
	local currentContinuousMs = band30.currentContinuousMs

	if currentContinuousMs == nil then
		if enteredAtMs ~= nil then
			local v11 = assert(nil, "image band requires an end timestamp") - enteredAtMs
			band30.cumulativeMs += v11

			if band30.maxContinuousMs < v11 then
				band30.maxContinuousMs = v11
			end

			band30.enteredAtMs = nil
		end
	elseif enteredAtMs ~= nil or band30.pendingContinuity then
		band30.cumulativeMs += currentContinuousMs

		if band30.maxContinuousMs < currentContinuousMs then
			band30.maxContinuousMs = currentContinuousMs
		end

		band30.enteredAtMs = nil

		band30.currentContinuousMs = 0
		band30.pendingContinuity = false
	end

	local band50 = self._band50
	local enteredAtMs2 = band50.enteredAtMs
	local currentContinuousMs2 = band50.currentContinuousMs

	if currentContinuousMs2 == nil then
		if enteredAtMs2 ~= nil then
			local v11 = assert(nil, "image band requires an end timestamp") - enteredAtMs2
			band50.cumulativeMs += v11

			if band50.maxContinuousMs < v11 then
				band50.maxContinuousMs = v11
			end

			band50.enteredAtMs = nil
		end
	elseif enteredAtMs2 ~= nil or band50.pendingContinuity then
		band50.cumulativeMs += currentContinuousMs2

		if band50.maxContinuousMs < currentContinuousMs2 then
			band50.maxContinuousMs = currentContinuousMs2
		end

		band50.enteredAtMs = nil

		band50.currentContinuousMs = 0
		band50.pendingContinuity = false
	end

	local band100 = self._band100
	local enteredAtMs3 = band100.enteredAtMs
	local currentContinuousMs3 = band100.currentContinuousMs

	if currentContinuousMs3 == nil then
		if enteredAtMs3 ~= nil then
			local v11 = assert(nil, "image band requires an end timestamp") - enteredAtMs3
			band100.cumulativeMs += v11

			if band100.maxContinuousMs < v11 then
				band100.maxContinuousMs = v11
			end

			band100.enteredAtMs = nil
		end
	elseif enteredAtMs3 ~= nil or band100.pendingContinuity then
		band100.cumulativeMs += currentContinuousMs3

		if band100.maxContinuousMs < currentContinuousMs3 then
			band100.maxContinuousMs = currentContinuousMs3
		end

		band100.enteredAtMs = nil

		band100.currentContinuousMs = 0
		band100.pendingContinuity = false
	end

	local inGridBand50 = self._inGridBand50
	local fullscreenBand50 = self._fullscreenBand50

	if inGridBand50 ~= nil then
		local enteredAtMs4 = inGridBand50.enteredAtMs
		local currentContinuousMs4 = inGridBand50.currentContinuousMs

		if currentContinuousMs4 == nil then
			if enteredAtMs4 ~= nil then
				local v11 = assert(nil, "image band requires an end timestamp") - enteredAtMs4
				inGridBand50.cumulativeMs += v11

				if inGridBand50.maxContinuousMs < v11 then
					inGridBand50.maxContinuousMs = v11
				end

				inGridBand50.enteredAtMs = nil
			end
		elseif enteredAtMs4 ~= nil or inGridBand50.pendingContinuity then
			inGridBand50.cumulativeMs += currentContinuousMs4

			if inGridBand50.maxContinuousMs < currentContinuousMs4 then
				inGridBand50.maxContinuousMs = currentContinuousMs4
			end

			inGridBand50.enteredAtMs = nil

			inGridBand50.currentContinuousMs = 0
			inGridBand50.pendingContinuity = false
		end
	end

	if fullscreenBand50 == nil then
		return v7, v8
	end

	local enteredAtMs4 = fullscreenBand50.enteredAtMs
	local currentContinuousMs4 = fullscreenBand50.currentContinuousMs

	if currentContinuousMs4 == nil then
		if enteredAtMs4 ~= nil then
			local v11 = assert(nil, "image band requires an end timestamp") - enteredAtMs4
			fullscreenBand50.cumulativeMs += v11

			if fullscreenBand50.maxContinuousMs < v11 then
				fullscreenBand50.maxContinuousMs = v11
			end

			fullscreenBand50.enteredAtMs = nil
		end
	elseif enteredAtMs4 ~= nil or fullscreenBand50.pendingContinuity then
		fullscreenBand50.cumulativeMs += currentContinuousMs4

		if fullscreenBand50.maxContinuousMs < currentContinuousMs4 then
			fullscreenBand50.maxContinuousMs = currentContinuousMs4
		end

		fullscreenBand50.enteredAtMs = nil

		fullscreenBand50.currentContinuousMs = 0
		fullscreenBand50.pendingContinuity = false
	end

	return v7, v8
end

function class:_finalize_deprecated(viewabilitySessionEndTimestampMs)
	assert(not self._finalized, "finalize called more than once on the same session")
	self._finalized = true

	self:_accumulate(viewabilitySessionEndTimestampMs, self._lastRatio, self._latchedGeometry)
	local band30 = self._band30
	local enteredAtMs = band30.enteredAtMs
	local currentContinuousMs = band30.currentContinuousMs

	if currentContinuousMs == nil then
		if enteredAtMs ~= nil then
			local v7 = assert(viewabilitySessionEndTimestampMs, "image band requires an end timestamp") - enteredAtMs
			band30.cumulativeMs += v7

			if band30.maxContinuousMs < v7 then
				band30.maxContinuousMs = v7
			end

			band30.enteredAtMs = nil
		end
	elseif enteredAtMs ~= nil or band30.pendingContinuity then
		band30.cumulativeMs += currentContinuousMs

		if band30.maxContinuousMs < currentContinuousMs then
			band30.maxContinuousMs = currentContinuousMs
		end

		band30.enteredAtMs = nil

		band30.currentContinuousMs = 0
		band30.pendingContinuity = false
	end

	local band50 = self._band50
	local enteredAtMs2 = band50.enteredAtMs
	local currentContinuousMs2 = band50.currentContinuousMs

	if currentContinuousMs2 == nil then
		if enteredAtMs2 ~= nil then
			local v7 = assert(viewabilitySessionEndTimestampMs, "image band requires an end timestamp") - enteredAtMs2
			band50.cumulativeMs += v7

			if band50.maxContinuousMs < v7 then
				band50.maxContinuousMs = v7
			end

			band50.enteredAtMs = nil
		end
	elseif enteredAtMs2 ~= nil or band50.pendingContinuity then
		band50.cumulativeMs += currentContinuousMs2

		if band50.maxContinuousMs < currentContinuousMs2 then
			band50.maxContinuousMs = currentContinuousMs2
		end

		band50.enteredAtMs = nil

		band50.currentContinuousMs = 0
		band50.pendingContinuity = false
	end

	local band100 = self._band100
	local enteredAtMs3 = band100.enteredAtMs
	local currentContinuousMs3 = band100.currentContinuousMs

	if currentContinuousMs3 == nil then
		if enteredAtMs3 ~= nil then
			local v7 = assert(viewabilitySessionEndTimestampMs, "image band requires an end timestamp") - enteredAtMs3
			band100.cumulativeMs += v7

			if band100.maxContinuousMs < v7 then
				band100.maxContinuousMs = v7
			end

			band100.enteredAtMs = nil
		end
	elseif enteredAtMs3 ~= nil or band100.pendingContinuity then
		band100.cumulativeMs += currentContinuousMs3

		if band100.maxContinuousMs < currentContinuousMs3 then
			band100.maxContinuousMs = currentContinuousMs3
		end

		band100.enteredAtMs = nil

		band100.currentContinuousMs = 0
		band100.pendingContinuity = false
	end

	local visibleWeightedMs = self._visibleWeightedMs
	local latchedGeometry = self._latchedGeometry
	local pausedDurationMs = self._pausedDurationMs
	local pausedAtMs = self._pausedAtMs

	if pausedAtMs ~= nil then
		assert(pausedAtMs <= viewabilitySessionEndTimestampMs, "session end precedes pause")
		pausedDurationMs += viewabilitySessionEndTimestampMs - pausedAtMs
	end

	local v8 = if latchedGeometry == nil then {
		adSize = Vector2.zero,
		viewportBounds = { min = Vector2.zero, max = Vector2.zero }
	} else {
		adSize = latchedGeometry.adSize,
		viewportBounds = {
			min = latchedGeometry.viewportBounds.min,
			max = latchedGeometry.viewportBounds.max
		}
	}
	return {
		geometry = v8,
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

function class:finalize(p2)
	if self._video == nil then
		return self:_finalize_deprecated(p2)
	end

	if self._finalized then
		return self._terminalSnapshot
	end

	local video = self._video
	local inGridBand50 = self._inGridBand50
	local fullscreenBand50 = self._fullscreenBand50
	local v7 = math.max(
		p2,
		self.startTimestampMs,
		self._lastSampleMs or self.startTimestampMs,
		self._pausedAtMs or self.startTimestampMs
	)

	if video == nil or inGridBand50 == nil or fullscreenBand50 == nil then
		local finalize_deprecated = self:_finalize_deprecated(v7)
		self._terminalSnapshot = finalize_deprecated
		return finalize_deprecated
	else
		self._finalized = true

		self:_accumulate(v7, self._lastRatio, self._latchedGeometry)
		local band30 = self._band30
		local enteredAtMs = band30.enteredAtMs
		local currentContinuousMs = band30.currentContinuousMs

		if currentContinuousMs == nil then
			if enteredAtMs ~= nil then
				local v8 = assert(nil, "image band requires an end timestamp") - enteredAtMs
				band30.cumulativeMs += v8

				if band30.maxContinuousMs < v8 then
					band30.maxContinuousMs = v8
				end

				band30.enteredAtMs = nil
			end
		elseif enteredAtMs ~= nil or band30.pendingContinuity then
			band30.cumulativeMs += currentContinuousMs

			if band30.maxContinuousMs < currentContinuousMs then
				band30.maxContinuousMs = currentContinuousMs
			end

			band30.enteredAtMs = nil

			band30.currentContinuousMs = 0
			band30.pendingContinuity = false
		end

		local band50 = self._band50
		local enteredAtMs2 = band50.enteredAtMs
		local currentContinuousMs2 = band50.currentContinuousMs

		if currentContinuousMs2 == nil then
			if enteredAtMs2 ~= nil then
				local v8 = assert(nil, "image band requires an end timestamp") - enteredAtMs2
				band50.cumulativeMs += v8

				if band50.maxContinuousMs < v8 then
					band50.maxContinuousMs = v8
				end

				band50.enteredAtMs = nil
			end
		elseif enteredAtMs2 ~= nil or band50.pendingContinuity then
			band50.cumulativeMs += currentContinuousMs2

			if band50.maxContinuousMs < currentContinuousMs2 then
				band50.maxContinuousMs = currentContinuousMs2
			end

			band50.enteredAtMs = nil

			band50.currentContinuousMs = 0
			band50.pendingContinuity = false
		end

		local band100 = self._band100
		local enteredAtMs3 = band100.enteredAtMs
		local currentContinuousMs3 = band100.currentContinuousMs

		if currentContinuousMs3 == nil then
			if enteredAtMs3 ~= nil then
				local v8 = assert(nil, "image band requires an end timestamp") - enteredAtMs3
				band100.cumulativeMs += v8

				if band100.maxContinuousMs < v8 then
					band100.maxContinuousMs = v8
				end

				band100.enteredAtMs = nil
			end
		elseif enteredAtMs3 ~= nil or band100.pendingContinuity then
			band100.cumulativeMs += currentContinuousMs3

			if band100.maxContinuousMs < currentContinuousMs3 then
				band100.maxContinuousMs = currentContinuousMs3
			end

			band100.enteredAtMs = nil

			band100.currentContinuousMs = 0
			band100.pendingContinuity = false
		end

		local enteredAtMs4 = inGridBand50.enteredAtMs
		local currentContinuousMs4 = inGridBand50.currentContinuousMs

		if currentContinuousMs4 == nil then
			if enteredAtMs4 ~= nil then
				local v8 = assert(nil, "image band requires an end timestamp") - enteredAtMs4
				inGridBand50.cumulativeMs += v8

				if inGridBand50.maxContinuousMs < v8 then
					inGridBand50.maxContinuousMs = v8
				end

				inGridBand50.enteredAtMs = nil
			end
		elseif enteredAtMs4 ~= nil or inGridBand50.pendingContinuity then
			inGridBand50.cumulativeMs += currentContinuousMs4

			if inGridBand50.maxContinuousMs < currentContinuousMs4 then
				inGridBand50.maxContinuousMs = currentContinuousMs4
			end

			inGridBand50.enteredAtMs = nil

			inGridBand50.currentContinuousMs = 0
			inGridBand50.pendingContinuity = false
		end

		local enteredAtMs5 = fullscreenBand50.enteredAtMs
		local currentContinuousMs5 = fullscreenBand50.currentContinuousMs

		if currentContinuousMs5 == nil then
			if enteredAtMs5 ~= nil then
				local v8 = assert(nil, "image band requires an end timestamp") - enteredAtMs5
				fullscreenBand50.cumulativeMs += v8

				if fullscreenBand50.maxContinuousMs < v8 then
					fullscreenBand50.maxContinuousMs = v8
				end

				fullscreenBand50.enteredAtMs = nil
			end
		elseif enteredAtMs5 ~= nil or fullscreenBand50.pendingContinuity then
			fullscreenBand50.cumulativeMs += currentContinuousMs5

			if fullscreenBand50.maxContinuousMs < currentContinuousMs5 then
				fullscreenBand50.maxContinuousMs = currentContinuousMs5
			end

			fullscreenBand50.enteredAtMs = nil

			fullscreenBand50.currentContinuousMs = 0
			fullscreenBand50.pendingContinuity = false
		end

		local visibleWeightedMs = self._visibleWeightedMs
		local latchedGeometry = self._latchedGeometry
		local pausedDurationMs = self._pausedDurationMs
		local pausedAtMs = self._pausedAtMs

		if pausedAtMs ~= nil then
			pausedDurationMs += v7 - pausedAtMs
		end

		local v9 = if latchedGeometry == nil then {
			adSize = Vector2.zero,
			viewportBounds = { min = Vector2.zero, max = Vector2.zero }
		} else copyGeometry(latchedGeometry)
		local v8 = {
			geometry = v9,
			viewabilitySessionStartTimestampMs = self.startTimestampMs,
			viewabilitySessionEndTimestampMs = v7,
			dwellDurationMs = v7 - self.startTimestampMs - pausedDurationMs,
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
		local v10 = if video.highestProgress ~= nil then video.audioOnAtEvent else nil
		v8.audioOnAtEvent = v10
		v8.cumulativeInGridViewDurationMs = inGridBand50.cumulativeMs
		v8.cumulativeFullScreenViewDurationMs = fullscreenBand50.cumulativeMs

		self._terminalSnapshot = v8
		return v8
	end
end

class.MilestoneLabels = v6
class.MilestoneDurationMs = 1000

return class
