local function parseBooleanString(p: string?): nil | boolean
	if p == nil then
		return nil
	end

	return p == "true" or p == "True" or p == "1"
end

return parseBooleanString
