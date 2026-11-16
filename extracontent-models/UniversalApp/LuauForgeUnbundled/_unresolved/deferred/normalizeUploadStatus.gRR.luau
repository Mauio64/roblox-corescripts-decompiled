local function normalizeUploadStatus(data)
	if type(data) ~= "table" then
		return nil, `BackgroundUploadStatus: type table required, got {type(data)}.`
	end

	if type(data.status) == "string" then
		return { status = data.status, assetId = data.assetId, error = data.error }, nil
	end

	return nil, "BackgroundUploadStatus: status field is required and must be a string."
end

return normalizeUploadStatus
