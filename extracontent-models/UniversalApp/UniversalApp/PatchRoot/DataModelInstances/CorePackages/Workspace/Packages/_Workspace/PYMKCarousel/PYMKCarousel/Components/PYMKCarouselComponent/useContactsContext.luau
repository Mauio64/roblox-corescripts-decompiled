local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)
local PYMKCarouselParent = PYMKCarousel.Parent
local React = require(PYMKCarouselParent.React)
local tutils = require(PYMKCarouselParent.tutils)
local useSelector = dependencies.Hooks.useSelector
local RoduxFriends = dependencies.RoduxFriends
local RecommendationContextType = RoduxFriends.Enums.RecommendationContextType

local function useContactsContext(t1: {[any]: any}) -- line: 33
	-- upvalues: useSelector (copy), RoduxFriends (copy), tutils (copy), React (copy), RecommendationContextType (copy)
	local v11 = useSelector(function(p1) -- line: 34
		-- upvalues: RoduxFriends (copy)
		local str = tostring(p1.LocalUserId)

		return RoduxFriends.Selectors.selectRecommendationsForUserId(p1)(str) or {}
	end, tutils.shallowEqual)

	return (React.useMemo(function() -- line: 39
		-- upvalues: t1 (copy), RecommendationContextType (copy), v11 (copy)
		local t2 = {}

		for _, v16 in t1 do
			if v16.recommendationContextType == RecommendationContextType.Contacts then
				local id = v16.id
				local v18 = v11[id]

				if v18 then
					t2[id] = {
						isLoading = false,
						name = v18.entityDisplayName or "",
						avatarThumbnailUrl = not v18.thumbnailEntities and "" or (v18.thumbnailEntities.headshotImageUrl or "")
					}
				end
			end
		end

		return {
			contacts = t2
		}
	end, {
		t1,
		v11
	}))
end

return useContactsContext
