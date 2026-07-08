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

local function PurchaseConfirmationModal(t1: {[any]: any}) -- line: 50
	-- upvalues: useNavigation (copy), useProfileAnalyticsContext (copy), useDispatch (copy), useProfileWrapperContext (copy), React (copy), AvatarSaveContext (copy), useLocalization (copy), FFlagSocialEnableProfileInspectAndBuyAnalytics (copy), EventNames (copy), PurchaseBulkItems (copy), HandlePurchaseItemsSuccess (copy), NumberLocalization (copy), LocalizationService (copy), getIconRichText (copy), IconName (copy), View (copy), FoundationText (copy), FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav (copy), InputHandlers (copy), Dialog (copy), DialogSize (copy), Checkbox (copy), InputSize (copy), EnumsOrientation (copy), ButtonVariant (copy), AppFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), FocusNavigationEventNameEnum (copy)
	local v37 = useNavigation()
	local v38 = useProfileAnalyticsContext()
	local v39 = useDispatch()
	local v40 = useProfileWrapperContext()
	local v41 = React.useContext(AvatarSaveContext)
	local v42 = t1.navigation.state.params or {}
	local v43 = v42.totalPrice or 0
	local v44 = v42.purchasableLineItems or {}
	local v45 = v42.userId or ""
	local v46 = v42.purchasedWearIds or {}
	local v47 = v42.ownedAssetIds or {}
	local v48 = v42.wearTypeMap or {}
	local v49 = useLocalization({
		buyTitle = "IAPExperience.PurchasePrompt.Header.BuyAvatar",
		buyAction = "IAPExperience.PurchasePrompt.Action.Buy",
		totalPrice = "IAPExperience.PurchasePrompt.Label.TotalPriceV2",
		wearAfterPurchase = "Feature.Catalog.Label.WearAvatarAfterPurchase",
		purchasePartialFailure = "Feature.Avatar.Heading.LooksPurchasePartialSuccess",
		purchaseSuccessSingular = {
			"Feature.Avatar.Message.LooksPurchaseSuccessSingular",
			numItems = 1
		},
		purchaseSuccessPlural = {
			"Feature.Avatar.Message.LooksPurchaseSuccessPlural",
			numItems = #v44
		}
	})
	local v50 = React.useMemo(function() -- line: 78
		-- upvalues: v49 (copy)
		return {
			purchaseSuccessSingular = v49.purchaseSuccessSingular,
			purchaseSuccessPlural = v49.purchaseSuccessPlural,
			purchasePartialFailure = v49.purchasePartialFailure
		}
	end, {
		v49.purchaseSuccessSingular,
		v49.purchaseSuccessPlural,
		v49.purchasePartialFailure
	})
	local v51, v52 = React.useState(false)
	local v53, v54 = React.useState(true)
	local v55 = React.useCallback(function() -- line: 93
		-- upvalues: v51 (copy), v37 (copy)
		if v51 then
			return
		end

		v37.goBack()
	end, {
		v51,
		v37
	})
	local v56 = React.useCallback(function() -- line: 101
		-- upvalues: v51 (copy), v44 (copy), v52 (copy), FFlagSocialEnableProfileInspectAndBuyAnalytics (copy), v38 (copy), EventNames (copy), v40 (copy), PurchaseBulkItems (copy), v45 (copy), HandlePurchaseItemsSuccess (copy), v53 (copy), v46 (copy), v47 (copy), v48 (copy), v41 (copy), v39 (copy), v50 (copy), v37 (copy)
		if v51 or #v44 == 0 then
			return
		end

		v52(true)

		if FFlagSocialEnableProfileInspectAndBuyAnalytics then
			v38.fireAnalyticsEvent(EventNames.InspectAvatarPurchaseConfirmed, {
				profileSessionId = v40.profileSessionId
			})
		else
			v38.fireAnalyticsEvent(EventNames.CatalogItemOpened, {
				btnContext = "InspectAvatarBuyAll"
			})
		end

		PurchaseBulkItems({
			userId = v45,
			lineItems = v44
		}):andThen(function(p1) -- line: 120
			-- upvalues: HandlePurchaseItemsSuccess (copy), v53 (copy), v46 (copy), v47 (copy), v48 (copy), v40 (copy), v41 (copy), v39 (copy), v50 (copy)
			HandlePurchaseItemsSuccess({
				result = p1,
				isWearAfterPurchaseChecked = v53,
				purchasedWearIds = v46,
				ownedAssetIds = v47,
				wearTypeMap = v48,
				profileWrapperContext = v40,
				avatarSaveContext = v41,
				dispatch = v39,
				localized = v50
			})
		end):finally(function() -- line: 132
			-- upvalues: v52 (copy), v37 (copy)
			v52(false)
			v37.goBack()
		end)
	end, {
		v51,
		v44,
		v45,
		v46,
		v47,
		v48,
		v53,
		v38,
		v37,
		v39,
		v50,
		v40,
		v41
	})
	local v57 = React.useMemo(function() -- line: 154
		-- upvalues: NumberLocalization (copy), v43 (copy), LocalizationService (copy), getIconRichText (copy), IconName (copy)
		local v61 = NumberLocalization.localize(v43, LocalizationService.RobloxLocaleId)

		return `{ getIconRichText(IconName.Robux) } { v61 }`
	end, {
		v43,
		LocalizationService.RobloxLocaleId
	})
	local v58 = React.createElement(View, {
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
					Text = v49.totalPrice
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
					Text = v57
				})
			})
		})
	})
	local v59 = if not FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav then nil else React.useMemo(function() -- line: 193
		-- upvalues: InputHandlers (copy), v55 (copy)
		return InputHandlers.onRelease(function(p2) -- line: 194
			-- upvalues: v55 (copy)
			p2:cancel()
			v55()
		end)
	end, { v55 })
	local v60 = React.createElement(Dialog.Root, {
		size = DialogSize.Small,
		onClose = v55,
		hasBackdrop = not not FFlagSocialEnableProfileInspectAndBuyConsoleFocusNav or nil
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v49.buyTitle
		}),
		DialogContent = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			Body = React.createElement(View, {
				tag = "col gap-medium auto-y size-full-0 align-x-left"
			}, {
				PriceTotal = v58,
				WearCheckbox = React.createElement(Checkbox, {
					LayoutOrder = 2,
					label = v49.wearAfterPurchase,
					size = InputSize.XSmall,
					isChecked = v53,
					onActivated = function() -- line: 222
						-- upvalues: v54 (copy), v53 (copy)
						v54(not v53)
					end,
					isDisabled = v51
				})
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			orientation = EnumsOrientation.Horizontal,
			actions = {{
				text = v49.buyAction,
				variant = ButtonVariant.Emphasis,
				onActivated = v56
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
					handler = v59
				}
			}
		}, {
			Dialog = v60
		})
	end

	return v60
end

return PurchaseConfirmationModal
