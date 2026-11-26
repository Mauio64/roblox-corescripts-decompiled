local module = require("@luauforge/deferred/hcS")
local module2 = require("@luauforge/deferred/hcT")
local module3 = require("@luauforge/deferred/hdi")
local module4 = require("@luauforge/deferred/hdj")
require("@luauforge/deferred/hdk")
local backHandlerRegistry = require("@luauforge/deferred/hdl").BackHandlerRegistry

local fFlagAXFixBackgroundGenerationResultMenuNavigation = require("@luauforge/deferred/hcQ").FFlagAXFixBackgroundGenerationResultMenuNavigation

local buttonVariant = module2.Enums.ButtonVariant
local orientation = module2.Enums.Orientation
local focusNavigableSurfaceIdentifierEnum = module3.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = module3.FocusNavigationEventNameEnum
local useAppFocusRoot = module3.useAppFocusRoot

local function PublishConfirmDialog(props)
	local v5

	if fFlagAXFixBackgroundGenerationResultMenuNavigation then
		v5 = module.useMemo(function()
			local v6 = {}
			v6[focusNavigationEventNameEnum.NavigateBack] = {
				handler = module4.onRelease(function(object)
					object:cancel()
					props.onCancel()
				end)
			}

			return v6
		end, { props.onCancel })
	end

	local v6

	if fFlagAXFixBackgroundGenerationResultMenuNavigation then
		v6 = useAppFocusRoot({
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
			customEventHandlers = v5,
			isAutoFocusRoot = true,
			isFocusable = props.isOpen
		})
	end

	if fFlagAXFixBackgroundGenerationResultMenuNavigation then
		module.useLayoutEffect(function()
			if props.isOpen then
				return backHandlerRegistry.register(props.onCancel)
			end

			return nil
		end, { props.isOpen, props.onCancel })
	end

	if not props.isOpen then
		return nil
	end

	local v7 = {
		{
			text = props.publishLabel,
			variant = buttonVariant.Emphasis,
			isLoading = props.isLoading,
			isDisabled = props.isLoading,
			onActivated = props.onConfirm,
			testId = "publish-confirm-dialog-confirm"
		},
		{
			text = props.cancelLabel,
			variant = buttonVariant.Standard,
			onActivated = props.onCancel,
			testId = "publish-confirm-dialog-cancel"
		}
	}

	local v8 = { LayoutOrder = 3, orientation = orientation.Vertical, actions = v7 }

	return module.createElement(
		module2.Dialog.Root,
		{
			disablePortal = false,
			hasBackdrop = true,
			onClose = props.onCancel,
			ref = v6
		},
		{
			Title = module.createElement(module2.Dialog.Title, {
				text = props.title,
				LayoutOrder = 1
			}),
			Content = module.createElement(module2.Dialog.Content, { LayoutOrder = 2 }, {
				Body = module.createElement(module2.Text, {
					Text = props.body,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left"
				})
			}),
			Actions = module.createElement(module2.Dialog.Actions, v8)
		}
	)
end

return module.memo(PublishConfirmDialog)
