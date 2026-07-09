local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local PYMKCarouselParent = PYMKCarousel.Parent
local llama = require(PYMKCarousel.dependencies).llama
local SocialCommon = require(PYMKCarouselParent.SocialCommon)

require(PYMKCarousel.Common.OmniTypes)

local getRecommendationsMetadata = require(script.Parent.getRecommendationsMetadata)
local ContextualInfoTypes = SocialCommon.Enums.ContextualInfoTypes
local getFFlagTempFixInfiniteHomePYMK = require(PYMKCarousel.Flags.getFFlagTempFixInfiniteHomePYMK)

local function v8(p1, s1: string) -- line: 25
	-- upvalues: llama (copy)
	local v11 = p1.sorts or {}
	local v12 = llama.List.findWhere(v11, function(p2) -- line: 30
		-- upvalues: s1 (copy)
		return p2.treatmentType == s1
	end)

	if v12 then
		return v11[v12]
	end

	return nil
end

return function(p3, p4, p5: ((...any) -> ...any)?, p6: ((...any) -> ...any)?) -- line: 36
	-- upvalues: getRecommendationsMetadata (copy), v8 (copy), getFFlagTempFixInfiniteHomePYMK (copy), llama (copy), ContextualInfoTypes (copy)
	local t1 = {}
	local contentType = p4.contentType
	local treatmentType = p4.treatmentType

	for _, v in pairs(p3) do
		local v22 = getRecommendationsMetadata(v, contentType)
		local v23 = v8(v, treatmentType)
		local v24 = if not v23 then {} else v23.recommendations or {}

		if not getFFlagTempFixInfiniteHomePYMK() or #v24 ~= 0 then
			if p6 then
				t1 = llama.List.push(t1, p6(v23, v22))
			end

			t1 = llama.List.reduce(v24, function(p7, p8, p9) -- line: 61
				-- upvalues: ContextualInfoTypes (copy), v22 (copy), p5 (copy), llama (copy)
				local v29 = v22[if p8.contentMetadata.contextType ~= ContextualInfoTypes.Contacts then tostring(p8.contentId) else p8.contentStringId]
				local contentMetadata = p8.contentMetadata

				if not v29 then
					return p7
				end

				if p5 then
					return llama.List.push(p7, p5(v29, p9, contentMetadata))
				end

				return p7
			end, t1)
		end
	end

	return t1
end
