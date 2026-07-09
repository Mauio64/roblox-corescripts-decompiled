local Modules = game:GetService("CoreGui").RobloxGui.Modules
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local ApiFetchIAPProducts = require(Modules.LuaApp.Thunks.ApiFetchIAPProducts)
local ClearNativePurchaseResult = require(Modules.LuaApp.Actions.ClearNativePurchaseResult)
local ApiFetchIAPPurchaseWarning = require(Modules.LuaApp.Thunks.ApiFetchIAPPurchaseWarning)
local FetchNativeIAPProducts = require(Modules.LuaApp.Thunks.FetchNativeIAPProducts)
local ApiPostAckPurchaseWarning = require(Modules.LuaApp.Thunks.ApiPostAckPurchaseWarning)
local OpenNativePurchase = require(Modules.LuaApp.Thunks.Economy.OpenNativePurchase)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local ApiFetchEconomyCurrency = require(Modules.LuaApp.Thunks.ApiFetchEconomyCurrency)
local ApiPostCheckUserPurchaseSettings = require(Modules.LuaApp.Thunks.ApiPostCheckUserPurchaseSettings)

return function(p1) -- line: 15
	-- upvalues: ClearNativePurchaseResult (copy), ApiFetchIAPProducts (copy), FetchNativeIAPProducts (copy), ApiFetchIAPPurchaseWarning (copy), ApiPostAckPurchaseWarning (copy), ApiFetchEconomyCurrency (copy), OpenNativePurchase (copy), NavigateBack (copy), SetCentralOverlay (copy), ApiPostCheckUserPurchaseSettings (copy)
	return {
		dispatchClearNativePurchaseResult = function() -- line: 17
			-- upvalues: p1 (copy), ClearNativePurchaseResult (copy)
			p1(ClearNativePurchaseResult())
		end,
		dispatchFetchIAPProducts = function(p2) -- line: 20
			-- upvalues: p1 (copy), ApiFetchIAPProducts (copy)
			p1(ApiFetchIAPProducts.Fetch(p2))
		end,
		dispatchFetchNativeIAPProducts = function() -- line: 23
			-- upvalues: p1 (copy), FetchNativeIAPProducts (copy)
			p1(FetchNativeIAPProducts.Fetch())
		end,
		dispatchFetchIAPPurchaseWarning = function(p3, s1: string, n1: number, b1: boolean) -- line: 26
			-- upvalues: p1 (copy), ApiFetchIAPPurchaseWarning (copy)
			return p1(ApiFetchIAPPurchaseWarning.Fetch(p3, s1, n1, b1))
		end,
		dispatchPostAckPurchaseWarning = function(p4, p5) -- line: 34
			-- upvalues: p1 (copy), ApiPostAckPurchaseWarning (copy)
			return p1(ApiPostAckPurchaseWarning.Post(p4, p5))
		end,
		dispatchFetchUserBalance = function(p6, p7) -- line: 37
			-- upvalues: p1 (copy), ApiFetchEconomyCurrency (copy)
			p1(ApiFetchEconomyCurrency(p6, p7, true))
		end,
		promptRobux = function(p8, s2: string, n2: number) -- line: 40
			-- upvalues: p1 (copy), OpenNativePurchase (copy)
			p1(OpenNativePurchase(p8, s2, n2))
		end,
		dispatchNavigateBack = function() -- line: 43
			-- upvalues: p1 (copy), NavigateBack (copy)
			p1(NavigateBack())
		end,
		dispatchCentralOverlay = function(p9, p10) -- line: 46
			-- upvalues: p1 (copy), SetCentralOverlay (copy)
			return p1(SetCentralOverlay(p9, p10))
		end,
		dispatchCheckUserPurchaseSettings = function(p11) -- line: 49
			-- upvalues: p1 (copy), ApiPostCheckUserPurchaseSettings (copy)
			return p1(ApiPostCheckUserPurchaseSettings.Post(p11))
		end
	}
end
