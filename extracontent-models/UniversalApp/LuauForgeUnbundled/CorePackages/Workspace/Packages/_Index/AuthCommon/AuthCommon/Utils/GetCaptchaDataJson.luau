local HttpService = game:GetService("HttpService")

return function(p2)
	if p2 == nil or p2.errors == nil or not (p2.errors[1] and p2.errors[1].fieldData) then
		return "", ""
	end

	local fieldData = p2.errors[1].fieldData
	local success, result = pcall(function()
		return HttpService:JSONDecode(fieldData)
	end)

	if success then
		return
			not result.unifiedCaptchaId and "" or result.unifiedCaptchaId,
			not result.dxBlob and "" or result.dxBlob
	end

	return "", fieldData
end
