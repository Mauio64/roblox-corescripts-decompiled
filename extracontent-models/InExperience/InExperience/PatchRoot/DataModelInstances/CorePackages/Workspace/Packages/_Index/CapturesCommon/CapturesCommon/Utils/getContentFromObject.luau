local function getContentFromObject(p1) -- line: 1
	if typeof(p1) == "Object" then
		return Content.fromObject(p1)
	end

	return Content.none
end

return getContentFromObject
