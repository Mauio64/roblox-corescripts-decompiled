local CollectionService = game:GetService("CollectionService")
local VideoUtils = script:FindFirstAncestor("VideoUtils")
local VideoUtilsParent = VideoUtils.Parent
local Signals = require(VideoUtilsParent.Signals)
local DiscoveryEventErrorLogger = require(VideoUtilsParent.DiscoveryUtils).DiscoveryEventErrorLogger

require(VideoUtils.VideoPlaybackCoordinator)

local VideoEndReason = require(VideoUtils.Analytics.Enums).VideoEndReason
local getIsInstanceVisible = require(VideoUtils.getIsInstanceVisible)
local ViewportAutoplayCandidateTag = require(VideoUtils.ViewportAutoplayCandidateTag)
local FIntLuaAppGameTileVideoVisiblePercent = require(VideoUtilsParent.SharedFlags).FIntLuaAppGameTileVideoVisiblePercent
local FFlagLuaAppTileVideoKeepPlayingOnScroll = require(VideoUtilsParent.SharedFlags).FFlagLuaAppTileVideoKeepPlayingOnScroll
local v11 = game:DefineFastInt("LuaAppVideoAutoplayMaxDistanceToWinnerLinePercent", 50)
local t1 = {
	instance = nil,
	shouldUseDwell = true
}

local function winnerStateEquals(t2: {[any]: any}, t3: {[any]: any}) -- line: 39
	return t2.instance == t3.instance and t2.shouldUseDwell == t3.shouldUseDwell
end

local t4 = {}

t4.__index = t4

function t4.new(p1) -- line: 60
	-- upvalues: Signals (copy), t1 (copy), winnerStateEquals (copy), t4 (copy)
	local v18, v19 = Signals.createSignal(t1, winnerStateEquals)

	return (setmetatable({
		isScrolling = false,
		pendingUpdateTask = nil,
		viewPortBounds = nil,
		feedScopeRef = nil,
		winnerLineOffsetFromTopBarPx = 0,
		coordinator = p1,
		getWinnerState = v18,
		setWinnerState = v19
	}, t4))
end
function t4._hasUsableViewportBounds(p2) -- line: 75
	if not p2.viewPortBounds then
		return false
	end

	return p2.viewPortBounds.max.X > p2.viewPortBounds.min.X and p2.viewPortBounds.max.Y > p2.viewPortBounds.min.Y
end
function t4._maybeScheduleInitialWinnerUpdate(p3) -- line: 84
	if p3.getWinnerState(false).instance ~= nil or p3.isScrolling then
		return
	end

	if not p3:_hasUsableViewportBounds() then
		return
	end

	p3:scheduleUpdateWinner("Y", nil, true)
end
function t4.setViewPortBounds(p4, t5: {[any]: any}) -- line: 97
	-- upvalues: VideoEndReason (copy)
	p4.viewPortBounds = t5
	p4:_maybeScheduleInitialWinnerUpdate()

	local v24 = p4.getWinnerState(false)
	local instance = v24.instance

	if instance ~= nil and (not p4.isScrolling and p4:_hasUsableViewportBounds()) then
		p4:_cancelPendingUpdate()

		local v26 = p4:_selectWinner("Y", nil)
		local shouldUseDwell = v24.shouldUseDwell

		if v26 ~= instance then
			p4.coordinator:reset(VideoEndReason.ViewportResized)
			shouldUseDwell = true
		end

		p4.setWinnerState({
			instance = v26,
			shouldUseDwell = shouldUseDwell
		})
	end
end
function t4.setWinnerLineOffsetFromTopBarPx(p5, n1: number) -- line: 126
	p5.winnerLineOffsetFromTopBarPx = n1
end
function t4.setFeedScopeRef(p6, t6: {[any]: any}) -- line: 136
	p6.feedScopeRef = t6
	p6:_maybeScheduleInitialWinnerUpdate()
end
function t4._cancelPendingUpdate(p7) -- line: 142
	if p7.pendingUpdateTask ~= nil then
		task.cancel(p7.pendingUpdateTask)
		p7.pendingUpdateTask = nil
	end
end
function t4.onScrollStart(p8) -- line: 150
	-- upvalues: FFlagLuaAppTileVideoKeepPlayingOnScroll (copy), VideoEndReason (copy)
	p8:_cancelPendingUpdate()
	p8.isScrolling = true

	if not FFlagLuaAppTileVideoKeepPlayingOnScroll then
		p8.coordinator:reset(VideoEndReason.ScrollStart)
		p8.setWinnerState({
			instance = nil,
			shouldUseDwell = false
		})
	end
