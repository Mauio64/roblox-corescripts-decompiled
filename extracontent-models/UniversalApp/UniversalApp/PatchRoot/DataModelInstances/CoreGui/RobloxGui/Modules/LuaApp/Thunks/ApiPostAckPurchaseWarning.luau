local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Promise = require(Modules.LuaApp.Promise)
local PostAckPurchaseWarning = require(Modules.LuaApp.Http.Requests.PurchaseWarningApi.PostAckPurchaseWarning)
local addRawValueMethodToEnum = require(Modules.LuaApp.Enum.AccountSecurity.addRawValueMethodToEnum)
local enumerate = require(CorePackages.Packages.enumerate)
local t1 = {}
local t2 = {
	None = "None",
	ConfirmedU13PaymentModal = "ConfirmedU13PaymentModal",
	ConfirmedU13MonthlyThreshold1Modal = "ConfirmedU13MonthlyThreshold1Modal",
	ConfirmedU13MonthlyThreshold2Modal = "ConfirmedU13MonthlyThreshold2Modal",
	ConfirmParentalConsentWarningPaymentModal13To17 = "ConfirmParentalConsentWarningPaymentModal13To17"
}

t1.UserActionType = enumerate(script.Name, t2)
addRawValueMethodToEnum(t1.UserActionType, t2)

function t1.Post(p1: ((...any) -> ...any), p2) -- line: 26
	-- upvalues: t1 (copy), PerformFetch (copy), PostAckPurchaseWarning (copy), Promise (copy)
	local v12 = t1.UserActionType.toRawValue(p2)

	return PerformFetch.Single("purchasewarning.acknowledge", function(_) -- line: 29
		-- upvalues: PostAckPurchaseWarning (copy), p1 (copy), v12 (copy), Promise (copy)
		return PostAckPurchaseWarning(p1, v12):andThen(function(_) -- line: 30
			-- upvalues: Promise (copy)
			return Promise.resolve()
		end, function(_) -- line: 32
			-- upvalues: Promise (copy)
			return Promise.resolve()
		end)
	end)
end

return t1
