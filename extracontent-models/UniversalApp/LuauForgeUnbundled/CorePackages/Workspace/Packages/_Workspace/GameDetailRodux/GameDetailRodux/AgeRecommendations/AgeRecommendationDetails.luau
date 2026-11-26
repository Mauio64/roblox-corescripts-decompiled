local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/Dash")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/t")
local Result = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/Result")

local v5 = {}

function v5.new()
	return {}
end

v5.validateModel = t.interface({
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

function v5.mock(options)
	local v6 = v5.new()

	v6.summary = {
		ageRecommendation = { displayName = "13+", minimumAge = 13 }
	}

	v6.descriptorUsages = {
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
	local joinDeep = Dash.joinDeep(v6, options or {})

	if v5.validateModel(joinDeep) then
		return joinDeep
	end

	return error("AgeRecommendationDetails mockData is invalid")
end

function v5.fromJsonData(p2)
	if not v5.validateModel(p2) then
		return Result.error("AgeRecommendationDetails.fromJsonData expects a valid moderation JSON response")
	end

	local v6 = v5.new()
	local joinDeep = Dash.joinDeep(v6, p2)

	return Result.success(joinDeep)
end

return v5
