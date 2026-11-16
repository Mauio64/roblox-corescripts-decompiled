local function isCanonicalNonzeroUuid(value): boolean
	if
		type(value) == "string"
		and value ~= "00000000-0000-0000-0000-000000000000"
		and value == string.lower(value)
	then
		return string.match(
			value,
			"^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$"
		) ~= nil
	end

	return false
end

return isCanonicalNonzeroUuid
