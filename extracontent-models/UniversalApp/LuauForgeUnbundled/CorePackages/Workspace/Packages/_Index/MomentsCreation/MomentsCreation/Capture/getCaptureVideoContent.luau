local function getCaptureVideoContent(p2)
	if typeof(p2) == "table" and p2.assetId ~= nil then
		return Content.fromUri(`rbxassetid://{p2.assetId}`)
	end

	if typeof(p2) ~= "table" then
		local success, result = pcall(Content.fromObject, p2)

		if success then
			return result
		end
	end

	return nil
end

return getCaptureVideoContent
