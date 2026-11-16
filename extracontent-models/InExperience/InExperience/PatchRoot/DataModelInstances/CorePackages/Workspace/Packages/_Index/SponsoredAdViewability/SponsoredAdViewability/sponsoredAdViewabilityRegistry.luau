local CollectionService = game:GetService("CollectionService")

local Constants = require(script.Parent.Constants)
require(script.Parent.sponsoredAdViewabilityTypes)

local v = {}

local count = 0
local SponsoredAdViewabilityRegistry = {}

function SponsoredAdViewabilityRegistry.bind(instance, data)
	local v2 = data.mediaType == "video"

	if data.mediaType ~= "image" and not v2 then
		return function() end
	end

	if v2 ~= (data.videoPlaybackStateRef ~= nil) then
		return function() end
	end

	if data.isFullscreen == true and not v2 then
		return function() end
	end

	count += 1
	local v3 = tostring(count)
	v[v3] = data
	instance:SetAttribute(Constants.ViewabilityTargetIdAttribute, v3)
	CollectionService:AddTag(instance, Constants.CandidateTag)

	return function()
		if instance:GetAttribute(Constants.ViewabilityTargetIdAttribute) == v3 then
			CollectionService:RemoveTag(instance, Constants.CandidateTag)
			instance:SetAttribute(Constants.ViewabilityTargetIdAttribute, nil)
		end

		v[v3] = nil
	end
end

function SponsoredAdViewabilityRegistry.get(p: string)
	return v[p]
end

function SponsoredAdViewabilityRegistry._clear()
	for k in v do
		v[k] = nil
	end
end

function SponsoredAdViewabilityRegistry._size()
	local count2 = 0

	for _ in v do
		count2 += 1
	end

	return count2
end

return SponsoredAdViewabilityRegistry
