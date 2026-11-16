local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local buttonVariant = Foundation.Enums.ButtonVariant
local dialog = Foundation.Dialog
local orientation = Foundation.Enums.Orientation

local defineFastFlag = game:DefineFastFlag("SduiDialogHeroMediaProps2", false)

local function SduiDialog(props)
	local bodyText = props.bodyText or props.bodyComponent

	local v5 = React.useCallback(function()
		if props.primaryButtonAction then
			props.primaryButtonAction()

			if props.primaryButtonSideEffectAction then
				props.primaryButtonSideEffectAction()
			end
		end
	end, { props.primaryButtonAction, props.primaryButtonSideEffectAction })

	local v6 = React.useCallback(function()
		if props.secondaryButtonAction then
			props.secondaryButtonAction()

			if props.secondaryButtonSideEffectAction then
				props.secondaryButtonSideEffectAction()
			end
		end
	end, { props.secondaryButtonAction, props.secondaryButtonSideEffectAction })

	local v7 = nil

	if props.primaryButtonAction or props.primaryButtonText or props.primaryButtonIcon then
		v7 = v7 or {}
		table.insert(v7, {
			testId = "--sdui-dialog-primary-button",
			variant = buttonVariant.Emphasis,
			text = props.primaryButtonText,
			icon = props.primaryButtonIcon,
			onActivated = v5,
			inputDelay = props.primaryButtonInputDelay
		})
	end

	if props.secondaryButtonAction or props.secondaryButtonText or props.secondaryButtonIcon then
		v7 = v7 or {}
		table.insert(v7, {
			testId = "--sdui-dialog-secondary-button",
			variant = buttonVariant.Standard,
			text = props.secondaryButtonText,
			icon = props.secondaryButtonIcon,
			onActivated = v6,
			inputDelay = props.secondaryButtonInputDelay
		})
	end

	local createElement = React.createElement
	local root = dialog.Root
	local v8 = {
		size = props.size,
		onClose = props.onClose,
		disablePortal = props.disablePortal == nil or props.disablePortal,
		hasBackdrop = props.hasBackdrop == nil or props.hasBackdrop
	}

	local v10 = if props.titleText then React.createElement(dialog.Title, {
		text = props.titleText
	}) or nil else nil
	local v11

	if props.image then
		local createElement2 = React.createElement
		local heroMedia = dialog.HeroMedia
		local v12 = {
			media = props.image,
			aspectRatio = 0,
			mediaStyle = 0,
			height = 0,
			scaleType = 0
		}

		local v13 = if defineFastFlag and props.imageHeight ~= nil then props.imageAspectRatio else props.imageAspectRatio or 16 / 9
		v12.aspectRatio = v13

		local v14 = if defineFastFlag then props.imageStyle else nil
		v12.mediaStyle = v14
		local v15 = if defineFastFlag then props.imageHeight else nil
		v12.height = v15
		local v16 = if defineFastFlag then props.imageScaleType else nil
		v12.scaleType = v16
		v11 = createElement2(heroMedia, v12) or nil
	end

	local v12

	if bodyText then
		local createElement2 = React.createElement
		local content = dialog.Content
		local v15

		if props.bodyComponent then
			v15 = props.bodyComponent
		elseif props.bodyText then
			v15 = React.createElement(dialog.Text, { Text = props.bodyText })
		end

		v12 = createElement2(content, { LayoutOrder = 2 }, { BodyContent = v15 }) or nil
	end

	local v13 = if v7 then React.createElement(dialog.Actions, {
		LayoutOrder = 3,
		actions = v7,
		label = props.actionsLabel,
		orientation = props.actionsOrientation or orientation.Horizontal
	}) or nil else nil
	return createElement(root, v8, {
		DialogTitle = v10,
		DialogMedia = v11,
		DialogContent = v12,
		DialogActions = v13
	})
end

return React.memo(SduiDialog)
