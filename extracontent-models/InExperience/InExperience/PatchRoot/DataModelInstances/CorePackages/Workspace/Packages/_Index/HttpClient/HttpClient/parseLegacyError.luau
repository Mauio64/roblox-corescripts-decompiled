require(script.Parent.types)

local function parseLegacyError(p)
	if typeof(p) ~= "table" or typeof(p.errors) ~= "table" then
		return nil
	end

	local errors = {}

	for _, err in p.errors do
		if not (typeof(err) == "table" and typeof(err.code) == "number" and typeof(err.message) == "string") then
			continue
		end

		table.insert(errors, {
			code = err.code,
			message = err.message,
			userFacingMessage = err.userFacingMessage,
			field = err.field
		})
	end

	if #errors == 0 then
		return nil
	end

	return { errors = errors }
end

return parseLegacyError
