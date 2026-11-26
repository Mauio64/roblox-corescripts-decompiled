local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/React")
local useMemo = React.useMemo
local useEffect = React.useEffect

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/UIBlox")
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local LocalizationService = game:GetService("LocalizationService")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/Localization")
local localizationProvider = Localization.LocalizationProvider
local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/RobloxAppLocales").Localization
local useLocalization = Localization.Hooks.useLocalization

local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")

local IAPExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")
local formatEconomicRestrictionText = IAPExperience.Utility.formatEconomicRestrictionText
local addEconomicRestrictionKeysToLocalization = IAPExperience.Utility.addEconomicRestrictionKeysToLocalization

local formatTextWithParams = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/formatTextWithParams")
local economicRestrictionsCounter = IAPExperience.Counters.EconomicRestrictionsCounter
local universalEconomicRestrictionsCounter = economicRestrictionsCounter.UniversalEconomicRestrictionsCounter
local economicRestrictionsSurface = economicRestrictionsCounter.EconomicRestrictionsSurface
local productPurchasePromptCounter = IAPExperience.Counters.ProductPurchasePromptCounter.ProductPurchasePromptCounter
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/LoggingProtocol").default
local fFlagPurchaseModalTimedOptionExtension = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagPurchaseModalTimedOptionExtension
local unifiedPurchaseCompletionModal = IAPExperience.UnifiedPurchaseCompletionModal
local unifiedPurchaseCompletionModalV2 = IAPExperience.UnifiedPurchaseCompletionModalV2
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagFixPurchasingErrorCounter")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagAddSurfaceAndProductTypeToPromptCounter")
local logProductPurchasePromptCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/logProductPurchasePromptCounter")

local fFlagAddCenterDialogForUnifiedPurchaseModal = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagAddCenterDialogForUnifiedPurchaseModal
local AppContext = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/AppContext")

local fFlagAddCenterDialogForUnifiedPurchaseModal2 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagAddCenterDialogForUnifiedPurchaseModal

local fFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase

local fFlagLuaAppsEnablePromptVIPServerPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagLuaAppsEnablePromptVIPServerPurchase

local function getPurchaseErrorText(data, purchaseError)
	if purchaseError == PurchaseError.CannotGetBalance then
		return data.PurchaseErrorCannotGetBalanceText
	end

	if purchaseError == PurchaseError.CannotGetItemPrice then
		return data.PurchaseErrorCannotGetItemPriceText
	end

	if purchaseError == PurchaseError.NotForSale then
		return data.PurchaseErrorNotForSaleText
	end

	if purchaseError == PurchaseError.NotForSaleHere then
		return data.PurchaseErrorNotForSaleHereText
	end

	if purchaseError == PurchaseError.AlreadyOwn then
		return data.PurchaseErrorAlreadyOwnText
	end

	if purchaseError == PurchaseError.Under13 then
		return data.PurchaseErrorUnder13Text
	end

	if purchaseError == PurchaseError.Limited then
		return data.PurchaseErrorLimitedText
	end

	if purchaseError == PurchaseError.ThirdPartyDisabled then
		return data.PurchaseErrorThirdPartyDisabledText
	end

	if purchaseError == PurchaseError.NotEnoughRobux then
		return data.PurchaseErrorNotEnoughRobuxText
	end

	if purchaseError == PurchaseError.NotEnoughRobuxXbox then
		return data.PurchaseErrorNotEnoughRobuxXboxText
	end

	if purchaseError == PurchaseError.NotEnoughRobuxNoUpsell then
		return data.PurchaseErrorNotEnoughRobuxNoUpsellText
	end

	if purchaseError == PurchaseError.TwoFactorNeeded then
		return data.PurchaseErrorTwoFactorNeededText
	end

	if purchaseError == PurchaseError.TwoFactorNeededSettings then
		return data.PurchaseErrorTwoFactorNeededSettingsText
	end

	if purchaseError == PurchaseError.UnknownFailure then
		return data.PurchaseErrorUnknownFailureText
	end

	if purchaseError == PurchaseError.UnknownFailureNoItemName then
		return data.PurchaseErrorUnknownFailureNoItemNameText
	end

	if purchaseError == PurchaseError.PurchaseDisabled then
		return data.PurchaseErrorPurchaseDisabledText
	end

	if purchaseError == PurchaseError.InvalidFunds then
		return data.PurchaseErrorInvalidFundsText
	end

	if purchaseError == PurchaseError.InvalidFundsUnknown then
		return data.PurchaseErrorInvalidFundsUnknownText
	end

	if purchaseError == PurchaseError.PremiumOnly then
		return data.PurchaseErrorPremiumOnlyText
	end

	if fFlagLuaAppsEnablePromptVIPServerPurchase and purchaseError == PurchaseError.VIPServerUnavailable then
		return data.PurchaseErrorVIPServerUnavailableText
	end

	if fFlagLuaAppsEnablePromptVIPServerPurchase and purchaseError == PurchaseError.UnsupportedInStudio then
		return data.PurchaseErrorUnsupportedInStudioText
	end

	return data.PurchaseErrorUnknownFailureNoItemNameText
