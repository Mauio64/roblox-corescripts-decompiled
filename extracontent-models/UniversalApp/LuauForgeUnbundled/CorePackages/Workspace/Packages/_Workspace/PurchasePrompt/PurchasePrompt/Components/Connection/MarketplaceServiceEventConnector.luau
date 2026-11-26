local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local roact = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Roact

local ErrorOccurred = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/ErrorOccurred")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local completePurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/completePurchase")
local initiatePurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/initiatePurchase")
local initiateBundlePurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/initiateBundlePurchase")
local initiateSubscriptionPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/initiateSubscriptionPurchase")
local connectToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/connectToStore")

local ExternalEventConnection = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/Connection/ExternalEventConnection")

local GetFFlagEnablePromptPurchaseRequestedV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnablePromptPurchaseRequestedV2")
local GetFFlagEnablePromptPurchaseRequestedV2Take2 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnablePromptPurchaseRequestedV2Take2")
local fFlagEnableUnifiedPurchaseFlowForDevSubs = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableUnifiedPurchaseFlowForDevSubs
local productTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types").ProductTypeEnum

local FFlagEnablePromptRobloxSubscriptionPurchaseBinding = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagEnablePromptRobloxSubscriptionPurchaseBinding")

local fFlagLuaAppsEnablePromptVIPServerPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagLuaAppsEnablePromptVIPServerPurchase

local RobloxSubscriptionPurchaseApp = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/RobloxSubscriptionPurchaseApp")
local surfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext
local surfaceName = RobloxSubscriptionPurchaseApp.SurfaceName

local function MarketplaceServiceEventConnector(props)
	local onPurchaseRequest = props.onPurchaseRequest
	local onPurchaseRequestV2 = props.onPurchaseRequestV2
	local onProductPurchaseRequest = props.onProductPurchaseRequest
	local onPurchaseGamePassRequest = props.onPurchaseGamePassRequest
	local onServerPurchaseVerification = props.onServerPurchaseVerification
	local onBundlePurchaseRequest = props.onBundlePurchaseRequest
	local onPremiumPurchaseRequest = props.onPremiumPurchaseRequest
	local onRobloxPurchaseRequest = props.onRobloxPurchaseRequest
	local onPromptCollectiblesPurchaseRequest = props.onPromptCollectiblesPurchaseRequest
	local onSubscriptionPurchaseRequest = props.onSubscriptionPurchaseRequest
	local onCollectibleBundlePurchaseRequest = props.onCollectibleBundlePurchaseRequest
	local onRobloxSubscriptionPurchaseRequest = props.onRobloxSubscriptionPurchaseRequest
	local onVIPServerPurchaseRequest = props.onVIPServerPurchaseRequest

	local function checkNewEventExists()
		return MarketplaceService.PromptPurchaseRequestedV2
	end

	local v5

	if GetFFlagEnablePromptPurchaseRequestedV2() or GetFFlagEnablePromptPurchaseRequestedV2Take2() and pcall(checkNewEventExists) then
		v5 = roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.PromptPurchaseRequestedV2,
			callback = onPurchaseRequestV2
		})
	else
		v5 = roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.PromptPurchaseRequested,
			callback = onPurchaseRequest
		})
	end

	local function checkPromptCollectiblesPurchaseRequestedEventExists()
		return MarketplaceService.PromptCollectiblesPurchaseRequested
	end

	local v6

	if pcall(checkPromptCollectiblesPurchaseRequestedEventExists) then
		v6 = roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.PromptCollectiblesPurchaseRequested,
			callback = onPromptCollectiblesPurchaseRequest
		})
	end

	local function checkCollectibleBundlePurchaseEventExists()
		return MarketplaceService.PromptCollectibleBundlePurchaseRequested
	end

	local v7

	if pcall(checkCollectibleBundlePurchaseEventExists) then
		v7 = roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.PromptCollectibleBundlePurchaseRequested,
			callback = onCollectibleBundlePurchaseRequest
		})
	end

	local v8

	if fFlagLuaAppsEnablePromptVIPServerPurchase then
		v8 = roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.PromptVIPServerPurchaseRequested,
			callback = onVIPServerPurchaseRequest
		})
	end

	local createFragment = roact.createFragment
	local v9 = {
		v5,
		v6,
		v7,
		v8,
		RobloxPurchase = roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.PromptRobloxPurchaseRequested,
			callback = onRobloxPurchaseRequest
		}),
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil
	}

	local element = roact.createElement(ExternalEventConnection, {
		event = MarketplaceService.PromptProductPurchaseRequested,
		callback = onProductPurchaseRequest
	})

	local element2 = roact.createElement(ExternalEventConnection, {
		event = MarketplaceService.PromptGamePassPurchaseRequested,
		callback = onPurchaseGamePassRequest
	})

	local element3 = roact.createElement(ExternalEventConnection, {
		event = MarketplaceService.ServerPurchaseVerification,
		callback = onServerPurchaseVerification
	})

	local element4 = roact.createElement(ExternalEventConnection, {
		event = MarketplaceService.PromptBundlePurchaseRequested,
		callback = onBundlePurchaseRequest
	})

	local element5 = roact.createElement(ExternalEventConnection, {
		event = MarketplaceService.PromptPremiumPurchaseRequested,
		callback = onPremiumPurchaseRequest
	})

	local element6 = roact.createElement(ExternalEventConnection, {
		event = MarketplaceService.PromptSubscriptionPurchaseRequested,
		callback = onSubscriptionPurchaseRequest
	})

	local v10 = if FFlagEnablePromptRobloxSubscriptionPurchaseBinding then roact.createElement(ExternalEventConnection, {
		event = MarketplaceService.PromptRobloxSubscriptionPurchaseRequested,
		callback = onRobloxSubscriptionPurchaseRequest
	}) else nil

	v9[5], v9[6], v9[7], v9[8], v9[9], v9[10], v9[11] = element, element2, element3, element4, element5, element6, v10
	return createFragment(v9)
