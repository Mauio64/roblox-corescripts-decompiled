local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local Promise = require(parent.Promise)
local Http = require(parent.Http)
local Url = Http.Url
local requestInternalWrapper = Http.NetworkLayers.requestInternalWrapper
local Constants = require(InExperienceShop.Constants)
require(InExperienceShop.Types)
local Errors = require(script.Parent.Errors)
local multiGetProductInfo = require(script.Parent.multiGetProductInfo)
local buildShopDataFromWidgets = require(script.Parent.buildShopDataFromWidgets)
local ShopDebugLogger = require(InExperienceShop.Internal.ShopDebugLogger)
local FFlagUseShopRequestImpl = require(InExperienceShop.Flags.FFlagUseShopRequestImpl)
local FIntExperienceShopWidgetRequestPriority = require(InExperienceShop.Flags.FIntExperienceShopWidgetRequestPriority)
local FFlagSkipShopWidgetsCallInUnpublishedStudio = require(InExperienceShop.Flags.FFlagSkipShopWidgetsCallInUnpublishedStudio)

local ROBUX_CATEGORY_NAME = Constants.ROBUX_CATEGORY_NAME
local v = Url.APIS_URL .. "marketplace-widgets/v1/widgets/robux-widget"

local v2 = { categories = {}, sections = {}, failedItems = {} }

local function buildRobuxWidgetUrl(requestId: string) -- 2 equivalent calls inferred from this helper
	return `{v}?{Url:makeQueryString({ requestId = requestId, universeId = game.GameId })}`
end

local function validateAndResolve(p, callback, callback2): boolean
	if typeof(p) ~= "table" then
		callback2((Errors.schemaError(
			"fetchRobuxWidgetsAfterPurchase: malformed response, expected { category = ... }",
			p
		)))

		return false
	end

	if p.category == nil or typeof(p.category) == "table" then
		callback(p)
		return true
	end

	callback2((Errors.schemaError("fetchRobuxWidgetsAfterPurchase: malformed response, category must be a table", p)))

	return false
end

local function buildFromWidgetResponse(p, multiGetProductInfo2)
	local category = p.category

	if category == nil then
		return Promise.resolve(v2)
	end

	local items = {}

	for _, item in ipairs(category.items) do
		if item.type == "Robux" then
			table.insert(items, item)
		end
	end

	return buildShopDataFromWidgets({
		categories = {
			{
				id = category.id,
				name = ROBUX_CATEGORY_NAME,
				items = items,
				metadata = category.metadata
			}
		}
	}, multiGetProductInfo2)
end

local function fetchViaGetAsyncFullUrl(p: string)
	return Promise.new(function(p2, callback)
		task.spawn(function()
			local robuxWidgetUrl = buildRobuxWidgetUrl(p) -- inferred equivalent call
			ShopDebugLogger.logLazy(function()
				return "fetchRobuxWidgetsAfterPurchase: GET " .. robuxWidgetUrl
			end)

			local v3 = ShopDebugLogger.startTimer()
			local success, result = pcall(function()
				return HttpRbxApiService:GetAsyncFullUrl(robuxWidgetUrl)
			end)

			if success then
				ShopDebugLogger.logElapsed("fetchRobuxWidgetsAfterPurchase: HTTP response received", v3)
				local success2, result2 = pcall(function()
					return HttpService:JSONDecode(result)
				end)

				if success2 then
					validateAndResolve(result2, p2, callback)
				else
					callback((Errors.parseError(
						"fetchRobuxWidgetsAfterPurchase: response body is not valid JSON",
						result2
					)))
				end
			else
				ShopDebugLogger.logElapsed("fetchRobuxWidgetsAfterPurchase: HTTP error", v3)
				callback((Errors.networkError("fetchRobuxWidgetsAfterPurchase: HTTP request failed", result)))
			end
		end)
	end)
end

local function fetchViaRequestImpl(requestId: string)
	local robuxWidgetUrl = buildRobuxWidgetUrl(requestId) -- inferred equivalent call
	ShopDebugLogger.logLazy(function()
		return "fetchRobuxWidgetsAfterPurchase: GET " .. robuxWidgetUrl
	end)

	local v3 = ShopDebugLogger.startTimer()
	return requestInternalWrapper(HttpService)(
		robuxWidgetUrl,
		"GET",
		FIntExperienceShopWidgetRequestPriority ~= 0 and {
			priority = FIntExperienceShopWidgetRequestPriority
		} or nil
	):andThen(function(p)
		ShopDebugLogger.logElapsed("fetchRobuxWidgetsAfterPurchase: HTTP response received", v3)
		return Promise.new(function(p2, p3)
			validateAndResolve(p.responseBody, p2, p3)
		end)
	end):catch(function(p)
		if typeof(p) == "table" and p.kind ~= nil then
			return Promise.reject(p)
		end

		if typeof(p) == "table" and p.isJSONValid == false then
			return Promise.reject((Errors.parseError(
				"fetchRobuxWidgetsAfterPurchase: response body is not valid JSON",
				p
			)))
		end

		ShopDebugLogger.logElapsed("fetchRobuxWidgetsAfterPurchase: HTTP error", v3)
		return Promise.reject((Errors.networkError("fetchRobuxWidgetsAfterPurchase: HTTP request failed", p)))
	end)
end

local function fetchRobuxWidget(guid: string)
	if FFlagSkipShopWidgetsCallInUnpublishedStudio and RunService:IsStudio() and game.GameId == 0 then
		ShopDebugLogger.logLazy(function()
			return "fetchRobuxWidgetsAfterPurchase: skipped unpublished Studio requestId=" .. guid
		end)

		return Promise.resolve({})
	end

	if FFlagUseShopRequestImpl then
		return fetchViaRequestImpl(guid)
	end

	return fetchViaGetAsyncFullUrl(guid)
end

return {
	fetchRobuxWidgetsAfterPurchase = function()
		local guid = HttpService:GenerateGUID(false)
		ShopDebugLogger.logLazy(function()
			return "fetchRobuxWidgetsAfterPurchase: start requestId=" .. guid
		end)

		return fetchRobuxWidget(guid):andThen(function(p)
			return buildFromWidgetResponse(p, multiGetProductInfo)
		end)
	end,
	buildFromWidgetResponse = buildFromWidgetResponse,
	EMPTY_SHOP_DATA = v2
}
