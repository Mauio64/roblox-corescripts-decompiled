local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ecV")
local module2 = require("@luauforge/deferred/guF")
local module3 = require("@luauforge/bundled/ftq")
local module4 = require("@luauforge/bundled/ftu")

local module5 = require("@luauforge/bundled/frD")
local enumerate = require(CorePackages.Packages.enumerate)
require("@game/CorePackages/Workspace/Packages/Http")

local module6 = require("@luauforge/deferred/guG")

local v5 = {}

local v6 = {
	None = "None",
	U13PaymentModal = "U13PaymentModal",
	U13MonthlyThreshold1Modal = "U13MonthlyThreshold1Modal",
	U13MonthlyThreshold2Modal = "U13MonthlyThreshold2Modal",
	ParentalConsentWarningPaymentModal13To17 = "ParentalConsentWarningPaymentModal13To17"
}

v5.ResponseType = enumerate("ApiFetchIAPPurchaseWarning", v6)
module5(v5.ResponseType, v6)

function v5.Fetch(p2, p3, p4, p5)
	return function(p6)
		local v7 = module3()

		if module6() then
			if v7 == module4.Web then
				p3 = nil
			else
				p4 = nil
			end

			return module2(p2, p3, p4, p5):andThen(function(list)
				if list == nil or list[1] == nil then
					return module.resolve(v5.ResponseType.None)
				end

				local v8 = list[1]

				local v9 = v5.ResponseType.None

				if v8 then
					if v8.action == "U13PaymentModal" then
						v9 = v5.ResponseType.U13PaymentModal
					elseif v8.action == "U13MonthlyThreshold1Modal" then
						v9 = v5.ResponseType.U13MonthlyThreshold1Modal
					elseif v8.action == "U13MonthlyThreshold2Modal" then
						v9 = v5.ResponseType.U13MonthlyThreshold2Modal
					elseif v8.action == "ParentalConsentWarningPaymentModal13To17" then
						v9 = v5.ResponseType.ParentalConsentWarningPaymentModal13To17
					end
				end

				return module.resolve(v9)
			end, function()
				return module.resolve(v5.ResponseType.None)
			end)
		elseif v7 == module4.Web then
			return module.resolve(v5.ResponseType.None)
		else
			return module2(p2, p3, p4, p5):andThen(function(list)
				if list == nil or list[1] == nil then
					return module.resolve(v5.ResponseType.None)
				end

				local v8 = list[1]

				local v9 = v5.ResponseType.None

				if v8 then
					if v8.action == "U13PaymentModal" then
						v9 = v5.ResponseType.U13PaymentModal
					elseif v8.action == "U13MonthlyThreshold1Modal" then
						v9 = v5.ResponseType.U13MonthlyThreshold1Modal
					elseif v8.action == "U13MonthlyThreshold2Modal" then
						v9 = v5.ResponseType.U13MonthlyThreshold2Modal
					elseif v8.action == "ParentalConsentWarningPaymentModal13To17" then
						v9 = v5.ResponseType.ParentalConsentWarningPaymentModal13To17
					end
				end

				return module.resolve(v9)
			end, function()
				return module.resolve(v5.ResponseType.None)
			end)
		end
	end
end

return v5
