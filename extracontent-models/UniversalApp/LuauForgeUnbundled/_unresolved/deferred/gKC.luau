local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local module = require("@luauforge/bundled/dzP")

local module2 = require("@luauforge/bundled/dVK")
local module3 = require("@luauforge/bundled/dVD")
local module4 = require("@luauforge/bundled/dVA")
local module5 = require("@luauforge/bundled/dPU")

local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module7 = require("@luauforge/bundled/dFm")
local module8 = require("@luauforge/bundled/egt")

local function keyMapper(p2)
	return module5.RemoveAvailableToSellAssetKey .. tostring(p2)
end

local v5 = {
	toastMessage = "Feature.Catalog.Label.SellSuccess",
	isLocalized = false,
	toastType = require("@luauforge/bundled/dzE").SuccessConfirmation
}

return function(p2, p3, p4, p5)
	return function(p6)
		module.isType(p3, "string", "RemoveAvailableToSellAsset thunk expects assetId to be a string")
		module.isType(p4, "string", "RemoveAvailableToSellAsset thunk expects userAssetId to be a string")
		module.isType(p5, "number", "RemoveAvailableToSellAsset thunk expects priceInRobux to be a number")
		return performFetch.Single(module5.RemoveAvailableToSellAssetKey .. tostring(p4), function(object)
			return GetExperienceSourceLanguage.RemoveAvailableToSell(p2, p3, p4, p5):andThen(function(p7)
				object:dispatch(module2(p4, p5))
				object:dispatch(module4(p3, p4))
				object:dispatch(module3(p3, p4))

				object:dispatch(module7(v5))

				return Promise.resolve()
			end, function(p7)
				object:dispatch(module8(p7))
				return Promise.reject(p7)
			end)
		end)(p6)
	end
end
