local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local Roact = require(scriptParentParentParent.Roact)
local UIBlox = require(scriptParentParentParent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(scriptParentParentParent.AppLocales).Localization
local LocalizationProvider = require(scriptParentParentParent.Localization).LocalizationProvider
local withLocalization = require(scriptParentParentParent.Localization).withLocalization
local PurchaseErrorType = require(scriptParentParent.Enums.PurchaseErrorType)
local EconomicRestrictionsViolationType = require(scriptParentParent.Enums.EconomicRestrictionsViolationType)
local PurchaseFlowType = require(scriptParent.PurchaseFlowType)
local default = require(scriptParentParentParent.LoggingProtocol).default
local logger = require(scriptParentParent.Utility.logger)
local getAppContext = require(scriptParentParent.Utility.getAppContext)
local v19 = Roact.Component:extend(script.Name)
local PurchaseErrorPromptCounter = require(scriptParentParent.Generic.Events.PurchaseErrorPromptCounter)
local PurchaseErrorPromptShownCounter = PurchaseErrorPromptCounter.PurchaseErrorPromptShownCounter
local EconomicRestrictionsPromptShownCounter = PurchaseErrorPromptCounter.EconomicRestrictionsPromptShownCounter

v19.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function v19.getErrorTitle(_: {[any]: any}, t2: {[any]: any}, p1, p2) -- line: 49
	-- upvalues: PurchaseErrorType (copy), PurchaseFlowType (copy)
	if p1 == PurchaseErrorType.FailedRobuxPurchase then
		return t2.robuxFailedPurchaseTitle
	end

	if p1 == PurchaseErrorType.AlreadySubscribed then
		return t2.alreadySubscribedTitle
	end

	if p2 == PurchaseFlowType.Subscription then
		return t2.cantSubscribeTitle
	end

	return t2.titleText
end
function v19.getErrorMessage(_: {[any]: any}, t4: {[any]: any}, p3, t5: {[any]: any}) -- line: 61
	-- upvalues: PurchaseErrorType (copy)
	if p3 == PurchaseErrorType.AlreadyOwn then
		return t4.alreadyOwnText
	end

	if p3 == PurchaseErrorType.FailedGrant then
		return t4.failedGrantText
	end

	if p3 == PurchaseErrorType.FailedGrantUnknown then
		return t4.failedGrantUnknownText
	end

	if p3 == PurchaseErrorType.Limited then
		return t4.limitedText
	end

	if p3 == PurchaseErrorType.NotEnoughRobux then
		return t4.notEnoughRobuxText
	end

	if p3 == PurchaseErrorType.NotForSale then
		return t4.notForSaleText
	end

	if p3 == PurchaseErrorType.NotForSaleExperience then
		return t4.notForSaleExperienceText
	end

	if p3 == PurchaseErrorType.PremiumOnly then
		return t4.premiumOnlyText
	end

	if p3 == PurchaseErrorType.ThirdPartyDisabled then
		return t4.thirdPartyDisabledText
	end

	if p3 == PurchaseErrorType.Under13 then
		return t4.under13Text
	end

	if p3 == PurchaseErrorType.PremiumPlatformUnavailable then
		return t4.premiumPlatformUnavailable
	end

	if p3 == PurchaseErrorType.AlreadyPremium then
		return t4.alreadyPremium
	end

	if p3 == PurchaseErrorType.PurchaseLimit then
		return t4.purchaseLimitText
	end

	if p3 == PurchaseErrorType.ParentalLimit then
		return t4.parentalLimitText
	end

	if p3 == PurchaseErrorType.FailedRobuxPurchase then
		return t4.robuxFailedPurchaseText
	end

	if p3 == PurchaseErrorType.AlreadySubscribed then
		return t4.alreadySubscribedText
	end

	if p3 == PurchaseErrorType.SubscriptionNotForSale then
		return t4.subscriptionNotForSaleText
	end

	if p3 == PurchaseErrorType.SubscriptionExceededUserSpendLimit then
		return t4.parentalRestrictionSubscriptionText
	end

	if p3 == PurchaseErrorType.SubscriptionUnsupportedLocale then
		return t4.subscriptionUnsupportedLocaleText
	end

	if p3 == PurchaseErrorType.RestrictedUser then
		return t4.restrictedUserText
	end

	if p3 == PurchaseErrorType.SubscriptionPurchasePlatformNotSupported or p3 == PurchaseErrorType.SubscriptionInvalidSaleLocation then
		return t4.subscriptionUnsupportedPlatformText
	end

	if p3 == PurchaseErrorType.VpcRequired then
		return t4.vpcRequiredText
	end

	if p3 == PurchaseErrorType.ExceedParentalSpendLimit then
		return t4.exceedParentalSpendLimitText
	end

	if p3 == PurchaseErrorType.EconomicRestriction then
		return formatEconomicRestrictionText(t4, t5)
	end

	return t4.unknownText
end
function formatEconomicRestrictionText(t6: {[any]: any}, t7: {[any]: any}) -- line: 123
	-- upvalues: default (copy), EconomicRestrictionsPromptShownCounter (copy), getAppContext (copy), logger (copy)
	local timeoutMinutes = t7.timeoutMinutes
	local violationType = t7.violationType

	default:logRobloxTelemetryCounter(EconomicRestrictionsPromptShownCounter, 1, {
		violationType = tostring(violationType),
		appContext = getAppContext()
	})

	if not timeoutMinutes or not violationType then
		logger.error({
			error = "Timeout and violationType is required for economic restriction text. Showing unknown error.",
			timeoutMinutes = timeoutMinutes,
			violationType = violationType
		})

		return t6.unknownText
	end

	local v35 = getEconomicRestrictionViolationLabel(t6, violationType)
	local v36 = math.ceil(timeoutMinutes / 60)

	if v36 >= 24 then
		local v37 = math.ceil(v36 / 24)

		return t6.economicRestrictionBaseTextDays:gsub("{day}", (tostring(v37))):gsub("{violation}", v35)
	end

	return t6.economicRestrictionBaseTextHours:gsub("{hour}", (tostring(v36))):gsub("{violation}", v35)
end
function getEconomicRestrictionViolationLabel(t8: {[any]: any}, p4) -- line: 154
	-- upvalues: EconomicRestrictionsViolationType (copy), logger (copy)
	if p4 == EconomicRestrictionsViolationType.Chargeback then
		return t8.chargebackViolationLabel
	end

	if p4 == EconomicRestrictionsViolationType.AbuseOfAffiliateSystem then
		return t8.fraudAbuseOfAffiliateSystemViolationLabel
	end

	if p4 == EconomicRestrictionsViolationType.AttemptedUnauthorizedPaymentMethodUse then
		return t8.fraudAttemptedUnauthorizedPaymentMethodUseViolationLabel
	end

	if p4 == EconomicRestrictionsViolationType.PaymentAuthorizationAttempt then
		return t8.fraudPaymentAbuseViolationLabel
	end

	if p4 == EconomicRestrictionsViolationType.RepeatedRefundRequests then
		return t8.fraudRepeatedRefundRequestsViolationLabel
	end

	if p4 == EconomicRestrictionsViolationType.SuspiciousAccountPatterns then
		return t8.fraudSuspiciousAccountPatternsViolationLabel
	end

	if p4 == EconomicRestrictionsViolationType.SuspiciousRefundRequests then
		return t8.fraudSuspiciousRefundRequestsViolationLabel
	end

	if p4 == EconomicRestrictionsViolationType.UnauthorizedPurchase then
		return t8.fraudUnauthorizedPurchaseViolationLabel
	end

	if p4 == EconomicRestrictionsViolationType.UseOfUnauthorizedOffPlatformTransactions then
		return t8.fraudUseOfUnauthorizedOffPlatformTransactionsViolationLabel
	end

	if p4 == EconomicRestrictionsViolationType.VirtualEconomyAbuse then
		return t8.fraudVirtualEconomyAbuseViolationLabel
	end

	logger.error({
		message = "Invalid violation type",
		violationType = p4
	})

	return ""
end
function getIsAlreadyOwnedError(p5) -- line: 185
	-- upvalues: PurchaseErrorType (copy)
	return p5 == PurchaseErrorType.AlreadyOwn or (p5 == PurchaseErrorType.AlreadyPremium or p5 == PurchaseErrorType.AlreadySubscribed)
end
function getErrorTitleIcon(p6) -- line: 191
	-- upvalues: Images (copy)
	if getIsAlreadyOwnedError(p6) then
		return Images["icons/status/success_large"]
	end

	return Images["icons/status/error_large"]
end
function v19.renderNewAlertWithLocalization(p7) -- line: 198
	-- upvalues: withLocalization (copy)
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
	})(function(p8) -- line: 241
		-- upvalues: p7 (copy)
		return p7:renderAlert(p8)
	end)
