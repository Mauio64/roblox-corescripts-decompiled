local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Roact = require(PurchasePromptParent.PurchasePromptDeps).Roact
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local completePurchase = require(PurchasePrompt.Thunks.completePurchase)
local initiatePurchase = require(PurchasePrompt.Thunks.initiatePurchase)
local initiateBundlePurchase = require(PurchasePrompt.Thunks.initiateBundlePurchase)
local initiatePremiumPurchase = require(PurchasePrompt.Thunks.initiatePremiumPurchase)
local initiateSubscriptionPurchase = require(PurchasePrompt.Thunks.initiateSubscriptionPurchase)
local connectToStore = require(PurchasePrompt.connectToStore)
local ExternalEventConnection = require(script.Parent.ExternalEventConnection)
local GetFFlagEnablePromptPurchaseRequestedV2 = require(PurchasePrompt.Flags.GetFFlagEnablePromptPurchaseRequestedV2)
local GetFFlagEnablePromptPurchaseRequestedV2Take2 = require(PurchasePrompt.Flags.GetFFlagEnablePromptPurchaseRequestedV2Take2)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = require(PurchasePromptParent.SharedFlags).FFlagEnableUnifiedPurchaseFlowForDevSubs
local ProductTypeEnum = require(PurchasePrompt.types).ProductTypeEnum
local FFlagEnablePromptRobloxSubscriptionPurchaseBinding = require(PurchasePrompt.Flags.FFlagEnablePromptRobloxSubscriptionPurchaseBinding)
local v20 = game:DefineFastFlag("RoutePremiumToBlackbirdUpsell", false)
local RobloxSubscriptionPurchaseApp = require(PurchasePromptParent.RobloxSubscriptionPurchaseApp)
local SurfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext
local SurfaceName = RobloxSubscriptionPurchaseApp.SurfaceName

local function MarketplaceServiceEventConnector(p1) -- line: 37
	-- upvalues: MarketplaceService (copy), GetFFlagEnablePromptPurchaseRequestedV2 (copy), GetFFlagEnablePromptPurchaseRequestedV2Take2 (copy), Roact (copy), ExternalEventConnection (copy), FFlagEnablePromptRobloxSubscriptionPurchaseBinding (copy)
	local onPurchaseRequest = p1.onPurchaseRequest
	local onPurchaseRequestV2 = p1.onPurchaseRequestV2
	local onProductPurchaseRequest = p1.onProductPurchaseRequest
	local onPurchaseGamePassRequest = p1.onPurchaseGamePassRequest
	local onServerPurchaseVerification = p1.onServerPurchaseVerification
	local onBundlePurchaseRequest = p1.onBundlePurchaseRequest
	local onPremiumPurchaseRequest = p1.onPremiumPurchaseRequest
	local onRobloxPurchaseRequest = p1.onRobloxPurchaseRequest
	local onPromptCollectiblesPurchaseRequest = p1.onPromptCollectiblesPurchaseRequest
	local onSubscriptionPurchaseRequest = p1.onSubscriptionPurchaseRequest
	local onCollectibleBundlePurchaseRequest = p1.onCollectibleBundlePurchaseRequest
	local onRobloxSubscriptionPurchaseRequest = p1.onRobloxSubscriptionPurchaseRequest

	local function checkNewEventExists() -- line: 51
		-- upvalues: MarketplaceService (copy)
		return MarketplaceService.PromptPurchaseRequestedV2
	end

	local v39 = if not GetFFlagEnablePromptPurchaseRequestedV2() and (not GetFFlagEnablePromptPurchaseRequestedV2Take2() or not pcall(checkNewEventExists)) then Roact.createElement(ExternalEventConnection, {
		event = MarketplaceService.PromptPurchaseRequested,
		callback = onPurchaseRequest
	}) else Roact.createElement(ExternalEventConnection, {
		event = MarketplaceService.PromptPurchaseRequestedV2,
		callback = onPurchaseRequestV2
	})

	local function checkPromptCollectiblesPurchaseRequestedEventExists() -- line: 71
		-- upvalues: MarketplaceService (copy)
		return MarketplaceService.PromptCollectiblesPurchaseRequested
	end

	local v41 = nil

	if pcall(checkPromptCollectiblesPurchaseRequestedEventExists) then
		v41 = Roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.PromptCollectiblesPurchaseRequested,
			callback = onPromptCollectiblesPurchaseRequest
		})
	end

	local function checkCollectibleBundlePurchaseEventExists() -- line: 82
		-- upvalues: MarketplaceService (copy)
		return MarketplaceService.PromptCollectibleBundlePurchaseRequested
	end

	local v43 = nil

	if pcall(checkCollectibleBundlePurchaseEventExists) then
		v43 = Roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.PromptCollectibleBundlePurchaseRequested,
			callback = onCollectibleBundlePurchaseRequest
		})
	end

	return Roact.createFragment({
		v39,
		v41,
		v43,
		RobloxPurchase = Roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.PromptRobloxPurchaseRequested,
			callback = onRobloxPurchaseRequest
		}),
		Roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.PromptProductPurchaseRequested,
			callback = onProductPurchaseRequest
		}),
		Roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.PromptGamePassPurchaseRequested,
			callback = onPurchaseGamePassRequest
		}),
		Roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.ServerPurchaseVerification,
			callback = onServerPurchaseVerification
		}),
		Roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.PromptBundlePurchaseRequested,
			callback = onBundlePurchaseRequest
		}),
		Roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.PromptPremiumPurchaseRequested,
			callback = onPremiumPurchaseRequest
		}),
		Roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.PromptSubscriptionPurchaseRequested,
			callback = onSubscriptionPurchaseRequest
		}),
		if not FFlagEnablePromptRobloxSubscriptionPurchaseBinding then nil else Roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.PromptRobloxSubscriptionPurchaseRequested,
			callback = onRobloxSubscriptionPurchaseRequest
		})
	})
