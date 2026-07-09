local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local AccountInfoReceived = require(PurchasePrompt.Actions.AccountInfoReceived)
local BalanceInfoRecieved = require(PurchasePrompt.Actions.BalanceInfoRecieved)

return (Rodux.createReducer({}, {
	[AccountInfoReceived.name] = function(p1, p2) -- line: 11
		local accountInfo = p2.accountInfo

		return {
			balance = p1.balance,
			membershipType = not accountInfo.isPremium and 0 or 4
		}
	end,
	[BalanceInfoRecieved.name] = function(p3, p4) -- line: 23
		local balanceInfo = p4.balanceInfo

		return {
			balance = balanceInfo.robux,
			hasFailed = balanceInfo.hasFailed,
			membershipType = p3.membershipType
		}
	end
}))
