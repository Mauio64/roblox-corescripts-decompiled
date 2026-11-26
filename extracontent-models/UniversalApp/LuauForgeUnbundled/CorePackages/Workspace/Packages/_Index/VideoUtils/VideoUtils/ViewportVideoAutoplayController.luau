local CollectionService = game:GetService("CollectionService")

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/Signals")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/DiscoveryUtils").DiscoveryEventErrorLogger

local ViewportVideoAutoplayMode = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/ViewportVideoAutoplayMode")
local ViewportAutoplayVideoKeyAttribute = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/ViewportAutoplayVideoKeyAttribute")
local UserIntentModeAutoplayCandidateTag = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/UserIntentModeAutoplayCandidateTag")
require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/VideoPlaybackCoordinator")
local videoEndReason = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/Analytics/Enums").VideoEndReason
local getIsInstanceVisible = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/getIsInstanceVisible")
local ViewportAutoplayCandidateTag = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/ViewportAutoplayCandidateTag")
local ViewportAutoplayHelpers = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/ViewportAutoplayHelpers")
local getTileRowSpan = ViewportAutoplayHelpers.getTileRowSpan
local resolveOneByOneHeight = ViewportAutoplayHelpers.resolveOneByOneHeight
local getReadingOrderPositions = ViewportAutoplayHelpers.getReadingOrderPositions
local isTilePinnedLeft = ViewportAutoplayHelpers.isTilePinnedLeft
local computeRowAnchorOverrides = ViewportAutoplayHelpers.computeRowAnchorOverrides

local fIntLuaAppGameTileVideoVisiblePercent = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FIntLuaAppGameTileVideoVisiblePercent

local fIntLuaAppOneByTwoTileVideoVisiblePercent = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FIntLuaAppOneByTwoTileVideoVisiblePercent
local fFlagLuaAppOneByTwoHoverIdleAutoplay = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppOneByTwoHoverIdleAutoplay
local fFlagLuaAppHoverIdleAutoplayDuringScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppHoverIdleAutoplayDuringScroll

local fFlagLuaAppSuppressVideoDetectorDuringScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppSuppressVideoDetectorDuringScroll

local fFlagLuaAppSuppressOneByTwoVideoDetectorDuringScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppSuppressOneByTwoVideoDetectorDuringScroll

local fFlagLuaAppSduiSuppressVideoDetectorDuringScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppSduiSuppressVideoDetectorDuringScroll
local fFlagLuaAppTileVideoKeepPlayingOnScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppTileVideoKeepPlayingOnScroll
local fFlagLuaAppVideoAutoplayFeedElection = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppVideoAutoplayFeedElection
local fFlagMobileGameJoinCardVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagMobileGameJoinCardVideo

local fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback
local FFlagLuaAppVideoAutoplayElectOnNewCandidate = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/FFlagLuaAppVideoAutoplayElectOnNewCandidate")

local defineFastInt = game:DefineFastInt("LuaAppVideoAutoplayMaxDistanceToWinnerLinePercent", 50)

local defineFastInt2 = game:DefineFastInt("LuaAppVideoAutoplayScrollUpdateIntervalMs", 100)

local v5 = {
	instance = nil,
	shouldUseDwell = true,
	isUserIntentWinner = if fFlagLuaAppOneByTwoHoverIdleAutoplay then false else nil
}

local function winnerStateEquals(data, data2): boolean
	return data.instance == data2.instance
		and data.shouldUseDwell == data2.shouldUseDwell
		and (not fFlagLuaAppOneByTwoHoverIdleAutoplay or data.isUserIntentWinner == data2.isUserIntentWinner)
end

local function shouldSuppressReelection(p2)
	return p2 == videoEndReason.TileClicked
		or p2 == videoEndReason.ExperienceLaunched
		or p2 == videoEndReason.AppBackgrounded
		or fFlagMobileGameJoinCardVideo and p2 == videoEndReason.OverlayTakeover
end

local function reportCandidateOverlap(p2, data, p3)
	discoveryEventErrorLogger.reportError(
		"ViewportAutoplayCandidateOverlap",
		"Two visible autoplay candidates share identical reading-order position and AbsolutePosition.X",
		{
			candidateA = p2.Name,
			candidateB = data.Name,
			absolutePositionX = p3,
			absolutePositionY = data.AbsolutePosition.Y,
			absoluteSizeX = data.AbsoluteSize.X,
			absoluteSizeY = data.AbsoluteSize.Y
		}
	)
end

local class = {}
class.__index = class

