local engineFeature = game:GetEngineFeature("FacialAgeEstimationServiceAvailable")
local FacialAgeEstimationService

if engineFeature then
	FacialAgeEstimationService = game:GetService("FacialAgeEstimationService")
else
	FacialAgeEstimationService = nil
end

local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local Promise = require(parent.Promise)
local FFlagAmpV2WizardVerificationDiagnostics = require(AmpV2Wizard.FFlagAmpV2WizardVerificationDiagnostics)
local PersonaInquiryService = {}

function PersonaInquiryService.isAvailable()
	return engineFeature and FacialAgeEstimationService:IsAvailable()
end

function PersonaInquiryService.startInquiry(inquiryId: string)
	return Promise.new(function(callback, callback2)
		local success, result = pcall(function()
			return FacialAgeEstimationService:InquiryAsync({ inquiryId = inquiryId })
		end)

		if not success then
			callback2(result)
		elseif FFlagAmpV2WizardVerificationDiagnostics then
			callback({ resultType = result.resultType, debugMessage = result.debugMessage })
		else
			callback(result.resultType)
		end
	end)
end

return PersonaInquiryService
