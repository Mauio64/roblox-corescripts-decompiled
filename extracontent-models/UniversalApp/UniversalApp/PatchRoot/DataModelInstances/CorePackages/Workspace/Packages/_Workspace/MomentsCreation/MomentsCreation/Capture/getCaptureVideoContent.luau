local function getCaptureVideoContent(p1) -- line: 12
	if typeof(p1) == "table" and p1.assetId ~= nil then
		return Content.fromUri(`rbxassetid://{ p1.assetId }`)
	end

	if typeof(p1) ~= "table" then
		local ok, result = pcall(Content.fromObject, p1)

		if ok then
			return result
		end
	end

	return nil
end

return getCaptureVideoContent
