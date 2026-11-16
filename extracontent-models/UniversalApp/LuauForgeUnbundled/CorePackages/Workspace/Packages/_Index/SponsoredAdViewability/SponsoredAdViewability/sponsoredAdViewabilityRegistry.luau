local CollectionService = game:GetService("CollectionService")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredAdViewability/SponsoredAdViewability/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/SponsoredAdViewability/SponsoredAdViewability/sponsoredAdViewabilityTypes")

local v5 = {}

local count = 0

return {
	bind = function(instance, data)
		local v6 = data.mediaType == "video"

		if data.mediaType ~= "image" and not v6 then
			return function() end
		end

		if v6 ~= (data.videoPlaybackStateRef ~= nil) then
			return function() end
		end

		if data.isFullscreen == true and not v6 then
			return function() end
		end

		count += 1
		local v7 = tostring(count)
		v5[v7] = data
		instance:SetAttribute(Constants.ViewabilityTargetIdAttribute, v7)
		CollectionService:AddTag(instance, Constants.CandidateTag)

		return function()
			if instance:GetAttribute(Constants.ViewabilityTargetIdAttribute) == v7 then
				CollectionService:RemoveTag(instance, Constants.CandidateTag)
				instance:SetAttribute(Constants.ViewabilityTargetIdAttribute, nil)
			end

			v5[v7] = nil
		end
	end,
	get = function(p2)
		return v5[p2]
	end,
	_clear = function()
		for k in v5 do
			v5[k] = nil
		end
	end,
	_size = function()
		local count2 = 0

		for k in v5 do
			count2 += 1
		end

		return count2
	end
}
