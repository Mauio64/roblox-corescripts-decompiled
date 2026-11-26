local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Rodux

local AccountInfoReceived = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/AccountInfoReceived")
local BalanceInfoRecieved = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/BalanceInfoRecieved")

return (rodux.createReducer({}, {
	[AccountInfoReceived.name] = function(p2, p3)
		local accountInfo = p3.accountInfo

		return {
			balance = p2.balance,
			membershipType = accountInfo.isPremium and 4 or 0
		}
	end,
	[BalanceInfoRecieved.name] = function(p2, p3)
		local balanceInfo = p3.balanceInfo
		return {
			balance = balanceInfo.robux,
			hasFailed = balanceInfo.hasFailed,
			membershipType = p2.membershipType
		}
	end
}))
