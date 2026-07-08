local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)
local ButtonVariant = require(ParentParentParent.Foundation).Enums.ButtonVariant
local View = Foundation.View
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local EnumsOrientation = Foundation.Enums.Orientation
local useTokens = Foundation.Hooks.useTokens
local LoggingProtocol = require(ParentParentParent.LoggingProtocol)
local UnifiedProductPurchaseCompletionModalShownCounter = require(ParentParent.Generic.Events.UnifiedPurchaseCompletionCounter).UnifiedProductPurchaseCompletionModalShownCounter
local useLocalization = require(ParentParentParent.Localization).Hooks.useLocalization
local formatTextWithParams = require(ParentParent.Utility.formatTextWithParams)
local useFocusNavigationRefs = require(ParentParent.Generic.Hooks.useFocusNavigationRefs)

local function UnifiedPurchaseCompletionModalV2(t1: {[any]: any}) -- line: 47
	-- upvalues: useLocalization (copy), useFocusNavigationRefs (copy), useTokens (copy), React (copy), Foundation (copy), LoggingProtocol (copy), UnifiedProductPurchaseCompletionModalShownCounter (copy), formatTextWithParams (copy), Dialog (copy), DialogSize (copy), View (copy), Icon (copy), FoundationText (copy), EnumsOrientation (copy), ButtonVariant (copy)
	local v20 = useLocalization({
		PurchaseCompleteTitle = "IAPExperience.PurchasePrompt.Title.PurchaseCompleted",
		PurchaseCompleteBody = "IAPExperience.PurchasePrompt.Body.PurchaseCompleted",
		ErrorTitle = "CoreScripts.PremiumModal.Title.Error",
		GenericErrorBody = "CoreScripts.PurchasePrompt.PurchaseFailed.UnknownFailureNoItemName",
		OkButtonText = "CoreScripts.PurchasePrompt.Button.OK",
		MultiItemPurchaseCompleteBody = "IAPExperience.PurchasePrompt.Body.PurchaseItemsSuccess"
	})
	local v21, v22 = useFocusNavigationRefs(t1.buttons.onClose or t1.buttons.onActivated, nil)
	local v23 = useTokens()
	local v24, v25 = React.useState(Foundation.Enums.IconName.CircleCheck)

	React.useEffect(function() -- line: 61
		-- upvalues: LoggingProtocol (copy), UnifiedProductPurchaseCompletionModalShownCounter (copy)
		LoggingProtocol.default:logRobloxTelemetryCounter(UnifiedProductPurchaseCompletionModalShownCounter, 1, {})
	end, {})

	local v26 = React.useMemo(function() -- line: 65
		-- upvalues: t1 (copy), v20 (copy)
		if t1.title then
			return t1.title
		end

		if t1.isError then
			return v20.ErrorTitle
		end

		return v20.PurchaseCompleteTitle
	end, {
		t1.title,
		t1.isError
	})
	local v27 = React.useMemo(function() -- line: 75
		-- upvalues: t1 (copy), v20 (copy), formatTextWithParams (copy)
		if t1.bodyText then
			return t1.bodyText
		end

		if t1.isError then
			return v20.GenericErrorBody
		end

		if t1.isMultiItem then
			return v20.MultiItemPurchaseCompleteBody
		end

		return formatTextWithParams(v20.PurchaseCompleteBody, {
			ITEM_NAME = t1.itemName or ""
		})
	end, {
		t1.bodyText,
		t1.isError,
		t1.isMultiItem,
		t1.itemName
	})

	React.useEffect(function() -- line: 89
		-- upvalues: t1 (copy), v25 (copy), Foundation (copy)
		if t1.isError then
			v25(Foundation.Enums.IconName.TriangleExclamation)

			return
		end

		v25(Foundation.Enums.IconName.CircleCheck)
	end, { t1.isError })

	return React.createElement(Dialog.Root, {
		closeOnClickOutside = true,
		disablePortal = false,
		size = DialogSize.Medium,
		onClose = if not t1.buttons.onClose then t1.buttons.onActivated else t1.buttons.onClose,
		ref = v21
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			text = v26
		}),
		DialogContent = React.createElement(Dialog.Content, nil, {
			Body = React.createElement(View, {
				tag = "col gap-large auto-y size-full-0 align-x-center align-y-center padding-top-small"
			}, {
				DialogIcon = React.createElement(Icon, {
					tag = "auto-xy",
					name = v24,
					size = v23.Size.Size_1200
				}),
				Message = React.createElement(FoundationText, {
					tag = "auto-xy text-body content-default text-align-x-left text-body-medium text-wrap",
					Text = v27
				})
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			orientation = EnumsOrientation.Horizontal,
			actions = {{
				isDisabled = false,
				text = if not t1.buttons or not t1.buttons.text then v20.OkButtonText else t1.buttons.text,
				variant = ButtonVariant.Emphasis,
				onActivated = t1.buttons.onActivated,
				ref = v22
			}}
		})
	})
end

return UnifiedPurchaseCompletionModalV2
