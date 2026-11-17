local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppHooks = require(parent.RobloxAppHooks)

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local getIsInsufficientRobuxError = AvatarExperienceCommon.Utils.getIsInsufficientRobuxError
local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local MarketplaceUnifiedAction = AvatarExperienceAnalytics.UnifiedEventLogEnums.MarketplaceUnifiedAction

require(ProfilePlatform.Common.Types)
local PurchaseBulkItems = require(ProfilePlatform.Networking.PurchaseBulkItems)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local HandlePurchaseItemsSuccess = require(ProfilePlatform.Components.InspectAvatar.HandlePurchaseItemsSuccess)
local sendProfilePurchaseEvents = require(ProfilePlatform.Analytics.sendProfilePurchaseEvents)

local FFlagProfileUnifiedPurchaseLogging = require(ProfilePlatform.Flags.FFlagProfileUnifiedPurchaseLogging)

local useRecentActivityPurchaseSelection = require(script.Parent.useRecentActivityPurchaseSelection)

local function useRecentActivityPurchase(data)
	local dispatch = useDispatch()
	local v = RobloxAppHooks.useLocalRobuxBalance()

	local profileWrapperContext = useProfileWrapperContext()

	local localUserId = data.localUserId
	local v2 = useRecentActivityPurchaseSelection(data.displayItems)
	local purchaseData = v2.purchaseData

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)

	local v3 = useLocalization({
		purchaseSuccessSingular = {
			"Feature.Avatar.Message.LooksPurchaseSuccessSingular",
			numItems = 1
		},
		purchaseSuccessPlural = {
			"Feature.Avatar.Message.LooksPurchaseSuccessPlural",
			numItems = purchaseData.count
		},
		purchasePartialFailure = "Feature.Avatar.Heading.LooksPurchasePartialSuccess",
		purchaseFailed = "CoreScripts.PurchasePrompt.PurchaseFailed.UnknownFailureNoItemName"
	})

	local localized = React.useMemo(function()
		return {
			purchaseSuccessSingular = v3.purchaseSuccessSingular,
			purchaseSuccessPlural = v3.purchaseSuccessPlural,
			purchasePartialFailure = v3.purchasePartialFailure
		}
	end, { v3.purchaseSuccessSingular, v3.purchaseSuccessPlural, v3.purchasePartialFailure })

	local onBuyAll = React.useCallback(function()
		if #purchaseData.lineItems == 0 or not localUserId then
			return
		end

		if v ~= nil and v < purchaseData.totalPrice then
			setState3(true)
			return
		end

		setState2(true)
	end, { purchaseData, localUserId, v })

	local onCancelPurchase = React.useCallback(function()
		setState2(false)
	end, {})

	local onDismissInsufficientRobux = React.useCallback(function()
		setState3(false)
	end, {})

	local onConfirmPurchase = React.useCallback(function()
		if state or #purchaseData.lineItems == 0 or not localUserId then
			return
		end

		setState(true)

		if FFlagProfileUnifiedPurchaseLogging then
			sendProfilePurchaseEvents(
				MarketplaceUnifiedAction.PURCHASE_ATTEMPT,
				purchaseData.purchasedItems or {},
				profileWrapperContext.profileType
			)
		end

		PurchaseBulkItems({ userId = localUserId, lineItems = purchaseData.lineItems }):andThen(function(p)
			local purchasedItems

			if FFlagProfileUnifiedPurchaseLogging then
				purchasedItems = purchaseData.purchasedItems
			end

			HandlePurchaseItemsSuccess({
				result = p,
				purchasedItems = purchasedItems,
				profileWrapperContext = profileWrapperContext,
				dispatch = dispatch,
				localized = localized
			})

			setState2(false)
			data.onClose()
		end):catch(function(p)
			setState2(false)

			if getIsInsufficientRobuxError(p) then
				setState3(true)
				return
			end

			dispatch(SetCurrentToastMessage({
				toastMessage = v3.purchaseFailed,
				isLocalized = true,
				toastType = "PurchaseMessage"
			}))

			data.onClose()
		end):finally(function()
			setState(false)
		end)
	end, {
		state,
		purchaseData,
		localUserId,
		profileWrapperContext,
		dispatch,
		localized,
		v3.purchaseFailed,
		data.onClose
	})

	return {
		selectedItems = v2.selectedItems,
		purchaseSummary = { totalPrice = purchaseData.totalPrice, count = purchaseData.count },
		isPurchasing = state,
		isConfirmingPurchase = state2,
		isShowingInsufficientRobux = state3,
		robuxBalance = v == nil and 0 or v,
		onToggleItem = v2.onToggleItem,
		onBuyAll = onBuyAll,
		onConfirmPurchase = onConfirmPurchase,
		onCancelPurchase = onCancelPurchase,
		onDismissInsufficientRobux = onDismissInsufficientRobux
	}
end

return useRecentActivityPurchase
