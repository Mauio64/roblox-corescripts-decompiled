require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/ExperienceGuidelines")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseActivation")
local UniverseConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseConfiguration")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local privacyType = UniverseConfiguration.PrivacyType

local GAME_CONFIGURATION_AUDIENCE_PUBLIC = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PUBLIC
local GAME_CONFIGURATION_AUDIENCE_FRIENDS_ONLY = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_FRIENDS_ONLY
local GAME_CONFIGURATION_AUDIENCE_PRIVATE = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PRIVATE
local GAME_CONFIGURATION_AUDIENCE_UNKNOWN = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_UNKNOWN

local v5 = {
	[privacyType.Public] = GAME_CONFIGURATION_AUDIENCE_PUBLIC,
	[privacyType.FriendsOnly] = GAME_CONFIGURATION_AUDIENCE_FRIENDS_ONLY,
	[privacyType.Private] = GAME_CONFIGURATION_AUDIENCE_PRIVATE
}

local v6 = {
	[privacyType.Public] = privacyType.Public,
	[privacyType.FriendsOnly] = privacyType.FriendsOnly,
	[privacyType.Private] = privacyType.Private
}

local function getDescriptorDisplayName(p2)
	local experienceDescriptorUsages = p2 and p2.experienceDescriptorUsages
	local items = experienceDescriptorUsages and experienceDescriptorUsages.items
	local v7 = items and items[1]
	local descriptorDisplayName = v7 and v7.descriptorDisplayName

	if descriptorDisplayName == nil or descriptorDisplayName == "" then
		return nil
	end

	return descriptorDisplayName
end

local function getContentRatingText(p2)
	local ageRecommendationDetails = p2 and p2.ageRecommendationDetails
	local ageRecommendationSummary = ageRecommendationDetails
		and ageRecommendationDetails.ageRecommendationSummary
	local ageRecommendation = ageRecommendationSummary and ageRecommendationSummary.ageRecommendation

	if ageRecommendation == nil then
		return nil
	end

	local v7 = ageRecommendation.displayName

	if v7 == nil or v7 == "" then
		v7 = ageRecommendation.contentMaturity
	end

	if v7 == nil or v7 == "" then
		return v7
	end

	local experienceDescriptorUsages = ageRecommendationDetails
		and ageRecommendationDetails.experienceDescriptorUsages
	local items = experienceDescriptorUsages and experienceDescriptorUsages.items
	local v8 = items and items[1]
	local descriptorDisplayName = v8 and v8.descriptorDisplayName

	if descriptorDisplayName == nil or descriptorDisplayName == "" then
		descriptorDisplayName = nil
	end

	if descriptorDisplayName == nil then
		return v7
	end

	return `{v7} - {descriptorDisplayName}`
end

return {
	AudienceTextByPrivacyType = v5,
	UNKNOWN_AUDIENCE_TEXT = GAME_CONFIGURATION_AUDIENCE_UNKNOWN,
	getAudience = function(p2)
		if p2 == nil then
			return nil
		end

		if p2.audiences ~= nil then
			return UniverseConfiguration.getPrivacyTypeForAudiences(p2.audiences)
		end

		local privacyType2 = p2.privacyType

		if privacyType2 == nil then
			return nil
		end

		return v6[privacyType2]
	end,
	getAudienceText = function(p2)
		if p2 == nil then
			return nil
		end

		local v7

		if p2 ~= nil then
			if p2.audiences == nil then
				local privacyType2 = p2.privacyType

				if privacyType2 ~= nil then
					v7 = v6[privacyType2]
				end
			else
				v7 = UniverseConfiguration.getPrivacyTypeForAudiences(p2.audiences)
			end
		end

		if v7 == nil then
			return nil
		end

		return v5[v7]
	end,
	getContentRatingText = getContentRatingText,
	getContentMaturityText = function(p2, p3, p4)
		if p4 then
			local ageRecommendationDetails = p3 and p3.ageRecommendationDetails
			local ageRecommendationSummary = ageRecommendationDetails
				and ageRecommendationDetails.ageRecommendationSummary
			local ageRecommendation = ageRecommendationSummary
				and ageRecommendationSummary.ageRecommendation
			local displayName = ageRecommendation and ageRecommendation.displayName

			if displayName == nil or displayName == "" then
				displayName = nil
			end

			if displayName ~= nil then
				local ageRecommendationDetails2 = p3 and p3.ageRecommendationDetails
				local experienceDescriptorUsages = ageRecommendationDetails2
					and ageRecommendationDetails2.experienceDescriptorUsages
				local v7 = experienceDescriptorUsages and experienceDescriptorUsages[1]
				local descriptorDisplayName = v7 and v7.descriptorDisplayName

				if descriptorDisplayName == nil or descriptorDisplayName == "" then
					descriptorDisplayName = nil
				end

				if descriptorDisplayName == nil then
					return displayName
				end

				return `{displayName} - {descriptorDisplayName}`
			end
		end

		return getContentRatingText(p2)
	end,
	getProvisionalRatingText = function(p2)
		local ageRecommendationDetails = p2 and p2.ageRecommendationDetails
		local ageRecommendationSummary = ageRecommendationDetails
			and ageRecommendationDetails.ageRecommendationSummary
		local ageRecommendation = ageRecommendationSummary and ageRecommendationSummary.ageRecommendation
		local displayName = ageRecommendation and ageRecommendation.displayName

		if displayName == nil or displayName == "" then
			return nil
		end

		return displayName
	end,
	getProvisionalRatingDescriptor = function(p2)
		local ageRecommendationDetails = p2 and p2.ageRecommendationDetails
		local experienceDescriptorUsages = ageRecommendationDetails
			and ageRecommendationDetails.experienceDescriptorUsages
		local v7 = experienceDescriptorUsages and experienceDescriptorUsages[1]
		local descriptorDisplayName = v7 and v7.descriptorDisplayName

		if descriptorDisplayName == nil or descriptorDisplayName == "" then
			return nil
		end

		return descriptorDisplayName
	end
}
