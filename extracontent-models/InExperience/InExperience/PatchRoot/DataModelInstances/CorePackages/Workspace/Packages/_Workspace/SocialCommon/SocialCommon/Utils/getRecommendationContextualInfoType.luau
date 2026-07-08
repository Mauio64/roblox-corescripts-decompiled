local SocialCommon = script:FindFirstAncestor("SocialCommon")
local RecommendationContextType = require(SocialCommon.Enums.RecommendationContextType)
local ContextualInfoTypes = require(SocialCommon.Enums.ContextualInfoTypes)

local function getRecommendationContextualInfoType(p1) -- line: 11
	-- upvalues: RecommendationContextType (copy), ContextualInfoTypes (copy)
	local v6 = p1.contextType and p1.contextType.rawValue()

	if v6 == RecommendationContextType.MutualFriends.rawValue() then
		return ContextualInfoTypes.MutualFriends
	end

	if v6 == RecommendationContextType.Frequents.rawValue() then
		return ContextualInfoTypes.Frequents
	end

	if v6 == RecommendationContextType.Contacts.rawValue() then
		return ContextualInfoTypes.Contacts
	end

	return nil
end

return getRecommendationContextualInfoType
