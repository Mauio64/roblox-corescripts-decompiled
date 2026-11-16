local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local AppContext = require(PurchasePrompt.Utils.AppContext)
local PromptState = require(PurchasePrompt.Enums.PromptState)
local WindowState = require(PurchasePrompt.Enums.WindowState)

local RobloxSubscriptionPurchaseApp = require(parent.RobloxSubscriptionPurchaseApp)
local RobloxSubscriptionFlowCompleteReason = RobloxSubscriptionPurchaseApp.RobloxSubscriptionFlowCompleteReason
local SurfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local SurfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext
local PurchaseClientSessionIdType = RobloxSubscriptionPurchaseApp.PurchaseClientSessionIdType

local function startRobuxUpsellPlusPurchase(data)
	data.setPromptState(PromptState.BlackbirdUpsellInProgress)
	data.setWindowState(WindowState.Suspended)

	local clientSessionId = type(data.purchaseFlowUUID) == "string"
		and data.purchaseFlowUUID ~= ""
		and {
			clientSessionIdType = PurchaseClientSessionIdType.PurchaseFlowUUID,
			clientSessionId = data.purchaseFlowUUID
		}
		or nil

	local initiateRobloxSubscriptionPurchase = RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase

	local inGameRobuxUpsell = SurfaceName.InGameRobuxUpsell
	local v

	if AppContext.get() == AppContext.Enum.IN_APP then
		v = SurfaceContext.InApp
	else
		v = SurfaceContext.InGame
	end

	initiateRobloxSubscriptionPurchase({ showBackButton = true }, {
		onFlowComplete = function(p)
			if data.onFlowEnded then
				data.onFlowEnded()
			end

			if p ~= RobloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded then
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
	}, nil, inGameRobuxUpsell, v, nil, clientSessionId and { clientSessionId = clientSessionId } or nil)
end

return startRobuxUpsellPlusPurchase
