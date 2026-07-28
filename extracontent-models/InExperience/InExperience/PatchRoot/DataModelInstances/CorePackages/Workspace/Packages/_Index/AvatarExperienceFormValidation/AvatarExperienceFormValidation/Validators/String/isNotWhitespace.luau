local FormValidationErrorEnum = require(script.Parent.Parent.Parent.FormValidationErrorEnum)

local function isNotWhitespace(s1: string) -- line: 4
	-- upvalues: FormValidationErrorEnum (copy)
	if string.match(s1, "%S") ~= nil then
		return true
	end

	return false, FormValidationErrorEnum.FailedIsNotWhitespace
end

return isNotWhitespace
