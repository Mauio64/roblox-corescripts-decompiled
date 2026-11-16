local CollectionService = game:GetService("CollectionService")

local VideoUtils = script:FindFirstAncestor("VideoUtils")
local parent = VideoUtils.Parent

local React = require(parent.React)

require(script.Parent.FeedVideoPlaybackContext)
local ViewportAutoplayVideoKeyAttribute = require(script.Parent.ViewportAutoplayVideoKeyAttribute)
local UserIntentModeAutoplayCandidateTag = require(script.Parent.UserIntentModeAutoplayCandidateTag)
local Enums = require(VideoUtils.Analytics.Enums)
local VideoEndReason = Enums.VideoEndReason
local ViewportAutoplayCandidateTag = require(script.Parent.ViewportAutoplayCandidateTag)
local ViewportAutoplayRowSpanAttribute = require(script.Parent.ViewportAutoplayRowSpanAttribute)
local ViewportAutoplayCellVerticalPaddingAttribute = require(script.Parent.ViewportAutoplayCellVerticalPaddingAttribute)
local ViewportAutoplayAlignmentTypeAttribute = require(script.Parent.ViewportAutoplayAlignmentTypeAttribute)
local DiscoveryTypes = require(parent.DiscoveryTypes)
local AlignmentType = DiscoveryTypes.GameCollectionItemTypes.AlignmentType

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags.FFlagLuaAppOneByTwoHoverIdleAutoplay
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppTileVideoCandidateOnly = SharedFlags2.FFlagLuaAppTileVideoCandidateOnly
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppFixHiddenTileVideoCleanup = SharedFlags3.FFlagLuaAppFixHiddenTileVideoCleanup
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppVideoAutoplayFeedElection = SharedFlags4.FFlagLuaAppVideoAutoplayFeedElection
local FFlagLuaAppVideoAutoplayElectOnNewCandidate = require(script.Parent.FFlagLuaAppVideoAutoplayElectOnNewCandidate)

local function isVideoAutoplayCandidate(flag: boolean?): boolean -- 2 equivalent calls inferred from this helper
	return not FFlagLuaAppTileVideoCandidateOnly or flag == true
end

local function shouldTagUserIntentModeCandidate(flag: boolean?, flag2: boolean?, flag3: boolean) -- 1 equivalent call inferred from this helper
	return not (FFlagLuaAppFixHiddenTileVideoCleanup and flag2) and (isVideoAutoplayCandidate(flag) or flag3) -- inferred equivalent call
end

local function shouldNotifyUserIntentModeCandidateRegistered(flag: boolean, flag2: boolean) -- 1 equivalent call inferred from this helper
	return flag or FFlagLuaAppVideoAutoplayFeedElection and (flag2 or FFlagLuaAppVideoAutoplayElectOnNewCandidate)
end

local function useTagAsViewportAutoplayCandidate(p, p2, flag: boolean?, flag2: boolean?, p3: number?, p4: number?, p5: string?, p6)
	local viewportVideoAutoplayController

	if p2 then
		viewportVideoAutoplayController = p2.viewportVideoAutoplayController
	else
		viewportVideoAutoplayController = nil
	end

	local videoKey

	if FFlagLuaAppOneByTwoHoverIdleAutoplay and p6 then
		videoKey = p6.videoKey
	else
		videoKey = nil
	end

	local v = FFlagLuaAppOneByTwoHoverIdleAutoplay

	if v then
		v = not (p6 == nil) and p6.isUserIntentModeAutoplayCandidate
	end

	local v2 = FFlagLuaAppOneByTwoHoverIdleAutoplay and p6 ~= nil
	local useEffect = React.useEffect
	local function fn()
		if not viewportVideoAutoplayController then
			return
		end

		if FFlagLuaAppOneByTwoHoverIdleAutoplay then
			if not shouldTagUserIntentModeCandidate(flag, flag2, v) then -- inferred equivalent call
				return
			end
		elseif FFlagLuaAppTileVideoCandidateOnly and not flag or FFlagLuaAppFixHiddenTileVideoCleanup and flag2 then
			return
		end

		local current = p.current

		if not current or p3 == 2 and p5 ~= AlignmentType.LeftPin and p5 ~= AlignmentType.RightPin then
			return
		end

		if FFlagLuaAppOneByTwoHoverIdleAutoplay and videoKey then
			current:SetAttribute(ViewportAutoplayVideoKeyAttribute, videoKey)
		end

		if p3 ~= nil then
			current:SetAttribute(ViewportAutoplayRowSpanAttribute, p3)
			current:SetAttribute(ViewportAutoplayCellVerticalPaddingAttribute, p4)
			current:SetAttribute(ViewportAutoplayAlignmentTypeAttribute, p5)
		end

		if FFlagLuaAppOneByTwoHoverIdleAutoplay then
			if isVideoAutoplayCandidate(flag) then -- inferred equivalent call
				CollectionService:AddTag(current, ViewportAutoplayCandidateTag)
			end
		else
			CollectionService:AddTag(current, ViewportAutoplayCandidateTag)
		end

		if FFlagLuaAppOneByTwoHoverIdleAutoplay and v then
			CollectionService:AddTag(current, UserIntentModeAutoplayCandidateTag)
		end

		if FFlagLuaAppOneByTwoHoverIdleAutoplay then
			if shouldNotifyUserIntentModeCandidateRegistered( -- inferred equivalent call
				v2 and viewportVideoAutoplayController:isUserIntentWithSelectiveAutoplay(),
				viewportVideoAutoplayController.electOnNewCandidate
			) then
				viewportVideoAutoplayController:onCandidateRegistered(current)
			end
		elseif
			FFlagLuaAppVideoAutoplayFeedElection
			and (viewportVideoAutoplayController.electOnNewCandidate or FFlagLuaAppVideoAutoplayElectOnNewCandidate)
		then
			viewportVideoAutoplayController:onCandidateRegistered(current)
		end

		return function()
			CollectionService:RemoveTag(current, ViewportAutoplayCandidateTag)

			if FFlagLuaAppOneByTwoHoverIdleAutoplay then
				CollectionService:RemoveTag(current, UserIntentModeAutoplayCandidateTag)
			end

			if p3 ~= nil then
				current:SetAttribute(ViewportAutoplayRowSpanAttribute, nil)
				current:SetAttribute(ViewportAutoplayCellVerticalPaddingAttribute, nil)
				current:SetAttribute(ViewportAutoplayAlignmentTypeAttribute, nil)
			end

			if FFlagLuaAppOneByTwoHoverIdleAutoplay then
				current:SetAttribute(ViewportAutoplayVideoKeyAttribute, nil)
			end

			viewportVideoAutoplayController:resetIfActiveInstance(current, VideoEndReason.Unmounted)
		end
	end

	local v3

	if FFlagLuaAppTileVideoCandidateOnly then
		v3 = flag
	end

	local v4

	if FFlagLuaAppFixHiddenTileVideoCleanup then
		v4 = flag2
	end

	local v5

	if FFlagLuaAppOneByTwoHoverIdleAutoplay then
		v5 = videoKey
	end

	local v6

	if FFlagLuaAppOneByTwoHoverIdleAutoplay then
		v6 = v
	end

	local v7

	if FFlagLuaAppOneByTwoHoverIdleAutoplay then
		v7 = v2
	end

	useEffect(fn, {
		viewportVideoAutoplayController,
		p,
		v3,
		v4,
		p3,
		p4,
		p5,
		v5,
		v6,
		v7
	})
end

return useTagAsViewportAutoplayCandidate
