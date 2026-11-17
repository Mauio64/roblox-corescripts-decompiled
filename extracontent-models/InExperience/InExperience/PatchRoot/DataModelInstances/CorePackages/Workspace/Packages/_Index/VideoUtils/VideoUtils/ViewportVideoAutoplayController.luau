local CollectionService = game:GetService("CollectionService")

local VideoUtils = script:FindFirstAncestor("VideoUtils")
local parent = VideoUtils.Parent

local Signals = require(parent.Signals)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local ViewportVideoAutoplayMode = require(VideoUtils.ViewportVideoAutoplayMode)
local ViewportAutoplayVideoKeyAttribute = require(VideoUtils.ViewportAutoplayVideoKeyAttribute)
local UserIntentModeAutoplayCandidateTag = require(VideoUtils.UserIntentModeAutoplayCandidateTag)
require(VideoUtils.VideoPlaybackCoordinator)
local Enums = require(VideoUtils.Analytics.Enums)
local VideoEndReason = Enums.VideoEndReason
local getIsInstanceVisible = require(VideoUtils.getIsInstanceVisible)
local ViewportAutoplayCandidateTag = require(VideoUtils.ViewportAutoplayCandidateTag)
local ViewportAutoplayHelpers = require(VideoUtils.ViewportAutoplayHelpers)
local getTileRowSpan = ViewportAutoplayHelpers.getTileRowSpan
local resolveOneByOneHeight = ViewportAutoplayHelpers.resolveOneByOneHeight
local getReadingOrderPositions = ViewportAutoplayHelpers.getReadingOrderPositions
local isTilePinnedLeft = ViewportAutoplayHelpers.isTilePinnedLeft
local computeRowAnchorOverrides = ViewportAutoplayHelpers.computeRowAnchorOverrides

local SharedFlags = require(parent.SharedFlags)
local FIntLuaAppGameTileVideoVisiblePercent = SharedFlags.FIntLuaAppGameTileVideoVisiblePercent

local SharedFlags2 = require(parent.SharedFlags)
local FIntLuaAppOneByTwoTileVideoVisiblePercent = SharedFlags2.FIntLuaAppOneByTwoTileVideoVisiblePercent
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags3.FFlagLuaAppOneByTwoHoverIdleAutoplay
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppHoverIdleAutoplayDuringScroll = SharedFlags4.FFlagLuaAppHoverIdleAutoplayDuringScroll

local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppSuppressVideoDetectorDuringScroll = SharedFlags5.FFlagLuaAppSuppressVideoDetectorDuringScroll

local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppSuppressOneByTwoVideoDetectorDuringScroll = SharedFlags6.FFlagLuaAppSuppressOneByTwoVideoDetectorDuringScroll

local SharedFlags7 = require(parent.SharedFlags)
local FFlagLuaAppSduiSuppressVideoDetectorDuringScroll = SharedFlags7.FFlagLuaAppSduiSuppressVideoDetectorDuringScroll
local SharedFlags8 = require(parent.SharedFlags)
local FFlagLuaAppTileVideoKeepPlayingOnScroll = SharedFlags8.FFlagLuaAppTileVideoKeepPlayingOnScroll
local SharedFlags9 = require(parent.SharedFlags)
local FFlagLuaAppVideoAutoplayFeedElection = SharedFlags9.FFlagLuaAppVideoAutoplayFeedElection
local SharedFlags10 = require(parent.SharedFlags)
local FFlagMobileGameJoinCardVideo = SharedFlags10.FFlagMobileGameJoinCardVideo

local SharedFlags11 = require(parent.SharedFlags)
local FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback = SharedFlags11.FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback
local FFlagLuaAppVideoAutoplayElectOnNewCandidate = require(script.Parent.FFlagLuaAppVideoAutoplayElectOnNewCandidate)

local defineFastInt = game:DefineFastInt("LuaAppVideoAutoplayMaxDistanceToWinnerLinePercent", 50)

local defineFastInt2 = game:DefineFastInt("LuaAppVideoAutoplayScrollUpdateIntervalMs", 100)

local v = {
	instance = nil,
	shouldUseDwell = true,
	isUserIntentWinner = not FFlagLuaAppOneByTwoHoverIdleAutoplay and nil
}

local function winnerStateEquals(data, data2): boolean
	return data.instance == data2.instance
		and data.shouldUseDwell == data2.shouldUseDwell
		and (not FFlagLuaAppOneByTwoHoverIdleAutoplay or data.isUserIntentWinner == data2.isUserIntentWinner)
end

local function shouldSuppressReelection(p: string?) -- 1 equivalent call inferred from this helper
	return p == VideoEndReason.TileClicked
		or p == VideoEndReason.ExperienceLaunched
		or p == VideoEndReason.AppBackgrounded
		or FFlagMobileGameJoinCardVideo and p == VideoEndReason.OverlayTakeover
end

local function reportCandidateOverlap(p, data, absolutePositionX: number)
	DiscoveryEventErrorLogger.reportError(
		"ViewportAutoplayCandidateOverlap",
		"Two visible autoplay candidates share identical reading-order position and AbsolutePosition.X",
		{
			candidateA = p.Name,
			candidateB = data.Name,
			absolutePositionX = absolutePositionX,
			absolutePositionY = data.AbsolutePosition.Y,
			absoluteSizeX = data.AbsoluteSize.X,
			absoluteSizeY = data.AbsoluteSize.Y
		}
	)
