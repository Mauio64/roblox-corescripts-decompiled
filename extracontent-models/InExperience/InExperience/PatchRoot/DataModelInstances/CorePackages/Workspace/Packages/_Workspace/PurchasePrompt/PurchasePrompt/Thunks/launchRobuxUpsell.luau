local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local Players = game:GetService("Players")
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local SetPromptState = require(PurchasePrompt.Actions.SetPromptState)
local UpsellFlow = require(PurchasePrompt.Enums.UpsellFlow)
local PromptState = require(PurchasePrompt.Enums.PromptState)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
require(PurchasePrompt.Enums.PurchaseFlow)
local getUpsellFlow = require(PurchasePrompt.NativeUpsell.getUpsellFlow)
local Constants = require(PurchasePrompt.Misc.Constants)
local postPurchaseWarningAcknowledge = require(PurchasePrompt.Network.postPurchaseWarningAcknowledge)
local Analytics = require(PurchasePrompt.Services.Analytics)
local ExternalSettings = require(PurchasePrompt.Services.ExternalSettings)
local Network = require(PurchasePrompt.Services.Network)
local PlatformInterface = require(PurchasePrompt.Services.PlatformInterface)
local Thunk = require(PurchasePrompt.Thunk)
local Promise = require(PurchasePrompt.Promise)

local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies
local SharedFlags = require(parent.SharedFlags)
local GetFStringVNGWebshopUrl = SharedFlags.GetFStringVNGWebshopUrl

local retryAfterUpsell = require(script.Parent.retryAfterUpsell)

local IAPExperience = require(parent.IAPExperience)
local PreparePaymentCheck = IAPExperience.PreparePaymentCheck
local GetEnableConsolePreparePaymentCheck = IAPExperience.GetEnableConsolePreparePaymentCheck

local SelectedRobuxPackage = require(PurchasePrompt.Utils.SelectedRobuxPackage)
local DesktopUpsellExperiment = IAPExperience.Utility.DesktopUpsellExperiment

local v = { Analytics, ExternalSettings, Network, PlatformInterface }

