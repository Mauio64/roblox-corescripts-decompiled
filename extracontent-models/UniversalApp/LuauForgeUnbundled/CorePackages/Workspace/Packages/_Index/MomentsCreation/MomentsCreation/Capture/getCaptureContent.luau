local function getCaptureContent(p2)
	if typeof(p2) == "table" and p2.assetId ~= nil then
		return Content.fromUri(`rbxthumb://type=Asset&id={p2.assetId}&w=420&h=420`)
	end

	return Content.fromObject(p2)
end

return getCaptureContent
