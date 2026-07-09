local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)
local SocialCommon = dependencies.SocialCommon
local RoduxUsers = dependencies.RoduxUsers
local transformOmniRecommendationsToActions = require(script.Parent.transformOmniRecommendationsToActions)

require(PYMKCarousel.Common.OmniTypes)

local ContextualInfoTypes = SocialCommon.Enums.ContextualInfoTypes

local function v7(p1) -- line: 10
	-- upvalues: ContextualInfoTypes (copy), RoduxUsers (copy)
	local v9 = if p1.contextType ~= ContextualInfoTypes.Contacts then {
		id = tostring(p1.userId),
		username = p1.userName,
		displayName = p1.displayName
	} else {
		id = p1.ContactId or tostring(p1.userId),
		username = p1.ContactName or "",
		displayName = p1.ContactName or ""
	}

	return RoduxUsers.Actions.UserUpdated(v9)
end

return function(p2) -- line: 25
	-- upvalues: transformOmniRecommendationsToActions (copy), v7 (copy)
	return {
		AddContentMetadata = function(p3) -- line: 27
			return { p3 }
		end,
		AddOmniRecommendations = function(p4) -- line: 32
			-- upvalues: transformOmniRecommendationsToActions (copy), p2 (copy), v7 (copy)
			return transformOmniRecommendationsToActions(p4.recommendations or {}, p2, v7)
		end
	}
end
