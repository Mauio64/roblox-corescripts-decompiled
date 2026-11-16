local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Roact = PurchasePromptDeps.Roact

local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local completePurchase = require(PurchasePrompt.Thunks.completePurchase)
local initiatePurchase = require(PurchasePrompt.Thunks.initiatePurchase)
local initiateBundlePurchase = require(PurchasePrompt.Thunks.initiateBundlePurchase)
local initiateSubscriptionPurchase = require(PurchasePrompt.Thunks.initiateSubscriptionPurchase)
local connectToStore = require(PurchasePrompt.connectToStore)

local ExternalEventConnection = require(script.Parent.ExternalEventConnection)

local GetFFlagEnablePromptPurchaseRequestedV2 = require(PurchasePrompt.Flags.GetFFlagEnablePromptPurchaseRequestedV2)
local GetFFlagEnablePromptPurchaseRequestedV2Take2 = require(PurchasePrompt.Flags.GetFFlagEnablePromptPurchaseRequestedV2Take2)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = SharedFlags.FFlagEnableUnifiedPurchaseFlowForDevSubs
local types = require(PurchasePrompt.types)
local productTypeEnum = types.ProductTypeEnum

local FFlagEnablePromptRobloxSubscriptionPurchaseBinding = require(PurchasePrompt.Flags.FFlagEnablePromptRobloxSubscriptionPurchaseBinding)

local SharedFlags2 = require(PurchasePrompt.Parent.SharedFlags)
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags2.FFlagLuaAppsEnablePromptVIPServerPurchase

