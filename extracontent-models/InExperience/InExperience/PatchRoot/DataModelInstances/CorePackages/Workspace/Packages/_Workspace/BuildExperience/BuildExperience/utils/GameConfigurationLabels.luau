local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent

require(BuildExperienceParent.DataHydration.ExperienceGuidelines)

local UniverseActivation = require(BuildExperienceParent.DataHydration.UniverseActivation)
local UniverseConfiguration = require(BuildExperienceParent.DataHydration.UniverseConfiguration)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local PrivacyType = UniverseConfiguration.PrivacyType
local GAME_CONFIGURATION_AUDIENCE_PUBLIC = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PUBLIC
local GAME_CONFIGURATION_AUDIENCE_FRIENDS_ONLY = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_FRIENDS_ONLY
local GAME_CONFIGURATION_AUDIENCE_PRIVATE = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PRIVATE
local GAME_CONFIGURATION_AUDIENCE_UNKNOWN = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_UNKNOWN
local t1 = {
	[PrivacyType.Public] = GAME_CONFIGURATION_AUDIENCE_PUBLIC,
	[PrivacyType.FriendsOnly] = GAME_CONFIGURATION_AUDIENCE_FRIENDS_ONLY,
	[PrivacyType.Private] = GAME_CONFIGURATION_AUDIENCE_PRIVATE
}
local t2 = {
	[PrivacyType.Public] = PrivacyType.Public,
	[PrivacyType.FriendsOnly] = PrivacyType.FriendsOnly,
	[PrivacyType.Private] = PrivacyType.Private
}
local t3 = {
	[UniverseActivation.Audience.Public] = PrivacyType.Public,
	[UniverseActivation.Audience.Friends] = PrivacyType.FriendsOnly
}
local t4 = {
	UniverseActivation.Audience.Public,
	UniverseActivation.Audience.Friends
}

local function getAudience(p1) -- line: 41
	-- upvalues: t2 (copy), t4 (copy), t3 (copy), PrivacyType (copy)
	if p1 == nil then
		return nil
	end

	if p1.audiences == nil then
		return t2[p1.privacyType]
	end

	for _, v18 in t4 do
		if table.find(p1.audiences, v18) then
			return t3[v18]
		end
	end

	return PrivacyType.Private
end

return {
	AudienceTextByPrivacyType = t1,
	UNKNOWN_AUDIENCE_TEXT = GAME_CONFIGURATION_AUDIENCE_UNKNOWN,
	getAudience = getAudience,
	getAudienceText = function(p2) -- line: 59
		-- upvalues: getAudience (copy), t1 (copy), GAME_CONFIGURATION_AUDIENCE_UNKNOWN (copy)
		if p2 == nil then
			return nil
		end

		local v20 = getAudience(p2)

		if v20 ~= nil then
			return t1[v20]
		end

		return GAME_CONFIGURATION_AUDIENCE_UNKNOWN
	end,
	getContentRatingText = function(p3) -- line: 68
		local v22 = p3 and p3.ageRecommendationDetails
		local v23 = v22 and v22.ageRecommendationSummary
		local v24 = v23 and v23.ageRecommendation

		return v24 and v24.contentMaturity
	end
}
