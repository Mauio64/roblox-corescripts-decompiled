local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/React")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/tutils")
local useSelector = dependencies.Hooks.useSelector
local roduxFriends = dependencies.RoduxFriends
local recommendationContextType = roduxFriends.Enums.RecommendationContextType
require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/DirectRecommendationTypes")

local fFlagLuaAppEnableSduiHomePage = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SharedFlags").FFlagLuaAppEnableSduiHomePage

local function useContactsContext(items, options)
	local v5 = fFlagLuaAppEnableSduiHomePage and (options or {}) or useSelector(function(p2)
		local localUserId = tostring(p2.LocalUserId)
		return roduxFriends.Selectors.selectRecommendationsForUserId(p2)(localUserId) or {}
	end, tutils.shallowEqual)

	return (React.useMemo(function()
		local v6 = {}

		for k, item in items do
			if item.recommendationContextType ~= recommendationContextType.Contacts then
				continue
			end

			local id = item.id
			local v7 = v5[id]

			if v7 then
				v6[id] = {
					isLoading = false,
					name = v7.entityDisplayName or "",
					avatarThumbnailUrl = v7.thumbnailEntities and v7.thumbnailEntities.headshotImageUrl or ""
				}
			end
		end

		return { contacts = v6 }
	end, { items, v5 }))
end

return useContactsContext
