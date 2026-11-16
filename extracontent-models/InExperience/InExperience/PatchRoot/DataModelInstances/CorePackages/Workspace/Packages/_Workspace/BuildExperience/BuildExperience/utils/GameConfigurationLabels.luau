local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(parent.DataHydration.ExperienceGuidelines)
require(parent.DataHydration.UniverseActivation)
local UniverseConfiguration = require(parent.DataHydration.UniverseConfiguration)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local PrivacyType = UniverseConfiguration.PrivacyType

local GAME_CONFIGURATION_AUDIENCE_PUBLIC = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PUBLIC
local GAME_CONFIGURATION_AUDIENCE_FRIENDS_ONLY = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_FRIENDS_ONLY
local GAME_CONFIGURATION_AUDIENCE_PRIVATE = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_PRIVATE
local GAME_CONFIGURATION_AUDIENCE_UNKNOWN = LocalizationStrings.GAME_CONFIGURATION_AUDIENCE_UNKNOWN

local audienceTextByPrivacyType = {
	[PrivacyType.Public] = GAME_CONFIGURATION_AUDIENCE_PUBLIC,
	[PrivacyType.FriendsOnly] = GAME_CONFIGURATION_AUDIENCE_FRIENDS_ONLY,
	[PrivacyType.Private] = GAME_CONFIGURATION_AUDIENCE_PRIVATE
}

local v = {
	[PrivacyType.Public] = PrivacyType.Public,
	[PrivacyType.FriendsOnly] = PrivacyType.FriendsOnly,
	[PrivacyType.Private] = PrivacyType.Private
}

local function getAudience(p) -- 1 equivalent call inferred from this helper
	if p == nil then
		return nil
	end

	if p.audiences ~= nil then
		return UniverseConfiguration.getPrivacyTypeForAudiences(p.audiences)
	end

	local privacyType = p.privacyType

	if privacyType == nil then
		return nil
	end

	return v[privacyType]
end

local function getDescriptorDisplayName(ageRecommendationDetails) -- 1 equivalent call inferred from this helper
	local experienceDescriptorUsages = ageRecommendationDetails and ageRecommendationDetails.experienceDescriptorUsages
	local items = experienceDescriptorUsages and experienceDescriptorUsages.items
	local v2 = items and items[1]
	local descriptorDisplayName = v2 and v2.descriptorDisplayName

	if descriptorDisplayName == nil or descriptorDisplayName == "" then
		return nil
	end

	return descriptorDisplayName
end

local function getContentRatingText(p)
	local ageRecommendationDetails = p and p.ageRecommendationDetails
	local ageRecommendationSummary = ageRecommendationDetails and ageRecommendationDetails.ageRecommendationSummary
	local ageRecommendation = ageRecommendationSummary and ageRecommendationSummary.ageRecommendation

	if ageRecommendation == nil then
		return nil
	end

	local v2 = ageRecommendation.displayName

	if v2 == nil or v2 == "" then
		v2 = ageRecommendation.contentMaturity
	end

	if v2 == nil or v2 == "" then
		return v2
	end

	local descriptorDisplayName = getDescriptorDisplayName(ageRecommendationDetails) -- inferred equivalent call

	if descriptorDisplayName == nil then
		return v2
	end

	return `{v2} - {descriptorDisplayName}`
end

local function getProvisionalRatingText(p) -- 1 equivalent call inferred from this helper
	local ageRecommendationDetails = p and p.ageRecommendationDetails
	local ageRecommendationSummary = ageRecommendationDetails and ageRecommendationDetails.ageRecommendationSummary
	local ageRecommendation = ageRecommendationSummary and ageRecommendationSummary.ageRecommendation
	local displayName = ageRecommendation and ageRecommendation.displayName

	if displayName == nil or displayName == "" then
		return nil
	end

	return displayName
end

local function getProvisionalRatingDescriptor(p) -- 1 equivalent call inferred from this helper
	local ageRecommendationDetails = p and p.ageRecommendationDetails
	local experienceDescriptorUsages = ageRecommendationDetails and ageRecommendationDetails.experienceDescriptorUsages
	local v2 = experienceDescriptorUsages and experienceDescriptorUsages[1]
	local descriptorDisplayName = v2 and v2.descriptorDisplayName

	if descriptorDisplayName == nil or descriptorDisplayName == "" then
		return nil
	end

	return descriptorDisplayName
end

local GameConfigurationLabels = {}
GameConfigurationLabels.AudienceTextByPrivacyType = audienceTextByPrivacyType
GameConfigurationLabels.UNKNOWN_AUDIENCE_TEXT = GAME_CONFIGURATION_AUDIENCE_UNKNOWN
GameConfigurationLabels.getAudience = getAudience

function GameConfigurationLabels.getAudienceText(p)
	if p == nil then
		return nil
	end

	local audience = getAudience(p) -- inferred equivalent call

	if audience == nil then
		return nil
	end

	return audienceTextByPrivacyType[audience]
end

GameConfigurationLabels.getContentRatingText = getContentRatingText

function GameConfigurationLabels.getContentMaturityText(p, p2, flag: boolean)
	if flag then
		local provisionalRatingText = getProvisionalRatingText(p2) -- inferred equivalent call

		if provisionalRatingText ~= nil then
			local provisionalRatingDescriptor = getProvisionalRatingDescriptor(p2) -- inferred equivalent call

			if provisionalRatingDescriptor == nil then
				return provisionalRatingText
			end

			return `{provisionalRatingText} - {provisionalRatingDescriptor}`
		end
	end

	return getContentRatingText(p)
end

GameConfigurationLabels.getProvisionalRatingText = getProvisionalRatingText
GameConfigurationLabels.getProvisionalRatingDescriptor = getProvisionalRatingDescriptor
return GameConfigurationLabels
