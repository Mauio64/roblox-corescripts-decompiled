local function getCaptureContent(p)
	if typeof(p) == "table" and p.assetId ~= nil then
		return Content.fromUri(`rbxthumb://type=Asset&id={p.assetId}&w=420&h=420`)
	end

	return Content.fromObject(p)
end

return getCaptureContent
