local parent = script:FindFirstAncestor("DataHydration").Parent

local Promise = require(parent.Promise)
local HttpClient = require(parent.HttpClient)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function pollAnalyticsOperation(data)
	local delay = data.delay or Promise.delay
	local function postQuery(p: number)
		return asPromise((fetch({
			network = data.network,
			method = "POST",
			url = data.url,
			body = data.body,
			analyticsKey = data.analyticsKey,
			decode = function(p2)
				return p2 and p2.operation or {}
			end
		}))):andThen(function(p2)
			if p2.done == true then
				if p2.error == nil then
					return Promise.resolve(data.mapResult(p2))
				end

				return Promise.reject({
					responseCode = p2.error.code,
					errorMessage = p2.error.message
				})
			elseif p >= 6 then
				return Promise.reject({ errorMessage = data.timeoutMessage })
			else
				return delay(2):andThen(function()
					return postQuery(p + 1)
				end)
			end
		end)
	end

	return postQuery(1)
end

return pollAnalyticsOperation
