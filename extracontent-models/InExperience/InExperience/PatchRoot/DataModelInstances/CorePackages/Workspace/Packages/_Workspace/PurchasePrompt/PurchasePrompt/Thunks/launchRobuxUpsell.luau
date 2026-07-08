local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
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
local getAppFeaturePolicies = require(PurchasePromptParent.UniversalAppPolicy).getAppFeaturePolicies
local GetFStringVNGWebshopUrl = require(PurchasePromptParent.SharedFlags).GetFStringVNGWebshopUrl
local retryAfterUpsell = require(script.Parent.retryAfterUpsell)
local IAPExperience = require(PurchasePromptParent.IAPExperience)
local PreparePaymentCheck = IAPExperience.PreparePaymentCheck
local GetEnableConsolePreparePaymentCheck = IAPExperience.GetEnableConsolePreparePaymentCheck
local SelectedRobuxPackage = require(PurchasePrompt.Utils.SelectedRobuxPackage)
local DesktopUpsellExperiment = IAPExperience.Utility.DesktopUpsellExperiment
local t1 = {
	Analytics,
	ExternalSettings,
	Network,
	PlatformInterface
}

local function launchRobuxUpsell() -- line: 41
	-- upvalues: Thunk (copy), t1 (copy), Analytics (copy), ExternalSettings (copy), Network (copy), PlatformInterface (copy), getUpsellFlow (copy), UpsellFlow (copy), SelectedRobuxPackage (copy), GetEnableConsolePreparePaymentCheck (copy), PreparePaymentCheck (copy), ErrorOccurred (copy), PurchaseError (copy), PromptState (copy), postPurchaseWarningAcknowledge (copy), getAppFeaturePolicies (copy), SetPromptState (copy), GetFStringVNGWebshopUrl (copy), DesktopUpsellExperiment (copy), Players (copy), Promise (copy), Constants (copy), retryAfterUpsell (copy)
	return Thunk.new(script.Name, t1, function(p1, p2) -- line: 42
		-- upvalues: Analytics (copy), ExternalSettings (copy), Network (copy), PlatformInterface (copy), getUpsellFlow (copy), UpsellFlow (copy), SelectedRobuxPackage (copy), GetEnableConsolePreparePaymentCheck (copy), PreparePaymentCheck (copy), ErrorOccurred (copy), PurchaseError (copy), PromptState (copy), postPurchaseWarningAcknowledge (copy), getAppFeaturePolicies (copy), SetPromptState (copy), GetFStringVNGWebshopUrl (copy), DesktopUpsellExperiment (copy), Players (copy), Promise (copy), Constants (copy), retryAfterUpsell (copy)
		local v30 = p2[Analytics]
		local v31 = p2[ExternalSettings]
		local v32 = p2[Network]
		local v33 = p2[PlatformInterface]
		local v34 = p1:getState()
		local v35 = getUpsellFlow(v31.getPlatform())
		local v36 = v35 ~= UpsellFlow.Web and SelectedRobuxPackage.getRobuxProductId(v34)
		local productId = v34.productInfo.productId

		if GetEnableConsolePreparePaymentCheck() and not PreparePaymentCheck(v36) then
			p1:dispatch(ErrorOccurred(PurchaseError.NotEnoughRobuxNoUpsell))

			return
		end

		if v34.promptState == PromptState.U13PaymentModal then
			v30.signalScaryModalConfirmed(productId, "U13PaymentModal", v36)
		elseif v34.promptState == PromptState.U13MonthlyThreshold1Modal then
			v30.signalScaryModalConfirmed(productId, "U13MonthlyThreshold1Modal", v36)
		elseif v34.promptState == PromptState.U13MonthlyThreshold2Modal then
			v30.signalScaryModalConfirmed(productId, "U13MonthlyThreshold2Modal", v36)
		elseif v34.promptState == PromptState.ParentalConsentWarningPaymentModal13To17 then
			v30.signalScaryModalConfirmed(productId, "ConfirmedParentalConsentWarningPaymentModal13To17", v36)
		end

		if v34.promptState == PromptState.U13PaymentModal then
			postPurchaseWarningAcknowledge.Post(v32, postPurchaseWarningAcknowledge.UserActionType.ConfirmedU13PaymentModal)
		elseif v34.promptState == PromptState.U13MonthlyThreshold1Modal then
			postPurchaseWarningAcknowledge.Post(v32, postPurchaseWarningAcknowledge.UserActionType.ConfirmedU13MonthlyThreshold1Modal)
		elseif v34.promptState == PromptState.U13MonthlyThreshold2Modal then
			postPurchaseWarningAcknowledge.Post(v32, postPurchaseWarningAcknowledge.UserActionType.ConfirmedU13MonthlyThreshold2Modal)
		elseif v34.promptState == PromptState.ParentalConsentWarningPaymentModal13To17 then
			postPurchaseWarningAcknowledge.Post(v32, postPurchaseWarningAcknowledge.UserActionType.ConfirmedParentalConsentWarningPaymentModal13To17)
		end

		if v31.getFFlagDisableRobuxUpsell() then
			p1:dispatch(ErrorOccurred(PurchaseError.NotEnoughRobuxNoUpsell))

			return
		end

		if v35 == UpsellFlow.Web then
			local requestType = v34.requestType

			v30.signalProductPurchaseUpsellConfirmed(productId, requestType, SelectedRobuxPackage.getProductId(v34))

			if getAppFeaturePolicies().getRedirectBuyRobuxToVNG() then
				if v34.promptState == PromptState.LeaveRobloxWarning then
					v32:getVngShopUrl():andThen(function(p3) -- line: 112
						-- upvalues: v33 (copy), p1 (copy), SetPromptState (copy), PromptState (copy)
						v33.openVngStore(p3.vngShopRedirectUrl)
						p1:dispatch(SetPromptState(PromptState.UpsellInProgress))
					end):catch(function() -- line: 116
						-- upvalues: v33 (copy), GetFStringVNGWebshopUrl (copy), p1 (copy), SetPromptState (copy), PromptState (copy)
						v33.openVngStore(GetFStringVNGWebshopUrl())
						p1:dispatch(SetPromptState(PromptState.UpsellInProgress))
					end)

					return
				end

				p1:dispatch(SetPromptState(PromptState.LeaveRobloxWarning))

				return
			end

			local t2 = {
				analyticId = v34.purchaseFlowUUID
			}
			local v40 = DesktopUpsellExperiment.getVariant()

			if v40 == DesktopUpsellExperiment.variants.OpenRobuxStore then
				v33.openRobuxStoreWithContext(t2, SelectedRobuxPackage.getProductId(v34))
			elseif v40 == DesktopUpsellExperiment.variants.OpenPaymentsPage then
				v33.openPaymentsPageWithContext(t2, SelectedRobuxPackage.getProductId(v34))
			else
				v33.startRobuxUpsellWebByFlowWithContext(t2, v34.purchaseFlow, SelectedRobuxPackage.getProductId(v34))
			end

			p1:dispatch(SetPromptState(PromptState.UpsellInProgress))

			return
		end

		if v35 == UpsellFlow.Mobile then
			local v41 = SelectedRobuxPackage.getRobuxProductId(v34)
			local productId2 = v34.productInfo.productId
			local requestType = v34.requestType
			local LocalPlayer = Players.LocalPlayer

			v30.signalProductPurchaseUpsellConfirmed(productId2, requestType, v41)

			if game:GetEngineFeature("NativePurchaseWithLocalPlayer") then
				v33.promptNativePurchaseWithLocalPlayer(v41)
			else
				v33.promptNativePurchase(LocalPlayer, v41)
			end

			p1:dispatch(SetPromptState(PromptState.UpsellInProgress))

			return
		end

		if v35 == UpsellFlow.Xbox then
			local v45 = SelectedRobuxPackage.getRobuxProductId(v34)
			local productId3 = v34.productInfo.productId
			local requestType = v34.requestType

			v30.signalProductPurchaseUpsellConfirmed(productId3, requestType, v45)
			p1:dispatch(SetPromptState(PromptState.UpsellInProgress))

			return Promise.new(function(resolve, reject) -- line: 162
				-- upvalues: v33 (copy), v45 (copy)
				local u51 = nil
				local ok, result = pcall(function() -- line: 168
					-- upvalues: u51 (ref), v33 (copy), v45 (copy)
					u51 = v33.beginPlatformStorePurchase(v45)
				end)

				if ok then
					resolve(u51)
				else
					reject(result)
				end
			end):andThen(function(p4) -- line: 177
				-- upvalues: Constants (copy), v30 (copy), productId3 (copy), requestType (copy), v45 (copy), p1 (copy), retryAfterUpsell (copy), ErrorOccurred (copy), PurchaseError (copy)
				if p4 == Constants.PlatformPurchaseResult.PurchaseResult_Success then
					v30.signalXboxInGamePurchaseSuccess(productId3, requestType, v45)
				elseif p4 == Constants.PlatformPurchaseResult.PurchaseResult_UserCancelled then
					v30.signalXboxInGamePurchaseCanceled(productId3, requestType, v45)
				else
					v30.signalXboxInGamePurchaseFailure(productId3, requestType, v45)
				end

				if p4 == Constants.PlatformPurchaseResult.PurchaseResult_Success or p4 == Constants.PlatformPurchaseResult.PurchaseResult_RobuxUpdated then
					return p1:dispatch(retryAfterUpsell())
				end

				return p1:dispatch(ErrorOccurred(PurchaseError.UnknownFailure))
			end)
		end

		if v35 == UpsellFlow.Unavailable then
			p1:dispatch(ErrorOccurred(PurchaseError.NotEnoughRobuxNoUpsell))

			return
		end

		warn("Need more Robux: platform not supported for Robux purchase")
	end)
end

return launchRobuxUpsell