local function launchRobuxUpsell()
	return Thunk.new(script.Name, v, function(object, p)
		local v2 = p[Analytics]
		local v3 = p[ExternalSettings]
		local v4 = p[Network]
		local v5 = p[PlatformInterface]
		local state = object:getState()

		local upsellFlow = getUpsellFlow(v3.getPlatform())
		local v6

		if upsellFlow == UpsellFlow.Web then
			v6 = false
		else
			v6 = SelectedRobuxPackage.getRobuxProductId(state)
		end

		local productId = state.productInfo.productId

		if GetEnableConsolePreparePaymentCheck() and not PreparePaymentCheck(v6) then
			object:dispatch(ErrorOccurred(PurchaseError.NotEnoughRobuxNoUpsell))
			return
		end

		if state.promptState == PromptState.U13PaymentModal then
			v2.signalScaryModalConfirmed(productId, "U13PaymentModal", v6)
		elseif state.promptState == PromptState.U13MonthlyThreshold1Modal then
			v2.signalScaryModalConfirmed(productId, "U13MonthlyThreshold1Modal", v6)
		elseif state.promptState == PromptState.U13MonthlyThreshold2Modal then
			v2.signalScaryModalConfirmed(productId, "U13MonthlyThreshold2Modal", v6)
		elseif state.promptState == PromptState.ParentalConsentWarningPaymentModal13To17 then
			v2.signalScaryModalConfirmed(productId, "ConfirmedParentalConsentWarningPaymentModal13To17", v6)
		end

		if state.promptState == PromptState.U13PaymentModal then
			postPurchaseWarningAcknowledge.Post(
				v4,
				postPurchaseWarningAcknowledge.UserActionType.ConfirmedU13PaymentModal
			)
		elseif state.promptState == PromptState.U13MonthlyThreshold1Modal then
			postPurchaseWarningAcknowledge.Post(
				v4,
				postPurchaseWarningAcknowledge.UserActionType.ConfirmedU13MonthlyThreshold1Modal
			)
		elseif state.promptState == PromptState.U13MonthlyThreshold2Modal then
			postPurchaseWarningAcknowledge.Post(
				v4,
				postPurchaseWarningAcknowledge.UserActionType.ConfirmedU13MonthlyThreshold2Modal
			)
		elseif state.promptState == PromptState.ParentalConsentWarningPaymentModal13To17 then
			postPurchaseWarningAcknowledge.Post(
				v4,
				postPurchaseWarningAcknowledge.UserActionType.ConfirmedParentalConsentWarningPaymentModal13To17
			)
		end

		if v3.getFFlagDisableRobuxUpsell() then
			object:dispatch(ErrorOccurred(PurchaseError.NotEnoughRobuxNoUpsell))
		elseif upsellFlow == UpsellFlow.Web then
			local requestType = state.requestType
			v2.signalProductPurchaseUpsellConfirmed(productId, requestType, SelectedRobuxPackage.getProductId(state))

			if getAppFeaturePolicies().getRedirectBuyRobuxToVNG() then
				if state.promptState == PromptState.LeaveRobloxWarning then
					v4.getVngShopUrl(v4):andThen(function(p2)
						v5.openVngStore(p2.vngShopRedirectUrl)
						object:dispatch(SetPromptState(PromptState.UpsellInProgress))
					end):catch(function()
						v5.openVngStore(GetFStringVNGWebshopUrl())
						object:dispatch(SetPromptState(PromptState.UpsellInProgress))
					end)
				else
					object:dispatch(SetPromptState(PromptState.LeaveRobloxWarning))
				end
			else
				local v7 = { analyticId = state.purchaseFlowUUID }

				local variant = DesktopUpsellExperiment.getVariant()

				if variant == DesktopUpsellExperiment.variants.OpenRobuxStore then
					v5.openRobuxStoreWithContext(v7, SelectedRobuxPackage.getProductId(state))
				elseif variant == DesktopUpsellExperiment.variants.OpenPaymentsPage then
					v5.openPaymentsPageWithContext(v7, SelectedRobuxPackage.getProductId(state))
				else
					v5.startRobuxUpsellWebByFlowWithContext(
						v7,
						state.purchaseFlow,
						SelectedRobuxPackage.getProductId(state)
					)
				end

				object:dispatch(SetPromptState(PromptState.UpsellInProgress))
			end
		elseif upsellFlow == UpsellFlow.Mobile then
			local robuxProductId = SelectedRobuxPackage.getRobuxProductId(state)
			local productId2 = state.productInfo.productId
			local requestType = state.requestType
			local localPlayer = Players.LocalPlayer

			v2.signalProductPurchaseUpsellConfirmed(productId2, requestType, robuxProductId)

			if game:GetEngineFeature("NativePurchaseWithLocalPlayer") then
				v5.promptNativePurchaseWithLocalPlayer(robuxProductId)
			else
				v5.promptNativePurchase(localPlayer, robuxProductId)
			end

			object:dispatch(SetPromptState(PromptState.UpsellInProgress))
		elseif upsellFlow == UpsellFlow.Xbox then
			local robuxProductId = SelectedRobuxPackage.getRobuxProductId(state)
			local productId2 = state.productInfo.productId
			local requestType = state.requestType

			v2.signalProductPurchaseUpsellConfirmed(productId2, requestType, robuxProductId)
			object:dispatch(SetPromptState(PromptState.UpsellInProgress))
			return Promise.new(function(callback, callback2)
				local v7 = nil

				local success, result = pcall(function()
					v7 = v5.beginPlatformStorePurchase(robuxProductId)
				end)

				if success then
					callback(v7)
				else
					callback2(result)
				end
			end):andThen(function(p2)
				if p2 == Constants.PlatformPurchaseResult.PurchaseResult_Success then
					v2.signalXboxInGamePurchaseSuccess(productId2, requestType, robuxProductId)
				elseif p2 == Constants.PlatformPurchaseResult.PurchaseResult_UserCancelled then
					v2.signalXboxInGamePurchaseCanceled(productId2, requestType, robuxProductId)
				else
					v2.signalXboxInGamePurchaseFailure(productId2, requestType, robuxProductId)
				end

				if
					p2 == Constants.PlatformPurchaseResult.PurchaseResult_Success
					or p2 == Constants.PlatformPurchaseResult.PurchaseResult_RobuxUpdated
				then
					return object:dispatch(retryAfterUpsell())
				end

				return object:dispatch(ErrorOccurred(PurchaseError.UnknownFailure))
			end)
		elseif upsellFlow == UpsellFlow.Unavailable then
			object:dispatch(ErrorOccurred(PurchaseError.NotEnoughRobuxNoUpsell))
		else
			warn("Need more Robux: platform not supported for Robux purchase")
		end
	end)
end

return launchRobuxUpsell
