local HttpRbxApiService = game:GetService("HttpRbxApiService")
local ContentProvider = game:GetService("ContentProvider")

local APIUtil = {}

function APIUtil.getBaseDomain()
	local v = ContentProvider.BaseUrl

	if string.sub(v, #v) ~= "/" then
		v ..= "/"
	end

	local _, v2 = string.find(v, "://")
	local _, v3 = string.find(v, "%.", v2 + 1)
	return (string.sub(v, v3 + 1))
end

local function requestAndRetry(fn, p: number?)
	local v = p == nil and 0 or p

	local success, result = pcall(fn)

	if success then
		return true, result
	end

	if v >= 2 then
		return false, result
	end

	local v2 = 2 ^ (v - 1)
	wait(v2)
	return requestAndRetry(fn, v + 1)
end

function APIUtil.requestAndRetryPost(p, p2)
	return requestAndRetry(function()
		return HttpRbxApiService:PostAsyncFullUrl(p, p2)
	end)
end

function APIUtil.requestAndRetryGet(p)
	return requestAndRetry(function()
		return HttpRbxApiService:GetAsyncFullUrl(p)
	end)
end

return APIUtil
