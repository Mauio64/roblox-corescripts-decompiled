local HttpService = game:GetService("HttpService")

local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Http")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/HttpClient")

local v5 = Http.Url.APIS_URL .. "look-api/v1/avatar-moments/create"

local function bodyToString(value)
	if typeof(value) == "string" then
		return value
	end

	if typeof(value) == "buffer" then
		return buffer.tostring(value)
	end

	return ""
end

local function createAvatarMomentLook(body, p2)
	local createRequest = HttpClient.createRequest
	local v7 = if p2 and p2.network then p2.network else HttpClient.createRequestInternalNetwork()
	local request = createRequest({
		networkImpl = v7,
		method = "POST",
		url = v5,
		headers = { ["Content-Type"] = "application/json" },
		body = body,
		analyticsKey = "moments-creation.create-avatar-moment-look",
		decode = function(p3)
			local v8 = p3.responseBody

			if typeof(v8) ~= "string" then
				v8 = typeof(v8) ~= "buffer" and "" or buffer.tostring(v8)
			end

			local success, result = pcall(HttpService.JSONDecode, HttpService, v8)
			local v9 = if success and type(result) == "table" and type(result.outfitId) == "number" then result.outfitId else nil

			return { statusCode = p3.statusCode, outfitId = v9 }
		end
	})

	return HttpClient.asPromise(request)
end

return createAvatarMomentLook
