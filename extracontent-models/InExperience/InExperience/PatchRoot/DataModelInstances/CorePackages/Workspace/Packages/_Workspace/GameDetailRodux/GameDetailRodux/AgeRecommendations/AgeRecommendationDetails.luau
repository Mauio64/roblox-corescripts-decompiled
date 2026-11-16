local parent = script:FindFirstAncestor("GameDetailRodux").Parent

local Dash = require(parent.Dash)
local t = require(parent.t)
local Result = require(parent.Result)

local AgeRecommendationDetails = {}

function AgeRecommendationDetails.new()
	return {}
end

AgeRecommendationDetails.validateModel = t.interface({
	summary = t.interface({
		ageRecommendation = t.optional(t.interface({
			displayName = t.optional(t.string),
			displayNameWithHeaderShort = t.optional(t.string),
			minimumAge = t.number,
			minimumAgeDisplay = t.optional(t.string),
			contentMaturity = t.optional(t.string),
			igrsRating = t.optional(t.string),
			igrsRatingDisplayMessage = t.optional(t.string)
		}))
	}),
	descriptorUsages = t.optional(t.array(t.interface({
		name = t.optional(t.string),
		followsComplianceApi = t.optional(t.boolean),
		descriptor = t.interface({
			name = t.string,
			displayName = t.string,
			complianceApiSupported = t.boolean,
			iconUrl = t.optional(t.string),
			localeCode = t.optional(t.string)
		}),
		descriptorDimensionUsages = t.optional(t.array(t.interface({
			dimensionName = t.optional(t.string),
			dimensionValue = t.optional(t.string)
		})))
	})))
})

function AgeRecommendationDetails.mock(options)
	local v = AgeRecommendationDetails.new()

	v.summary = {
		ageRecommendation = { displayName = "13+", minimumAge = 13 }
	}

	v.descriptorUsages = {
		{
			descriptor = {
				complianceApiSupported = false,
				displayName = "Blood",
				iconUrl = "https://images.rbxcdn.com/blood-icon.svg",
				name = "blood"
			},
			descriptorDimensionUsages = {
				{ dimensionName = "realism", dimensionValue = "unrealistic" },
				{ dimensionName = "blood-level", dimensionValue = "heavy" }
			},
			name = "blood"
		},
		{
			descriptor = {
				complianceApiSupported = false,
				displayName = "Violence",
				iconUrl = "https://images.rbxcdn.com/violence-icon.svg",
				name = "violence"
			},
			descriptorDimensionUsages = {
				{ dimensionName = "intensity", dimensionValue = "mild" },
				{ dimensionName = "frequency", dimensionValue = "infrequent" }
			},
			name = "violence"
		}
	}
	local joinDeep = Dash.joinDeep(v, options or {})

	if AgeRecommendationDetails.validateModel(joinDeep) then
		return joinDeep
	end

	return error("AgeRecommendationDetails mockData is invalid")
end

function AgeRecommendationDetails.fromJsonData(p)
	if not AgeRecommendationDetails.validateModel(p) then
		return Result.error("AgeRecommendationDetails.fromJsonData expects a valid moderation JSON response")
	end

	local v = AgeRecommendationDetails.new()
	local joinDeep = Dash.joinDeep(v, p)

	return Result.success(joinDeep)
end

return AgeRecommendationDetails
