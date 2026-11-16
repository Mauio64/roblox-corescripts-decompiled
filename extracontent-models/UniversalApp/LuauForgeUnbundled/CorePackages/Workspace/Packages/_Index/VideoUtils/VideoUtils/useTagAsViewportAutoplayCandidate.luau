local CollectionService = game:GetService("CollectionService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/React")

require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/FeedVideoPlaybackContext")
local ViewportAutoplayVideoKeyAttribute = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/ViewportAutoplayVideoKeyAttribute")
local UserIntentModeAutoplayCandidateTag = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/UserIntentModeAutoplayCandidateTag")
local videoEndReason = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/Analytics/Enums").VideoEndReason
local ViewportAutoplayCandidateTag = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/ViewportAutoplayCandidateTag")
local ViewportAutoplayRowSpanAttribute = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/ViewportAutoplayRowSpanAttribute")
local ViewportAutoplayCellVerticalPaddingAttribute = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/ViewportAutoplayCellVerticalPaddingAttribute")
local ViewportAutoplayAlignmentTypeAttribute = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/ViewportAutoplayAlignmentTypeAttribute")
local alignmentType = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/DiscoveryTypes").GameCollectionItemTypes.AlignmentType

local fFlagLuaAppOneByTwoHoverIdleAutoplay = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppOneByTwoHoverIdleAutoplay
local fFlagLuaAppTileVideoCandidateOnly = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppTileVideoCandidateOnly
local fFlagLuaAppFixHiddenTileVideoCleanup = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppFixHiddenTileVideoCleanup
local fFlagLuaAppVideoAutoplayFeedElection = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppVideoAutoplayFeedElection
local FFlagLuaAppVideoAutoplayElectOnNewCandidate = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/FFlagLuaAppVideoAutoplayElectOnNewCandidate")

local function isVideoAutoplayCandidate(p2): boolean
	return not fFlagLuaAppTileVideoCandidateOnly or p2 == true
end

local function shouldTagUserIntentModeCandidate(p2, p3, p4)
	local v5 = not (fFlagLuaAppFixHiddenTileVideoCleanup and p3)

	if v5 then
		v5 = not fFlagLuaAppTileVideoCandidateOnly or p2 == true or p4
	end

	return v5
end

local function shouldNotifyUserIntentModeCandidateRegistered(p2, p3)
	return p2 or fFlagLuaAppVideoAutoplayFeedElection and (p3 or FFlagLuaAppVideoAutoplayElectOnNewCandidate)
end

local function useTagAsViewportAutoplayCandidate(p2, p3, p4, p5, p6, p7, p8, p9)
	local viewportVideoAutoplayController = if p3 then p3.viewportVideoAutoplayController else nil

	local videoKey = if fFlagLuaAppOneByTwoHoverIdleAutoplay and p9 then p9.videoKey else nil

	local v5 = fFlagLuaAppOneByTwoHoverIdleAutoplay

	if v5 then
		v5 = not (p9 == nil) and p9.isUserIntentModeAutoplayCandidate
	end

	local v6 = fFlagLuaAppOneByTwoHoverIdleAutoplay and p9 ~= nil
	local useEffect = React.useEffect
	local function fn()
		if not viewportVideoAutoplayController then
			return
		end

		if fFlagLuaAppOneByTwoHoverIdleAutoplay then
			local v7 = p4

			local v9 = v5
			local v10 = not (fFlagLuaAppFixHiddenTileVideoCleanup and p5)

			if v10 then
				v10 = not fFlagLuaAppTileVideoCandidateOnly or v7 == true or v9
			end

			if not v10 then
				return
			end
		elseif
			fFlagLuaAppTileVideoCandidateOnly and not p4
			or fFlagLuaAppFixHiddenTileVideoCleanup and p5
		then
			return
		end

		local current = p2.current

		if not current or p6 == 2 and p8 ~= alignmentType.LeftPin and p8 ~= alignmentType.RightPin then
			return
		end

		if fFlagLuaAppOneByTwoHoverIdleAutoplay and videoKey then
			current:SetAttribute(ViewportAutoplayVideoKeyAttribute, videoKey)
		end

		if p6 ~= nil then
			current:SetAttribute(ViewportAutoplayRowSpanAttribute, p6)
			current:SetAttribute(ViewportAutoplayCellVerticalPaddingAttribute, p7)
			current:SetAttribute(ViewportAutoplayAlignmentTypeAttribute, p8)
		end

		if fFlagLuaAppOneByTwoHoverIdleAutoplay then
			if not fFlagLuaAppTileVideoCandidateOnly or p4 == true then
				CollectionService:AddTag(current, ViewportAutoplayCandidateTag)
			end
		else
			CollectionService:AddTag(current, ViewportAutoplayCandidateTag)
		end

		if fFlagLuaAppOneByTwoHoverIdleAutoplay and v5 then
			CollectionService:AddTag(current, UserIntentModeAutoplayCandidateTag)
		end

		if fFlagLuaAppOneByTwoHoverIdleAutoplay then
			local v7 = v6 and viewportVideoAutoplayController:isUserIntentWithSelectiveAutoplay()

			local electOnNewCandidate = viewportVideoAutoplayController.electOnNewCandidate

			if v7 or fFlagLuaAppVideoAutoplayFeedElection and (electOnNewCandidate or FFlagLuaAppVideoAutoplayElectOnNewCandidate) then
				viewportVideoAutoplayController:onCandidateRegistered(current)
			end
		elseif
			fFlagLuaAppVideoAutoplayFeedElection
			and (viewportVideoAutoplayController.electOnNewCandidate or FFlagLuaAppVideoAutoplayElectOnNewCandidate)
		then
			viewportVideoAutoplayController:onCandidateRegistered(current)
		end

		return function()
			CollectionService:RemoveTag(current, ViewportAutoplayCandidateTag)

			if fFlagLuaAppOneByTwoHoverIdleAutoplay then
				CollectionService:RemoveTag(current, UserIntentModeAutoplayCandidateTag)
			end

			if p6 ~= nil then
				current:SetAttribute(ViewportAutoplayRowSpanAttribute, nil)
				current:SetAttribute(ViewportAutoplayCellVerticalPaddingAttribute, nil)
				current:SetAttribute(ViewportAutoplayAlignmentTypeAttribute, nil)
			end

			if fFlagLuaAppOneByTwoHoverIdleAutoplay then
				current:SetAttribute(ViewportAutoplayVideoKeyAttribute, nil)
			end

			viewportVideoAutoplayController:resetIfActiveInstance(current, videoEndReason.Unmounted)
		end
	end

	local v8 = if fFlagLuaAppTileVideoCandidateOnly then p4 else nil
	local v9 = if fFlagLuaAppFixHiddenTileVideoCleanup then p5 else nil
	local v10 = if fFlagLuaAppOneByTwoHoverIdleAutoplay then videoKey else nil
	local v11 = if fFlagLuaAppOneByTwoHoverIdleAutoplay then v5 else nil
	useEffect(fn, {
		viewportVideoAutoplayController,
		p2,
		v8,
		v9,
		p6,
		p7,
		p8,
		v10,
		v11,
		if fFlagLuaAppOneByTwoHoverIdleAutoplay then v6 else nil
	})
end

return useTagAsViewportAutoplayCandidate
