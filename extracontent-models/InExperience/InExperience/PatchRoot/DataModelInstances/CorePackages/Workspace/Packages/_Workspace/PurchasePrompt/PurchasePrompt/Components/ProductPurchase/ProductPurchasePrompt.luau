local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local React = require(parent.React)
local useMemo = React.useMemo
local useEffect = React.useEffect

local UIBlox = require(parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local LocalizationService = game:GetService("LocalizationService")
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local RobloxAppLocales = require(parent.RobloxAppLocales)
local localization = RobloxAppLocales.Localization
local useLocalization = Localization.Hooks.useLocalization

local PromptState = require(PurchasePrompt.Enums.PromptState)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)

local IAPExperience = require(parent.IAPExperience)
local formatEconomicRestrictionText = IAPExperience.Utility.formatEconomicRestrictionText
local addEconomicRestrictionKeysToLocalization = IAPExperience.Utility.addEconomicRestrictionKeysToLocalization

local formatTextWithParams = require(PurchasePrompt.Utils.formatTextWithParams)
local EconomicRestrictionsCounter = IAPExperience.Counters.EconomicRestrictionsCounter
local UniversalEconomicRestrictionsCounter = EconomicRestrictionsCounter.UniversalEconomicRestrictionsCounter
local EconomicRestrictionsSurface = EconomicRestrictionsCounter.EconomicRestrictionsSurface
local ProductPurchasePromptCounter = IAPExperience.Counters.ProductPurchasePromptCounter.ProductPurchasePromptCounter
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default
local SharedFlags = require(parent.SharedFlags)
local FFlagPurchaseModalTimedOptionExtension = SharedFlags.FFlagPurchaseModalTimedOptionExtension
local UnifiedPurchaseCompletionModal = IAPExperience.UnifiedPurchaseCompletionModal
local UnifiedPurchaseCompletionModalV2 = IAPExperience.UnifiedPurchaseCompletionModalV2
require(PurchasePrompt.Flags.FFlagFixPurchasingErrorCounter)
require(PurchasePrompt.Flags.FFlagAddSurfaceAndProductTypeToPromptCounter)
local logProductPurchasePromptCounter = require(PurchasePrompt.Utils.logProductPurchasePromptCounter)

local v = require(parent.SharedFlags)
v = v.FFlagAddCenterDialogForUnifiedPurchaseModal
local AppContext = require(PurchasePrompt.Utils.AppContext)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagAddCenterDialogForUnifiedPurchaseModal = SharedFlags2.FFlagAddCenterDialogForUnifiedPurchaseModal

local SharedFlags3 = require(parent.SharedFlags)
local FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase = SharedFlags3.FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase

local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags4.FFlagLuaAppsEnablePromptVIPServerPurchase

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

	if FFlagLuaAppsEnablePromptVIPServerPurchase and purchaseError == PurchaseError.VIPServerUnavailable then
		return data.PurchaseErrorVIPServerUnavailableText
	end

	if FFlagLuaAppsEnablePromptVIPServerPurchase and purchaseError == PurchaseError.UnsupportedInStudio then
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

		if FFlagPurchaseModalTimedOptionExtension and props.completionMessage then
			return { messageText = props.completionMessage, titleText = data.PurchaseCompleteTitle }
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
		return { messageText = data.ScaryModalParentalText, titleText = data.BuyItemTitle }
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
		FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase
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

local function getButtonStackInfo(props, p)
	if props.includeCancelButton then
		return {
			{
				props = {
					onActivated = props.cancelButtonPressed,
					text = p.CancelPurchaseText,
					inputIcon = props.isGamepadEnabled and "rbxasset://textures/ui/Controls/DesignSystem/ButtonB.png" or nil
				}
			},
			{
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = props.confirmButtonPressed,
					text = p.OkButtonText,
					inputIcon = props.isGamepadEnabled and "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png" or nil
				}
			}
		}
	end

	return {
		{
			buttonType = ButtonType.PrimarySystem,
			props = {
				onActivated = props.confirmButtonPressed,
				text = p.OkButtonText,
				inputIcon = props.isGamepadEnabled and "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png" or nil
			}
		}
	}
end

local function ProductPurchasePrompt(props)
	local v2 = {
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
		DevProductPendingProductsLimitExceededTitleText = FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase and "Purchasing.PurchaseDialog.Heading.PendingDeveloperProductLimitReached" or nil,
		DevProductPendingProductsLimitExceededMessageText = FFlagEnableDevProductPendingProductsLimitExceededInUnifiedPurchase and "Purchasing.PurchaseDialog.Message.PendingDeveloperProductLimitReached" or nil,
		MultiItemPurchaseCompleteBody = "IAPExperience.PurchasePrompt.Body.PurchaseItemsSuccess"
	}

	addEconomicRestrictionKeysToLocalization(v2)

	local v3 = useLocalization(v2)

	local v4 = useMemo(function()
		return getModalContent(v3, props)
	end, { props })

	useEffect(function()
		logProductPurchasePromptCounter(props.promptState, props.purchaseError, props.surface, props.productType)

		if props.purchaseError == PurchaseError.EconomicRestriction then
			default:logRobloxTelemetryCounter(UniversalEconomicRestrictionsCounter, 1, {
				surface = EconomicRestrictionsSurface.InExperience,
				failureReason = tostring(props.economicRestrictionError.violationType)
			})
		end
	end, { props.purchaseError })

	if not props.useUnifiedPurchaseCompletionModal then
		return React.createElement(InteractiveAlert, {
			screenSize = props.screenSize,
			title = v4.titleText,
			titleIcon = props.titleIcon,
			bodyText = v4.messageText,
			buttonStackInfo = { buttons = getButtonStackInfo(props, v3) }
		})
	end

	local onActivated = props.launchAfterPurchaseButtonPressed
	local enableLaunchAfterPurchase

	if onActivated == nil then
		enableLaunchAfterPurchase = false
	else
		enableLaunchAfterPurchase = props.promptState == PromptState.PurchaseComplete
	end

	local buttons = { text = v3.OkButtonText, onActivated = 0, onClose = 0, onShown = 0 }

	if onActivated == nil or props.promptState ~= PromptState.PurchaseComplete then
		onActivated = props.confirmButtonPressed
	end

	buttons.onActivated = onActivated

	buttons.onClose = props.cancelButtonPressed
	local onShown

	if enableLaunchAfterPurchase then
		onShown = props.launchAfterPurchaseButtonShown
	end

	buttons.onShown = onShown

	if FFlagAddCenterDialogForUnifiedPurchaseModal and AppContext.get() == AppContext.Enum.IN_APP then
		return React.createElement(UnifiedPurchaseCompletionModalV2, {
			title = v4.titleText,
			isError = props.promptState ~= PromptState.PurchaseComplete,
			bodyText = v4.messageText,
			buttons = buttons,
			enableLaunchAfterPurchase = enableLaunchAfterPurchase
		})
	end

	return React.createElement(UnifiedPurchaseCompletionModal, {
		title = v4.titleText,
		isError = props.promptState ~= PromptState.PurchaseComplete,
		bodyText = v4.messageText,
		buttons = buttons,
		enableLaunchAfterPurchase = enableLaunchAfterPurchase
	})
end

local function ProductPurchasePromptContainer(p)
	return React.createElement(
		LocalizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			ProductPurchasePrompt = React.createElement(ProductPurchasePrompt, p)
		}
	)
end

return ProductPurchasePromptContainer
