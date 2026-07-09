local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local EnumsOrientation = Foundation.Enums.Orientation

local function SduiDialog(t1: {[any]: any}) -- line: 47
	-- upvalues: React (copy), ButtonVariant (copy), Dialog (copy), EnumsOrientation (copy)
	local v9 = t1.bodyText or t1.bodyComponent
	local v10 = React.useCallback(function() -- line: 50
		-- upvalues: t1 (copy)
		if t1.primaryButtonAction then
			t1.primaryButtonAction()

			if t1.primaryButtonSideEffectAction then
				t1.primaryButtonSideEffectAction()
			end
		end
	end, {
		t1.primaryButtonAction,
		t1.primaryButtonSideEffectAction
	})
	local v11 = React.useCallback(function() -- line: 59
		-- upvalues: t1 (copy)
		if t1.secondaryButtonAction then
			t1.secondaryButtonAction()

			if t1.secondaryButtonSideEffectAction then
				t1.secondaryButtonSideEffectAction()
			end
		end
	end, {
		t1.secondaryButtonAction,
		t1.secondaryButtonSideEffectAction
	})
	local v12 = nil

	if t1.primaryButtonAction or (t1.primaryButtonText or t1.primaryButtonIcon) then
		v12 = v12 or {}
		table.insert(v12, {
			testId = "--sdui-dialog-primary-button",
			variant = ButtonVariant.Emphasis,
			text = t1.primaryButtonText,
			icon = t1.primaryButtonIcon,
			onActivated = v10,
			inputDelay = t1.primaryButtonInputDelay
		})
	end

	if t1.secondaryButtonAction or t1.secondaryButtonText or t1.secondaryButtonIcon then
		v12 = v12 or {}
		table.insert(v12, {
			testId = "--sdui-dialog-secondary-button",
			variant = ButtonVariant.Standard,
			text = t1.secondaryButtonText,
			icon = t1.secondaryButtonIcon,
			onActivated = v11,
			inputDelay = t1.secondaryButtonInputDelay
		})
	end

	return React.createElement(Dialog.Root, {
		size = t1.size,
		onClose = t1.onClose,
		disablePortal = t1.disablePortal == nil or t1.disablePortal,
		hasBackdrop = t1.hasBackdrop == nil or t1.hasBackdrop
	}, {
		DialogTitle = t1.titleText and React.createElement(Dialog.Title, {
			text = t1.titleText
		}) or nil,
		DialogMedia = t1.image and React.createElement(Dialog.HeroMedia, {
			media = t1.image,
			aspectRatio = t1.imageAspectRatio or 1.7777777777777777
		}) or nil,
		DialogContent = v9 and React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			BodyContent = if not t1.bodyComponent then if not t1.bodyText then nil else React.createElement(Dialog.Text, {
				Text = t1.bodyText
			}) else t1.bodyComponent
		}) or nil,
		DialogActions = v12 and React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = v12,
			label = t1.actionsLabel,
			orientation = t1.actionsOrientation or EnumsOrientation.Horizontal
		}) or nil
	})
end

return React.memo(SduiDialog)