end

local ViewportVideoAutoplayController = {}
ViewportVideoAutoplayController.__index = ViewportVideoAutoplayController

function ViewportVideoAutoplayController:new(flag: boolean?, flag2: boolean?, p)
	local signal, setWinnerState = Signals.createSignal(v, winnerStateEquals)
	local getDetectorsUnmounted, setDetectorsUnmounted

	if FFlagLuaAppSduiSuppressVideoDetectorDuringScroll then
		getDetectorsUnmounted, setDetectorsUnmounted = Signals.createSignal(false)
	end

	local v2 = {
		coordinator = self,
		mode = nil,
		isScrolling = false,
		pendingUpdateTask = nil,
		pendingAdsUpdateTask = nil,
		viewPortBounds = nil,
		feedScopeRef = nil,
		winnerLineOffsetFromTopBarPx = 0,
		preferTallestWinner = nil,
		electOnNewCandidate = nil,
		playedVideoKeys = 0,
		suppressDetectorsDuringScroll = 0,
		getWinnerState = 0,
		setWinnerState = 0,
		adsPlaybackCoordinatorInfo = nil,
		isResettingPairedPlayback = 0,
		getDetectorsUnmounted = 0,
		setDetectorsUnmounted = 0
	}
	local mode

	if FFlagLuaAppOneByTwoHoverIdleAutoplay then
		mode = p
	end

	v2.mode = mode
	local preferTallestWinner

	if FFlagLuaAppVideoAutoplayFeedElection then
		preferTallestWinner = flag == true
	else
		preferTallestWinner = false
	end

	v2.preferTallestWinner = preferTallestWinner
	local electOnNewCandidate

	if FFlagLuaAppVideoAutoplayFeedElection then
		electOnNewCandidate = flag2 == true
	else
		electOnNewCandidate = false
	end

	v2.electOnNewCandidate = electOnNewCandidate
	v2.playedVideoKeys = FFlagLuaAppOneByTwoHoverIdleAutoplay and {} or nil
	v2.suppressDetectorsDuringScroll = not (FFlagLuaAppSuppressVideoDetectorDuringScroll or FFlagLuaAppSduiSuppressVideoDetectorDuringScroll)
		and nil

	v2.getWinnerState = signal
	v2.setWinnerState = setWinnerState

	v2.isResettingPairedPlayback = not FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback and nil

	if not FFlagLuaAppSduiSuppressVideoDetectorDuringScroll then
		getDetectorsUnmounted = nil
	end

	v2.getDetectorsUnmounted = getDetectorsUnmounted

	if not FFlagLuaAppSduiSuppressVideoDetectorDuringScroll then
		setDetectorsUnmounted = nil
	end

	v2.setDetectorsUnmounted = setDetectorsUnmounted
	local object = setmetatable(v2, ViewportVideoAutoplayController)

	if FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
		function self.onPlaybackReset(p2: string, p3: string?)
			object:_resetPairedPlayback(self, p2, p3)
		end
	end

	if FFlagLuaAppOneByTwoHoverIdleAutoplay and p == ViewportVideoAutoplayMode.UserIntentWithSelectiveAutoplay then
		object.playbackChangedConnection = self.changed:connect(function(p2: string?, p3: string?)
			local instance = object.getWinnerState(false).instance
			local attribute

			if instance then
				attribute = instance:GetAttribute(ViewportAutoplayVideoKeyAttribute)
			end

			if p2 == nil then
				if instance ~= nil then
					object.setWinnerState(v)
				end

				if not shouldSuppressReelection(p3) then -- inferred equivalent call
					object:scheduleUpdateWinner("Y", nil, false)
					return
				end

				object:_cancelPendingUpdate()
				object:_cancelScrollUpdate()
			elseif attribute ~= p2 then
				object.setWinnerState(v)
			end
		end)
	end

	return object
end

function ViewportVideoAutoplayController:isUserIntentWithSelectiveAutoplay(): boolean
	return self.mode == ViewportVideoAutoplayMode.UserIntentWithSelectiveAutoplay
end

function ViewportVideoAutoplayController:setCandidateUserIntent(currentUserIntentCandidate, flag: boolean)
	if not self:isUserIntentWithSelectiveAutoplay() then
		return
	end

	if flag then
		if self.currentUserIntentCandidate == currentUserIntentCandidate then
			return
		end

		self.currentUserIntentCandidate = currentUserIntentCandidate
	elseif self.currentUserIntentCandidate == currentUserIntentCandidate then
		self.currentUserIntentCandidate = nil
	else
		return
	end

	if self.isScrolling and not FFlagLuaAppHoverIdleAutoplayDuringScroll then
		self:_scheduleScrollUpdate()
	else
		self:scheduleUpdateWinner("Y", nil, false)
	end
end

function ViewportVideoAutoplayController:clearUserIntentCandidate()
	self.currentUserIntentCandidate = nil
end

