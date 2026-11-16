local CollectionService = game:GetService("CollectionService")

local parent = script:FindFirstAncestor("SponsoredTiles").Parent

local React = require(parent.React)
local VideoUtils = require(parent.VideoUtils)
local VideoEndReason = VideoUtils.AnalyticsEnums.VideoEndReason

local AdsViewportAutoplayCandidateTag = require(script.Parent.AdsViewportAutoplayCandidateTag)

local function useTagAsAdsViewportAutoplayCandidate(p, object)
	React.useEffect(function()
		if not object then
			return
		end

		local current = p.current

		if not current then
			return
		end

		CollectionService:AddTag(current, AdsViewportAutoplayCandidateTag)
		object:onAdsCandidateRegistered(current)

		return function()
			CollectionService:RemoveTag(current, AdsViewportAutoplayCandidateTag)
			object:resetIfActiveInstance(current, VideoEndReason.Unmounted)
		end
	end, { object, p })
end

return useTagAsAdsViewportAutoplayCandidate
