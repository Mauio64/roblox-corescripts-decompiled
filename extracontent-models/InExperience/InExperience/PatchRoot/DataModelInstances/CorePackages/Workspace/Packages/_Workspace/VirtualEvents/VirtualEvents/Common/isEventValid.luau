local function isEventValid(data): boolean
	return data.title ~= nil and data.imageUrl ~= nil and data.pagePath ~= nil
end

return isEventValid
