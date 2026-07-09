local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local React = require(PurchasePromptParent.React)
local useMemo = React.useMemo
local useEffect = React.useEffect
local UIBlox = require(PurchasePromptParent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(PurchasePromptParent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local Localization2 = require(PurchasePromptParent.RobloxAppLocales).Localization
local useLocalization = Localization.Hooks.useLocalization
local PromptState = require(PurchasePrompt.Enums.PromptState)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local IAPExperience = require(PurchasePromptParent.IAPExperience)
local formatEconomicRestrictionText = IAPExperience.Utility.formatEconomicRestrictionText
local addEconomicRestrictionKeysToLocalization = IAPExperience.Utility.addEconomicRestrictionKeysToLocalization
local formatTextWithParams = require(PurchasePrompt.Utils.formatTextWithParams)
local EconomicRestrictionsCounter = IAPExperience.Counters.EconomicRestrictionsCounter
local UniversalEconomicRestrictionsCounter = EconomicRestrictionsCounter.UniversalEconomicRestrictionsCounter
local EconomicRestrictionsSurface = EconomicRestrictionsCounter.EconomicRestrictionsSurface
local ProductPurchasePromptCounter = IAPExperience.Counters.ProductPurchasePromptCounter.ProductPurchasePromptCounter
local default = require(PurchasePromptParent.LoggingProtocol).default
local FFlagEnableUnifiedProductPurchaseFlow = require(PurchasePromptParent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local FFlagPurchaseModalTimedOptionExtension = require(PurchasePromptParent.SharedFlags).FFlagPurchaseModalTimedOptionExtension
local UnifiedPurchaseCompletionModal = IAPExperience.UnifiedPurchaseCompletionModal
local UnifiedPurchaseCompletionModalV2 = IAPExperience.UnifiedPurchaseCompletionModalV2
local FFlagFixPurchasingErrorCounter = require(PurchasePrompt.Flags.FFlagFixPurchasingErrorCounter)
local _ = require(PurchasePromptParent.SharedFlags).FFlagAddCenterDialogForUnifiedPurchaseModal
local AppContext = require(PurchasePrompt.Utils.AppContext)
local FFlagAddCenterDialogForUnifiedPurchaseModal = require(PurchasePromptParent.SharedFlags).FFlagAddCenterDialogForUnifiedPurchaseModal
local FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase = require(PurchasePromptParent.SharedFlags).FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase

local function getPurchaseErrorText(p1, p2) -- line: 62
	-- upvalues: PurchaseError (copy)
	if p2 == PurchaseError.CannotGetBalance then
		return p1.PurchaseErrorCannotGetBalanceText
	end

	if p2 == PurchaseError.CannotGetItemPrice then
		return p1.PurchaseErrorCannotGetItemPriceText
	end

	if p2 == PurchaseError.NotForSale then
		return p1.PurchaseErrorNotForSaleText
	end

	if p2 == PurchaseError.NotForSaleHere then
		return p1.PurchaseErrorNotForSaleHereText
	end

	if p2 == PurchaseError.AlreadyOwn then
		return p1.PurchaseErrorAlreadyOwnText
	end

	if p2 == PurchaseError.Under13 then
		return p1.PurchaseErrorUnder13Text
	end

	if p2 == PurchaseError.Limited then
		return p1.PurchaseErrorLimitedText
	end

	if p2 == PurchaseError.ThirdPartyDisabled then
		return p1.PurchaseErrorThirdPartyDisabledText
	end

	if p2 == PurchaseError.NotEnoughRobux then
		return p1.PurchaseErrorNotEnoughRobuxText
	end

	if p2 == PurchaseError.NotEnoughRobuxXbox then
		return p1.PurchaseErrorNotEnoughRobuxXboxText
	end

	if p2 == PurchaseError.NotEnoughRobuxNoUpsell then
		return p1.PurchaseErrorNotEnoughRobuxNoUpsellText
	end

	if p2 == PurchaseError.TwoFactorNeeded then
		return p1.PurchaseErrorTwoFactorNeededText
	end

	if p2 == PurchaseError.TwoFactorNeededSettings then
		return p1.PurchaseErrorTwoFactorNeededSettingsText
	end

	if p2 == PurchaseError.UnknownFailure then
		return p1.PurchaseErrorUnknownFailureText
	end

	if p2 == PurchaseError.UnknownFailureNoItemName then
		return p1.PurchaseErrorUnknownFailureNoItemNameText
	end

	if p2 == PurchaseError.PurchaseDisabled then
		return p1.PurchaseErrorPurchaseDisabledText
	end

	if p2 == PurchaseError.InvalidFunds then
		return p1.PurchaseErrorInvalidFundsText
	end

	if p2 == PurchaseError.InvalidFundsUnknown then
		return p1.PurchaseErrorInvalidFundsUnknownText
	end

	if p2 == PurchaseError.PremiumOnly then
		return p1.PurchaseErrorPremiumOnlyText
	end

	return p1.PurchaseErrorUnknownFailureNoItemNameText
end
local function getModalContent(p3, t1: {[any]: any}) -- line: 106
	-- upvalues: PromptState (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), FFlagPurchaseModalTimedOptionExtension (copy), formatTextWithParams (copy), PurchaseError (copy), formatEconomicRestrictionText (copy), FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase (copy), getPurchaseErrorText (copy)
	local promptState = t1.promptState
	local purchaseError = t1.purchaseError
	local isGenericChallengeResponse = t1.isGenericChallengeResponse
	local productInfo = t1.productInfo

	if promptState == PromptState.PurchaseComplete then
		if FFlagEnableUnifiedProductPurchaseFlow and t1.useUnifiedPurchaseCompletionModal then
			if t1.isMultiItem then
				return {
					messageText = p3.MultiItemPurchaseCompleteBody,
					titleText = p3.PurchaseCompleteTitle
				}
			end

			if FFlagPurchaseModalTimedOptionExtension and t1.completionMessage then
				return {
					messageText = t1.completionMessage,
					titleText = p3.PurchaseCompleteTitle
				}
			end

			return {
				messageText = formatTextWithParams(p3.PurchaseCompleteBody, {
					ITEM_NAME = t1.productInfo.name
				}),
				titleText = p3.PurchaseCompleteTitle
			}
		end

		return {
			messageText = formatTextWithParams(p3.PurchaseCompleteSucceededText, {
				ITEM_NAME = t1.productInfo.name
			}),
			titleText = p3.BuyItemTitle
		}
	end

	if promptState == PromptState.U13PaymentModal then
		return {
			messageText = p3.ScaryModalOneText,
			titleText = p3.BuyItemTitle
		}
	end

	if promptState == PromptState.U13MonthlyThreshold1Modal then
		return {
			messageText = p3.ScaryModalTwoText,
			titleText = p3.BuyItemTitle
		}
	end

	if promptState == PromptState.U13MonthlyThreshold2Modal then
		return {
			messageText = p3.ScaryModalParentalText,
			titleText = p3.BuyItemTitle
		}
	end

	if promptState == PromptState.ParentalConsentWarningPaymentModal13To17 then
		return {
			messageText = p3.ParentalConsentText,
			titleText = p3.BuyItemTitle
		}
	end

	if promptState == PromptState.Error then
		if purchaseError == PurchaseError.UnknownFailure then
			return {
				messageText = formatTextWithParams(p3.PurchaseErrorUnknownFailureText, {
					ITEM_NAME = productInfo.name
				}),
				titleText = p3.ErrorTitle
			}
		end

		if purchaseError == PurchaseError.TwoFactorNeededSettings or isGenericChallengeResponse(purchaseError) then
			return {
				messageText = p3.Enable2SVLogoutText,
				titleText = p3.ErrorTitle
			}
		end

		if purchaseError == PurchaseError.EconomicRestriction then
			return {
				messageText = formatEconomicRestrictionText(p3, {
					violationType = t1.economicRestrictionError.violationType,
					timeoutMinutes = t1.economicRestrictionError.timeoutMinutes
				}, true),
				titleText = p3.ErrorTitle
			}
		end

		if FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase and purchaseError == PurchaseError.PendingProductsLimitExceeded then
			return {
				messageText = p3.DevProductPendingProductsLimitExceededMessageText,
				titleText = p3.DevProductPendingProductsLimitExceededTitleText
			}
		end

		return {
			messageText = getPurchaseErrorText(p3, purchaseError),
			titleText = p3.ErrorTitle
		}
	end

	return {
		messageText = p3.PurchaseErrorUnknownFailureNoItemNameText,
		titleText = p3.ErrorTitle
	}
end
local function getButtonStackInfo(t2: {[any]: any}, p4) -- line: 202
	-- upvalues: ButtonType (copy)
	if t2.includeCancelButton then
		return {
			{
				props = {
					onActivated = t2.cancelButtonPressed,
					text = p4.CancelPurchaseText,
					inputIcon = if not t2.isGamepadEnabled then nil else "rbxasset://textures/ui/Controls/DesignSystem/ButtonB.png"
				}
			},
			{
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = t2.confirmButtonPressed,
					text = p4.OkButtonText,
					inputIcon = if not t2.isGamepadEnabled then nil else "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png"
				}
			}
		}
	end

	return {{
		buttonType = ButtonType.PrimarySystem,
		props = {
			onActivated = t2.confirmButtonPressed,
			text = p4.OkButtonText,
			inputIcon = if not t2.isGamepadEnabled then nil else "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png"
		}
	}}
end
local function ProductPurchasePrompt(t3: {[any]: any}) -- line: 237
	-- upvalues: FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase (copy), addEconomicRestrictionKeysToLocalization (copy), useLocalization (copy), useMemo (copy), getModalContent (copy), useEffect (copy), FFlagFixPurchasingErrorCounter (copy), default (copy), ProductPurchasePromptCounter (copy), PurchaseError (copy), PromptState (copy), UniversalEconomicRestrictionsCounter (copy), EconomicRestrictionsSurface (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), FFlagAddCenterDialogForUnifiedPurchaseModal (copy), AppContext (copy), React (copy), UnifiedPurchaseCompletionModalV2 (copy), UnifiedPurchaseCompletionModal (copy), InteractiveAlert (copy), getButtonStackInfo (copy)
	local t4 = {
		PurchaseCompleteTitle = "IAPExperience.PurchasePrompt.Title.PurchaseCompleted",
		PurchaseCompleteBody = "IAPExperience.PurchasePrompt.Body.PurchaseCompleted",
		PurchaseCompleteSucceededText = "CoreScripts.PurchasePrompt.PurchaseMessage.Succeeded",
		BuyItemTitle = "CoreScripts.PurchasePrompt.Title.BuyItem",
		VerificationRequiredTitle = "CoreScripts.PurchasePrompt.Title.VerificationRequired",
		OkButtonText = "CoreScripts.PurchasePrompt.Button.OK",
		SettingsButtonText = "CoreScripts.PurchasePrompt.Button.Settings",
		CancelPurchaseText = "CoreScripts.PurchasePrompt.CancelPurchase.Cancel",
		ErrorTitle = "CoreScripts.PremiumModal.Title.Error",
		ScaryModalOneText = "CoreScripts.PurchasePrompt.PurchaseDetails.ScaryModalOne",
		ScaryModalTwoText = "CoreScripts.PurchasePrompt.PurchaseDetails.ScaryModalTwo",
		ScaryModalParentalText = "CoreScripts.PurchasePrompt.PurchaseDetails.ScaryModalParental",
		Enable2SVLogoutText = "CoreScripts.PurchasePrompt.PurchaseFailed.Enable2SVLogout",
		PurchaseErrorCannotGetBalanceText = "CoreScripts.PurchasePrompt.PurchaseFailed.CannotGetBalance",
		PurchaseErrorCannotGetItemPriceText = "CoreScripts.PurchasePrompt.PurchaseFailed.CannotGetItemPrice",
		PurchaseErrorNotForSaleText = "CoreScripts.PurchasePrompt.PurchaseFailed.NotForSale",
		PurchaseErrorNotForSaleHereText = "CoreScripts.PurchasePrompt.PurchaseFailed.NotForSaleHere",
		PurchaseErrorAlreadyOwnText = "CoreScripts.PurchasePrompt.PurchaseFailed.AlreadyOwn",
		PurchaseErrorUnder13Text = "CoreScripts.PurchasePrompt.PurchaseFailed.Under13",
		PurchaseErrorLimitedText = "CoreScripts.PurchasePrompt.PurchaseFailed.Limited",
		PurchaseErrorThirdPartyDisabledText = "CoreScripts.PurchasePrompt.PurchaseFailed.ThirdPartyDisabled",
		PurchaseErrorNotEnoughRobuxText = "CoreScripts.PurchasePrompt.PurchaseFailed.NotEnoughRobux",
		PurchaseErrorNotEnoughRobuxXboxText = "CoreScripts.PurchasePrompt.PurchaseFailed.NotEnoughRobuxXbox",
		PurchaseErrorNotEnoughRobuxNoUpsellText = "CoreScripts.PurchasePrompt.PurchaseFailed.NotEnoughRobuxNoUpsell",
		PurchaseErrorTwoFactorNeededText = "CoreScripts.PurchasePrompt.PurchaseFailed.Enable2SV",
		PurchaseErrorTwoFactorNeededSettingsText = "CoreScripts.PurchasePrompt.PurchaseFailed.Enable2SV",
		PurchaseErrorUnknownFailureText = "CoreScripts.PurchasePrompt.PurchaseFailed.UnknownFailure",
		PurchaseErrorUnknownFailureNoItemNameText = "CoreScripts.PurchasePrompt.PurchaseFailed.UnknownFailureNoItemName",
		PurchaseErrorPurchaseDisabledText = "CoreScripts.PurchasePrompt.PurchaseFailed.PurchaseDisabled",
		PurchaseErrorInvalidFundsText = "CoreScripts.PurchasePrompt.PurchaseFailed.InvalidFunds",
		PurchaseErrorInvalidFundsUnknownText = "CoreScripts.PurchasePrompt.PurchaseFailed.InvalidFunds",
		PurchaseErrorPremiumOnlyText = "CoreScripts.PurchasePrompt.PurchaseFailed.PremiumOnly",
		DevProductPendingProductsLimitExceededTitleText = if not FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase then nil else "Purchasing.PurchaseDialog.Heading.PendingDeveloperProductLimitReached",
		DevProductPendingProductsLimitExceededMessageText = if not FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase then nil else "Purchasing.PurchaseDialog.Message.PendingDeveloperProductLimitReached",
		MultiItemPurchaseCompleteBody = "IAPExperience.PurchasePrompt.Body.PurchaseItemsSuccess"
	}

	addEconomicRestrictionKeysToLocalization(t4)

	local v51 = useLocalization(t4)
	local v52 = useMemo(function() -- line: 283
		-- upvalues: getModalContent (copy), v51 (copy), t3 (copy)
		return (getModalContent(v51, t3))
	end, { t3 })

	useEffect(function() -- line: 287
		-- upvalues: FFlagFixPurchasingErrorCounter (copy), default (copy), ProductPurchasePromptCounter (copy), t3 (copy), PurchaseError (copy), PromptState (copy), UniversalEconomicRestrictionsCounter (copy), EconomicRestrictionsSurface (copy)
		if FFlagFixPurchasingErrorCounter then
			default:logRobloxTelemetryCounter(ProductPurchasePromptCounter, 1, {
				promptState = tostring(t3.promptState),
				purchaseError = if not PurchaseError.isMember(t3.purchaseError) then tostring(PurchaseError.UnknownFailure) else tostring(t3.purchaseError)
			})
		else
			default:logRobloxTelemetryCounter(ProductPurchasePromptCounter, 1, {
				promptState = tostring(t3.promptState),
				purchaseError = t3.promptState ~= PromptState.Error and "" or tostring(t3.purchaseError)
			})
		end

		if t3.purchaseError == PurchaseError.EconomicRestriction then
			default:logRobloxTelemetryCounter(UniversalEconomicRestrictionsCounter, 1, {
				surface = EconomicRestrictionsSurface.InExperience,
				failureReason = tostring(t3.economicRestrictionError.violationType)
			})
		end
	end, { t3.purchaseError })

	if FFlagEnableUnifiedProductPurchaseFlow and t3.useUnifiedPurchaseCompletionModal then
		if FFlagAddCenterDialogForUnifiedPurchaseModal and AppContext.get() == AppContext.Enum.IN_APP then
			return React.createElement(UnifiedPurchaseCompletionModalV2, {
				title = v52.titleText,
				isError = t3.promptState ~= PromptState.PurchaseComplete,
				bodyText = v52.messageText,
				buttons = {
					onActivated = t3.confirmButtonPressed,
					text = v51.OkButtonText,
					onClose = t3.cancelButtonPressed
				}
			})
		end

		return React.createElement(UnifiedPurchaseCompletionModal, {
			title = v52.titleText,
			isError = t3.promptState ~= PromptState.PurchaseComplete,
			bodyText = v52.messageText,
			buttons = {
				onActivated = t3.confirmButtonPressed,
				text = v51.OkButtonText,
				onClose = t3.cancelButtonPressed
			}
		})
	end

	return React.createElement(InteractiveAlert, {
		screenSize = t3.screenSize,
		title = v52.titleText,
		titleIcon = t3.titleIcon,
		bodyText = v52.messageText,
		buttonStackInfo = {
			buttons = getButtonStackInfo(t3, v51)
		}
	})
end
local function ProductPurchasePromptContainer(t5: {[any]: any}) -- line: 344
	-- upvalues: React (copy), LocalizationProvider (copy), Localization2 (copy), LocalizationService (copy), ProductPurchasePrompt (copy)
	return React.createElement(LocalizationProvider, {
		localization = Localization2.new(LocalizationService.RobloxLocaleId)
	}, {
		ProductPurchasePrompt = React.createElement(ProductPurchasePrompt, t5)
	})
end

return ProductPurchasePromptContainer
