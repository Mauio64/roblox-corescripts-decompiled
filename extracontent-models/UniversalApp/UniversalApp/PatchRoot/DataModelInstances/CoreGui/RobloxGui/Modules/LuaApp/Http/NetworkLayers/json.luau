local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local Promise = require(Modules.LuaApp.Promise)
local HttpError = require(Modules.LuaApp.Http.HttpError)
local HttpResponse = require(Modules.LuaApp.Http.HttpResponse)

return function(p1) -- line: 12
	-- upvalues: HttpService (copy), Promise (copy), HttpError (copy), HttpResponse (copy)
	return function(p2, p3, p4) -- line: 13
		-- upvalues: p1 (copy), HttpService (copy), Promise (copy), HttpError (copy), HttpResponse (copy)
		return (p1(p2, p3, p4):andThen(function(p5) -- line: 14
			-- upvalues: HttpService (copy), Promise (copy), HttpError (copy), p2 (copy), HttpResponse (copy)
			local ok, result = pcall(HttpService.JSONDecode, HttpService, p5.responseBody)

			if not ok then
				local v13 = string.format("Cannot parse : %s", p5.responseBody or "nil")

				return Promise.reject(HttpError.new(p2, HttpError.Kind.InvalidJson, v13))
			end

			return HttpResponse.new(p5.requestUrl, result, p5.responseTimeMs, p5.responseCode)
		end))
	end
end
