local HttpService = game:GetService("HttpService")

return function(p1) -- line: 3
	-- upvalues: HttpService (copy)
	if p1 ~= nil and (p1.errors ~= nil and p1.errors[1] and p1.errors[1].fieldData) then
		local fieldData = p1.errors[1].fieldData
		local ok, result = pcall(function() -- line: 11
			-- upvalues: HttpService (copy), fieldData (copy)
			return HttpService:JSONDecode(fieldData)
		end)

		if ok then
			local s1 = ""
			local s2 = ""

			if result.unifiedCaptchaId then
				s1 = result.unifiedCaptchaId
			end

			if result.dxBlob then
				s2 = result.dxBlob
			end

			return s1, s2
		end

		return "", fieldData
	end

	return "", ""
end
