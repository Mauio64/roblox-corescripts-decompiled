local ParentParent = script.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Dash = require(ParentParentParent.Dash)
local EntityType = require(ParentParentParent.UserList).Enums.EntityType
local RecommendationContextType = dependencies.RoduxFriends.Enums.RecommendationContextType

local function usePYMKCarouselUserEntitiesList(t1: {[any]: any}) -- line: 23
	-- upvalues: React (copy), Dash (copy), RecommendationContextType (copy), EntityType (copy)
	return React.useMemo(function() -- line: 24
		-- upvalues: Dash (copy), t1 (copy), RecommendationContextType (copy), EntityType (copy)
		return Dash.map(Dash.filter(t1, function(p1) -- line: 26
			return not p1.isButtonTile and not p1.isTooltip
		end), function(p2) -- line: 30
			-- upvalues: RecommendationContextType (copy), EntityType (copy)
			return {
				id = p2.id,
				type = if p2.recommendationContextType ~= RecommendationContextType.Contacts then EntityType.User else EntityType.Contact
			}
		end)
	end, { t1 })
end

return usePYMKCarouselUserEntitiesList
