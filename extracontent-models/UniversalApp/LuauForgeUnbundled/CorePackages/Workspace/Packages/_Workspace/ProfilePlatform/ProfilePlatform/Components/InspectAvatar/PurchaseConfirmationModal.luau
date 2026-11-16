local LocalizationService = game:GetService("LocalizationService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")

local useNavigation = Navigation.useNavigation
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local numberLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").NumberLocalization

local avatarSaveContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AvatarExperienceSave").Context.AvatarSaveContext

local getIsInsufficientRobuxError = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AvatarExperienceCommon").Utils.getIsInsufficientRobuxError
local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ToastRodux").Actions.SetCurrentToastMessage
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks")

local marketplaceUnifiedAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AvatarExperienceAnalytics").UnifiedEventLogEnums.MarketplaceUnifiedAction

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local PurchaseBulkItems = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/PurchaseBulkItems")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local HandlePurchaseItemsSuccess = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/InspectAvatar/HandlePurchaseItemsSuccess")
local sendProfilePurchaseEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/sendProfilePurchaseEvents")

local FFlagProfileUnifiedPurchaseLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileUnifiedPurchaseLogging")

local fFlagSocialEnableProfileInspectAndBuyAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSocialEnableProfileInspectAndBuyAnalytics

local fFlagSocialEnableProfileInspectAndBuyConsoleFocusNav = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav
local FFlagProfileInspectAndBuyAutoFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileInspectAndBuyAutoFocus")

local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ReactFocusNavigation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/FocusNavigationUtils")
local appFocusRoot = FocusNavigationUtils.AppFocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/InputHandlers")

local view = Foundation.View
local text = Foundation.Text
local checkbox = Foundation.Checkbox
local dialog = Foundation.Dialog
local inputSize = Foundation.Enums.InputSize
local dialogSize = Foundation.Enums.DialogSize
local buttonVariant = Foundation.Enums.ButtonVariant
local orientation = Foundation.Enums.Orientation
local iconName = Foundation.Enums.IconName
local getIconRichText = Foundation.Utility.getIconRichText

