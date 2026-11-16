local SocialCommon = script:FindFirstAncestor("SocialCommon")
local RecommendationContextType = require(SocialCommon.Enums.RecommendationContextType)
local ContextualInfoTypes = require(SocialCommon.Enums.ContextualInfoTypes)
local parent = SocialCommon.Parent
local FFlagShowClassmatesOnPYMK = require(parent.SharedFlags.FFlagShowClassmatesOnPYMK)

local function getRecommendationContextualInfoType(p)
	local contextType = p.contextType
	local v = contextType and contextType.rawValue()

	if v == RecommendationContextType.MutualFriends.rawValue() then
		return ContextualInfoTypes.MutualFriends
	end

	if v == RecommendationContextType.Frequents.rawValue() then
		return ContextualInfoTypes.Frequents
	end

	if v == RecommendationContextType.Contacts.rawValue() then
		return ContextualInfoTypes.Contacts
	end

	if FFlagShowClassmatesOnPYMK and v == RecommendationContextType.Classmates.rawValue() then
		return ContextualInfoTypes.Classmates
	end

	return nil
end

return getRecommendationContextualInfoType
