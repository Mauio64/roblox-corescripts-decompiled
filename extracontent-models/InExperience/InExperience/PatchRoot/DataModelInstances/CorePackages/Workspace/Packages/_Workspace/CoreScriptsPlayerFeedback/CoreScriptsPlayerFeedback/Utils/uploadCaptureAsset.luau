local engineFeature = game:GetEngineFeature("EnableCaptureUploadForSupportTicket")

local engineFeature2 = game:GetEngineFeature("EnableCheckUploadCaptureStatusForSupportTicket")

local function uploadCaptureAsset(p, p2)
	if not (engineFeature and engineFeature2) then
		return nil, Enum.UploadCaptureResult.UploadFailed
	end

	local v = p2 or game:GetService("CaptureService")

	local success, result, v2 = pcall(function()
		return v:StartUploadCaptureForSupportTicketAsync(p)
	end)

	if success and result == Enum.UploadCaptureResult.Success then
		for _ = 1, 120 do
			task.wait(5)

			local success2, result2, v3 = pcall(function()
				return v:CheckUploadCaptureStatusForSupportTicketAsync(v2)
			end)

			if not success2 then
				return nil, Enum.UploadCaptureResult.UploadFailed
			end

			if result2 == Enum.UploadCaptureResult.Success then
				return v3, nil
			end

			if result2 ~= Enum.UploadCaptureResult.UploadPending then
				return nil, result2
			end
		end

		return nil, Enum.UploadCaptureResult.UploadFailed
	end

	if not success or result == nil then
		result = Enum.UploadCaptureResult.UploadFailed
	end

	return nil, result
end

return uploadCaptureAsset
