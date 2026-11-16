local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)

local socialCommon = dependencies.SocialCommon
local roduxUsers = dependencies.RoduxUsers
local transformOmniRecommendationsToActions = require(script.Parent.transformOmniRecommendationsToActions)
require(PYMKCarousel.Common.OmniTypes)
local contextualInfoTypes = socialCommon.Enums.ContextualInfoTypes

local function fn(data)
	local v

	if data.contextType == contextualInfoTypes.Contacts then
		v = {
			id = data.ContactId or tostring(data.userId),
			username = data.ContactName or "",
			displayName = data.ContactName or ""
		}
	else
		v = { id = tostring(data.userId), username = data.userName, displayName = data.displayName }
	end

	return roduxUsers.Actions.UserUpdated(v)
end

return function(p)
	return {
		AddContentMetadata = function(p2)
			return { p2 }
		end,
		AddOmniRecommendations = function(p2)
			return transformOmniRecommendationsToActions(p2.recommendations or {}, p, fn)
		end
	}
end
