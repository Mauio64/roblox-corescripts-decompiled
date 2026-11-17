local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)
local parent = PYMKCarousel.Parent

local React = require(parent.React)
local tutils = require(parent.tutils)
local useSelector = dependencies.Hooks.useSelector
local roduxFriends = dependencies.RoduxFriends
local recommendationContextType = roduxFriends.Enums.RecommendationContextType
require(PYMKCarousel.Common.DirectRecommendationTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local SharedFlags2 = require(parent.SharedFlags)
local FFlagPymkCarouselExtendProps = SharedFlags2.FFlagPymkCarouselExtendProps

local function useContactsContext(items, options)
	local v

	if FFlagLuaAppEnableSduiHomePage then
		v = options or {}
	elseif FFlagPymkCarouselExtendProps then
		local v2 = useSelector(function(p)
			local localUserId = tostring(p.LocalUserId)
			return roduxFriends.Selectors.selectRecommendationsForUserId(p)(localUserId) or {}
		end, tutils.shallowEqual)
		v = options or v2
	else
		v = useSelector(function(p)
			local localUserId = tostring(p.LocalUserId)
			return roduxFriends.Selectors.selectRecommendationsForUserId(p)(localUserId) or {}
		end, tutils.shallowEqual)
	end

	return (React.useMemo(function()
		local contacts = {}

		for _, item in items do
			if item.recommendationContextType ~= recommendationContextType.Contacts then
				continue
			end

			local id = item.id
			local v2 = v[id]

			if v2 then
				contacts[id] = {
					isLoading = false,
					name = v2.entityDisplayName or "",
					avatarThumbnailUrl = v2.thumbnailEntities and v2.thumbnailEntities.headshotImageUrl or ""
				}
			end
		end

		return { contacts = contacts }
	end, { items, v }))
end

return useContactsContext
