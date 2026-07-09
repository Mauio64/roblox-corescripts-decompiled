local ParentParent = script.Parent.Parent
local RequestAvatarCreationFeePurchase = require(ParentParent.Actions.RequestAvatarCreationFeePurchase)
local Promise = require(ParentParent.Promise)
local Thunk = require(ParentParent.Thunk)
local Network = require(ParentParent.Services.Network)
local ExternalSettings = require(ParentParent.Services.ExternalSettings)
local getBalanceInfo = require(ParentParent.Network.getBalanceInfo)
local getAccountInfo = require(ParentParent.Network.getAccountInfo)
local ErrorOccurred = require(ParentParent.Actions.ErrorOccurred)
local FFlagEnableUnifiedProductPurchaseFlow = require(ParentParent.Parent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local getUnifiedPurchaseFlowEligibility = require(ParentParent.Network.getUnifiedPurchaseFlowEligibility)
local resolvePromptState = require(script.Parent.resolvePromptState)
local t1 = {
	Network,
	ExternalSettings
}

local function initiateAvatarCreationFeePurchase(p1, p2, p3, p4) -- line: 25
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), ExternalSettings (copy), RequestAvatarCreationFeePurchase (copy), Promise (copy), getAccountInfo (copy), getBalanceInfo (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), getUnifiedPurchaseFlowEligibility (copy), resolvePromptState (copy), ErrorOccurred (copy)
	return Thunk.new(script.Name, t1, function(p5, p6) -- line: 26
		-- upvalues: Network (copy), ExternalSettings (copy), RequestAvatarCreationFeePurchase (copy), p3 (copy), p2 (copy), Promise (copy), getAccountInfo (copy), getBalanceInfo (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), getUnifiedPurchaseFlowEligibility (copy), p4 (copy), p1 (copy), resolvePromptState (copy), ErrorOccurred (copy)
		local v21 = p6[Network]
		local v22 = p6[ExternalSettings]

		p5:dispatch(RequestAvatarCreationFeePurchase(p3, p2))

		return Promise.all({
			accountInfo = getAccountInfo(v21, v22),
			balanceInfo = getBalanceInfo(v21, v22, true),
			isUserEligibleForUnifiedPurchaseFlow = if not FFlagEnableUnifiedProductPurchaseFlow then nil else getUnifiedPurchaseFlowEligibility(v21)
		}):andThen(function(p7) -- line: 39
			-- upvalues: p4 (copy), p1 (copy), p5 (copy), resolvePromptState (copy)
			local t2 = {
				PriceInRobux = p4,
				Name = p1.name,
				Description = p1.description
			}

			p5:dispatch(resolvePromptState(t2, p7.accountInfo, p7.balanceInfo, false, true, p4, p7.isUserEligibleForUnifiedPurchaseFlow))
		end):catch(function(p8) -- line: 57
			-- upvalues: p5 (copy), ErrorOccurred (copy)
			p5:dispatch(ErrorOccurred(p8))
		end)
	end)
end

return initiateAvatarCreationFeePurchase
