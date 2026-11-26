local module = require("@luauforge/bundled/dBz")
local module2 = require("@luauforge/bundled/egs")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module3 = require("@luauforge/bundled/gCD")
local SendFeedbackThunk = require("@game/CoreGui/RobloxGui/Modules/Feedback/Thunks/SendFeedbackThunk")

local module5 = require("@luauforge/bundled/gCH")

local module6 = require("@luauforge/bundled/gCI")

local defineFastFlag = game:DefineFastFlag("ReduceActiveSubscriptionFetch", false)

return function(p2, p3)
	return performFetch.Single("ApiFetchGameSubscriptionProducts" .. p3, function(object)
		return module5(p2, p3):andThen(function(p4)
			if defineFastFlag then
				if
					p4 == nil
					or p4.responseBody == nil
					or p4.responseBody.subscriptionProductsInfo == nil
				then
					return module2.reject()
				end

				local v5 = {}
				local iconImageAssetIds = {}
				local subscriptionTargetKeys = {}

				for k, v6 in p4.responseBody.subscriptionProductsInfo do
					local v7 = module6.fromJsonData(v6)
					table.insert(v5, v7)
					table.insert(iconImageAssetIds, v7.iconImageAssetId)
					table.insert(subscriptionTargetKeys, v7.subscriptionTargetKey)
				end

				object:dispatch(module(p3, v5))
				object:dispatch(module3(p2, iconImageAssetIds))
				object:dispatch(SendFeedbackThunk(p2, subscriptionTargetKeys, p3))

				return module2.resolve()
			else
				local v5 = not (p4 and p4.responseBody and p4.responseBody.subscriptionProductsInfo)
					and {}
					or p4.responseBody.subscriptionProductsInfo

				local v6 = {}
				local iconImageAssetIds = {}
				local subscriptionTargetKeys = {}

				if #v5 == 0 then
					return module2.resolve()
				end

				for k, v7 in v5 do
					local v8 = module6.fromJsonData(v7)
					table.insert(v6, v8)
					table.insert(iconImageAssetIds, v8.iconImageAssetId)
					table.insert(subscriptionTargetKeys, v8.subscriptionTargetKey)
				end

				object:dispatch(module(p3, v6))
				object:dispatch(module3(p2, iconImageAssetIds))
				object:dispatch(SendFeedbackThunk(p2, subscriptionTargetKeys, p3))

				return module2.resolve()
			end
		end, function(p4)
			return module2.resolve()
		end)
	end)
end