local RobloxSubscriptionPurchaseApp = require(parent.RobloxSubscriptionPurchaseApp)
local SurfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext
local SurfaceName = RobloxSubscriptionPurchaseApp.SurfaceName

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

	local v

	if
		GetFFlagEnablePromptPurchaseRequestedV2()
		or GetFFlagEnablePromptPurchaseRequestedV2Take2() and pcall(checkNewEventExists)
	then
		v = Roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.PromptPurchaseRequestedV2,
			callback = onPurchaseRequestV2
		})
	else
		v = Roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.PromptPurchaseRequested,
			callback = onPurchaseRequest
		})
	end

	local function checkPromptCollectiblesPurchaseRequestedEventExists()
		return MarketplaceService.PromptCollectiblesPurchaseRequested
	end

	local v2

	if pcall(checkPromptCollectiblesPurchaseRequestedEventExists) then
		v2 = Roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.PromptCollectiblesPurchaseRequested,
			callback = onPromptCollectiblesPurchaseRequest
		})
	end

	local function checkCollectibleBundlePurchaseEventExists()
		return MarketplaceService.PromptCollectibleBundlePurchaseRequested
	end

	local v3

	if pcall(checkCollectibleBundlePurchaseEventExists) then
		v3 = Roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.PromptCollectibleBundlePurchaseRequested,
			callback = onCollectibleBundlePurchaseRequest
		})
	end

	local v4

	if FFlagLuaAppsEnablePromptVIPServerPurchase then
		v4 = Roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.PromptVIPServerPurchaseRequested,
			callback = onVIPServerPurchaseRequest
		})
	end

	local createFragment = Roact.createFragment
	local v5 = {
		v,
		v2,
		v3,
		v4,
		RobloxPurchase = Roact.createElement(ExternalEventConnection, {
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

	local element = Roact.createElement(ExternalEventConnection, {
		event = MarketplaceService.PromptProductPurchaseRequested,
		callback = onProductPurchaseRequest
	})

	local element2 = Roact.createElement(ExternalEventConnection, {
		event = MarketplaceService.PromptGamePassPurchaseRequested,
		callback = onPurchaseGamePassRequest
	})

	local element3 = Roact.createElement(ExternalEventConnection, {
		event = MarketplaceService.ServerPurchaseVerification,
		callback = onServerPurchaseVerification
	})

	local element4 = Roact.createElement(ExternalEventConnection, {
		event = MarketplaceService.PromptBundlePurchaseRequested,
		callback = onBundlePurchaseRequest
	})

	local element5 = Roact.createElement(ExternalEventConnection, {
		event = MarketplaceService.PromptPremiumPurchaseRequested,
		callback = onPremiumPurchaseRequest
	})

	local element6 = Roact.createElement(ExternalEventConnection, {
		event = MarketplaceService.PromptSubscriptionPurchaseRequested,
		callback = onSubscriptionPurchaseRequest
	})
	local v6

	if FFlagEnablePromptRobloxSubscriptionPurchaseBinding then
		v6 = Roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.PromptRobloxSubscriptionPurchaseRequested,
			callback = onRobloxSubscriptionPurchaseRequest
		})
	end

	v5[5], v5[6], v5[7], v5[8], v5[9], v5[10], v5[11] = element, element2, element3, element4, element5, element6, v6
	return createFragment(v5)
end

return (connectToStore(nil, function(callback)
	return {
		onPurchaseRequest = function(p, p2, p3, _)
			if p == Players.LocalPlayer then
				callback(initiatePurchase(p2, Enum.InfoType.Asset, p3, false, "", ""))
			end
		end,
		onPurchaseRequestV2 = function(p, p2, p3, _, p4, p5)
			if p == Players.LocalPlayer then
				callback(initiatePurchase(p2, Enum.InfoType.Asset, p3, false, p4, p5))
			end
		end,
		onRobloxPurchaseRequest = function(p, p2)
			callback(initiatePurchase(p, Enum.InfoType.Asset, p2, true))
		end,
		onProductPurchaseRequest = function(p, p2, p3, _)
			if p == Players.LocalPlayer then
				callback(initiatePurchase(p2, Enum.InfoType.Product, p3))
			end
		end,
		onPurchaseGamePassRequest = function(p, p2)
			if p == Players.LocalPlayer then
				callback(initiatePurchase(p2, Enum.InfoType.GamePass, false))
			end
		end,
		onServerPurchaseVerification = function(p)
			if not p then
				callback(ErrorOccurred(PurchaseError.UnknownFailure))
				return
			end

			local playerId = p.playerId

			if playerId ~= nil then
				playerId = tonumber(p.playerId)
			end

			if playerId == Players.LocalPlayer.UserId then
				callback(completePurchase())
			end
		end,
		onBundlePurchaseRequest = function(p, p2)
			if p == Players.LocalPlayer then
				callback(initiateBundlePurchase(p2))
			end
		end,
		onPremiumPurchaseRequest = function(p)
			if p == Players.LocalPlayer then
				RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase(
					{},
					nil,
					nil,
					SurfaceName.PromptSubscriptionPurchase,
					SurfaceContext.InGame,
					{ skipWaitingForPurchaseResult = true }
				)
			end
		end,
		onPromptCollectiblesPurchaseRequest = function(p, p2, p3, p4, p5, p6, p7, p8)
			if p == Players.LocalPlayer then
				callback(initiatePurchase(p2, Enum.InfoType.Asset, false, true, p7, p8, p3, p4, p5, p6))
			end
		end,
		onSubscriptionPurchaseRequest = function(p)
			if FFlagEnableUnifiedPurchaseFlowForDevSubs then
				callback(initiatePurchase(p, productTypeEnum.DeveloperSubscription))
			else
				callback(initiateSubscriptionPurchase(p))
			end
		end,
		onCollectibleBundlePurchaseRequest = function(p, p2, p3, p4, p5, p6, p7, p8)
			if p == Players.LocalPlayer then
				callback(initiateBundlePurchase(p2, p7, p8, p3, p4, p5, p6))
			end
		end,
		onRobloxSubscriptionPurchaseRequest = function()
			if FFlagEnablePromptRobloxSubscriptionPurchaseBinding then
				RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase(
					{},
					nil,
					nil,
					SurfaceName.PromptSubscriptionPurchase,
					SurfaceContext.InGame,
					{ skipWaitingForPurchaseResult = true }
				)
			end
		end,
		onVIPServerPurchaseRequest = function(_)
			callback(initiatePurchase(game.GameId, productTypeEnum.VIPServer))
		end
	}
end)(MarketplaceServiceEventConnector))
