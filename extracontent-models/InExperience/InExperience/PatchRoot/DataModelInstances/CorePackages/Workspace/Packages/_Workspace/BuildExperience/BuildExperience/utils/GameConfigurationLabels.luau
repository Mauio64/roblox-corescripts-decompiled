local Parent = script:FindFirstAncestor("BuildExperience").Parent

require(Parent.DataHydration.ExperienceGuidelines)

local UniverseActivation = require(Parent.DataHydration.UniverseActivation)

require(Parent.DataHydration.UniverseConfiguration)

local t1 = {
	Public = "Public",
	FriendsOnly = "Friends only",
	Private = "Private"
}
local t2 = {
	[UniverseActivation.Audience.Public] = "Public",
	[UniverseActivation.Audience.Friends] = "Friends only"
}
local t3 = {
	UniverseActivation.Audience.Public,
	UniverseActivation.Audience.Friends
}

local function getAudienceTextFromAudiences(t4: {[any]: any}) -- line: 32
	-- upvalues: t3 (copy), t2 (copy)
	for _, v9 in t3 do
		if table.find(t4, v9) then
			return t2[v9]
		end
	end

	return "Private"
end

return {
	UNKNOWN_AUDIENCE_TEXT = "Unknown",
	AudienceTextByPrivacyType = t1,
	getAudienceText = function(p1) -- line: 42
		-- upvalues: getAudienceTextFromAudiences (copy), t1 (copy)
		if p1 == nil then
			return nil
		end

		if p1.audiences ~= nil then
			return (getAudienceTextFromAudiences(p1.audiences))
		end

		return t1[p1.privacyType] or "Unknown"
	end,
	getContentRatingText = function(p2) -- line: 58
		local v13 = p2 and p2.ageRecommendationDetails
		local v14 = v13 and v13.ageRecommendationSummary
		local v15 = v14 and v14.ageRecommendation

		return v15 and v15.contentMaturity
	end,
	isPrivateAudience = function(p3) -- line: 54
		-- upvalues: getAudienceTextFromAudiences (copy), t1 (copy)
		return ((if p3 ~= nil then (if p3.audiences == nil then t1[p3.privacyType] or "Unknown" else getAudienceTextFromAudiences(p3.audiences)) else nil)) == "Private"
	end
}
