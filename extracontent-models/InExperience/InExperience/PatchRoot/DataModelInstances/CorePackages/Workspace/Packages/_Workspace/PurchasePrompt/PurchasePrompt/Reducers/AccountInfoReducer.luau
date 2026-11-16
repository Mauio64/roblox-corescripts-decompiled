local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

local AccountInfoReceived = require(PurchasePrompt.Actions.AccountInfoReceived)
local BalanceInfoRecieved = require(PurchasePrompt.Actions.BalanceInfoRecieved)

return (Rodux.createReducer({}, {
	[AccountInfoReceived.name] = function(p, p2)
		local accountInfo = p2.accountInfo

		return {
			balance = p.balance,
			membershipType = accountInfo.isPremium and 4 or 0
		}
	end,
	[BalanceInfoRecieved.name] = function(p, p2)
		local balanceInfo = p2.balanceInfo
		return {
			balance = balanceInfo.robux,
			hasFailed = balanceInfo.hasFailed,
			membershipType = p.membershipType
		}
	end
}))
