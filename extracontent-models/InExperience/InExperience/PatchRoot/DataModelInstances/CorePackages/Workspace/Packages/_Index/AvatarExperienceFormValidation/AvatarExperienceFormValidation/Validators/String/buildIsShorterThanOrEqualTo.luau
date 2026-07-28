local FormValidationErrorEnum = require(script.Parent.Parent.Parent.FormValidationErrorEnum)

local function buildIsShorterThanOrEqualTo(n1: number) -- line: 4
	-- upvalues: FormValidationErrorEnum (copy)
	return function(s1: string) -- line: 5
		-- upvalues: n1 (copy), FormValidationErrorEnum (copy)
		local v5 = utf8.len(s1)

		if v5 ~= nil and v5 <= n1 then
			return true
		end

		return false, FormValidationErrorEnum.FailedIsShorterThanOrEqualTo
	end
end

return buildIsShorterThanOrEqualTo