end

local function getModalContent(data, props)
	local promptState = props.promptState
	local purchaseError = props.purchaseError
	local isGenericChallengeResponse = props.isGenericChallengeResponse
	local productInfo = props.productInfo

	if promptState == PromptState.PurchaseComplete then
		if not props.useUnifiedPurchaseCompletionModal then
			return {
				messageText = formatTextWithParams(data.PurchaseCompleteSucceededText, {
					ITEM_NAME = props.productInfo.name
				}),
				titleText = data.BuyItemTitle
			}
		end

		if props.isMultiItem then
			return {
				messageText = data.MultiItemPurchaseCompleteBody,
				titleText = data.PurchaseCompleteTitle
			}
		end

		if fFlagPurchaseModalTimedOptionExtension and props.completionMessage then
			return {
				messageText = props.completionMessage,
				titleText = data.PurchaseCompleteTitle
			}
		end

		return {
			messageText = formatTextWithParams(data.PurchaseCompleteBody, {
				ITEM_NAME = props.productInfo.name
			}),
			titleText = data.PurchaseCompleteTitle
		}
	end

	if promptState == PromptState.U13PaymentModal then
		return { messageText = data.ScaryModalOneText, titleText = data.BuyItemTitle }
	end

	if promptState == PromptState.U13MonthlyThreshold1Modal then
		return { messageText = data.ScaryModalTwoText, titleText = data.BuyItemTitle }
	end

	if promptState == PromptState.U13MonthlyThreshold2Modal then
		return {
			messageText = data.ScaryModalParentalText,
			titleText = data.BuyItemTitle
		}
	end

	if promptState == PromptState.ParentalConsentWarningPaymentModal13To17 then
		return { messageText = data.ParentalConsentText, titleText = data.BuyItemTitle }
	end

	if promptState ~= PromptState.Error then
		return {
			messageText = data.PurchaseErrorUnknownFailureNoItemNameText,
			titleText = data.ErrorTitle
		}
	end

	if purchaseError == PurchaseError.UnknownFailure then
		return {
			messageText = formatTextWithParams(data.PurchaseErrorUnknownFailureText, {
				ITEM_NAME = productInfo.name
			}),
			titleText = data.ErrorTitle
		}
	end

	if purchaseError == PurchaseError.TwoFactorNeededSettings or isGenericChallengeResponse(purchaseError) then
		return { messageText = data.Enable2SVLogoutText, titleText = data.ErrorTitle }
	end

	if purchaseError == PurchaseError.EconomicRestriction then
		return {
			messageText = formatEconomicRestrictionText(
				data,
				{
					violationType = props.economicRestrictionError.violationType,
					timeoutMinutes = props.economicRestrictionError.timeoutMinutes
				},
				true
			),
			titleText = data.ErrorTitle
		}
	end

	if
		fFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase
		and purchaseError == PurchaseError.PendingProductsLimitExceeded
	then
		return {
			messageText = data.DevProductPendingProductsLimitExceededMessageText,
			titleText = data.DevProductPendingProductsLimitExceededTitleText
		}
	end

	return {
		messageText = getPurchaseErrorText(data, purchaseError),
		titleText = data.ErrorTitle
	}
end

