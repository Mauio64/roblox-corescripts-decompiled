local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Foundation = require(parent2.Foundation)
local Localization = require(parent2.Localization)
local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)

local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local InputSize = Foundation.Enums.InputSize
local Text = Foundation.Text
local View = Foundation.View

local useAnalytics = require(parent.Analytics.useAnalytics)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization
local usePinInputStateWhileOpen = require(parent.Hooks.usePinInputStateWhileOpen)

local EventNames = require(parent.Analytics.EventNames)
local PermissionPromptFinished = require(parent.Thunks.PermissionPromptFinished)

local FFlagCapturePermissionsPromptFreeMouse = require(parent.Flags.FFlagCapturePermissionsPromptFreeMouse)

return function(p)
	local v = useAnalytics()
	local v2 = useDispatch()
	local v3 = useLocalization({
		allow = "Feature.Captures.Action.Allow",
		allowAccessToCapturesBody = "Feature.Captures.Body.AllowAccessToCaptures",
		allowAccessToCapturesTitle = "Feature.Captures.Title.AllowAccessToCaptures",
		dontAllow = "Feature.Captures.Action.DontAllow"
	})

	usePinInputStateWhileOpen(FFlagCapturePermissionsPromptFreeMouse)

	React.useEffect(function()
		v.fireEvent(EventNames.CapturePermissionsPromptViewed)
	end, {})

	local onActivated = React.useCallback(function()
		v.fireEvent(EventNames.CapturePermissionsPromptAccepted)

		v2(PermissionPromptFinished(p.promptId, true))
	end, { p.promptId })

	local onActivated2 = React.useCallback(function()
		v.fireEvent(EventNames.CapturePermissionsPromptRejected)

		v2(PermissionPromptFinished(p.promptId, false))
	end, { p.promptId })

	local createElement = React.createElement
	local root = Dialog.Root
	local v4 = { size = DialogSize.Small }
	local modalFix

	if FFlagCapturePermissionsPromptFreeMouse then
		modalFix = React.createElement("ImageButton", {
			BackgroundTransparency = 1,
			Modal = true,
			Size = UDim2.new(0, 0, 0, 0)
		})
	end

	return createElement(root, v4, {
		ModalFix = modalFix,
		DialogTitle = React.createElement(
			View,
			{
				LayoutOrder = 1,
				tag = "col align-x-center align-y-center auto-y gap-small size-full-0 margin-top-small"
			},
			{
				DialogTitleText = React.createElement(Text, {
					Text = v3.allowAccessToCapturesTitle,
					tag = "auto-xy text-heading-small text-wrap"
				})
			}
		),
		DialogContent = React.createElement(
			View,
			{
				LayoutOrder = 2,
				tag = "col align-x-center align-y-center auto-y gap-small size-full-0 margin-none"
			},
			{
				DialogContentText = React.createElement(Text, {
					LayoutOrder = 1,
					Text = v3.allowAccessToCapturesBody,
					tag = "auto-xy text-body-small text-wrap padding-bottom-xsmall"
				}),
				Buttons = React.createElement(
					View,
					{
						LayoutOrder = 2,
						tag = "row align-x-center align-y-center auto-xy gap-medium"
					},
					{
						AcceptButton = React.createElement(Button, {
							text = v3.allow,
							variant = ButtonVariant.Emphasis,
							onActivated = onActivated,
							size = InputSize.Small,
							width = UDim.new(0.45, 0)
						}),
						RejectButton = React.createElement(Button, {
							text = v3.dontAllow,
							variant = ButtonVariant.Standard,
							onActivated = onActivated2,
							size = InputSize.Small,
							width = UDim.new(0.45, 0)
						})
					}
				)
			}
		)
	})
end
