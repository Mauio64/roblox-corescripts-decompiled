local FormValidationErrorEnum = require(script.Parent.Parent.FormValidationErrorEnum)

local function isNotNull(p)
	if p == nil then
		return false, FormValidationErrorEnum.FailedIsNotNull
	end

	return true
end

return isNotNull
