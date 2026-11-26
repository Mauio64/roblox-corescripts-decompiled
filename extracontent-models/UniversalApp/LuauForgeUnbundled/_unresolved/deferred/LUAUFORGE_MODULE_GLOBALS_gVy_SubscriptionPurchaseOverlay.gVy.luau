local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useScreenSize = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useScreenSize
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useLocalUserId
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local module2 = require("@luauforge/bundled/eie")
local module3 = require("@luauforge/bundled/egx")
local module4 = require("@luauforge/deferred/gFx")
local module5 = require("@luauforge/deferred/gLo")
local module6 = require("@luauforge/deferred/gLp")
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Thunks.CloseCentralOverlay

local fFlagEnableReportingFlowForDevSubs = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableReportingFlowForDevSubs
local module7 = require("@luauforge/bundled/dFm")
local module8 = require("@luauforge/bundled/dzE")

local default = require("@luauforge/bundled/bZp").ExternalContentSharingProtocol.default
local UrlBuilder = require(CorePackages.Packages.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local urlBase = UrlBuilder.UrlBase
local HttpRequest = require(CorePackages.Packages.HttpRequest)

local module9 = require("@luauforge/deferred/gKv")
local subscriptionPurchaseFlow = module9.PurchaseFlow.SubscriptionPurchaseFlow
local subscriptionPurchaseFlowState = module9.PurchaseFlow.SubscriptionPurchaseFlowState
local purchaseErrorType = module9.PurchaseFlow.PurchaseErrorType
local module10 = require("@luauforge/deferred/gVz")

local module11 = require("@luauforge/bundled/gIi")
local module12 = require("@luauforge/bundled/gIg")
local module13 = require("@luauforge/bundled/gIk")
local module14 = require("@luauforge/bundled/gVA")

local module15 = require("@luauforge/bundled/fAO")
local module16 = require("@luauforge/bundled/fAK")

require("@luauforge/bundled/gCI")

local module17 = require("@luauforge/deferred/gVB")

local isErrorReasonPrefixWithEconomicRestrictions = module9.Utility.isErrorReasonPrefixWithEconomicRestrictions
local parseErrorReasonToEconomicRestriction = module9.Utility.parseErrorReasonToEconomicRestriction

local function parseSubscriptionError(p2)
	if p2 == "UserHasSpendLimitSet" then
		return purchaseErrorType.SubscriptionExceededUserSpendLimit
	elseif p2 == "UnsupportedLocale" then
		return purchaseErrorType.SubscriptionUnsupportedLocale
	elseif p2 == "RestrictedUser" then
		return purchaseErrorType.RestrictedUser
	elseif p2 == "PurchasePlatformNotSupported" then
		return purchaseErrorType.SubscriptionPurchasePlatformNotSupported
	elseif p2 == "InvalidSaleLocation" then
		return purchaseErrorType.SubscriptionInvalidSaleLocation
	elseif p2 == "UserAlreadySubscribed" then
		return purchaseErrorType.AlreadySubscribed
	elseif p2 == "ProductNotForSale" then
		return purchaseErrorType.SubscriptionNotForSale
	elseif p2 == "VpcRequired" then
		return purchaseErrorType.VpcRequired
	elseif p2 == "ExceedParentalSpendLimit" then
		return purchaseErrorType.ExceedParentalSpendLimit
	elseif p2 == "EconomicRestriction" then
		return purchaseErrorType.EconomicRestriction
	end

	return purchaseErrorType.Unknown
end

local function isSettingsSupportedForPlatform(): boolean
	local v5 = module16()

	return v5 == module15.Google or v5 == module15.Apple or v5 == module15.UWP or v5 == module15.Amazon
end

local function useClearPurchaseResultsOnUnmount()
	local v5 = useDispatch()
	React.useEffect(function()
		return function()
			v5(module14())
		end
	end, {})
end

function LUAUFORGE_MODULE_GLOBALS_gVy_SubscriptionPurchaseOverlay(props)
	local endPurchase = props.endPurchase
	local state, setState = React.useState(subscriptionPurchaseFlowState.PurchaseModal)
	local state2, setState2 = React.useState(purchaseErrorType.None)
	local state3, setState3 = React.useState({})
	local v5 = useDispatch()
	local v6 = useLocalization({
		subscribed = "Feature.Subscription.Text.Subscribed",
		perMonth = "Feature.Subscription.Text.PerMonth",
		disclaimerText = "Feature.Subscription.Text.DisclaimerTextMonthly",
		reportSubscriptionSubmitted = "Feature.Subscription.Message.ReportSubmitted",
		somethingIsWrong = "Feature.Toast.NetworkingError.SomethingIsWrong"
	})

	local v7 = useScreenSize()
	local v8 = useLocalUserId()
	local v9 = module2(module3)

	local subscriptionTargetKey = props.subscriptionPurchaseProductInfo.subscriptionTargetKey

	local v10 = useSelector(function(p2)
		return p2.NativePurchase
	end)

	React.useEffect(function()
		if v10 == nil or v10.purchaseStatus == nil then
			return
		end

		local purchaseStatus = v10.purchaseStatus

		if purchaseStatus == module12.Pending then
			setState(subscriptionPurchaseFlowState.None)
		elseif purchaseStatus == module12.Success then
			props.onPurchaseSuccess()
		elseif purchaseStatus == module12.Failed then
			setState(subscriptionPurchaseFlowState.Error)
			setState2(purchaseErrorType.Unknown)
		end
	end, { v10, props.onPurchaseSuccess })
	local v11 = useDispatch()
	React.useEffect(function()
		return function()
			v11(module14())
		end
	end, {})

	local v12 = React.useCallback(function()
		if fFlagEnableReportingFlowForDevSubs then
			v5(module6({
				abuseVector = module5.Subscription,
				targetId = {
					subscriptionTargetKey = subscriptionTargetKey,
					imageAssetId = tostring(props.subscriptionPurchaseProductInfo.iconImageAssetId)
				},
				onClose = function()
					v5(closeCentralOverlay())
				end
			}))
		else
			module4(v9, subscriptionTargetKey, v8):andThen(function()
				v5(module7({
					toastMessage = v6.reportSubscriptionSubmitted,
					isLocalized = true,
					toastType = module8.SuccessConfirmation
				}))
			end, function()
				v5(module7({
					toastMessage = v6.somethingIsWrong,
					isLocalized = true,
					toastType = module8.NetworkingError
				}))
			end)
		end
	end, {
		v9,
		subscriptionTargetKey,
		v8,
		v5,
		v6,
		props.subscriptionPurchaseProductInfo.iconImageAssetId
	})

	local subscriptionProviderId = props.subscriptionPurchaseProductInfo.subscriptionProviderId

	local v13 = React.useCallback(function()
		if not subscriptionProviderId then
			return
		end

		local v14 = urlBuilder.new({
			base = urlBase.APIS,
			path = "sharelinks/v1/get-or-create-link"
		})()

		local jsonEncode2 = HttpService:JSONEncode({
			linkType = "ExperienceDetails",
			data = HttpService:JSONEncode({
				universeId = tostring(subscriptionProviderId)
			})
		})

		HttpRequest.config({
			requestFunction = HttpRequest.requestFunctions.RequestInternal
		})(
			v14,
			"POST",
			{ postBody = jsonEncode2 }
		):andThen(function(p2)
			local responseBody = p2.responseBody or p2.result

			if responseBody and responseBody.linkId then
				local unixTimestampMillis = tostring(DateTime.now().UnixTimestampMillis)
				local shortUrl = urlBuilder.sharelinks.shortUrl({
					linkId = responseBody.linkId,
					type = "ExperienceDetails",
					stamp = unixTimestampMillis
				})

				if default then
					default:shareUrl({
						url = shortUrl,
						context = "SubscriptionPurchaseShare"
					})
				end
			end
		end):catch(function()
			v5(module7({
				toastMessage = v6.somethingIsWrong,
				isLocalized = true,
				toastType = module8.NetworkingError
			}))
		end)
	end, { subscriptionProviderId, v5, v6 })

	local createElement = React.createElement

	local v16 = if state == subscriptionPurchaseFlowState.PurchaseVPCModal then module10.toRawValue(module10.EnablePurchase) else module10.toRawValue(module10.None)
	local v15 = {
		screenSize = v7,
		purchaseState = state,
		errorType = state2,
		economicRestrictionError = state3,
		purchaseVPCType = v16,
		shouldUseNewModalDesign = props.shouldUseNewModalDesign,
		isRobuxSubscription = props.isRobuxSubscription,
		creatorName = props.creatorName,
		creatorVerified = props.creatorVerified,
		subscriptionId = subscriptionTargetKey,
		name = props.subscriptionPurchaseProductInfo.name,
		subscriptionProviderId = props.subscriptionPurchaseProductInfo.subscriptionProviderId,
		subscriptionProviderName = props.subscriptionPurchaseProductInfo.subscriptionProviderName,
		priceTier = props.subscriptionPurchaseProductInfo.priceTier,
		displayPrice = props.subscriptionPurchaseProductInfo.displayPrice,
		period = v6.perMonth,
		description = props.subscriptionPurchaseProductInfo.description,
		disclaimerText = v6.disclaimerText,
		itemIcon = props.thumbnailString,
		disablePurchase = props.isSubscribed,
		disablePurchaseText = 0,
		purchaseSubscription = 0,
		cancelPurchase = 0,
		flowComplete = 0,
		openSettingsPage = 0,
		onReport = 0,
		onShare = 0,
		onAnalyticEvent = 0,
		eventPrefix = "EDP"
	}
	local v17 = if props.isSubscribed then v6.subscribed else nil
	v15.disablePurchaseText = v17

	function v15.purchaseSubscription()
		if props.isRobuxSubscription then
			props.promptSubscriptionPurchase(
				subscriptionTargetKey,
				props.subscriptionPurchaseProductInfo.priceInRobux
			):andThen(function()
				props.onPurchaseSuccess()
			end):catch(function(value)
				local v14 = nil

				if type(value) == "string" then
					v14 = value
				elseif type(value) == "table" and value.Body then
					local success, result = pcall(function()
						return HttpService:JSONDecode(value.Body)
					end)

					if success and result and result.errors and result.errors[1] then
						v14 = result.errors[1].code or result.errors[1].message
					end
				end

				if v14 and isErrorReasonPrefixWithEconomicRestrictions(v14) then
					setState2(purchaseErrorType.EconomicRestriction)
					setState(subscriptionPurchaseFlowState.Error)
					setState3(parseErrorReasonToEconomicRestriction(v14))
				else
					setState2(parseSubscriptionError(v14))
					setState(subscriptionPurchaseFlowState.Error)
				end
			end)
			return
		end

		v5(module13(subscriptionTargetKey, module12.Pending, module11.Subscription))

		props.promptSubscriptionPurchase(subscriptionTargetKey):catch(function(p2)
			if isErrorReasonPrefixWithEconomicRestrictions(p2) then
				setState2(purchaseErrorType.EconomicRestriction)
				setState(subscriptionPurchaseFlowState.Error)
				setState3(parseErrorReasonToEconomicRestriction(p2))
			else
				local v14 = parseSubscriptionError(p2)
				setState2(v14)

				local v16 = if module17() and v14 == purchaseErrorType.VpcRequired then subscriptionPurchaseFlowState.PurchaseVPCModal else subscriptionPurchaseFlowState.Error
				setState(v16)
			end
		end)
	end
	v15.cancelPurchase = endPurchase
	v15.flowComplete = endPurchase
	local v18 = module16()

	local v19 = if v18 == module15.Google or v18 == module15.Apple or v18 == module15.UWP or v18 == module15.Amazon then props.openSettingsPage else nil
	v15.openSettingsPage = v19

	if not props.shouldUseNewModalDesign then
		v12 = nil
	end

	v15.onReport = v12

	if not props.shouldUseNewModalDesign then
		v13 = nil
	end

	v15.onShare = v13

	function v15.onAnalyticEvent(p2, p3)
		props.onAnalyticEvent("EDPSubscriptionPurchase", p2, p3)
	end

	return createElement(subscriptionPurchaseFlow, v15)
end

return LUAUFORGE_MODULE_GLOBALS_gVy_SubscriptionPurchaseOverlay
