local function parseBooleanString(p2): nil | boolean
	if p2 == nil then
		return nil
	end

	return p2 == "true" or p2 == "True" or p2 == "1"
end

return parseBooleanString
