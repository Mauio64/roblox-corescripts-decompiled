require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/types")

local function parseLegacyError(p2)
	if typeof(p2) ~= "table" or typeof(p2.errors) ~= "table" then
		return nil
	end

	local v5 = {}

	for k, err in p2.errors do
		if not (typeof(err) == "table" and typeof(err.code) == "number" and typeof(err.message) == "string") then
			continue
		end

		table.insert(v5, {
			code = err.code,
			message = err.message,
			userFacingMessage = err.userFacingMessage,
			field = err.field
		})
	end

	if #v5 == 0 then
		return nil
	end

	return { errors = v5 }
end

return parseLegacyError
