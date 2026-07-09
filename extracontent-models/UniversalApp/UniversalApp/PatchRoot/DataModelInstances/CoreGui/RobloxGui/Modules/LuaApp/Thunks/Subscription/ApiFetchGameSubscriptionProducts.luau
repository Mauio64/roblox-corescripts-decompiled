local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Actions = Modules.LuaApp.Actions
local SetGameSubscriptionProducts = require(Actions.Subscription.SetGameSubscriptionProducts)
local Promise = require(Modules.LuaApp.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ApiFetchSubscriptionsThumbnails = require(Modules.LuaApp.Thunks.Subscription.ApiFetchSubscriptionsThumbnails)
local ApiFetchSubscriptionsStatus = require(Modules.LuaApp.Thunks.Subscription.ApiFetchSubscriptionsStatus)
local GameGetActiveSubscriptionProducts = require(Modules.LuaApp.Http.Requests.EconomyAPI.GameGetActiveSubscriptionProducts)
local SubscriptionProductInfoModel = require(Modules.LuaApp.Models.SubscriptionApi.SubscriptionProductInfoModel)
local v11 = game:DefineFastFlag("ReduceActiveSubscriptionFetch", false)

return function(p1, s1: string) -- line: 18
	-- upvalues: PerformFetch (copy), GameGetActiveSubscriptionProducts (copy), v11 (copy), Promise (copy), SubscriptionProductInfoModel (copy), SetGameSubscriptionProducts (copy), ApiFetchSubscriptionsThumbnails (copy), ApiFetchSubscriptionsStatus (copy)
	return PerformFetch.Single("ApiFetchGameSubscriptionProducts" .. s1, function(p2) -- line: 19
		-- upvalues: GameGetActiveSubscriptionProducts (copy), p1 (copy), s1 (copy), v11 (copy), Promise (copy), SubscriptionProductInfoModel (copy), SetGameSubscriptionProducts (copy), ApiFetchSubscriptionsThumbnails (copy), ApiFetchSubscriptionsStatus (copy)
		return GameGetActiveSubscriptionProducts(p1, s1):andThen(function(p3) -- line: 20
			-- upvalues: v11 (copy), Promise (copy), SubscriptionProductInfoModel (copy), p2 (copy), SetGameSubscriptionProducts (copy), s1 (copy), ApiFetchSubscriptionsThumbnails (copy), p1 (copy), ApiFetchSubscriptionsStatus (copy)
			if v11 then
				if p3 == nil or p3.responseBody == nil or p3.responseBody.subscriptionProductsInfo == nil then
					return Promise.reject()
				end

				local t1 = {}
				local t2 = {}
				local t3 = {}

				for _, v20 in p3.responseBody.subscriptionProductsInfo do
					local v21 = SubscriptionProductInfoModel.fromJsonData(v20)

					table.insert(t1, v21)
					table.insert(t2, v21.iconImageAssetId)
					table.insert(t3, v21.subscriptionTargetKey)
				end

				p2:dispatch(SetGameSubscriptionProducts(s1, t1))
				p2:dispatch(ApiFetchSubscriptionsThumbnails(p1, t2))
				p2:dispatch(ApiFetchSubscriptionsStatus(p1, t3, s1))

				return Promise.resolve()
			end

			local v22 = if not p3 or (not p3.responseBody or not p3.responseBody.subscriptionProductsInfo) then {} else p3.responseBody.subscriptionProductsInfo
			local t4 = {}
			local t5 = {}
			local t6 = {}

			if #v22 == 0 then
				return Promise.resolve()
			end

			for _, v27 in v22 do
				local v28 = SubscriptionProductInfoModel.fromJsonData(v27)

				table.insert(t4, v28)
				table.insert(t5, v28.iconImageAssetId)
				table.insert(t6, v28.subscriptionTargetKey)
			end

			p2:dispatch(SetGameSubscriptionProducts(s1, t4))
			p2:dispatch(ApiFetchSubscriptionsThumbnails(p1, t5))
			p2:dispatch(ApiFetchSubscriptionsStatus(p1, t6, s1))

			return Promise.resolve()
		end, function(_) -- line: 74
			-- upvalues: Promise (copy)
			return Promise.resolve()
		end)
	end)
end
