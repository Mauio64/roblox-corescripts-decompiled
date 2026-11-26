local function getContentFromObject(p2)
	if typeof(p2) == "Object" then
		return Content.fromObject(p2)
	end

	return Content.none
end

return getContentFromObject
