local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")

local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local Promise = require(parent.Promise)
local Http = require(parent.Http)
local Url = Http.Url
local requestInternalWrapper = Http.NetworkLayers.requestInternalWrapper
require(InExperienceShop.Types)
local Errors = require(script.Parent.Errors)
local ShopDebugLogger = require(InExperienceShop.Internal.ShopDebugLogger)
local FFlagUseShopRequestImpl = require(InExperienceShop.Flags.FFlagUseShopRequestImpl)
local FIntExperienceShopWidgetRequestPriority = require(InExperienceShop.Flags.FIntExperienceShopWidgetRequestPriority)
local FFlagSkipShopWidgetsCallInUnpublishedStudio = require(InExperienceShop.Flags.FFlagSkipShopWidgetsCallInUnpublishedStudio)
local RunService = game:GetService("RunService")

local v = Url.APIS_URL .. "marketplace-widgets/v1/widgets/shop-widgets"

local function buildShopWidgetsUrl(requestId: string) -- 2 equivalent calls inferred from this helper
	return `{v}?{Url:makeQueryString({ requestId = requestId, universeId = game.GameId })}`
end

local function logSuccess(p) -- 1 equivalent call inferred from this helper
	ShopDebugLogger.logLazy(function()
		return "fetchShopItemIds: success categories=" .. (typeof(p.categories) == "table" and #p.categories or 0)
	end)
end

local function validateAndResolve(p, callback, callback2): boolean
	if typeof(p) == "table" and p.categories ~= nil then
		logSuccess(p) -- inferred equivalent call
		callback(p)
		return true
	end

	ShopDebugLogger.log("fetchShopItemIds: schema error, missing categories field")
	callback2((Errors.schemaError("fetchShopItemIds: malformed response, expected { categories = ... }", p)))

	return false
end

local function fetchShopItemIdsViaGetAsyncFullUrl(p: string)
	return Promise.new(function(p2, callback)
		task.spawn(function()
			local shopWidgetsUrl = buildShopWidgetsUrl(p) -- inferred equivalent call
			ShopDebugLogger.logLazy(function()
				return "fetchShopItemIds: GET " .. shopWidgetsUrl
			end)

			local v2 = ShopDebugLogger.startTimer()

			local success, result = pcall(function()
				return HttpRbxApiService:GetAsyncFullUrl(shopWidgetsUrl)
			end)

			if success then
				ShopDebugLogger.logElapsed("fetchShopItemIds: HTTP response received", v2)

				local success2, result2 = pcall(function()
					return HttpService:JSONDecode(result)
				end)

				if success2 then
					validateAndResolve(result2, p2, callback)
					return
				end

				ShopDebugLogger.logLazy(function()
					return "fetchShopItemIds: JSON parse error=" .. tostring(result2)
				end)

				callback((Errors.parseError("fetchShopItemIds: response body is not valid JSON", result2)))
			else
				ShopDebugLogger.logElapsed("fetchShopItemIds: HTTP error", v2)
				ShopDebugLogger.logLazy(function()
					return "fetchShopItemIds: HTTP error detail=" .. tostring(result)
				end)

				callback((Errors.networkError("fetchShopItemIds: HTTP request failed", result)))
			end
		end)
	end)
end

local function fetchShopItemIdsViaRequestImpl(requestId: string)
	local shopWidgetsUrl = buildShopWidgetsUrl(requestId) -- inferred equivalent call
	ShopDebugLogger.logLazy(function()
		return "fetchShopItemIds: GET " .. shopWidgetsUrl
	end)

	local v2 = ShopDebugLogger.startTimer()

	return requestInternalWrapper(HttpService)(
		shopWidgetsUrl,
		"GET",
		FIntExperienceShopWidgetRequestPriority ~= 0 and {
			priority = FIntExperienceShopWidgetRequestPriority
		} or nil
	):andThen(function(p)
		ShopDebugLogger.logElapsed("fetchShopItemIds: HTTP response received", v2)
		return Promise.new(function(p2, p3)
			validateAndResolve(p.responseBody, p2, p3)
		end)
	end):catch(function(p)
		if typeof(p) == "table" and p.kind ~= nil then
			return Promise.reject(p)
		end

		if typeof(p) == "table" and p.isJSONValid == false then
			ShopDebugLogger.logLazy(function()
				return "fetchShopItemIds: JSON parse error=" .. tostring(p)
			end)

			return Promise.reject((Errors.parseError("fetchShopItemIds: response body is not valid JSON", p)))
		end

		ShopDebugLogger.logElapsed("fetchShopItemIds: HTTP error", v2)
		ShopDebugLogger.logLazy(function()
			return "fetchShopItemIds: HTTP error detail=" .. tostring(p)
		end)

		return Promise.reject((Errors.networkError("fetchShopItemIds: HTTP request failed", p)))
	end)
end

local function fetchShopItemIds(requestId: string)
	if FFlagSkipShopWidgetsCallInUnpublishedStudio and RunService:IsStudio() and game.GameId == 0 then
		ShopDebugLogger.logLazy(function()
			return "fetchShopItemIds: skipped unpublished Studio experience requestId=" .. requestId
		end)

		return Promise.resolve({ categories = {} })
	end

	if FFlagUseShopRequestImpl then
		ShopDebugLogger.logLazy(function()
			return `fetchShopItemIds: transport=requestInternalWrapper requestId={requestId}{FIntExperienceShopWidgetRequestPriority == 0 and "" or ` priority={FIntExperienceShopWidgetRequestPriority}`}`
		end)

		return fetchShopItemIdsViaRequestImpl(requestId)
	end

	ShopDebugLogger.logLazy(function()
		return `fetchShopItemIds: transport=GetAsyncFullUrl requestId={requestId}`
	end)

	return fetchShopItemIdsViaGetAsyncFullUrl(requestId)
end

return fetchShopItemIds
