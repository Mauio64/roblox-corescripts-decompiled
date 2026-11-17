local HttpService = game:GetService("HttpService")

local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(parent.Http)
local Promise = require(parent.Promise)

require(AppChat.AppChatData.Ports.createHttpPort)

local function decodeBody(p)
	local postBody

	if p == nil then
		postBody = nil
	else
		postBody = p.postBody
	end

	if type(postBody) ~= "string" then
		return postBody
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(postBody)
	end)
	return if success then result else postBody
end

local function createFakeServer()
	local v = {}
	local v2 = {}

	return {
		request = function(endpoint, url: string, method: string, p)
			local postBody

			if p == nil then
				postBody = nil
			else
				postBody = p.postBody
			end

			local result

			if type(postBody) == "string" then
				local success
				success, result = pcall(function()
					return HttpService:JSONDecode(postBody)
				end)

				if not success then
					result = postBody
				end
			else
				result = postBody
			end

			local v3 = { endpoint = endpoint, url = url, method = method, body = result }

			table.insert(v2, v3)

			local v4 = v[endpoint]

			if v4 == nil then
				return Promise.reject(`AppChatData.Testing: no response scripted for {endpoint}`)
			end

			if type(v4) == "function" then
				v4 = v4(v3)
			end

			local status = v4.status or 200
			local v5 = { responseBody = v4.body, responseCode = status, StatusCode = status }

			if status >= 200 and status < 300 then
				return Promise.resolve(v5)
			end

			if v4.body ~= nil then
				v5.Body = HttpService:JSONEncode(v4.body)
			end

			return Promise.reject(v5)
		end,
		respond = function(p, p2)
			v[p] = p2
		end,
		getCalls = function(p)
			if p == nil then
				return table.clone(v2)
			end

			local result = {}

			for _, v3 in v2 do
				if v3.endpoint == p then
					table.insert(result, v3)
				end
			end

			return result
		end
	}
end

return createFakeServer
