local function normalizeGenerationStatus(data)
	if type(data) ~= "table" then
		return nil, `GenerationStatus: type table required, got {type(data)}.`
	end

	if type(data.generationId) ~= "string" then
		return nil, "GenerationStatus: generationId field is required and must be a string."
	end

	if type(data.status) == "string" then
		return {
			generationId = data.generationId,
			status = data.status,
			presignedUrl = data.presignedUrl,
			failureReason = data.failureReason,
			imageGenerationId = data.imageGenerationId
		}, nil
	end

	return nil, "GenerationStatus: status field is required and must be a string."
end

return normalizeGenerationStatus
