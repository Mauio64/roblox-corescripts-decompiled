local function validateRefs(items): boolean
	for k, item in items do
		if item.current == nil then
			return false
		end
	end

	return true
end

return validateRefs
