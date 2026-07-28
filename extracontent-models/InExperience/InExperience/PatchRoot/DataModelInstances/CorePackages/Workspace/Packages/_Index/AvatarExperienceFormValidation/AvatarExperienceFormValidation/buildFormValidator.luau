require(script.Parent.FormValidationErrorEnum)

local function buildFormValidator(t1: {[any]: any}) -- line: 4
	return function(p1) -- line: 5
		-- upvalues: t1 (copy)
		for _, v5 in t1 do
			local v6, v7 = v5(p1)

			if not v6 then
				return false, v7
			end
		end

		return true, nil
	end
end

return buildFormValidator
