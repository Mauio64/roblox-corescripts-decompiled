local FormValidationErrorEnum = require(script.Parent.Parent.Parent.FormValidationErrorEnum)

local function buildIsShorterThanOrEqualTo(p: number)
	return function(p2: string)
		local v = utf8.len(p2)

		if v == nil or not (v <= p) then
			return false, FormValidationErrorEnum.FailedIsShorterThanOrEqualTo
		end

		return true
	end
end

return buildIsShorterThanOrEqualTo
