local function getResponseBody(p2)
	if p2 == nil then
		return nil
	end

	return p2.responseBody or p2
end

return getResponseBody
