local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Promise")

local engineFeature = game:GetEngineFeature("FacialAgeEstimationServiceAvailable")

local FacialAgeEstimationService = if engineFeature then game:GetService("FacialAgeEstimationService") else nil

return {
	isAvailable = function()
		return engineFeature and FacialAgeEstimationService:IsAvailable()
	end,
	startFlow = function(p2, p3)
		return Promise.new(function(callback, callback2)
			local success, result = pcall(function()
				return FacialAgeEstimationService:InquiryAsync({
					inquiryId = p2,
					sessionToken = p3
				})
			end)

			if not success then
				callback2(result)
				return
			end

			local resultType = result.resultType

			if resultType == Enum.FacialAgeEstimationResultType.Complete then
				callback(p2)
			elseif resultType == Enum.FacialAgeEstimationResultType.Cancel then
				callback2({ resultType = resultType })
			elseif resultType == Enum.FacialAgeEstimationResultType.Error then
				callback2({ resultType = resultType })
			end
		end)
	end
}