local function getButtonStackInfo(props, p2)
	if props.includeCancelButton then
		return {
			{
				props = {
					onActivated = props.cancelButtonPressed,
					text = p2.CancelPurchaseText,
					inputIcon = props.isGamepadEnabled and "rbxasset://textures/ui/Controls/DesignSystem/ButtonB.png" or nil
				}
			},
			{
				buttonType = buttonType.PrimarySystem,
				props = {
					onActivated = props.confirmButtonPressed,
					text = p2.OkButtonText,
					inputIcon = props.isGamepadEnabled and "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png" or nil
				}
			}
		}
	end

	return {
		{
			buttonType = buttonType.PrimarySystem,
			props = {
				onActivated = props.confirmButtonPressed,
				text = p2.OkButtonText,
				inputIcon = props.isGamepadEnabled and "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png" or nil
			}
		}
	}
end

local function ProductPurchasePrompt(props)
	local v5 = {
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
		PurchaseErrorVIPServerUnavailableText = "Feature.PrivateServers.Description.VipServersNotSupported",
		PurchaseErrorUnsupportedInStudioText = "Feature.PrivateServers.Description.PrivateServerPurchaseUnavailableInStudio",
		DevProductPendingProductsLimitExceededTitleText = fFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase and "Purchasing.PurchaseDialog.Heading.PendingDeveloperProductLimitReached" or nil,
		DevProductPendingProductsLimitExceededMessageText = fFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase and "Purchasing.PurchaseDialog.Message.PendingDeveloperProductLimitReached" or nil,
		MultiItemPurchaseCompleteBody = "IAPExperience.PurchasePrompt.Body.PurchaseItemsSuccess"
	}

	addEconomicRestrictionKeysToLocalization(v5)

	local v6 = useLocalization(v5)

	local v7 = useMemo(function()
		return getModalContent(v6, props)
	end, { props })

	useEffect(function()
		logProductPurchasePromptCounter(props.promptState, props.purchaseError, props.surface, props.productType)

		if props.purchaseError == PurchaseError.EconomicRestriction then
			default:logRobloxTelemetryCounter(universalEconomicRestrictionsCounter, 1, {
				surface = economicRestrictionsSurface.InExperience,
				failureReason = tostring(props.economicRestrictionError.violationType)
			})
		end
	end, { props.purchaseError })

	if not props.useUnifiedPurchaseCompletionModal then
		return React.createElement(interactiveAlert, {
			screenSize = props.screenSize,
			title = v7.titleText,
			titleIcon = props.titleIcon,
			bodyText = v7.messageText,
			buttonStackInfo = { buttons = getButtonStackInfo(props, v6) }
		})
	end

	local v8 = props.launchAfterPurchaseButtonPressed
	local v9 = not (v8 == nil) and props.promptState == PromptState.PurchaseComplete
	local v10 = { text = v6.OkButtonText, onActivated = 0, onClose = 0, onShown = 0 }

	if v8 == nil or props.promptState ~= PromptState.PurchaseComplete then
		v8 = props.confirmButtonPressed
	end

	v10.onActivated = v8

	v10.onClose = props.cancelButtonPressed
	local v11 = if v9 then props.launchAfterPurchaseButtonShown else nil
	v10.onShown = v11

	if fFlagAddCenterDialogForUnifiedPurchaseModal2 and AppContext.get() == AppContext.Enum.IN_APP then
		return React.createElement(unifiedPurchaseCompletionModalV2, {
			title = v7.titleText,
			isError = props.promptState ~= PromptState.PurchaseComplete,
			bodyText = v7.messageText,
			buttons = v10,
			enableLaunchAfterPurchase = v9
		})
	end

	return React.createElement(unifiedPurchaseCompletionModal, {
		title = v7.titleText,
		isError = props.promptState ~= PromptState.PurchaseComplete,
		bodyText = v7.messageText,
		buttons = v10,
		enableLaunchAfterPurchase = v9
	})
end

local function ProductPurchasePromptContainer(p2)
	return React.createElement(
		localizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			ProductPurchasePrompt = React.createElement(ProductPurchasePrompt, p2)
		}
	)
end

return ProductPurchasePromptContainer
