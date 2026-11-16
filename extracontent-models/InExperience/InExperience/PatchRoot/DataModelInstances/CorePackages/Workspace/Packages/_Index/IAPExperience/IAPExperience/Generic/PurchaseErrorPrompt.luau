local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local UIBlox = require(parent3.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images

local LocalizationService = game:GetService("LocalizationService")
local AppLocales = require(parent3.AppLocales)
local Localization = AppLocales.Localization
local Localization2 = require(parent3.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local Localization3 = require(parent3.Localization)
local withLocalization = Localization3.withLocalization
local PurchaseErrorType = require(parent2.Enums.PurchaseErrorType)
local EconomicRestrictionsViolationType = require(parent2.Enums.EconomicRestrictionsViolationType)

local PurchaseFlowType = require(parent.PurchaseFlowType)
local LoggingProtocol = require(parent3.LoggingProtocol)
local default = LoggingProtocol.default
local logger = require(parent2.Utility.logger)
local getAppContext = require(parent2.Utility.getAppContext)
local extended = Roact.Component:extend(script.Name)
local PurchaseErrorPromptCounter = require(parent2.Generic.Events.PurchaseErrorPromptCounter)
local PurchaseErrorPromptShownCounter = PurchaseErrorPromptCounter.PurchaseErrorPromptShownCounter
local EconomicRestrictionsPromptShownCounter = PurchaseErrorPromptCounter.EconomicRestrictionsPromptShownCounter

extended.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function extended:getErrorTitle(data, p, p2)
	if p == PurchaseErrorType.FailedRobuxPurchase then
		return data.robuxFailedPurchaseTitle
	end

	if p == PurchaseErrorType.AlreadySubscribed then
		return data.alreadySubscribedTitle
	end

	if p2 == PurchaseFlowType.Subscription then
		return data.cantSubscribeTitle
	end

	return data.titleText
end

function extended:getErrorMessage(data, p, p2)
	if p == PurchaseErrorType.AlreadyOwn then
		return data.alreadyOwnText
	end

	if p == PurchaseErrorType.FailedGrant then
		return data.failedGrantText
	end

	if p == PurchaseErrorType.FailedGrantUnknown then
		return data.failedGrantUnknownText
	end

	if p == PurchaseErrorType.Limited then
		return data.limitedText
	end

	if p == PurchaseErrorType.NotEnoughRobux then
		return data.notEnoughRobuxText
	end

	if p == PurchaseErrorType.NotForSale then
		return data.notForSaleText
	end

	if p == PurchaseErrorType.NotForSaleExperience then
		return data.notForSaleExperienceText
	end

	if p == PurchaseErrorType.PremiumOnly then
		return data.premiumOnlyText
	end

	if p == PurchaseErrorType.ThirdPartyDisabled then
		return data.thirdPartyDisabledText
	end

	if p == PurchaseErrorType.Under13 then
		return data.under13Text
	end

	if p == PurchaseErrorType.PremiumPlatformUnavailable then
		return data.premiumPlatformUnavailable
	end

	if p == PurchaseErrorType.AlreadyPremium then
		return data.alreadyPremium
	end

	if p == PurchaseErrorType.PurchaseLimit then
		return data.purchaseLimitText
	end

	if p == PurchaseErrorType.ParentalLimit then
		return data.parentalLimitText
	end

	if p == PurchaseErrorType.FailedRobuxPurchase then
		return data.robuxFailedPurchaseText
	end

	if p == PurchaseErrorType.AlreadySubscribed then
		return data.alreadySubscribedText
	end

	if p == PurchaseErrorType.SubscriptionNotForSale then
		return data.subscriptionNotForSaleText
	end

	if p == PurchaseErrorType.SubscriptionExceededUserSpendLimit then
		return data.parentalRestrictionSubscriptionText
	end

	if p == PurchaseErrorType.SubscriptionUnsupportedLocale then
		return data.subscriptionUnsupportedLocaleText
	end

	if p == PurchaseErrorType.RestrictedUser then
		return data.restrictedUserText
	end

	if
		p == PurchaseErrorType.SubscriptionPurchasePlatformNotSupported
		or p == PurchaseErrorType.SubscriptionInvalidSaleLocation
	then
		return data.subscriptionUnsupportedPlatformText
	end

	if p == PurchaseErrorType.VpcRequired then
		return data.vpcRequiredText
	end

	if p == PurchaseErrorType.ExceedParentalSpendLimit then
		return data.exceedParentalSpendLimitText
	end

	if p == PurchaseErrorType.EconomicRestriction then
		return formatEconomicRestrictionText(data, p2)
	end

	return data.unknownText
end

function formatEconomicRestrictionText(data, p)
	local timeoutMinutes = p.timeoutMinutes
	local violationType = p.violationType
	default:logRobloxTelemetryCounter(EconomicRestrictionsPromptShownCounter, 1, {
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

	local economicRestrictionViolationLabel = getEconomicRestrictionViolationLabel(data, violationType)
	local v = math.ceil(timeoutMinutes / 60)

	if v >= 24 then
		local v2 = math.ceil(v / 24)
		return data.economicRestrictionBaseTextDays:gsub("{day}", (tostring(v2))):gsub(
			"{violation}",
			economicRestrictionViolationLabel
		)
	end

	return data.economicRestrictionBaseTextHours:gsub("{hour}", (tostring(v))):gsub(
		"{violation}",
		economicRestrictionViolationLabel
	)
end

function getEconomicRestrictionViolationLabel(data, violationType)
	if violationType == EconomicRestrictionsViolationType.Chargeback then
		return data.chargebackViolationLabel
	end

	if violationType == EconomicRestrictionsViolationType.AbuseOfAffiliateSystem then
		return data.fraudAbuseOfAffiliateSystemViolationLabel
	end

	if violationType == EconomicRestrictionsViolationType.AttemptedUnauthorizedPaymentMethodUse then
		return data.fraudAttemptedUnauthorizedPaymentMethodUseViolationLabel
	end

	if violationType == EconomicRestrictionsViolationType.PaymentAuthorizationAttempt then
		return data.fraudPaymentAbuseViolationLabel
	end

	if violationType == EconomicRestrictionsViolationType.RepeatedRefundRequests then
		return data.fraudRepeatedRefundRequestsViolationLabel
	end

	if violationType == EconomicRestrictionsViolationType.SuspiciousAccountPatterns then
		return data.fraudSuspiciousAccountPatternsViolationLabel
	end

	if violationType == EconomicRestrictionsViolationType.SuspiciousRefundRequests then
		return data.fraudSuspiciousRefundRequestsViolationLabel
	end

	if violationType == EconomicRestrictionsViolationType.UnauthorizedPurchase then
		return data.fraudUnauthorizedPurchaseViolationLabel
	end

	if violationType == EconomicRestrictionsViolationType.UseOfUnauthorizedOffPlatformTransactions then
		return data.fraudUseOfUnauthorizedOffPlatformTransactionsViolationLabel
	end

	if violationType == EconomicRestrictionsViolationType.VirtualEconomyAbuse then
		return data.fraudVirtualEconomyAbuseViolationLabel
	end

	logger.error({ message = "Invalid violation type", violationType = violationType })

	return ""
end

function getIsAlreadyOwnedError(p): boolean
	return p == PurchaseErrorType.AlreadyOwn
		or p == PurchaseErrorType.AlreadyPremium
		or p == PurchaseErrorType.AlreadySubscribed
end

function getErrorTitleIcon(p)
	if getIsAlreadyOwnedError(p) then
		return Images["icons/status/success_large"]
	end

	return Images["icons/status/error_large"]
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
	})(function(p)
		return self:renderAlert(p)
	end)
end

function extended:render()
	return Roact.createElement(
		LocalizationProvider,
		{
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			Alert = self:renderNewAlertWithLocalization()
		}
	)
end

function extended:renderAlert(p)
	local props = self.props
	local errorLabel = props.errorType and PurchaseErrorType.toRawValue(props.errorType) or tostring(props.errorType)
	logger.debug({
		message = "Purchase Error Prompt Shown",
		errorType = tostring(props.errorType),
		errorLabel = errorLabel,
		flowType = tostring(props.flowType),
		screenHeight = props.screenSize.Y,
		screenWidth = props.screenSize.X,
		portrait = props.screenSize.X < props.screenSize.Y,
		appContext = getAppContext()
	})

	default:logRobloxTelemetryCounter(PurchaseErrorPromptShownCounter, 1, {
		errorType = tostring(props.errorType),
		errorLabel = errorLabel,
		flowType = tostring(props.flowType),
		screenHeight = props.screenSize.Y,
		screenWidth = props.screenSize.X,
		portrait = props.screenSize.X < props.screenSize.Y,
		appContext = getAppContext()
	})

	return Roact.createElement(InteractiveAlert, {
		anchorPoint = props.anchorPoint,
		position = props.position,
		screenSize = props.screenSize,
		title = self:getErrorTitle(p, props.errorType, props.flowType),
		titleIcon = getErrorTitleIcon(props.errorType),
		bodyText = self:getErrorMessage(p, props.errorType, props.economicRestrictionError),
		buttonStackInfo = {
			buttons = {
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = props.doneActivated,
						text = p.okText,
						inputIcon = props.doneControllerIcon
					}
				}
			}
		}
	})
end

return extended
