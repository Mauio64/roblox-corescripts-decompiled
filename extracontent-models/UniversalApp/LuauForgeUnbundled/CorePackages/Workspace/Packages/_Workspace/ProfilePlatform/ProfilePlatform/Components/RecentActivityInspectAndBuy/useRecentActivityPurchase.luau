local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks")

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization

local getIsInsufficientRobuxError = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AvatarExperienceCommon").Utils.getIsInsufficientRobuxError
local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ToastRodux").Actions.SetCurrentToastMessage

local marketplaceUnifiedAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AvatarExperienceAnalytics").UnifiedEventLogEnums.MarketplaceUnifiedAction

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")
local PurchaseBulkItems = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/PurchaseBulkItems")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local HandlePurchaseItemsSuccess = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/InspectAvatar/HandlePurchaseItemsSuccess")
local sendProfilePurchaseEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/sendProfilePurchaseEvents")

local FFlagProfileUnifiedPurchaseLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileUnifiedPurchaseLogging")

local useRecentActivityPurchaseSelection = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/RecentActivityInspectAndBuy/useRecentActivityPurchaseSelection")

local function useRecentActivityPurchase(data)
	local v5 = useDispatch()
	local v6 = RobloxAppHooks.useLocalRobuxBalance()

	local v7 = useProfileWrapperContext()

	local localUserId = data.localUserId
	local v8 = useRecentActivityPurchaseSelection(data.displayItems)
	local purchaseData = v8.purchaseData

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)

	local v9 = useLocalization({
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

	local v10 = React.useMemo(function()
		return {
			purchaseSuccessSingular = v9.purchaseSuccessSingular,
			purchaseSuccessPlural = v9.purchaseSuccessPlural,
			purchasePartialFailure = v9.purchasePartialFailure
		}
	end, { v9.purchaseSuccessSingular, v9.purchaseSuccessPlural, v9.purchasePartialFailure })

	local v11 = React.useCallback(function()
		if #purchaseData.lineItems == 0 or not localUserId then
			return
		end

		if v6 ~= nil and v6 < purchaseData.totalPrice then
			setState3(true)
			return
		end

		setState2(true)
	end, { purchaseData, localUserId, v6 })

	local v12 = React.useCallback(function()
		setState2(false)
	end, {})

	local v13 = React.useCallback(function()
		setState3(false)
	end, {})

	local v14 = React.useCallback(function()
		if state or #purchaseData.lineItems == 0 or not localUserId then
			return
		end

		setState(true)

		if FFlagProfileUnifiedPurchaseLogging then
			sendProfilePurchaseEvents(
				marketplaceUnifiedAction.PURCHASE_ATTEMPT,
				purchaseData.purchasedItems or {},
				v7.profileType
			)
		end

		PurchaseBulkItems({ userId = localUserId, lineItems = purchaseData.lineItems }):andThen(function(p2)
			local v17 = if FFlagProfileUnifiedPurchaseLogging then purchaseData.purchasedItems else nil
			HandlePurchaseItemsSuccess({
				result = p2,
				purchasedItems = v17,
				profileWrapperContext = v7,
				dispatch = v5,
				localized = v10
			})

			setState2(false)
			data.onClose()
		end):catch(function(p2)
			setState2(false)

			if getIsInsufficientRobuxError(p2) then
				setState3(true)
				return
			end

			v5(setCurrentToastMessage({
				toastMessage = v9.purchaseFailed,
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
		v7,
		v5,
		v10,
		v9.purchaseFailed,
		data.onClose
	})

	return {
		selectedItems = v8.selectedItems,
		purchaseSummary = {
			totalPrice = purchaseData.totalPrice,
			count = purchaseData.count
		},
		isPurchasing = state,
		isConfirmingPurchase = state2,
		isShowingInsufficientRobux = state3,
		robuxBalance = v6 == nil and 0 or v6,
		onToggleItem = v8.onToggleItem,
		onBuyAll = v11,
		onConfirmPurchase = v14,
		onCancelPurchase = v12,
		onDismissInsufficientRobux = v13
	}
end

return useRecentActivityPurchase
