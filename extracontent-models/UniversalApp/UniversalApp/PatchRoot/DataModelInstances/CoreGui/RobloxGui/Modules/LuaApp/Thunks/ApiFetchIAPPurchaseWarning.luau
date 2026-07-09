local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local GetPurchaseWarning = require(Modules.LuaApp.Http.Requests.PurchaseWarningApi.GetPurchaseWarning)
local getPaymentPlatform = require(Modules.LuaApp.Util.getPaymentPlatform)
local PaymentPlatform = require(Modules.LuaApp.Enum.PaymentPlatform)
local addRawValueMethodToEnum = require(Modules.LuaApp.Enum.AccountSecurity.addRawValueMethodToEnum)
local enumerate = require(CorePackages.Packages.enumerate)

require(CorePackages.Workspace.Packages.Http)

local GetFFlagUADesktopPurchaseWarnings = require(Modules.LuaApp.Flags.GetFFlagUADesktopPurchaseWarnings)
local t1 = {}
local t2 = {
	None = "None",
	U13PaymentModal = "U13PaymentModal",
	U13MonthlyThreshold1Modal = "U13MonthlyThreshold1Modal",
	U13MonthlyThreshold2Modal = "U13MonthlyThreshold2Modal",
	ParentalConsentWarningPaymentModal13To17 = "ParentalConsentWarningPaymentModal13To17"
}

t1.ResponseType = enumerate(script.Name, t2)
addRawValueMethodToEnum(t1.ResponseType, t2)

function t1.Fetch(p1, s1: string?, n1: number?, b1: boolean?) -- line: 30
	-- upvalues: getPaymentPlatform (copy), GetFFlagUADesktopPurchaseWarnings (copy), PaymentPlatform (copy), Promise (copy), t1 (copy), GetPurchaseWarning (copy)
	return function(_) -- line: 36
		-- upvalues: getPaymentPlatform (copy), GetFFlagUADesktopPurchaseWarnings (copy), PaymentPlatform (copy), s1 (ref), n1 (ref), Promise (copy), t1 (copy), GetPurchaseWarning (copy), p1 (copy), b1 (copy)
		local v19 = getPaymentPlatform()

		if GetFFlagUADesktopPurchaseWarnings() then
			if v19 == PaymentPlatform.Web then
				s1 = nil
			else
				n1 = nil
			end
		elseif v19 == PaymentPlatform.Web then
			return Promise.resolve(t1.ResponseType.None)
		end

		return GetPurchaseWarning(p1, s1, n1, b1):andThen(function(p3) -- line: 51
			-- upvalues: Promise (copy), t1 (copy)
			if p3 == nil or p3[1] == nil then
				return Promise.resolve(t1.ResponseType.None)
			end

			local v21 = p3[1]
			local None = t1.ResponseType.None

			if v21 then
				if v21.action == "U13PaymentModal" then
					None = t1.ResponseType.U13PaymentModal
				elseif v21.action == "U13MonthlyThreshold1Modal" then
					None = t1.ResponseType.U13MonthlyThreshold1Modal
				elseif v21.action == "U13MonthlyThreshold2Modal" then
					None = t1.ResponseType.U13MonthlyThreshold2Modal
				elseif v21.action == "ParentalConsentWarningPaymentModal13To17" then
					None = t1.ResponseType.ParentalConsentWarningPaymentModal13To17
				end
			end

			return Promise.resolve(None)
		end, function() -- line: 73
			-- upvalues: Promise (copy), t1 (copy)
			return Promise.resolve(t1.ResponseType.None)
		end)
	end
end

return t1
