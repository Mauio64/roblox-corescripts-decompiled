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

	for _, v20 in t4 do
		if table.find(p1.audiences, v20) then
			return t3[v20]
		end
	end

	return PrivacyType.Private
end
local function getDescriptorDisplayName(p2) -- line: 69
	local v24 = p2 and p2.experienceDescriptorUsages
	local v25 = v24 and v24.items
	local v26 = v25 and v25[1]
	local v27 = v26 and v26.descriptorDisplayName

	if v27 ~= nil and v27 ~= "" then
		return v27
	end

	return nil
end
local function getContentRatingText(p3) -- line: 77
	local v29 = p3 and p3.ageRecommendationDetails
	local v30 = v29 and v29.ageRecommendationSummary
	local v31 = v30 and v30.ageRecommendation

	if v31 == nil then
		return nil
	end

	local displayName = v31.displayName

	if displayName == nil or displayName == "" then
		displayName = v31.contentMaturity
	end

	if displayName == nil or displayName == "" then
		return displayName
	end

	local v33 = v29 and v29.experienceDescriptorUsages
	local v34 = v33 and v33.items
	local v35 = v34 and v34[1]
	local v36 = v35 and v35.descriptorDisplayName
	local v37 = if v36 == nil or v36 == "" then nil else v36

	if v37 ~= nil then
		return `{ displayName } - { v37 }`
	end

	return displayName
end

return {
	AudienceTextByPrivacyType = t1,
	UNKNOWN_AUDIENCE_TEXT = GAME_CONFIGURATION_AUDIENCE_UNKNOWN,
	getAudience = getAudience,
	getAudienceText = function(p4) -- line: 60
		-- upvalues: getAudience (copy), t1 (copy), GAME_CONFIGURATION_AUDIENCE_UNKNOWN (copy)
		if p4 == nil then
			return nil
		end

		local v22 = getAudience(p4)

		if v22 ~= nil then
			return t1[v22]
		end

		return GAME_CONFIGURATION_AUDIENCE_UNKNOWN
	end,
	getContentRatingText = getContentRatingText,
	getContentMaturityText = function(p5, p6, b1: boolean) -- line: 111
		-- upvalues: getContentRatingText (copy)
		if b1 then
			local v51 = p6 and p6.ageRecommendationDetails
			local v52 = v51 and v51.ageRecommendationSummary
			local v53 = v52 and v52.ageRecommendation
			local v54 = v53 and v53.displayName
			local v55 = if v54 == nil or v54 == "" then nil else v54

			if v55 ~= nil then
				local v56 = p6 and p6.ageRecommendationDetails
				local v57 = v56 and v56.experienceDescriptorUsages
				local v58 = v57 and v57[1]
				local v59 = v58 and v58.descriptorDisplayName
				local v60 = if v59 == nil or v59 == "" then nil else v59

				if v60 ~= nil then
					return `{ v55 } - { v60 }`
				end

				return v55
			end
		end

		return (getContentRatingText(p5))
	end,
	getProvisionalRatingText = function(p7) -- line: 95
		local v39 = p7 and p7.ageRecommendationDetails
		local v40 = v39 and v39.ageRecommendationSummary
		local v41 = v40 and v40.ageRecommendation
		local v42 = v41 and v41.displayName

		if v42 ~= nil and v42 ~= "" then
			return v42
		end

		return nil
	end,
	getProvisionalRatingDescriptor = function(p8) -- line: 103
		local v44 = p8 and p8.ageRecommendationDetails
		local v45 = v44 and v44.experienceDescriptorUsages
		local v46 = v45 and v45[1]
		local v47 = v46 and v46.descriptorDisplayName

		if v47 ~= nil and v47 ~= "" then
			return v47
		end

		return nil
	end
}