function ViewportVideoAutoplayController:requestWinnerPlayback(instance, callback)
	local winnerState = self.getWinnerState(false)

	if winnerState.instance ~= instance then
		return
	end

	if not self:isUserIntentWithSelectiveAutoplay() then
		callback(winnerState.shouldUseDwell)
		return
	end

	if winnerState.isUserIntentWinner then
		callback(false)
		return
	end

	local attribute = instance:GetAttribute(ViewportAutoplayVideoKeyAttribute)

	if typeof(attribute) ~= "string" or self.playedVideoKeys[attribute] or self.coordinator.playingVideoKey ~= nil then
		return
	end

	callback(false)
end

function ViewportVideoAutoplayController:onVideoCompleted(instance)
	if not self:isUserIntentWithSelectiveAutoplay() then
		return
	end

	local attribute = instance:GetAttribute(ViewportAutoplayVideoKeyAttribute)

	if
		typeof(attribute) ~= "string"
		or self.coordinator.playingVideoKey ~= attribute
		or self.currentUserIntentCandidate == instance
	then
		return
	end

	self.playedVideoKeys[attribute] = true
	self.coordinator:reset(VideoEndReason.Completed)
end

function ViewportVideoAutoplayController.getAdsPlaybackCoordinator(p)
	local adsPlaybackCoordinatorInfo = p.adsPlaybackCoordinatorInfo

	if adsPlaybackCoordinatorInfo then
		return adsPlaybackCoordinatorInfo.coordinator
	end

	return nil
end

function ViewportVideoAutoplayController.getWinnerStateForCoordinator(p, p2)
	local adsPlaybackCoordinatorInfo = p.adsPlaybackCoordinatorInfo

	if adsPlaybackCoordinatorInfo and adsPlaybackCoordinatorInfo.coordinator == p2 then
		return adsPlaybackCoordinatorInfo.getWinnerState
	end

	return p.getWinnerState
end

function ViewportVideoAutoplayController.completeAdsPlayback(p, p2, p3: string)
	local adsPlaybackCoordinatorInfo = p.adsPlaybackCoordinatorInfo

	if not adsPlaybackCoordinatorInfo then
		return
	end

	adsPlaybackCoordinatorInfo.completedVideoKeys[p3] = true
	adsPlaybackCoordinatorInfo.handedOffInstances[p2] = true

	if adsPlaybackCoordinatorInfo.getWinnerState(false).instance == p2 then
		adsPlaybackCoordinatorInfo.coordinator:reset(VideoEndReason.Completed)
		adsPlaybackCoordinatorInfo.setWinnerState({ instance = nil, shouldUseDwell = false })
	end
end

function ViewportVideoAutoplayController:_consumeAdsHandoff(p): boolean
	local adsPlaybackCoordinatorInfo = self.adsPlaybackCoordinatorInfo

	if adsPlaybackCoordinatorInfo and adsPlaybackCoordinatorInfo.handedOffInstances[p] then
		adsPlaybackCoordinatorInfo.handedOffInstances[p] = nil
		return true
	end

	return false
end

function ViewportVideoAutoplayController.hasCompletedAdsPlayback(p, p2: string): boolean
	local adsPlaybackCoordinatorInfo = p.adsPlaybackCoordinatorInfo
	return adsPlaybackCoordinatorInfo ~= nil and adsPlaybackCoordinatorInfo.completedVideoKeys[p2] == true
end

function ViewportVideoAutoplayController:attachAdsPlaybackCoordinator(coordinator, candidateTag: string)
	if self.adsPlaybackCoordinatorInfo then
		return
	end

	local signal, setWinnerState = Signals.createSignal(v, winnerStateEquals)
	self.adsPlaybackCoordinatorInfo = {
		coordinator = coordinator,
		candidateTag = candidateTag,
		getWinnerState = signal,
		setWinnerState = setWinnerState,
		completedVideoKeys = {},
		handedOffInstances = setmetatable({}, { __mode = "k" })
	}

	function coordinator.onPlaybackReset(p: string, p2: string?)
		self:_resetPairedPlayback(coordinator, p, p2)
	end
end

function ViewportVideoAutoplayController:_hasUsableViewportBounds(): boolean
	if not self.viewPortBounds then
		return false
	end

	return self.viewPortBounds.max.X > self.viewPortBounds.min.X
		and self.viewPortBounds.max.Y > self.viewPortBounds.min.Y
end

function ViewportVideoAutoplayController:_maybeScheduleInitialWinnerUpdate()
	if self.getWinnerState(false).instance ~= nil or self.isScrolling or not self:_hasUsableViewportBounds() then
		return
	end

	if FFlagLuaAppVideoAutoplayFeedElection then
		self:scheduleUpdateWinner("Y", nil, true, true)
	else
		self:scheduleUpdateWinner("Y", nil, true)
	end
end

function ViewportVideoAutoplayController:onCandidateRegistered(instance)
	if FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback and self:_consumeAdsHandoff(instance) then
		return
	end

	local current

	if self.feedScopeRef then
		current = self.feedScopeRef.current
	end

	if
		not (current and instance:IsDescendantOf(current))
		or self.isScrolling
		or not self:_hasUsableViewportBounds()
	then
		return
	end

	if FFlagLuaAppOneByTwoHoverIdleAutoplay and self:isUserIntentWithSelectiveAutoplay() then
		self:scheduleUpdateWinner("Y", nil, false)
		return
	end

	if self.coordinator.playingVideoKey ~= nil then
		return
	end

	if not FFlagLuaAppVideoAutoplayFeedElection then
		self:scheduleUpdateWinner("Y", nil, true)
		return
	end

	if self.getWinnerState(false).instance == nil then
		self:_maybeScheduleInitialWinnerUpdate()
		return
	end

	if self.pendingUpdateTask ~= nil then
		return
	end

	self.pendingUpdateTask = task.defer(function()
		self.pendingUpdateTask = nil

		if self.isScrolling or self.coordinator.playingVideoKey ~= nil then
			return
		end

		self:_updateWinner("Y", nil, true)
	end)
