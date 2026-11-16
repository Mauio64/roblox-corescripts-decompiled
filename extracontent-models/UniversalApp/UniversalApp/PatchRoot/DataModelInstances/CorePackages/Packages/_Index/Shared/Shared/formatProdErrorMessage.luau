local HttpService = game:GetService("HttpService")

local function formatProdErrorMessage(p, ...)
	local v = "https://reactjs.org/docs/error-decoder.html?invariant=" .. tostring(p)

	for i = 1, select("#", ...) do
		v ..= "&args[]=" .. HttpService:UrlEncode((select)(i, ...))
	end

	return string.format(
		"Minified React error #%d; visit %s for the full message or use the non-minified dev environment for full errors and additional helpful warnings.",
		p,
		v
	)
end

return formatProdErrorMessage
