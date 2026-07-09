local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Foundation = require(scriptParentParent.Foundation)
local Localization = require(scriptParentParent.Localization)
local React = require(scriptParentParent.React)
local usePinInputStateWhileOpen = require(scriptParent.usePinInputStateWhileOpen)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local InputSize = Foundation.Enums.InputSize
local FoundationText = Foundation.Text
local View = Foundation.View
local useLocalization = Localization.Hooks.useLocalization

local function CapturePermissionPrompt(t1: {[any]: any}) -- line: 49
	-- upvalues: useLocalization (copy), usePinInputStateWhileOpen (copy), React (copy), Dialog (copy), DialogSize (copy), View (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), InputSize (copy)
	local v17 = useLocalization({
		allow = "Feature.Captures.Action.Allow",
		dontAllow = "Feature.Captures.Action.DontAllow",
		galleryTitle = "Feature.Captures.Title.AllowAccessToCaptures",
		galleryBody = "Feature.Captures.Body.AllowAccessToCaptures"
	})

	usePinInputStateWhileOpen(t1.promptId ~= nil)

	local v18 = React.useCallback(function() -- line: 59
		-- upvalues: t1 (copy)
		if t1.onAccepted then
			t1.onAccepted()
		end

		t1.respond(true)
	end, {
		t1.respond,
		t1.onAccepted
	})
	local v19 = React.useCallback(function() -- line: 66
		-- upvalues: t1 (copy)
		if t1.onRejected then
			t1.onRejected()
		end

		t1.respond(false)
	end, {
		t1.respond,
		t1.onRejected
	})

	if t1.promptId == nil then
		return nil
	end

	local galleryTitle = v17.galleryTitle
	local galleryBody = v17.galleryBody

	return React.createElement(Dialog.Root, {
		size = DialogSize.Small
	}, {
		ModalFix = React.createElement("ImageButton", {
			BackgroundTransparency = 1,
			Modal = true,
			Size = UDim2.new(0, 0, 0, 0)
		}),
		DialogTitle = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col align-x-center align-y-center gap-small size-full-0 auto-y margin-top-small"
		}, {
			DialogTitleText = React.createElement(FoundationText, {
				tag = "auto-xy text-heading-small text-wrap",
				Text = galleryTitle
			})
		}),
		DialogContent = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col align-x-center align-y-center gap-small size-full-0 auto-y margin-none"
		}, {
			DialogContentText = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "auto-xy padding-bottom-xsmall text-body-small text-wrap",
				Text = galleryBody
			}),
			Buttons = React.createElement(View, {
				LayoutOrder = 2,
				tag = "row align-x-center align-y-center gap-medium auto-xy"
			}, {
				AcceptButton = React.createElement(Button, {
					text = v17.allow,
					variant = ButtonVariant.Emphasis,
					onActivated = v18,
					size = InputSize.Small,
					width = UDim.new(0.45, 0)
				}),
				RejectButton = React.createElement(Button, {
					text = v17.dontAllow,
					variant = ButtonVariant.Standard,
					onActivated = v19,
					size = InputSize.Small,
					width = UDim.new(0.45, 0)
				})
			})
		})
	})
end

return CapturePermissionPrompt