end

function ViewportVideoAutoplayController:forceScheduleInitialWinnerUpdate()
	self:_cancelPendingUpdate()

	if FFlagLuaAppVideoAutoplayFeedElection then
		self:scheduleUpdateWinner("Y", nil, true, true)
	else
		self:scheduleUpdateWinner("Y", nil, true)
	end
end

function ViewportVideoAutoplayController:setViewPortBounds(viewPortBounds)
	self.viewPortBounds = viewPortBounds

	self:_maybeScheduleInitialWinnerUpdate()

	local winnerState = self.getWinnerState(false)
	local instance = winnerState.instance

	if instance ~= nil and not self.isScrolling and self:_hasUsableViewportBounds() then
		self:_cancelPendingUpdate()

		local isUserIntentWinner = nil
		local instance2

		if FFlagLuaAppOneByTwoHoverIdleAutoplay and self:isUserIntentWithSelectiveAutoplay() then
			instance2, isUserIntentWinner = self:_selectUserIntentOrAutoplayWinner("Y", nil)
		else
			instance2 = self:_selectWinner("Y", nil)
		end

		local shouldUseDwell = winnerState.shouldUseDwell

		if instance2 ~= instance then
			self.coordinator:reset(VideoEndReason.ViewportResized)
			shouldUseDwell = true
		end

		local setWinnerState = self.setWinnerState

		if not (FFlagLuaAppOneByTwoHoverIdleAutoplay and self:isUserIntentWithSelectiveAutoplay()) then
			isUserIntentWinner = nil
		end

		setWinnerState({
			instance = instance2,
			shouldUseDwell = shouldUseDwell,
			isUserIntentWinner = isUserIntentWinner
		})
	end

	if FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
		self:_refreshAdsWinnerForViewportChange()
	end
end

function ViewportVideoAutoplayController:setWinnerLineOffsetFromTopBarPx(winnerLineOffsetFromTopBarPx: number)
	self.winnerLineOffsetFromTopBarPx = winnerLineOffsetFromTopBarPx
end

function ViewportVideoAutoplayController:setSuppressDetectorsDuringScroll(suppressDetectorsDuringScroll: boolean)
	self.suppressDetectorsDuringScroll = suppressDetectorsDuringScroll
end

function ViewportVideoAutoplayController:setFeedScopeRef(feedScopeRef)
	self.feedScopeRef = feedScopeRef

	self:_maybeScheduleInitialWinnerUpdate()
end

function ViewportVideoAutoplayController:_cancelPendingUpdate()
	if self.pendingUpdateTask ~= nil then
		task.cancel(self.pendingUpdateTask)
		self.pendingUpdateTask = nil
	end
end

function ViewportVideoAutoplayController:_cancelPendingAdsUpdate()
	if self.pendingAdsUpdateTask ~= nil then
		task.cancel(self.pendingAdsUpdateTask)
		self.pendingAdsUpdateTask = nil
	end
end

function ViewportVideoAutoplayController:_deferApplyAdsWinner()
	self:_cancelPendingAdsUpdate()
	self.pendingAdsUpdateTask = task.defer(function()
		self.pendingAdsUpdateTask = nil

		if self.isScrolling or not self.adsPlaybackCoordinatorInfo then
			return
		end

		self:_applyAdsWinner(true, VideoEndReason.ExitViewport)
	end)
end

function ViewportVideoAutoplayController:_cancelScrollUpdate()
	if self.scrollUpdateTask ~= nil then
		task.cancel(self.scrollUpdateTask)
		self.scrollUpdateTask = nil
	end
end

function ViewportVideoAutoplayController:_scheduleScrollUpdate()
	if self.scrollUpdateTask ~= nil or not (self.isScrolling and self:isUserIntentWithSelectiveAutoplay()) then
		return
	end

	self.scrollUpdateTask = task.delay(defineFastInt2 / 1000, function()
		self.scrollUpdateTask = nil

		if not self.isScrolling then
			return
		end

		self:_updateWinner("Y", nil, false)

		if FFlagLuaAppHoverIdleAutoplayDuringScroll then
			self:_scheduleScrollUpdate()
		end
	end)
end

