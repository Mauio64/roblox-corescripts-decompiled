local Parent = script:FindFirstAncestor("AmpUpsell").Parent
local Promise = require(Parent.Promise)
local EngineFeature = game:GetEngineFeature("FacialAgeEstimationServiceAvailable")
local v4 = if not EngineFeature then nil else game:GetService("FacialAgeEstimationService")

return {
	isAvailable = function() -- line: 13
		-- upvalues: EngineFeature (copy), v4 (copy)
		return EngineFeature and v4:IsAvailable()
	end,
	startFlow = function(s1: string, s2: string?) -- line: 16
		-- upvalues: Promise (copy), v4 (copy)
		return Promise.new(function(resolve, reject) -- line: 17
			-- upvalues: v4 (copy), s1 (copy), s2 (copy)
			local ok, result = pcall(function() -- line: 18
				-- upvalues: v4 (copy), s1 (copy), s2 (copy)
				return v4:InquiryAsync({
					inquiryId = s1,
					sessionToken = s2
				})
			end)

			if not ok then
				reject(result)

				return
			end

			local resultType = result.resultType

			if resultType == Enum.FacialAgeEstimationResultType.Complete then
				resolve(s1)

				return
			end

			if resultType == Enum.FacialAgeEstimationResultType.Cancel then
				reject({
					resultType = resultType
				})

				return
			end

			if resultType == Enum.FacialAgeEstimationResultType.Error then
				reject({
					resultType = resultType
				})
			end
		end)
	end
}
