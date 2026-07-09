local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local SubscriptionGetStatuses = require(Modules.LuaApp.Http.Requests.EconomyAPI.SubscriptionGetStatuses)
local SetSubscriptionStatuses = require(Modules.LuaApp.Actions.Subscription.SetSubscriptionStatuses)
local SubscriptionStatusModel = require(Modules.LuaApp.Models.SubscriptionApi.SubscriptionStatusModel)

return function(p1, t1: {[any]: any}, s1: string) -- line: 13
	-- upvalues: PerformFetch (copy), SubscriptionGetStatuses (copy), SubscriptionStatusModel (copy), SetSubscriptionStatuses (copy), Promise (copy)
	return PerformFetch.Single("ApiFetchSubscriptionsStatus" .. s1, function(p2) -- line: 14
		-- upvalues: SubscriptionGetStatuses (copy), p1 (copy), t1 (copy), SubscriptionStatusModel (copy), SetSubscriptionStatuses (copy), Promise (copy)
		return SubscriptionGetStatuses(p1, t1):andThen(function(p3) -- line: 15
			-- upvalues: t1 (copy), SubscriptionStatusModel (copy), p2 (copy), SetSubscriptionStatuses (copy)
			local t2 = {}

			for _, v15 in t1 do
				local v16 = p3[v15]

				if v16 then
					t2[v15] = SubscriptionStatusModel.fromJsonData(v16)
				end
			end

			return p2:dispatch(SetSubscriptionStatuses(t2))
		end, function(_) -- line: 25
			-- upvalues: Promise (copy)
			return Promise.resolve()
		end)
	end)
end
