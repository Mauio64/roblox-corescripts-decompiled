local function getCaptureContent(p1) -- line: 11
	if typeof(p1) == "table" and p1.assetId ~= nil then
		return Content.fromUri(`rbxthumb://type=Asset&id={ p1.assetId }&w=420&h=420`)
	end

	return Content.fromObject(p1)
end

return getCaptureContent
