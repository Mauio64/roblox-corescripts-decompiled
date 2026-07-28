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

local function getAudience(p1) -- line: 42
	-- upvalues: t2 (copy), t4 (copy), t3 (copy), PrivacyType (copy)
	if p1 == nil then
		return nil
	end

	if p1.audiences == nil then
		return t2[p1.privacyType]
	end

	for _, v19 in t4 do
		if table.find(p1.audiences, v19) then
			return t3[v19]
		end
	end

	return PrivacyType.Private
end
local function getDescriptorDisplayName(p2) -- line: 69
	local v23 = p2 and p2.experienceDescriptorUsages
	local v24 = v23 and v23.items
	local v25 = v24 and v24[1]
	local v26 = v25 and v25.descriptorDisplayName

	if v26 ~= nil and v26 ~= "" then
		return v26
	end

	return nil
end

return {
	AudienceTextByPrivacyType = t1,
	UNKNOWN_AUDIENCE_TEXT = GAME_CONFIGURATION_AUDIENCE_UNKNOWN,
	getAudience = getAudience,
	getAudienceText = function(p3) -- line: 60
		-- upvalues: getAudience (copy), t1 (copy), GAME_CONFIGURATION_AUDIENCE_UNKNOWN (copy)
		if p3 == nil then
			return nil
		end

		local v21 = getAudience(p3)

		if v21 ~= nil then
			return t1[v21]
		end

		return GAME_CONFIGURATION_AUDIENCE_UNKNOWN
	end,
	getContentRatingText = function(p4) -- line: 77
		local v28 = p4 and p4.ageRecommendationDetails
		local v29 = v28 and v28.ageRecommendationSummary
		local v30 = v29 and v29.ageRecommendation

		if v30 == nil then
			return nil
		end

		local displayName = v30.displayName

		if displayName == nil or displayName == "" then
			displayName = v30.contentMaturity
		end

		if displayName == nil or displayName == "" then
			return displayName
		end

		local v32 = v28 and v28.experienceDescriptorUsages
		local v33 = v32 and v32.items
		local v34 = v33 and v33[1]
		local v35 = v34 and v34.descriptorDisplayName
		local v36 = if v35 == nil or v35 == "" then nil else v35

		if v36 ~= nil then
			return `{ displayName } - { v36 }`
		end

		return displayName
	end,
	getProvisionalRatingText = function(p5) -- line: 95
		local v38 = p5 and p5.ageRecommendationDetails
		local v39 = v38 and v38.ageRecommendationSummary
		local v40 = v39 and v39.ageRecommendation
		local v41 = v40 and v40.displayName

		if v41 ~= nil and v41 ~= "" then
			return v41
		end

		return nil
	end,
	getProvisionalRatingDescriptor = function(p6) -- line: 103
		local v43 = p6 and p6.ageRecommendationDetails
		local v44 = v43 and v43.experienceDescriptorUsages
		local v45 = v44 and v44[1]
		local v46 = v45 and v45.descriptorDisplayName

		if v46 ~= nil and v46 ~= "" then
			return v46
		end

		return nil
	end
}
