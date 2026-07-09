require(script.Parent.types)

local function parseLegacyError(p1) -- line: 6
	if typeof(p1) ~= "table" or typeof(p1.errors) ~= "table" then
		return nil
	end

	local t1 = {}

	for _, v5 in p1.errors do
		if typeof(v5) == "table" and typeof(v5.code) == "number" and typeof(v5.message) == "string" then
			table.insert(t1, {
				code = v5.code,
				message = v5.message,
				userFacingMessage = v5.userFacingMessage,
				field = v5.field
			})
		end
	end

	if #t1 == 0 then
		return nil
	end

	return {
		errors = t1
	}
end

return parseLegacyError
