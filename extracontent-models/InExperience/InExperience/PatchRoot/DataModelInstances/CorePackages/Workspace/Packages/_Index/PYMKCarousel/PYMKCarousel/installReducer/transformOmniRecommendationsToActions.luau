local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local parent = PYMKCarousel.Parent
local dependencies = require(PYMKCarousel.dependencies)

local llama = dependencies.llama

local SocialCommon = require(parent.SocialCommon)
require(PYMKCarousel.Common.OmniTypes)
local getRecommendationsMetadata = require(script.Parent.getRecommendationsMetadata)
local ContextualInfoTypes = SocialCommon.Enums.ContextualInfoTypes

local function fn(item, treatmentType: string)
	local sorts = item.sorts or {}
	local where = llama.List.findWhere(sorts, function(p): boolean
		return p.treatmentType == treatmentType
	end)

	if where then
		return sorts[where]
	end

	return nil
end

return function(items, p, callback, callback2)
	local contentType = p.contentType
	local treatmentType = p.treatmentType
	local reduced = {}

	for _, item in pairs(items) do
		local recommendationsMetadata = getRecommendationsMetadata(item, contentType)
		local v = fn(item, treatmentType)
		local recommendations = v and v.recommendations or {}

		if #recommendations == 0 then
			continue
		end

		if callback2 then
			reduced = llama.List.push(reduced, callback2(v, recommendationsMetadata))
		end

		reduced = llama.List.reduce(recommendations, function(p2, data, p3)
			local v2

			if data.contentMetadata.contextType == ContextualInfoTypes.Contacts then
				v2 = data.contentStringId
			else
				v2 = tostring(data.contentId)
			end

			local v3 = recommendationsMetadata[v2]
			local contentMetadata = data.contentMetadata

			if not v3 then
				return p2
			end

			if callback then
				return llama.List.push(p2, callback(v3, p3, contentMetadata))
			end

			return p2
		end, reduced)
	end

	return reduced
end
