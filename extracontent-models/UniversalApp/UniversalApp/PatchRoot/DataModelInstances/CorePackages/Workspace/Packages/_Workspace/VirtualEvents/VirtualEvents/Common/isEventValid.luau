local function isEventValid(t1: {[any]: any}) -- line: 1
	if t1.title == nil then
		return false
	end

	if t1.imageUrl == nil then
		return false
	end

	if t1.pagePath == nil then
		return false
	end

	return true
end

return isEventValid
