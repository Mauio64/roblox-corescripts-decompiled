local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local LocalizationService = game:GetService("LocalizationService")
local React = require(ProfilePlatformParent.React)
local Foundation = require(ProfilePlatformParent.Foundation)
local Navigation = require(ProfilePlatformParent.Navigation)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local useNavigation = Navigation.useNavigation
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local NumberLocalization = require(ProfilePlatformParent.Localization).NumberLocalization
local AvatarSaveContext = require(ProfilePlatformParent.AvatarExperienceSave).Context.AvatarSaveContext
local getIsInsufficientRobuxError = require(ProfilePlatformParent.AvatarExperienceCommon).Utils.getIsInsufficientRobuxError
local SetCurrentToastMessage = require(ProfilePlatformParent.ToastRodux).Actions.SetCurrentToastMessage
local RobloxAppHooks = require(ProfilePlatformParent.RobloxAppHooks)
local Enums = require(ProfilePlatform.Common.Enums)
local PurchaseBulkItems = require(ProfilePlatform.Networking.PurchaseBulkItems)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local HandlePurchaseItemsSuccess = require(script.Parent.HandlePurchaseItemsSuccess)
local FFlagSocialEnableProfileInspectAndBuyAnalytics = require(ProfilePlatformParent.SharedFlags).FFlagSocialEnableProfileInspectAndBuyAnalytics
local FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav = require(ProfilePlatformParent.SharedFlags).FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav
local FocusNavigationUtils = require(ProfilePlatformParent.FocusNavigationUtils)
local AppFocusRoot = FocusNavigationUtils.AppFocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require(ProfilePlatformParent.InputHandlers)
local View = Foundation.View
local FoundationText = Foundation.Text
local Checkbox = Foundation.Checkbox
local Dialog = Foundation.Dialog
local InputSize = Foundation.Enums.InputSize
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local EnumsOrientation = Foundation.Enums.Orientation
local IconName = Foundation.Enums.IconName
local getIconRichText = Foundation.Utility.getIconRichText

