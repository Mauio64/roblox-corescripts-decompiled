local function normalizeGenerateBackgroundResponse(p2)
	if type(p2) ~= "table" then
		return nil, `GenerateBackground: type table required, got {type(p2)}.`
	end

	if type(p2.generationId) == "string" then
		return { generationId = p2.generationId }, nil
	end

	return nil, "GenerateBackground: generationId field is required and must be a string."
end

return normalizeGenerateBackgroundResponse
