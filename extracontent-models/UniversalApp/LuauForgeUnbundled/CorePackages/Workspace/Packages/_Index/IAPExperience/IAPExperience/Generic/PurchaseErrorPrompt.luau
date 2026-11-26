local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local images = UIBlox.App.ImageSet.Images

local LocalizationService = game:GetService("LocalizationService")
local localization = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/AppLocales").Localization
local localizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization").LocalizationProvider
local withLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization").withLocalization
local PurchaseErrorType = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/PurchaseErrorType")
local EconomicRestrictionsViolationType = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/EconomicRestrictionsViolationType")

local PurchaseFlowType = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/PurchaseFlowType")
local default = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol").default
local logger = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/logger")
local getAppContext = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/getAppContext")
local extended = Roact.Component:extend("PurchaseErrorPrompt")
local PurchaseErrorPromptCounter = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Events/PurchaseErrorPromptCounter")
local purchaseErrorPromptShownCounter = PurchaseErrorPromptCounter.PurchaseErrorPromptShownCounter
local economicRestrictionsPromptShownCounter = PurchaseErrorPromptCounter.EconomicRestrictionsPromptShownCounter

extended.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function extended:getErrorTitle(data, p3, p4)
	if p3 == PurchaseErrorType.FailedRobuxPurchase then
		return data.robuxFailedPurchaseTitle
	end

	if p3 == PurchaseErrorType.AlreadySubscribed then
		return data.alreadySubscribedTitle
	end

	if p4 == PurchaseFlowType.Subscription then
		return data.cantSubscribeTitle
	end

	return data.titleText
end

function extended:getErrorMessage(data, p3, p4)
	if p3 == PurchaseErrorType.AlreadyOwn then
		return data.alreadyOwnText
	end

	if p3 == PurchaseErrorType.FailedGrant then
		return data.failedGrantText
	end

	if p3 == PurchaseErrorType.FailedGrantUnknown then
		return data.failedGrantUnknownText
	end

	if p3 == PurchaseErrorType.Limited then
		return data.limitedText
	end

	if p3 == PurchaseErrorType.NotEnoughRobux then
		return data.notEnoughRobuxText
	end

	if p3 == PurchaseErrorType.NotForSale then
		return data.notForSaleText
	end

	if p3 == PurchaseErrorType.NotForSaleExperience then
		return data.notForSaleExperienceText
	end

	if p3 == PurchaseErrorType.PremiumOnly then
		return data.premiumOnlyText
	end

	if p3 == PurchaseErrorType.ThirdPartyDisabled then
		return data.thirdPartyDisabledText
	end

	if p3 == PurchaseErrorType.Under13 then
		return data.under13Text
	end

	if p3 == PurchaseErrorType.PremiumPlatformUnavailable then
		return data.premiumPlatformUnavailable
	end

	if p3 == PurchaseErrorType.AlreadyPremium then
		return data.alreadyPremium
	end

	if p3 == PurchaseErrorType.PurchaseLimit then
		return data.purchaseLimitText
	end

	if p3 == PurchaseErrorType.ParentalLimit then
		return data.parentalLimitText
	end

	if p3 == PurchaseErrorType.FailedRobuxPurchase then
		return data.robuxFailedPurchaseText
	end

	if p3 == PurchaseErrorType.AlreadySubscribed then
		return data.alreadySubscribedText
	end

	if p3 == PurchaseErrorType.SubscriptionNotForSale then
		return data.subscriptionNotForSaleText
	end

	if p3 == PurchaseErrorType.SubscriptionExceededUserSpendLimit then
		return data.parentalRestrictionSubscriptionText
	end

	if p3 == PurchaseErrorType.SubscriptionUnsupportedLocale then
		return data.subscriptionUnsupportedLocaleText
	end

	if p3 == PurchaseErrorType.RestrictedUser then
		return data.restrictedUserText
	end

	if
		p3 == PurchaseErrorType.SubscriptionPurchasePlatformNotSupported
		or p3 == PurchaseErrorType.SubscriptionInvalidSaleLocation
	then
		return data.subscriptionUnsupportedPlatformText
	end

	if p3 == PurchaseErrorType.VpcRequired then
		return data.vpcRequiredText
	end

	if p3 == PurchaseErrorType.ExceedParentalSpendLimit then
		return data.exceedParentalSpendLimitText
	end

	if p3 == PurchaseErrorType.EconomicRestriction then
		return LUAUFORGE_MODULE_GLOBALS_bbx_formatEconomicRestrictionText(data, p4)
	end

	return data.unknownText
end

