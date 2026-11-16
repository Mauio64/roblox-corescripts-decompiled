local parent = script.Parent.Parent
game:GetService("UserInputService")

local SetButtonState = require(parent.Actions.SetButtonState)
local PurchaseWarning = require(parent.Enums.PurchaseWarning)
local ButtonState = require(parent.Enums.ButtonState)
local UpsellFlow = require(parent.Enums.UpsellFlow)
local Network = require(parent.Services.Network)
local getPurchaseWarning = require(parent.Network.getPurchaseWarning)
local getUpsellFlow = require(parent.NativeUpsell.getUpsellFlow)
local Analytics = require(parent.Services.Analytics)
local ExternalSettings = require(parent.Services.ExternalSettings)
local Thunk = require(parent.Thunk)

local SelectedRobuxPackage = require(parent.Utils.SelectedRobuxPackage)

local resolvePurchasePrecheck = require(script.Parent.resolvePurchasePrecheck)
require(parent.Actions.SetPromptState)
require(parent.Enums.PromptState)

local v = { Analytics, Network, ExternalSettings }

local function initiatePurchasePrecheck()
	return Thunk.new(script.Name, v, function(object, p)
		local state = object:getState()
		local v2 = p[Analytics]
		local v3 = p[Network]
		local v4 = p[ExternalSettings]

		if v4.isStudio() then
			return resolvePurchasePrecheck(PurchaseWarning.NoAction)
		end

		local upsellFlow = getUpsellFlow(v4.getPlatform())

		local productId = state.productInfo.productId
		local robuxProductId = SelectedRobuxPackage.getRobuxProductId(state)

		local v5 = state.accountInfo.membershipType == 4
		local v6

		if upsellFlow == UpsellFlow.Web then
			v6 = SelectedRobuxPackage.getProductId(state)
			robuxProductId = nil
		else
			v6 = nil
		end

		object:dispatch(SetButtonState(ButtonState.Disabled))
		return getPurchaseWarning(v3, robuxProductId, v6, v5):andThen(function(p2)
			object:dispatch(SetButtonState(ButtonState.Enabled))

			if p2 then
				if p2.action == "U13PaymentModal" then
					v2.signalScaryModalShown(productId, "U13PaymentModal", robuxProductId or v6)
					return object:dispatch(resolvePurchasePrecheck(PurchaseWarning.U13PaymentModal))
				end

				if p2.action == "U13MonthlyThreshold1Modal" then
					v2.signalScaryModalShown(productId, "U13MonthlyThreshold1Modal", robuxProductId or v6)

					return object:dispatch(resolvePurchasePrecheck(PurchaseWarning.U13MonthlyThreshold1Modal))
				end

				if p2.action == "U13MonthlyThreshold2Modal" then
					v2.signalScaryModalShown(productId, "U13MonthlyThreshold2Modal", robuxProductId or v6)

					return object:dispatch(resolvePurchasePrecheck(PurchaseWarning.U13MonthlyThreshold2Modal))
				end

				if p2.action == "ParentalConsentWarningPaymentModal13To17" then
					v2.signalScaryModalShown(
						productId,
						"ParentalConsentWarningPaymentModal13To17",
						robuxProductId or v6
					)

					return object:dispatch(resolvePurchasePrecheck(PurchaseWarning.ParentalConsentWarningPaymentModal13To17))
				end
			end

			object:dispatch(resolvePurchasePrecheck(PurchaseWarning.NoAction))
		end):catch(function(_)
			object:dispatch(SetButtonState(ButtonState.Enabled))
			object:dispatch(resolvePurchasePrecheck(PurchaseWarning.NoAction))
		end)
	end)
end

return initiatePurchasePrecheck
