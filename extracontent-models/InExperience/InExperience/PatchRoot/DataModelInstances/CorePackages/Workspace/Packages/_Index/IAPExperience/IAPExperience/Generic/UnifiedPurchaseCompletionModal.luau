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

local function UnifiedPurchaseCompletionModal(t1: {[any]: any}) -- line: 53
	-- upvalues: useLocalization (copy), useFocusNavigationRefs (copy), useInitialButtonDisableDelay (copy), useTokens (copy), React (copy), Foundation (copy), LoggingProtocol (copy), UnifiedProductPurchaseCompletionModalShownCounter (copy), formatTextWithParams (copy), Sheet (copy), useScaledValue (copy), UNIFIED_PURCHASE_COMPLETION_MODAL_MIN_HEIGHT_PIXELS (copy), FoundationText (copy), View (copy), Icon (copy), FillBehavior (copy), ButtonVariant (copy)
	local v22 = useLocalization({
		PurchaseCompleteTitle = "IAPExperience.PurchasePrompt.Title.PurchaseCompleted",
		PurchaseCompleteBody = "IAPExperience.PurchasePrompt.Body.PurchaseCompleted",
		ErrorTitle = "CoreScripts.PremiumModal.Title.Error",
		GenericErrorBody = "CoreScripts.PurchasePrompt.PurchaseFailed.UnknownFailureNoItemName",
		OkButtonText = "CoreScripts.PurchasePrompt.Button.OK",
		MultiItemPurchaseCompleteBody = "IAPExperience.PurchasePrompt.Body.PurchaseItemsSuccess"
	})
	local v23, v24 = useFocusNavigationRefs(t1.buttons.onClose, nil)
	local v25 = useInitialButtonDisableDelay()
	local v26 = useTokens()
	local v27, v28 = React.useState(Foundation.Enums.IconName.CircleCheck)

	React.useEffect(function() -- line: 70
		-- upvalues: LoggingProtocol (copy), UnifiedProductPurchaseCompletionModalShownCounter (copy)
		LoggingProtocol.default:logRobloxTelemetryCounter(UnifiedProductPurchaseCompletionModalShownCounter, 1, {})
	end, {})

	local v29 = React.useMemo(function() -- line: 74
		-- upvalues: t1 (copy), v22 (copy)
		if t1.title then
			return t1.title
		end

		if t1.isError then
			return v22.ErrorTitle
		end

		return v22.PurchaseCompleteTitle
	end, {
		t1.title,
		t1.isError
	})
	local v30 = React.useMemo(function() -- line: 84
		-- upvalues: t1 (copy), v22 (copy), formatTextWithParams (copy)
		if t1.bodyText then
			return t1.bodyText
		end

		if t1.isError then
			return v22.GenericErrorBody
		end

		if t1.isMultiItem then
			return v22.MultiItemPurchaseCompleteBody
		end

		return formatTextWithParams(v22.PurchaseCompleteBody, {
			ITEM_NAME = t1.itemName
		})
	end, {
		t1.bodyText,
		t1.isError,
		t1.isMultiItem,
		t1.itemName
	})
	local v31 = if not t1.buttons or not t1.buttons.text then v22.OkButtonText else t1.buttons.text

	React.useEffect(function() -- line: 105
		-- upvalues: t1 (copy), v28 (copy), Foundation (copy)
		if t1.isError then
			v28(Foundation.Enums.IconName.TriangleExclamation)

			return
		end

		v28(Foundation.Enums.IconName.CircleCheck)
	end, { t1.isError })

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		onClose = if not t1.buttons.onClose then t1.buttons.onActivated else t1.buttons.onClose,
		snapPoints = {
			useScaledValue(UNIFIED_PURCHASE_COMPLETION_MODAL_MIN_HEIGHT_PIXELS),
			0.8
		},
		ref = if not v25 then v23 else nil
	}, {
		Header = React.createElement(Sheet.Header, {}, {
			Title = React.createElement(FoundationText, {
				tag = "auto-xy text-heading-small content-default text-align-x-left",
				Text = v29
			})
		}),
		Content = React.createElement(Sheet.Content, {
			LayoutOrder = 2
		}, {
			Body = React.createElement(View, {
				tag = "col gap-large auto-y size-full-0 align-x-center align-y-center padding-top-small",
				LayoutOrder = 1
			}, {
				Icon = React.createElement(Icon, {
					tag = "auto-xy",
					name = v27,
					size = v26.Size.Size_1200
				}),
				Message = React.createElement(FoundationText, {
					tag = "auto-xy text-body content-default text-align-x-left text-body-medium text-wrap",
					Text = v30
				})
			})
		}),
		Actions = React.createElement(Sheet.Actions, {
			LayoutOrder = 3
		}, { React.createElement(Foundation.Button, {
			text = v31,
			onActivated = t1.buttons.onActivated,
			fillBehavior = FillBehavior.Fill,
			variant = ButtonVariant.Emphasis,
			ref = v24,
			isDisabled = v25
		}) })
	})
end

return UnifiedPurchaseCompletionModal