function LUAUFORGE_MODULE_GLOBALS_bbx_formatEconomicRestrictionText(data, p2)
	local timeoutMinutes = p2.timeoutMinutes
	local violationType = p2.violationType
	default:logRobloxTelemetryCounter(economicRestrictionsPromptShownCounter, 1, {
		violationType = tostring(violationType),
		appContext = getAppContext()
	})

	if not (timeoutMinutes and violationType) then
		logger.error({
			error = "Timeout and violationType is required for economic restriction text. Showing unknown error.",
			timeoutMinutes = timeoutMinutes,
			violationType = violationType
		})

		return data.unknownText
	end

	local v5 = LUAUFORGE_MODULE_GLOBALS_bbx_getEconomicRestrictionViolationLabel(data, violationType)
	local v6 = math.ceil(timeoutMinutes / 60)

	if v6 >= 24 then
		local v7 = math.ceil(v6 / 24)
		return data.economicRestrictionBaseTextDays:gsub("{day}", (tostring(v7))):gsub("{violation}", v5)
	end

	return data.economicRestrictionBaseTextHours:gsub("{hour}", (tostring(v6))):gsub("{violation}", v5)
end

function LUAUFORGE_MODULE_GLOBALS_bbx_getEconomicRestrictionViolationLabel(data, p2)
	if p2 == EconomicRestrictionsViolationType.Chargeback then
		return data.chargebackViolationLabel
	end

	if p2 == EconomicRestrictionsViolationType.AbuseOfAffiliateSystem then
		return data.fraudAbuseOfAffiliateSystemViolationLabel
	end

	if p2 == EconomicRestrictionsViolationType.AttemptedUnauthorizedPaymentMethodUse then
		return data.fraudAttemptedUnauthorizedPaymentMethodUseViolationLabel
	end

	if p2 == EconomicRestrictionsViolationType.PaymentAuthorizationAttempt then
		return data.fraudPaymentAbuseViolationLabel
	end

	if p2 == EconomicRestrictionsViolationType.RepeatedRefundRequests then
		return data.fraudRepeatedRefundRequestsViolationLabel
	end

	if p2 == EconomicRestrictionsViolationType.SuspiciousAccountPatterns then
		return data.fraudSuspiciousAccountPatternsViolationLabel
	end

	if p2 == EconomicRestrictionsViolationType.SuspiciousRefundRequests then
		return data.fraudSuspiciousRefundRequestsViolationLabel
	end

	if p2 == EconomicRestrictionsViolationType.UnauthorizedPurchase then
		return data.fraudUnauthorizedPurchaseViolationLabel
	end

	if p2 == EconomicRestrictionsViolationType.UseOfUnauthorizedOffPlatformTransactions then
		return data.fraudUseOfUnauthorizedOffPlatformTransactionsViolationLabel
	end

	if p2 == EconomicRestrictionsViolationType.VirtualEconomyAbuse then
		return data.fraudVirtualEconomyAbuseViolationLabel
	end

	logger.error({ message = "Invalid violation type", violationType = p2 })

	return ""
end

function LUAUFORGE_MODULE_GLOBALS_bbx_getIsAlreadyOwnedError(p2): boolean
	return p2 == PurchaseErrorType.AlreadyOwn or p2 == PurchaseErrorType.AlreadyPremium or p2 == PurchaseErrorType.AlreadySubscribed
end

function LUAUFORGE_MODULE_GLOBALS_bbx_getErrorTitleIcon(p2)
	if LUAUFORGE_MODULE_GLOBALS_bbx_getIsAlreadyOwnedError(p2) then
		return images["icons/status/success_large"]
	end

	return images["icons/status/error_large"]
end

