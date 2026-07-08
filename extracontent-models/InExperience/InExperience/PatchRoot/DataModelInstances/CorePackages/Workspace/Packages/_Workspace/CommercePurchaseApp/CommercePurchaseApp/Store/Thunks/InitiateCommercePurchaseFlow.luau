local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")
local CommerceService = game:GetService("CommerceService")
local CommercePurchaseFailed = require(CommercePurchaseApp.Store.Actions.CommercePurchaseFailed)
local CommercePurchaseStarted = require(CommercePurchaseApp.Store.Actions.CommercePurchaseStarted)
local CommercePurchaseCheckout = require(CommercePurchaseApp.Store.Actions.CommercePurchaseCheckout)
local CommercePurchaseEnded = require(CommercePurchaseApp.Store.Actions.CommercePurchaseEnded)
local ErrorCodeEnum = require(CommercePurchaseApp.Enums.ErrorCodeEnum)
local FFlagAddCommerceErrors = require(CommercePurchaseApp.Flags.FFlagAddCommerceErrors)
local CommercePurchaseAppParent = CommercePurchaseApp.Parent
local ToastRodux = require(CommercePurchaseAppParent.ToastRodux)
local ToastType = ToastRodux.Enums.ToastType
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

local function convertErrorMessageToErrorCode(s1: string) -- line: 16
	-- upvalues: FFlagAddCommerceErrors (copy), ErrorCodeEnum (copy)
	if FFlagAddCommerceErrors then
		if s1 == "DeviceTypeNotAllowed" or s1 == "PurchasePlatformNotSupported" then
			return ErrorCodeEnum.DeviceNotSupported
		end

		if s1 == "UniverseNotAllowed" or s1 == "ProductContentModerated" or s1 == "ProductNotFound" then
			return ErrorCodeEnum.NotPurchasable
		end

		if s1 == "UserNotAllowed" or s1 == "AccountCountryNotSupported" or s1 == "UserAgeNotAllowed" then
			return ErrorCodeEnum.AccountNotSupported
		end

		return ErrorCodeEnum.Generic
	end

	if s1 == "NotPurchasable" then
		return ErrorCodeEnum.NotPurchasable
	end

	return ErrorCodeEnum.Generic
end
local function handleError(p1, p2, p3) -- line: 44
	-- upvalues: convertErrorMessageToErrorCode (copy), ErrorCodeEnum (copy), SetCurrentToastMessage (copy), ToastType (copy), CommercePurchaseEnded (copy), CommercePurchaseFailed (copy)
	local v20 = convertErrorMessageToErrorCode(p1)

	if v20 == ErrorCodeEnum.Generic then
		p2:dispatch(SetCurrentToastMessage({
			toastType = ToastType.NetworkingError,
			toastTitle = p3
		}))
		p2:dispatch(CommercePurchaseEnded())

		return
	end

	p2:dispatch(CommercePurchaseFailed(v20))
end
local function InitiateCommercePurchaseFlow(s2: string, s3: string) -- line: 58
	-- upvalues: CommercePurchaseStarted (copy), CommerceService (copy), CommercePurchaseCheckout (copy), handleError (copy)
	return function(p4) -- line: 59
		-- upvalues: CommercePurchaseStarted (copy), s2 (copy), CommerceService (copy), CommercePurchaseCheckout (copy), handleError (copy), s3 (copy)
		p4:dispatch(CommercePurchaseStarted(s2))

		local ok, result = pcall(function() -- line: 61
			-- upvalues: CommerceService (copy), s2 (copy)
			return CommerceService:PrepareCommerceProductPurchase(s2)
		end)

		if ok then
			p4:dispatch(CommercePurchaseCheckout(result.CheckoutSessionId))

			return
		end

		handleError(result, p4, s3)
	end
end

return InitiateCommercePurchaseFlow
