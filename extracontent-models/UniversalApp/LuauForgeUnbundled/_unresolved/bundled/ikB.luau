local module = require("@luauforge/bundled/dVn")
local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local Promise = require(CorePackages.Packages.Promise)
local fFlagSurvBloxEventTypeEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSurvBloxEventTypeEnabled

return function(callback, p2)
	local v5 = string.format("%sv1/survey", module.APIS_URL)

	if fFlagSurvBloxEventTypeEnabled and p2 ~= nil then
		v5 = string.format("%s?eventType=%s", v5, HttpService:UrlEncode(p2))
	end

	return callback(v5, "GET"):andThen(function(p3)
		return Promise.resolve(p3.responseBody)
	end, function(p3)
		logging.warn(string.format("ResponseCode: %s", (tostring(p3.responseCode))))
		return Promise.reject(p3)
	end)
end
