local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
local parent2 = parent.Parent
local React = require(parent2.React)
local Dash = require(parent2.Dash)

local UserList = require(parent2.UserList)

local EntityType = UserList.Enums.EntityType

local recommendationContextType = dependencies.RoduxFriends.Enums.RecommendationContextType
require(parent.Common.DirectRecommendationTypes)

local function usePYMKCarouselUserEntitiesList(p)
	return React.useMemo(function()
		return Dash.map(Dash.filter(p, function(p2): boolean
			return not (p2.isButtonTile or p2.isTooltip)
		end), function(p2)
			local v = { id = p2.id, type = 0 }
			local v2

			if p2.recommendationContextType == recommendationContextType.Contacts then
				v2 = EntityType.Contact
			else
				v2 = EntityType.User
			end

			v.type = v2
			return v
		end)
	end, { p })
end

return usePYMKCarouselUserEntitiesList
