local parent = script.Parent.Parent
local RequestAvatarCreationFeePurchase = require(parent.Actions.RequestAvatarCreationFeePurchase)
local Promise = require(parent.Promise)
local Thunk = require(parent.Thunk)
local Network = require(parent.Services.Network)
local ExternalSettings = require(parent.Services.ExternalSettings)
local getBalanceInfo = require(parent.Network.getBalanceInfo)
local getAccountInfo = require(parent.Network.getAccountInfo)
local ErrorOccurred = require(parent.Actions.ErrorOccurred)
local getUnifiedPurchaseFlowEligibility = require(parent.Network.getUnifiedPurchaseFlowEligibility)
local resolvePromptState = require(script.Parent.resolvePromptState)

local v = { Network, ExternalSettings }

local function initiateAvatarCreationFeePurchase(p, p2, p3, priceInRobux)
	return Thunk.new(script.Name, v, function(object, p4)
		local v2 = p4[Network]
		local v3 = p4[ExternalSettings]

		object:dispatch(RequestAvatarCreationFeePurchase(p3, p2))

		return Promise.all({
			accountInfo = getAccountInfo(v2, v3),
			balanceInfo = getBalanceInfo(v2, v3, true),
			isUserEligibleForUnifiedPurchaseFlow = getUnifiedPurchaseFlowEligibility(v2)
		}):andThen(function(data)
			object:dispatch(resolvePromptState(
				{ PriceInRobux = priceInRobux, Name = p.name, Description = p.description },
				data.accountInfo,
				data.balanceInfo,
				false,
				true,
				priceInRobux,
				data.isUserEligibleForUnifiedPurchaseFlow
			))
		end):catch(function(p5)
			object:dispatch(ErrorOccurred(p5))
		end)
	end)
end

return initiateAvatarCreationFeePurchase
