local HttpService = game:GetService("HttpService")

return function(p)
	if p == nil or p.errors == nil or not (p.errors[1] and p.errors[1].fieldData) then
		return "", ""
	end

	local fieldData = p.errors[1].fieldData
	local success, result = pcall(function()
		return HttpService:JSONDecode(fieldData)
	end)

	if success then
		return not result.unifiedCaptchaId and "" or result.unifiedCaptchaId, not result.dxBlob and "" or result.dxBlob
	end

	return "", fieldData
end
