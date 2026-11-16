local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local DeveloperSubscription = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/DeveloperSubscription")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Promise")

local fFlagBuildExperienceManageMonetizationTool = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceManageMonetizationTool

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/localToolOverlay")
local createManageSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/createManageSubscriptionStore")
local createMonetizationToolController = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/createMonetizationToolController")
local toolControllerUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/toolControllerUtils")

local productStatusType = DeveloperSubscription.ProductStatusType
local v5 = {
	consumable = DeveloperSubscription.DeveloperSubscriptionProductType.Consumable,
	currency = DeveloperSubscription.DeveloperSubscriptionProductType.Currency,
	durable = DeveloperSubscription.DeveloperSubscriptionProductType.Durable
}

local store = nil

local function getStore()
	if store == nil then
		store = createManageSubscriptionStore()
	end

	return store
end

local function deletionResult(subscriptionId, p2)
	if p2 == nil or p2.productStatusType == productStatusType.Deleted then
		return { id = subscriptionId, deleted = true }
	end

	return {
		id = subscriptionId,
		deleted = false,
		deletionAccepted = true,
		productStatusType = p2.productStatusType
	}
end

local v6 = {
	tool = 0,
	itemKind = "subscription",
	resultKey = "subscription",
	list = 0,
	mutate = 0,
	itemIdOf = 0,
	cardFields = 0
}

local v7 = if fFlagBuildExperienceManageMonetizationTool then CreatorAgentChat.StudioManageMonetizationTool.forKind("subscription") else CreatorAgentChat.StudioManageSubscriptionTool
v6.tool = v7

function v6.list(p2)
	if store == nil then
		store = createManageSubscriptionStore()
	end

	return store.list(p2):andThen(function(data)
		return {
			count = #data.developerSubscriptions,
			subscriptions = data.developerSubscriptions,
			nextCursor = data.nextCursor,
			truncated = data.isIncomplete == true
		}
	end, function(data)
		if typeof(data) == "table" and data.code == "IncompleteDeveloperSubscriptionList" then
			return {
				count = #data.developerSubscriptions,
				subscriptions = data.developerSubscriptions,
				nextCursor = data.nextCursor,
				truncated = true,
				truncatedReason = data.message
			}
		end

		return Promise.reject(data)
	end)
end

function v6.mutate(p2, data)
	local subscriptionId = data.subscriptionId

	if data.action == "create" then
		return toolControllerUtils.withGeneratedImage(
			data.imageAssetId,
			"The subscription image could not be loaded. No subscription was created.",
			function(p3)
				if store == nil then
					store = createManageSubscriptionStore()
				end

				return store.create(p2, {
					name = data.name,
					description = data.description,
					productType = v5[data.productType],
					currencyType = DeveloperSubscription.CurrencyType.Robux,
					priceInRobux = data.priceInRobux,
					isRegionalPricingEnabled = true,
					imageFile = p3
				})
			end
		)
	end

	if data.action == "update" then
		return toolControllerUtils.withGeneratedImage(
			data.imageAssetId,
			"The subscription image could not be loaded. No changes were made.",
			function(imageFile)
				if store == nil then
					store = createManageSubscriptionStore()
				end

				local update = store.update
				local v10 = {
					description = data.description,
					currencyType = 0,
					priceInRobux = 0,
					isRegionalPricingEnabled = 0,
					imageFile = 0
				}
				local v11 = if data.priceInRobux ~= nil then DeveloperSubscription.CurrencyType.Robux else nil
				v10.currencyType = v11

				v10.priceInRobux = data.priceInRobux
				v10.isRegionalPricingEnabled = data.priceInRobux ~= nil or nil
				v10.imageFile = imageFile
				return update(p2, subscriptionId, v10)
			end
		)
	end

	if data.action == "activate" then
		if store == nil then
			store = createManageSubscriptionStore()
		end

		return store.activate(p2, subscriptionId)
	elseif data.action == "deactivate" then
		if store == nil then
			store = createManageSubscriptionStore()
		end

		return store.deactivate(p2, subscriptionId, data.cancelRenewals == true)
	else
		if data.action ~= "delete" then
			return Promise.reject({
				errorMessage = ("Unsupported action '%s'."):format((tostring(data.action)))
			})
		end

		if store == nil then
			store = createManageSubscriptionStore()
		end

		return store.delete(p2, subscriptionId):andThen(function(p3)
			return deletionResult(subscriptionId, p3)
		end)
	end
end

function v6.itemIdOf(p2)
	return p2.subscriptionId
end

function v6.cardFields(data)
	return {
		productType = data.productType,
		cancelRenewals = data.cancelRenewals,
		imageAssetId = data.imageAssetId
	}
end

return function(p2, p3, p4, p5)
	return createMonetizationToolController(v6, p2, p3, p4, p5)
end
