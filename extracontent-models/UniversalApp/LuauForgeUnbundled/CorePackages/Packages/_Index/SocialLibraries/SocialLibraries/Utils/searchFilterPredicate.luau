local function isAlumniSchool(value): boolean
	if value == nil then
		return false
	end

	return string.find(string.lower(value), "alumni", 1, true) ~= nil
end

return isAlumniSchool
