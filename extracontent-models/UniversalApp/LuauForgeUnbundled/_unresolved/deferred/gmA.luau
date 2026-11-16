local CorePackages = game:GetService("CorePackages")
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local Promise = require(CorePackages.Packages.Promise)

local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module2 = require("@luauforge/bundled/fuC")
local module3 = require("@luauforge/bundled/dMV")

local module4 = require("@luauforge/bundled/dME")

local module5 = require("@luauforge/bundled/ecW")
local module6 = require("@luauforge/bundled/dCh")
local itemData = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Selectors.ItemData
local module7 = require("@luauforge/bundled/dwB")

local v5 = { HttpError = Enum.HttpError.OK }

local v6 = {
	toastMessage = "Feature.Catalog.Label.Redeemed",
	isLocalized = false,
	toastType = module7.SuccessConfirmation
}

local v7 = {
	toastMessage = "Feature.Catalog.Label.NotAvailable",
	isLocalized = false,
	toastType = module7.InformationMessage
}

local v8 = {
	toastMessage = "Feature.Catalog.Label.AlreadyOwned",
	isLocalized = false,
	toastType = module7.InformationMessage
}

local function redeemQRCodeItemKeyMapper(p2)
	return module4.RedeemQRCodeItemKey .. tostring(p2)
end

return function(p2, p3, p4, p5)
	return performFetch.Single(module4.RedeemQRCodeItemKey .. tostring(p4), function(object)
		return object:dispatch(module2(p2, p3, p4, p5)):andThen(function()
			local v9 = itemData(object:getState().AvatarExperience.Common, p4, p5)

			if v9 and v9.isOwned then
				object:dispatch(module6(v8))
				return Promise.resolve()
			end

			return GetExperienceSourceLanguage.RedeemQRCodeItem(p2, p4):andThen(function(p6)
				local responseBody = p6.responseBody

				if type(responseBody) == "table" and responseBody.success == true then
					object:dispatch(module3(p4, true))
					object:dispatch(module6(v6))
					return Promise.resolve()
				else
					local v10 = v5
					logging.warn("Response from RedeemQRCodeItem is malformed!")
					object:dispatch(module5(v10))
					return Promise.reject(v10)
				end
			end, function(p6)
				if type(p6) ~= "table" or p6.HttpError == nil then
					p6 = v5
				end

				object:dispatch(module6(v7))
				return Promise.reject(p6)
			end)
		end)
	end)
end
