local parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local Orientation = Foundation.Enums.Orientation

local defineFastFlag = game:DefineFastFlag("SduiDialogHeroMediaProps2", false)

local function SduiDialog(props)
	local bodyText = props.bodyText or props.bodyComponent

	local onActivated = React.useCallback(function()
		if props.primaryButtonAction then
			props.primaryButtonAction()

			if props.primaryButtonSideEffectAction then
				props.primaryButtonSideEffectAction()
			end
		end
	end, { props.primaryButtonAction, props.primaryButtonSideEffectAction })

	local onActivated2 = React.useCallback(function()
		if props.secondaryButtonAction then
			props.secondaryButtonAction()

			if props.secondaryButtonSideEffectAction then
				props.secondaryButtonSideEffectAction()
			end
		end
	end, { props.secondaryButtonAction, props.secondaryButtonSideEffectAction })

	local actions = nil

	if props.primaryButtonAction or props.primaryButtonText or props.primaryButtonIcon then
		actions = actions or {}
		table.insert(actions, {
			testId = "--sdui-dialog-primary-button",
			variant = ButtonVariant.Emphasis,
			text = props.primaryButtonText,
			icon = props.primaryButtonIcon,
			onActivated = onActivated,
			inputDelay = props.primaryButtonInputDelay
		})
	end

	if props.secondaryButtonAction or props.secondaryButtonText or props.secondaryButtonIcon then
		actions = actions or {}
		table.insert(actions, {
			testId = "--sdui-dialog-secondary-button",
			variant = ButtonVariant.Standard,
			text = props.secondaryButtonText,
			icon = props.secondaryButtonIcon,
			onActivated = onActivated2,
			inputDelay = props.secondaryButtonInputDelay
		})
	end

	local createElement = React.createElement
	local root = Dialog.Root
	local v = {
		size = props.size,
		onClose = props.onClose,
		disablePortal = props.disablePortal == nil or props.disablePortal,
		hasBackdrop = props.hasBackdrop == nil or props.hasBackdrop
	}
	local dialogTitle

	if props.titleText then
		dialogTitle = React.createElement(Dialog.Title, { text = props.titleText }) or nil
	end

	local dialogMedia

	if props.image then
		local createElement2 = React.createElement
		local heroMedia = Dialog.HeroMedia
		local v2 = {
			media = props.image,
			aspectRatio = 0,
			mediaStyle = 0,
			height = 0,
			scaleType = 0
		}
		local aspectRatio

		if defineFastFlag and props.imageHeight ~= nil then
			aspectRatio = props.imageAspectRatio
		else
			aspectRatio = props.imageAspectRatio or 16 / 9
		end

		v2.aspectRatio = aspectRatio
		local mediaStyle

		if defineFastFlag then
			mediaStyle = props.imageStyle
		end

		v2.mediaStyle = mediaStyle
		local height

		if defineFastFlag then
			height = props.imageHeight
		end

		v2.height = height
		local scaleType

		if defineFastFlag then
			scaleType = props.imageScaleType
		end

		v2.scaleType = scaleType
		dialogMedia = createElement2(heroMedia, v2) or nil
	end

	local dialogContent

	if bodyText then
		local createElement2 = React.createElement
		local content = Dialog.Content
		local bodyContent

		if props.bodyComponent then
			bodyContent = props.bodyComponent
		elseif props.bodyText then
			bodyContent = React.createElement(Dialog.Text, { Text = props.bodyText })
		end

		dialogContent = createElement2(content, { LayoutOrder = 2 }, { BodyContent = bodyContent }) or nil
	end

	local dialogActions

	if actions then
		dialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = actions,
			label = props.actionsLabel,
			orientation = props.actionsOrientation or Orientation.Horizontal
		}) or nil
	end

	return createElement(root, v, {
		DialogTitle = dialogTitle,
		DialogMedia = dialogMedia,
		DialogContent = dialogContent,
		DialogActions = dialogActions
	})
end

return React.memo(SduiDialog)
