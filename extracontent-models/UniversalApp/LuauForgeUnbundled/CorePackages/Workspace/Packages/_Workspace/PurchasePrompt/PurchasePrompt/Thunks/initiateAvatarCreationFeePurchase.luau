local RequestAvatarCreationFeePurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RequestAvatarCreationFeePurchase")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")
local Network = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Network")
local ExternalSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/ExternalSettings")
local getBalanceInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getBalanceInfo")
local getAccountInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getAccountInfo")
local ErrorOccurred = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/ErrorOccurred")
local getUnifiedPurchaseFlowEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getUnifiedPurchaseFlowEligibility")
local resolvePromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/resolvePromptState")

local v5 = { Network, ExternalSettings }

local function initiateAvatarCreationFeePurchase(p2, p3, p4, p5)
	return Thunk.new("initiateAvatarCreationFeePurchase", v5, function(object, p6)
		local v6 = p6[Network]
		local v7 = p6[ExternalSettings]

		object:dispatch(RequestAvatarCreationFeePurchase(p4, p3))

		return Promise.all({
			accountInfo = getAccountInfo(v6, v7),
			balanceInfo = getBalanceInfo(v6, v7, true),
			isUserEligibleForUnifiedPurchaseFlow = getUnifiedPurchaseFlowEligibility(v6)
		}):andThen(function(data)
			object:dispatch(resolvePromptState(
				{ PriceInRobux = p5, Name = p2.name, Description = p2.description },
				data.accountInfo,
				data.balanceInfo,
				false,
				true,
				p5,
				data.isUserEligibleForUnifiedPurchaseFlow
			))
		end):catch(function(p7)
			object:dispatch(ErrorOccurred(p7))
		end)
	end)
end

return initiateAvatarCreationFeePurchase