function ViewportVideoAutoplayController:onScrollStart()
	self:_cancelPendingUpdate()
	self.isScrolling = true

	if FFlagLuaAppOneByTwoHoverIdleAutoplay and self:isUserIntentWithSelectiveAutoplay() then
		if FFlagLuaAppHoverIdleAutoplayDuringScroll then
			self:_scheduleScrollUpdate()
		end
	elseif
		FFlagLuaAppTileVideoKeepPlayingOnScroll
		or (FFlagLuaAppSuppressVideoDetectorDuringScroll or FFlagLuaAppSduiSuppressVideoDetectorDuringScroll)
		and self.suppressDetectorsDuringScroll
	then
		if
			(FFlagLuaAppSuppressVideoDetectorDuringScroll or FFlagLuaAppSduiSuppressVideoDetectorDuringScroll)
			and self.suppressDetectorsDuringScroll
		then
			self.coordinator:cancelPendingDwells()
			local adsPlaybackCoordinatorInfo = self.adsPlaybackCoordinatorInfo

			if
				FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback
				and FFlagLuaAppSuppressOneByTwoVideoDetectorDuringScroll
				and adsPlaybackCoordinatorInfo
			then
				adsPlaybackCoordinatorInfo.coordinator:cancelPendingDwells()
			end
		end
	else
		self.coordinator:reset(VideoEndReason.ScrollStart)
		self.setWinnerState({ instance = nil, shouldUseDwell = false })

		if FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
			self:_resetAdsPlayback(VideoEndReason.ScrollStart)
		end
	end
end

function ViewportVideoAutoplayController:onScrollSettled(p: string, _: number, p2)
	self:_cancelPendingUpdate()
	self.isScrolling = false

	if FFlagLuaAppOneByTwoHoverIdleAutoplay then
		self:_cancelScrollUpdate()
	end

	if FFlagLuaAppOneByTwoHoverIdleAutoplay and self:isUserIntentWithSelectiveAutoplay() then
		self:_updateWinner(p, p2, false)
	elseif
		FFlagLuaAppTileVideoKeepPlayingOnScroll
		or (FFlagLuaAppSuppressVideoDetectorDuringScroll or FFlagLuaAppSduiSuppressVideoDetectorDuringScroll)
		and self.suppressDetectorsDuringScroll
	then
		local instance = self.getWinnerState(false).instance
		local winner = self:_selectWinner(p, p2)

		if
			(FFlagLuaAppSuppressVideoDetectorDuringScroll or FFlagLuaAppSduiSuppressVideoDetectorDuringScroll)
			and self.suppressDetectorsDuringScroll
			and winner == nil
			and instance ~= nil
		then
			self.pendingUpdateTask = task.defer(function()
				self.pendingUpdateTask = nil

				if self.isScrolling then
					return
				end

				local winner2 = self:_selectWinner(p, p2)
				local instance2 = self.getWinnerState(false).instance

				if winner2 ~= instance2 and instance2 ~= nil then
					self.coordinator:reset(VideoEndReason.ScrollSettled)
				end

				self.setWinnerState({ instance = winner2, shouldUseDwell = false })

				if FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
					self:_applyAdsWinner(false, VideoEndReason.ScrollSettled)
				end
			end)
			return
		end

		if instance ~= winner and instance ~= nil then
			self.coordinator:reset(VideoEndReason.ScrollSettled)
		end

		self.setWinnerState({ instance = winner, shouldUseDwell = false })

		if FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
			self:_applyAdsWinner(false, VideoEndReason.ScrollSettled)
		end
	else
		self:_updateWinner(p, p2, false)
	end
end

function ViewportVideoAutoplayController:_resetPairedPlayback(p, p2: string, p3: string?)
	if
		self.isResettingPairedPlayback
		or p2 ~= VideoEndReason.TileClicked
		and p2 ~= VideoEndReason.ExperienceLaunched
		and (not FFlagMobileGameJoinCardVideo or p2 ~= VideoEndReason.OverlayTakeover)
	then
		return
	end

	self.isResettingPairedPlayback = true
	self:_cancelPendingUpdate()
	self:_cancelPendingAdsUpdate()

	if p == self.coordinator then
		local adsPlaybackCoordinatorInfo = self.adsPlaybackCoordinatorInfo

		if adsPlaybackCoordinatorInfo then
			adsPlaybackCoordinatorInfo.coordinator:reset(p2, nil, p3, nil)
		end
	else
		self.coordinator:reset(p2, nil, p3, nil)
	end

	self.isResettingPairedPlayback = false
end

function ViewportVideoAutoplayController:reset(p: string)
	if FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
		self:_resetOrganicPlayback(p)
		self:_cancelPendingAdsUpdate()
		self:_resetAdsPlayback(p)
	else
		self:_cancelPendingUpdate()

		if FFlagLuaAppOneByTwoHoverIdleAutoplay then
			self:_cancelScrollUpdate()
		end

		self.isScrolling = false

		if FFlagLuaAppSduiSuppressVideoDetectorDuringScroll then
			self.setDetectorsUnmounted(false)
		end

		self.coordinator:reset(p)
		self.setWinnerState({
			instance = nil,
			shouldUseDwell = false,
			isUserIntentWinner = not (FFlagLuaAppOneByTwoHoverIdleAutoplay and self:isUserIntentWithSelectiveAutoplay()) and nil
		})
	end
end

function ViewportVideoAutoplayController:_resetOrganicPlayback(p: string)
	self:_cancelPendingUpdate()

	if FFlagLuaAppOneByTwoHoverIdleAutoplay then
		self:_cancelScrollUpdate()
	end

	self.isScrolling = false

	if FFlagLuaAppSduiSuppressVideoDetectorDuringScroll then
		self.setDetectorsUnmounted(false)
	end

	self.coordinator:reset(p)
	self.setWinnerState({
		instance = nil,
		shouldUseDwell = false,
		isUserIntentWinner = not (FFlagLuaAppOneByTwoHoverIdleAutoplay and self:isUserIntentWithSelectiveAutoplay()) and nil
	})
