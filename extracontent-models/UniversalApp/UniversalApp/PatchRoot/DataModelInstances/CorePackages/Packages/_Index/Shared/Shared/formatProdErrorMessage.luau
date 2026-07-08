local HttpService = game:GetService("HttpService")

local function formatProdErrorMessage(p1, ...) -- line: 17
	-- upvalues: HttpService (copy)
	local v4 = "https://reactjs.org/docs/error-decoder.html?invariant=" .. tostring(p1)

	for i = 1, select("#", ...) do
		v4 ..= "&args[]=" .. HttpService:UrlEncode(select(i, ...))
	end

	return string.format("Minified React error #%d; visit %s for the full message or use the non-minified dev environment for full errors and additional helpful warnings.", p1, v4)
end

return formatProdErrorMessage
