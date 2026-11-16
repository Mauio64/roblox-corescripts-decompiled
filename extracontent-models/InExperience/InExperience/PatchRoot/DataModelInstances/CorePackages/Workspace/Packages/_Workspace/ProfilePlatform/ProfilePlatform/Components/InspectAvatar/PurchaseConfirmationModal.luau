local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local LocalizationService = game:GetService("LocalizationService")

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Navigation = require(parent.Navigation)
local RoactUtils = require(parent.RoactUtils)

local useNavigation = Navigation.useNavigation
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Localization2 = require(parent.Localization)
local NumberLocalization = Localization2.NumberLocalization

local AvatarExperienceSave = require(parent.AvatarExperienceSave)
local AvatarSaveContext = AvatarExperienceSave.Context.AvatarSaveContext

local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local getIsInsufficientRobuxError = AvatarExperienceCommon.Utils.getIsInsufficientRobuxError
local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local RobloxAppHooks = require(parent.RobloxAppHooks)

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local MarketplaceUnifiedAction = AvatarExperienceAnalytics.UnifiedEventLogEnums.MarketplaceUnifiedAction

local Enums = require(ProfilePlatform.Common.Enums)
local PurchaseBulkItems = require(ProfilePlatform.Networking.PurchaseBulkItems)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local HandlePurchaseItemsSuccess = require(script.Parent.HandlePurchaseItemsSuccess)
local sendProfilePurchaseEvents = require(ProfilePlatform.Analytics.sendProfilePurchaseEvents)

local FFlagProfileUnifiedPurchaseLogging = require(ProfilePlatform.Flags.FFlagProfileUnifiedPurchaseLogging)

local SharedFlags = require(parent.SharedFlags)
local FFlagSocialEnableProfileInspectAndBuyAnalytics = SharedFlags.FFlagSocialEnableProfileInspectAndBuyAnalytics

local SharedFlags2 = require(parent.SharedFlags)
local FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav = SharedFlags2.FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav
local FFlagProfileInspectAndBuyAutoFocus = require(ProfilePlatform.Flags.FFlagProfileInspectAndBuyAutoFocus)

local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local AppFocusRoot = FocusNavigationUtils.AppFocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require(parent.InputHandlers)

local View = Foundation.View
local Text = Foundation.Text
local Checkbox = Foundation.Checkbox
local Dialog = Foundation.Dialog
local InputSize = Foundation.Enums.InputSize
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local Orientation = Foundation.Enums.Orientation
local IconName = Foundation.Enums.IconName
local getIconRichText = Foundation.Utility.getIconRichText

