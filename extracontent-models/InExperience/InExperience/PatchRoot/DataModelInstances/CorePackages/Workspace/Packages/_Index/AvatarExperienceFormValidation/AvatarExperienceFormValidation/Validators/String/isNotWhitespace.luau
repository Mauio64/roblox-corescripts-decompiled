local FormValidationErrorEnum = require(script.Parent.Parent.Parent.FormValidationErrorEnum)

local function isNotWhitespace(value: string)
	if string.match(value, "%S") == nil then
		return false, FormValidationErrorEnum.FailedIsNotWhitespace
	end

	return true
end

return isNotWhitespace