end

return (connectToStore(nil, function(p2) -- line: 135
	-- upvalues: Players (copy), initiatePurchase (copy), ErrorOccurred (copy), PurchaseError (copy), completePurchase (copy), initiateBundlePurchase (copy), v20 (copy), RobloxSubscriptionPurchaseApp (copy), SurfaceName (copy), SurfaceContext (copy), initiatePremiumPurchase (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), ProductTypeEnum (copy), initiateSubscriptionPurchase (copy), FFlagEnablePromptRobloxSubscriptionPurchaseBinding (copy)
	return {
		onPurchaseRequest = function(p3, p4, p5, _) -- line: 136
			-- upvalues: Players (copy), p2 (copy), initiatePurchase (copy)
			if p3 == Players.LocalPlayer then
				p2(initiatePurchase(p4, Enum.InfoType.Asset, p5, false, "", ""))
			end
		end,
		onPurchaseRequestV2 = function(p7, p8, p9, _, p11, p12) -- line: 142
			-- upvalues: Players (copy), p2 (copy), initiatePurchase (copy)
			if p7 == Players.LocalPlayer then
				p2(initiatePurchase(p8, Enum.InfoType.Asset, p9, false, p11, p12))
			end
		end,
		onRobloxPurchaseRequest = function(p13, p14) -- line: 164
			-- upvalues: p2 (copy), initiatePurchase (copy)
			p2(initiatePurchase(p13, Enum.InfoType.Asset, p14, true))
		end,
		onProductPurchaseRequest = function(p15, p16, p17, _) -- line: 168
			-- upvalues: Players (copy), p2 (copy), initiatePurchase (copy)
			if p15 == Players.LocalPlayer then
				p2(initiatePurchase(p16, Enum.InfoType.Product, p17))
			end
		end,
		onPurchaseGamePassRequest = function(p19, p20) -- line: 174
			-- upvalues: Players (copy), p2 (copy), initiatePurchase (copy)
			if p19 == Players.LocalPlayer then
				p2(initiatePurchase(p20, Enum.InfoType.GamePass, false))
			end
		end,
		onServerPurchaseVerification = function(p21) -- line: 209
			-- upvalues: p2 (copy), ErrorOccurred (copy), PurchaseError (copy), Players (copy), completePurchase (copy)
			if not p21 then
				p2(ErrorOccurred(PurchaseError.UnknownFailure))

				return
			end

			local playerId = p21.playerId

			if playerId ~= nil then
				playerId = tonumber(p21.playerId)
			end

			if playerId == Players.LocalPlayer.UserId then
				p2(completePurchase())
			end
		end,
		onBundlePurchaseRequest = function(p22, p23) -- line: 223
			-- upvalues: Players (copy), p2 (copy), initiateBundlePurchase (copy)
			if p22 == Players.LocalPlayer then
				p2(initiateBundlePurchase(p23))
			end
		end,
		onPremiumPurchaseRequest = function(p24) -- line: 254
			-- upvalues: Players (copy), v20 (copy), RobloxSubscriptionPurchaseApp (copy), SurfaceName (copy), SurfaceContext (copy), p2 (copy), initiatePremiumPurchase (copy)
			if p24 == Players.LocalPlayer then
				if v20 then
					RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase({}, nil, nil, SurfaceName.PromptSubscriptionPurchase, SurfaceContext.InGame, {
						skipWaitingForPurchaseResult = true
					})

					return
				end

				p2(initiatePremiumPurchase())
			end
		end,
		onPromptCollectiblesPurchaseRequest = function(p25, p26, p27, p28, p29, p30, p31, p32) -- line: 180
			-- upvalues: Players (copy), p2 (copy), initiatePurchase (copy)
			if p25 == Players.LocalPlayer then
				p2(initiatePurchase(p26, Enum.InfoType.Asset, false, true, p31, p32, p27, p28, p29, p30))
			end
		end,
		onSubscriptionPurchaseRequest = function(p33) -- line: 274
			-- upvalues: FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), p2 (copy), initiatePurchase (copy), ProductTypeEnum (copy), initiateSubscriptionPurchase (copy)
			if FFlagEnableUnifiedPurchaseFlowForDevSubs then
				p2(initiatePurchase(p33, ProductTypeEnum.DeveloperSubscription))

				return
			end

			p2(initiateSubscriptionPurchase(p33))
		end,
		onCollectibleBundlePurchaseRequest = function(p34, p35, p36, p37, p38, p39, p40, p41) -- line: 229
			-- upvalues: Players (copy), p2 (copy), initiateBundlePurchase (copy)
			if p34 == Players.LocalPlayer then
				p2(initiateBundlePurchase(p35, p40, p41, p36, p37, p38, p39))
			end
		end,
		onRobloxSubscriptionPurchaseRequest = function() -- line: 282
			-- upvalues: FFlagEnablePromptRobloxSubscriptionPurchaseBinding (copy), RobloxSubscriptionPurchaseApp (copy), SurfaceName (copy), SurfaceContext (copy)
			if FFlagEnablePromptRobloxSubscriptionPurchaseBinding then
				RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase({}, nil, nil, SurfaceName.PromptSubscriptionPurchase, SurfaceContext.InGame, {
					skipWaitingForPurchaseResult = true
				})
			end
		end
	}
end)(MarketplaceServiceEventConnector))
