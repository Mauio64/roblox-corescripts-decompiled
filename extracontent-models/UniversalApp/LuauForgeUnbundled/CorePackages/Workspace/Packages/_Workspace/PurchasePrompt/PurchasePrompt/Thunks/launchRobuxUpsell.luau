local Players = game:GetService("Players")
local ErrorOccurred = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/ErrorOccurred")
local SetPromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPromptState")
local UpsellFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/UpsellFlow")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseFlow")
local getUpsellFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/NativeUpsell/getUpsellFlow")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Misc/Constants")
local postPurchaseWarningAcknowledge = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/postPurchaseWarningAcknowledge")
local Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Analytics")
local ExternalSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/ExternalSettings")
local Network = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Network")
local PlatformInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/PlatformInterface")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")

local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/UniversalAppPolicy").getAppFeaturePolicies
local getFStringVNGWebshopUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").GetFStringVNGWebshopUrl

local retryAfterUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/retryAfterUpsell")

local IAPExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")
local preparePaymentCheck = IAPExperience.PreparePaymentCheck
local getEnableConsolePreparePaymentCheck = IAPExperience.GetEnableConsolePreparePaymentCheck

local SelectedRobuxPackage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/SelectedRobuxPackage")
local desktopUpsellExperiment = IAPExperience.Utility.DesktopUpsellExperiment

local v5 = { Analytics, ExternalSettings, Network, PlatformInterface }

