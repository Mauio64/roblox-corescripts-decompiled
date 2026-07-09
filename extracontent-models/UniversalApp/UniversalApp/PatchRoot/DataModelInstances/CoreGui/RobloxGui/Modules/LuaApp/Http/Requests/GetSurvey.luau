local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)
local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(CorePackages.Packages.Promise)
local FFlagSurvBloxEventTypeEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSurvBloxEventTypeEnabled

return function(p1, s1: string?) -- line: 22
	-- upvalues: Url (copy), FFlagSurvBloxEventTypeEnabled (copy), HttpService (copy), Promise (copy), Logging (copy)
	local v10 = string.format("%sv1/survey", Url.APIS_URL)

	if FFlagSurvBloxEventTypeEnabled and s1 ~= nil then
		v10 = string.format("%s?eventType=%s", v10, HttpService:UrlEncode(s1))
	end

	return p1(v10, "GET"):andThen(function(p2) -- line: 29
		-- upvalues: Promise (copy)
		return Promise.resolve(p2.responseBody)
	end, function(p3) -- line: 31
		-- upvalues: Logging (copy), Promise (copy)
		Logging.warn(string.format("ResponseCode: %s", (tostring(p3.responseCode))))

		return Promise.reject(p3)
	end)
end
