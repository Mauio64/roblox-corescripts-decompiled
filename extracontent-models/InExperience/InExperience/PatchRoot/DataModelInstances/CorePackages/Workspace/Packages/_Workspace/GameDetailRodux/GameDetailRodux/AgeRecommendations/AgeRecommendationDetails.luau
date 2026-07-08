local Parent = script:FindFirstAncestor("GameDetailRodux").Parent
local Dash = require(Parent.Dash)
local t = require(Parent.t)
local Result = require(Parent.Result)
local t1 = {
	new = function() -- line: 47
		return {}
	end,
	validateModel = t.interface({
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
}

function t1.mock(p1) -- line: 80
	-- upvalues: t1 (copy), Dash (copy)
	local v7 = p1 or {}
	local v8 = t1.new()

	v8.summary = {
		ageRecommendation = {
			displayName = "13+",
			minimumAge = 13
		}
	}
	v8.descriptorUsages = {
		[1] = {
			name = "blood",
			descriptor = {
				complianceApiSupported = false,
				displayName = "Blood",
				iconUrl = "https://images.rbxcdn.com/blood-icon.svg",
				name = "blood"
			},
			descriptorDimensionUsages = {
				[1] = {
					dimensionName = "realism",
					dimensionValue = "unrealistic"
				},
				[2] = {
					dimensionName = "blood-level",
					dimensionValue = "heavy"
				}
			}
		},
		[2] = {
			name = "violence",
			descriptor = {
				complianceApiSupported = false,
				displayName = "Violence",
				iconUrl = "https://images.rbxcdn.com/violence-icon.svg",
				name = "violence"
			},
			descriptorDimensionUsages = {
				[1] = {
					dimensionName = "intensity",
					dimensionValue = "mild"
				},
				[2] = {
					dimensionName = "frequency",
					dimensionValue = "infrequent"
				}
			}
		}
	}

	local v9 = Dash.joinDeep(v8, v7)

	if not t1.validateModel(v9) then
		return error("AgeRecommendationDetails mockData is invalid")
	end

	return v9
end
function t1.fromJsonData(p2) -- line: 140
	-- upvalues: t1 (copy), Result (copy), Dash (copy)
	if not t1.validateModel(p2) then
		return Result.error("AgeRecommendationDetails.fromJsonData expects a valid moderation JSON response")
	end

	local v11 = t1.new()
	local v12 = Dash.joinDeep(v11, p2)

	return Result.success(v12)
end

return t1
