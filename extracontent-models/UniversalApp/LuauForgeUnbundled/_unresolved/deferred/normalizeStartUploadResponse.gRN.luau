local function normalizeStartUploadResponse(p2)
	if type(p2) ~= "table" then
		return nil, `StartBackgroundUpload: type table required, got {type(p2)}.`
	end

	if type(p2.operationId) == "string" then
		return { operationId = p2.operationId }, nil
	end

	return nil, "StartBackgroundUpload: operationId field is required and must be a string."
end

return normalizeStartUploadResponse
