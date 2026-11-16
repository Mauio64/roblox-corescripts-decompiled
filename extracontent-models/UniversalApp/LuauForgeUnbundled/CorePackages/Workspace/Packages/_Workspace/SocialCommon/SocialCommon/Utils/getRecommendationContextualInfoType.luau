local RecommendationContextType = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Enums/RecommendationContextType")
local ContextualInfoTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Enums/ContextualInfoTypes")

local FFlagShowClassmatesOnPYMK = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SharedFlags/FFlagShowClassmatesOnPYMK")

local function getRecommendationContextualInfoType(p2)
	local contextType = p2.contextType
	local v5 = contextType and contextType.rawValue()

	if v5 == RecommendationContextType.MutualFriends.rawValue() then
		return ContextualInfoTypes.MutualFriends
	end

	if v5 == RecommendationContextType.Frequents.rawValue() then
		return ContextualInfoTypes.Frequents
	end

	if v5 == RecommendationContextType.Contacts.rawValue() then
		return ContextualInfoTypes.Contacts
	end

	if FFlagShowClassmatesOnPYMK and v5 == RecommendationContextType.Classmates.rawValue() then
		return ContextualInfoTypes.Classmates
	end

	return nil
end

return getRecommendationContextualInfoType
