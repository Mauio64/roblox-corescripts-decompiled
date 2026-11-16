local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("MomentsCreation").Parent

local Http = require(parent.Http)
local HttpClient = require(parent.HttpClient)

local url = Http.Url.APIS_URL .. "look-api/v1/avatar-moments/create"

local function bodyToString(value)
	if typeof(value) == "string" then
		return value
	end

	if typeof(value) == "buffer" then
		return buffer.tostring(value)
	end

	return ""
end

local function createAvatarMomentLook(body, p)
	local createRequest = HttpClient.createRequest
	local networkImpl

	if p and p.network then
		networkImpl = p.network
	else
		networkImpl = HttpClient.createRequestInternalNetwork()
	end

	local request = createRequest({
		networkImpl = networkImpl,
		method = "POST",
		url = url,
		headers = { ["Content-Type"] = "application/json" },
		body = body,
		analyticsKey = "moments-creation.create-avatar-moment-look",
		decode = function(p2)
			local v = p2.responseBody

			if typeof(v) ~= "string" then
				v = typeof(v) ~= "buffer" and "" or buffer.tostring(v)
			end

			local success, result = pcall(HttpService.JSONDecode, HttpService, v)
			local outfitId

			if success and type(result) == "table" and type(result.outfitId) == "number" then
				outfitId = result.outfitId
			end

			return { statusCode = p2.statusCode, outfitId = outfitId }
		end
	})

	return HttpClient.asPromise(request)
end

return createAvatarMomentLook
