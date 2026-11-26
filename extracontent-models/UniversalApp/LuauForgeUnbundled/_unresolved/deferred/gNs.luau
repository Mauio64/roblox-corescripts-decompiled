local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local module = require("@luauforge/bundled/ehL")
local InputHandlers = require(CorePackages.Packages.InputHandlers)

local dialog = Foundation.Dialog
local text = Foundation.Text

local module2 = require("@luauforge/deferred/gJI")

local dialogSize = Foundation.Enums.DialogSize
local buttonVariant = Foundation.Enums.ButtonVariant

local fFlagAXAvatarFoldersEnabled = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAvatarFoldersEnabled

local focusNavigableSurfaceWrapper = module.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = module.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = module.FocusNavigationEventNameEnum

local function BaseDialog(props)
	local v5 = React.useMemo(function()
		if not fFlagAXAvatarFoldersEnabled then
			return {
				{
					text = props.cancelButtonText,
					variant = buttonVariant.Standard,
					onActivated = props.onClose
				},
				{
					text = props.confirmButtonText,
					variant = buttonVariant.Emphasis,
					onActivated = props.onConfirm
				}
			}
		end

		local v6 = {}

		if props.cancelButtonText then
			table.insert(v6, {
				text = props.cancelButtonText,
				variant = buttonVariant.Standard,
				onActivated = props.onClose
			})
		end

		table.insert(v6, {
			text = props.confirmButtonText,
			variant = buttonVariant.Emphasis,
			onActivated = props.onConfirm
		})

		return v6
	end, {
		props.cancelButtonText,
		props.onClose,
		props.confirmButtonText,
		props.onConfirm
	})

	return React.createElement(focusNavigableSurfaceWrapper, {
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isIsolated = true,
		customEventHandlers = {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					props.onClose()
					object:cancel()
				end)
			}
		}
	}, {
		Backdrop = React.createElement("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			Text = "",
			Selectable = false,
			[React.Event.Activated] = props.onClose
		}, {
			Dialog = React.createElement(
				dialog.Root,
				{ size = dialogSize.Medium, hasBackdrop = false, onClose = nil },
				{
					DialogTitle = React.createElement(dialog.Title, {
						text = props.titleText,
						LayoutOrder = 1
					}),
					DialogContent = React.createElement(
						dialog.Content,
						{ LayoutOrder = 2, tag = "col gap-medium size-full-0" },
						{
							Body = React.createElement(text, {
								Text = props.bodyText,
								tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left",
								LayoutOrder = 1
							})
						}
					),
					DialogActions = React.createElement(dialog.Actions, {
						LayoutOrder = 3,
						actions = v5
					})
				}
			)
		})
	})
end

return (module2(BaseDialog))
