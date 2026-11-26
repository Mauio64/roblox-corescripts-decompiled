local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local buttonVariant = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation").Enums.ButtonVariant
local fillBehavior = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation").Enums.FillBehavior
local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local sheet = Foundation.Sheet
local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue

local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol")
local unifiedProductPurchaseCompletionModalShownCounter = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Events/UnifiedPurchaseCompletionCounter").UnifiedProductPurchaseCompletionModalShownCounter

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization").Hooks.useLocalization
local formatTextWithParams = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/formatTextWithParams")

local useFocusNavigationRefs = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Hooks/useFocusNavigationRefs")
local useInitialButtonDisableDelay = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Hooks/useInitialButtonDisableDelay")

local UNIFIED_PURCHASE_COMPLETION_MODAL_MIN_HEIGHT_PIXELS = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Constants").UNIFIED_PURCHASE_COMPLETION_MODAL_MIN_HEIGHT_PIXELS

local function UnifiedPurchaseCompletionModal(props)
	local v5 = useLocalization({
		PurchaseCompleteTitle = "IAPExperience.PurchasePrompt.Title.PurchaseCompleted",
		PurchaseCompleteBody = "IAPExperience.PurchasePrompt.Body.PurchaseCompleted",
		ErrorTitle = "CoreScripts.PremiumModal.Title.Error",
		GenericErrorBody = "CoreScripts.PurchasePrompt.PurchaseFailed.UnknownFailureNoItemName",
		OkButtonText = "CoreScripts.PurchasePrompt.Button.OK",
		MultiItemPurchaseCompleteBody = "IAPExperience.PurchasePrompt.Body.PurchaseItemsSuccess"
	})

	local v6, v7 = useFocusNavigationRefs(props.buttons.onClose, nil)

	local v8 = useInitialButtonDisableDelay()

	local v9 = useTokens()
	local state, setState = React.useState(Foundation.Enums.IconName.CircleCheck)

	React.useEffect(function()
		LoggingProtocol.default:logRobloxTelemetryCounter(unifiedProductPurchaseCompletionModalShownCounter, 1, {})
	end, {})

	local v10 = React.useMemo(function()
		if props.title then
			return props.title
		end

		if props.isError then
			return v5.ErrorTitle
		end

		return v5.PurchaseCompleteTitle
	end, { props.title, props.isError })

	local v11 = React.useMemo(function()
		if props.bodyText then
			return props.bodyText
		end

		if props.isError then
			return v5.GenericErrorBody
		end

		if props.isMultiItem then
			return v5.MultiItemPurchaseCompleteBody
		end

		return formatTextWithParams(v5.PurchaseCompleteBody, { ITEM_NAME = props.itemName })
	end, { props.bodyText, props.isError, props.isMultiItem, props.itemName })

	local v12 = if props.buttons and props.buttons.text then props.buttons.text else v5.OkButtonText

	React.useEffect(function()
		if props.isError then
			setState(Foundation.Enums.IconName.TriangleExclamation)
		else
			setState(Foundation.Enums.IconName.CircleCheck)
		end
	end, { props.isError })

	local createElement = React.createElement
	local root = sheet.Root
	local v14 = if props.buttons.onClose then props.buttons.onClose else props.buttons.onActivated
	local v13 = {
		onClose = v14,
		snapPoints = { useScaledValue(UNIFIED_PURCHASE_COMPLETION_MODAL_MIN_HEIGHT_PIXELS), 0.8 },
		preferCenterSheet = true,
		ref = 0
	}

	if v8 then
		v6 = nil
	end

	v13.ref = v6
	return createElement(root, v13, {
		Header = React.createElement(sheet.Header, {}, {
			Title = React.createElement(text, {
				Text = v10,
				tag = "auto-xy text-heading-small content-default text-align-x-left"
			})
		}),
		Content = React.createElement(sheet.Content, { LayoutOrder = 2 }, {
			Body = React.createElement(
				view,
				{
					tag = "col gap-large auto-y size-full-0 align-x-center align-y-center padding-top-small",
					LayoutOrder = 1
				},
				{
					Icon = React.createElement(icon, {
						name = state,
						size = v9.Size.Size_1200,
						tag = "auto-xy"
					}),
					Message = React.createElement(text, {
						Text = v11,
						tag = "auto-xy text-body content-default text-align-x-left text-body-medium text-wrap"
					})
				}
			)
		}),
		Actions = React.createElement(sheet.Actions, { LayoutOrder = 3 }, {
			React.createElement(Foundation.Button, {
				text = v12,
				onActivated = props.buttons.onActivated,
				fillBehavior = fillBehavior.Fill,
				variant = buttonVariant.Emphasis,
				ref = v7,
				isDisabled = v8
			})
		})
	})
end

return UnifiedPurchaseCompletionModal
