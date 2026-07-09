local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Localization = require(CorePackages.Workspace.Packages.RobloxAppLocales).Localization
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)

local function showLooksPurchaseToasts(t1: {[any]: any}, p1: ((...any) -> ...any)) -- line: 18
	-- upvalues: Localization (copy), LocalizationService (copy), SetCurrentToastMessage (copy), ToastType (copy)
	local v10 = Localization.new(LocalizationService.RobloxLocaleId)
	local successCount = t1.successCount
	local failureCount = t1.failureCount

	if successCount > 0 and failureCount <= 0 then
		local v13 = if successCount ~= 1 then v10:Format("Feature.Avatar.Message.LooksPurchaseSuccessPlural", {
			numItems = successCount
		}) else v10:Format("Feature.Avatar.Message.LooksPurchaseSuccessSingular", {
			numItems = successCount
		})

		p1(SetCurrentToastMessage({
			isLocalized = true,
			toastMessage = v13,
			toastType = ToastType.PurchaseMessage
		}))

		return
	end

	if successCount > 0 and failureCount > 0 then
		local v14 = if successCount ~= 1 or failureCount ~= 1 then if successCount ~= 1 or not (failureCount > 1) then (not (successCount > 1) or failureCount ~= 1) and "Feature.Avatar.Message.LooksPurchasePartialSuccessGenericPP" or "Feature.Avatar.Message.LooksPurchasePartialSuccessGenericPS" else "Feature.Avatar.Message.LooksPurchasePartialSuccessGenericSP" else "Feature.Avatar.Message.LooksPurchasePartialSuccessGenericSS"

		p1(SetCurrentToastMessage({
			isLocalized = true,
			toastMessage = v10:Format("Feature.Avatar.Heading.LooksPurchasePartialSuccess"),
			toastSubMessage = v10:Format(v14, {
				numSuccessItems = successCount,
				numFailureItems = failureCount
			}),
			toastType = ToastType.NetworkingError
		}))

		return
	end

	if successCount <= 0 and failureCount > 0 then
		p1(SetCurrentToastMessage({
			isLocalized = true,
			toastMessage = v10:Format("Feature.Avatar.Heading.LooksPurchaseFailed"),
			toastSubMessage = v10:Format("Feature.Avatar.Message.LooksPurchaseFailedNetworkError"),
			toastType = ToastType.NetworkingError
		}))
	end
end

return showLooksPurchaseToasts
