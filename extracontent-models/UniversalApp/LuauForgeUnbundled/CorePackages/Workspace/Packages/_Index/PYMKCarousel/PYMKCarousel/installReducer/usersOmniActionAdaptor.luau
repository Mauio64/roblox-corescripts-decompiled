local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")

local socialCommon = dependencies.SocialCommon
local roduxUsers = dependencies.RoduxUsers
local transformOmniRecommendationsToActions = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/installReducer/transformOmniRecommendationsToActions")
require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/OmniTypes")
local contextualInfoTypes = socialCommon.Enums.ContextualInfoTypes

local function fn(data)
	local v5 = if data.contextType == contextualInfoTypes.Contacts then {
		id = data.ContactId or tostring(data.userId),
		username = data.ContactName or "",
		displayName = data.ContactName or ""
	} else {
		id = tostring(data.userId),
		username = data.userName,
		displayName = data.displayName
	}

	return roduxUsers.Actions.UserUpdated(v5)
end

return function(p2)
	return {
		AddContentMetadata = function(p3)
			return { p3 }
		end,
		AddOmniRecommendations = function(p3)
			return transformOmniRecommendationsToActions(p3.recommendations or {}, p2, fn)
		end
	}
end