function class:new(p3, p4, p5)
	local signal, v7 = Signals.createSignal(v5, winnerStateEquals)
	local v8, v9

	if fFlagLuaAppSduiSuppressVideoDetectorDuringScroll then
		v8, v9 = Signals.createSignal(false)
	end

	local v10 = {
		coordinator = self,
		mode = if fFlagLuaAppOneByTwoHoverIdleAutoplay then p5 else nil,
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
	local v12 = if fFlagLuaAppVideoAutoplayFeedElection then p3 == true else false
	v10.preferTallestWinner = v12
	local v13 = if fFlagLuaAppVideoAutoplayFeedElection then p4 == true else false
	v10.electOnNewCandidate = v13
	v10.playedVideoKeys = fFlagLuaAppOneByTwoHoverIdleAutoplay and {} or nil
	local v14 = if fFlagLuaAppSuppressVideoDetectorDuringScroll or fFlagLuaAppSduiSuppressVideoDetectorDuringScroll then false else nil
	v10.suppressDetectorsDuringScroll = v14

	v10.getWinnerState = signal
	v10.setWinnerState = v7

	v10.isResettingPairedPlayback = if fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then false else nil

	if not fFlagLuaAppSduiSuppressVideoDetectorDuringScroll then
		v8 = nil
	end

	v10.getDetectorsUnmounted = v8

	if not fFlagLuaAppSduiSuppressVideoDetectorDuringScroll then
		v9 = nil
	end

	v10.setDetectorsUnmounted = v9
	local object = setmetatable(v10, class)

	if fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
		function self.onPlaybackReset(p6, p7)
			object:_resetPairedPlayback(self, p6, p7)
		end
	end

	if fFlagLuaAppOneByTwoHoverIdleAutoplay and p5 == ViewportVideoAutoplayMode.UserIntentWithSelectiveAutoplay then
		object.playbackChangedConnection = self.changed:connect(function(p6, p7)
			local instance = object.getWinnerState(false).instance
			local attribute = if instance then instance:GetAttribute(ViewportAutoplayVideoKeyAttribute) else nil

			if p6 == nil then
				if instance ~= nil then
					object.setWinnerState(v5)
				end

				if
					p7 ~= videoEndReason.TileClicked
					and p7 ~= videoEndReason.ExperienceLaunched
					and p7 ~= videoEndReason.AppBackgrounded
					and (not fFlagMobileGameJoinCardVideo or p7 ~= videoEndReason.OverlayTakeover)
				then
					object:scheduleUpdateWinner("Y", nil, false)
					return
				end

				object:_cancelPendingUpdate()
				object:_cancelScrollUpdate()
			elseif attribute ~= p6 then
				object.setWinnerState(v5)
			end
		end)
	end

	return object
end

function class:isUserIntentWithSelectiveAutoplay(): boolean
	return self.mode == ViewportVideoAutoplayMode.UserIntentWithSelectiveAutoplay
end

function class:setCandidateUserIntent(currentUserIntentCandidate, p2)
	if not self:isUserIntentWithSelectiveAutoplay() then
		return
	end

	if p2 then
		if self.currentUserIntentCandidate == currentUserIntentCandidate then
			return
		end

		self.currentUserIntentCandidate = currentUserIntentCandidate
	elseif self.currentUserIntentCandidate == currentUserIntentCandidate then
		self.currentUserIntentCandidate = nil
	else
		return
	end

	if self.isScrolling and not fFlagLuaAppHoverIdleAutoplayDuringScroll then
		self:_scheduleScrollUpdate()
	else
		self:scheduleUpdateWinner("Y", nil, false)
	end
end

function class:clearUserIntentCandidate()
	self.currentUserIntentCandidate = nil
end

function class:requestWinnerPlayback(instance, callback)
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

	if
		typeof(attribute) ~= "string"
		or self.playedVideoKeys[attribute]
		or self.coordinator.playingVideoKey ~= nil
	then
		return
	end

	callback(false)
end

function class:onVideoCompleted(instance)
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
	self.coordinator:reset(videoEndReason.Completed)
end

function class:getAdsPlaybackCoordinator()
	local adsPlaybackCoordinatorInfo = self.adsPlaybackCoordinatorInfo

	if adsPlaybackCoordinatorInfo then
		return adsPlaybackCoordinatorInfo.coordinator
	end

	return nil
end

function class:getWinnerStateForCoordinator(p3)
	local adsPlaybackCoordinatorInfo = self.adsPlaybackCoordinatorInfo

	if adsPlaybackCoordinatorInfo and adsPlaybackCoordinatorInfo.coordinator == p3 then
		return adsPlaybackCoordinatorInfo.getWinnerState
	end

	return self.getWinnerState
end

function class:completeAdsPlayback(p3, p4)
	local adsPlaybackCoordinatorInfo = self.adsPlaybackCoordinatorInfo

	if not adsPlaybackCoordinatorInfo then
		return
	end

	adsPlaybackCoordinatorInfo.completedVideoKeys[p4] = true
	adsPlaybackCoordinatorInfo.handedOffInstances[p3] = true

	if adsPlaybackCoordinatorInfo.getWinnerState(false).instance == p3 then
		adsPlaybackCoordinatorInfo.coordinator:reset(videoEndReason.Completed)
		adsPlaybackCoordinatorInfo.setWinnerState({
			instance = nil,
			shouldUseDwell = false
		})
	end
end

function class:_consumeAdsHandoff(p3): boolean
	local adsPlaybackCoordinatorInfo = self.adsPlaybackCoordinatorInfo

	if adsPlaybackCoordinatorInfo and adsPlaybackCoordinatorInfo.handedOffInstances[p3] then
		adsPlaybackCoordinatorInfo.handedOffInstances[p3] = nil
		return true
	end

	return false
end

function class:hasCompletedAdsPlayback(p3): boolean
	local adsPlaybackCoordinatorInfo = self.adsPlaybackCoordinatorInfo
	return adsPlaybackCoordinatorInfo ~= nil and adsPlaybackCoordinatorInfo.completedVideoKeys[p3] == true
end

function class:attachAdsPlaybackCoordinator(p2, p3)
	if self.adsPlaybackCoordinatorInfo then
		return
	end

	local signal, v7 = Signals.createSignal(v5, winnerStateEquals)
	self.adsPlaybackCoordinatorInfo = {
		coordinator = p2,
		candidateTag = p3,
		getWinnerState = signal,
		setWinnerState = v7,
		completedVideoKeys = {},
		handedOffInstances = setmetatable({}, { __mode = "k" })
	}

	function p2.onPlaybackReset(p4, p5)
		self:_resetPairedPlayback(p2, p4, p5)
	end
end

function class:_hasUsableViewportBounds(): boolean
	if not self.viewPortBounds then
		return false
	end

	return self.viewPortBounds.max.X > self.viewPortBounds.min.X
		and self.viewPortBounds.max.Y > self.viewPortBounds.min.Y
end

function class:_maybeScheduleInitialWinnerUpdate()
	if
		self.getWinnerState(false).instance ~= nil
		or self.isScrolling
		or not self:_hasUsableViewportBounds()
	then
		return
	end

	if fFlagLuaAppVideoAutoplayFeedElection then
		self:scheduleUpdateWinner("Y", nil, true, true)
	else
		self:scheduleUpdateWinner("Y", nil, true)
	end
end

function class:onCandidateRegistered(instance)
	if fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback and self:_consumeAdsHandoff(instance) then
		return
	end

	local current = if self.feedScopeRef then self.feedScopeRef.current else nil

	if
		not (current and instance:IsDescendantOf(current))
		or self.isScrolling
		or not self:_hasUsableViewportBounds()
	then
		return
	end

	if fFlagLuaAppOneByTwoHoverIdleAutoplay and self:isUserIntentWithSelectiveAutoplay() then
		self:scheduleUpdateWinner("Y", nil, false)
		return
	end

	if self.coordinator.playingVideoKey ~= nil then
		return
	end

	if not fFlagLuaAppVideoAutoplayFeedElection then
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

function class:forceScheduleInitialWinnerUpdate()
	self:_cancelPendingUpdate()

	if fFlagLuaAppVideoAutoplayFeedElection then
		self:scheduleUpdateWinner("Y", nil, true, true)
	else
		self:scheduleUpdateWinner("Y", nil, true)
	end
end

function class:setViewPortBounds(viewPortBounds)
	self.viewPortBounds = viewPortBounds

	self:_maybeScheduleInitialWinnerUpdate()

	local winnerState = self.getWinnerState(false)
	local instance = winnerState.instance

	if instance ~= nil and not self.isScrolling and self:_hasUsableViewportBounds() then
		self:_cancelPendingUpdate()

		local v7 = nil
		local v8

		if fFlagLuaAppOneByTwoHoverIdleAutoplay and self:isUserIntentWithSelectiveAutoplay() then
			v8, v7 = self:_selectUserIntentOrAutoplayWinner("Y", nil)
		else
			v8 = self:_selectWinner("Y", nil)
		end

		local v9 = winnerState.shouldUseDwell

		if v8 ~= instance then
			self.coordinator:reset(videoEndReason.ViewportResized)
			v9 = true
		end

		local setWinnerState = self.setWinnerState

		if not (fFlagLuaAppOneByTwoHoverIdleAutoplay and self:isUserIntentWithSelectiveAutoplay()) then
			v7 = nil
		end

		setWinnerState({ instance = v8, shouldUseDwell = v9, isUserIntentWinner = v7 })
	end

	if fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
		self:_refreshAdsWinnerForViewportChange()
	end
end

function class:setWinnerLineOffsetFromTopBarPx(winnerLineOffsetFromTopBarPx)
	self.winnerLineOffsetFromTopBarPx = winnerLineOffsetFromTopBarPx
end

function class:setSuppressDetectorsDuringScroll(suppressDetectorsDuringScroll)
	self.suppressDetectorsDuringScroll = suppressDetectorsDuringScroll
end

function class:setFeedScopeRef(feedScopeRef)
	self.feedScopeRef = feedScopeRef

	self:_maybeScheduleInitialWinnerUpdate()
end

function class:_cancelPendingUpdate()
	if self.pendingUpdateTask ~= nil then
		task.cancel(self.pendingUpdateTask)
		self.pendingUpdateTask = nil
	end
end

function class:_cancelPendingAdsUpdate()
	if self.pendingAdsUpdateTask ~= nil then
		task.cancel(self.pendingAdsUpdateTask)
		self.pendingAdsUpdateTask = nil
	end
end

function class:_deferApplyAdsWinner()
	self:_cancelPendingAdsUpdate()
	self.pendingAdsUpdateTask = task.defer(function()
		self.pendingAdsUpdateTask = nil

		if self.isScrolling or not self.adsPlaybackCoordinatorInfo then
			return
		end

		self:_applyAdsWinner(true, videoEndReason.ExitViewport)
	end)
end

function class:_cancelScrollUpdate()
	if self.scrollUpdateTask ~= nil then
		task.cancel(self.scrollUpdateTask)
		self.scrollUpdateTask = nil
	end
end

function class:_scheduleScrollUpdate()
	if
		self.scrollUpdateTask ~= nil
		or not (self.isScrolling and self:isUserIntentWithSelectiveAutoplay())
	then
		return
	end

	self.scrollUpdateTask = task.delay(defineFastInt2 / 1000, function()
		self.scrollUpdateTask = nil

		if not self.isScrolling then
			return
		end

		self:_updateWinner("Y", nil, false)

		if fFlagLuaAppHoverIdleAutoplayDuringScroll then
			self:_scheduleScrollUpdate()
		end
	end)
end

function class:onScrollStart()
	self:_cancelPendingUpdate()
	self.isScrolling = true

	if fFlagLuaAppOneByTwoHoverIdleAutoplay and self:isUserIntentWithSelectiveAutoplay() then
		if fFlagLuaAppHoverIdleAutoplayDuringScroll then
			self:_scheduleScrollUpdate()
		end
	elseif
		fFlagLuaAppTileVideoKeepPlayingOnScroll
		or (fFlagLuaAppSuppressVideoDetectorDuringScroll or fFlagLuaAppSduiSuppressVideoDetectorDuringScroll)
		and self.suppressDetectorsDuringScroll
	then
		if
			(fFlagLuaAppSuppressVideoDetectorDuringScroll or fFlagLuaAppSduiSuppressVideoDetectorDuringScroll)
			and self.suppressDetectorsDuringScroll
		then
			self.coordinator:cancelPendingDwells()
			local adsPlaybackCoordinatorInfo = self.adsPlaybackCoordinatorInfo

			if
				fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback
				and fFlagLuaAppSuppressOneByTwoVideoDetectorDuringScroll
				and adsPlaybackCoordinatorInfo
			then
				adsPlaybackCoordinatorInfo.coordinator:cancelPendingDwells()
			end
		end
	else
		self.coordinator:reset(videoEndReason.ScrollStart)
		self.setWinnerState({ instance = nil, shouldUseDwell = false })

		if fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
			self:_resetAdsPlayback(videoEndReason.ScrollStart)
		end
	end
end

function class:onScrollSettled(p2, p3, p4)
	self:_cancelPendingUpdate()
	self.isScrolling = false

	if fFlagLuaAppOneByTwoHoverIdleAutoplay then
		self:_cancelScrollUpdate()
	end

	if fFlagLuaAppOneByTwoHoverIdleAutoplay and self:isUserIntentWithSelectiveAutoplay() then
		self:_updateWinner(p2, p4, false)
	elseif
		fFlagLuaAppTileVideoKeepPlayingOnScroll
		or (fFlagLuaAppSuppressVideoDetectorDuringScroll or fFlagLuaAppSduiSuppressVideoDetectorDuringScroll)
		and self.suppressDetectorsDuringScroll
	then
		local instance = self.getWinnerState(false).instance
		local winner = self:_selectWinner(p2, p4)

		if
			(fFlagLuaAppSuppressVideoDetectorDuringScroll or fFlagLuaAppSduiSuppressVideoDetectorDuringScroll)
			and self.suppressDetectorsDuringScroll
			and winner == nil
			and instance ~= nil
		then
			self.pendingUpdateTask = task.defer(function()
				self.pendingUpdateTask = nil

				if self.isScrolling then
					return
				end

				local winner2 = self:_selectWinner(p2, p4)
				local instance2 = self.getWinnerState(false).instance

				if winner2 ~= instance2 and instance2 ~= nil then
					self.coordinator:reset(videoEndReason.ScrollSettled)
				end

				self.setWinnerState({ instance = winner2, shouldUseDwell = false })

				if fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
					self:_applyAdsWinner(false, videoEndReason.ScrollSettled)
				end
			end)
			return
		end

		if instance ~= winner and instance ~= nil then
			self.coordinator:reset(videoEndReason.ScrollSettled)
		end

		self.setWinnerState({ instance = winner, shouldUseDwell = false })

		if fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
			self:_applyAdsWinner(false, videoEndReason.ScrollSettled)
		end
	else
		self:_updateWinner(p2, p4, false)
	end
end

function class:_resetPairedPlayback(p2, p3, p4)
	if
		self.isResettingPairedPlayback
		or p3 ~= videoEndReason.TileClicked
		and p3 ~= videoEndReason.ExperienceLaunched
		and (not fFlagMobileGameJoinCardVideo or p3 ~= videoEndReason.OverlayTakeover)
	then
		return
	end

	self.isResettingPairedPlayback = true
	self:_cancelPendingUpdate()
	self:_cancelPendingAdsUpdate()

	if p2 == self.coordinator then
		local adsPlaybackCoordinatorInfo = self.adsPlaybackCoordinatorInfo

		if adsPlaybackCoordinatorInfo then
			adsPlaybackCoordinatorInfo.coordinator:reset(p3, nil, p4, nil)
		end
	else
		self.coordinator:reset(p3, nil, p4, nil)
	end

	self.isResettingPairedPlayback = false
end

function class:reset(p2)
	if fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
		self:_resetOrganicPlayback(p2)
		self:_cancelPendingAdsUpdate()
		self:_resetAdsPlayback(p2)
	else
		self:_cancelPendingUpdate()

		if fFlagLuaAppOneByTwoHoverIdleAutoplay then
			self:_cancelScrollUpdate()
		end

		self.isScrolling = false

		if fFlagLuaAppSduiSuppressVideoDetectorDuringScroll then
			self.setDetectorsUnmounted(false)
		end

		self.coordinator:reset(p2)
		local setWinnerState = self.setWinnerState

		local v8 = if fFlagLuaAppOneByTwoHoverIdleAutoplay and self:isUserIntentWithSelectiveAutoplay() then false else nil
		setWinnerState({
			instance = nil,
			shouldUseDwell = false,
			isUserIntentWinner = v8
		})
	end
end

function class:_resetOrganicPlayback(p2)
	self:_cancelPendingUpdate()

	if fFlagLuaAppOneByTwoHoverIdleAutoplay then
		self:_cancelScrollUpdate()
	end

	self.isScrolling = false

	if fFlagLuaAppSduiSuppressVideoDetectorDuringScroll then
		self.setDetectorsUnmounted(false)
	end

	self.coordinator:reset(p2)
	local setWinnerState = self.setWinnerState

	local v8 = if fFlagLuaAppOneByTwoHoverIdleAutoplay and self:isUserIntentWithSelectiveAutoplay() then false else nil
	setWinnerState({ instance = nil, shouldUseDwell = false, isUserIntentWinner = v8 })
end

function class:resetIfActiveInstance(p2, p3)
	if self.getWinnerState(false).instance == p2 then
		if fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
			self:_resetOrganicPlayback(p3)
		else
			self:reset(p3)
		end

		self:_maybeScheduleInitialWinnerUpdate()
	elseif fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
		local adsPlaybackCoordinatorInfo = self.adsPlaybackCoordinatorInfo

		if
			adsPlaybackCoordinatorInfo
			and adsPlaybackCoordinatorInfo.getWinnerState(false).instance == p2
		then
			self:_resetAdsPlayback(p3)

			if not self.isScrolling and self:_hasUsableViewportBounds() then
				self:_deferApplyAdsWinner()
			end
		end
	end
end

function class:onAdsCandidateRegistered(instance)
	if not self.adsPlaybackCoordinatorInfo then
		return
	end

	local current = if self.feedScopeRef then self.feedScopeRef.current else nil

	if
		not (current and instance:IsDescendantOf(current))
		or (self.isScrolling or not self:_hasUsableViewportBounds())
	then
		return
	end

	self:_deferApplyAdsWinner()
end

function class:scheduleUpdateWinner(p2, p3, p4, p5)
	if self.pendingUpdateTask ~= nil then
		return
	end

	self.pendingUpdateTask = task.defer(function()
		self.pendingUpdateTask = nil

		if self.isScrolling then
			return
		end

		self:_updateWinner(p2, p3, p4, if fFlagLuaAppVideoAutoplayFeedElection then p5 else nil)
	end)
end

function class:_updateWinner(p2, p3, p4, p5)
	if fFlagLuaAppOneByTwoHoverIdleAutoplay and self:isUserIntentWithSelectiveAutoplay() then
		local winnerState = self.getWinnerState(false)
		local instance = winnerState.instance
		local userIntentOrAutoplayWinner, v7 = self:_selectUserIntentOrAutoplayWinner(p2, p3, p5)

		if userIntentOrAutoplayWinner == instance and v7 == winnerState.isUserIntentWinner then
			return
		end

		local playingVideoKey = self.coordinator.playingVideoKey
		local attribute

		if userIntentOrAutoplayWinner then
			attribute = userIntentOrAutoplayWinner:GetAttribute(ViewportAutoplayVideoKeyAttribute)
		end

		local attribute2 = if instance then instance:GetAttribute(ViewportAutoplayVideoKeyAttribute) else nil

		if
			playingVideoKey ~= nil
			and attribute ~= playingVideoKey
			and (v7 or attribute2 == playingVideoKey)
		then
			local v8 = not (instance == nil) and CollectionService:HasTag(instance, UserIntentModeAutoplayCandidateTag)
			local v9

			if v7 then
				v9 = videoEndReason.HoverTakeover
			elseif
				instance
				and (not v8 or typeof(attribute2) == "string" and self.playedVideoKeys[attribute2])
			then
				v9 = videoEndReason.Unhovered
			else
				v9 = videoEndReason.ExitViewport
			end

			self.coordinator:reset(v9)
		end

		self.setWinnerState({
			instance = userIntentOrAutoplayWinner,
			shouldUseDwell = false,
			isUserIntentWinner = v7
		})
	elseif fFlagLuaAppVideoAutoplayFeedElection then
		local instance = self.getWinnerState(false).instance

		local winner = self:_selectWinner(p2, p3, p5)

		if (self.electOnNewCandidate or FFlagLuaAppVideoAutoplayElectOnNewCandidate) and instance ~= nil and winner ~= instance then
			self.coordinator:reset(videoEndReason.ExitViewport)
		end

		self.setWinnerState({ instance = winner, shouldUseDwell = p4 })

		if fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
			self:_applyAdsWinner(p4, videoEndReason.ExitViewport)
		end
	else
		local winner = self:_selectWinner(p2, p3)
		self.setWinnerState({ instance = winner, shouldUseDwell = p4 })

		if fFlagLuaAppVideoAutoplayOneByTwoConcurrentPlayback then
			self:_applyAdsWinner(p4, videoEndReason.ExitViewport)
		end
	end
end

function class:_resetAdsPlayback(p3)
	local adsPlaybackCoordinatorInfo = self.adsPlaybackCoordinatorInfo

	if not adsPlaybackCoordinatorInfo then
		return
	end

	adsPlaybackCoordinatorInfo.coordinator:reset(p3)
	adsPlaybackCoordinatorInfo.setWinnerState({ instance = nil, shouldUseDwell = false })
end

function class:_refreshAdsWinnerForViewportChange()
	local adsPlaybackCoordinatorInfo = self.adsPlaybackCoordinatorInfo

	if not adsPlaybackCoordinatorInfo or self.isScrolling or not self:_hasUsableViewportBounds() then
		return
	end

	local winnerState = adsPlaybackCoordinatorInfo.getWinnerState(false)
	local adsWinner = self:_selectAdsWinner()
	local v7 = winnerState.shouldUseDwell

	if adsWinner ~= winnerState.instance and winnerState.instance ~= nil then
		adsPlaybackCoordinatorInfo.coordinator:reset(videoEndReason.ViewportResized)
		v7 = true
	end

	adsPlaybackCoordinatorInfo.setWinnerState({
		instance = adsWinner,
		shouldUseDwell = v7
	})
end

function class:_applyAdsWinner(p2, p3)
	local adsPlaybackCoordinatorInfo = self.adsPlaybackCoordinatorInfo

	if not adsPlaybackCoordinatorInfo then
		return
	end

	local instance = adsPlaybackCoordinatorInfo.getWinnerState(false).instance
	local adsWinner = self:_selectAdsWinner()

	if adsWinner ~= instance and instance ~= nil then
		adsPlaybackCoordinatorInfo.coordinator:reset(p3)
	end

	adsPlaybackCoordinatorInfo.setWinnerState({
		instance = adsWinner,
		shouldUseDwell = p2
	})
end

function class:_selectAdsWinner()
	local adsPlaybackCoordinatorInfo = self.adsPlaybackCoordinatorInfo
	local viewPortBounds = self.viewPortBounds
	local current = if self.feedScopeRef then self.feedScopeRef.current else nil

	if not (adsPlaybackCoordinatorInfo and viewPortBounds and current) then
		return nil
	end

	local v7 = viewPortBounds.min.Y + self.winnerLineOffsetFromTopBarPx
	local v8 = math.max(viewPortBounds.max.X - viewPortBounds.min.X, 1)
	local v9 = 1e999
	local v10 = 1e999
	local v11 = false
	local v12 = nil

	for k, guiObject in CollectionService:GetTagged(adsPlaybackCoordinatorInfo.candidateTag) do
		if not (guiObject:IsA("GuiObject") and guiObject:IsDescendantOf(current) and getIsInstanceVisible(
			guiObject,
			viewPortBounds,
			fIntLuaAppOneByTwoTileVideoVisiblePercent
		)) then
			continue
		end

		local x = guiObject.AbsolutePosition.X
		local v13 = math.abs(guiObject.AbsolutePosition.Y + x / v8 * guiObject.AbsoluteSize.Y - v7)
		local flag = false

		if v13 < v9 or v13 == v9 and x < v10 then
			flag = true
		elseif v13 == v9 and x == v10 and not v11 and v12 then
			reportCandidateOverlap(v12, guiObject, x)
			v11 = true
		end

		if not flag then
			continue
		end

		v12 = guiObject
		v10 = x
		v9 = v13
	end

	return v12
end

function class:_selectUserIntentOrAutoplayWinner(p2, p3, p4)
	local userIntentWinner = self:_selectUserIntentWinner()

	if userIntentWinner then
		return userIntentWinner, true
	end

	local playingVideoKey = self.coordinator.playingVideoKey

	if playingVideoKey ~= nil then
		return self:_selectCurrentIdleWinner(playingVideoKey), false
	end

	if self.isScrolling and not fFlagLuaAppHoverIdleAutoplayDuringScroll then
		return nil, false
	end

	return self:_selectWinner(p2, p3, p4, UserIntentModeAutoplayCandidateTag, true), false
end

function class:_selectUserIntentWinner()
	local currentUserIntentCandidate = self.currentUserIntentCandidate
	local current = if self.feedScopeRef then self.feedScopeRef.current else nil

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

function class:_selectCurrentIdleWinner(p2)
	local current = if self.feedScopeRef then self.feedScopeRef.current else nil
	local viewPortBounds = self.viewPortBounds

	if current == nil or viewPortBounds == nil then
		return nil
	end

	for k, guiObject in CollectionService:GetTagged(UserIntentModeAutoplayCandidateTag) do
		if
			not guiObject:IsA("GuiObject")
			or guiObject:GetAttribute(ViewportAutoplayVideoKeyAttribute) ~= p2
			or self.playedVideoKeys[p2]
			or not guiObject:IsDescendantOf(current)
		then
			continue
		end

		local v7

		if getTileRowSpan(guiObject) == 2 and not self.preferTallestWinner then
			v7 = fIntLuaAppOneByTwoTileVideoVisiblePercent
		else
			v7 = fIntLuaAppGameTileVideoVisiblePercent
		end

		if getIsInstanceVisible(guiObject, viewPortBounds, v7) then
			return guiObject
		end
	end

	return nil
end

function class:_isCandidateEligibleForSelection(instance, p3): boolean
	if not p3 then
		return true
	end

	local attribute = instance:GetAttribute(ViewportAutoplayVideoKeyAttribute)
	return typeof(attribute) == "string" and not self.playedVideoKeys[attribute]
end

function class:_selectWinner(p2, p3, p4, p5, p6)
	local viewPortBounds = self.viewPortBounds

	if not viewPortBounds then
		return nil
	end

	local current = nil

	if p2 == "X" and p3 then
		current = p3.current
	elseif self.feedScopeRef then
		current = self.feedScopeRef.current
	end

	if not current then
		return nil
	end

	local v7 = viewPortBounds.min.Y + self.winnerLineOffsetFromTopBarPx
	local v8 = math.max(viewPortBounds.max.X - viewPortBounds.min.X, 1)

	local v9 = (viewPortBounds.max.Y - viewPortBounds.min.Y) * (defineFastInt / 100)

	local v10 = nil
	local v11 = 1e999
	local v12 = 1e999
	local v13 = false
	local v14, v15

	if self.preferTallestWinner then
		v14 = -1
		v15 = 1e999
	end

	local function shouldReplaceByLeftmostX(p7, p8): boolean
		if p7 < v12 then
			return true
		end

		if p7 == v12 and not v13 and v10 then
			v13 = true
			reportCandidateOverlap(v10, p8, p7)
		end

		return false
	end

	local function considerFoldXCandidate(p7, p8, p9)
		local v16 = math.abs(p9 - v7)

		if v16 < v11 then
			v11 = v16
			v12 = p8
			v10 = p7
		elseif v16 == v11 then
			local flag

			if p8 < v12 then
				flag = true
			else
				if p8 == v12 and not v13 and v10 then
					v13 = true
					reportCandidateOverlap(v10, p7, p8)
				end

				flag = false
			end

			if flag then
				v11 = v16
				v12 = p8
				v10 = p7
			end
		end
	end

	local tagged = CollectionService:GetTagged(fFlagLuaAppOneByTwoHoverIdleAutoplay and p5 or ViewportAutoplayCandidateTag)

	local guiObjects = {}

	for k, guiObject in tagged do
		if not (guiObject:IsA("GuiObject") and guiObject:IsDescendantOf(current) and (not fFlagLuaAppOneByTwoHoverIdleAutoplay or self:_isCandidateEligibleForSelection(guiObject, p6))) then
			continue
		end

		table.insert(guiObjects, guiObject)
	end

	local v16 = computeRowAnchorOverrides(guiObjects, v8)

	for k, guiObject in tagged do
		if not (guiObject:IsA("GuiObject") and guiObject:IsDescendantOf(current) and (not fFlagLuaAppOneByTwoHoverIdleAutoplay or self:_isCandidateEligibleForSelection(guiObject, p6))) then
			continue
		end

		local v17

		if getTileRowSpan(guiObject) == 2 and not self.preferTallestWinner then
			v17 = fIntLuaAppOneByTwoTileVideoVisiblePercent
		else
			v17 = fIntLuaAppGameTileVideoVisiblePercent
		end

		if not getIsInstanceVisible(guiObject, viewPortBounds, v17) then
			continue
		end

		local x = guiObject.AbsolutePosition.X

		if fFlagLuaAppVideoAutoplayFeedElection and self.preferTallestWinner then
			local v18 = math.abs(math.clamp(
				v7,
				guiObject.AbsolutePosition.Y,
				guiObject.AbsolutePosition.Y + guiObject.AbsoluteSize.Y
			) - v7)

			local y = guiObject.AbsoluteSize.Y
			local v19 = math.abs(guiObject.AbsolutePosition.Y + x / v8 * y - v7)
			local v20 = false

			if v18 < v11 then
				v20 = true
			elseif v18 == v11 then
				if v14 < y then
					v20 = true
				elseif y == v14 then
					if p4 then
						local v21

						if x < v12 then
							v21 = true
						else
							if x == v12 and not v13 and v10 then
								v13 = true
								reportCandidateOverlap(v10, guiObject, x)
							end

							v21 = false
						end

						v20 = v21 and true or false
					elseif v19 < v15 then
						v20 = true
					elseif v19 == v15 then
						local v21

						if x < v12 then
							v21 = true
						else
							if x == v12 and not v13 and v10 then
								v13 = true
								reportCandidateOverlap(v10, guiObject, x)
							end

							v21 = false
						end

						v20 = v21 and true or false
					end
				end
			end

			if v20 then
				v11 = v18

				v12 = x
				v10 = guiObject
				v15 = v19
				v14 = y
			end
		else
			local tileRowSpan = getTileRowSpan(guiObject)
			local v18 = v16[guiObject]

			if tileRowSpan == 2 then
				local readingOrderPositions = getReadingOrderPositions(
					guiObject,
					x,
					v8,
					2,
					(resolveOneByOneHeight(guiObject, 2))
				)

				if v18 ~= nil then
					readingOrderPositions[isTilePinnedLeft(guiObject) and 1 or 2] = v18
				end

				for k2, readingOrderPosition in readingOrderPositions do
					local v19 = math.abs(readingOrderPosition - v7)

					if v19 < v11 then
						v11 = v19
						v12 = x
						v10 = guiObject
					elseif v19 == v11 then
						local flag

						if x < v12 then
							flag = true
						else
							if x == v12 and not v13 and v10 then
								v13 = true
								reportCandidateOverlap(v10, guiObject, x)
							end

							flag = false
						end

						if flag then
							v11 = v19
							v12 = x
							v10 = guiObject
						end
					end
				end
			elseif v18 == nil then
				local v19 = math.abs(guiObject.AbsolutePosition.Y + x / v8 * guiObject.AbsoluteSize.Y - v7)

				if v19 < v11 then
					v11 = v19
					v12 = x
					v10 = guiObject
				elseif v19 == v11 then
					local flag

					if x < v12 then
						flag = true
					else
						if x == v12 and not v13 and v10 then
							v13 = true
							reportCandidateOverlap(v10, guiObject, x)
						end

						flag = false
					end

					if flag then
						v11 = v19
						v12 = x
						v10 = guiObject
					end
				end
			else
				local v19 = math.abs(v18 - v7)

				if v19 < v11 then
					v11 = v19
					v12 = x
					v10 = guiObject
				elseif v19 == v11 then
					local flag

					if x < v12 then
						flag = true
					else
						if x == v12 and not v13 and v10 then
							v13 = true
							reportCandidateOverlap(v10, guiObject, x)
						end

						flag = false
					end

					if flag then
						v11 = v19
						v12 = x
						v10 = guiObject
					end
				end
			end
		end
	end

	if v9 < v11 then
		return nil
	end

	return v10
end

return class
