local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function pollAnalyticsOperation(data)
	local delay2 = data.delay or Promise.delay
	local function postQuery(p2)
		return asPromise((fetch({
			network = data.network,
			method = "POST",
			url = data.url,
			body = data.body,
			analyticsKey = data.analyticsKey,
			decode = function(p3)
				return p3 and p3.operation or {}
			end
		}))):andThen(function(p3)
			if p3.done == true then
				if p3.error == nil then
					return Promise.resolve(data.mapResult(p3))
				end

				return Promise.reject({
					responseCode = p3.error.code,
					errorMessage = p3.error.message
				})
			elseif p2 >= 6 then
				return Promise.reject({ errorMessage = data.timeoutMessage })
			else
				return delay2(2):andThen(function()
					return postQuery(p2 + 1)
				end)
			end
		end)
	end

	return postQuery(1)
end

return pollAnalyticsOperation
