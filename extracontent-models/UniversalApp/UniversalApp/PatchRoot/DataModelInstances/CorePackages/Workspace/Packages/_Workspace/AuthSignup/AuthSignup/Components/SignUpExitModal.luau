local Parent = script:FindFirstAncestor("AuthSignup").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local ReactFocusNavigation = require(Parent.ReactFocusNavigation)
local AuthAnalytics = require(Parent.AuthAnalytics)
local authModalShown = AuthAnalytics.Events.authModalShown
local authButtonClick = AuthAnalytics.Events.authButtonClick
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local InputSize = Foundation.Enums.InputSize
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local FocusNavigationEventNameEnum = require(Parent.FocusNavigationUtils).FocusNavigationEventNameEnum
local InputHandlers = require(Parent.InputHandlers)
local t1 = {
	[Enum.KeyCode.ButtonA] = FocusNavigationEventNameEnum.Confirm,
	[Enum.KeyCode.Return] = FocusNavigationEventNameEnum.Confirm
}

local function useFocusNavigationBindings(p1) -- line: 29
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v21 = ReactFocusNavigation.useEventMap(t1, p1)
	local v22 = React.useMemo(function() -- line: 31
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy)
		return {
			[FocusNavigationEventNameEnum.Confirm] = {
				handler = InputHandlers.onRelease(function() -- line: 34
				end)
			}
		}
	end, {})

	return ReactFocusNavigation.useEventHandlerMap(v22, v21)
end
local function SignUpExitModal(t2: {[any]: any}) -- line: 46
	-- upvalues: useLocalization (copy), useFocusGuiObject (copy), React (copy), useFocusNavigationBindings (copy), authModalShown (copy), EventStreamConstants (copy), authButtonClick (copy), Dialog (copy), DialogSize (copy), Foundation (copy), ButtonVariant (copy), InputSize (copy)
	local v24 = useLocalization({
		cancel = "Authentication.SignUp.Action.Cancel",
		confirm = "Authentication.SignUp.Action.ExitModalLeave",
		title = "Authentication.SignUp.Label.ExitModalTitle",
		subtitle = "Authentication.SignUp.Label.ExitModalSubtitle"
	})
	local v25 = useFocusGuiObject()
	local v26 = React.useRef(nil)
	local v27 = useFocusNavigationBindings(nil)

	React.useEffect(function() -- line: 58
		-- upvalues: v25 (copy), v26 (copy), authModalShown (copy), EventStreamConstants (copy)
		v25(v26.current)
		authModalShown(EventStreamConstants.Context.SignUpExitModal, EventStreamConstants.State.Success)
	end, {})

	local v28 = React.useCallback(function() -- line: 63
		-- upvalues: authButtonClick (copy), EventStreamConstants (copy), t2 (copy)
		authButtonClick(EventStreamConstants.Context.SignUpExitModal, EventStreamConstants.Button.SignUpExitModalLeave)
		t2.onConfirm()
	end, { t2.onConfirm })
	local v29 = React.useCallback(function() -- line: 71
		-- upvalues: authButtonClick (copy), EventStreamConstants (copy), t2 (copy)
		authButtonClick(EventStreamConstants.Context.SignUpExitModal, EventStreamConstants.Button.SignUpExitModalCancel)
		t2.onClose()
	end, { t2.onClose })

	return React.createElement(Dialog.Root, {
		hasBackdrop = true,
		size = DialogSize.Small,
		ref = v27
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			text = v24.title
		}),
		DialogContent = React.createElement(Dialog.Content, {}, {
			DialogView = React.createElement(Foundation.View, {
				tag = "col fill auto-xy items-start gap-medium"
			}, {
				DialogText = React.createElement(Dialog.Text, {
					LayoutOrder = 1,
					Text = v24.subtitle
				}),
				PrimaryButton = React.createElement(Foundation.Button, {
					LayoutOrder = 2,
					text = v24.confirm,
					variant = ButtonVariant.Alert,
					size = InputSize.Small,
					width = UDim.new(1, 0),
					TextTruncate = Enum.TextTruncate.None,
					onActivated = v28
				}),
				SecondaryButton = React.createElement(Foundation.Button, {
					LayoutOrder = 3,
					text = v24.cancel,
					variant = ButtonVariant.Standard,
					size = InputSize.Small,
					width = UDim.new(1, 0),
					TextTruncate = Enum.TextTruncate.None,
					onActivated = v29,
					ref = v26
				})
			})
		})
	})
end

return SignUpExitModal
