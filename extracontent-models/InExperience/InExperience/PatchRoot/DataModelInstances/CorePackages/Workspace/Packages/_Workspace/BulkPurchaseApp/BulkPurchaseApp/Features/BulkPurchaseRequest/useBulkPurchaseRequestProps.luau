local MarketplaceService = game:GetService("MarketplaceService")
local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local SharedFlags = require(parent.SharedFlags)
local function isInExperienceBuyRobuxRoutingEnabled() -- 1 equivalent call inferred from this helper
	return SharedFlags.FFlagEnableBuyRobuxNewRouting and SharedFlags.FFlagEnableBuyRobuxNewRoutingInExperience
end

local IAPExperience = require(parent.IAPExperience)
local isErrorReasonContainsEconomicRestrictions = IAPExperience.Utility.isErrorReasonContainsEconomicRestrictions

local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local RobloxSubscriptionPurchaseApp = require(parent.RobloxSubscriptionPurchaseApp)
local getRobloxSubscriptionProducts = RobloxSubscriptionPurchaseApp.Network.getRobloxSubscriptionProducts
local RobloxSubscriptionSignals = RobloxSubscriptionPurchaseApp.RobloxSubscriptionSignals
local RobloxSubscriptionFlowCompleteReason = RobloxSubscriptionPurchaseApp.RobloxSubscriptionFlowCompleteReason
local SurfaceName = RobloxSubscriptionPurchaseApp.SurfaceName
local SurfaceContext = RobloxSubscriptionPurchaseApp.SurfaceContext
local PurchasePrompt = require(parent.PurchasePrompt)
local WebViewUtils = require(parent.WebViewUtils)

local selectPurchaseResults = require(BulkPurchaseApp.Store.Selectors.selectPurchaseResults)
local selectOrderRequest = require(BulkPurchaseApp.Store.Selectors.selectOrderRequest)
local selectItemData = require(BulkPurchaseApp.Store.Selectors.selectItemData)
local BulkPurchaseEnded = require(BulkPurchaseApp.Store.Actions.BulkPurchaseEnded)
local BulkPurchaseFailed = require(BulkPurchaseApp.Store.Actions.BulkPurchaseFailed)
local BulkPurchaseDisablePurchase = require(BulkPurchaseApp.Store.Actions.BulkPurchaseDisablePurchase)
local BulkPurchaseSucceeded = require(BulkPurchaseApp.Store.Actions.BulkPurchaseSucceeded)
local BulkPurchaseCountersEnum = require(BulkPurchaseApp.Enums.BulkPurchaseCountersEnum)
local BulkPurchasePromptStateEnum = require(BulkPurchaseApp.Enums.BulkPurchasePromptStateEnum)
local ErrorCodeEnum = require(BulkPurchaseApp.Enums.ErrorCodeEnum)
local ItemStatusToErrorCodeMap = require(BulkPurchaseApp.Enums.ItemStatusToErrorCodeMap)
local PaymentPlatformEnum = require(BulkPurchaseApp.Enums.PaymentPlatformEnum)
local getPaymentPlatform = require(BulkPurchaseApp.Utils.getPaymentPlatform)
local getRobuxStoreUrl = require(BulkPurchaseApp.Utils.getRobuxStoreUrl)
local getGuiObjectIsObscured = require(BulkPurchaseApp.Utils.getGuiObjectIsObscured)
local reportBulkPurchaseRequestCounters = require(BulkPurchaseApp.Utils.reportBulkPurchaseRequestCounters)
local FFlagFixVP8143 = require(BulkPurchaseApp.Flags.FFlagFixVP8143)
local FFlagBulkPurchaseReportCounters = require(BulkPurchaseApp.Flags.FFlagBulkPurchaseReportCounters)

local getItemResultsFromResponse = require(script.Parent.Utils.getItemResultsFromResponse)
local getCommonItemStatus = require(script.Parent.Utils.getCommonItemStatus)
local handleEconomicRestrictionError = require(script.Parent.Utils.handleEconomicRestrictionError)
local selectBulkPurchaseRequestState = require(script.Parent.Utils.selectBulkPurchaseRequestState)
local selectOptions = require(script.Parent.Utils.selectOptions)