end
function t4.onScrollSettled(p9, s1: string, _: number, t7: {[any]: any}?) -- line: 165
	-- upvalues: FFlagLuaAppTileVideoKeepPlayingOnScroll (copy), VideoEndReason (copy)
	p9:_cancelPendingUpdate()
	p9.isScrolling = false

	if FFlagLuaAppTileVideoKeepPlayingOnScroll then
		local instance = p9.getWinnerState(false).instance
		local v39 = p9:_selectWinner(s1, t7)

		if instance ~= v39 and instance ~= nil then
			p9.coordinator:reset(VideoEndReason.ScrollSettled)
		end

		p9.setWinnerState({
			shouldUseDwell = false,
			instance = v39
		})

		return
	end

	p9:_updateWinner(s1, t7, false)
end
function t4.reset(p10, s2: string) -- line: 189
	p10:_cancelPendingUpdate()
	p10.isScrolling = false
	p10.coordinator:reset(s2)
	p10.setWinnerState({
		instance = nil,
		shouldUseDwell = false
	})
end
function t4.resetIfActiveInstance(p11, p12, s3: string) -- line: 196
	if p12 == p11.getWinnerState(false).instance then
		p11:reset(s3)
		p11:_maybeScheduleInitialWinnerUpdate()
	end
end
function t4.scheduleUpdateWinner(p13, s4: string, t8: {[any]: any}?, b1: boolean) -- line: 210
	if p13.pendingUpdateTask ~= nil then
		return
	end

	p13.pendingUpdateTask = task.defer(function() -- line: 220
		-- upvalues: p13 (copy), s4 (copy), t8 (copy), b1 (copy)
		p13.pendingUpdateTask = nil

		if p13.isScrolling then
			return
		end

		p13:_updateWinner(s4, t8, b1)
	end)
end
function t4._updateWinner(p14, s5: string, t9: {[any]: any}?, b2: boolean) -- line: 232
	local v53 = p14:_selectWinner(s5, t9)

	p14.setWinnerState({
		instance = v53,
		shouldUseDwell = b2
	})
end
function t4._selectWinner(p15, s6: string, t10: {[any]: any}?) -- line: 244
	-- upvalues: v11 (copy), CollectionService (copy), ViewportAutoplayCandidateTag (copy), getIsInstanceVisible (copy), FIntLuaAppGameTileVideoVisiblePercent (copy), DiscoveryEventErrorLogger (copy)
	local viewPortBounds = p15.viewPortBounds

	if not viewPortBounds then
		return nil
	end

	local current = nil

	if s6 == "X" and t10 then
		current = t10.current
	elseif p15.feedScopeRef then
		current = p15.feedScopeRef.current
	end

	if not current then
		return nil
	end

	local v59 = viewPortBounds.min.Y + p15.winnerLineOffsetFromTopBarPx
	local v60 = math.max(viewPortBounds.max.X - viewPortBounds.min.X, 1)
	local v61 = (viewPortBounds.max.Y - viewPortBounds.min.Y) * (v11 / 100)
	local v62 = nil
	local n3 = 1e999
	local n4 = 1e999
	local v65 = false

	for _, v67 in (CollectionService:GetTagged(ViewportAutoplayCandidateTag)) do
		if v67:IsA("GuiObject") and v67:IsDescendantOf(current) and getIsInstanceVisible(v67, viewPortBounds, FIntLuaAppGameTileVideoVisiblePercent) then
			local v68 = math.abs(v67.AbsolutePosition.Y + v67.AbsolutePosition.X / v60 * v67.AbsoluteSize.Y - v59)
			local AbsolutePositionX = v67.AbsolutePosition.X
			local v70 = false

			if v68 < n3 then
				v70 = true
			elseif v68 == n3 then
				if AbsolutePositionX < n4 then
					v70 = true
				elseif AbsolutePositionX == n4 and not v65 and v62 then
					v65 = true
					DiscoveryEventErrorLogger.reportError("ViewportAutoplayCandidateOverlap", "Two visible autoplay candidates share identical reading-order position and AbsolutePosition.X", {
						candidateA = v62.Name,
						candidateB = v67.Name,
						absolutePositionX = AbsolutePositionX,
						absolutePositionY = v67.AbsolutePosition.Y,
						absoluteSizeX = v67.AbsoluteSize.X,
						absoluteSizeY = v67.AbsoluteSize.Y
					})
				end
			end

			if v70 then
				n3 = v68
				n4 = AbsolutePositionX
				v62 = v67
			end
		end
	end

	if v61 < n3 then
		return nil
	end

	return v62
end

return t4
