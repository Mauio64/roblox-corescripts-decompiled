local function createCloudClientExperiment(object, p: string)
	return {
		isTreatment = function()
			if p == "" then
				return true
			end

			local success, result = pcall(function()
				return object:GetUserLayerVariables(p)
			end)

			if success then
				if type(result) == "table" then
					success = result.EnableCloudClientOffer == true
				else
					success = false
				end
			end

			return success
		end,
		logExposure = function()
			if p == "" then
				return
			end

			pcall(function()
				object:LogUserLayerExposure(p)
			end)
		end
	}
end

return createCloudClientExperiment
