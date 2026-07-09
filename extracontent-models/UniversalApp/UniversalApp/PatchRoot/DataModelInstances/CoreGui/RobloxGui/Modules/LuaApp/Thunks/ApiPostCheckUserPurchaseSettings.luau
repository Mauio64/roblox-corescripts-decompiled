local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Promise = require(Modules.LuaApp.Promise)
local CheckUserPurchaseSettings = require(Modules.LuaApp.Http.Requests.PaymentsGatewayApi.CheckUserPurchaseSettings)
local addRawValueMethodToEnum = require(Modules.LuaApp.Enum.AccountSecurity.addRawValueMethodToEnum)
local enumerate = require(CorePackages.Packages.enumerate)
local t1 = {}
local t2 = {
	None = "None",
	PurchaseNotEnabled = "PurchaseNotEnabled",
	SpendLimitExceeded = "SpendLimitExceeded"
}

t1.FailureReason = enumerate(script.Name, t2)
addRawValueMethodToEnum(t1.FailureReason, t2)

function t1.Post(p1: ((...any) -> ...any)) -- line: 24
	-- upvalues: PerformFetch (copy), CheckUserPurchaseSettings (copy), Promise (copy)
	return PerformFetch.Single("PostCheckUserPurchaseSettings", function(_) -- line: 26
		-- upvalues: CheckUserPurchaseSettings (copy), p1 (copy), Promise (copy)
		return CheckUserPurchaseSettings(p1):andThen(function(p3) -- line: 27
			-- upvalues: Promise (copy)
			local v13 = p3[1]

			return Promise.resolve(v13)
		end, function(_) -- line: 30
			-- upvalues: Promise (copy)
			return Promise.resolve()
		end)
	end)
end

return t1
