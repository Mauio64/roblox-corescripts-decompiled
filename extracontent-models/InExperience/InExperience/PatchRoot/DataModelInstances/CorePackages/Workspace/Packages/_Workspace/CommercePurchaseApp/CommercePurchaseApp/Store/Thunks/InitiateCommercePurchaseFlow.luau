local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")

local CommerceService = game:GetService("CommerceService")
local CommercePurchaseFailed = require(CommercePurchaseApp.Store.Actions.CommercePurchaseFailed)
local CommercePurchaseStarted = require(CommercePurchaseApp.Store.Actions.CommercePurchaseStarted)
local CommercePurchaseCheckout = require(CommercePurchaseApp.Store.Actions.CommercePurchaseCheckout)
local CommercePurchaseEnded = require(CommercePurchaseApp.Store.Actions.CommercePurchaseEnded)
local ErrorCodeEnum = require(CommercePurchaseApp.Enums.ErrorCodeEnum)
local FFlagAddCommerceErrors = require(CommercePurchaseApp.Flags.FFlagAddCommerceErrors)

local parent = CommercePurchaseApp.Parent
local ToastRodux = require(parent.ToastRodux)
local ToastType = ToastRodux.Enums.ToastType
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

local function convertErrorMessageToErrorCode(p: string)
	if FFlagAddCommerceErrors then
		if p == "DeviceTypeNotAllowed" or p == "PurchasePlatformNotSupported" then
			return ErrorCodeEnum.DeviceNotSupported
		end

		if p == "UniverseNotAllowed" or p == "ProductContentModerated" or p == "ProductNotFound" then
			return ErrorCodeEnum.NotPurchasable
		end

		if p == "UserNotAllowed" or p == "AccountCountryNotSupported" or p == "UserAgeNotAllowed" then
			return ErrorCodeEnum.AccountNotSupported
		end

		return ErrorCodeEnum.Generic
	elseif p == "NotPurchasable" then
		return ErrorCodeEnum.NotPurchasable
	else
		return ErrorCodeEnum.Generic
	end
end

local function handleError(result, object, toastTitle)
	local v = convertErrorMessageToErrorCode(result)

	if v ~= ErrorCodeEnum.Generic then
		object:dispatch(CommercePurchaseFailed(v))
		return
	end

	object:dispatch(SetCurrentToastMessage({
		toastType = ToastType.NetworkingError,
		toastTitle = toastTitle
	}))

	object:dispatch(CommercePurchaseEnded())
end

local function InitiateCommercePurchaseFlow(p: string, toastTitle: string)
	return function(object)
		object:dispatch(CommercePurchaseStarted(p))
		local success, result = pcall(function()
			return CommerceService:PrepareCommerceProductPurchase(p)
		end)

		if success then
			object:dispatch(CommercePurchaseCheckout(result.CheckoutSessionId))
		else
			handleError(result, object, toastTitle)
		end
	end
end

return InitiateCommercePurchaseFlow
