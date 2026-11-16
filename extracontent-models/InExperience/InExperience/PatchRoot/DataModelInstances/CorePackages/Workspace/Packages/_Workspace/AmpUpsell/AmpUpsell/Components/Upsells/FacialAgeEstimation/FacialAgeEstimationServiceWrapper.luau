local parent = script:FindFirstAncestor("AmpUpsell").Parent

local Promise = require(parent.Promise)

local engineFeature = game:GetEngineFeature("FacialAgeEstimationServiceAvailable")
local FacialAgeEstimationService

if engineFeature then
	FacialAgeEstimationService = game:GetService("FacialAgeEstimationService")
else
	FacialAgeEstimationService = nil
end

local FacialAgeEstimationServiceWrapper = {}

function FacialAgeEstimationServiceWrapper.isAvailable()
	return engineFeature and FacialAgeEstimationService:IsAvailable()
end

function FacialAgeEstimationServiceWrapper.startFlow(inquiryId: string, sessionToken: string?)
	return Promise.new(function(callback, callback2)
		local success, result = pcall(function()
			return FacialAgeEstimationService:InquiryAsync({
				inquiryId = inquiryId,
				sessionToken = sessionToken
			})
		end)

		if not success then
			callback2(result)
			return
		end

		local resultType = result.resultType

		if resultType == Enum.FacialAgeEstimationResultType.Complete then
			callback(inquiryId)
		elseif resultType == Enum.FacialAgeEstimationResultType.Cancel then
			callback2({ resultType = resultType })
		elseif resultType == Enum.FacialAgeEstimationResultType.Error then
			callback2({ resultType = resultType })
		end
	end)
end

return FacialAgeEstimationServiceWrapper