end

function ViewportVideoAutoplayController:resetIfActiveInstance(p, p2: string)
	if self.getWinnerState(false).instance == p then
		if FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
			self:_resetOrganicPlayback(p2)
		else
			self:reset(p2)
		end

		self:_maybeScheduleInitialWinnerUpdate()
	elseif FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
		local adsPlaybackCoordinatorInfo = self.adsPlaybackCoordinatorInfo

		if adsPlaybackCoordinatorInfo and adsPlaybackCoordinatorInfo.getWinnerState(false).instance == p then
			self:_resetAdsPlayback(p2)

			if not self.isScrolling and self:_hasUsableViewportBounds() then
				self:_deferApplyAdsWinner()
			end
		end
	end
end

function ViewportVideoAutoplayController:onAdsCandidateRegistered(instance)
	if not self.adsPlaybackCoordinatorInfo then
		return
	end

	local current

	if self.feedScopeRef then
		current = self.feedScopeRef.current
	end

	if
		not (current and instance:IsDescendantOf(current))
		or (self.isScrolling or not self:_hasUsableViewportBounds())
	then
		return
	end

	self:_deferApplyAdsWinner()
end

function ViewportVideoAutoplayController:scheduleUpdateWinner(p: string, p2, flag: boolean, flag2: boolean?)
	if self.pendingUpdateTask ~= nil then
		return
	end

	self.pendingUpdateTask = task.defer(function()
		self.pendingUpdateTask = nil

		if self.isScrolling then
			return
		end

		local v2

		if FFlagLuaAppVideoAutoplayFeedElection then
			v2 = flag2
		end

		self:_updateWinner(p, p2, flag, v2)
	end)
end

function ViewportVideoAutoplayController:_updateWinner(p: string, p2, shouldUseDwell: boolean, flag: boolean?)
	if FFlagLuaAppOneByTwoHoverIdleAutoplay and self:isUserIntentWithSelectiveAutoplay() then
		local winnerState = self.getWinnerState(false)
		local instance = winnerState.instance
		local userIntentOrAutoplayWinner, isUserIntentWinner = self:_selectUserIntentOrAutoplayWinner(p, p2, flag)

		if userIntentOrAutoplayWinner == instance and isUserIntentWinner == winnerState.isUserIntentWinner then
			return
		end

		local playingVideoKey = self.coordinator.playingVideoKey
		local attribute

		if userIntentOrAutoplayWinner then
			attribute = userIntentOrAutoplayWinner:GetAttribute(ViewportAutoplayVideoKeyAttribute)
		end

		local attribute2

		if instance then
			attribute2 = instance:GetAttribute(ViewportAutoplayVideoKeyAttribute)
		end

		if
			playingVideoKey ~= nil
			and attribute ~= playingVideoKey
			and (isUserIntentWinner or attribute2 == playingVideoKey)
		then
			local v2

			if instance == nil then
				v2 = false
			else
				v2 = CollectionService:HasTag(instance, UserIntentModeAutoplayCandidateTag)
			end

			local v3

			if isUserIntentWinner then
				v3 = VideoEndReason.HoverTakeover
			elseif instance and (not v2 or typeof(attribute2) == "string" and self.playedVideoKeys[attribute2]) then
				v3 = VideoEndReason.Unhovered
			else
				v3 = VideoEndReason.ExitViewport
			end

			self.coordinator:reset(v3)
		end

		self.setWinnerState({
			instance = userIntentOrAutoplayWinner,
			shouldUseDwell = false,
			isUserIntentWinner = isUserIntentWinner
		})
	elseif FFlagLuaAppVideoAutoplayFeedElection then
		local instance = self.getWinnerState(false).instance

		local winner = self:_selectWinner(p, p2, flag)

		if
			(self.electOnNewCandidate or FFlagLuaAppVideoAutoplayElectOnNewCandidate)
			and instance ~= nil
			and winner ~= instance
		then
			self.coordinator:reset(VideoEndReason.ExitViewport)
		end

		self.setWinnerState({ instance = winner, shouldUseDwell = shouldUseDwell })

		if FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
			self:_applyAdsWinner(shouldUseDwell, VideoEndReason.ExitViewport)
		end
	else
		local winner = self:_selectWinner(p, p2)
		self.setWinnerState({ instance = winner, shouldUseDwell = shouldUseDwell })

		if FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
			self:_applyAdsWinner(shouldUseDwell, VideoEndReason.ExitViewport)
		end
	end
end

function ViewportVideoAutoplayController:_resetAdsPlayback(p: string)
	local adsPlaybackCoordinatorInfo = self.adsPlaybackCoordinatorInfo

	if not adsPlaybackCoordinatorInfo then
		return
	end

	adsPlaybackCoordinatorInfo.coordinator:reset(p)
	adsPlaybackCoordinatorInfo.setWinnerState({ instance = nil, shouldUseDwell = false })
end

