local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local Players = game:GetService("Players")

local Promise = require(parent.Promise)
local Http = require(parent.Http)
local Url = Http.Url

local HttpRequest = require(script.Parent.HttpRequest)
require(RobloxSubscriptionPurchaseApp.types)

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

	for _, entry in entries do
		if type(entry) ~= "table" then
			return nil
		end

		local v = parseEvaluationValue(entry.key)

		if type(v) ~= "string" then
			return nil
		end

		local v2 = parseEvaluationValue(entry.value)

		if v2 == nil then
			return nil
		end

		result[v] = v2
	end

	return result
end

local function findMembershipResult(p)
	if type(p) ~= "table" then
		return nil
	end

	local evaluationResponses = p.evaluationResponses

	if type(evaluationResponses) ~= "table" then
		return nil
	end

	for _, evaluationRespons in evaluationResponses do
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

	return HttpRequest.new():post(Url.APIS_URL .. "access-management/v2/feature-evaluation", {
		{
			userId = localPlayer.UserId,
			featureName = "RobloxSubscriptionMembership",
			namespace = "subscriptions/PlusSubscription"
		}
	}):andThen(function(p)
		local membershipResult = findMembershipResult(p)

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
