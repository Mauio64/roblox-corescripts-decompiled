local llama = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies").llama

local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SocialCommon")
require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/OmniTypes")
local getRecommendationsMetadata = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/installReducer/getRecommendationsMetadata")
local contextualInfoTypes = SocialCommon.Enums.ContextualInfoTypes

local function fn(item, treatmentType)
	local sorts = item.sorts or {}
	local where = llama.List.findWhere(sorts, function(p2): boolean
		return p2.treatmentType == treatmentType
	end)

	if where then
		return sorts[where]
	end

	return nil
end

return function(items, p2, callback, callback2)
	local contentType = p2.contentType
	local treatmentType = p2.treatmentType
	local reduced = {}

	for k, item in pairs(items) do
		local v5 = getRecommendationsMetadata(item, contentType)
		local v6 = fn(item, treatmentType)
		local recommendations = v6 and v6.recommendations or {}

		if #recommendations == 0 then
			continue
		end

		if callback2 then
			reduced = llama.List.push(reduced, callback2(v6, v5))
		end

		reduced = llama.List.reduce(recommendations, function(p3, data, p4)
			local v7 = if data.contentMetadata.contextType == contextualInfoTypes.Contacts then data.contentStringId else tostring(data.contentId)
			local v8 = v5[v7]
			local contentMetadata = data.contentMetadata

			if not v8 then
				return p3
			end

			if callback then
				return llama.List.push(p3, callback(v8, p4, contentMetadata))
			end

			return p3
		end, reduced)
	end

	return reduced
end
