local AppContext = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/AppContext")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")
local WindowState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/WindowState")

local RobloxSubscriptionPurchaseApp = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/RobloxSubscriptionPurchaseApp")
local robloxSubscriptionFlowCompleteReason = RobloxSubscriptionPurchaseApp.RobloxSubscriptionFlowCompleteReason
local surfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local surfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext
local purchaseClientSessionIdType = RobloxSubscriptionPurchaseApp.PurchaseClientSessionIdType

local function startRobuxUpsellPlusPurchase(data)
	data.setPromptState(PromptState.BlackbirdUpsellInProgress)
	data.setWindowState(WindowState.Suspended)

	local v5 = type(data.purchaseFlowUUID) == "string"
		and data.purchaseFlowUUID ~= ""
		and {
			clientSessionIdType = purchaseClientSessionIdType.PurchaseFlowUUID,
			clientSessionId = data.purchaseFlowUUID
		}
		or nil

	local initiateRobloxSubscriptionPurchase = RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase

	local inGameRobuxUpsell = surfaceName.InGameRobuxUpsell
	local v9 = if AppContext.get() == AppContext.Enum.IN_APP then surfaceContext.InApp else surfaceContext.InGame
	initiateRobloxSubscriptionPurchase({ showBackButton = true }, {
		onFlowComplete = function(p2)
			if data.onFlowEnded then
				data.onFlowEnded()
			end

			if p2 ~= robloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded then
				data.completeRequest()

				return
			end

			if data.onRobloxSubscriptionUpsellSuccess then
				data.onRobloxSubscriptionUpsellSuccess()
			end

			data.retryPurchaseAfterUpsell()
		end,
		onBackButtonActivated = function()
			if data.onFlowEnded then
				data.onFlowEnded()
			end

			data.setPromptState(PromptState.RobuxUpsell)
			data.setWindowState(WindowState.Shown)
		end
	}, nil, inGameRobuxUpsell, v9, nil, v5 and { clientSessionId = v5 } or nil)
end

return startRobuxUpsellPlusPurchase