end
function v19.render(p9) -- line: 246
	-- upvalues: Roact (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy)
	return Roact.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		Alert = p9:renderNewAlertWithLocalization()
	})
end
function v19.renderAlert(t9: {[any]: any}, t10: {[any]: any}) -- line: 254
	-- upvalues: PurchaseErrorType (copy), logger (copy), getAppContext (copy), default (copy), PurchaseErrorPromptShownCounter (copy), Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	local props = t9.props
	local v47 = props.errorType and PurchaseErrorType.toRawValue(props.errorType) or tostring(props.errorType)

	logger.debug({
		message = "Purchase Error Prompt Shown",
		errorType = tostring(props.errorType),
		errorLabel = v47,
		flowType = tostring(props.flowType),
		screenHeight = props.screenSize.Y,
		screenWidth = props.screenSize.X,
		portrait = props.screenSize.X < props.screenSize.Y,
		appContext = getAppContext()
	})
	default:logRobloxTelemetryCounter(PurchaseErrorPromptShownCounter, 1, {
		errorType = tostring(props.errorType),
		errorLabel = v47,
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
		title = t9:getErrorTitle(t10, props.errorType, props.flowType),
		titleIcon = getErrorTitleIcon(props.errorType),
		bodyText = t9:getErrorMessage(t10, props.errorType, props.economicRestrictionError),
		buttonStackInfo = {
			buttons = {{
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = props.doneActivated,
					text = t10.okText,
					inputIcon = props.doneControllerIcon
				}
			}}
		}
	})
end

return v19
