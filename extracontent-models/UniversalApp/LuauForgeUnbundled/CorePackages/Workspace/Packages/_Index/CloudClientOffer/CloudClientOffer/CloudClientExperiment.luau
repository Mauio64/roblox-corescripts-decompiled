local function createCloudClientExperiment(object, p2)
	return {
		isTreatment = function()
			if p2 == "" then
				return true
			end

			local success, result = pcall(function()
				return object:GetUserLayerVariables(p2)
			end)

			if success then
				success = type(result) == "table" and result.EnableCloudClientOffer == true
			end

			return success
		end,
		logExposure = function()
			if p2 == "" then
				return
			end

			pcall(function()
				object:LogUserLayerExposure(p2)
			end)
		end
	}
end

return createCloudClientExperiment
