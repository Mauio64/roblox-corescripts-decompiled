local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local module = require("@luauforge/bundled/dwM")

local module2 = require("@luauforge/bundled/dSp")
local module3 = require("@luauforge/bundled/dSj")
local module4 = require("@luauforge/bundled/dSe")
local module5 = require("@luauforge/bundled/dME")

local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module7 = require("@luauforge/bundled/dCh")
local module8 = require("@luauforge/bundled/ecW")

local function keyMapper(p2)
	return module5.RemoveCurrentlySellingAssetKey .. tostring(p2)
end

local v5 = {
	toastMessage = "Feature.Catalog.Heading.ItemRemoved",
	isLocalized = false,
	toastType = require("@luauforge/bundled/dwB").SuccessConfirmation
}

return function(p2, p3, p4, p5)
	return function(p6)
		module.isType(p3, "string", "RemoveCurrentlySellingAsset thunk expects assetId to be a string")
		module.isType(p5, "string", "RemoveCurrentlySellingAsset thunk expects userId to be a string")
		module.isType(p4, "string", "RemoveCurrentlySellingAsset thunk expects userAssetId to be a string")
		return performFetch.Single(module5.RemoveCurrentlySellingAssetKey .. tostring(p4), function(object)
			return GetExperienceSourceLanguage.RemoveCurrentlySellingAsset(p2, p3, p4):andThen(function(p7)
				object:dispatch(module2(p4, nil))
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
