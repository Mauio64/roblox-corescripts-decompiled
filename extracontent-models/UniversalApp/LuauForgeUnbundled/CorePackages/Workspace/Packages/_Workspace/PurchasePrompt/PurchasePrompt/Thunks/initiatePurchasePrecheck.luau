local SetWindowState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetWindowState")
local PurchaseWarning = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseWarning")
local ButtonState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/ButtonState")
local UpsellFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/UpsellFlow")
local Network = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Network")
local getPurchaseWarning = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getPurchaseWarning")
local getUpsellFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/NativeUpsell/getUpsellFlow")
local Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Analytics")
local ExternalSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/ExternalSettings")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")

local SelectedRobuxPackage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/SelectedRobuxPackage")

local resolvePurchasePrecheck = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/resolvePurchasePrecheck")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPromptState")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")

local v5 = { Analytics, Network, ExternalSettings }

local function initiatePurchasePrecheck()
	return Thunk.new("initiatePurchasePrecheck", v5, function(object, p2)
		local state = object:getState()
		local v6 = p2[Analytics]
		local v7 = p2[Network]
		local v8 = p2[ExternalSettings]

		if v8.isStudio() then
			return resolvePurchasePrecheck(PurchaseWarning.NoAction)
		end

		local v9 = getUpsellFlow(v8.getPlatform())

		local productId = state.productInfo.productId
		local robuxProductId = SelectedRobuxPackage.getRobuxProductId(state)

		local v10 = state.accountInfo.membershipType == 4
		local v11

		if v9 == UpsellFlow.Web then
			v11 = SelectedRobuxPackage.getProductId(state)
			robuxProductId = nil
		else
			v11 = nil
		end

		object:dispatch(SetWindowState(ButtonState.Disabled))
		return getPurchaseWarning(v7, robuxProductId, v11, v10):andThen(function(p3)
			object:dispatch(SetWindowState(ButtonState.Enabled))

			if p3 then
				if p3.action == "U13PaymentModal" then
					v6.signalScaryModalShown(productId, "U13PaymentModal", robuxProductId or v11)
					return object:dispatch(resolvePurchasePrecheck(PurchaseWarning.U13PaymentModal))
				end

				if p3.action == "U13MonthlyThreshold1Modal" then
					v6.signalScaryModalShown(productId, "U13MonthlyThreshold1Modal", robuxProductId or v11)

					return object:dispatch(resolvePurchasePrecheck(PurchaseWarning.U13MonthlyThreshold1Modal))
				end

				if p3.action == "U13MonthlyThreshold2Modal" then
					v6.signalScaryModalShown(productId, "U13MonthlyThreshold2Modal", robuxProductId or v11)

					return object:dispatch(resolvePurchasePrecheck(PurchaseWarning.U13MonthlyThreshold2Modal))
				end

				if p3.action == "ParentalConsentWarningPaymentModal13To17" then
					v6.signalScaryModalShown(
						productId,
						"ParentalConsentWarningPaymentModal13To17",
						robuxProductId or v11
					)

					return object:dispatch(resolvePurchasePrecheck(PurchaseWarning.ParentalConsentWarningPaymentModal13To17))
				end
			end

			object:dispatch(resolvePurchasePrecheck(PurchaseWarning.NoAction))
		end):catch(function(p3)
			object:dispatch(SetWindowState(ButtonState.Enabled))
			object:dispatch(resolvePurchasePrecheck(PurchaseWarning.NoAction))
		end)
	end)
end

return initiatePurchasePrecheck
