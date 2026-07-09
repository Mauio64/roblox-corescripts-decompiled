local ParentParent = script.Parent.Parent
local Players = game:GetService("Players")
local SetPromptState = require(ParentParent.Actions.SetPromptState)
local ErrorOccurred = require(ParentParent.Actions.ErrorOccurred)
local PremiumInfoRecieved = require(ParentParent.Actions.PremiumInfoRecieved)
local AccountInfoReceived = require(ParentParent.Actions.AccountInfoReceived)
local BalanceInfoRecieved = require(ParentParent.Actions.BalanceInfoRecieved)
local PromptState = require(ParentParent.Enums.PromptState)
local PurchaseError = require(ParentParent.Enums.PurchaseError)
local Analytics = require(ParentParent.Services.Analytics)
local ExternalSettings = require(ParentParent.Services.ExternalSettings)
local Network = require(ParentParent.Services.Network)
local postPremiumImpression = require(ParentParent.Network.postPremiumImpression)
local completeRequest = require(ParentParent.Thunks.completeRequest)
local Thunk = require(ParentParent.Thunk)
local t1 = {
	Network,
	ExternalSettings,
	Analytics
}

local function resolvePremiumPromptState(p1, p2, p3, p4) -- line: 28
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), ExternalSettings (copy), Analytics (copy), PremiumInfoRecieved (copy), AccountInfoReceived (copy), BalanceInfoRecieved (copy), completeRequest (copy), Players (copy), ErrorOccurred (copy), PurchaseError (copy), postPremiumImpression (copy), SetPromptState (copy), PromptState (copy)
	return Thunk.new(script.Name, t1, function(p5, p6) -- line: 29
		-- upvalues: Network (copy), ExternalSettings (copy), Analytics (copy), PremiumInfoRecieved (copy), p3 (copy), AccountInfoReceived (copy), p1 (copy), BalanceInfoRecieved (copy), p2 (copy), p4 (copy), completeRequest (copy), Players (copy), ErrorOccurred (copy), PurchaseError (copy), postPremiumImpression (copy), SetPromptState (copy), PromptState (copy)
		local v24 = p6[Network]
		local v25 = p6[ExternalSettings]
		local v26 = p6[Analytics]
		local v27 = v25.getPlatform()

		p5:dispatch(PremiumInfoRecieved(p3))
		p5:dispatch(AccountInfoReceived(p1))
		p5:dispatch(BalanceInfoRecieved(p2))

		if p4 == false then
			v26.signalPremiumUpsellPrecheckFail()

			return p5:dispatch(completeRequest())
		end

		if v25.isStudio() then
			if Players.LocalPlayer.MembershipType == Enum.MembershipType.Premium then
				return p5:dispatch(ErrorOccurred(PurchaseError.AlreadyPremium))
			end
		elseif p1.isPremium then
			v26.signalPremiumUpsellShownPremium()

			return p5:dispatch(ErrorOccurred(PurchaseError.AlreadyPremium))
		end

		if v27 == Enum.Platform.XBoxOne then
			v26.signalPremiumUpsellInvalidPlatform()

			return p5:dispatch(ErrorOccurred(PurchaseError.PremiumUnavailablePlatform))
		end

		if p3 == nil then
			v26.signalPremiumUpsellInvalidProducts()

			return p5:dispatch(ErrorOccurred(PurchaseError.PremiumUnavailable))
		end

		if not v25.isStudio() then
			v26.signalPremiumUpsellShownNonPremium()
			postPremiumImpression(v24)
		end

		return p5:dispatch(SetPromptState(PromptState.PremiumUpsell))
	end)
end

return resolvePremiumPromptState
