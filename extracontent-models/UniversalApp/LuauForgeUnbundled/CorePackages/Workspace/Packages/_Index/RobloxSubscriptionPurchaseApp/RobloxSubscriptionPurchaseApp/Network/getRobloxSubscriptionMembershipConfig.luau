local Players = game:GetService("Players")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Promise")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Http").Url

local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/HttpRequest")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/types")

local flattenMapValue

local function parseEvaluationValue(data)
	if type(data) ~= "table" then
		return nil
	end

	if data.boolValue ~= nil then
		return data.boolValue
	end

	if data.stringValue ~= nil then
		return data.stringValue
	end

	if data.doubleValue ~= nil then
		return data.doubleValue
	end

	if data.int64Value ~= nil then
		return tonumber(data.int64Value) or data.int64Value
	end

	if data.mapValue == nil then
		return data
	end

	return flattenMapValue(data.mapValue)
end

flattenMapValue = function(mapValue)
	if type(mapValue) ~= "table" then
		return nil
	end

	local entries = mapValue.entries

	if entries == nil then
		return {}
	end

	if type(entries) ~= "table" then
		return nil
	end

	local result = {}

	for k, entry in entries do
		if type(entry) ~= "table" then
			return nil
		end

		local v5 = parseEvaluationValue(entry.key)

		if type(v5) ~= "string" then
			return nil
		end

		local v6 = parseEvaluationValue(entry.value)

		if v6 == nil then
			return nil
		end

		result[v5] = v6
	end

	return result
end

local function findMembershipResult(p2)
	if type(p2) ~= "table" then
		return nil
	end

	local evaluationResponses = p2.evaluationResponses

	if type(evaluationResponses) ~= "table" then
		return nil
	end

	for k, evaluationRespons in evaluationResponses do
		if type(evaluationRespons) ~= "table" then
			continue
		end

		local request = evaluationRespons.request

		if
			type(request) == "table"
			and request.fullFeatureName == "subscriptions/PlusSubscription.RobloxSubscriptionMembership"
		then
			return evaluationRespons.result
		end
	end

	return nil
end

local function getRobloxSubscriptionMembershipConfig()
	local localPlayer = Players.LocalPlayer

	if localPlayer == nil then
		return Promise.resolve(nil)
	end

	return HttpRequest.new():post(url.APIS_URL .. "access-management/v2/feature-evaluation", {
		{
			userId = localPlayer.UserId,
			featureName = "RobloxSubscriptionMembership",
			namespace = "subscriptions/PlusSubscription"
		}
	}):andThen(function(p2)
		local membershipResult = findMembershipResult(p2)

		if type(membershipResult) ~= "table" then
			return nil
		end

		if membershipResult.errorValue == nil then
			return flattenMapValue(membershipResult.mapValue)
		end

		return nil
	end):catch(function()
		return Promise.resolve(nil)
	end)
end

return getRobloxSubscriptionMembershipConfig
