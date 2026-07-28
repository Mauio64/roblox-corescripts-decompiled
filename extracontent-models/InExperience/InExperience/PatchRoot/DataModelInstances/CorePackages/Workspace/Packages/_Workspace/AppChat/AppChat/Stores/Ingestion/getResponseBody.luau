local function getResponseBody(p1) -- line: 1
	if p1 == nil then
		return nil
	end

	return p1.responseBody or p1
end

return getResponseBody
