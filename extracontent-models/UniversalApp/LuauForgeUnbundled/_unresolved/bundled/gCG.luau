local CorePackages = game:GetService("CorePackages")
local url = require("@game/CorePackages/Workspace/Packages/Http").Url
local Promise = require(CorePackages.Packages.Promise)

local defineFastFlag = game:DefineFastFlag("DoNotFetchOnEmptySubscriptionKeys", false)

return function(callback, list)
	if defineFastFlag and #list == 0 then
		return Promise.resolve({})
	end

	local queryString = url:makeQueryString({
		subscriptionProductTargetKeys = table.concat(list, "&subscriptionProductTargetKeys=")
	})

	return callback(string.format("%sv1/subscriptions/statuses?%s", url.APIS_URL, queryString), "GET"):andThen(function(p2)
		if p2 and p2.responseBody and p2.responseBody.subscriptionStatuses then
			return p2.responseBody.subscriptionStatuses
		end

		return {}
	end)
end