function ViewportVideoAutoplayController:_refreshAdsWinnerForViewportChange()
	local adsPlaybackCoordinatorInfo = self.adsPlaybackCoordinatorInfo

	if not adsPlaybackCoordinatorInfo or self.isScrolling or not self:_hasUsableViewportBounds() then
		return
	end

	local winnerState = adsPlaybackCoordinatorInfo.getWinnerState(false)
	local adsWinner = self:_selectAdsWinner()
	local shouldUseDwell = winnerState.shouldUseDwell

	if adsWinner ~= winnerState.instance and winnerState.instance ~= nil then
		adsPlaybackCoordinatorInfo.coordinator:reset(VideoEndReason.ViewportResized)
		shouldUseDwell = true
	end

	adsPlaybackCoordinatorInfo.setWinnerState({
		instance = adsWinner,
		shouldUseDwell = shouldUseDwell
	})
end

function ViewportVideoAutoplayController:_applyAdsWinner(shouldUseDwell: boolean, p: string)
	local adsPlaybackCoordinatorInfo = self.adsPlaybackCoordinatorInfo

	if not adsPlaybackCoordinatorInfo then
		return
	end

	local instance = adsPlaybackCoordinatorInfo.getWinnerState(false).instance
	local adsWinner = self:_selectAdsWinner()

	if adsWinner ~= instance and instance ~= nil then
		adsPlaybackCoordinatorInfo.coordinator:reset(p)
	end

	adsPlaybackCoordinatorInfo.setWinnerState({
		instance = adsWinner,
		shouldUseDwell = shouldUseDwell
	})
end

function ViewportVideoAutoplayController:_selectAdsWinner()
	local adsPlaybackCoordinatorInfo = self.adsPlaybackCoordinatorInfo
	local viewPortBounds = self.viewPortBounds
	local current

	if self.feedScopeRef then
		current = self.feedScopeRef.current
	end

	if not (adsPlaybackCoordinatorInfo and viewPortBounds and current) then
		return nil
	end

	local v2 = viewPortBounds.min.Y + self.winnerLineOffsetFromTopBarPx
	local v3 = math.max(viewPortBounds.max.X - viewPortBounds.min.X, 1)
	local v4 = 1e999
	local v5 = 1e999
	local v6 = false
	local v7 = nil

	for _, guiObject in CollectionService:GetTagged(adsPlaybackCoordinatorInfo.candidateTag) do
		if not (guiObject:IsA("GuiObject") and guiObject:IsDescendantOf(current) and getIsInstanceVisible(
			guiObject,
			viewPortBounds,
			FIntLuaAppOneByTwoTileVideoVisiblePercent
		)) then
			continue
		end

		local x = guiObject.AbsolutePosition.X
		local v8 = math.abs(guiObject.AbsolutePosition.Y + x / v3 * guiObject.AbsoluteSize.Y - v2)
		local flag = false

		if v8 < v4 or v8 == v4 and x < v5 then
			flag = true
		elseif v8 == v4 and x == v5 and not v6 and v7 then
			reportCandidateOverlap(v7, guiObject, x)
			v6 = true
		end

		if not flag then
			continue
		end

		v7 = guiObject
		v5 = x
		v4 = v8
	end

	return v7
end

function ViewportVideoAutoplayController:_selectUserIntentOrAutoplayWinner(p: string, p2, flag: boolean?)
	local userIntentWinner = self:_selectUserIntentWinner()

	if userIntentWinner then
		return userIntentWinner, true
	end

	local playingVideoKey = self.coordinator.playingVideoKey

	if playingVideoKey ~= nil then
		return self:_selectCurrentIdleWinner(playingVideoKey), false
	end

	if self.isScrolling and not FFlagLuaAppHoverIdleAutoplayDuringScroll then
		return nil, false
	end

	return self:_selectWinner(p, p2, flag, UserIntentModeAutoplayCandidateTag, true), false
end

function ViewportVideoAutoplayController:_selectUserIntentWinner()
	local currentUserIntentCandidate = self.currentUserIntentCandidate
	local current

	if self.feedScopeRef then
		current = self.feedScopeRef.current
	end

	if
		currentUserIntentCandidate == nil
		or current == nil
		or not (currentUserIntentCandidate:IsDescendantOf(current) and CollectionService:HasTag(
			currentUserIntentCandidate,
			ViewportAutoplayCandidateTag
		))
	then
		return nil
	end

	return currentUserIntentCandidate
end

function ViewportVideoAutoplayController:_selectCurrentIdleWinner(p: string)
	local current

	if self.feedScopeRef then
		current = self.feedScopeRef.current
	end

	local viewPortBounds = self.viewPortBounds

	if current == nil or viewPortBounds == nil then
		return nil
	end

	for _, guiObject in CollectionService:GetTagged(UserIntentModeAutoplayCandidateTag) do
		if
			not guiObject:IsA("GuiObject")
			or guiObject:GetAttribute(ViewportAutoplayVideoKeyAttribute) ~= p
			or self.playedVideoKeys[p]
			or not guiObject:IsDescendantOf(current)
		then
			continue
		end

		local v2

		if getTileRowSpan(guiObject) == 2 and not self.preferTallestWinner then
			v2 = FIntLuaAppOneByTwoTileVideoVisiblePercent
		else
			v2 = FIntLuaAppGameTileVideoVisiblePercent
		end

		if getIsInstanceVisible(guiObject, viewPortBounds, v2) then
			return guiObject
		end
	end

	return nil
end

function ViewportVideoAutoplayController:_isCandidateEligibleForSelection(instance, flag: boolean?): boolean
	if not flag then
		return true
	end

	local attribute = instance:GetAttribute(ViewportAutoplayVideoKeyAttribute)
	return typeof(attribute) == "string" and not self.playedVideoKeys[attribute]
