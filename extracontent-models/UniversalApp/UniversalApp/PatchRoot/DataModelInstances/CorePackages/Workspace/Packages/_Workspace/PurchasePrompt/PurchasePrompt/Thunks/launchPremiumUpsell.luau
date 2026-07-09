local ParentParent = script.Parent.Parent
local Players = game:GetService("Players")
local ErrorOccurred = require(ParentParent.Actions.ErrorOccurred)
local PurchaseCompleteRecieved = require(ParentParent.Actions.PurchaseCompleteRecieved)
local SetPromptState = require(ParentParent.Actions.SetPromptState)
local SetWindowState = require(ParentParent.Actions.SetWindowState)
local UpsellFlow = require(ParentParent.Enums.UpsellFlow)
local PromptState = require(ParentParent.Enums.PromptState)
local PurchaseError = require(ParentParent.Enums.PurchaseError)
local WindowState = require(ParentParent.Enums.WindowState)
local getUpsellFlow = require(ParentParent.NativeUpsell.getUpsellFlow)
local Analytics = require(ParentParent.Services.Analytics)
local PlatformInterface = require(ParentParent.Services.PlatformInterface)
local ExternalSettings = require(ParentParent.Services.ExternalSettings)
local hideWindow = require(ParentParent.Thunks.hideWindow)
local Thunk = require(ParentParent.Thunk)
local t1 = {
	Analytics,
	PlatformInterface,
	ExternalSettings
}

local function launchPremiumUpsell() -- line: 25
	-- upvalues: Thunk (copy), t1 (copy), PlatformInterface (copy), ExternalSettings (copy), Analytics (copy), PurchaseCompleteRecieved (copy), SetWindowState (copy), WindowState (copy), getUpsellFlow (copy), UpsellFlow (copy), SetPromptState (copy), PromptState (copy), hideWindow (copy), Players (copy), ErrorOccurred (copy), PurchaseError (copy)
	return Thunk.new(script.Name, t1, function(p1, p2) -- line: 26
		-- upvalues: PlatformInterface (copy), ExternalSettings (copy), Analytics (copy), PurchaseCompleteRecieved (copy), SetWindowState (copy), WindowState (copy), getUpsellFlow (copy), UpsellFlow (copy), SetPromptState (copy), PromptState (copy), hideWindow (copy), Players (copy), ErrorOccurred (copy), PurchaseError (copy)
		local v21 = p2[PlatformInterface]
		local v22 = p2[ExternalSettings]
		local v23 = p2[Analytics]
		local premiumProductInfo = p1:getState().premiumProductInfo

		if v22.isStudio() then
			v21.signalMockPurchasePremium()
			p1:dispatch(PurchaseCompleteRecieved())

			return p1:dispatch(SetWindowState(WindowState.Hidden))
		end

		local v25 = getUpsellFlow(v22.getPlatform())

		v23.signalPremiumUpsellConfirmed()

		if v25 == UpsellFlow.Web then
			local productId = premiumProductInfo.productId

			v21.startPremiumUpsell(productId)
			p1:dispatch(SetPromptState(PromptState.UpsellInProgress))
			p1:dispatch(hideWindow())

			return
		end

		if v25 == UpsellFlow.Mobile then
			local mobileProductId = premiumProductInfo.mobileProductId
			local LocalPlayer = Players.LocalPlayer

			if game:GetEngineFeature("NativePurchaseWithLocalPlayer") then
				v21.promptNativePurchaseWithLocalPlayer(mobileProductId)
			else
				v21.promptNativePurchase(LocalPlayer, mobileProductId)
			end

			p1:dispatch(SetPromptState(PromptState.UpsellInProgress))
			p1:dispatch(hideWindow())

			return
		end

		p1:dispatch(ErrorOccurred(PurchaseError.PremiumUnavailablePlatform))
	end)
end

return launchPremiumUpsell
