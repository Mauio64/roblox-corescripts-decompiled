local parent = script:FindFirstAncestor("BuildExperience").Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local DeveloperSubscription = require(parent.DataHydration.DeveloperSubscription)
local Promise = require(parent.Promise)

local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceManageMonetizationTool = SharedFlags.FFlagBuildExperienceManageMonetizationTool

require(script.Parent.chatTypes)
require(script.Parent.localToolOverlay)
local createManageSubscriptionStore = require(script.Parent.createManageSubscriptionStore)
local createMonetizationToolController = require(script.Parent.createMonetizationToolController)
local toolControllerUtils = require(script.Parent.toolControllerUtils)

local ProductStatusType = DeveloperSubscription.ProductStatusType
local v = {
	consumable = DeveloperSubscription.DeveloperSubscriptionProductType.Consumable,
	currency = DeveloperSubscription.DeveloperSubscriptionProductType.Currency,
	durable = DeveloperSubscription.DeveloperSubscriptionProductType.Durable
}

local store = nil

local function getStore() -- 6 equivalent calls inferred from this helper
	if store == nil then
		store = createManageSubscriptionStore()
	end

	return store
end

local function deletionResult(subscriptionId: string, p)
	if p == nil or p.productStatusType == ProductStatusType.Deleted then
		return { id = subscriptionId, deleted = true }
	end

	return {
		id = subscriptionId,
		deleted = false,
		deletionAccepted = true,
		productStatusType = p.productStatusType
	}
end

local v2 = {
	tool = 0,
	itemKind = "subscription",
	resultKey = "subscription",
	list = 0,
	mutate = 0,
	itemIdOf = 0,
	cardFields = 0
}
local tool

if FFlagBuildExperienceManageMonetizationTool then
	tool = CreatorAgentChat.StudioManageMonetizationTool.forKind("subscription")
else
	tool = CreatorAgentChat.StudioManageSubscriptionTool
end

v2.tool = tool

function v2.list(p: number)
	return getStore().list(p):andThen(function(data) -- inferred equivalent call
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

function v2.mutate(p: number, data)
	local subscriptionId = data.subscriptionId

	if data.action == "create" then
		return toolControllerUtils.withGeneratedImage(
			data.imageAssetId,
			"The subscription image could not be loaded. No subscription was created.",
			function(imageFile)
				return getStore().create(p, { -- inferred equivalent call
					name = data.name,
					description = data.description,
					productType = v[data.productType],
					currencyType = DeveloperSubscription.CurrencyType.Robux,
					priceInRobux = data.priceInRobux,
					isRegionalPricingEnabled = true,
					imageFile = imageFile
				})
			end
		)
	end

	if data.action == "update" then
		return toolControllerUtils.withGeneratedImage(
			data.imageAssetId,
			"The subscription image could not be loaded. No changes were made.",
			function(imageFile)
				local update = getStore().update -- inferred equivalent call
				local v3 = {
					description = data.description,
					currencyType = 0,
					priceInRobux = 0,
					isRegionalPricingEnabled = 0,
					imageFile = 0
				}
				local currencyType

				if data.priceInRobux ~= nil then
					currencyType = DeveloperSubscription.CurrencyType.Robux
				end

				v3.currencyType = currencyType

				v3.priceInRobux = data.priceInRobux
				v3.isRegionalPricingEnabled = data.priceInRobux ~= nil or nil
				v3.imageFile = imageFile
				return update(p, subscriptionId, v3)
			end
		)
	end

	if data.action == "activate" then
		return getStore().activate(p, subscriptionId) -- inferred equivalent call
	elseif data.action == "deactivate" then
		return getStore().deactivate(p, subscriptionId, data.cancelRenewals == true) -- inferred equivalent call
	else
		if data.action ~= "delete" then
			return Promise.reject({
				errorMessage = ("Unsupported action '%s'."):format((tostring(data.action)))
			})
		end

		return getStore().delete(p, subscriptionId):andThen(function(p2) -- inferred equivalent call
			return deletionResult(subscriptionId, p2)
		end)
	end
end

function v2.itemIdOf(p)
	return p.subscriptionId
end

function v2.cardFields(data)
	return {
		productType = data.productType,
		cancelRenewals = data.cancelRenewals,
		imageAssetId = data.imageAssetId
	}
end

return function(p, p2, p3, p4)
	return createMonetizationToolController(v2, p, p2, p3, p4)
end
