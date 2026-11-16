local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local Foundation = require(parent2.Foundation)
local Foundation2 = require(parent2.Foundation)
local ButtonVariant = Foundation2.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local Orientation = Foundation.Enums.Orientation
local useTokens = Foundation.Hooks.useTokens

local LoggingProtocol = require(parent2.LoggingProtocol)
local UnifiedPurchaseCompletionCounter = require(parent.Generic.Events.UnifiedPurchaseCompletionCounter)

local UnifiedProductPurchaseCompletionModalShownCounter = UnifiedPurchaseCompletionCounter.UnifiedProductPurchaseCompletionModalShownCounter

local Localization = require(parent2.Localization)
local useLocalization = Localization.Hooks.useLocalization
local formatTextWithParams = require(parent.Utility.formatTextWithParams)

local useFocusNavigationRefs = require(parent.Generic.Hooks.useFocusNavigationRefs)

local SharedFlags = require(parent2.SharedFlags)
local FFlagEnableLaunchAfterPurchase = SharedFlags.FFlagEnableLaunchAfterPurchase

local SharedFlags2 = require(parent2.SharedFlags)
local icon

if SharedFlags2.FFlagEnableLargerLaunchAfterPurchasePlayIcon then
	icon = IconName.PlayXlarge
else
	icon = IconName.PlaySmall
end

local function UnifiedPurchaseCompletionModalV2(props)
	local v = useLocalization({
		PurchaseCompleteTitle = "IAPExperience.PurchasePrompt.Title.PurchaseCompleted",
		PurchaseCompleteBody = "IAPExperience.PurchasePrompt.Body.PurchaseCompleted",
		ErrorTitle = "CoreScripts.PremiumModal.Title.Error",
		GenericErrorBody = "CoreScripts.PurchasePrompt.PurchaseFailed.UnknownFailureNoItemName",
		OkButtonText = "CoreScripts.PurchasePrompt.Button.OK",
		MultiItemPurchaseCompleteBody = "IAPExperience.PurchasePrompt.Body.PurchaseItemsSuccess"
	})

	local ref2, ref3 = useFocusNavigationRefs(props.buttons.onClose or props.buttons.onActivated, nil)
	local v2 = useTokens()
	local state, setState = React.useState(Foundation.Enums.IconName.CircleCheck)

	local v3 = FFlagEnableLaunchAfterPurchase

	if v3 then
		if props.enableLaunchAfterPurchase == true then
			v3 = not props.isError
		else
			v3 = false
		end
	end

	local ref = React.useRef(props.buttons.onShown)
	ref.current = props.buttons.onShown
	React.useEffect(function()
		LoggingProtocol.default:logRobloxTelemetryCounter(UnifiedProductPurchaseCompletionModalShownCounter, 1, {})

		if FFlagEnableLaunchAfterPurchase and ref.current then
			ref.current()
		end
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

		return formatTextWithParams(v.PurchaseCompleteBody, {
			ITEM_NAME = props.itemName or ""
		})
	end, { props.bodyText, props.isError, props.isMultiItem, props.itemName })

	React.useEffect(function()
		if props.isError then
			setState(Foundation.Enums.IconName.TriangleExclamation)
		else
			setState(Foundation.Enums.IconName.CircleCheck)
		end
	end, { props.isError })

	local createElement = React.createElement
	local root = Dialog.Root
	local v4 = {
		size = DialogSize.Medium,
		closeOnClickOutside = true,
		onClose = 0,
		ref = 0,
		disablePortal = false
	}
	local onClose

	if props.buttons.onClose then
		onClose = props.buttons.onClose
	else
		onClose = props.buttons.onActivated
	end

	v4.onClose = onClose
	v4.ref = ref2

	local v5 = {
		DialogTitle = React.createElement(Dialog.Title, { text = text }),
		DialogContent = React.createElement(Dialog.Content, nil, {
			Body = React.createElement(
				View,
				{
					tag = "col gap-large auto-y size-full-0 align-x-center align-y-center padding-top-small"
				},
				{
					DialogIcon = React.createElement(Icon, {
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
		DialogActions = 0
	}

	local createElement2 = React.createElement
	local actions = Dialog.Actions
	local v6 = { orientation = Orientation.Horizontal, actions = 0 }
	local actions2

	if v3 then
		actions2 = {
			{
				icon = icon,
				variant = ButtonVariant.Emphasis,
				onActivated = props.buttons.onActivated,
				ref = ref3,
				isDisabled = false
			}
		}
	else
		actions2 = { nil }
		local text3

		if props.buttons and props.buttons.text then
			text3 = props.buttons.text
		else
			text3 = v.OkButtonText
		end

		actions2[1] = {
	text = text3,
	variant = ButtonVariant.Emphasis,
	onActivated = props.buttons.onActivated,
	ref = ref3,
	isDisabled = false
}
	end

	v6.actions = actions2
	v5.DialogActions = createElement2(actions, v6)
	return createElement(root, v4, v5)
end

return UnifiedPurchaseCompletionModalV2
