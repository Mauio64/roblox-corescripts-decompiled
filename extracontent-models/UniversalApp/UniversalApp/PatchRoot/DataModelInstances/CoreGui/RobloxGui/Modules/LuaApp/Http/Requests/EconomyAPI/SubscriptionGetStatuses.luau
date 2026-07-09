local CorePackages = game:GetService("CorePackages")
local Url = require(CorePackages.Workspace.Packages.Http).Url
local Promise = require(CorePackages.Packages.Promise)
local v4 = game:DefineFastFlag("DoNotFetchOnEmptySubscriptionKeys", false)

return function(p1: ((...any) -> ...any), t1: {[any]: any}) -- line: 7
	-- upvalues: v4 (copy), Promise (copy), Url (copy)
	if v4 and #t1 == 0 then
		return Promise.resolve({})
	end

	local v7 = Url:makeQueryString({
		subscriptionProductTargetKeys = table.concat(t1, "&subscriptionProductTargetKeys=")
	})

	return p1(string.format("%sv1/subscriptions/statuses?%s", Url.APIS_URL, v7), "GET"):andThen(function(p2) -- line: 15
		if p2 and (p2.responseBody and p2.responseBody.subscriptionStatuses) then
			return p2.responseBody.subscriptionStatuses
		end

		return {}
	end)
end
