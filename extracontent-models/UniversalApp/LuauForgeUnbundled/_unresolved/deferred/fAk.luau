local module = require("@luauforge/bundled/ecV")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module2 = require("@luauforge/bundled/fAl")

local module3 = require("@luauforge/deferred/fAm")
local module4 = require("@luauforge/bundled/dPI")

local module5 = require("@luauforge/deferred/fAj")
local module6 = require("@luauforge/deferred/fAn")

local module7 = require("@luauforge/deferred/fAp")

local v5 = {}
local function getSubscriptionData(p2, p3, p4, p5, p6)
	local v6 = p5 or { subscriptions = {}, games = {}, plans = {} }

	return module3(p2, p3, p4, p6):andThen(function(p7)
		if not module6.SubscriptionsResponseCheck(p7.responseBody) then
			return nil, false
		end

		for k, v7 in pairs(p7.responseBody.data) do
			v6.subscriptions[v7.id] = v7
		end

		for k, plan in pairs(p7.responseBody.auxiliaryData.plans) do
			v6.plans[plan.id] = plan
		end

		for k, univers in pairs(p7.responseBody.auxiliaryData.universes) do
			v6.games[univers.id] = univers
		end

		local nextPageCursor = p7.responseBody.nextPageCursor

		if nextPageCursor then
			return getSubscriptionData(p2, p3, p4, v6, nextPageCursor)
		end

		return v6, true
	end)
end

local function getAllSubscriptionData(p2, p3)
	return getSubscriptionData(p2, p3, module5.Active):andThen(function(p4)
		return getSubscriptionData(p2, p3, module5.Inactive, p4)
	end)
end

function v5.Fetch(p2)
	local Players = game:GetService("Players")
	local localPlayer = Players.LocalPlayer
	assert(localPlayer)
	local userId = localPlayer.UserId

	return performFetch.Single("DevSubs", function(object)
		local v6 = p2
		local v7 = userId
		return getSubscriptionData(v6, v7, module5.Active):andThen(function(p3)
			return getSubscriptionData(v6, v7, module5.Inactive, p3)
		end):andThen(function(data, p3)
			if not p3 then
				return module.resolve()
			end

			local v8 = {}

			for k, Game in pairs(data.games) do
				table.insert(v8, k)
			end

			module4.Game.getGameIconStore(false).getAndFetchGameIcons(v8)

			local v9 = {}

			for k, subscription in pairs(data.subscriptions) do
				subscription.planData = data.plans[subscription.planId]

				if not subscription.planData then
					continue
				end

				subscription.gameData = data.games[subscription.planData.universeId]

				if subscription.gameData then
					table.insert(v9, module7.fromJsonData(subscription))
				end
			end

			object:dispatch(module2(v9))

			return module.resolve()
		end, function(p3)
			return module.reject(p3)
		end)
	end)
end

function v5.GetFetchingStatus(p2)
	return performFetch.GetStatus(p2, "DevSubs")
end

return v5