local function PurchaseConfirmationModal(p)
	local v = useNavigation()
	local v2 = useProfileAnalyticsContext()
	local dispatch = useDispatch()
	local profileWrapperContext = useProfileWrapperContext()
	local avatarSaveContext = React.useContext(AvatarSaveContext)

	local params = p.navigation.state.params or {}
	local totalPrice = params.totalPrice or 0
	local purchasableLineItems = params.purchasableLineItems or {}
	local purchasedItems

	if FFlagProfileUnifiedPurchaseLogging then
		purchasedItems = params.purchasedItems
	else
		purchasedItems = nil
	end

	local userId = params.userId or ""
	local purchasedWearIds = params.purchasedWearIds or {}
	local ownedAssetIds = params.ownedAssetIds or {}
	local wearTypeMap = params.wearTypeMap or {}
	local v3 = RobloxAppHooks.useLocalRobuxBalance()
	local robuxBalance = v3 == nil and (params.robuxBalance or 0) or v3

	local v4 = React.useCallback(function()
		v.navigate(Enums.Screens.InsufficientRobuxDialog, {
			totalPrice = totalPrice,
			robuxBalance = robuxBalance
		})
	end, { v, totalPrice, robuxBalance })

	local v5 = useLocalization({
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

	local localized = React.useMemo(function()
		return {
			purchaseSuccessSingular = v5.purchaseSuccessSingular,
			purchaseSuccessPlural = v5.purchaseSuccessPlural,
			purchasePartialFailure = v5.purchasePartialFailure
		}
	end, { v5.purchaseSuccessSingular, v5.purchaseSuccessPlural, v5.purchasePartialFailure })

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(true)

	local onClose = React.useCallback(function()
		if state then
			return
		end

		v.goBack()
	end, { state, v })

	local useCallback = React.useCallback
	local function fn()
		if state or #purchasableLineItems == 0 then
			return
		end

		setState(true)

		if FFlagSocialEnableProfileInspectAndBuyAnalytics then
			v2.fireAnalyticsEvent(EventNames.InspectAvatarPurchaseConfirmed, {
				profileSessionId = profileWrapperContext.profileSessionId
			})
		else
			v2.fireAnalyticsEvent(EventNames.CatalogItemOpened, {
				btnContext = "InspectAvatarBuyAll"
			})
		end

		if FFlagProfileUnifiedPurchaseLogging then
			sendProfilePurchaseEvents(
				MarketplaceUnifiedAction.PURCHASE_ATTEMPT,
				purchasedItems or {},
				profileWrapperContext.profileType
			)
		end

		PurchaseBulkItems({ userId = userId, lineItems = purchasableLineItems }):andThen(function(p2)
			local v6 = {
				result = p2,
				isWearAfterPurchaseChecked = state2,
				purchasedWearIds = purchasedWearIds,
				ownedAssetIds = ownedAssetIds,
				wearTypeMap = wearTypeMap,
				purchasedItems = nil,
				profileWrapperContext = nil,
				avatarSaveContext = nil,
				dispatch = nil,
				localized = nil
			}
			local purchasedItems2

			if FFlagProfileUnifiedPurchaseLogging then
				purchasedItems2 = purchasedItems
			end

			v6.purchasedItems = purchasedItems2
			v6.profileWrapperContext = profileWrapperContext
			v6.avatarSaveContext = avatarSaveContext
			v6.dispatch = dispatch
			v6.localized = localized
			HandlePurchaseItemsSuccess(v6)

			v.goBack()
		end):catch(function(p2)
			if getIsInsufficientRobuxError(p2) then
				v4()
				return
			end

			dispatch(SetCurrentToastMessage({
				toastMessage = v5.purchaseFailed,
				isLocalized = true,
				toastType = "PurchaseMessage"
			}))

			v.goBack()
		end):finally(function()
			setState(false)
		end)
	end

	local purchaseFailed = v5.purchaseFailed
	local v6

	if FFlagProfileUnifiedPurchaseLogging then
		v6 = purchasedItems
	end

	local onActivated = useCallback(fn, {
		state,
		purchasableLineItems,
		userId,
		purchasedWearIds,
		ownedAssetIds,
		wearTypeMap,
		state2,
		v2,
		v,
		dispatch,
		localized,
		profileWrapperContext,
		avatarSaveContext,
		v4,
		purchaseFailed,
		v6
	})

	local text = React.useMemo(function()
		local localize = NumberLocalization.localize(totalPrice, LocalizationService.RobloxLocaleId)
		return `{getIconRichText(IconName.Robux)} {localize}`
	end, { totalPrice, LocalizationService.RobloxLocaleId })

	local element = React.createElement(
		View,
		{
			LayoutOrder = 1,
			tag = "size-full-1300 padding-left-xxsmall padding-right-xxsmall padding-top-small padding-bottom-large"
		},
		{
			BorderContainer = React.createElement(
				View,
				{
					tag = "auto-xy align-y-center align-x-center radius-medium padding-x-large row stroke-default padding-y-xsmall"
				},
				{
					LeftSide = React.createElement(
						View,
						{
							LayoutOrder = 1,
							tag = "row align-y-center gap-small padding-y-xsmall",
							Size = UDim2.new(0.5, 0, 1, 0)
						},
						{
							Label = React.createElement(Text, {
								LayoutOrder = 1,
								Text = v5.totalPrice,
								tag = "auto-xy text-title-medium content-default text-align-x-left padding-y-xsmall"
							})
						}
					),
					RightSide = React.createElement(
						View,
						{
							LayoutOrder = 2,
							tag = "row align-y-center align-x-right gap-large padding-y-xsmall",
							Size = UDim2.new(0.5, 0, 1, 0)
						},
						{
							Price = React.createElement(Text, {
								LayoutOrder = 1,
								Text = text,
								tag = "auto-xy text-title-medium content-emphasis text-align-x-right padding-y-xsmall",
								RichText = true
							})
						}
					)
				}
			)
		}
	)
	local handler

	if FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav then
		handler = React.useMemo(function()
			return InputHandlers.onRelease(function(object)
				object:cancel()
				onClose()
			end)
		end, { onClose })
	end

	local ref, ref2

	if FFlagProfileInspectAndBuyAutoFocus then
		ref, ref2 = ReactFocusNavigation.useDefaultFocusBehavior()
	end

	local createElement = React.createElement
	local root = Dialog.Root
	local v7 = { size = DialogSize.Small, onClose = onClose, ref = 0, hasBackdrop = 0 }

	if not FFlagProfileInspectAndBuyAutoFocus then
		ref2 = nil
	end

	v7.ref = ref2

	v7.hasBackdrop = FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav and true or nil
	local v8 = {
		DialogTitle = React.createElement(Dialog.Title, { LayoutOrder = 1, text = v5.buyTitle }),
		DialogContent = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
			Body = React.createElement(View, {
				tag = "col gap-medium auto-y size-full-0 align-x-left"
			}, {
				PriceTotal = element,
				WearCheckbox = React.createElement(Checkbox, {
					LayoutOrder = 2,
					label = v5.wearAfterPurchase,
					size = InputSize.XSmall,
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
	local actions = Dialog.Actions
	local v9 = { LayoutOrder = 3, orientation = Orientation.Horizontal, actions = 0 }

	local v10 = {
		text = v5.buyAction,
		variant = ButtonVariant.Emphasis,
		onActivated = onActivated,
		ref = 0
	}

	if not FFlagProfileInspectAndBuyAutoFocus then
		ref = nil
	end

	v10.ref = ref
	v9.actions = { v10 }
	v8.DialogActions = createElement2(actions, v9)
	local element2 = createElement(root, v7, v8)

	if not FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav then
		return element2
	end

	return React.createElement(AppFocusRoot, {
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
		isAutoFocusRoot = true,
		isIsolated = true,
		customEventHandlers = {
			[FocusNavigationEventNameEnum.NavigateBack] = { handler = handler }
		}
	}, { Dialog = element2 })
end

return PurchaseConfirmationModal
