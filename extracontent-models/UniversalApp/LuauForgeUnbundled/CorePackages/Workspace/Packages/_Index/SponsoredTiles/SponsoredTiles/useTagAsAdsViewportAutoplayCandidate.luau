local CollectionService = game:GetService("CollectionService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/React")
local videoEndReason = require("@game/CorePackages/Workspace/Packages/_Workspace/SponsoredTiles/VideoUtils").AnalyticsEnums.VideoEndReason

local AdsViewportAutoplayCandidateTag = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredTiles/SponsoredTiles/AdsViewportAutoplayCandidateTag")

local function useTagAsAdsViewportAutoplayCandidate(p2, object)
	React.useEffect(function()
		if not object then
			return
		end

		local current = p2.current

		if not current then
			return
		end

		CollectionService:AddTag(current, AdsViewportAutoplayCandidateTag)
		object:onAdsCandidateRegistered(current)

		return function()
			CollectionService:RemoveTag(current, AdsViewportAutoplayCandidateTag)
			object:resetIfActiveInstance(current, videoEndReason.Unmounted)
		end
	end, { object, p2 })
end

return useTagAsAdsViewportAutoplayCandidate
