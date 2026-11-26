local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/Dash")

local entityType = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/UserList").Enums.EntityType

local recommendationContextType = dependencies.RoduxFriends.Enums.RecommendationContextType
require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/DirectRecommendationTypes")

local function usePYMKCarouselUserEntitiesList(p2)
	return React.useMemo(function()
		return Dash.map(Dash.filter(p2, function(p3): boolean
			return not (p3.isButtonTile or p3.isTooltip)
		end), function(p3)
			local v5 = { id = p3.id, type = 0 }
			local v6 = if p3.recommendationContextType == recommendationContextType.Contacts then entityType.Contact else entityType.User
			v5.type = v6
			return v5
		end)
	end, { p2 })
end

return usePYMKCarouselUserEntitiesList
