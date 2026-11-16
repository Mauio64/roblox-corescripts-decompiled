require(script.Parent.FormValidationErrorEnum)

local function buildFormValidator(items)
	return function(p)
		for _, item in items do
			local v, v2 = item(p)

			if not v then
				return false, v2
			end
		end

		return true, nil
	end
end

return buildFormValidator
