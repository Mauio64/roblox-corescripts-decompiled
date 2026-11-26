local CorePackages = game:GetService("CorePackages")

local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module = require("@luauforge/bundled/egs")
local module2 = require("@luauforge/deferred/gWN")

local module3 = require("@luauforge/bundled/fyX")
local enumerate = require(CorePackages.Packages.enumerate)

local v5 = {}

local v6 = {
	None = "None",
	ConfirmedU13PaymentModal = "ConfirmedU13PaymentModal",
	ConfirmedU13MonthlyThreshold1Modal = "ConfirmedU13MonthlyThreshold1Modal",
	ConfirmedU13MonthlyThreshold2Modal = "ConfirmedU13MonthlyThreshold2Modal",
	ConfirmParentalConsentWarningPaymentModal13To17 = "ConfirmParentalConsentWarningPaymentModal13To17"
}

v5.UserActionType = enumerate("ApiPostAckPurchaseWarning", v6)
module3(v5.UserActionType, v6)

function v5.Post(p2, p3)
	local rawValue = v5.UserActionType.toRawValue(p3)
	return performFetch.Single("purchasewarning.acknowledge", function(p4)
		return module2(p2, rawValue):andThen(function(p5)
			return module.resolve()
		end, function(p5)
			return module.resolve()
		end)
	end)
end

return v5
