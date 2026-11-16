local function formatError(p2)
	if typeof(p2) == "table" and p2.errorMessage then
		return `HTTP {tostring(p2.responseCode)}: {p2.errorMessage}`
	end

	return (tostring(p2))
end

return formatError
