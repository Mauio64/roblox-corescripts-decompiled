local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Foundation")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/ReactFocusNavigation")
local AuthAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/AuthAnalytics")

local authModalShown = AuthAnalytics.Events.authModalShown
local authButtonClick = AuthAnalytics.Events.authButtonClick
local eventStreamConstants = AuthAnalytics.EventStreamConstants
local inputSize = Foundation.Enums.InputSize
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local buttonVariant = Foundation.Enums.ButtonVariant
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Localization").Hooks.useLocalization
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject

local focusNavigationEventNameEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/FocusNavigationUtils").FocusNavigationEventNameEnum
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/InputHandlers")

local confirms = {
	[Enum.KeyCode.ButtonA] = focusNavigationEventNameEnum.Confirm,
	[Enum.KeyCode.Return] = focusNavigationEventNameEnum.Confirm
}

local function useFocusNavigationBindings(p2)
	local v5 = ReactFocusNavigation.useEventMap(confirms, p2)
	local v6 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.Confirm] = {
				handler = InputHandlers.onRelease(function() end)
			}
		}
	end, {})
	return ReactFocusNavigation.useEventHandlerMap(v6, v5)
end

local function SignUpExitModal(p2)
	local v5 = useLocalization({
		cancel = "Authentication.SignUp.Action.Cancel",
		confirm = "Authentication.SignUp.Action.ExitModalLeave",
		title = "Authentication.SignUp.Label.ExitModalTitle",
		subtitle = "Authentication.SignUp.Label.ExitModalSubtitle"
	})

	local v6 = useFocusGuiObject()
	local ref = React.useRef(nil)
	local v7 = useFocusNavigationBindings(nil)

	React.useEffect(function()
		v6(ref.current)
		authModalShown(eventStreamConstants.Context.SignUpExitModal, eventStreamConstants.State.Success)
	end, {})

	local v8 = React.useCallback(function()
		authButtonClick(
			eventStreamConstants.Context.SignUpExitModal,
			eventStreamConstants.Button.SignUpExitModalLeave
		)

		p2.onConfirm()
	end, { p2.onConfirm })

	local v9 = React.useCallback(function()
		authButtonClick(
			eventStreamConstants.Context.SignUpExitModal,
			eventStreamConstants.Button.SignUpExitModalCancel
		)

		p2.onClose()
	end, { p2.onClose })

	return React.createElement(dialog.Root, {
		size = dialogSize.Small,
		hasBackdrop = true,
		ref = v7
	}, {
		DialogTitle = React.createElement(dialog.Title, { text = v5.title }),
		DialogContent = React.createElement(dialog.Content, {}, {
			DialogView = React.createElement(
				Foundation.View,
				{ tag = "col fill auto-xy items-start gap-medium" },
				{
					DialogText = React.createElement(dialog.Text, {
						Text = v5.subtitle,
						LayoutOrder = 1
					}),
					PrimaryButton = React.createElement(Foundation.Button, {
						text = v5.confirm,
						variant = buttonVariant.Alert,
						size = inputSize.Small,
						width = UDim.new(1, 0),
						TextTruncate = Enum.TextTruncate.None,
						onActivated = v8,
						LayoutOrder = 2
					}),
					SecondaryButton = React.createElement(Foundation.Button, {
						text = v5.cancel,
						variant = buttonVariant.Standard,
						size = inputSize.Small,
						width = UDim.new(1, 0),
						TextTruncate = Enum.TextTruncate.None,
						onActivated = v9,
						LayoutOrder = 3,
						ref = ref
					})
				}
			)
		})
	})
end

return SignUpExitModal
