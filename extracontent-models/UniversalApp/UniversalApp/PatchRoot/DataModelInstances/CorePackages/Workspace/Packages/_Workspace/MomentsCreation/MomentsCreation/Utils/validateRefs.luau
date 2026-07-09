local function validateRefs(t1: {[any]: any}) -- line: 7
	for _, v4 in t1 do
		if v4.current == nil then
			return false
		end
	end

	return true
end

return validateRefs
