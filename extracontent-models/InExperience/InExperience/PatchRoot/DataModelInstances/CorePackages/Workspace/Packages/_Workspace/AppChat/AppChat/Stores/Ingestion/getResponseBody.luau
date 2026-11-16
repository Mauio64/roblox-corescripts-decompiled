local function getResponseBody(p)
	if p == nil then
		return nil
	end

	return p.responseBody or p
end

return getResponseBody