function extended:renderNewAlertWithLocalization()
	return withLocalization({
		titleText = "IAPExperience.PurchaseError.Title.Error",
		robuxFailedPurchaseTitle = "IAPExperience.PurchaseError.Title.RobuxPurchaseFailed",
		robuxFailedPurchaseText = "IAPExperience.PurchaseError.Text.FailedRobuxPurchase",
		unknownText = "IAPExperience.PurchaseError.Text.UnknownError",
		okText = "IAPExperience.PurchaseError.Text.Ok",
		alreadyOwnText = "IAPExperience.PurchaseError.Text.AlreadyOwn",
		failedGrantText = "IAPExperience.PurchaseError.Text.FailedGrant",
		failedGrantUnknownText = "IAPExperience.PurchaseError.Text.FailedGrantUnknown",
		limitedText = "IAPExperience.PurchaseError.Text.Limited",
		notEnoughRobuxText = "IAPExperience.PurchaseError.Text.NotEnoughRobux",
		notForSaleText = "IAPExperience.PurchaseError.Text.NotForSale",
		notForSaleExperienceText = "IAPExperience.PurchaseError.Text.NotForSaleExperience",
		premiumOnlyText = "IAPExperience.PurchaseError.Text.PremiumOnly",
		thirdPartyDisabledText = "IAPExperience.PurchaseError.Text.ThirdPartyDisabled",
		under13Text = "IAPExperience.PurchaseError.Text.Under13",
		premiumPlatformUnavailable = "IAPExperience.PurchaseError.Text.PremiumPlatformUnavailable",
		alreadyPremium = "IAPExperience.PurchaseError.AlreadyPremium",
		purchaseLimitText = "IAPExperience.PurchaseError.Text.PurchaseLimit",
		parentalLimitText = "IAPExperience.PurchaseError.Text.ParentalLimit",
		alreadySubscribedTitle = "IAPExperience.PurchaseError.Title.AlreadySubscribed",
		cantSubscribeTitle = "IAPExperience.PurchaseError.Title.CantSubscribe",
		alreadySubscribedText = "IAPExperience.PurchaseError.Text.AlreadySubscribed",
		subscriptionNotForSaleText = "IAPExperience.PurchaseError.Text.SubscriptionNotForSale",
		parentalRestrictionSubscriptionText = "IAPExperience.PurchaseError.Text.ParentalRestrictionSubscription",
		subscriptionUnsupportedLocaleText = "IAPExperience.PurchaseError.Text.SubscriptionUnsupportedLocale",
		restrictedUserText = "IAPExperience.PurchaseError.Text.RestrictedUser",
		subscriptionUnsupportedPlatformText = "IAPExperience.PurchaseError.Text.SubscriptionUnsupportedPlatform",
		vpcRequiredText = "IAPExperience.PurchaseError.Text.VpcRequired",
		exceedParentalSpendLimitText = "Feature.Subscription.Message.MonthlySpendRestrictionsMonthlyLimitExceed",
		chargebackViolationLabel = "Feature.NotApproved.Label.AbuseType.Chargeback",
		fraudAbuseOfAffiliateSystemViolationLabel = "Feature.NotApproved.Label.Sublabel.FraudAbuseOfTheAffiliateSystem",
		fraudAttemptedUnauthorizedPaymentMethodUseViolationLabel = "Feature.NotApproved.Label.Sublabel.FraudAttemptedUnauthorizedPaymentMethodUse",
		fraudPaymentAbuseViolationLabel = "Feature.NotApproved.Label.Sublabel.FraudPaymentAbuse",
		fraudRepeatedRefundRequestsViolationLabel = "Feature.NotApproved.Label.Sublabel.FraudRepeatedRefundRequests",
		fraudSuspiciousAccountPatternsViolationLabel = "Feature.NotApproved.Label.Sublabel.FraudSuspiciousAccountPatterns",
		fraudSuspiciousRefundRequestsViolationLabel = "Feature.NotApproved.Label.Sublabel.FraudSuspiciousRefundRequests",
		fraudUnauthorizedPurchaseViolationLabel = "Feature.NotApproved.Label.Sublabel.FraudUnauthorizedPurchase",
		fraudUseOfUnauthorizedOffPlatformTransactionsViolationLabel = "Feature.NotApproved.Label.Sublabel.FraudUseOfUnauthorizedOffPlatformTransactions",
		fraudVirtualEconomyAbuseViolationLabel = "Feature.NotApproved.Label.Sublabel.FraudVirtualEconomyAbuse",
		economicRestrictionBaseTextHours = "IAPExperience.PurchaseError.Text.EconomicRestrictionsHours",
		economicRestrictionBaseTextDays = "IAPExperience.PurchaseError.Text.EconomicRestrictionsDays"
	})(function(p2)
		return self:renderAlert(p2)
	end)
end

function extended:render()
	return Roact.createElement(
		localizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			Alert = self:renderNewAlertWithLocalization()
		}
	)
end

function extended:renderAlert(p2)
	local props = self.props
	local v5 = props.errorType and PurchaseErrorType.toRawValue(props.errorType) or tostring(props.errorType)
	logger.debug({
		message = "Purchase Error Prompt Shown",
		errorType = tostring(props.errorType),
		errorLabel = v5,
		flowType = tostring(props.flowType),
		screenHeight = props.screenSize.Y,
		screenWidth = props.screenSize.X,
		portrait = props.screenSize.X < props.screenSize.Y,
		appContext = getAppContext()
	})

	default:logRobloxTelemetryCounter(purchaseErrorPromptShownCounter, 1, {
		errorType = tostring(props.errorType),
		errorLabel = v5,
		flowType = tostring(props.flowType),
		screenHeight = props.screenSize.Y,
		screenWidth = props.screenSize.X,
		portrait = props.screenSize.X < props.screenSize.Y,
		appContext = getAppContext()
	})

	return Roact.createElement(interactiveAlert, {
		anchorPoint = props.anchorPoint,
		position = props.position,
		screenSize = props.screenSize,
		title = self:getErrorTitle(p2, props.errorType, props.flowType),
		titleIcon = LUAUFORGE_MODULE_GLOBALS_bbx_getErrorTitleIcon(props.errorType),
		bodyText = self:getErrorMessage(p2, props.errorType, props.economicRestrictionError),
		buttonStackInfo = {
			buttons = {
				{
					buttonType = buttonType.PrimarySystem,
					props = {
						onActivated = props.doneActivated,
						text = p2.okText,
						inputIcon = props.doneControllerIcon
					}
				}
			}
		}
	})
end

return extended
