local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local Promise = require(InExperienceShopParent.Promise)
local Http = require(InExperienceShopParent.Http)
local Url = Http.Url
local requestInternalWrapper = Http.NetworkLayers.requestInternalWrapper

require(InExperienceShop.Types)

local Errors = require(script.Parent.Errors)
local ShopDebugLogger = require(InExperienceShop.Internal.ShopDebugLogger)
local FFlagUseShopRequestImpl = require(InExperienceShop.Flags.FFlagUseShopRequestImpl)
local FIntExperienceShopWidgetRequestPriority = require(InExperienceShop.Flags.FIntExperienceShopWidgetRequestPriority)
local v13 = Url.APIS_URL .. "marketplace-widgets/v1/widgets/shop-widgets"

local function buildShopWidgetsUrl(s1: string) -- line: 26
	-- upvalues: Url (copy), v13 (copy)
	local v21 = Url:makeQueryString({
		requestId = s1,
		universeId = game.GameId
	})

	return `{ v13 }?{ v21 }`
end
local function logSuccess(p1) -- line: 34
	-- upvalues: ShopDebugLogger (copy)
	ShopDebugLogger.logLazy(function() -- line: 35
		-- upvalues: p1 (copy)
		return "fetchShopItemIds: success categories=" .. (typeof(p1.categories) == "table" and #p1.categories or 0)
	end)
end
local function validateAndResolve(p2, p3: ((...any) -> ...any), p4: ((...any) -> ...any)) -- line: 41
	-- upvalues: ShopDebugLogger (copy), Errors (copy)
	if typeof(p2) ~= "table" or p2.categories == nil then
		ShopDebugLogger.log("fetchShopItemIds: schema error, missing categories field")
		p4((Errors.schemaError("fetchShopItemIds: malformed response, expected { categories = ... }", p2)))

		return false
	end

	ShopDebugLogger.logLazy(function() -- line: 35
		-- upvalues: p2 (copy)
		return "fetchShopItemIds: success categories=" .. (typeof(p2.categories) == "table" and #p2.categories or 0)
	end)
	p3(p2)

	return true
end
local function fetchShopItemIdsViaGetAsyncFullUrl(s2: string) -- line: 68
	-- upvalues: Promise (copy), Url (copy), v13 (copy), ShopDebugLogger (copy), HttpRbxApiService (copy), Errors (copy), HttpService (copy), validateAndResolve (copy)
	return Promise.new(function(resolve, reject) -- line: 69
		-- upvalues: s2 (copy), Url (copy), v13 (copy), ShopDebugLogger (copy), HttpRbxApiService (copy), Errors (copy), HttpService (copy), validateAndResolve (copy)
		task.spawn(function() -- line: 70
			-- upvalues: s2 (copy), Url (copy), v13 (copy), ShopDebugLogger (copy), HttpRbxApiService (copy), reject (copy), Errors (copy), HttpService (copy), validateAndResolve (copy), resolve (copy)
			local v37 = s2
			local v38 = Url:makeQueryString({
				requestId = v37,
				universeId = game.GameId
			})
			local v39 = `{ v13 }?{ v38 }`

			ShopDebugLogger.logLazy(function() -- line: 73
				-- upvalues: v39 (copy)
				return "fetchShopItemIds: GET " .. v39
			end)

			local v40 = ShopDebugLogger.startTimer()
			local ok, result = pcall(function() -- line: 83
				-- upvalues: HttpRbxApiService (copy), v39 (copy)
				return HttpRbxApiService:GetAsyncFullUrl(v39)
			end)

			if not ok then
				ShopDebugLogger.logElapsed("fetchShopItemIds: HTTP error", v40)
				ShopDebugLogger.logLazy(function() -- line: 88
					-- upvalues: result (copy)
					return "fetchShopItemIds: HTTP error detail=" .. tostring(result)
				end)
				reject((Errors.networkError("fetchShopItemIds: HTTP request failed", result)))

				return
			end

			ShopDebugLogger.logElapsed("fetchShopItemIds: HTTP response received", v40)

			local ok2, result2 = pcall(function() -- line: 97
				-- upvalues: HttpService (copy), result (copy)
				return HttpService:JSONDecode(result)
			end)

			if not ok2 then
				ShopDebugLogger.logLazy(function() -- line: 101
					-- upvalues: result2 (copy)
					return "fetchShopItemIds: JSON parse error=" .. tostring(result2)
				end)
				reject((Errors.parseError("fetchShopItemIds: response body is not valid JSON", result2)))

				return
			end

			validateAndResolve(result2, resolve, reject)
		end)
	end)
end
local function fetchShopItemIdsViaRequestImpl(s3: string) -- line: 113
	-- upvalues: Url (copy), v13 (copy), ShopDebugLogger (copy), requestInternalWrapper (copy), HttpService (copy), FIntExperienceShopWidgetRequestPriority (copy), Promise (copy), validateAndResolve (copy), Errors (copy)
	local v28 = Url:makeQueryString({
		requestId = s3,
		universeId = game.GameId
	})
	local v29 = `{ v13 }?{ v28 }`

	ShopDebugLogger.logLazy(function() -- line: 116
		-- upvalues: v29 (copy)
		return "fetchShopItemIds: GET " .. v29
	end)

	local v30 = ShopDebugLogger.startTimer()

	return requestInternalWrapper(HttpService)(v29, "GET", (if FIntExperienceShopWidgetRequestPriority == 0 then nil else {
		priority = FIntExperienceShopWidgetRequestPriority
	})):andThen(function(p5) -- line: 128
		-- upvalues: ShopDebugLogger (copy), v30 (copy), Promise (copy), validateAndResolve (copy)
		ShopDebugLogger.logElapsed("fetchShopItemIds: HTTP response received", v30)

		return Promise.new(function(resolve, reject) -- line: 130
			-- upvalues: validateAndResolve (copy), p5 (copy)
			validateAndResolve(p5.responseBody, resolve, reject)
		end)
	end):catch(function(p6) -- line: 134
		-- upvalues: Promise (copy), ShopDebugLogger (copy), Errors (copy), v30 (copy)
		if typeof(p6) == "table" and p6.kind ~= nil then
			return Promise.reject(p6)
		end

		if typeof(p6) == "table" and p6.isJSONValid == false then
			ShopDebugLogger.logLazy(function() -- line: 140
				-- upvalues: p6 (copy)
				return "fetchShopItemIds: JSON parse error=" .. tostring(p6)
			end)

			return Promise.reject((Errors.parseError("fetchShopItemIds: response body is not valid JSON", p6)))
		end

		ShopDebugLogger.logElapsed("fetchShopItemIds: HTTP error", v30)
		ShopDebugLogger.logLazy(function() -- line: 149
			-- upvalues: p6 (copy)
			return "fetchShopItemIds: HTTP error detail=" .. tostring(p6)
		end)

		return Promise.reject((Errors.networkError("fetchShopItemIds: HTTP request failed", p6)))
	end)
end
local function fetchShopItemIds(s4: string) -- line: 156
	-- upvalues: FFlagUseShopRequestImpl (copy), ShopDebugLogger (copy), FIntExperienceShopWidgetRequestPriority (copy), fetchShopItemIdsViaRequestImpl (copy), fetchShopItemIdsViaGetAsyncFullUrl (copy)
	if FFlagUseShopRequestImpl then
		ShopDebugLogger.logLazy(function() -- line: 158
			-- upvalues: FIntExperienceShopWidgetRequestPriority (copy), s4 (copy)
			local v36 = FIntExperienceShopWidgetRequestPriority == 0 and "" or ` priority={ FIntExperienceShopWidgetRequestPriority }`

			return `fetchShopItemIds: transport=requestInternalWrapper requestId={ s4 }{ v36 }`
		end)

		return fetchShopItemIdsViaRequestImpl(s4)
	end

	ShopDebugLogger.logLazy(function() -- line: 167
		-- upvalues: s4 (copy)
		return `fetchShopItemIds: transport=GetAsyncFullUrl requestId={ s4 }`
	end)

	return fetchShopItemIdsViaGetAsyncFullUrl(s4)
end

return fetchShopItemIds
