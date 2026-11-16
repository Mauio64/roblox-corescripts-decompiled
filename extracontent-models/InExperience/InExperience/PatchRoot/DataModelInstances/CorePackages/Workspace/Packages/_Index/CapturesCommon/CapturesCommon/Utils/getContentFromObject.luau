local function getContentFromObject(p)
	if typeof(p) == "Object" then
		return Content.fromObject(p)
	end

	return Content.none
end

return getContentFromObject
