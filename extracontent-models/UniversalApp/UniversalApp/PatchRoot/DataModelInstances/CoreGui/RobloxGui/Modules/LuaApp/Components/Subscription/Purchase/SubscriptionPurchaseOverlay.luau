local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useScreenSize = require(CorePackages.Workspace.Packages.RobloxAppHooks).useScreenSize
local useLocalUserId = require(CorePackages.Workspace.Packages.RobloxAppHooks).useLocalUserId
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local PostReportSubscription = require(Modules.LuaApp.Http.Requests.EconomyAPI.PostReportSubscription)
local AbuseVector = require(CorePackages.Workspace.Packages.GenericAbuseReporting.AbuseVector)
local OpenDynamicAbuseReport = require(CorePackages.Workspace.Packages.GenericAbuseReporting.OpenDynamicAbuseReport)
local CloseCentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Thunks.CloseCentralOverlay
local FFlagEnableReportingFlowForDevSubs = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableReportingFlowForDevSubs
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local default = require(CorePackages.Workspace.Packages.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local UrlBuilder = require(CorePackages.Packages.UrlBuilder)
local UrlBuilder2 = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase
local HttpRequest = require(CorePackages.Packages.HttpRequest)
local IAPExperience = require(CorePackages.Workspace.Packages.IAPExperience)
local SubscriptionPurchaseFlow = IAPExperience.PurchaseFlow.SubscriptionPurchaseFlow
local SubscriptionPurchaseFlowState = IAPExperience.PurchaseFlow.SubscriptionPurchaseFlowState
local PurchaseErrorType = IAPExperience.PurchaseFlow.PurchaseErrorType
local VPCModalType = require(Modules.LuaApp.Components.BuyRobux.Enum.VPCModalType)
local NativePurchaseProductTypeEnum = require(Modules.LuaApp.Enum.NativePurchaseProductTypeEnum)
local NativePurchaseStatus = require(Modules.LuaApp.Enum.NativePurchaseStatus)
local SetNativePurchaseResult = require(Modules.LuaApp.Actions.SetNativePurchaseResult)
local ClearNativePurchaseResult = require(Modules.LuaApp.Actions.ClearNativePurchaseResult)
local PaymentPlatform = require(Modules.LuaApp.Enum.PaymentPlatform)
local getPaymentPlatform = require(Modules.LuaApp.Util.getPaymentPlatform)

require(Modules.LuaApp.Models.SubscriptionApi.SubscriptionProductInfoModel)

local GetFFlagEnableVpcForInAppSubscriptionPurchase = require(Modules.LuaApp.Flags.GetFFlagEnableVpcForInAppSubscriptionPurchase)
local isErrorReasonPrefixWithEconomicRestrictions = IAPExperience.Utility.isErrorReasonPrefixWithEconomicRestrictions
local parseErrorReasonToEconomicRestriction = IAPExperience.Utility.parseErrorReasonToEconomicRestriction

local function parseSubscriptionError(p1) -- line: 73
	-- upvalues: PurchaseErrorType (copy)
	if p1 == "UserHasSpendLimitSet" then
		return PurchaseErrorType.SubscriptionExceededUserSpendLimit
	end

	if p1 == "UnsupportedLocale" then
		return PurchaseErrorType.SubscriptionUnsupportedLocale
	end

	if p1 == "RestrictedUser" then
		return PurchaseErrorType.RestrictedUser
	end

	if p1 == "PurchasePlatformNotSupported" then
		return PurchaseErrorType.SubscriptionPurchasePlatformNotSupported
	end

	if p1 == "InvalidSaleLocation" then
		return PurchaseErrorType.SubscriptionInvalidSaleLocation
	end

	if p1 == "UserAlreadySubscribed" then
		return PurchaseErrorType.AlreadySubscribed
	end

	if p1 == "ProductNotForSale" then
		return PurchaseErrorType.SubscriptionNotForSale
	end

	if p1 == "VpcRequired" then
		return PurchaseErrorType.VpcRequired
	end

	if p1 == "ExceedParentalSpendLimit" then
		return PurchaseErrorType.ExceedParentalSpendLimit
	end

	if p1 == "EconomicRestriction" then
		return PurchaseErrorType.EconomicRestriction
	end

	return PurchaseErrorType.Unknown
end
local function isSettingsSupportedForPlatform() -- line: 99
	-- upvalues: getPaymentPlatform (copy), PaymentPlatform (copy)
	local v43 = getPaymentPlatform()

	return v43 == PaymentPlatform.Google or (v43 == PaymentPlatform.Apple or (v43 == PaymentPlatform.UWP or v43 == PaymentPlatform.Amazon))
end
local function useClearPurchaseResultsOnUnmount() -- line: 108
	-- upvalues: useDispatch (copy), React (copy), ClearNativePurchaseResult (copy)
	local v44 = useDispatch()

	React.useEffect(function() -- line: 110
		-- upvalues: v44 (copy), ClearNativePurchaseResult (copy)
		return function() -- line: 111
			-- upvalues: v44 (copy), ClearNativePurchaseResult (copy)
			v44(ClearNativePurchaseResult())
		end
	end, {})
end

function SubscriptionPurchaseOverlay(t1: {[any]: any}) -- line: 117
	-- upvalues: React (copy), SubscriptionPurchaseFlowState (copy), PurchaseErrorType (copy), useDispatch (copy), useLocalization (copy), useScreenSize (copy), useLocalUserId (copy), useRoactService (copy), RoactNetworking (copy), useSelector (copy), NativePurchaseStatus (copy), ClearNativePurchaseResult (copy), FFlagEnableReportingFlowForDevSubs (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy), PostReportSubscription (copy), SetCurrentToastMessage (copy), ToastType (copy), UrlBuilder2 (copy), UrlBase (copy), HttpService (copy), HttpRequest (copy), default (copy), isErrorReasonPrefixWithEconomicRestrictions (copy), parseErrorReasonToEconomicRestriction (copy), parseSubscriptionError (copy), SetNativePurchaseResult (copy), NativePurchaseProductTypeEnum (copy), GetFFlagEnableVpcForInAppSubscriptionPurchase (copy), SubscriptionPurchaseFlow (copy), VPCModalType (copy), getPaymentPlatform (copy), PaymentPlatform (copy)
	local endPurchase = t1.endPurchase
	local v47, v48 = React.useState(SubscriptionPurchaseFlowState.PurchaseModal)
	local v49, v50 = React.useState(PurchaseErrorType.None)
	local v51, v52 = React.useState({})
	local v53 = useDispatch()
	local v54 = useLocalization({
		subscribed = "Feature.Subscription.Text.Subscribed",
		perMonth = "Feature.Subscription.Text.PerMonth",
		disclaimerText = "Feature.Subscription.Text.DisclaimerTextMonthly",
		reportSubscriptionSubmitted = "Feature.Subscription.Message.ReportSubmitted",
		somethingIsWrong = "Feature.Toast.NetworkingError.SomethingIsWrong"
	})
	local v55 = useScreenSize()
	local v56 = useLocalUserId()
	local v57 = useRoactService(RoactNetworking)
	local subscriptionTargetKey = t1.subscriptionPurchaseProductInfo.subscriptionTargetKey
	local v59 = useSelector(function(p2) -- line: 137
		return p2.NativePurchase
	end)

	React.useEffect(function() -- line: 141
		-- upvalues: v59 (copy), NativePurchaseStatus (copy), v48 (copy), SubscriptionPurchaseFlowState (copy), t1 (copy), v50 (copy), PurchaseErrorType (copy)
		if v59 == nil or v59.purchaseStatus == nil then
			return
		end

		local purchaseStatus = v59.purchaseStatus

		if purchaseStatus == NativePurchaseStatus.Pending then
			v48(SubscriptionPurchaseFlowState.None)

			return
		end

		if purchaseStatus == NativePurchaseStatus.Success then
			t1.onPurchaseSuccess()

			return
		end

		if purchaseStatus == NativePurchaseStatus.Failed then
			v48(SubscriptionPurchaseFlowState.Error)
			v50(PurchaseErrorType.Unknown)
		end
	end, {
		v59,
		t1.onPurchaseSuccess
	})

	local v60 = useDispatch()

	React.useEffect(function() -- line: 110
		-- upvalues: v60 (copy), ClearNativePurchaseResult (copy)
		return function() -- line: 111
			-- upvalues: v60 (copy), ClearNativePurchaseResult (copy)
			v60(ClearNativePurchaseResult())
		end
	end, {})

	local v61 = React.useCallback(function() -- line: 159
		-- upvalues: FFlagEnableReportingFlowForDevSubs (copy), v53 (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), subscriptionTargetKey (copy), t1 (copy), CloseCentralOverlay (copy), PostReportSubscription (copy), v57 (copy), v56 (copy), SetCurrentToastMessage (copy), v54 (copy), ToastType (copy)
		if FFlagEnableReportingFlowForDevSubs then
			v53(OpenDynamicAbuseReport({
				abuseVector = AbuseVector.Subscription,
				targetId = {
					subscriptionTargetKey = subscriptionTargetKey,
					imageAssetId = tostring(t1.subscriptionPurchaseProductInfo.iconImageAssetId)
				},
				onClose = function() -- line: 167
					-- upvalues: v53 (copy), CloseCentralOverlay (copy)
					v53(CloseCentralOverlay())
				end
			}))

			return
		end

		PostReportSubscription(v57, subscriptionTargetKey, v56):andThen(function() -- line: 174
			-- upvalues: v53 (copy), SetCurrentToastMessage (copy), v54 (copy), ToastType (copy)
			v53(SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = v54.reportSubscriptionSubmitted,
				toastType = ToastType.SuccessConfirmation
			}))
		end, function() -- line: 180
			-- upvalues: v53 (copy), SetCurrentToastMessage (copy), v54 (copy), ToastType (copy)
			v53(SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = v54.somethingIsWrong,
				toastType = ToastType.NetworkingError
			}))
		end)
	end, {
		v57,
		subscriptionTargetKey,
		v56,
		v53,
		v54,
		t1.subscriptionPurchaseProductInfo.iconImageAssetId
	})
	local subscriptionProviderId = t1.subscriptionPurchaseProductInfo.subscriptionProviderId
	local v63 = React.useCallback(function() -- line: 200
		-- upvalues: subscriptionProviderId (copy), UrlBuilder2 (copy), UrlBase (copy), HttpService (copy), HttpRequest (copy), default (copy), v53 (copy), SetCurrentToastMessage (copy), v54 (copy), ToastType (copy)
		if not subscriptionProviderId then
			return
		end

		local v70 = UrlBuilder2.new({
			path = "sharelinks/v1/get-or-create-link",
			base = UrlBase.APIS
		})()
		local json = HttpService:JSONEncode({
			universeId = tostring(subscriptionProviderId)
		})
		local json2 = HttpService:JSONEncode({
			linkType = "ExperienceDetails",
			data = json
		})

		HttpRequest.config({
			requestFunction = HttpRequest.requestFunctions.RequestInternal
		})(v70, "POST", {
			postBody = json2
		}):andThen(function(p3) -- line: 221
			-- upvalues: UrlBuilder2 (copy), default (copy)
			local v76 = p3.responseBody or p3.result

			if v76 and v76.linkId then
				local str = tostring(DateTime.now().UnixTimestampMillis)
				local v78 = UrlBuilder2.sharelinks.shortUrl({
					type = "ExperienceDetails",
					linkId = v76.linkId,
					stamp = str
				})

				if default then
					default:shareUrl({
						context = "SubscriptionPurchaseShare",
						url = v78
					})
				end
			end
		end):catch(function() -- line: 238
			-- upvalues: v53 (copy), SetCurrentToastMessage (copy), v54 (copy), ToastType (copy)
			v53(SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = v54.somethingIsWrong,
				toastType = ToastType.NetworkingError
			}))
		end)
	end, {
		subscriptionProviderId,
		v53,
		v54
	})
	local createElement = React.createElement
	local v65 = SubscriptionPurchaseFlow
	local t2 = {
		eventPrefix = "EDP",
		screenSize = v55,
		purchaseState = v47,
		errorType = v49,
		economicRestrictionError = v51,
		purchaseVPCType = if v47 ~= SubscriptionPurchaseFlowState.PurchaseVPCModal then VPCModalType.toRawValue(VPCModalType.None) else VPCModalType.toRawValue(VPCModalType.EnablePurchase),
		shouldUseNewModalDesign = t1.shouldUseNewModalDesign,
		isRobuxSubscription = t1.isRobuxSubscription,
		creatorName = t1.creatorName,
		creatorVerified = t1.creatorVerified,
		subscriptionId = subscriptionTargetKey,
		name = t1.subscriptionPurchaseProductInfo.name,
		subscriptionProviderId = t1.subscriptionPurchaseProductInfo.subscriptionProviderId,
		subscriptionProviderName = t1.subscriptionPurchaseProductInfo.subscriptionProviderName,
		priceTier = t1.subscriptionPurchaseProductInfo.priceTier,
		displayPrice = t1.subscriptionPurchaseProductInfo.displayPrice,
		period = v54.perMonth,
		description = t1.subscriptionPurchaseProductInfo.description,
		disclaimerText = v54.disclaimerText,
		itemIcon = t1.thumbnailString,
		disablePurchase = t1.isSubscribed,
		disablePurchaseText = if not t1.isSubscribed then nil else v54.subscribed,
		purchaseSubscription = function() -- line: 247
			-- upvalues: t1 (copy), subscriptionTargetKey (copy), HttpService (copy), isErrorReasonPrefixWithEconomicRestrictions (copy), v50 (copy), PurchaseErrorType (copy), v48 (copy), SubscriptionPurchaseFlowState (copy), v52 (copy), parseErrorReasonToEconomicRestriction (copy), parseSubscriptionError (copy), v53 (copy), SetNativePurchaseResult (copy), NativePurchaseStatus (copy), NativePurchaseProductTypeEnum (copy), GetFFlagEnableVpcForInAppSubscriptionPurchase (copy)
			if t1.isRobuxSubscription then
				t1.promptSubscriptionPurchase(subscriptionTargetKey, t1.subscriptionPurchaseProductInfo.priceInRobux):andThen(function() -- line: 251
					-- upvalues: t1 (copy)
					t1.onPurchaseSuccess()
				end):catch(function(p4) -- line: 254
					-- upvalues: HttpService (copy), isErrorReasonPrefixWithEconomicRestrictions (copy), v50 (copy), PurchaseErrorType (copy), v48 (copy), SubscriptionPurchaseFlowState (copy), v52 (copy), parseErrorReasonToEconomicRestriction (copy), parseSubscriptionError (copy)
					local v80 = nil

					if type(p4) == "string" then
						v80 = p4
					elseif type(p4) == "table" and p4.Body then
						local ok, result = pcall(function() -- line: 259
							-- upvalues: HttpService (copy), p4 (copy)
							return HttpService:JSONDecode(p4.Body)
						end)

						if ok and result and result.errors and result.errors[1] then
							v80 = result.errors[1].code or result.errors[1].message
						end
					end

					if v80 and isErrorReasonPrefixWithEconomicRestrictions(v80) then
						v50(PurchaseErrorType.EconomicRestriction)
						v48(SubscriptionPurchaseFlowState.Error)
						v52(parseErrorReasonToEconomicRestriction(v80))

						return
					end

					local v83 = parseSubscriptionError(v80)

					v50(v83)
					v48(SubscriptionPurchaseFlowState.Error)
				end)

				return
			end

			v53(SetNativePurchaseResult(subscriptionTargetKey, NativePurchaseStatus.Pending, NativePurchaseProductTypeEnum.Subscription))
			t1.promptSubscriptionPurchase(subscriptionTargetKey):catch(function(p5) -- line: 290
				-- upvalues: isErrorReasonPrefixWithEconomicRestrictions (copy), v50 (copy), PurchaseErrorType (copy), v48 (copy), SubscriptionPurchaseFlowState (copy), v52 (copy), parseErrorReasonToEconomicRestriction (copy), parseSubscriptionError (copy), GetFFlagEnableVpcForInAppSubscriptionPurchase (copy)
				if isErrorReasonPrefixWithEconomicRestrictions(p5) then
					v50(PurchaseErrorType.EconomicRestriction)
					v48(SubscriptionPurchaseFlowState.Error)
					v52(parseErrorReasonToEconomicRestriction(p5))

					return
				end

				local v85 = parseSubscriptionError(p5)

				v50(v85)
				v48(if not GetFFlagEnableVpcForInAppSubscriptionPurchase() or v85 ~= PurchaseErrorType.VpcRequired then SubscriptionPurchaseFlowState.Error else SubscriptionPurchaseFlowState.PurchaseVPCModal)
			end)
		end,
		cancelPurchase = endPurchase,
		flowComplete = endPurchase
	}
	local v67 = getPaymentPlatform()

	t2.openSettingsPage = if not (v67 == PaymentPlatform.Google or (v67 == PaymentPlatform.Apple or (v67 == PaymentPlatform.UWP or v67 == PaymentPlatform.Amazon))) then nil else t1.openSettingsPage
	t2.onReport = if not t1.shouldUseNewModalDesign then nil else v61
	t2.onShare = if not t1.shouldUseNewModalDesign then nil else v63

	function t2.onAnalyticEvent(s1: string, t3: {[any]: any}) -- line: 342
		-- upvalues: t1 (copy)
		t1.onAnalyticEvent("EDPSubscriptionPurchase", s1, t3)
	end

	return createElement(v65, t2)
end

return SubscriptionPurchaseOverlay