local defineFastFlag = game:DefineFastFlag("FixBuyRobuxForAndroid", false)
local defineFastFlag2 = game:DefineFastFlag("FixBulkPurchaseInExperienceBuyRobux", false)
local defineFastFlag3 = game:DefineFastFlag("FixBulkPurchaseStarterGuiRename", false)
local FFlagAXAddPlusUpsellToBulkPurchase = require(BulkPurchaseApp.Flags.FFlagAXAddPlusUpsellToBulkPurchase)
local FFlagAXAddOffersToBulkPurchase = require(BulkPurchaseApp.Flags.FFlagAXAddOffersToBulkPurchase)
local FFlagAXMoreBulkPurchaseCounters = require(BulkPurchaseApp.Flags.FFlagAXMoreBulkPurchaseCounters)
local FFlagBulkPurchaseTestPurchaseHint = require(BulkPurchaseApp.Flags.FFlagBulkPurchaseTestPurchaseHint)
local FIntBlackbirdUpsellMinPriceForDiscountInclusive = SharedFlags.FIntBlackbirdUpsellMinPriceForDiscountInclusive
local FIntBlackbirdUpsellMaxPriceForDiscountInclusive = SharedFlags.FIntBlackbirdUpsellMaxPriceForDiscountInclusive

require(script.Parent.BulkPurchaseRequest)

