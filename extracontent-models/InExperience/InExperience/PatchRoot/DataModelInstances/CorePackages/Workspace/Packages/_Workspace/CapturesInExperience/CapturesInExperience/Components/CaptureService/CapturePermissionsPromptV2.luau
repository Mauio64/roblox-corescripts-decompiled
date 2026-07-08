local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Foundation = require(ParentParentParent.Foundation)
local Localization = require(ParentParentParent.Localization)
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local InputSize = Foundation.Enums.InputSize
local FoundationText = Foundation.Text
local View = Foundation.View
local useAnalytics = require(ParentParent.Analytics.useAnalytics)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local usePinInputStateWhileOpen = require(ParentParent.Hooks.usePinInputStateWhileOpen)
local EventNames = require(ParentParent.Analytics.EventNames)
local PermissionPromptFinished = require(ParentParent.Thunks.PermissionPromptFinished)
local FFlagCapturePermissionsPromptFreeMouse = require(ParentParent.Flags.FFlagCapturePermissionsPromptFreeMouse)

return function(t1: {[any]: any}) -- line: 34
	-- upvalues: useAnalytics (copy), useDispatch (copy), useLocalization (copy), usePinInputStateWhileOpen (copy), FFlagCapturePermissionsPromptFreeMouse (copy), React (copy), EventNames (copy), PermissionPromptFinished (copy), Dialog (copy), DialogSize (copy), View (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), InputSize (copy)
	local v22 = useAnalytics()
	local v23 = useDispatch()
	local v24 = useLocalization({
		allow = "Feature.Captures.Action.Allow",
		allowAccessToCapturesBody = "Feature.Captures.Body.AllowAccessToCaptures",
		allowAccessToCapturesTitle = "Feature.Captures.Title.AllowAccessToCaptures",
		dontAllow = "Feature.Captures.Action.DontAllow"
	})

	usePinInputStateWhileOpen(FFlagCapturePermissionsPromptFreeMouse)
	React.useEffect(function() -- line: 50
		-- upvalues: v22 (copy), EventNames (copy)
		v22.fireEvent(EventNames.CapturePermissionsPromptViewed)
	end, {})

	local v25 = React.useCallback(function() -- line: 54
		-- upvalues: v22 (copy), EventNames (copy), v23 (copy), PermissionPromptFinished (copy), t1 (copy)
		v22.fireEvent(EventNames.CapturePermissionsPromptAccepted)
		v23(PermissionPromptFinished(t1.promptId, true))
	end, { t1.promptId })
	local v26 = React.useCallback(function() -- line: 60
		-- upvalues: v22 (copy), EventNames (copy), v23 (copy), PermissionPromptFinished (copy), t1 (copy)
		v22.fireEvent(EventNames.CapturePermissionsPromptRejected)
		v23(PermissionPromptFinished(t1.promptId, false))
	end, { t1.promptId })

	return React.createElement(Dialog.Root, {
		size = DialogSize.Small
	}, {
		ModalFix = if not FFlagCapturePermissionsPromptFreeMouse then nil else React.createElement("ImageButton", {
			BackgroundTransparency = 1,
			Modal = true,
			Size = UDim2.new(0, 0, 0, 0)
		}),
		DialogTitle = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col align-x-center align-y-center auto-y gap-small size-full-0 margin-top-small"
		}, {
			DialogTitleText = React.createElement(FoundationText, {
				tag = "auto-xy text-heading-small text-wrap",
				Text = v24.allowAccessToCapturesTitle
			})
		}),
		DialogContent = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col align-x-center align-y-center auto-y gap-small size-full-0 margin-none"
		}, {
			DialogContentText = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "auto-xy text-body-small text-wrap padding-bottom-xsmall",
				Text = v24.allowAccessToCapturesBody
			}),
			Buttons = React.createElement(View, {
				LayoutOrder = 2,
				tag = "row align-x-center align-y-center auto-xy gap-medium"
			}, {
				AcceptButton = React.createElement(Button, {
					text = v24.allow,
					variant = ButtonVariant.Emphasis,
					onActivated = v25,
					size = InputSize.Small,
					width = UDim.new(0.45, 0)
				}),
				RejectButton = React.createElement(Button, {
					text = v24.dontAllow,
					variant = ButtonVariant.Standard,
					onActivated = v26,
					size = InputSize.Small,
					width = UDim.new(0.45, 0)
				})
			})
		})
	})
end
