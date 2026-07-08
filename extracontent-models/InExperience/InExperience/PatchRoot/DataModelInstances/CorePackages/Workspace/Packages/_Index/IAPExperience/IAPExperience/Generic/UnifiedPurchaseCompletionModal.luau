local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)
local ButtonVariant = require(ParentParentParent.Foundation).Enums.ButtonVariant
local FillBehavior = require(ParentParentParent.Foundation).Enums.FillBehavior
local View = Foundation.View
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local Sheet = Foundation.Sheet
local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue
local LoggingProtocol = require(ParentParentParent.LoggingProtocol)
local UnifiedProductPurchaseCompletionModalShownCounter = require(ParentParent.Generic.Events.UnifiedPurchaseCompletionCounter).UnifiedProductPurchaseCompletionModalShownCounter
local useLocalization = require(ParentParentParent.Localization).Hooks.useLocalization
local formatTextWithParams = require(ParentParent.Utility.formatTextWithParams)
local useFocusNavigationRefs = require(ParentParent.Generic.Hooks.useFocusNavigationRefs)
local useInitialButtonDisableDelay = require(ParentParent.Generic.Hooks.useInitialButtonDisableDelay)
local UNIFIED_PURCHASE_COMPLETION_MODAL_MIN_HEIGHT_PIXELS = require(ParentParent.Generic.Constants).UNIFIED_PURCHASE_COMPLETION_MODAL_MIN_HEIGHT_PIXELS
local FFlagUnifiedPurchaseModalUiImprovements = require(ParentParent.Flags.FFlagUnifiedPurchaseModalUiImprovements)
local FFlagAddFocusNavigationToUnifiedPurchase = require(ParentParent.Flags.FFlagAddFocusNavigationToUnifiedPurchase)

local function UnifiedPurchaseCompletionModal(t1: {[any]: any}) -- line: 58
	-- upvalues: useLocalization (copy), FFlagAddFocusNavigationToUnifiedPurchase (copy), useFocusNavigationRefs (copy), useInitialButtonDisableDelay (copy), useTokens (copy), React (copy), Foundation (copy), LoggingProtocol (copy), UnifiedProductPurchaseCompletionModalShownCounter (copy), formatTextWithParams (copy), Sheet (copy), FFlagUnifiedPurchaseModalUiImprovements (copy), useScaledValue (copy), UNIFIED_PURCHASE_COMPLETION_MODAL_MIN_HEIGHT_PIXELS (copy), FoundationText (copy), View (copy), Icon (copy), FillBehavior (copy), ButtonVariant (copy)
	local v24 = useLocalization({
		PurchaseCompleteTitle = "IAPExperience.PurchasePrompt.Title.PurchaseCompleted",
		PurchaseCompleteBody = "IAPExperience.PurchasePrompt.Body.PurchaseCompleted",
		ErrorTitle = "CoreScripts.PremiumModal.Title.Error",
		GenericErrorBody = "CoreScripts.PurchasePrompt.PurchaseFailed.UnknownFailureNoItemName",
		OkButtonText = "CoreScripts.PurchasePrompt.Button.OK",
		MultiItemPurchaseCompleteBody = "IAPExperience.PurchasePrompt.Body.PurchaseItemsSuccess"
	})
	local v25 = nil
	local v26 = nil
	local v27 = false

	if FFlagAddFocusNavigationToUnifiedPurchase then
		v25, v26 = useFocusNavigationRefs(t1.buttons.onClose, nil)
		v27 = useInitialButtonDisableDelay()
	end

	local v28 = useTokens()
	local v29, v30 = React.useState(Foundation.Enums.IconName.CircleCheck)

	React.useEffect(function() -- line: 77
		-- upvalues: LoggingProtocol (copy), UnifiedProductPurchaseCompletionModalShownCounter (copy)
		LoggingProtocol.default:logRobloxTelemetryCounter(UnifiedProductPurchaseCompletionModalShownCounter, 1, {})
	end, {})

	local v31 = React.useMemo(function() -- line: 81
		-- upvalues: t1 (copy), v24 (copy)
		if t1.title then
			return t1.title
		end

		if t1.isError then
			return v24.ErrorTitle
		end

		return v24.PurchaseCompleteTitle
	end, {
		t1.title,
		t1.isError
	})
	local v32 = React.useMemo(function() -- line: 91
		-- upvalues: t1 (copy), v24 (copy), formatTextWithParams (copy)
		if t1.bodyText then
			return t1.bodyText
		end

		if t1.isError then
			return v24.GenericErrorBody
		end

		if t1.isMultiItem then
			return v24.MultiItemPurchaseCompleteBody
		end

		return formatTextWithParams(v24.PurchaseCompleteBody, {
			ITEM_NAME = t1.itemName
		})
	end, {
		t1.bodyText,
		t1.isError,
		t1.isMultiItem,
		t1.itemName
	})
	local v33 = if not t1.buttons or not t1.buttons.text then v24.OkButtonText else t1.buttons.text

	React.useEffect(function() -- line: 112
		-- upvalues: t1 (copy), v30 (copy), Foundation (copy)
		if t1.isError then
			v30(Foundation.Enums.IconName.TriangleExclamation)

			return
		end

		v30(Foundation.Enums.IconName.CircleCheck)
	end, { t1.isError })

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		onClose = if not t1.buttons.onClose then t1.buttons.onActivated else t1.buttons.onClose,
		snapPoints = if not FFlagUnifiedPurchaseModalUiImprovements then {
			0.4,
			0.8
		} else {
			useScaledValue(UNIFIED_PURCHASE_COMPLETION_MODAL_MIN_HEIGHT_PIXELS),
			0.8
		},
		ref = if not FFlagAddFocusNavigationToUnifiedPurchase then nil else if not v27 then v25 else nil
	}, {
		Header = React.createElement(Sheet.Header, {}, {
			Title = React.createElement(FoundationText, {
				tag = "auto-xy text-heading-small content-default text-align-x-left",
				Text = v31
			})
		}),
		Content = React.createElement(Sheet.Content, {
			LayoutOrder = 2
		}, {
			Body = React.createElement(View, {
				LayoutOrder = 1,
				tag = not FFlagUnifiedPurchaseModalUiImprovements and "col gap-medium auto-y size-full-0 align-x-center align-y-center" or "col gap-large auto-y size-full-0 align-x-center align-y-center padding-top-small"
			}, {
				Icon = React.createElement(Icon, {
					tag = "auto-xy",
					name = v29,
					size = v28.Size.Size_1200
				}),
				Message = React.createElement(FoundationText, {
					tag = "auto-xy text-body content-default text-align-x-left text-body-medium text-wrap",
					Text = v32
				})
			})
		}),
		Actions = React.createElement(Sheet.Actions, {
			LayoutOrder = 3
		}, { React.createElement(Foundation.Button, {
			text = v33,
			onActivated = t1.buttons.onActivated,
			fillBehavior = FillBehavior.Fill,
			variant = ButtonVariant.Emphasis,
			ref = if not FFlagAddFocusNavigationToUnifiedPurchase then nil else v26,
			isDisabled = v27
		}) })
	})
end

return UnifiedPurchaseCompletionModal
