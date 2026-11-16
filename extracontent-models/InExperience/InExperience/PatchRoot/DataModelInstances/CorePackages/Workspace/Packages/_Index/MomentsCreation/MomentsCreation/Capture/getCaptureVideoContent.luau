local function getCaptureVideoContent(p)
	if typeof(p) == "table" and p.assetId ~= nil then
		return Content.fromUri(`rbxassetid://{p.assetId}`)
	end

	if typeof(p) ~= "table" then
		local success, result = pcall(Content.fromObject, p)

		if success then
			return result
		end
	end

	return nil
end

return getCaptureVideoContent
