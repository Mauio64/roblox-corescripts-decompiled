local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local module = require("@luauforge/bundled/eeo")
local InputHandlers = require(CorePackages.Packages.InputHandlers)
require("@luauforge/deferred/giI")

local dialog = Foundation.Dialog
local textInput = Foundation.TextInput

local module2 = require("@luauforge/deferred/gfc")

local dialogSize = Foundation.Enums.DialogSize
local buttonVariant = Foundation.Enums.ButtonVariant
local focusNavigableSurfaceWrapper = module.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = module.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = module.FocusNavigationEventNameEnum

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fIntAXOutfitNameMaxLength = AvatarExperienceFlags.FIntAXOutfitNameMaxLength
local fFlagAXAvatarFoldersEnabled = AvatarExperienceFlags.FFlagAXAvatarFoldersEnabled

local function BaseDialogWithTextbox(props)
	local state, setState = React.useState(props.defaultText or "")
	local ref = React.useRef(nil)
	local v5

	if fFlagAXAvatarFoldersEnabled then
		v5 = props.maxLength or fIntAXOutfitNameMaxLength
	else
		v5 = fIntAXOutfitNameMaxLength
	end

	local function fn(p2)
		local v6 = utf8.len(p2)

		if v6 == nil or v5 < v6 then
			local textBox = ref.current and ref.current:FindFirstChild("TextBox", true)

			if textBox then
				textBox.Text = state
			end
		else
			setState(p2)
		end
	end

	local v8 = React.useCallback(fn, { setState, state, if fFlagAXAvatarFoldersEnabled then v5 else nil })

	local v9, v10 = React.useMemo(function()
		return props.isTextValid(state)
	end, { state, props.isTextValid })

	local v11 = React.useCallback(function()
		props.onConfirm(state)
	end, { props.onConfirm, state })

	local v12 = React.useMemo(function()
		return {
			{
				text = props.cancelButtonText,
				variant = buttonVariant.Standard,
				onActivated = props.onClose
			},
			{
				text = props.confirmButtonText,
				variant = buttonVariant.Emphasis,
				isDisabled = not v9 or nil,
				onActivated = v11
			}
		}
	end, { props.cancelButtonText, props.onClose, props.confirmButtonText, v9, v11 })

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
							OutfitNameInput = React.createElement(textInput, {
								text = state,
								label = "",
								width = UDim.new(1, 0),
								onChanged = v8,
								ref = ref
							})
						}
					),
					DialogActions = React.createElement(dialog.Actions, {
						LayoutOrder = 3,
						actions = v12
					})
				}
			)
		})
	})
end

return (module2(BaseDialogWithTextbox))
