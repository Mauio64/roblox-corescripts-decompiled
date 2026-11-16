local function formatError(p)
	if typeof(p) == "table" and p.errorMessage then
		return `HTTP {tostring(p.responseCode)}: {p.errorMessage}`
	end

	return (tostring(p))
end

return formatError
