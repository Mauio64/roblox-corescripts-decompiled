local engineFeature = game:GetEngineFeature("FacialAgeEstimationServiceAvailable")

local FacialAgeEstimationService = if engineFeature then game:GetService("FacialAgeEstimationService") else nil

local module = require("@luauforge/bundled/gvg")
local module2 = require("@luauforge/bundled/gwf")

return {
	isAvailable = function()
		return engineFeature and FacialAgeEstimationService:IsAvailable()
	end,
	startInquiry = function(p2)
		return module.new(function(callback, callback2)
			local success, result = pcall(function()
				return FacialAgeEstimationService:InquiryAsync({ inquiryId = p2 })
			end)

			if not success then
				callback2(result)
			elseif module2 then
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