end

function ViewportVideoAutoplayController:_selectWinner(p: string, p2, flag: boolean?, p3: string?, flag2: boolean?)
	local viewPortBounds = self.viewPortBounds

	if not viewPortBounds then
		return nil
	end

	local current = nil

	if p == "X" and p2 then
		current = p2.current
	elseif self.feedScopeRef then
		current = self.feedScopeRef.current
	end

	if not current then
		return nil
	end

	local v2 = viewPortBounds.min.Y + self.winnerLineOffsetFromTopBarPx
	local v3 = math.max(viewPortBounds.max.X - viewPortBounds.min.X, 1)

	local v4 = (viewPortBounds.max.Y - viewPortBounds.min.Y) * (defineFastInt / 100)

	local v5 = nil
	local v6 = 1e999
	local v7 = 1e999
	local v8 = false
	local v9, v10

	if self.preferTallestWinner then
		v9 = -1
		v10 = 1e999
	end

	local function shouldReplaceByLeftmostX(absolutePositionX: number, p4): boolean -- 3 equivalent calls inferred from this helper
		if absolutePositionX < v7 then
			return true
		end

		if absolutePositionX == v7 and not v8 and v5 then
			v8 = true
			reportCandidateOverlap(v5, p4, absolutePositionX)
		end

		return false
	end

	local function considerFoldXCandidate(guiObject, x: number, p4: number) -- 3 equivalent calls inferred from this helper
		local v11 = math.abs(p4 - v2)

		if v11 < v6 then
			v6 = v11
			v7 = x
			v5 = guiObject
		elseif v11 == v6 and shouldReplaceByLeftmostX(x, guiObject) then -- inferred equivalent call
			v6 = v11
			v7 = x
			v5 = guiObject
		end
	end

	local tagged = CollectionService:GetTagged(FFlagLuaAppOneByTwoHoverIdleAutoplay and p3 or ViewportAutoplayCandidateTag)

	local guiObjects = {}

	for _, guiObject in tagged do
		if not (guiObject:IsA("GuiObject") and guiObject:IsDescendantOf(current) and (not FFlagLuaAppOneByTwoHoverIdleAutoplay or self:_isCandidateEligibleForSelection(guiObject, flag2))) then
			continue
		end

		table.insert(guiObjects, guiObject)
	end

	local v11 = computeRowAnchorOverrides(guiObjects, v3)

	for _, guiObject in tagged do
		if not (guiObject:IsA("GuiObject") and guiObject:IsDescendantOf(current) and (not FFlagLuaAppOneByTwoHoverIdleAutoplay or self:_isCandidateEligibleForSelection(guiObject, flag2))) then
			continue
		end

		local v12

		if getTileRowSpan(guiObject) == 2 and not self.preferTallestWinner then
			v12 = FIntLuaAppOneByTwoTileVideoVisiblePercent
		else
			v12 = FIntLuaAppGameTileVideoVisiblePercent
		end

		if not getIsInstanceVisible(guiObject, viewPortBounds, v12) then
			continue
		end

		local x = guiObject.AbsolutePosition.X

		if FFlagLuaAppVideoAutoplayFeedElection and self.preferTallestWinner then
			local v13 = math.abs(math.clamp(
				v2,
				guiObject.AbsolutePosition.Y,
				guiObject.AbsolutePosition.Y + guiObject.AbsoluteSize.Y
			) - v2)

			local y = guiObject.AbsoluteSize.Y
			local v14 = math.abs(guiObject.AbsolutePosition.Y + x / v3 * y - v2)
			local v15 = false

			if v13 < v6 then
				v15 = true
			elseif v13 == v6 then
				if v9 < y then
					v15 = true
				elseif y == v9 then
					if flag then
						v15 = shouldReplaceByLeftmostX(x, guiObject) and true or false -- inferred equivalent call
					elseif v14 < v10 then
						v15 = true
					elseif v14 == v10 then
						v15 = shouldReplaceByLeftmostX(x, guiObject) and true or false -- inferred equivalent call
					end
				end
			end

			if v15 then
				v6 = v13

				v7 = x
				v5 = guiObject
				v10 = v14
				v9 = y
			end
		else
			local tileRowSpan = getTileRowSpan(guiObject)
			local v13 = v11[guiObject]

			if tileRowSpan == 2 then
				local readingOrderPositions = getReadingOrderPositions(
					guiObject,
					x,
					v3,
					2,
					(resolveOneByOneHeight(guiObject, 2))
				)

				if v13 ~= nil then
					readingOrderPositions[isTilePinnedLeft(guiObject) and 1 or 2] = v13
				end

				for _, readingOrderPosition in readingOrderPositions do
					considerFoldXCandidate(guiObject, x, readingOrderPosition) -- inferred equivalent call
				end
			elseif v13 == nil then
				considerFoldXCandidate(guiObject, x, guiObject.AbsolutePosition.Y + x / v3 * guiObject.AbsoluteSize.Y) -- inferred equivalent call
			else
				considerFoldXCandidate(guiObject, x, v13) -- inferred equivalent call
			end
		end
	end

	return if not (v4 < v6) then v5 else nil
end

return ViewportVideoAutoplayController
