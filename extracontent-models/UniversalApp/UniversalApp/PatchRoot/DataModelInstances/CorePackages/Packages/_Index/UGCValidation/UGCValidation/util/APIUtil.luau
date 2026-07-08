local HttpRbxApiService = game:GetService("HttpRbxApiService")
local ContentProvider = game:GetService("ContentProvider")
local t1 = {
	getBaseDomain = function() -- line: 10
		-- upvalues: ContentProvider (copy)
		local BaseUrl = ContentProvider.BaseUrl

		if string.sub(BaseUrl, #BaseUrl) ~= "/" then
			BaseUrl ..= "/"
		end

		local _, stop = string.find(BaseUrl, "://")
		local _, stop2 = string.find(BaseUrl, "%.", stop + 1)

		return (string.sub(BaseUrl, stop2 + 1))
	end
}

local function requestAndRetry(p1: ((...any) -> ...any), n1: number?) -- line: 21
	-- upvalues: requestAndRetry (copy)
	if n1 == nil then
		n1 = 0
	end

	local ok, result = pcall(p1)

	if ok then
		return true, result
	end

	if n1 >= 2 then
		return false, result
	end

	local v14 = 2 ^ (n1 - 1)

	wait(v14)

	return requestAndRetry(p1, n1 + 1)
end

function t1.requestAndRetryPost(p2, p3) -- line: 39
	-- upvalues: requestAndRetry (copy), HttpRbxApiService (copy)
	return requestAndRetry(function() -- line: 40
		-- upvalues: HttpRbxApiService (copy), p2 (copy), p3 (copy)
		return HttpRbxApiService:PostAsyncFullUrl(p2, p3)
	end)
end
function t1.requestAndRetryGet(p4) -- line: 45
	-- upvalues: requestAndRetry (copy), HttpRbxApiService (copy)
	return requestAndRetry(function() -- line: 46
		-- upvalues: HttpRbxApiService (copy), p4 (copy)
		return HttpRbxApiService:GetAsyncFullUrl(p4)
	end)
end

return t1
