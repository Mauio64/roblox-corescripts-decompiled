local engineFeature = game:GetEngineFeature("FacialAgeEstimationServiceAvailable")

local FacialAgeEstimationService = if engineFeature then game:GetService("FacialAgeEstimationService") else nil

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Promise")
local FFlagAmpV2WizardVerificationDiagnostics = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FFlagAmpV2WizardVerificationDiagnostics")

return {
	isAvailable = function()
		return engineFeature and FacialAgeEstimationService:IsAvailable()
	end,
	startInquiry = function(p2)
		return Promise.new(function(callback, callback2)
			local success, result = pcall(function()
				return FacialAgeEstimationService:InquiryAsync({ inquiryId = p2 })
			end)

			if not success then
				callback2(result)
			elseif FFlagAmpV2WizardVerificationDiagnostics then
				callback({
					resultType = result.resultType,
					debugMessage = result.debugMessage
				})
			else
				callback(result.resultType)
			end
		end)
	end
}