end

return (connectToStore(nil, function(callback)
	return {
		onPurchaseRequest = function(p2, p3, p4, p5)
			if p2 == Players.LocalPlayer then
				callback(initiatePurchase(p3, Enum.InfoType.Asset, p4, false, "", ""))
			end
		end,
		onPurchaseRequestV2 = function(p2, p3, p4, p5, p6, p7)
			if p2 == Players.LocalPlayer then
				callback(initiatePurchase(p3, Enum.InfoType.Asset, p4, false, p6, p7))
			end
		end,
		onRobloxPurchaseRequest = function(p2, p3)
			callback(initiatePurchase(p2, Enum.InfoType.Asset, p3, true))
		end,
		onProductPurchaseRequest = function(p2, p3, p4, p5)
			if p2 == Players.LocalPlayer then
				callback(initiatePurchase(p3, Enum.InfoType.Product, p4))
			end
		end,
		onPurchaseGamePassRequest = function(p2, p3)
			if p2 == Players.LocalPlayer then
				callback(initiatePurchase(p3, Enum.InfoType.GamePass, false))
			end
		end,
		onServerPurchaseVerification = function(p2)
			if not p2 then
				callback(ErrorOccurred(PurchaseError.UnknownFailure))
				return
			end

			local playerId = p2.playerId

			if playerId ~= nil then
				playerId = tonumber(p2.playerId)
			end

			if playerId == Players.LocalPlayer.UserId then
				callback(completePurchase())
			end
		end,
		onBundlePurchaseRequest = function(p2, p3)
			if p2 == Players.LocalPlayer then
				callback(initiateBundlePurchase(p3))
			end
		end,
		onPremiumPurchaseRequest = function(p2)
			if p2 == Players.LocalPlayer then
				RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase(
					{},
					nil,
					nil,
					surfaceName.PromptSubscriptionPurchase,
					surfaceContext.InGame,
					{ skipWaitingForPurchaseResult = true }
				)
			end
		end,
		onPromptCollectiblesPurchaseRequest = function(p2, p3, p4, p5, p6, p7, p8, p9)
			if p2 == Players.LocalPlayer then
				callback(initiatePurchase(p3, Enum.InfoType.Asset, false, true, p8, p9, p4, p5, p6, p7))
			end
		end,
		onSubscriptionPurchaseRequest = function(p2)
			if fFlagEnableUnifiedPurchaseFlowForDevSubs then
				callback(initiatePurchase(p2, productTypeEnum.DeveloperSubscription))
			else
				callback(initiateSubscriptionPurchase(p2))
			end
		end,
		onCollectibleBundlePurchaseRequest = function(p2, p3, p4, p5, p6, p7, p8, p9)
			if p2 == Players.LocalPlayer then
				callback(initiateBundlePurchase(p3, p8, p9, p4, p5, p6, p7))
			end
		end,
		onRobloxSubscriptionPurchaseRequest = function()
			if FFlagEnablePromptRobloxSubscriptionPurchaseBinding then
				RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase(
					{},
					nil,
					nil,
					surfaceName.PromptSubscriptionPurchase,
					surfaceContext.InGame,
					{ skipWaitingForPurchaseResult = true }
				)
			end
		end,
		onVIPServerPurchaseRequest = function(p2)
			callback(initiatePurchase(game.GameId, productTypeEnum.VIPServer))
		end
	}
end)(MarketplaceServiceEventConnector))