local function PurchaseConfirmationModal(t1: {[any]: any}) -- line: 56
	-- upvalues: useNavigation (copy), useProfileAnalyticsContext (copy), useDispatch (copy), useProfileWrapperContext (copy), React (copy), AvatarSaveContext (copy), RobloxAppHooks (copy), Enums (copy), useLocalization (copy), FFlagSocialEnableProfileInspectAndBuyAnalytics (copy), EventNames (copy), PurchaseBulkItems (copy), HandlePurchaseItemsSuccess (copy), getIsInsufficientRobuxError (copy), SetCurrentToastMessage (copy), NumberLocalization (copy), LocalizationService (copy), getIconRichText (copy), IconName (copy), View (copy), FoundationText (copy), FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav (copy), InputHandlers (copy), Dialog (copy), DialogSize (copy), Checkbox (copy), InputSize (copy), EnumsOrientation (copy), ButtonVariant (copy), AppFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), FocusNavigationEventNameEnum (copy)
	local v41 = useNavigation()
	local v42 = useProfileAnalyticsContext()
	local v43 = useDispatch()
	local v44 = useProfileWrapperContext()
	local v45 = React.useContext(AvatarSaveContext)
	local v46 = t1.navigation.state.params or {}
	local v47 = v46.totalPrice or 0
	local v48 = v46.purchasableLineItems or {}
	local v49 = v46.userId or ""
	local v50 = v46.purchasedWearIds or {}
	local v51 = v46.ownedAssetIds or {}
	local v52 = v46.wearTypeMap or {}
	local v53 = RobloxAppHooks.useLocalRobuxBalance()
	local v54 = if v53 == nil then v46.robuxBalance or 0 else v53
	local v55 = React.useCallback(function() -- line: 73
		-- upvalues: v41 (copy), Enums (copy), v47 (copy), v54 (copy)
		v41.navigate(Enums.Screens.InsufficientRobuxDialog, {
			totalPrice = v47,
			robuxBalance = v54
		})
	end, {
		v41,
		v47,
		v54
	})
	local v56 = useLocalization({
		buyTitle = "IAPExperience.PurchasePrompt.Header.BuyAvatar",
		buyAction = "IAPExperience.PurchasePrompt.Action.Buy",
		totalPrice = "IAPExperience.PurchasePrompt.Label.TotalPriceV2",
		wearAfterPurchase = "Feature.Catalog.Label.WearAvatarAfterPurchase",
		purchasePartialFailure = "Feature.Avatar.Heading.LooksPurchasePartialSuccess",
		purchaseFailed = "CoreScripts.PurchasePrompt.PurchaseFailed.UnknownFailureNoItemName",
		purchaseSuccessSingular = {
			"Feature.Avatar.Message.LooksPurchaseSuccessSingular",
			numItems = 1
		},
		purchaseSuccessPlural = {
			"Feature.Avatar.Message.LooksPurchaseSuccessPlural",
			numItems = #v48
		}
	})
	local v57 = React.useMemo(function() -- line: 94
		-- upvalues: v56 (copy)
		return {
			purchaseSuccessSingular = v56.purchaseSuccessSingular,
			purchaseSuccessPlural = v56.purchaseSuccessPlural,
			purchasePartialFailure = v56.purchasePartialFailure
		}
	end, {
		v56.purchaseSuccessSingular,
		v56.purchaseSuccessPlural,
		v56.purchasePartialFailure
	})
	local v58, v59 = React.useState(false)
	local v60, v61 = React.useState(true)
	local v62 = React.useCallback(function() -- line: 109
		-- upvalues: v58 (copy), v41 (copy)
		if v58 then
			return
		end

		v41.goBack()
	end, {
		v58,
		v41
	})
	local v63 = React.useCallback(function() -- line: 117
		-- upvalues: v58 (copy), v48 (copy), v59 (copy), FFlagSocialEnableProfileInspectAndBuyAnalytics (copy), v42 (copy), EventNames (copy), v44 (copy), PurchaseBulkItems (copy), v49 (copy), HandlePurchaseItemsSuccess (copy), v60 (copy), v50 (copy), v51 (copy), v52 (copy), v45 (copy), v43 (copy), v57 (copy), v41 (copy), getIsInsufficientRobuxError (copy), v55 (copy), SetCurrentToastMessage (copy), v56 (copy)
		if v58 or #v48 == 0 then
			return
		end

		v59(true)

		if FFlagSocialEnableProfileInspectAndBuyAnalytics then
			v42.fireAnalyticsEvent(EventNames.InspectAvatarPurchaseConfirmed, {
				profileSessionId = v44.profileSessionId
			})
		else
			v42.fireAnalyticsEvent(EventNames.CatalogItemOpened, {
				btnContext = "InspectAvatarBuyAll"
			})
		end

		PurchaseBulkItems({
			userId = v49,
			lineItems = v48
		}):andThen(function(p1) -- line: 138
			-- upvalues: HandlePurchaseItemsSuccess (copy), v60 (copy), v50 (copy), v51 (copy), v52 (copy), v44 (copy), v45 (copy), v43 (copy), v57 (copy), v41 (copy)
			HandlePurchaseItemsSuccess({
				result = p1,
				isWearAfterPurchaseChecked = v60,
				purchasedWearIds = v50,
				ownedAssetIds = v51,
				wearTypeMap = v52,
				profileWrapperContext = v44,
				avatarSaveContext = v45,
				dispatch = v43,
				localized = v57
			})
			v41.goBack()
		end):catch(function(p2) -- line: 152
			-- upvalues: getIsInsufficientRobuxError (copy), v55 (copy), v43 (copy), SetCurrentToastMessage (copy), v56 (copy), v41 (copy)
			if getIsInsufficientRobuxError(p2) then
				v55()

				return
			end

			v43(SetCurrentToastMessage({
				isLocalized = true,
				toastType = "PurchaseMessage",
				toastMessage = v56.purchaseFailed
			}))
			v41.goBack()
		end):finally(function() -- line: 164
			-- upvalues: v59 (copy)
			v59(false)
		end)
	end, {
		v58,
		v48,
		v49,
		v50,
		v51,
		v52,
		v60,
		v42,
		v41,
		v43,
		v57,
		v44,
		v45,
		v55,
		v56.purchaseFailed
	})
	local v64 = React.useMemo(function() -- line: 187
		-- upvalues: NumberLocalization (copy), v47 (copy), LocalizationService (copy), getIconRichText (copy), IconName (copy)
		local v68 = NumberLocalization.localize(v47, LocalizationService.RobloxLocaleId)

		return `{ getIconRichText(IconName.Robux) } { v68 }`
	end, {
		v47,
		LocalizationService.RobloxLocaleId
	})
	local v65 = React.createElement(View, {
		LayoutOrder = 1,
		tag = "size-full-1300 padding-left-xxsmall padding-right-xxsmall padding-top-small padding-bottom-large"
	}, {
		BorderContainer = React.createElement(View, {
			tag = "auto-xy align-y-center align-x-center radius-medium padding-x-large row stroke-default padding-y-xsmall"
		}, {
			LeftSide = React.createElement(View, {
				LayoutOrder = 1,
				tag = "row align-y-center gap-small padding-y-xsmall",
				Size = UDim2.new(0.5, 0, 1, 0)
			}, {
				Label = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "auto-xy text-title-medium content-default text-align-x-left padding-y-xsmall",
					Text = v56.totalPrice
				})
			}),
			RightSide = React.createElement(View, {
				LayoutOrder = 2,
				tag = "row align-y-center align-x-right gap-large padding-y-xsmall",
				Size = UDim2.new(0.5, 0, 1, 0)
			}, {
				Price = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "auto-xy text-title-medium content-emphasis text-align-x-right padding-y-xsmall",
					RichText = true,
					Text = v64
				})
			})
		})
	})
	local v66 = if not FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav then nil else React.useMemo(function() -- line: 226
		-- upvalues: InputHandlers (copy), v62 (copy)
		return InputHandlers.onRelease(function(p3) -- line: 227
			-- upvalues: v62 (copy)
			p3:cancel()
			v62()
		end)
	end, { v62 })
	local v67 = React.createElement(Dialog.Root, {
		size = DialogSize.Small,
		onClose = v62,
		hasBackdrop = not not FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav or nil
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v56.buyTitle
		}),
		DialogContent = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			Body = React.createElement(View, {
				tag = "col gap-medium auto-y size-full-0 align-x-left"
			}, {
				PriceTotal = v65,
				WearCheckbox = React.createElement(Checkbox, {
					LayoutOrder = 2,
					label = v56.wearAfterPurchase,
					size = InputSize.XSmall,
					isChecked = v60,
					onActivated = function() -- line: 255
						-- upvalues: v61 (copy), v60 (copy)
						v61(not v60)
					end,
					isDisabled = v58
				})
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			orientation = EnumsOrientation.Horizontal,
			actions = {{
				text = v56.buyAction,
				variant = ButtonVariant.Emphasis,
				onActivated = v63
			}}
		})
	})

	if FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav then
		return React.createElement(AppFocusRoot, {
			isAutoFocusRoot = true,
			isIsolated = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
			customEventHandlers = {
				[FocusNavigationEventNameEnum.NavigateBack] = {
					handler = v66
				}
			}
		}, {
			Dialog = v67
		})
	end

	return v67
end

return PurchaseConfirmationModal
