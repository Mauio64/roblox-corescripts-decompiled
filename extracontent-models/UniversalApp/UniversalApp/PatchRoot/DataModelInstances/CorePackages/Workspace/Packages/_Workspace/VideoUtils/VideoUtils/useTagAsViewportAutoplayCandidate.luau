local CollectionService = game:GetService("CollectionService")
local VideoUtils = script:FindFirstAncestor("VideoUtils")
local VideoUtilsParent = VideoUtils.Parent
local React = require(VideoUtilsParent.React)

require(script.Parent.FeedVideoPlaybackContext)

local VideoEndReason = require(VideoUtils.Analytics.Enums).VideoEndReason
local ViewportAutoplayCandidateTag = require(script.Parent.ViewportAutoplayCandidateTag)
local FFlagLuaAppTileVideoCandidateOnly = require(VideoUtilsParent.SharedFlags).FFlagLuaAppTileVideoCandidateOnly
local FFlagLuaAppFixHiddenTileVideoCleanup = require(VideoUtilsParent.SharedFlags).FFlagLuaAppFixHiddenTileVideoCleanup

local function useTagAsViewportAutoplayCandidate(t1: {[any]: any}, p1, b1: boolean?, b2: boolean?) -- line: 17
	-- upvalues: React (copy), FFlagLuaAppTileVideoCandidateOnly (copy), FFlagLuaAppFixHiddenTileVideoCleanup (copy), CollectionService (copy), ViewportAutoplayCandidateTag (copy), VideoEndReason (copy)
	local v14 = if not p1 then nil else p1.viewportVideoAutoplayController

	React.useEffect(function() -- line: 28
		-- upvalues: v14 (copy), FFlagLuaAppTileVideoCandidateOnly (copy), b1 (copy), FFlagLuaAppFixHiddenTileVideoCleanup (copy), b2 (copy), t1 (copy), CollectionService (copy), ViewportAutoplayCandidateTag (copy), VideoEndReason (copy)
		if not v14 then
			return
		end

		if FFlagLuaAppTileVideoCandidateOnly and not b1 then
			return
		end

		if FFlagLuaAppFixHiddenTileVideoCleanup and b2 then
			return
		end

		local current = t1.current

		if not current then
			return
		end

		CollectionService:AddTag(current, ViewportAutoplayCandidateTag)

		return function() -- line: 50
			-- upvalues: CollectionService (copy), current (copy), ViewportAutoplayCandidateTag (copy), v14 (copy), VideoEndReason (copy)
			CollectionService:RemoveTag(current, ViewportAutoplayCandidateTag)
			v14:resetIfActiveInstance(current, VideoEndReason.Unmounted)
		end
	end, {
		v14,
		t1,
		if not FFlagLuaAppTileVideoCandidateOnly then nil else b1,
		if not FFlagLuaAppFixHiddenTileVideoCleanup then nil else b2
	})
end

return useTagAsViewportAutoplayCandidate
