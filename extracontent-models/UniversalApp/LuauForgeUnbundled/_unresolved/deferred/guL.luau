local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local module2 = require("@luauforge/deferred/gij")
local module3 = require("@luauforge/bundled/gra")
local module4 = require("@luauforge/deferred/guE")
local module5 = require("@luauforge/deferred/guM")
local module6 = require("@luauforge/deferred/guH")
local module7 = require("@luauforge/deferred/gin")
local module8 = require("@luauforge/bundled/edP")
local module9 = require("@luauforge/bundled/fuX")
local module10 = require("@luauforge/deferred/guP")

return function(callback)
	return {
		dispatchClearNativePurchaseResult = function()
			callback(module3())
		end,
		dispatchFetchIAPProducts = function(p2)
			callback(module2.Fetch(p2))
		end,
		dispatchFetchNativeIAPProducts = function()
			callback(module5.Fetch())
		end,
		dispatchFetchIAPPurchaseWarning = function(p2, p3, p4, p5)
			return callback(module4.Fetch(p2, p3, p4, p5))
		end,
		dispatchPostAckPurchaseWarning = function(p2, p3)
			return callback(module6.Post(p2, p3))
		end,
		dispatchFetchUserBalance = function(p2, p3)
			callback(module9(p2, p3, true))
		end,
		promptRobux = function(p2, p3, p4)
			callback(module7(p2, p3, p4))
		end,
		dispatchNavigateBack = function()
			callback(RobloxAppToastsRodux())
		end,
		dispatchCentralOverlay = function(p2, p3)
			return callback(module8(p2, p3))
		end,
		dispatchCheckUserPurchaseSettings = function(p2)
			return callback(module10.Post(p2))
		end
	}
end
