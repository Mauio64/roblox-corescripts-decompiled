local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local Foundation = require(parent2.Foundation)
local Foundation2 = require(parent2.Foundation)
local ButtonVariant = Foundation2.Enums.ButtonVariant
local Foundation3 = require(parent2.Foundation)
local FillBehavior = Foundation3.Enums.FillBehavior
local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local Sheet = Foundation.Sheet
local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue

local LoggingProtocol = require(parent2.LoggingProtocol)
local UnifiedPurchaseCompletionCounter = require(parent.Generic.Events.UnifiedPurchaseCompletionCounter)

local UnifiedProductPurchaseCompletionModalShownCounter = UnifiedPurchaseCompletionCounter.UnifiedProductPurchaseCompletionModalShownCounter

local Localization = require(parent2.Localization)
local useLocalization = Localization.Hooks.useLocalization
local formatTextWithParams = require(parent.Utility.formatTextWithParams)

local useFocusNavigationRefs = require(parent.Generic.Hooks.useFocusNavigationRefs)
local useInitialButtonDisableDelay = require(parent.Generic.Hooks.useInitialButtonDisableDelay)

local Constants = require(parent.Generic.Constants)

local UNIFIED_PURCHASE_COMPLETION_MODAL_MIN_HEIGHT_PIXELS = Constants.UNIFIED_PURCHASE_COMPLETION_MODAL_MIN_HEIGHT_PIXELS

local function UnifiedPurchaseCompletionModal(props)
	local v = useLocalization({
		PurchaseCompleteTitle = "IAPExperience.PurchasePrompt.Title.PurchaseCompleted",
		PurchaseCompleteBody = "IAPExperience.PurchasePrompt.Body.PurchaseCompleted",
		ErrorTitle = "CoreScripts.PremiumModal.Title.Error",
		GenericErrorBody = "CoreScripts.PurchasePrompt.PurchaseFailed.UnknownFailureNoItemName",
		OkButtonText = "CoreScripts.PurchasePrompt.Button.OK",
		MultiItemPurchaseCompleteBody = "IAPExperience.PurchasePrompt.Body.PurchaseItemsSuccess"
	})

	local ref, ref2 = useFocusNavigationRefs(props.buttons.onClose, nil)

	local isDisabled = useInitialButtonDisableDelay()

	local v2 = useTokens()
	local state, setState = React.useState(Foundation.Enums.IconName.CircleCheck)

	React.useEffect(function()
		LoggingProtocol.default:logRobloxTelemetryCounter(UnifiedProductPurchaseCompletionModalShownCounter, 1, {})
	end, {})

	local text = React.useMemo(function()
		if props.title then
			return props.title
		end

		if props.isError then
			return v.ErrorTitle
		end

		return v.PurchaseCompleteTitle
	end, { props.title, props.isError })

	local text2 = React.useMemo(function()
		if props.bodyText then
			return props.bodyText
		end

		if props.isError then
			return v.GenericErrorBody
		end

		if props.isMultiItem then
			return v.MultiItemPurchaseCompleteBody
		end

		return formatTextWithParams(v.PurchaseCompleteBody, { ITEM_NAME = props.itemName })
	end, { props.bodyText, props.isError, props.isMultiItem, props.itemName })
	local text3

	if props.buttons and props.buttons.text then
		text3 = props.buttons.text
	else
		text3 = v.OkButtonText
	end

	React.useEffect(function()
		if props.isError then
			setState(Foundation.Enums.IconName.TriangleExclamation)
		else
			setState(Foundation.Enums.IconName.CircleCheck)
		end
	end, { props.isError })

	local createElement = React.createElement
	local root = Sheet.Root
	local onClose

	if props.buttons.onClose then
		onClose = props.buttons.onClose
	else
		onClose = props.buttons.onActivated
	end

	local v3 = {
		onClose = onClose,
		snapPoints = { useScaledValue(UNIFIED_PURCHASE_COMPLETION_MODAL_MIN_HEIGHT_PIXELS), 0.8 },
		preferCenterSheet = true,
		ref = 0
	}

	if isDisabled then
		ref = nil
	end

	v3.ref = ref
	return createElement(root, v3, {
		Header = React.createElement(Sheet.Header, {}, {
			Title = React.createElement(Text, {
				Text = text,
				tag = "auto-xy text-heading-small content-default text-align-x-left"
			})
		}),
		Content = React.createElement(Sheet.Content, { LayoutOrder = 2 }, {
			Body = React.createElement(
				View,
				{
					tag = "col gap-large auto-y size-full-0 align-x-center align-y-center padding-top-small",
					LayoutOrder = 1
				},
				{
					Icon = React.createElement(Icon, {
						name = state,
						size = v2.Size.Size_1200,
						tag = "auto-xy"
					}),
					Message = React.createElement(Text, {
						Text = text2,
						tag = "auto-xy text-body content-default text-align-x-left text-body-medium text-wrap"
					})
				}
			)
		}),
		Actions = React.createElement(Sheet.Actions, { LayoutOrder = 3 }, { React.createElement(Foundation.Button, {
				text = text3,
				onActivated = props.buttons.onActivated,
				fillBehavior = FillBehavior.Fill,
				variant = ButtonVariant.Emphasis,
				ref = ref2,
				isDisabled = isDisabled
			}) })
	})
end

return UnifiedPurchaseCompletionModal