local function PurchaseConfirmationModal(p2)
	local v5 = useNavigation()
	local v6 = useProfileAnalyticsContext()
	local v7 = useDispatch()
	local v8 = useProfileWrapperContext()
	local v9 = React.useContext(avatarSaveContext)

	local params = p2.navigation.state.params or {}
	local totalPrice = params.totalPrice or 0
	local purchasableLineItems = params.purchasableLineItems or {}
	local purchasedItems = if FFlagProfileUnifiedPurchaseLogging then params.purchasedItems else nil
	local userId = params.userId or ""
	local purchasedWearIds = params.purchasedWearIds or {}
	local ownedAssetIds = params.ownedAssetIds or {}
	local wearTypeMap = params.wearTypeMap or {}
	local v10 = RobloxAppHooks.useLocalRobuxBalance()
	local robuxBalance = v10 == nil and (params.robuxBalance or 0) or v10

	local v11 = React.useCallback(function()
		v5.navigate(Enums.Screens.InsufficientRobuxDialog, {
			totalPrice = totalPrice,
			robuxBalance = robuxBalance
		})
	end, { v5, totalPrice, robuxBalance })

	local v12 = useLocalization({
		buyTitle = "IAPExperience.PurchasePrompt.Header.BuyAvatar",
		buyAction = "IAPExperience.PurchasePrompt.Action.Buy",
		totalPrice = "IAPExperience.PurchasePrompt.Label.TotalPriceV2",
		wearAfterPurchase = "Feature.Catalog.Label.WearAvatarAfterPurchase",
		purchaseSuccessSingular = {
			"Feature.Avatar.Message.LooksPurchaseSuccessSingular",
			numItems = 1
		},
		purchaseSuccessPlural = {
			"Feature.Avatar.Message.LooksPurchaseSuccessPlural",
			numItems = #purchasableLineItems
		},
		purchasePartialFailure = "Feature.Avatar.Heading.LooksPurchasePartialSuccess",
		purchaseFailed = "CoreScripts.PurchasePrompt.PurchaseFailed.UnknownFailureNoItemName"
	})

	local v13 = React.useMemo(function()
		return {
			purchaseSuccessSingular = v12.purchaseSuccessSingular,
			purchaseSuccessPlural = v12.purchaseSuccessPlural,
			purchasePartialFailure = v12.purchasePartialFailure
		}
	end, { v12.purchaseSuccessSingular, v12.purchaseSuccessPlural, v12.purchasePartialFailure })

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(true)

	local v14 = React.useCallback(function()
		if state then
			return
		end

		v5.goBack()
	end, { state, v5 })

	local function fn()
		if state or #purchasableLineItems == 0 then
			return
		end

		setState(true)

		if fFlagSocialEnableProfileInspectAndBuyAnalytics then
			v6.fireAnalyticsEvent(EventNames.InspectAvatarPurchaseConfirmed, {
				profileSessionId = v8.profileSessionId
			})
		else
			v6.fireAnalyticsEvent(EventNames.CatalogItemOpened, {
				btnContext = "InspectAvatarBuyAll"
			})
		end

		if FFlagProfileUnifiedPurchaseLogging then
			sendProfilePurchaseEvents(marketplaceUnifiedAction.PURCHASE_ATTEMPT, purchasedItems or {}, v8.profileType)
		end

		PurchaseBulkItems({ userId = userId, lineItems = purchasableLineItems }):andThen(function(p3)
			HandlePurchaseItemsSuccess({
				result = p3,
				isWearAfterPurchaseChecked = state2,
				purchasedWearIds = purchasedWearIds,
				ownedAssetIds = ownedAssetIds,
				wearTypeMap = wearTypeMap,
				purchasedItems = if FFlagProfileUnifiedPurchaseLogging then purchasedItems else nil,
				profileWrapperContext = v8,
				avatarSaveContext = v9,
				dispatch = v7,
				localized = v13
			})

			v5.goBack()
		end):catch(function(p3)
			if getIsInsufficientRobuxError(p3) then
				v11()
				return
			end

			v7(setCurrentToastMessage({
				toastMessage = v12.purchaseFailed,
				isLocalized = true,
				toastType = "PurchaseMessage"
			}))

			v5.goBack()
		end):finally(function()
			setState(false)
		end)
	end

	local v17 = React.useCallback(fn, {
		state,
		purchasableLineItems,
		userId,
		purchasedWearIds,
		ownedAssetIds,
		wearTypeMap,
		state2,
		v6,
		v5,
		v7,
		v13,
		v8,
		v9,
		v11,
		v12.purchaseFailed,
		if FFlagProfileUnifiedPurchaseLogging then purchasedItems else nil
	})

	local v18 = React.useMemo(function()
		local localize = numberLocalization.localize(totalPrice, LocalizationService.RobloxLocaleId)
		return `{getIconRichText(iconName.Robux)} {localize}`
	end, { totalPrice, LocalizationService.RobloxLocaleId })

	local element = React.createElement(
		view,
		{
			LayoutOrder = 1,
			tag = "size-full-1300 padding-left-xxsmall padding-right-xxsmall padding-top-small padding-bottom-large"
		},
		{
			BorderContainer = React.createElement(
				view,
				{
					tag = "auto-xy align-y-center align-x-center radius-medium padding-x-large row stroke-default padding-y-xsmall"
				},
				{
					LeftSide = React.createElement(
						view,
						{
							LayoutOrder = 1,
							tag = "row align-y-center gap-small padding-y-xsmall",
							Size = UDim2.new(0.5, 0, 1, 0)
						},
						{
							Label = React.createElement(text, {
								LayoutOrder = 1,
								Text = v12.totalPrice,
								tag = "auto-xy text-title-medium content-default text-align-x-left padding-y-xsmall"
							})
						}
					),
					RightSide = React.createElement(
						view,
						{
							LayoutOrder = 2,
							tag = "row align-y-center align-x-right gap-large padding-y-xsmall",
							Size = UDim2.new(0.5, 0, 1, 0)
						},
						{
							Price = React.createElement(text, {
								LayoutOrder = 1,
								Text = v18,
								tag = "auto-xy text-title-medium content-emphasis text-align-x-right padding-y-xsmall",
								RichText = true
							})
						}
					)
				}
			)
		}
	)
	local v19

	if fFlagSocialEnableProfileInspectAndBuyConsoleFocusNav then
		v19 = React.useMemo(function()
			return InputHandlers.onRelease(function(object)
				object:cancel()
				v14()
			end)
		end, { v14 })
	end

	local v20, v21

	if FFlagProfileInspectAndBuyAutoFocus then
		v20, v21 = ReactFocusNavigation.useDefaultFocusBehavior()
	end

	local createElement = React.createElement
	local root = dialog.Root
	local v22 = { size = dialogSize.Small, onClose = v14, ref = 0, hasBackdrop = 0 }

	if not FFlagProfileInspectAndBuyAutoFocus then
		v21 = nil
	end

	v22.ref = v21

	v22.hasBackdrop = fFlagSocialEnableProfileInspectAndBuyConsoleFocusNav and true or nil
	local v23 = {
		DialogTitle = React.createElement(dialog.Title, {
			LayoutOrder = 1,
			text = v12.buyTitle
		}),
		DialogContent = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
			Body = React.createElement(view, {
				tag = "col gap-medium auto-y size-full-0 align-x-left"
			}, {
				PriceTotal = element,
				WearCheckbox = React.createElement(checkbox, {
					LayoutOrder = 2,
					label = v12.wearAfterPurchase,
					size = inputSize.XSmall,
					isChecked = state2,
					onActivated = function()
						setState2(not state2)
					end,
					isDisabled = state
				})
			})
		}),
		DialogActions = 0
	}

	local createElement2 = React.createElement
	local actions = dialog.Actions
	local v24 = { LayoutOrder = 3, orientation = orientation.Horizontal, actions = 0 }

	local v26 = {
		text = v12.buyAction,
		variant = buttonVariant.Emphasis,
		onActivated = v17,
		ref = 0
	}

	if not FFlagProfileInspectAndBuyAutoFocus then
		v20 = nil
	end

	v26.ref = v20
	v24.actions = { v26 }
	v23.DialogActions = createElement2(actions, v24)
	local element2 = createElement(root, v22, v23)

	if not fFlagSocialEnableProfileInspectAndBuyConsoleFocusNav then
		return element2
	end

	return React.createElement(appFocusRoot, {
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.CentralOverlay,
		isAutoFocusRoot = true,
		isIsolated = true,
		customEventHandlers = {
			[focusNavigationEventNameEnum.NavigateBack] = { handler = v19 }
		}
	}, { Dialog = element2 })
end

return PurchaseConfirmationModal