local function useBulkPurchaseRequestProps()
	local v = useDispatch()
	local v2 = useSelector(selectBulkPurchaseRequestState)
	local v3 = useSelector(selectPurchaseResults)
	local v4 = useSelector(selectOrderRequest)
	local v5 = useSelector(selectOptions)
	local v6 = useSelector(selectItemData)
	local totalCost = v2.totalCost
	local balance = v2.balance
	local batchPurchaseAuthToken

	if FFlagAXAddPlusUpsellToBulkPurchase then
		batchPurchaseAuthToken = v4 and v4.batchPurchaseAuthToken
	else
		batchPurchaseAuthToken = nil
	end

	local state, setState

	if FFlagAXAddPlusUpsellToBulkPurchase then
		state, setState = React.useState({})
	else
		setState = nil
	end

	local v7

	if FFlagAXAddPlusUpsellToBulkPurchase then
		local v8 = RobloxSubscriptionSignals.get()
		v7 = SignalsReact.useSignalState(v8.getHasRobloxSubscription)
	else
		v7 = nil
	end

	local function onClose()
		MarketplaceService:signalPromptBulkPurchaseFinished(2, v3)
		v(BulkPurchaseEnded())
	end

	local function onAccept()
		if FFlagAXAddPlusUpsellToBulkPurchase then
			v(BulkPurchaseDisablePurchase())
		end

		local success, result = pcall(function()
			return MarketplaceService:PerformBulkPurchase(v4, v5)
		end)

		if success and result then
			if result.message and isErrorReasonContainsEconomicRestrictions(result.message) then
				handleEconomicRestrictionError(result.message, v)
				return
			end

			local itemResultsFromResponse = getItemResultsFromResponse(result, v6)
			local commonItemStatus = getCommonItemStatus(itemResultsFromResponse)

			if commonItemStatus then
				if commonItemStatus == Enum.MarketplaceItemPurchaseStatus.Success then
					if FFlagBulkPurchaseReportCounters then
						reportBulkPurchaseRequestCounters(BulkPurchaseCountersEnum.BulkPurchaseSucceededCounter)
					end

					v(BulkPurchaseSucceeded(BulkPurchasePromptStateEnum.Success, itemResultsFromResponse))
				else
					if FFlagBulkPurchaseReportCounters then
						if FFlagAXMoreBulkPurchaseCounters then
							reportBulkPurchaseRequestCounters(BulkPurchaseCountersEnum.BulkPurchaseFailedCounter, {
								errorCode = tostring(ItemStatusToErrorCodeMap[commonItemStatus])
							})
						else
							reportBulkPurchaseRequestCounters(BulkPurchaseCountersEnum.BulkPurchaseFailedCounter)
						end
					end

					v(BulkPurchaseFailed(ItemStatusToErrorCodeMap[commonItemStatus]))
				end
			else
				if FFlagAXMoreBulkPurchaseCounters then
					reportBulkPurchaseRequestCounters(BulkPurchaseCountersEnum.BulkPurchasePartialSuccessCounter)
				end

				v(BulkPurchaseSucceeded(BulkPurchasePromptStateEnum.PartialSuccess, itemResultsFromResponse))
			end
		elseif string.find(result, "403") then
			v(BulkPurchaseFailed(ErrorCodeEnum.TwoStepVerificationRequired))
		else
			v(BulkPurchaseFailed(ErrorCodeEnum.Generic))
		end
	end

	local function fn()
		local paymentPlatform = getPaymentPlatform()

		if paymentPlatform ~= PaymentPlatformEnum.Desktop and paymentPlatform ~= PaymentPlatformEnum.Mobile then
			v(BulkPurchaseFailed(ErrorCodeEnum.InsufficientRobux))

			return
		end

		if isInExperienceBuyRobuxRoutingEnabled() then -- inferred equivalent call
			local BuyRobuxInExperience = require(parent.BuyRobuxInExperience)
			BuyRobuxInExperience.openBuyRobux({}, function(url: string)
				if defineFastFlag2 then
					WebViewUtils.openWebViewSession(url, "")
				elseif defineFastFlag then
					BrowserService:SendCommand((HttpService:JSONEncode({
						command = "open",
						url = url
					})))
				else
					BrowserService:OpenBrowserWindow(url)
				end
			end, "BulkPurchase.onRobuxUpsell")
		elseif defineFastFlag2 then
			WebViewUtils.openWebViewSession(getRobuxStoreUrl(), "")
		elseif defineFastFlag then
			BrowserService:SendCommand((HttpService:JSONEncode({
				command = "open",
				url = getRobuxStoreUrl()
			})))
		else
			BrowserService:OpenBrowserWindow(getRobuxStoreUrl())
		end

		v(BulkPurchaseEnded())
	end

	local shouldShowBlackbirdUpsellBanner, onBlackbirdUpsellActivated, blackbirdUpsellBannerProductInfo

	if FFlagAXAddPlusUpsellToBulkPurchase then
		local v8 = useAppPolicy(function(p)
			return p.getDisableBlackbirdEntrypoints()
		end)

		React.useEffect(function()
			getRobloxSubscriptionProducts():andThen(function(p)
				setState(p)
			end):catch(function(p)
				mutedError("BulkPurchasePrompt", "Failed to fetch Roblox subscription products: " .. tostring(p))
			end)
		end, {})

		shouldShowBlackbirdUpsellBanner = React.useMemo(function(): boolean
			if v7 or v8 then
				return false
			end

			for _, item in v2.items do
				if
					FIntBlackbirdUpsellMinPriceForDiscountInclusive <= item.cost
					and item.cost <= FIntBlackbirdUpsellMaxPriceForDiscountInclusive
				then
					return true
				end
			end

			return false
		end, { v8, v7, v2.items })

		onBlackbirdUpsellActivated = React.useCallback(function()
			if FFlagBulkPurchaseReportCounters then
				reportBulkPurchaseRequestCounters(BulkPurchaseCountersEnum.BulkPurchasePlusUpsellInitatedCounter)
			end

			RobloxSubscriptionPurchaseApp.initiateRobloxSubscriptionPurchase({
				showBackButton = false
			}, {
				onFlowComplete = function(p)
					if p == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseSucceeded and batchPurchaseAuthToken then
						v(BulkPurchaseDisablePurchase())

						if FFlagBulkPurchaseReportCounters then
							reportBulkPurchaseRequestCounters(BulkPurchaseCountersEnum.BulkPurchasePlusUpsellSucceededCounter)
						end

						if not pcall(function()
							MarketplaceService:RefreshBulkPurchase(batchPurchaseAuthToken)
						end) then
							v(BulkPurchaseFailed(ErrorCodeEnum.Generic))
						end
					end

					if
						FFlagBulkPurchaseReportCounters
						and p == RobloxSubscriptionFlowCompleteReason.UpsellPurchaseFailed
					then
						reportBulkPurchaseRequestCounters(BulkPurchaseCountersEnum.BulkPurchasePlusUpsellFailedCounter)
					end
				end
			}, nil, SurfaceName.BulkPurchasePrompt, SurfaceContext.InGame, nil, nil)
		end, { v, batchPurchaseAuthToken })

		blackbirdUpsellBannerProductInfo = PurchasePrompt.Utils.getBlackbirdUpsellBannerProductInfo(state)
	end

	local toggleOfferSelected

	if FFlagAXAddOffersToBulkPurchase then
		toggleOfferSelected = React.useCallback(function(p: string)
			local unselectedOffers = {}

			if v2.offerData and v2.offerData.offersAvailable then
				local offersAvailable = v2.offerData.offersAvailable

				for k, _ in offersAvailable do
					if k ~= p and not offersAvailable[k].selected then
						table.insert(unselectedOffers, k)
					end

					if k == p and offersAvailable[k].selected then
						table.insert(unselectedOffers, k)
					end
				end
			end

			pcall(function()
				MarketplaceService:RefreshBulkPurchase(batchPurchaseAuthToken, {
					unselectedOffers = unselectedOffers
				})
			end)
		end, { v2.offerData, batchPurchaseAuthToken })
	end

	local ref = nil
	local state2 = nil
	local v8 = nil

	if FFlagFixVP8143 then
		ref = React.useRef(nil)
		local setState2
		state2, setState2 = React.useState(true)
		v8 = setState2
		React.useEffect(function()
			local heartbeatConnection = RunService.Heartbeat:Connect(function()
				if ref.current and typeof(ref.current) == "Instance" and ref.current:IsA("GuiObject") then
					local guiObjectIsObscured = getGuiObjectIsObscured(ref.current)
					local v9

					if defineFastFlag3 then
						v9 = StarterGui:GetCore("DevConsoleVisible")
					else
						v9 = game.StarterGui:GetCore("DevConsoleVisible")
					end

					v8(guiObjectIsObscured or v9)
				end
			end)
			return function()
				heartbeatConnection:Disconnect()
			end
		end, {})
	end

	local v9 = {
		currentBalance = v2.balance,
		items = v2.items,
		ownedItems = v2.ownedItems,
		unpurchasableItems = v2.unpurchasableItems,
		onClose = onClose,
		onAccept = 0,
		totalCost = 0,
		isDisabled = 0,
		purchaseButtonRef = 0,
		discountInformation = 0,
		shouldShowBlackbirdUpsellBanner = 0,
		blackbirdUpsellBannerProductInfo = 0,
		onBlackbirdUpsellActivated = 0,
		offerData = 0,
		toggleOfferSelected = 0,
		isTestPurchase = 0
	}

	if balance < totalCost then
		onAccept = fn
	end

	v9.onAccept = onAccept
	v9.totalCost = v2.totalCost
	v9.isDisabled = FFlagFixVP8143 and state2
		or #v2.items == 0
		or FFlagAXAddPlusUpsellToBulkPurchase and v2.disablePurchase == true
	local purchaseButtonRef

	if FFlagFixVP8143 then
		purchaseButtonRef = ref
	end

	v9.purchaseButtonRef = purchaseButtonRef
	v9.discountInformation = v2.discountInformation

	if not FFlagAXAddPlusUpsellToBulkPurchase then
		shouldShowBlackbirdUpsellBanner = nil
	end

	v9.shouldShowBlackbirdUpsellBanner = shouldShowBlackbirdUpsellBanner

	if not FFlagAXAddPlusUpsellToBulkPurchase then
		blackbirdUpsellBannerProductInfo = nil
	end

	v9.blackbirdUpsellBannerProductInfo = blackbirdUpsellBannerProductInfo

	if not FFlagAXAddPlusUpsellToBulkPurchase then
		onBlackbirdUpsellActivated = nil
	end

	v9.onBlackbirdUpsellActivated = onBlackbirdUpsellActivated
	local offerData

	if FFlagAXAddOffersToBulkPurchase then
		offerData = v2.offerData
	end

	v9.offerData = offerData

	if not FFlagAXAddOffersToBulkPurchase then
		toggleOfferSelected = nil
	end

	v9.toggleOfferSelected = toggleOfferSelected
	local isTestPurchase

	if FFlagBulkPurchaseTestPurchaseHint then
		isTestPurchase = RunService:IsStudio()
	end

	v9.isTestPurchase = isTestPurchase
	return v9
end

return useBulkPurchaseRequestProps
