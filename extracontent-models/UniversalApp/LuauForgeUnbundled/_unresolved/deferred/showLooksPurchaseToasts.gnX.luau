local LocalizationService = game:GetService("LocalizationService")

local localization = require("@game/CorePackages/Workspace/Packages/RobloxAppLocales").Localization
local module = require("@luauforge/bundled/dCh")
local module2 = require("@luauforge/bundled/dwB")

local function showLooksPurchaseToasts(p2, callback)
	local v5 = localization.new(LocalizationService.RobloxLocaleId)
	local successCount = p2.successCount
	local failureCount = p2.failureCount

	if successCount > 0 and failureCount <= 0 then
		local v6 = if successCount == 1 then v5:Format(
			"Feature.Avatar.Message.LooksPurchaseSuccessSingular",
			{ numItems = successCount }
		) else v5:Format("Feature.Avatar.Message.LooksPurchaseSuccessPlural", {
			numItems = successCount
		})

		callback(module({
			isLocalized = true,
			toastMessage = v6,
			toastType = module2.PurchaseMessage
		}))
	elseif successCount > 0 and failureCount > 0 then
		local v6

		if successCount == 1 and failureCount == 1 then
			v6 = "Feature.Avatar.Message.LooksPurchasePartialSuccessGenericSS"
		elseif successCount == 1 and failureCount > 1 then
			v6 = "Feature.Avatar.Message.LooksPurchasePartialSuccessGenericSP"
		elseif successCount > 1 and failureCount == 1 then
			v6 = "Feature.Avatar.Message.LooksPurchasePartialSuccessGenericPS"
		else
			v6 = "Feature.Avatar.Message.LooksPurchasePartialSuccessGenericPP"
		end

		callback(module({
			isLocalized = true,
			toastMessage = v5:Format("Feature.Avatar.Heading.LooksPurchasePartialSuccess"),
			toastSubMessage = v5:Format(v6, {
				numSuccessItems = successCount,
				numFailureItems = failureCount
			}),
			toastType = module2.NetworkingError
		}))
	elseif successCount <= 0 and failureCount > 0 then
		callback(module({
			isLocalized = true,
			toastMessage = v5:Format("Feature.Avatar.Heading.LooksPurchaseFailed"),
			toastSubMessage = v5:Format("Feature.Avatar.Message.LooksPurchaseFailedNetworkError"),
			toastType = module2.NetworkingError
		}))
	end
end

return showLooksPurchaseToasts
