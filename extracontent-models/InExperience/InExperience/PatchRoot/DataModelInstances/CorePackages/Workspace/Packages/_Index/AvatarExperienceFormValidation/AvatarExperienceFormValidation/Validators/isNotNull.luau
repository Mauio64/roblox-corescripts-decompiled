local FormValidationErrorEnum = require(script.Parent.Parent.FormValidationErrorEnum)

local function isNotNull(p1) -- line: 4
	-- upvalues: FormValidationErrorEnum (copy)
	if p1 ~= nil then
		return true
	end

	return false, FormValidationErrorEnum.FailedIsNotNull
end

return isNotNull