local function launchRobuxUpsell()
	return Thunk.new("launchRobuxUpsell", v5, function(object, p2)
		local v6 = p2[Analytics]
		local v7 = p2[ExternalSettings]
		local v8 = p2[Network]
		local v9 = p2[PlatformInterface]
		local state = object:getState()

		local v10 = getUpsellFlow(v7.getPlatform())

		local v11 = not (v10 == UpsellFlow.Web) and SelectedRobuxPackage.getRobuxProductId(state)
		local productId = state.productInfo.productId

		if getEnableConsolePreparePaymentCheck() and not preparePaymentCheck(v11) then
			object:dispatch(ErrorOccurred(PurchaseError.NotEnoughRobuxNoUpsell))
			return
		end

		if state.promptState == PromptState.U13PaymentModal then
			v6.signalScaryModalConfirmed(productId, "U13PaymentModal", v11)
		elseif state.promptState == PromptState.U13MonthlyThreshold1Modal then
			v6.signalScaryModalConfirmed(productId, "U13MonthlyThreshold1Modal", v11)
		elseif state.promptState == PromptState.U13MonthlyThreshold2Modal then
			v6.signalScaryModalConfirmed(productId, "U13MonthlyThreshold2Modal", v11)
		elseif state.promptState == PromptState.ParentalConsentWarningPaymentModal13To17 then
			v6.signalScaryModalConfirmed(
				productId,
				"ConfirmedParentalConsentWarningPaymentModal13To17",
				v11
			)
		end

		if state.promptState == PromptState.U13PaymentModal then
			postPurchaseWarningAcknowledge.Post(v8, postPurchaseWarningAcknowledge.UserActionType.ConfirmedU13PaymentModal)
		elseif state.promptState == PromptState.U13MonthlyThreshold1Modal then
			postPurchaseWarningAcknowledge.Post(v8, postPurchaseWarningAcknowledge.UserActionType.ConfirmedU13MonthlyThreshold1Modal)
		elseif state.promptState == PromptState.U13MonthlyThreshold2Modal then
			postPurchaseWarningAcknowledge.Post(v8, postPurchaseWarningAcknowledge.UserActionType.ConfirmedU13MonthlyThreshold2Modal)
		elseif state.promptState == PromptState.ParentalConsentWarningPaymentModal13To17 then
			postPurchaseWarningAcknowledge.Post(v8, postPurchaseWarningAcknowledge.UserActionType.ConfirmedParentalConsentWarningPaymentModal13To17)
		end

		if v7.getFFlagDisableRobuxUpsell() then
			object:dispatch(ErrorOccurred(PurchaseError.NotEnoughRobuxNoUpsell))
		elseif v10 == UpsellFlow.Web then
			local requestType = state.requestType
			v6.signalProductPurchaseUpsellConfirmed(productId, requestType, SelectedRobuxPackage.getProductId(state))

			if getAppFeaturePolicies().getRedirectBuyRobuxToVNG() then
				if state.promptState == PromptState.LeaveRobloxWarning then
					v8.getVngShopUrl(v8):andThen(function(p3)
						v9.openVngStore(p3.vngShopRedirectUrl)
						object:dispatch(SetPromptState(PromptState.UpsellInProgress))
					end):catch(function()
						v9.openVngStore(getFStringVNGWebshopUrl())
						object:dispatch(SetPromptState(PromptState.UpsellInProgress))
					end)
				else
					object:dispatch(SetPromptState(PromptState.LeaveRobloxWarning))
				end
			else
				local v12 = { analyticId = state.purchaseFlowUUID }

				local variant = desktopUpsellExperiment.getVariant()

				if variant == desktopUpsellExperiment.variants.OpenRobuxStore then
					v9.openRobuxStoreWithContext(v12, SelectedRobuxPackage.getProductId(state))
				elseif variant == desktopUpsellExperiment.variants.OpenPaymentsPage then
					v9.openPaymentsPageWithContext(v12, SelectedRobuxPackage.getProductId(state))
				else
					v9.startRobuxUpsellWebByFlowWithContext(
						v12,
						state.purchaseFlow,
						SelectedRobuxPackage.getProductId(state)
					)
				end

				object:dispatch(SetPromptState(PromptState.UpsellInProgress))
			end
		elseif v10 == UpsellFlow.Mobile then
			local robuxProductId = SelectedRobuxPackage.getRobuxProductId(state)
			local productId2 = state.productInfo.productId
			local requestType = state.requestType
			local localPlayer = Players.LocalPlayer

			v6.signalProductPurchaseUpsellConfirmed(productId2, requestType, robuxProductId)

			if game:GetEngineFeature("NativePurchaseWithLocalPlayer") then
				v9.promptNativePurchaseWithLocalPlayer(robuxProductId)
			else
				v9.promptNativePurchase(localPlayer, robuxProductId)
			end

			object:dispatch(SetPromptState(PromptState.UpsellInProgress))
		elseif v10 == UpsellFlow.Xbox then
			local robuxProductId = SelectedRobuxPackage.getRobuxProductId(state)
			local productId2 = state.productInfo.productId
			local requestType = state.requestType

			v6.signalProductPurchaseUpsellConfirmed(productId2, requestType, robuxProductId)
			object:dispatch(SetPromptState(PromptState.UpsellInProgress))
			return Promise.new(function(callback, callback2)
				local v12 = nil

				local success, result = pcall(function()
					v12 = v9.beginPlatformStorePurchase(robuxProductId)
				end)

				if success then
					callback(v12)
				else
					callback2(result)
				end
			end):andThen(function(p3)
				if p3 == Constants.PlatformPurchaseResult.PurchaseResult_Success then
					v6.signalXboxInGamePurchaseSuccess(productId2, requestType, robuxProductId)
				elseif p3 == Constants.PlatformPurchaseResult.PurchaseResult_UserCancelled then
					v6.signalXboxInGamePurchaseCanceled(productId2, requestType, robuxProductId)
				else
					v6.signalXboxInGamePurchaseFailure(productId2, requestType, robuxProductId)
				end

				if
					p3 == Constants.PlatformPurchaseResult.PurchaseResult_Success
					or p3 == Constants.PlatformPurchaseResult.PurchaseResult_RobuxUpdated
				then
					return object:dispatch(retryAfterUpsell())
				end

				return object:dispatch(ErrorOccurred(PurchaseError.UnknownFailure))
			end)
		elseif v10 == UpsellFlow.Unavailable then
			object:dispatch(ErrorOccurred(PurchaseError.NotEnoughRobuxNoUpsell))
		else
			warn("Need more Robux: platform not supported for Robux purchase")
		end
	end)
end

return launchRobuxUpsell
