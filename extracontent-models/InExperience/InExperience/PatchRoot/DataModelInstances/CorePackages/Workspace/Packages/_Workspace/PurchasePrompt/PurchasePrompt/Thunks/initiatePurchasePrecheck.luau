local ParentParent = script.Parent.Parent

game:GetService("UserInputService")

local SetButtonState = require(ParentParent.Actions.SetButtonState)
local PurchaseWarning = require(ParentParent.Enums.PurchaseWarning)
local ButtonState = require(ParentParent.Enums.ButtonState)
local UpsellFlow = require(ParentParent.Enums.UpsellFlow)
local Network = require(ParentParent.Services.Network)
local getPurchaseWarning = require(ParentParent.Network.getPurchaseWarning)
local getUpsellFlow = require(ParentParent.NativeUpsell.getUpsellFlow)
local Analytics = require(ParentParent.Services.Analytics)
local ExternalSettings = require(ParentParent.Services.ExternalSettings)
local Thunk = require(ParentParent.Thunk)
local SelectedRobuxPackage = require(ParentParent.Utils.SelectedRobuxPackage)
local resolvePurchasePrecheck = require(script.Parent.resolvePurchasePrecheck)

require(ParentParent.Actions.SetPromptState)
require(ParentParent.Enums.PromptState)

local t1 = {
	Analytics,
	Network,
	ExternalSettings
}

local function initiatePurchasePrecheck() -- line: 28
	-- upvalues: Thunk (copy), t1 (copy), Analytics (copy), Network (copy), ExternalSettings (copy), resolvePurchasePrecheck (copy), PurchaseWarning (copy), getUpsellFlow (copy), SelectedRobuxPackage (copy), UpsellFlow (copy), SetButtonState (copy), ButtonState (copy), getPurchaseWarning (copy)
	return Thunk.new(script.Name, t1, function(p1, p2) -- line: 29
		-- upvalues: Analytics (copy), Network (copy), ExternalSettings (copy), resolvePurchasePrecheck (copy), PurchaseWarning (copy), getUpsellFlow (copy), SelectedRobuxPackage (copy), UpsellFlow (copy), SetButtonState (copy), ButtonState (copy), getPurchaseWarning (copy)
		local v18 = p1:getState()
		local v19 = p2[Analytics]
		local v20 = p2[Network]
		local v21 = p2[ExternalSettings]

		if v21.isStudio() then
			return resolvePurchasePrecheck(PurchaseWarning.NoAction)
		end

		local v22 = getUpsellFlow(v21.getPlatform())
		local productId = v18.productInfo.productId
		local u24 = SelectedRobuxPackage.getRobuxProductId(v18)
		local v25 = v18.accountInfo.membershipType == 4
		local u26

		if v22 == UpsellFlow.Web then
			u26 = SelectedRobuxPackage.getProductId(v18)
			u24 = nil
		else
			u26 = nil
		end

		p1:dispatch(SetButtonState(ButtonState.Disabled))

		return getPurchaseWarning(v20, u24, u26, v25):andThen(function(p3) -- line: 57
			-- upvalues: p1 (copy), SetButtonState (copy), ButtonState (copy), v19 (copy), productId (copy), u24 (ref), u26 (ref), resolvePurchasePrecheck (copy), PurchaseWarning (copy)
			p1:dispatch(SetButtonState(ButtonState.Enabled))

			if p3 then
				if p3.action == "U13PaymentModal" then
					v19.signalScaryModalShown(productId, "U13PaymentModal", u24 or u26)

					return p1:dispatch(resolvePurchasePrecheck(PurchaseWarning.U13PaymentModal))
				end

				if p3.action == "U13MonthlyThreshold1Modal" then
					v19.signalScaryModalShown(productId, "U13MonthlyThreshold1Modal", u24 or u26)

					return p1:dispatch(resolvePurchasePrecheck(PurchaseWarning.U13MonthlyThreshold1Modal))
				end

				if p3.action == "U13MonthlyThreshold2Modal" then
					v19.signalScaryModalShown(productId, "U13MonthlyThreshold2Modal", u24 or u26)

					return p1:dispatch(resolvePurchasePrecheck(PurchaseWarning.U13MonthlyThreshold2Modal))
				end

				if p3.action == "ParentalConsentWarningPaymentModal13To17" then
					v19.signalScaryModalShown(productId, "ParentalConsentWarningPaymentModal13To17", u24 or u26)

					return p1:dispatch(resolvePurchasePrecheck(PurchaseWarning.ParentalConsentWarningPaymentModal13To17))
				end
			end

			p1:dispatch(resolvePurchasePrecheck(PurchaseWarning.NoAction))
		end):catch(function(_) -- line: 95
			-- upvalues: p1 (copy), SetButtonState (copy), ButtonState (copy), resolvePurchasePrecheck (copy), PurchaseWarning (copy)
			p1:dispatch(SetButtonState(ButtonState.Enabled))
			p1:dispatch(resolvePurchasePrecheck(PurchaseWarning.NoAction))
		end)
	end)
end

return initiatePurchasePrecheck
