local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local buttonVariant = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation").Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local orientation = Foundation.Enums.Orientation
local useTokens = Foundation.Hooks.useTokens

local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol")
local unifiedProductPurchaseCompletionModalShownCounter = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Events/UnifiedPurchaseCompletionCounter").UnifiedProductPurchaseCompletionModalShownCounter

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization").Hooks.useLocalization
local formatTextWithParams = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/formatTextWithParams")

local useFocusNavigationRefs = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Hooks/useFocusNavigationRefs")

local fFlagEnableLaunchAfterPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagEnableLaunchAfterPurchase
local v5

if require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagEnableLargerLaunchAfterPurchasePlayIcon then
	v5 = iconName.PlayXlarge
else
	v5 = iconName.PlaySmall
end

local function UnifiedPurchaseCompletionModalV2(props)
	local v6 = useLocalization({
		PurchaseCompleteTitle = "IAPExperience.PurchasePrompt.Title.PurchaseCompleted",
		PurchaseCompleteBody = "IAPExperience.PurchasePrompt.Body.PurchaseCompleted",
		ErrorTitle = "CoreScripts.PremiumModal.Title.Error",
		GenericErrorBody = "CoreScripts.PurchasePrompt.PurchaseFailed.UnknownFailureNoItemName",
		OkButtonText = "CoreScripts.PurchasePrompt.Button.OK",
		MultiItemPurchaseCompleteBody = "IAPExperience.PurchasePrompt.Body.PurchaseItemsSuccess"
	})

	local v7, v8 = useFocusNavigationRefs(props.buttons.onClose or props.buttons.onActivated, nil)
	local v9 = useTokens()
	local state, setState = React.useState(Foundation.Enums.IconName.CircleCheck)

	local v10 = fFlagEnableLaunchAfterPurchase

	if v10 then
		v10 = props.enableLaunchAfterPurchase == true and not props.isError
	end

	local ref = React.useRef(props.buttons.onShown)
	ref.current = props.buttons.onShown
	React.useEffect(function()
		LoggingProtocol.default:logRobloxTelemetryCounter(unifiedProductPurchaseCompletionModalShownCounter, 1, {})

		if fFlagEnableLaunchAfterPurchase and ref.current then
			ref.current()
		end
	end, {})

	local v11 = React.useMemo(function()
		if props.title then
			return props.title
		end

		if props.isError then
			return v6.ErrorTitle
		end

		return v6.PurchaseCompleteTitle
	end, { props.title, props.isError })

	local v12 = React.useMemo(function()
		if props.bodyText then
			return props.bodyText
		end

		if props.isError then
			return v6.GenericErrorBody
		end

		if props.isMultiItem then
			return v6.MultiItemPurchaseCompleteBody
		end

		return formatTextWithParams(v6.PurchaseCompleteBody, {
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
	local root = dialog.Root
	local v13 = {
		size = dialogSize.Medium,
		closeOnClickOutside = true,
		onClose = 0,
		ref = 0,
		disablePortal = false
	}

	local v14 = if props.buttons.onClose then props.buttons.onClose else props.buttons.onActivated
	v13.onClose = v14
	v13.ref = v7

	local v15 = {
		DialogTitle = React.createElement(dialog.Title, { text = v11 }),
		DialogContent = React.createElement(dialog.Content, nil, {
			Body = React.createElement(
				view,
				{
					tag = "col gap-large auto-y size-full-0 align-x-center align-y-center padding-top-small"
				},
				{
					DialogIcon = React.createElement(icon, {
						name = state,
						size = v9.Size.Size_1200,
						tag = "auto-xy"
					}),
					Message = React.createElement(text, {
						Text = v12,
						tag = "auto-xy text-body content-default text-align-x-left text-body-medium text-wrap"
					})
				}
			)
		}),
		DialogActions = 0
	}

	local createElement2 = React.createElement
	local actions = dialog.Actions
	local v16 = { orientation = orientation.Horizontal, actions = 0 }
	local v17

	if v10 then
		v17 = {
			{
				icon = v5,
				variant = buttonVariant.Emphasis,
				onActivated = props.buttons.onActivated,
				ref = v8,
				isDisabled = false
			}
		}
	else
		v17 = { nil }

		local v19 = if props.buttons and props.buttons.text then props.buttons.text else v6.OkButtonText
		v17[1] = {
	text = v19,
	variant = buttonVariant.Emphasis,
	onActivated = props.buttons.onActivated,
	ref = v8,
	isDisabled = false
}
	end

	v16.actions = v17
	v15.DialogActions = createElement2(actions, v16)
	return createElement(root, v13, v15)
end

return UnifiedPurchaseCompletionModalV2
